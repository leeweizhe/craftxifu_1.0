using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebAssignment.Lee_Wei_Zhe.myClass;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class ForgotPass : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string purpose = "Reset Password";
            string email = txtEmail.Text.Trim();
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            int userId = 0;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 1. Check if the email exists in the database and grab their ID
                string query = "SELECT userId FROM userTable WHERE Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();

                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        userId = Convert.ToInt32(result);
                    }
                }
            }

            // 2. If we found the user, generate and send the OTP!
            if (userId > 0)
            {
                string otp = OtpHelper.GenerateNumericOtp();
                string otpHash = OtpHelper.HashOtp(otp);
                DateTime expiresAt = DateTime.Now.AddMinutes(10);

                OtpHelper.SaveOtpToDb(email, otpHash, purpose, expiresAt, connString);
                EmailHelper.SendOtpEmail(email, otp);

                Response.Redirect("~/Lee Wei Zhe/aspx/VerifyOtpFp.aspx?email=" + email);
            }
            else
            {
                errorMsg.Text = "If that email matches an account, an OTP has been sent.";
                errorMsg.ForeColor = System.Drawing.Color.Green;
                Response.Redirect("~/Lee Wei Zhe/aspx/VerifyOtpFp.aspx?email=" + email);
            }
        }

        private void ShowError(string message)
        {
            errorMsg.Text = message;
            errorMsg.ForeColor = Color.Red;
            errorMsg.Visible = true;
        }

        protected void lnkLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Wong Zhang Zhe/Login.aspx");
        }

        protected void lnkRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Lee Wei Zhe/aspx/RegistrationPage.aspx");
        }
    }
}