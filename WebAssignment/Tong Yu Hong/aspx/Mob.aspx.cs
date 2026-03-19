using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebAssignment.Tong_Yu_Hong.aspx
{
    public partial class Mob : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string userRole = Session["UserRole"] as string;
                if (!string.IsNullOrEmpty(userRole) && (userRole == "Instructor" || userRole == "Admin"))
                {
                    lnkAddMob.Visible = true;
                }
                // Load "Behavior" view as the first page
                BindMobData("Behavior");
            }
        }

        protected void btnAlpha_Click(object sender, EventArgs e)
        {
            BindMobData("Alpha");
        }

        protected void btnBehavior_Click(object sender, EventArgs e)
        {
            BindMobData("Behavior");
        }

        private void BindMobData(string mode)
        {
            var connSettings = ConfigurationManager.ConnectionStrings["ConnectionString"];

            if (connSettings != null)
            {
                string connString = connSettings.ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "SELECT MobID, MobName, Category, MobPicture FROM mobTable";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            if (mode == "Behavior")
                            {
                                mvMobViews.ActiveViewIndex = 1;

                                // Filter and Bind Passive
                                DataView dvPassive = new DataView(dt);
                                dvPassive.RowFilter = "Category = 'Passive'";
                                dvPassive.Sort = "MobName ASC"; // Keep them alphabetical within the category
                                rptPassive.DataSource = dvPassive;
                                rptPassive.DataBind();
                                litPassiveCount.Text = dvPassive.Count.ToString();

                                // Filter and Bind Neutral
                                DataView dvNeutral = new DataView(dt);
                                dvNeutral.RowFilter = "Category = 'Neutral'";
                                dvNeutral.Sort = "MobName ASC";
                                rptNeutral.DataSource = dvNeutral;
                                rptNeutral.DataBind();
                                litNeutralCount.Text = dvNeutral.Count.ToString();

                                // Filter and Bind Hostile
                                DataView dvHostile = new DataView(dt);
                                dvHostile.RowFilter = "Category = 'Hostile'";
                                dvHostile.Sort = "MobName ASC";
                                rptHostile.DataSource = dvHostile;
                                rptHostile.DataBind();
                                litHostileCount.Text = dvHostile.Count.ToString();
                            }
                            else if (mode == "Alpha")
                            {
                                mvMobViews.ActiveViewIndex = 0;
                                DataView dvStandard = new DataView(dt);
                                dvStandard.Sort = "MobName ASC";

                                MobRepeater.DataSource = dvStandard;
                                MobRepeater.DataBind();
                            }
                        }
                    }
                }
            }
            else
            {
                Response.Write("Error: Connection string 'ConnectionString' not found in Web.config.");
            }
        }
    }
}