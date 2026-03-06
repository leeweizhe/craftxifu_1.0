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
            string mobId = Request.QueryString["MobID"];

            if (!string.IsNullOrEmpty(mobId))
            {
                // Always load details so view mode works
                LoadMobDetails(mobId);

                if (!IsPostBack)
                {
                    LoadComments(mobId);
                    CheckCommentPermission();

                    // Check if the user is logged in and has the role "Instructor"
                    // Note: This must match exactly what you store in Session during login
                    string userRole = Session["UserRole"] as string;

                    if (!string.IsNullOrEmpty(userRole) && userRole == "Instructor")
                    {
                        btnEdit.Visible = true;
                    }
                    else
                    {
                        btnEdit.Visible = false;
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string mobId = Request.QueryString["MobID"];

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"UPDATE mobTable SET 
                        MobName = @Name, 
                        Description = @Desc, 
                        FullContent = @Content,
                        Health = @Health,
                        Category = @Cat,
                        SpawnCondition = @Spawn,
                        ItemDrops = @Drops,
                        HowToDefeat = @Guide
                        WHERE MobID = @ID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Name", txtEditName.Text);
                cmd.Parameters.AddWithValue("@Desc", txtEditDesc.Text);
                cmd.Parameters.AddWithValue("@Content", txtEditFullContent.Text);
                cmd.Parameters.AddWithValue("@Health", txtEditHealth.Text);
                cmd.Parameters.AddWithValue("@Cat", ddlEditCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Spawn", txtEditSpawn.Text);
                cmd.Parameters.AddWithValue("@Drops", txtEditDrops.Text);

                // Logic to pick which guide textbox to save
                string finalGuide = (ddlEditCategory.SelectedValue == "Passive") ? txtEditPassiveGuide.Text : txtEditHowToDefeat.Text;
                cmd.Parameters.AddWithValue("@Guide", finalGuide);

                cmd.Parameters.AddWithValue("@ID", mobId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("MobDetail.aspx?MobID=" + mobId);
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
            if (string.IsNullOrEmpty(mobId))
            {
                return;
            }
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
            string mobId = Request.QueryString["MobID"];
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
                string query = "SELECT MobName, Category, Description, FullContent, MobPicture, Health, SpawnCondition, ItemDrops, HowToDefeat FROM mobTable WHERE MobID = @ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", id);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // --- 1. DATA EXTRACTION ---
                    string name = reader["MobName"].ToString();
                    string desc = reader["Description"].ToString();
                    string fullContent = reader["FullContent"].ToString();
                    string category = reader["Category"].ToString();
                    string rawHealth = reader["Health"].ToString();
                    string spawn = reader["SpawnCondition"].ToString();
                    string drops = reader["ItemDrops"].ToString();
                    string guideData = reader["HowToDefeat"].ToString();
                    string picturePath = reader["MobPicture"].ToString();

                    // --- 2. POPULATE VIEW MODE (Labels/Literals) ---
                    lblMobName.Text = name;
                    lblDescription.Text = desc;
                    litFullContent.Text = fullContent;
                    lblCategory.Text = category;
                    lblHealth.Text = rawHealth;
                    lblSpawn.Text = spawn;
                    lblDrops.Text = drops;
                    imgMob.ImageUrl = ResolveUrl(picturePath);

                    // Heart Calculation logic
                    if (double.TryParse(rawHealth, out double hpValue))
                    {
                        double heartCount = hpValue / 2;
                        litHeartMultiplier.Text = "x " + heartCount.ToString();
                    }

                    // --- 3. POPULATE EDIT MODE (TextBoxes/DropDown) ---
                    txtEditName.Text = name;
                    txtEditDesc.Text = desc;
                    txtEditFullContent.Text = fullContent;
                    txtEditHealth.Text = rawHealth;
                    txtEditSpawn.Text = spawn;
                    txtEditDrops.Text = drops;

                    // Set the Category DropDown
                    if (ddlEditCategory.Items.FindByValue(category) != null)
                    {
                        ddlEditCategory.SelectedValue = category;
                    }

                    // Fill both guide textboxes so they are ready regardless of toggle
                    txtEditHowToDefeat.Text = guideData;
                    txtEditPassiveGuide.Text = guideData;

                    // --- 4. PANEL VISIBILITY LOGIC ---
                    if (category == "Passive")
                    {
                        pnlCombatGuide.Visible = false;
                        pnlPassiveGuide.Visible = true;
                        litPassiveGuide.Text = guideData;
                    }
                    else
                    {
                        pnlCombatGuide.Visible = true;
                        pnlPassiveGuide.Visible = false;
                        litHowToDefeat.Text = guideData;
                    }
                }
            }
        }

        protected void lnkReport_Command(object sender, CommandEventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Split the combined argument (CommentId|MobID)
            string[] args = e.CommandArgument.ToString().Split('|');

            if (args.Length < 2) return; // Safety check

            string commentId = args[0];
            string mobId = args[1]; // Changed from farmId to mobId
            string reporterId = Session["userId"].ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // Updated SQL to use MobID instead of FarmID
                    // Note: Ensure your database table has the MobID column!
                    string sql = "INSERT INTO reportTable (CommentId, ReporterId, MobID) VALUES (@cid, @rid, @mid)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@cid", commentId);
                    cmd.Parameters.AddWithValue("@rid", reporterId);
                    cmd.Parameters.AddWithValue("@mid", mobId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Report submitted successfully.');", true);
            }
            catch (Exception ex)
            {
                // Helpful tip: If this fails, check if the MobID column actually exists in your reportTable
            }
        }
    }
}