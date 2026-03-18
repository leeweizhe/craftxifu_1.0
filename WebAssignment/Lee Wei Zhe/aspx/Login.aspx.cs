using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment
{
    public partial class Login1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["message"] == "PasswordResetSuccess")
            {
                errorMsg.Text = "Password successfully changed";
                errorMsg.ForeColor = Color.Green;
                errorMsg.Visible = true;
            }
            else if (Request.QueryString["message"] == "RegistrationSuccess")
            {
                errorMsg.Text = "User successfully registered";
                errorMsg.ForeColor = Color.Green;
                errorMsg.Visible = true;
            }

            else if (Request.QueryString["message"] == "livestream")
            {
                errorMsg.Text = "Login to view more!";
                errorMsg.ForeColor = Color.Red;
                errorMsg.Visible = true;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;

            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT Username, Password, FName, Role, UserId, ProfilePicture, AvatarFrame FROM userTable WHERE Username = @Username";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string storedHash = dr["Password"].ToString();
                            bool isPasswordCorrect = BCrypt.Net.BCrypt.Verify(password, storedHash);

                            if (isPasswordCorrect)
                            {
                                Session["firstName"] = dr["FName"].ToString().Trim();
                                Session["userRole"] = dr["Role"].ToString().Trim();
                                Session["userId"] = Convert.ToInt32(dr["UserId"]);
                                Session["username"] = dr["Username"].ToString().Trim();
                                Session["profilePic"] = dr["ProfilePicture"].ToString().Trim();
                                Session["avatarFrame"] = dr["AvatarFrame"] != DBNull.Value ? dr["AvatarFrame"].ToString() : "";

                                Response.Redirect("~/Wong Zhang Zhe/Home.aspx");
                            }
                            else
                            {
                                ShowError("Username and Password mismatch!");
                            }
                        }
                        else
                        {
                            ShowError("Invalid Username!");
                        }
                    }
                }
            }
        }


        private void ShowError(string message)
        {
            errorMsg.Text = message;
            errorMsg.ForeColor = Color.Red;
            errorMsg.Visible = true;
        }

        protected void lnkForgetPassword_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Lee Wei Zhe/aspx/ForgotPass.aspx");
        }

        protected void lnkRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Lee Wei Zhe/aspx/RegistrationPage.aspx");
        }
    }
}