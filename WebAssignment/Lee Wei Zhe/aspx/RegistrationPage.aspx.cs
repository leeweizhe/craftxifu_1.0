using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;        // Needed for changing error message color
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebAssignment.Lee_Wei_Zhe.myClass;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class RegistrationPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            errorMsg.Visible = false;
            if (!IsPostBack)
            {
                if (Session["RegEmail"] != null)
                {
                    txtFname.Text = Session["RegFName"].ToString();
                    txtLname.Text = Session["RegLName"].ToString();
                    txtEmail.Text = Session["RegEmail"].ToString();
                    txtUsername.Text = Session["RegUsername"].ToString();
                    rblGender.SelectedValue = Session["RegGender"].ToString();
                    ddlCountry.SelectedValue = Session["RegCountry"].ToString();
                }
            }
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
                ShowError("Please select your Gender!");
                return;
            }

            if (string.IsNullOrEmpty(country))
            {
                ShowError("Please select your Country!");
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
                string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    // 1. Check if Username exists
                    string checkUserQuery = "SELECT COUNT(*) FROM userTable WHERE Username = @Username";
                    using (SqlCommand cmdUser = new SqlCommand(checkUserQuery, conn))
                    {
                        cmdUser.Parameters.AddWithValue("@Username", username);
                        int userCount = (int)cmdUser.ExecuteScalar();
                        if (userCount > 0)
                        {
                            ShowError("That username is already taken. Please choose another.");
                            return;
                        }
                    }

                    // 2. Check if Email exists
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

                    // --- NEW OTP LOGIC STARTS HERE ---

                    // 3. Hash the password immediately for safety
                    string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);

                    // 4. Save all validated data to Session to be inserted LATER on VerifyEmail page
                    Session["RegFName"] = fName;
                    Session["RegLName"] = lName;
                    Session["RegEmail"] = email;
                    Session["RegGender"] = gender;
                    Session["RegCountry"] = country;
                    Session["RegUsername"] = username;
                    Session["RegPassword"] = hashedPassword;

                    // 5. Generate a 6-digit OTP
                    string otp = OtpHelper.GenerateNumericOtp();
                    string otpHash = OtpHelper.HashOtp(otp);
                    string purpose = "Registration";
                    DateTime expiresAt = DateTime.Now.AddMinutes(10);

                    OtpHelper.SaveOtpToDb(email, otpHash, purpose, expiresAt, connString);
                    EmailHelper.SendOtpEmail(email, otp);
                    // 6. Save the OTP to the new EmailOtp table
                    //string otpQuery = "INSERT INTO EmailOtp (Email, OtpHash, Purpose, Expiration) VALUES (@OtpEmail, @OtpHash, @Purpose, @ExpiresAt)";
                    //using (SqlCommand cmdOtp = new SqlCommand(otpQuery, conn))
                    //{
                    //    cmdOtp.Parameters.AddWithValue("@OtpEmail", email);
                    //    cmdOtp.Parameters.AddWithValue("@OtpCode", otpHash);
                    //    cmdOtp.Parameters.AddWithValue("@Purpose", purpose);
                    //    cmdOtp.Parameters.AddWithValue("@ExpiresAt", expiresAt);
                    //    cmdOtp.ExecuteNonQuery();
                    //}

                    conn.Close();
                    Response.Redirect("VerifyOtpR.aspx");
                }
            }
            catch (Exception ex)
            {
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