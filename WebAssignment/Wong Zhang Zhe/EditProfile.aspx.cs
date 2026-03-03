using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebAssignment
{
    public partial class EditProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("/Lee Wei Zhe/aspx/Login.aspx"); 
                return;
            }

            // Add JavaScript to prompt for confirmation when the front-end button is clicked.
            btnUpdate.Attributes.Add("onclick", "return confirm('Are you sure you want to save these changes?');");

            if (!IsPostBack)
            {
                LoadCurrentData();
            }
        }

        private void LoadCurrentData()
        {
            int userId = Convert.ToInt32(Session["userId"]);
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT * FROM userTable WHERE UserId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtFName.Text = reader["FName"].ToString();
                    txtLName.Text = reader["LName"].ToString();
                    txtCountry.Text = reader["Country"].ToString();
                    txtBio.Text = reader["Bio"] != DBNull.Value ? reader["Bio"].ToString() : "";

                    string gender = reader["Gender"].ToString();
                    if (ddlGender.Items.FindByValue(gender) != null)
                    {
                        ddlGender.SelectedValue = gender;
                    }
                }
                conn.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtPassword.Text))
            {
                if (txtPassword.Text != txtConfirmPassword.Text)
                {
                    lblMsg.Text = "Error: Passwords do not match!";
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                    return;
                }
            }

            int userId = Convert.ToInt32(Session["userId"]);
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "UPDATE userTable SET FName=@fn, LName=@ln, Country=@ct, Bio=@bio, Gender=@gd";
                if (!string.IsNullOrEmpty(txtPassword.Text))
                {
                    sql += ", Password=@pw";
                }
                sql += " WHERE UserId=@id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@fn", txtFName.Text);
                cmd.Parameters.AddWithValue("@ln", txtLName.Text);
                cmd.Parameters.AddWithValue("@ct", txtCountry.Text);
                cmd.Parameters.AddWithValue("@bio", txtBio.Text);
                cmd.Parameters.AddWithValue("@gd", ddlGender.SelectedValue);
                cmd.Parameters.AddWithValue("@id", userId);

                if (!string.IsNullOrEmpty(txtPassword.Text))
                {
                    string hashedPassword = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text);
                    cmd.Parameters.AddWithValue("@pw", txtPassword.Text);
                }

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // After a successful update, ensure that the userId still exists in the Session.
            Session["userId"] = userId;
            Response.Redirect("UserProfile.aspx");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserProfile.aspx");
        }
    }
}