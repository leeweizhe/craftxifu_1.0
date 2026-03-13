using System;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;

namespace WebAssignment
{
    public partial class EditFarm : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // only Instructor
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Instructor")
            {
                Response.Redirect("AutoFarm.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    LoadFarmData(id);
                }
            }
        }

        private void LoadFarmData(string id)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT * FROM farmTable WHERE FarmId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtTitle.Text = reader["Title"].ToString();
                    txtDesc.Text = reader["Description"].ToString();
                    txtFullContent.Text = reader["FullContent"].ToString();
                    txtVideoUrl.Text = reader["VideoUrl"].ToString();
                    ddlEfficiency.SelectedValue = reader["Efficiency"].ToString();

                    ViewState["oldDetailImg"] = reader["DetailImage"].ToString();
                    ViewState["oldMatImg"] = reader["MaterialImage"].ToString();

                    imgPreviewDetail.ImageUrl = reader["DetailImage"].ToString();
                    imgPreviewMat.ImageUrl = reader["MaterialImage"].ToString();
                }
                conn.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            string detailImgPath = ViewState["oldDetailImg"].ToString();
            string matImgPath = ViewState["oldMatImg"].ToString();

            if (fuDetailImg.HasFile)
            {
                string fileName = "FarmDet_" + DateTime.Now.Ticks + Path.GetExtension(fuDetailImg.FileName);
                fuDetailImg.SaveAs(Server.MapPath("~/Wong Zhang Zhe/pic/") + fileName);
                detailImgPath = "/Wong Zhang Zhe/pic/" + fileName;
            }

            if (fuMatImg.HasFile)
            {
                string fileName = "FarmMat_" + DateTime.Now.Ticks + Path.GetExtension(fuMatImg.FileName);
                fuMatImg.SaveAs(Server.MapPath("~/Wong Zhang Zhe/pic/") + fileName);
                matImgPath = "/Wong Zhang Zhe/pic/" + fileName;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = @"UPDATE farmTable SET 
                             Title=@t, Description=@d, Efficiency=@e, FullContent=@fc, 
                             DetailImage=@di, MaterialImage=@mi, VideoUrl=@v 
                             WHERE FarmId=@id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@t", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@d", txtDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@e", ddlEfficiency.SelectedValue);
                cmd.Parameters.AddWithValue("@fc", txtFullContent.Text.Trim());
                cmd.Parameters.AddWithValue("@di", detailImgPath);
                cmd.Parameters.AddWithValue("@mi", matImgPath);
                cmd.Parameters.AddWithValue("@v", txtVideoUrl.Text.Trim());
                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            Response.Redirect("FarmDetails.aspx?id=" + id);
        }
    }
}