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
    public partial class ManageUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentRole = Session["UserRole"] as string;

            // If the person is NOT an Admin, kick them out
            if (string.IsNullOrEmpty(currentRole) || currentRole != "Admin")
            {
                Response.Redirect("~/Wong Zhang Zhe/Home.aspx");
                return;
            }
            if (!IsPostBack)
            {
                //
                BindUsers();
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            // This triggers automatically when you stop typing or tab out
            BindUsers(txtSearch.Text.Trim());
        }

        protected void btnHiddenSearch_Click(object sender, EventArgs e)
        {
            // This connects the ghost button to your search logic
            BindUsers(txtSearch.Text.Trim());
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;

            // Re-bind the grid with no filter to show all 10+ users
            BindUsers(string.Empty);

            // 3. Set focus back to the search bar
            txtSearch.Focus();
        }

        private void BindUsers(string searchItem = "")
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            // Build the dynamic query
            string query = "SELECT UserId, Username, Email, ProfilePicture FROM userTable WHERE 1=1";

            if (!string.IsNullOrEmpty(searchItem))
            {
                query += " AND (Username LIKE @SearchItem OR Email LIKE @SearchItem)";
            }

            // Use sorting similar to the Guide order fix
            query += " ORDER BY Username ASC";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(searchItem))
                    {
                        cmd.Parameters.AddWithValue("@SearchItem", "%" + searchItem + "%");
                    }

                    try
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        //
                        rptUsers.DataSource = dt;
                        rptUsers.DataBind();
                    }
                    catch (SqlException)
                    {
                        // Handle potential database issues, similar to how we analyzed salt errors
                        Response.Write("<script>alert('Error fetching user data. Check connection string.');</script>");
                    }
                }
            }
        }
    }
}