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