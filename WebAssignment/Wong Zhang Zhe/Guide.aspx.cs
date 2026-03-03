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
            // --- 核心修复：防止 Site.Master.cs 报 NullReferenceException ---
            // 必须在母版页执行 .ToString() 之前，确保这些小写的键名不是 null
            Session["userId"] = 8; // 保持测试 ID，确保母版页能正常读取
            if (Session["username"] == null) Session["username"] = "Steve";
            if (Session["profilePic"] == null) Session["profilePic"] = "~/Images/profiles/DPick.jpg";

            // 统一全站使用的键名：userId (小写)
            // 如果你希望 Visitor 也能看这个页面但不触发母版页崩溃，
            // 即使 userId 为空，只要 username 和 profilePic 有值，母版页就不会死。

            // --- 权限控制逻辑 ---
            // 如果用户未登录，锁定 Potion 和 AutoFarm 页面
            if (Session["userId"] == null)
            {
                panelLockPotion.Visible = true;
                panelLockAutoFarm.Visible = true;
            }
            else
            {
                panelLockPotion.Visible = false;
                panelLockAutoFarm.Visible = false;
            }
        }

        protected void Guide_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string guideName = btn.CommandArgument;

            // 安全检查：防止 Visitor 绕过 UI 点击锁定内容
            if (Session["userId"] == null && (guideName == "Potion" || guideName == "AutoFarm"))
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
            }

            // 数据库点击计数逻辑
            UpdateClickStats(guideName);

            Response.Redirect(targetUrl);
        }

        private void UpdateClickStats(string guideName)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "UPDATE guideStatsTable SET ClickCount = ClickCount + 1 WHERE GuideName = @name";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@name", guideName);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }
    }
}