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
                CheckInstructorPrivilege();
                categoryPanel.Visible = true;
                subFarmPanel.Visible = false;
                LoadDynamicCategories();
            }
        }

        private void CheckInstructorPrivilege()
        {
            if (Session["userId"] != null)
            {
                int userId = Convert.ToInt32(Session["userId"]);
                string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string sql = "SELECT Role FROM userTable WHERE userId = @id";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@id", userId);

                    conn.Open();
                    object roleObj = cmd.ExecuteScalar();
                    conn.Close();

                    if (roleObj != null && roleObj.ToString() == "Instructor")
                    {
                        btnAddFarm.Visible = true; // only show for instructor
                    }
                }
            }
        }

        protected void RedirectToAddFarm(object sender, EventArgs e)
        {
            Response.Redirect("~/Wong Zhang Zhe/AddAutoFarm.aspx");
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

            // Switch panel
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
