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
    public partial class MobDetail : System.Web.UI.Page
    {
        private string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Get the ID from the URL (e.g., MobDetail.aspx?ID=5)
            string mobId = Request.QueryString["ID"];

            if (!string.IsNullOrEmpty(mobId))
            {
                LoadMobDetails(mobId);
            }

            if (!IsPostBack)
            {
                LoadComments(mobId);
                CheckCommentPermission();
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
                litVisitorMsg.Text = "<p style='color: #fbbf24; text-align: center;'>[ <a href='/Lee Wei Zhe/aspx/Login.aspx' style='color: #68ff00;'>Login</a> to join the discussion ]</p>";
            }
        }
        private void LoadComments(string mobId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 使用 JOIN 获取用户名
                string sql = @"SELECT c.*, u.Username FROM mobComment c 
                               JOIN userTable u ON c.UserId = u.UserId 
                               WHERE c.mobId = @mid ORDER BY c.CommentDate DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@mid", mobId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptComments.DataSource = dt;
                rptComments.DataBind();
            }
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            string mobId = Request.QueryString["id"];
            string commentText = txtComment.Text.Trim();

            if (!string.IsNullOrEmpty(commentText) && Session["userId"] != null)
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string sql = "INSERT INTO mobComment (MobId, UserId, CommentText) VALUES (@mid, @uid, @text)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@mid", mobId);
                    cmd.Parameters.AddWithValue("@uid", Session["userId"]);
                    cmd.Parameters.AddWithValue("@text", commentText);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
                txtComment.Text = ""; // 清空输入框
                LoadComments(mobId); // 刷新评论列表
            }
        }

        private void LoadMobDetails(string id)
        {
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