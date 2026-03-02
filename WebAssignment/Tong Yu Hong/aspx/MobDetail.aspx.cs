using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class MobDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Get the ID from the URL (e.g., MobDetail.aspx?ID=5)
            string mobId = Request.QueryString["ID"];

            if (!string.IsNullOrEmpty(mobId))
            {
                LoadMobDetails(mobId);
            }
        }

        private void LoadMobDetails(string id)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 1. Added 'HowToDefeat' to the SELECT query
                string query = "SELECT MobName, Category, Description, FullContent, MobPicture, Health, SpawnCondition, ItemDrops, HowToDefeat FROM mobTable WHERE MobID = @ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", id);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // 2. Map standard content
                    lblMobName.Text = reader["MobName"].ToString();
                    lblDescription.Text = reader["Description"].ToString();

                    // Store category in a variable for logic check
                    string category = reader["Category"].ToString();
                    lblCategory.Text = category;

                    litFullContent.Text = reader["FullContent"].ToString();

                    // 3. Map picture content
                    string picturePath = reader["MobPicture"].ToString();
                    imgMob.ImageUrl = ResolveUrl(picturePath);

                    // 4. Map the new sectioned content
                    string rawHealth = reader["Health"].ToString();
                    lblHealth.Text = rawHealth;

                    // 5. Dynamic Heart Calculation
                    if (double.TryParse(rawHealth, out double hpValue))
                    {
                        double heartCount = hpValue / 2;
                        litHeartMultiplier.Text = "x " + heartCount.ToString();
                    }

                    lblSpawn.Text = reader["SpawnCondition"].ToString();
                    lblDrops.Text = reader["ItemDrops"].ToString();

                    // 6. Map the Combat Guide data to the literal (With Category Logic)
                    string guideData = reader["HowToDefeat"].ToString();

                    if (category == "Passive")
                    {
                        // Hide Combat, Show Utility for Passive mobs
                        pnlCombatGuide.Visible = false;
                        pnlPassiveGuide.Visible = true;
                        litPassiveGuide.Text = guideData;
                    }
                    else
                    {
                        // Show Combat for Hostile/Neutral mobs
                        pnlCombatGuide.Visible = true;
                        pnlPassiveGuide.Visible = false;
                        litHowToDefeat.Text = guideData;
                    }
                }
            }
        }
    }
}