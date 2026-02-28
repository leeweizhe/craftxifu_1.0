using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class BeginnerGuide : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGuideParts();
            }
        }

        private void LoadGuideParts()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT PartId, PartTitle FROM BGuidePart ORDER BY PartOrder ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        rptGuideParts.DataSource = dt;
                        rptGuideParts.DataBind(); // This triggers the ItemDataBound event below!
                    }
                }
            }
        }

        protected void rptGuideParts_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Make sure we are looking at an actual data row, not the header or footer
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Find the HiddenField and the Inner Repeater on the ASPX page
                HiddenField hfPartId = (HiddenField)e.Item.FindControl("hfPartId");
                Repeater rptSteps = (Repeater)e.Item.FindControl("rptSteps");

                int currentPartId = Convert.ToInt32(hfPartId.Value);

                // Query the database for the steps that belong to THIS PartId
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "SELECT StepTitle, StepDescription, ImagePath FROM BGuideStep WHERE PartId = @PartId ORDER BY StepOrder ASC";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PartId", currentPartId);
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dtSteps = new DataTable();
                            sda.Fill(dtSteps);

                            // Give the steps to the Inner Repeater
                            rptSteps.DataSource = dtSteps;
                            rptSteps.DataBind();
                        }
                    }
                }
            }
        }
    }
}