using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["email"] == null)
            {
                Response.Redirect("Home.aspx");
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            string password = txtPassword.Text;
            string confirmPass = txtConfirmPassword.Text;

            if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirmPass))
            {
                ShowError("Passwords cannot be empty!");
                return;
            }

            if (password != confirmPass)
            {
                ShowError("Passwords do not match!");
                return;
            }
            // Safely grab the userId we saved during the OTP step
            string email = Session["email"].ToString();
            string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);

            // Attempt to update the database
            bool isUpdated = UpdatePasswordInDatabase(email, hashedPassword);

            if (isUpdated)
            {
                // Clean up the session so they can't reuse it, then send to login
                Session.Remove("email");
                Response.Redirect("Login.aspx?message=PasswordResetSuccess");
            }
            else
            {
                ShowError("An error occurred while resetting your password. Please try again.");
            }
        }

        private bool UpdatePasswordInDatabase(string email, string newPassword)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "UPDATE userTable SET Password = @Password WHERE Email = @Email";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Password", newPassword);
                        cmd.Parameters.AddWithValue("@Email", email);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Database Error: " + ex.Message);
                return false;
            }
        }

        private void ShowError(string message)
        {
            errorMsg.Text = message;
            errorMsg.ForeColor = Color.Red;
            errorMsg.Visible = true;
        }
    }
}