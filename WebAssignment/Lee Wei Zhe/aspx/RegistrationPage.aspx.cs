using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Drawing;        // Needed for changing error message color
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class RegistrationPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            errorMsg.Visible = false;
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fName = txtFname.Text.Trim();
            string lName = txtLname.Text.Trim();
            string email = txtEmail.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string confirmPass = txtConfirmPassword.Text;
            string gender = rblGender.SelectedValue;
            string country = ddlCountry.SelectedValue;

            if (password != confirmPass)
            {
                ShowError("Passwords do not match!");
                return;
            }

            if (string.IsNullOrEmpty(gender))
            {
                ShowError("Please select both your Gender!");
                return;
            }

            if (string.IsNullOrEmpty(country))
            {
                ShowError("Please select both your Country!");
                return;
            }

            // The regex ^[a-zA-Z ]+$ means: Start to end, only allow uppercase, lowercase, and spaces.
            if (!Regex.IsMatch(fName, @"^[a-zA-Z ]+$") || !Regex.IsMatch(lName, @"^[a-zA-Z ]+$"))
            {
                ShowError("First and Last name can only contain letters.");
                return;
            }

            // This regex checks for the standard format: something @ something . something
            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                ShowError("Please enter a valid email address.");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
                {
                    conn.Open();
                    string checkUserQuery = "SELECT COUNT(*) FROM userTable WHERE Username = @Username";
                    using (SqlCommand cmdUser = new SqlCommand(checkUserQuery, conn))
                    {
                        cmdUser.Parameters.AddWithValue("@Username", username);
                        int userCount = (int)cmdUser.ExecuteScalar(); // ExecuteScalar grabs the single number result
                        if (userCount > 0)
                        {
                            ShowError("That username is already taken. Please choose another.");
                            return;
                        }
                    }

                    string checkEmailQuery = "SELECT COUNT(*) FROM userTable WHERE Email = @Email";
                    using (SqlCommand cmdEmail = new SqlCommand(checkEmailQuery, conn))
                    {
                        cmdEmail.Parameters.AddWithValue("@Email", email);
                        int emailCount = (int)cmdEmail.ExecuteScalar();
                        if (emailCount > 0)
                        {
                            ShowError("An account with that email already exists.");
                            return;
                        }
                    }

                    // Create your SQL Query. 
                    // We use @ parameters to PREVENT SQL INJECTION attacks. Never concatenate strings for SQL!
                    string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);

                    string query = @"INSERT INTO userTable (FName, LName, Email, Gender, Country, Username, Password) 
                                     VALUES (@FName, @LName, @Email, @Gender, @Country, @Username, @Password)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {

                        cmd.Parameters.AddWithValue("@FName", fName);
                        cmd.Parameters.AddWithValue("@LName", lName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Gender", gender);
                        cmd.Parameters.AddWithValue("@Country", country);
                        cmd.Parameters.AddWithValue("@Username", username);

                        cmd.Parameters.AddWithValue("@Password", hashedPassword);

                        cmd.ExecuteNonQuery();
                    }
                    conn.Close();
                }

                // If successful, redirect them to the login page!
                Response.Redirect("Login.aspx");
            }
            catch (Exception ex)
            {
                // If the database crashes or username already exists, show the error
                ShowError("Registration failed: " + ex.Message);
            }
        }

        protected void lnkHaveAccount_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        private void ShowError(string message)
        {
            errorMsg.Text = message;
            errorMsg.ForeColor = Color.Red;
            errorMsg.Visible = true;
        }
    }
}