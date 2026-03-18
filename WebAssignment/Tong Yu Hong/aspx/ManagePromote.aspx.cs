using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class ManagePromote : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentRole = Session["UserRole"] as string;
            if (string.IsNullOrEmpty(currentRole) || currentRole != "Admin")
            {
                Response.Redirect("~/Wong Zhang Zhe/Home.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadTicketSidebar();
            }
        }

        // --- SIDEBAR: Filter by Subject "Upgrade" ---
        private void LoadTicketSidebar()
        {
            string selectedStatus = ddlStatusFilter.SelectedValue;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // We join contactTable and userTable, filtering by Subject = 'Upgrade'
                string query = @"SELECT c.Id, u.Username, c.Message 
                                 FROM contactTable c 
                                 JOIN userTable u ON c.Userid = u.UserId 
                                 WHERE c.Subject = 'Upgrade' AND c.Status = @Status 
                                 ORDER BY c.Date DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Status", selectedStatus);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptTicketList.DataSource = dt;
                rptTicketList.DataBind();
            }
        }

        protected void rptTicketList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                string ticketId = e.CommandArgument.ToString();
                Session["SelectedTicketId"] = ticketId;
                RefreshChat(ticketId);
            }
        }

        // --- APPROVE BUTTON: Promotes User + Completes Ticket ---
        protected void btnApprove_Click(object sender, EventArgs e)
        {
            HandleRequest("Approved. User has been promoted to Instructor.", "Instructor");
        }

        // --- REJECT BUTTON: Completes Ticket ONLY ---
        protected void btnReject_Click(object sender, EventArgs e)
        {
            HandleRequest("Rejected. Promotion request does not meet requirements.", null);
        }

        private void HandleRequest(string adminNote, string newRole)
        {
            if (Session["SelectedTicketId"] == null) return;
            string ticketId = Session["SelectedTicketId"].ToString();
            string modNote = !string.IsNullOrEmpty(txtReply.Text) ? txtReply.Text : adminNote;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // 1. Update the Ticket status
                    string updateTicket = "UPDATE contactTable SET AdminMessage = @Msg, Status = 'Completed', AdminDate = GETDATE() WHERE Id = @Id";
                    SqlCommand cmdTicket = new SqlCommand(updateTicket, conn, trans);
                    cmdTicket.Parameters.AddWithValue("@Msg", modNote);
                    cmdTicket.Parameters.AddWithValue("@Id", ticketId);
                    cmdTicket.Parameters.AddWithValue("@AdminDate", DateTime.Now);
                    cmdTicket.ExecuteNonQuery();

                    // 2. If it was an Approval, update the userTable rank
                    if (!string.IsNullOrEmpty(newRole))
                    {
                        string updateUser = "UPDATE userTable SET Role = @Role WHERE UserId = (SELECT Userid FROM contactTable WHERE Id = @Id)";
                        SqlCommand cmdUser = new SqlCommand(updateUser, conn, trans);
                        cmdUser.Parameters.AddWithValue("@Role", newRole);
                        cmdUser.Parameters.AddWithValue("@Id", ticketId);
                        cmdUser.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
                catch { trans.Rollback(); }
            }

            txtReply.Text = "";
            RefreshChat(ticketId);
            LoadTicketSidebar();
        }

        private void RefreshChat(string ticketId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT c.Message, c.Date, c.AdminMessage, c.AdminDate, u.Username, u.ProfilePicture 
                                 FROM contactTable c 
                                 JOIN userTable u ON c.Userid = u.UserId 
                                 WHERE c.Id = @Id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", ticketId);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    litActiveSubject.Text = dr["Username"].ToString();
                    litOriginalMessage.Text = dr["Message"].ToString();
                    litUserTime.Text = Convert.ToDateTime(dr["Date"]).ToString("hh:mm tt");

                    // --- YOUR ORIGINAL IMAGE FIX ---
                    string rawPicPath = dr["ProfilePicture"] != DBNull.Value ? dr["ProfilePicture"].ToString() : "";
                    if (string.IsNullOrEmpty(rawPicPath)) imgActiveUser.ImageUrl = ResolveUrl("~/images/default-avatar.png");
                    else if (rawPicPath.ToLower().StartsWith("images/") || rawPicPath.ToLower().StartsWith("~/images/")) imgActiveUser.ImageUrl = ResolveUrl("~/" + rawPicPath.Replace("~/", ""));
                    else imgActiveUser.ImageUrl = ResolveUrl("~/images/" + rawPicPath);

                    // Handle Locking
                    bool hasReplied = dr["AdminMessage"] != DBNull.Value && !string.IsNullOrEmpty(dr["AdminMessage"].ToString());
                    if (hasReplied)
                    {
                        pnlAdminReply.Visible = true;
                        litAdminMessage.Text = dr["AdminMessage"].ToString();
                        litAdminTime.Text = "ADMIN • " + Convert.ToDateTime(dr["AdminDate"]).ToString("hh:mm tt");
                    }
                    else { pnlAdminReply.Visible = false; }

                    txtReply.Enabled = !hasReplied;
                    btnApprove.Enabled = !hasReplied;
                    btnReject.Enabled = !hasReplied;
                    pnlUnlockArea.Visible = hasReplied;
                }
            }
        }

        protected void btnUnlock_Click(object sender, EventArgs e)
        {
            txtReply.Enabled = true;
            btnApprove.Enabled = true;
            btnReject.Enabled = true;
            pnlUnlockArea.Visible = false;
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTicketSidebar();
        }
    }
}
