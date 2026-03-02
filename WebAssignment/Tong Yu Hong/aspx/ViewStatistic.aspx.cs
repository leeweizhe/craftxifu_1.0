using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class ViewStatistic : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGuideStats();
            }
        }

        private void BindGuideStats()
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Selecting only existing columns
                string query = "SELECT GuideName, ClickCount FROM guideStatsTable ORDER BY GuideName ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();
                        da.Fill(dt);

                        rptStats.DataSource = dt;
                        rptStats.DataBind();
                    }
                    catch (Exception ex)
                    {
                        // Handle error if table doesn't exist yet
                    }
                }
            }
        }
    }
}