using System;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace WebAssignment
{
    public partial class AddAutoFarm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["userId"] == null || Session["userRole"]?.ToString().Trim() != "Instructor")
            {
                // if not Instructor then redirect to list page
                Response.Redirect("AutoFarm.aspx");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string thumbPath = SaveFile(fuThumbnail, "thumb_");
                string detailPath = SaveFile(fuDetailImg, "detail_");

                string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string sql = @"INSERT INTO farmTable (Title, Category, Description, Thumbnail, DetailImage, VideoUrl, FullContent, Efficiency) 
                                   VALUES (@title, @cat, @desc, @thumb, @detail, @vid, @content, @eff)";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@title", txtTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@cat", ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@desc", txtDesc.Text.Trim());
                    cmd.Parameters.AddWithValue("@thumb", thumbPath);
                    cmd.Parameters.AddWithValue("@detail", detailPath);
                    cmd.Parameters.AddWithValue("@vid", txtVideoUrl.Text.Trim());
                    cmd.Parameters.AddWithValue("@content", txtFullContent.Text.Trim());
                    cmd.Parameters.AddWithValue("@eff", txtEfficiency.Text.Trim());

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                lblMsg.Text = "SUCCESS: FARM DESIGN PUBLISHED!";
                lblMsg.ForeColor = System.Drawing.Color.LimeGreen;
                // jump back to list after 3 seconds
                Response.AppendHeader("Refresh", "2;url=AutoFarm.aspx");
            }
            catch (Exception ex)
            {
                lblMsg.Text = "ERROR: " + ex.Message;
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
        }

        private string SaveFile(System.Web.UI.WebControls.FileUpload fileUpload, string prefix)
        {
            if (fileUpload.HasFile)
            {
                string fileName = prefix + Guid.NewGuid().ToString().Substring(0, 8) + Path.GetExtension(fileUpload.FileName);
                
                string folderPath = Server.MapPath("~/Wong Zhang Zhe/pic/");

                if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                fileUpload.SaveAs(Path.Combine(folderPath, fileName));
                return "/Wong Zhang Zhe/pic/" + fileName; 
            }
            return "";
        }
    }
}