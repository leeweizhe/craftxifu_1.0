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
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["userId"] != null)
            {
                visitorSection.Visible = false;
                memberSection.Visible = true;
                memberDataCards.Visible = true;
                phMemberStatus.Visible = true;
                LoadUserStatus(Convert.ToInt32(Session["userId"]));
            }
            else
            {
                visitorSection.Visible = true;
                memberSection.Visible = false;
                memberDataCards.Visible = false;
                phMemberStatus.Visible = false;

                if (Session["username"] == null) Session["username"] = "Guest";
                if (Session["profilePic"] == null) Session["profilePic"] = "~/Images/profiles/DPick.jpg";
            }
        }

        private void LoadUserStatus(int userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT Username, Currency, ProfilePicture, AvatarFrame FROM userTable WHERE UserId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", userId);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblEmeralds.Text = reader["Currency"].ToString();

                        // Synchronize Session with Master Page
                        Session["username"] = reader["Username"].ToString();
                        Session["profilePic"] = reader["ProfilePicture"].ToString();

                        if (reader["AvatarFrame"] != DBNull.Value)
                            Session["avatarFrame"] = reader["AvatarFrame"].ToString();
                    }
                    conn.Close();
                }
                catch (Exception) { }
            }
        }

        protected void btnLoginRedirect_Click(object sender, EventArgs e)
        {
            Response.Redirect("../Lee Wei Zhe/aspx/Login.aspx");
        }
    }
}