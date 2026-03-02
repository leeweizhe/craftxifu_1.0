using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class SupportChat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTicketSidebar();
            }
        }

        // ADD THIS METHOD TO FIX THE COMPILATION ERROR
        protected void btnSend_Click(object sender, EventArgs e)
        {
            string replyText = txtReply.Text.Trim();

            // Check if there is text and a ticket is actually selected in the Session
            if (!string.IsNullOrEmpty(replyText) && Session["SelectedTicketId"] != null)
            {
                string ticketId = Session["SelectedTicketId"].ToString();
                string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // Update the AdminMessage, set Status to 'Completed', and record the current time
                    string query = "UPDATE contactTable SET AdminMessage = @AdminMsg, Status = 'Completed', AdminDate = GETDATE() WHERE Id = @Id";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AdminMsg", replyText);
                    cmd.Parameters.AddWithValue("@Id", ticketId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // 1. Clear the input box
                txtReply.Text = "";

                // 2. Refresh the Chat Area. 
                // Because RefreshChat now contains the "hasReplied" lock logic, 
                // it will automatically disable the TextBox and Button now.
                RefreshChat(ticketId);

                // 3. Refresh the Sidebar so the list shows any updated info
                LoadTicketSidebar();
            }
        }

        private void LoadTicketSidebar()
        {
            string selectedStatus = ddlStatusFilter.SelectedValue;
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Added the WHERE clause to filter by the selected status
                string query = @"SELECT c.Id, c.Subject, c.Message, c.Date, u.Username 
                         FROM contactTable c 
                         JOIN userTable u ON c.Userid = u.UserId 
                         WHERE c.Status = @Status
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

        // Add this to your Repeater tag in HTML: OnItemCommand="rptTicketList_ItemCommand"
        protected void rptTicketList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                // 1. Get the Ticket ID from the clicked button
                string ticketId = e.CommandArgument.ToString();

                // 2. Save ID to Session so the Send button knows which ticket to reply to
                Session["SelectedTicketId"] = ticketId;

                // 3. Call your helper method which contains the "Bulletproof" date logic
                // This replaces all the old SQL code that was causing the crash
                RefreshChat(ticketId);
            }
        }

        private void RefreshChat(string ticketId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
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
                    imgActiveUser.ImageUrl = ResolveUrl("~/" + dr["ProfilePicture"].ToString());

                    // 1. Safe format for User's message time
                    if (dr["Date"] != DBNull.Value)
                    {
                        litUserTime.Text = Convert.ToDateTime(dr["Date"]).ToString("hh:mm tt");
                    }

                    // 2. Handle Admin Reply and Lock Logic
                    string adminReply = dr["AdminMessage"] != DBNull.Value ? dr["AdminMessage"].ToString() : string.Empty;
                    bool hasReplied = !string.IsNullOrEmpty(adminReply);

                    if (hasReplied)
                    {
                        pnlAdminReply.Visible = true;
                        litAdminMessage.Text = adminReply;

                        // CHANGE THIS: Only show the message in the textbox if you want it there for editing.
                        // To show the placeholder instead, we keep the textbox EMPTY while locked.
                        txtReply.Text = "";

                        DateTime tempAdminDate;
                        if (dr["AdminDate"] != DBNull.Value && DateTime.TryParse(dr["AdminDate"].ToString(), out tempAdminDate))
                        {
                            litAdminTime.Text = "ADMIN • " + tempAdminDate.ToString("hh:mm tt");
                        }
                    }
                    else
                    {
                        pnlAdminReply.Visible = false;
                        txtReply.Text = "";
                    }

                    // 3. Lock/Unlock the Input Controls and the new Unlock Area
                    txtReply.Enabled = !hasReplied;
                    btnSend.Enabled = !hasReplied;

                    // This is the line you asked about—keep it to show/hide the black bar
                    pnlUnlockArea.Visible = hasReplied;

                    // 4. Update placeholder for visual feedback
                    if (hasReplied)
                    {
                        txtReply.Attributes["placeholder"] = "Ticket Completed - Chat Locked";
                    }
                    else
                    {
                        txtReply.Attributes["placeholder"] = "Type your reply here...";
                    }
                }
            }
        }

        protected void btnUnlock_Click(object sender, EventArgs e)
        {
            // Re-enable the textbox and send button
            txtReply.Enabled = true;
            btnSend.Enabled = true;

            // Hide the unlock notice until the next time they save
            pnlUnlockArea.Visible = false;

            // Optional: Focus the textbox so the admin can start typing immediately
            txtReply.Focus();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Reloads the sidebar when you switch between Submitted/Completed
            LoadTicketSidebar();
        }
    }
}