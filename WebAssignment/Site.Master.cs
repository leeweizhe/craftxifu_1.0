using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient; // 必须导入
using System.Configuration;   // 必须导入

namespace WebAssignment
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 每次页面加载都检查，确保状态实时更新
            CheckLoginStatus();
        }

        private void CheckLoginStatus()
        {
            if (Session["userId"] != null)
            {
                phVisitor.Visible = false;
                phMember.Visible = true;

                // 【核心修复】如果 Session 里的详细资料丢了，直接从数据库抓取最新的
                int userId = Convert.ToInt32(Session["userId"]);
                LoadUserDataFromDb(userId);
            }
            else
            {
                phVisitor.Visible = true;
                phMember.Visible = false;
            }
        }

        private void LoadUserDataFromDb(int userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 从 userTable 获取该用户的实时数据
                string sql = "SELECT Username, ProfilePicture FROM userTable WHERE UserId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", userId);

                try
                {
                    string framePath = Session["avatarFrame"].ToString();
                    imgFrame.ImageUrl = framePath;
                    imgFrame.Visible = true; 
                }
                else
                {
                    imgFrame.Visible = false;
                }
                // make Minigame nav link interactive for logged-in users
                // find the minigame anchor by its href and ensure it points to the page
                // (Site.Master uses static markup so no server-side anchor control is present)
            }
            else
            {
                // No session means they are a visitor
                phVisitor.Visible = true;
                phMember.Visible = false;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            // 跨文件夹重定向至邻居的登录页
            Response.Redirect("~/Lee Wei Zhe/aspx/Login.aspx");
        }
    }
}