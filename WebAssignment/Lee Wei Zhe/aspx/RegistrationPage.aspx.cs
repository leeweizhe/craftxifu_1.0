using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class RegistrationPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void lnkHaveAccount_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}