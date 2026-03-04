using System;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace WebAssignment
{
    public partial class Home : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] != null)
            {
                visitorSection.Visible = false;
                memberSection.Visible = true;
                memberDataCards.Visible = true;
                phMemberStatus.Visible = true;

                LoadUserStatus(Convert.ToInt32(Session["userId"]));
            }
            else
            {
                visitorSection.Visible = true;
                memberSection.Visible = false;
                memberDataCards.Visible = false;
                phMemberStatus.Visible = false;
            }
        }

        private void LoadUserStatus(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 获取用户详情、物品数以及资产总值
                string sql = @"
                    SELECT u.Username, u.Role, u.Currency, u.ProfilePicture, u.AvatarFrame,
                    (SELECT COUNT(*) FROM userInventoryTable WHERE UserId = u.UserId) as ItemCount,
                    (SELECT SUM(s.Price) FROM userInventoryTable i JOIN shopItemTable s ON i.ItemId = s.ItemId WHERE i.UserId = u.UserId) as NetWorth
                    FROM userTable u WHERE u.UserId = @id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", userId);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        // 这里 litRole 不再报错，因为它在前端已定义
                        litUsername.Text = reader["Username"].ToString().ToUpper();
                        litRole.Text = reader["Role"].ToString().ToUpper();

                        lblEmeralds.Text = reader["Currency"].ToString();
                        lblItemCount.Text = reader["ItemCount"].ToString();

                        string worth = reader["NetWorth"] != DBNull.Value ? reader["NetWorth"].ToString() : "0";
                        lblInvValue.Text = worth;

                        // 同步 Session 给 Site.Master
                        Session["username"] = reader["Username"].ToString();
                        Session["profilePic"] = reader["ProfilePicture"].ToString();
                        if (reader["AvatarFrame"] != DBNull.Value)
                            Session["avatarFrame"] = reader["AvatarFrame"].ToString();
                    }
                    conn.Close();
                }
                catch (Exception) { }
            }
        }

        protected void btnLoginRedirect_Click(object sender, EventArgs e)
        {
            Response.Redirect("../Lee Wei Zhe/aspx/Login.aspx");
        }
    }
}