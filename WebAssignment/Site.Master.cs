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

                string picPath = Convert.ToString(Session["profilePic"]);
                int userId = Convert.ToInt32(Session["userId"]);
                lblUsername.Text = Convert.ToString(Session["username"]);
                imgProfile.ImageUrl = picPath;

                if (Session["avatarFrame"] != null && !string.IsNullOrEmpty(Session["avatarFrame"].ToString()))
                {
                    string framePath = Session["avatarFrame"].ToString();
                    imgFrame.ImageUrl = framePath;
                    imgFrame.Visible = true;
                }
                else
                {
                    imgFrame.Visible = false;
                }
            }
            else
            {
                // No session means they are a visitor
                phVisitor.Visible = true;
                phMember.Visible = false;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Lee Wei Zhe/aspx/Login.aspx", true);
        }
    }
}