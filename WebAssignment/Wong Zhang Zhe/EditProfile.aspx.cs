using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO; // 用于处理文件上传路径 [cite: 2026-03-04]

namespace WebAssignment
{
    public partial class EditProfile : System.Web.UI.Page
    {
        // 从 Web.config 获取数据库连接字符串
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 权限检查：确保用户已登录
            if (Session["userId"] == null)
            {
                Response.Redirect("~/Lee Wei Zhe/aspx/Login.aspx");
                return;
            }

            // 在保存按钮上添加前端确认弹窗
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
                // 1. 获取用户当前的基本资料和正在展示的装备
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

                    // 使用 ViewState 记录当前头像和装备路径，防止未修改时被置空
                    ViewState["curAvatar"] = reader["ProfilePicture"].ToString().Trim();
                    ViewState["curNT"] = reader["NameTag"].ToString().Trim();
                    ViewState["curAF"] = reader["AvatarFrame"].ToString().Trim();

                    if (ddlGender.Items.FindByValue(reader["Gender"].ToString()) != null)
                        ddlGender.SelectedValue = reader["Gender"].ToString();
                }
                reader.Close();

                // 2. 加载用户已买过的库存物品以供选择
                // 逻辑：根据 ImagePath 是否有值区分 NameTag 或 AvatarFrame
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

                    // 如果物品具有称号路径，则加入称号下拉框
                    if (!string.IsNullOrEmpty(tagPath))
                        ddlNameTag.Items.Add(new ListItem(itemName, tagPath));

                    // 如果物品具有边框路径，则加入头像框下拉框
                    if (!string.IsNullOrEmpty(framePath))
                        ddlAvatarFrame.Items.Add(new ListItem(itemName, framePath));
                }
                invReader.Close();

                // 3. 设置下拉框的初始选中状态 [cite: 2026-03-04]
                if (ViewState["curNT"] != null) ddlNameTag.SelectedValue = ViewState["curNT"].ToString();
                if (ViewState["curAF"] != null) ddlAvatarFrame.SelectedValue = ViewState["curAF"].ToString();

                conn.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // 验证密码一致性
            if (!string.IsNullOrEmpty(txtPassword.Text) && txtPassword.Text != txtConfirmPassword.Text)
            {
                lblMsg.Text = "Error: New passwords do not match!";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int userId = Convert.ToInt32(Session["userId"]);
            string avatarPath = ViewState["curAvatar"].ToString(); // 默认为旧头像路径

            // --- 核心修改：处理本地文件上传 --- [cite: 2026-03-04]
            if (fuProfilePic.HasFile)
            {
                try
                {
                    // 生成唯一文件名防止冲突 [cite: 2026-03-04]
                    string fileName = "Avatar_" + userId + "_" + DateTime.Now.Ticks + Path.GetExtension(fuProfilePic.FileName);
                    string folderPath = Server.MapPath("~/Images/profiles/");

                    // 确保目标文件夹存在 [cite: 2026-03-04]
                    if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                    fuProfilePic.SaveAs(folderPath + fileName);
                    avatarPath = "~/Images/profiles/" + fileName; // 更新数据库要存的路径 [cite: 2026-03-04]
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "File upload error: " + ex.Message;
                    return;
                }
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 更新 userTable 决定个人主页的展示内容
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
                cmd.Parameters.AddWithValue("@pp", avatarPath); // 上传后的新路径
                cmd.Parameters.AddWithValue("@nt", ddlNameTag.SelectedValue); // 选中的称号图片路径
                cmd.Parameters.AddWithValue("@af", ddlAvatarFrame.SelectedValue); // 选中的头像框图片路径
                cmd.Parameters.AddWithValue("@id", userId);

                if (!string.IsNullOrEmpty(txtPassword.Text))
                {
                    // 使用 BCrypt 加密新密码 [cite: 2026-02-09]
                    cmd.Parameters.AddWithValue("@pw", BCrypt.Net.BCrypt.HashPassword(txtPassword.Text));
                }

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // 同步 Session 确保全局头像即时刷新
            Session["profilePic"] = avatarPath;
            Response.Redirect("UserProfile.aspx");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserProfile.aspx");
        }
    }
}