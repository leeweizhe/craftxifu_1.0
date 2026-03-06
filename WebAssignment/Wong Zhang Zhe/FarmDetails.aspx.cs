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
    public partial class FarmDetails : System.Web.UI.Page
    {
        private string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                string farmId = Request.QueryString["id"];

                // Check logic: If farmId is not empty, load the data.
                if (!string.IsNullOrEmpty(farmId))
                {
                    LoadFarmDetails(farmId);
                    LoadComments(farmId);
                    CheckCommentPermission();
                }
                else
                {
                    Response.Redirect("AutoFarm.aspx");
                }
            }
        }

        private void CheckCommentPermission()
        {
            if (Session["userId"] != null)
            {
                pnlAddComment.Visible = true;
                litVisitorMsg.Text = "";
            }
            else
            {
                pnlAddComment.Visible = false;
                litVisitorMsg.Text = "<p style='color: #fbbf24; text-align: center;'>[ <a href='Login.aspx' style='color: #68ff00;'>Login</a> to join the discussion ]</p>";
            }
        }
        private void LoadComments(string farmId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = @"SELECT c.*, u.Username FROM commentTable c 
                               JOIN userTable u ON c.UserId = u.UserId 
                               WHERE c.FarmId = @fid 
                               AND c.Status = 'Visible'
                               ORDER BY c.CommentDate DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@fid", farmId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptComments.DataSource = dt;
                rptComments.DataBind();
            }
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            string farmId = Request.QueryString["id"];
            string commentText = txtComment.Text.Trim();

            if (!string.IsNullOrEmpty(commentText) && Session["userId"] != null)
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string sql = "INSERT INTO commentTable (FarmId, UserId, CommentText) VALUES (@fid, @uid, @text)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@fid", farmId);
                    cmd.Parameters.AddWithValue("@uid", Session["userId"]);
                    cmd.Parameters.AddWithValue("@text", commentText);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
                txtComment.Text = "";
                LoadComments(farmId);
            }
        }

        private void LoadFarmDetails(string id)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT * FROM farmTable WHERE FarmId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Binding basic text information
                    lblTitle.Text = reader["Title"].ToString();
                    lblDesc.Text = reader["Description"].ToString();
                    lblEfficiency.Text = reader["Efficiency"].ToString();
                    litContent.Text = reader["FullContent"].ToString();

                    // Binding details page large image
                    imgFarmDisplay.ImageUrl = reader["DetailImage"].ToString();

                    // Image of the binding materials list
                    string matImg = reader["MaterialImage"].ToString();
                    if (!string.IsNullOrEmpty(matImg))
                    {
                        imgMaterial.ImageUrl = matImg;
                        materialPanel.Visible = true;
                    }

                    // Handle video URL
                    string videoUrl = reader["VideoUrl"].ToString();
                    if (!string.IsNullOrEmpty(videoUrl))
                    {
                        string finalEmbedUrl = "";
                        if (videoUrl.Contains("watch?v="))
                        {
                            finalEmbedUrl = videoUrl.Replace("watch?v=", "embed/");
                        }
                        else if (videoUrl.Contains("youtu.be/"))
                        {
                            finalEmbedUrl = videoUrl.Replace("youtu.be/", "www.youtube.com/embed/");
                        }
                        videoFrame.Src = finalEmbedUrl;
                        videoPanel.Visible = true;
                    }
                }
                conn.Close();
            }
        }

        protected void lnkReport_Command(object sender, CommandEventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Split the combined argument (CommentId|FarmID)
            string[] args = e.CommandArgument.ToString().Split('|');

            if (args.Length < 2) return; // Safety check

            string commentId = args[0];
            string farmId = args[1];
            string reporterId = Session["userId"].ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // Make sure your table has a FarmID column!
                    string sql = "INSERT INTO reportTable (CommentId, ReporterId, FarmID) VALUES (@cid, @rid, @fid)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cid", commentId);
                    cmd.Parameters.AddWithValue("@rid", reporterId);
                    cmd.Parameters.AddWithValue("@fid", farmId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Report submitted successfully.');", true);
            }
            catch (Exception ex)
            {
                // Optional: Log error
            }
        }
    }
}