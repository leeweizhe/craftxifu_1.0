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
    public partial class UserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. 统一使用小写 userId 键名适配母版页
            if (Session["userId"] == null)
            {
                Session["userId"] = 8; // 默认测试 ID
            }

            // 2. 补全母版页基础 Session，防止 NullReference 报错
            if (Session["username"] == null) Session["username"] = "Steve";
            if (Session["profilePic"] == null) Session["profilePic"] = "~/Images/profiles/DPick.jpg";

            // 3. 初始隐藏头像框（由 LoadUserData 根据数据库决定是否显示）
            Session["avatarFrame"] = null;

            if (!IsPostBack)
            {
                try
                {
                    int currentUserId = Convert.ToInt32(Session["userId"]);
                    LoadUserData(currentUserId);
                }
                catch (Exception)
                {
                    Response.Redirect("../Lee Wei Zhe/aspx/Login.aspx");
                }
            }
        }

        private void LoadUserData(int userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // SQL 查询包含所有字段
                string sql = "SELECT * FROM userTable WHERE UserId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", userId);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // 基础文本信息
                        lblFullName.Text = reader["FName"].ToString() + " " + reader["LName"].ToString();
                        lblUsername.Text = "@" + reader["Username"].ToString();
                        lblEmail.Text = reader["Email"].ToString();
                        lblRole.Text = reader["Role"].ToString();
                        lblCountry.Text = reader["Country"].ToString();
                        lblCurrency.Text = reader["Currency"].ToString();
                        lblBio.Text = (reader["Bio"] != DBNull.Value && !string.IsNullOrEmpty(reader["Bio"].ToString()))
                                      ? reader["Bio"].ToString() : "No bio available.";

                        // 个人头像
                        string profilePic = reader["ProfilePicture"].ToString();
                        imgAvatar.ImageUrl = !string.IsNullOrEmpty(profilePic) ? profilePic : "~/Images/profiles/DPick.jpg";

                        // --- 处理 NameTag (称号) ---
                        if (reader["NameTag"] != DBNull.Value && !string.IsNullOrEmpty(reader["NameTag"].ToString()))
                        {
                            lblNameTag.Text = reader["NameTag"].ToString();
                            lblNameTag.Visible = true;
                        }

                        // --- 处理 AvatarFrame (头像框) ---
                        if (reader["AvatarFrame"] != DBNull.Value && !string.IsNullOrEmpty(reader["AvatarFrame"].ToString()))
                        {
                            string frameUrl = reader["AvatarFrame"].ToString();
                            imgFrameOverlay.ImageUrl = frameUrl;
                            imgFrameOverlay.Visible = true;

                            // 同步给母版页，确保母版页的头像框也能显示（如果需要）
                            Session["avatarFrame"] = frameUrl;
                        }

                        // 同步更新母版页 Session 数据
                        Session["username"] = reader["Username"].ToString();
                        Session["profilePic"] = imgAvatar.ImageUrl;
                    }
                    conn.Close();
                }
                catch (Exception ex)
                {
                    // 数据库报错处理
                }
            }
        }

        protected void btnGoToEdit_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditProfile.aspx");
        }
    }
}