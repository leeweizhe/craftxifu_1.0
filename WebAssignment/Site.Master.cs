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
            if (Session["userId"] != null)
            {
                phVisitor.Visible = false;
                phMember.Visible = true;

                string picPath = Session["profilePic"].ToString();
                int userId = Convert.ToInt32(Session["userId"]);
                lblUsername.Text = Session["username"].ToString();
                imgProfile.ImageUrl = picPath;
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
            Response.Redirect("Login.aspx");
        }
    }
}