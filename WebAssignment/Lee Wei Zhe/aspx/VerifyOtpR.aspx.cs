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
    public partial class VerifyOtpR : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["RegEmail"] == null)
            {
                Response.Redirect("Home.aspx");
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string email = Session["RegEmail"].ToString();
            string enteredOtp = txtOtp.Text.Trim();
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT TOP 1 OtpId, OtpHash, ExpiresAt, IsUsed FROM EmailOtp WHERE Email = @Email ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
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

                                string insertUserQuery = @"INSERT INTO userTable (FName, LName, Email, Gender, Country, Username, Password) 
                                               VALUES (@FName, @LName, @Email, @Gender, @Country, @Username, @Password)";

                                using (SqlCommand cmdInsert = new SqlCommand(insertUserQuery, conn))
                                {
                                    // Pulling all the data we temporarily saved during Step 1
                                    cmdInsert.Parameters.AddWithValue("@FName", Session["RegFName"].ToString());
                                    cmdInsert.Parameters.AddWithValue("@LName", Session["RegLName"].ToString());
                                    cmdInsert.Parameters.AddWithValue("@Email", email);
                                    cmdInsert.Parameters.AddWithValue("@Gender", Session["RegGender"].ToString());
                                    cmdInsert.Parameters.AddWithValue("@Country", Session["RegCountry"].ToString());
                                    cmdInsert.Parameters.AddWithValue("@Username", Session["RegUsername"].ToString());
                                    cmdInsert.Parameters.AddWithValue("@Password", Session["RegPassword"].ToString()); // This is already hashed!

                                    cmdInsert.ExecuteNonQuery();
                                    Response.Redirect("Login.aspx?message=RegistrationSuccess");
                                }
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
            Response.Redirect("RegistrationPage.aspx");
        }

        private void ShowError(string message)
        {
            errorMsg.Text = message;
            errorMsg.ForeColor = Color.Red;
            errorMsg.Visible = true;
        }
    }
}