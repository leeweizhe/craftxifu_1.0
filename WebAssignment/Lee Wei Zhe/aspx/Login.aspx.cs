using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
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

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            SqlCommand cmd = new SqlCommand("select count(*) from userTable where Username = '" + txtUsername.Text + "' and Password = '" + txtPassword.Text + "'", con);
            int count = Convert.ToInt32(cmd.ExecuteScalar().ToString());

            if (count > 0)
            {
                SqlCommand cmdType = new SqlCommand("select FName, Role from userTable where Username = '" + txtUsername.Text + "'", con);
                SqlDataReader dr = cmdType.ExecuteReader();

                string role = "";
                string name = "";

                while (dr.Read())
                {
                    role = dr["Role"].ToString().Trim();
                    name = dr["FName"].ToString().Trim();
                }

                Session["firstName"] = name;
                Session["userRole"] = role;
                Response.Redirect("Home.aspx");
                errorMsg.Visible = true;
                errorMsg.Text = "Login Successful";

            }
            else
            {
                errorMsg.Visible = true;
                errorMsg.ForeColor = System.Drawing.Color.Red;
                errorMsg.Text = "Username and Password mismatch!";
                return;
            }

            con.Close();
        }
    }
}