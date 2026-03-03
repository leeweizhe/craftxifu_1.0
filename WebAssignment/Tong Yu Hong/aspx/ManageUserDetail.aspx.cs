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
            string userId = Request.QueryString["id"];
            string fName = txtFname.Text.Trim();
            string lName = txtLname.Text.Trim();
            string email = txtEmail.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string confirmPass = txtConfirmPassword.Text;
            string gender = rblGender.SelectedValue;
            string country = ddlCountry.SelectedValue;
            string role = ddlRole.SelectedValue;

            // 1. Basic Validation
            if (password != confirmPass) { ShowError("Passwords do not match!"); return; }
            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$")) { ShowError("Invalid email format."); return; }

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    // 2. Build the Update Query
                    string updateQuery = @"UPDATE userTable SET 
                                        FName = @FName, LName = @LName, 
                                        Email = @Email, Username = @Username, 
                                        Gender = @Gender, Country = @Country, Role = @Role";

                    // 3. Only add Password to query if the Admin typed something
                    if (!string.IsNullOrEmpty(password))
                    {
                        updateQuery += ", Password = @Password";
                    }

                    updateQuery += " WHERE UserId = @UserId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@FName", fName);
                        cmd.Parameters.AddWithValue("@LName", lName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Gender", gender);
                        cmd.Parameters.AddWithValue("@Country", country);
                        cmd.Parameters.AddWithValue("@Role", role);
                        cmd.Parameters.AddWithValue("@UserId", userId);

                        if (!string.IsNullOrEmpty(password))
                        {
                            // Hash the new password before saving
                            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);
                            cmd.Parameters.AddWithValue("@Password", hashedPassword);
                        }

                        cmd.ExecuteNonQuery();
                    }
                }
                // Redirect back to the main list after success
                Response.Redirect("ManageUser.aspx");
            }
            catch (Exception ex)
            {
                ShowError("Update failed: " + ex.Message);
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