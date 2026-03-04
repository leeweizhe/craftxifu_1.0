using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO; 

namespace WebAssignment
{
    public partial class EditProfile : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("~/Lee Wei Zhe/aspx/Login.aspx");
                return;
            }

            // Add a pre-confirmation pop-up to the save button.
            btnUpdate.Attributes.Add("onclick", "return confirm('Confirm saving character changes?');");

            if (!IsPostBack)
            {
                LoadCurrentData();
            }
        }

        private void LoadCurrentData()
        {
            int userId = Convert.ToInt32(Session["userId"]);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Obtain the user's current basic information and the equipment being displayed.
                string sqlUser = "SELECT * FROM userTable WHERE UserId = @id";
                SqlCommand cmdUser = new SqlCommand(sqlUser, conn);
                cmdUser.Parameters.AddWithValue("@id", userId);

                conn.Open();
                SqlDataReader reader = cmdUser.ExecuteReader();
                if (reader.Read())
                {
                    txtFName.Text = reader["FName"].ToString().Trim();
                    txtLName.Text = reader["LName"].ToString().Trim();
                    txtCountry.Text = reader["Country"].ToString().Trim();
                    txtBio.Text = reader["Bio"] != DBNull.Value ? reader["Bio"].ToString().Trim() : "";

                    ViewState["curAvatar"] = reader["ProfilePicture"].ToString().Trim();
                    ViewState["curNT"] = reader["NameTag"].ToString().Trim();
                    ViewState["curAF"] = reader["AvatarFrame"].ToString().Trim();

                    if (ddlGender.Items.FindByValue(reader["Gender"].ToString()) != null)
                        ddlGender.SelectedValue = reader["Gender"].ToString();
                }
                reader.Close();

                //Load the user's previously purchased inventory items for selection.
                string sqlInv = @"SELECT s.Name, s.ImagePath, s.FrameImagePath 
                                FROM userInventoryTable i 
                                JOIN shopItemTable s ON i.ItemId = s.ItemId 
                                WHERE i.UserId = @uid";
                SqlCommand cmdInv = new SqlCommand(sqlInv, conn);
                cmdInv.Parameters.AddWithValue("@uid", userId);

                SqlDataReader invReader = cmdInv.ExecuteReader();
                while (invReader.Read())
                {
                    string itemName = invReader["Name"].ToString();
                    string tagPath = invReader["ImagePath"] != DBNull.Value ? invReader["ImagePath"].ToString() : "";
                    string framePath = invReader["FrameImagePath"] != DBNull.Value ? invReader["FrameImagePath"].ToString() : "";

                    // If the item has a title path, add it to the title dropdown menu.
                    if (!string.IsNullOrEmpty(tagPath))
                        ddlNameTag.Items.Add(new ListItem(itemName, tagPath));

                    // If the item has a border path, add an avatar frame dropdown.
                    if (!string.IsNullOrEmpty(framePath))
                        ddlAvatarFrame.Items.Add(new ListItem(itemName, framePath));
                }
                invReader.Close();

                // Set the initial selected state of the dropdown list.
                if (ViewState["curNT"] != null) ddlNameTag.SelectedValue = ViewState["curNT"].ToString();
                if (ViewState["curAF"] != null) ddlAvatarFrame.SelectedValue = ViewState["curAF"].ToString();

                conn.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // Verify password consistency
            if (!string.IsNullOrEmpty(txtPassword.Text) && txtPassword.Text != txtConfirmPassword.Text)
            {
                lblMsg.Text = "Error: New passwords do not match!";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int userId = Convert.ToInt32(Session["userId"]);
            string avatarPath = ViewState["curAvatar"].ToString(); // The default path is the old profile picture.

            // Handling local file uploads
            if (fuProfilePic.HasFile)
            {
                try
                {
                    string fileName = "Avatar_" + userId + "_" + DateTime.Now.Ticks + Path.GetExtension(fuProfilePic.FileName);
                    string folderPath = Server.MapPath("~/Images/profiles/");

                    // Ensure the target folder exists.
                    if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                    fuProfilePic.SaveAs(folderPath + fileName);
                    avatarPath = "~/Images/profiles/" + fileName; // Update the path to the database.
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "File upload error: " + ex.Message;
                    return;
                }
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Updating the userTable determines the content displayed on the user's homepage.
                string sql = @"UPDATE userTable SET 
                             FName=@fn, LName=@ln, Country=@ct, Bio=@bio, Gender=@gd, 
                             ProfilePicture=@pp, NameTag=@nt, AvatarFrame=@af";

                if (!string.IsNullOrEmpty(txtPassword.Text)) sql += ", Password=@pw";
                sql += " WHERE UserId=@id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@fn", txtFName.Text.Trim());
                cmd.Parameters.AddWithValue("@ln", txtLName.Text.Trim());
                cmd.Parameters.AddWithValue("@ct", txtCountry.Text.Trim());
                cmd.Parameters.AddWithValue("@bio", txtBio.Text.Trim());
                cmd.Parameters.AddWithValue("@gd", ddlGender.SelectedValue);
                cmd.Parameters.AddWithValue("@pp", avatarPath); 
                cmd.Parameters.AddWithValue("@nt", ddlNameTag.SelectedValue); 
                cmd.Parameters.AddWithValue("@af", ddlAvatarFrame.SelectedValue);
                cmd.Parameters.AddWithValue("@id", userId);

                if (!string.IsNullOrEmpty(txtPassword.Text))
                {
                    // Encrypt new passwords using BCrypt
                    cmd.Parameters.AddWithValue("@pw", BCrypt.Net.BCrypt.HashPassword(txtPassword.Text));
                }

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // Synchronize Session to ensure global avatars refresh instantly.
            Session["profilePic"] = avatarPath;
            Response.Redirect("UserProfile.aspx");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserProfile.aspx");
        }
    }
}