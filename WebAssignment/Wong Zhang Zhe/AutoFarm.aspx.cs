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
    public partial class AutoFarm : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 默认显示分类，隐藏列表
                categoryPanel.Visible = true;
                subFarmPanel.Visible = false;
                LoadDynamicCategories();
            }
        }

        private void LoadDynamicCategories()
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT DISTINCT Category FROM farmTable";
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                categoryRepeater.DataSource = dt;
                categoryRepeater.DataBind();
            }
        }

        protected void SelectCategory(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string category = btn.CommandArgument;

            lblCategoryTitle.Text = category + " Farms Database";
            LoadFarmsByCategory(category);

            // 切换面板
            categoryPanel.Visible = false;
            subFarmPanel.Visible = true;
        }

        private void LoadFarmsByCategory(string category)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT * FROM farmTable WHERE Category = @cat";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cat", category);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                farmRepeater.DataSource = dt;
                farmRepeater.DataBind();
            }
        }

        protected void BackToCategories(object sender, EventArgs e)
        {
            categoryPanel.Visible = true;
            subFarmPanel.Visible = false;
        }
    }
}
