using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace WebAssignment
{
    public partial class Guide : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                if (panelLockPotion != null) panelLockPotion.Visible = true;
                if (panelLockAutoFarm != null) panelLockAutoFarm.Visible = true;
            }
            else
            {
                if (panelLockPotion != null) panelLockPotion.Visible = false;
                if (panelLockAutoFarm != null) panelLockAutoFarm.Visible = false;
            }
        }

        protected void Guide_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string guideName = btn.CommandArgument;

            // Security check: Prevent visitors from bypassing the UI to click and lock content.
            if (Session["userId"] == null && (guideName == "Potion" || guideName == "AutoFarm" || guideName == "Enchantment"))
            {
                Response.Redirect("/Lee Wei Zhe/aspx/Login.aspx");
                return;
            }

            string targetUrl = "";
            switch (guideName)
            {
                case "AutoFarm": targetUrl = "/Wong Zhang Zhe/AutoFarm.aspx"; break;
                case "Beginner": targetUrl = "/Lee Wei Zhe/aspx/BeginnerGuide.aspx"; break;
                case "Mob": targetUrl = "/Tong Yu Hong/aspx/Mob.aspx"; break;
                case "Potion": targetUrl = "/Brayden/Potion.aspx"; break;
                case "Enchantment": targetUrl = "/Brayden/Enchantment.aspx"; break;
            }

            // Database click counting logic
            UpdateClickStats(guideName);

            if (!string.IsNullOrEmpty(targetUrl))
            {
                Response.Redirect(targetUrl);
            }
        }

        private void UpdateClickStats(string guideName)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                try
                {
                    // Try to increment existing counter
                    string sql = "UPDATE guideStatsTable SET ClickCount = ClickCount + 1 WHERE GuideName = @name";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@name", guideName);
                    int rows = cmd.ExecuteNonQuery();

                    // If no row updated, insert initial row
                    if (rows == 0)
                    {
                        string ins = "INSERT INTO guideStatsTable (GuideName, ClickCount) VALUES (@name, 1)";
                        SqlCommand cmdIns = new SqlCommand(ins, conn);
                        cmdIns.Parameters.AddWithValue("@name", guideName);
                        cmdIns.ExecuteNonQuery();
                    }
                }
                catch (SqlException ex)
                {
                    // If the table doesn't exist, create it and insert the initial counter.
                    // SQL Server error number 208 = Invalid object name
                    if (ex.Number == 208 || ex.Message.Contains("Invalid object name"))
                    {
                        string createSql = @"IF OBJECT_ID('dbo.guideStatsTable','U') IS NULL
                                            BEGIN
                                                CREATE TABLE dbo.guideStatsTable (
                                                    GuideName NVARCHAR(50) NOT NULL PRIMARY KEY,
                                                    ClickCount INT NOT NULL DEFAULT(0)
                                                );
                                            END";
                        using (SqlCommand createCmd = new SqlCommand(createSql, conn))
                        {
                            createCmd.ExecuteNonQuery();
                        }

                        string ins = "INSERT INTO guideStatsTable (GuideName, ClickCount) VALUES (@name, 1)";
                        using (SqlCommand cmdIns = new SqlCommand(ins, conn))
                        {
                            cmdIns.Parameters.AddWithValue("@name", guideName);
                            cmdIns.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // rethrow unexpected SQL exceptions
                        throw;
                    }
                }
                finally
                {
                    conn.Close();
                }
            }
        }
    }
}