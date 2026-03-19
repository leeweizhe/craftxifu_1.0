using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebAssignment
{
    public partial class ContactUs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            object userId = Session["userId"];

            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            string attachmentPath = null;
            string youtubeLink = txtYoutubeLink.Text.Trim();

            try
            {
                if (fuAttachment.HasFile)
                {
                    string fileName = "Ticket_" + DateTime.Now.Ticks + "_" + System.IO.Path.GetFileName(fuAttachment.FileName);
                    string savePath = Server.MapPath("~/Wong Zhang Zhe/uploads/") + fileName;

                    string folderPath = Server.MapPath("~/Wong Zhang Zhe/uploads/");
                    if (!System.IO.Directory.Exists(folderPath)) System.IO.Directory.CreateDirectory(folderPath);

                    fuAttachment.SaveAs(savePath);
                    attachmentPath = "/Wong Zhang Zhe/uploads/" + fileName;
                }

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // Insert a feedback record. If guest submissions are allowed, the UserId field in the database should be allowed to be NULL.
                    string sql = @"INSERT INTO contactTable (UserId, Subject, Message, Status, AttachmentPath, YoutubeLink) 
                           VALUES (@uid, @sub, @msg, @status, @apath, @ylink)";
                    SqlCommand cmd = new SqlCommand(sql, conn);

                    // If userId is null, then store DBNull.Value in the database
                    cmd.Parameters.AddWithValue("@uid", userId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@sub", ddlSubject.SelectedValue);
                    cmd.Parameters.AddWithValue("@msg", txtMessage.Text.Trim());
                    cmd.Parameters.AddWithValue("@status", "Submitted");
                    cmd.Parameters.AddWithValue("@apath", (object)attachmentPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ylink", string.IsNullOrEmpty(youtubeLink) ? DBNull.Value : (object)youtubeLink);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                // UI state switching
                lblStatus.Text = "TICKET CREATED SUCCESSFULLY!";
                lblStatus.ForeColor = System.Drawing.Color.LimeGreen;

                if (formPanel != null) formPanel.Visible = false;
                if (successPanel != null) successPanel.Visible = true;
            }
            catch (Exception ex)
            {
                lblStatus.Text = "ERROR: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Wong Zhang Zhe/Home.aspx");
        }
    }
}