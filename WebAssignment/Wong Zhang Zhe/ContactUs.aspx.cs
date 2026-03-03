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
    public partial class ContactUs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 如果有初始化逻辑可以放在这里
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Session["UserId"] = 5; // 仅供测试
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "INSERT INTO contactTable (UserId, Subject, Message, Status) VALUES (@uid, @sub, @msg, @status)";
                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@sub", ddlSubject.SelectedValue);
                cmd.Parameters.AddWithValue("@msg", txtMessage.Text);
                cmd.Parameters.AddWithValue("@status", "Submitted");

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            lblStatus.Text = "TICKET CREATED SUCCESSFULLY!";
            lblStatus.ForeColor = System.Drawing.Color.LimeGreen;
            formPanel.Visible = false;
            successPanel.Visible = true;
        }

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Wong Zhang Zhe/Home.aspx");
        }
    }
}