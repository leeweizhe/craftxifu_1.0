using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class AddMob : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["connectionstring"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Check if user is Admin before allowing access
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string folderPath = Server.MapPath("~/Uploads/Mobs/");
            string fileName = "default_mob.png"; // Fallback image

            // Handle Image Upload
            if (fuMobPicture.HasFile)
            {
                if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                fileName = Path.GetFileName(fuMobPicture.FileName);
                fuMobPicture.SaveAs(folderPath + fileName);
                fileName = "~/Uploads/Mobs/" + fileName; // Path to save in DB
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"INSERT INTO mobTable (MobName, Category, Description, FullContent, MobPicture, Health, SpawnCondition, ItemDrops, HowToDefeat) 
                                   VALUES (@name, @cat, @desc, @full, @pic, @health, @spawn, @drops, @defeat)";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@name", txtMobName.Text.Trim());
                    cmd.Parameters.AddWithValue("@cat", ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@desc", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@full", txtFullContent.Text.Trim());
                    cmd.Parameters.AddWithValue("@pic", fileName);
                    cmd.Parameters.AddWithValue("@health", txtHealth.Text.Trim());
                    cmd.Parameters.AddWithValue("@spawn", txtSpawn.Text.Trim());
                    cmd.Parameters.AddWithValue("@drops", txtDrops.Text.Trim());
                    cmd.Parameters.AddWithValue("@defeat", txtHowToDefeat.Text.Trim());

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMsg.ForeColor = System.Drawing.Color.LimeGreen;
                    lblMsg.Text = "SUCCESS: Mob added to the Encyclopedia!";

                    // Optional: Redirect after success
                    // Response.Redirect("Mob.aspx");
                }
            }
            catch (Exception ex)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "ERROR: " + ex.Message;
            }
        }
    }
}