using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Globalization;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class ManageUserDetail : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            errorMsg.Visible = false;

            if (!IsPostBack)
            {
                // 1. First, generate the full list of countries
                BindCountries();

                // 2. Then, load the user's specific data
                string userId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(userId))
                {
                    LoadUserData(userId);
                }
                else
                {
                    Response.Redirect("ManageUser.aspx");
                }
            }
        }

        private void BindCountries()
        {
            List<string> countryList = new List<string>();
            foreach (CultureInfo ci in CultureInfo.GetCultures(CultureTypes.SpecificCultures))
            {
                RegionInfo ri = new RegionInfo(ci.Name);
                if (!countryList.Contains(ri.EnglishName))
                {
                    countryList.Add(ri.EnglishName);
                }
            }
            countryList.Sort();

            ddlCountry.DataSource = countryList;
            ddlCountry.DataBind();
            ddlCountry.Items.Insert(0, new ListItem("-- Select Country --", ""));
        }

        private void LoadUserData(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Using your confirmed column names: FName and LName
                string query = "SELECT * FROM userTable WHERE UserId = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtFname.Text = reader["FName"].ToString();
                    txtLname.Text = reader["LName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtUsername.Text = reader["Username"].ToString();
                    rblGender.SelectedValue = reader["Gender"].ToString();

                    // After ddlCountry is bound, we can select the user's specific country
                    string userCountry = reader["Country"].ToString();
                    if (ddlCountry.Items.FindByValue(userCountry) != null)
                    {
                        ddlCountry.SelectedValue = userCountry;
                    }

                    string userRole = reader["Role"].ToString();
                    if (ddlRole.Items.FindByValue(userRole) != null)
                    {
                        ddlRole.SelectedValue = userRole;
                    }
                }
                conn.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // Make sure the Key matches exactly what is in your URL (is it 'id' or 'UserId'?)
            string targetUserId = Request.QueryString["id"];

            if (!string.IsNullOrEmpty(targetUserId))
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "UPDATE userTable SET Role = @Role WHERE UserId = @ID";
                    SqlCommand cmd = new SqlCommand(query, conn);

                    cmd.Parameters.AddWithValue("@Role", ddlRole.SelectedValue);
                    cmd.Parameters.AddWithValue("@ID", targetUserId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                Response.Redirect("/Tong Yu Hong/aspx/ManageUser.aspx");
            }
            else
            {
                errorMsg.Text = "ERROR: USER ID MISSING FROM URL";
                errorMsg.Visible = true;
            }
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageUser.aspx");
        }

        private void ShowError(string message)
        {
            errorMsg.Text = message;
            errorMsg.Visible = true;
        }
    }
}