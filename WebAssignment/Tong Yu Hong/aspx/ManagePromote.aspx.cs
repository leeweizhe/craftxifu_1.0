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

        private void LoadTicketSidebar()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT c.Id, u.Username, c.Message 
                                 FROM contactTable c 
                                 JOIN userTable u ON c.Userid = u.UserId 
                                 WHERE c.Subject = 'Upgrade' AND c.Status = @Status 
                                 ORDER BY c.Date DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Status", ddlStatusFilter.SelectedValue);
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

        private void RefreshChat(string ticketId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT c.Message, c.Date, c.AdminMessage, c.AdminDate, c.AttachmentPath, c.YoutubeLink, u.Username, u.ProfilePicture 
                         FROM contactTable c 
                         JOIN userTable u ON c.Userid = u.UserId 
                         WHERE c.Id = @Id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", ticketId);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // Ensure the image control is visible when loading a ticket
                    imgActiveUser.Visible = true;
                    litActiveSubject.Text = dr["Username"].ToString();
                    litOriginalMessage.Text = dr["Message"].ToString();
                    litUserTime.Text = Convert.ToDateTime(dr["Date"]).ToString("hh:mm tt");

                    // 1. Improved Profile Picture Handling
                    string rawPicPath = dr["ProfilePicture"] != DBNull.Value ? dr["ProfilePicture"].ToString().Trim() : "";

                    if (string.IsNullOrEmpty(rawPicPath))
                    {
                        // Fallback if no path exists in DB
                        imgActiveUser.ImageUrl = ResolveUrl("~/images/default-avatar.png");
                    }
                    else
                    {
                        // Step A: Clean the path (Ensure it starts with ~/ for ResolveUrl to work correctly)
                        string cleanPath = rawPicPath;

                        // If it doesn't start with ~ but starts with /, add the ~
                        if (!cleanPath.StartsWith("~") && cleanPath.StartsWith("/"))
                        {
                            cleanPath = "~" + cleanPath;
                        }
                        // If it's a relative path like "images/...", add ~/
                        else if (!cleanPath.StartsWith("~") && !cleanPath.StartsWith("/"))
                        {
                            cleanPath = "~/" + cleanPath;
                        }

                        // Step B: Resolve the URL properly
                        // This will handle both ~/images/avatars/... and ~/Images/profiles/... correctly
                        imgActiveUser.ImageUrl = ResolveUrl(cleanPath);
                    }

                    // 2. Handle Attachments
                    string attach = dr["AttachmentPath"] != DBNull.Value ? dr["AttachmentPath"].ToString() : "";
                    string yt = dr["YoutubeLink"] != DBNull.Value ? dr["YoutubeLink"].ToString() : "";

                    pnlAttachments.Visible = (!string.IsNullOrEmpty(attach) || !string.IsNullOrEmpty(yt));

                    lnkAttachment.Visible = !string.IsNullOrEmpty(attach);
                    if (lnkAttachment.Visible) lnkAttachment.NavigateUrl = ResolveUrl("~/" + attach.Replace("~/", ""));

                    lnkYoutube.Visible = !string.IsNullOrEmpty(yt);
                    if (lnkYoutube.Visible) lnkYoutube.NavigateUrl = yt;

                    // 3. Handle Admin Reply Status
                    bool hasReplied = dr["AdminMessage"] != DBNull.Value && !string.IsNullOrEmpty(dr["AdminMessage"].ToString());
                    pnlAdminReply.Visible = hasReplied;
                    if (hasReplied)
                    {
                        litAdminMessage.Text = dr["AdminMessage"].ToString();
                        litAdminTime.Text = "ADMIN • " + Convert.ToDateTime(dr["AdminDate"]).ToString("hh:mm tt");
                    }

                    // 4. Lock Controls if handled
                    txtReply.Enabled = !hasReplied;
                    btnApprove.Enabled = !hasReplied;
                    btnReject.Enabled = !hasReplied;
                    pnlUnlockArea.Visible = hasReplied;
                }
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e) 
        { 
            HandleRequest("Promoted to Instructor.", "Instructor"); 
        }

        protected void btnReject_Click(object sender, EventArgs e) 
        { 
            HandleRequest("Request Rejected.", null); 
        }

        private void HandleRequest(string defaultNote, string newRole)
        {
            if (Session["SelectedTicketId"] == null) return;
            string ticketId = Session["SelectedTicketId"].ToString();
            string note = !string.IsNullOrEmpty(txtReply.Text) ? txtReply.Text : defaultNote;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // Update Ticket
                    string sqlT = "UPDATE contactTable SET AdminMessage = @M, Status = 'Completed', AdminDate = GETDATE() WHERE Id = @Id";
                    SqlCommand cmdT = new SqlCommand(sqlT, conn, trans);
                    cmdT.Parameters.AddWithValue("@M", note);
                    cmdT.Parameters.AddWithValue("@Id", ticketId);
                    cmdT.ExecuteNonQuery();

                    // Update Role (If Approved)
                    if (newRole != null)
                    {
                        string sqlU = "UPDATE userTable SET Role = @R WHERE UserId = (SELECT UserId FROM contactTable WHERE Id = @Id)";
                        SqlCommand cmdU = new SqlCommand(sqlU, conn, trans);
                        cmdU.Parameters.AddWithValue("@R", newRole);
                        cmdU.Parameters.AddWithValue("@Id", ticketId);
                        cmdU.ExecuteNonQuery();
                    }
                    trans.Commit();
                }
                catch { trans.Rollback(); }
            }
            txtReply.Text = "";
            RefreshChat(ticketId);
            LoadTicketSidebar();
        }

        protected void btnUnlock_Click(object sender, EventArgs e)
        {
            txtReply.Enabled = btnApprove.Enabled = btnReject.Enabled = true;
            pnlUnlockArea.Visible = false;
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e) { LoadTicketSidebar(); }
    }
}
