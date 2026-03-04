using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckLoginStatus();
            }
        }

        private void CheckLoginStatus()
        {
            if (Session["userId"] != null && !string.IsNullOrEmpty(Session["userId"].ToString()))
            {
                phVisitor.Visible = false;
                phMember.Visible = true;

                if (Session["userRole"] != null && Session["userRole"].ToString() == "Admin")
                {
                    phAdmin.Visible = true;
                }
                else
                {
                    phAdmin.Visible = false;
                }

                // 3. Load user data for the phMember section
                //lblUsername.Text = Session["username"].ToString();
                //imgProfile.ImageUrl = Session["profilePic"].ToString();
                lblUsername.Text = Session["username"] != null ? Session["username"].ToString() : "Member";

                // 使用小写 p: profilePic
                if (Session["profilePic"] != null)
                {
                    imgProfile.ImageUrl = Session["profilePic"].ToString();
                }

                // Handle the frame
                if (Session["avatarFrame"] != null && !string.IsNullOrEmpty(Session["avatarFrame"].ToString()))
                {
                    imgFrame.ImageUrl = Session["avatarFrame"].ToString();
                    imgFrame.Visible = true;
                }
                else { imgFrame.Visible = false; }
            }
            else
            {
                // 4. Visitor state
                phVisitor.Visible = true;
                phMember.Visible = false;
                phAdmin.Visible = false;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Lee Wei Zhe/aspx/Login.aspx");
        }
    }
}