using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebAssignment.Lee_Wei_Zhe.myClass;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class VerifyOtpFp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["userId"] == null)
            {
                Response.Redirect("Home.aspx");
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string userIdStr = Request.QueryString["userId"];
            string enteredOtp = txtOtp.Text.Trim();
            int userId = Convert.ToInt32(userIdStr);
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT TOP 1 OtpId, OtpHash, ExpiresAt, IsUsed FROM EmailOtp WHERE UserId = @UserId ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            int otpId = Convert.ToInt32(dr["OtpId"]);
                            string storedHash = dr["OtpHash"].ToString();
                            DateTime expiresAt = Convert.ToDateTime(dr["ExpiresAt"]);
                            bool isUsed = Convert.ToBoolean(dr["IsUsed"]);

                            // Security Checks
                            if (isUsed || DateTime.Now > expiresAt)
                            {
                                ShowError("Code is expired or already used.");
                                return;
                            }

                            // Verify the Hash
                            if (BCrypt.Net.BCrypt.Verify(enteredOtp, storedHash))
                            {
                                dr.Close();

                                // 1. Mark as used so they can't reuse it
                                OtpHelper.MarkOtpAsUsed(otpId, connString);

                                // 2. THE VIP PASS: Save their ID to a Session variable
                                Session["userId"] = userId;

                                // 3. Send them to the final step!
                                Response.Redirect("ResetPassword.aspx");
                            }
                            else
                            {
                                ShowError("Invalid OTP code.");
                            }
                        }
                    }
                }
            }
        }

        protected void lnkBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("ForgotPass.aspx");
        }

        private void ShowError(string message)
        {
            errorMsg.Text = message; 
            errorMsg.ForeColor = System.Drawing.Color.Red;
        }
    }
}