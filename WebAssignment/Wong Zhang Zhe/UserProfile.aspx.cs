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
    public partial class UserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["userId"] == null)
            {
                // If you are not logged in, you will be redirected to the login page.
                Response.Redirect("~/Lee Wei Zhe/aspx/Login.aspx");
                return;
            }

            if (Session["username"] == null) Session["username"] = "Guest";
            if (Session["profilePic"] == null) Session["profilePic"] = "~/Images/profiles/DPick.jpg";

            if (!IsPostBack)
            {
                try
                {
                    int currentUserId = Convert.ToInt32(Session["userId"]);
                    LoadUserData(currentUserId);
                }
                catch (Exception)
                {
                    Response.Redirect("../Lee Wei Zhe/aspx/Login.aspx");
                }
            }
        }

        private void LoadUserData(int userId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT * FROM userTable WHERE UserId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", userId);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        lblFullName.Text = reader["FName"].ToString() + " " + reader["LName"].ToString();
                        lblUsername.Text = "@" + reader["Username"].ToString();
                        lblEmail.Text = reader["Email"].ToString();
                        lblRole.Text = reader["Role"].ToString();
                        lblCountry.Text = reader["Country"].ToString();
                        lblCurrency.Text = reader["Currency"].ToString();
                        lblBio.Text = (reader["Bio"] != DBNull.Value && !string.IsNullOrEmpty(reader["Bio"].ToString()))
                                      ? reader["Bio"].ToString() : "No bio available.";

                        // Handling cases where Bio is empty
                        lblBio.Text = (reader["Bio"] != DBNull.Value && !string.IsNullOrWhiteSpace(reader["Bio"].ToString()))
                                      ? reader["Bio"].ToString().Trim() : "No bio available.";

                        // profile picture
                        string profilePic = reader["ProfilePicture"].ToString();
                        imgAvatar.ImageUrl = !string.IsNullOrEmpty(profilePic) ? profilePic : "~/Images/profiles/DPick.jpg";

                        // --- NameTag  ---
                        if (reader["NameTag"] != DBNull.Value && !string.IsNullOrEmpty(reader["NameTag"].ToString()))
                        {
                            imgNameTag.ImageUrl = reader["NameTag"].ToString().Trim();
                            imgNameTag.Visible = true;
                        }
                        else
                        {
                            imgNameTag.Visible = false;
                        }

                        // --- AvatarFrame ---
                        if (reader["AvatarFrame"] != DBNull.Value && !string.IsNullOrEmpty(reader["AvatarFrame"].ToString()))
                        {
                            string frameUrl = reader["AvatarFrame"].ToString().Trim();
                            imgFrameOverlay.ImageUrl = ResolveUrl(frameUrl); 
                            imgFrameOverlay.Visible = true; 

                            Session["avatarFrame"] = frameUrl;
                        }
                        else
                        {
                            imgFrameOverlay.Visible = false; 
                            Session["avatarFrame"] = null;
                        }

                        Session["username"] = reader["Username"].ToString();
                        Session["profilePic"] = imgAvatar.ImageUrl;
                    }
                    conn.Close();
                }
                catch (Exception ex)
                {
                    
                }
            }
        }

        protected void btnGoToEdit_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditProfile.aspx");
        }
    }
}