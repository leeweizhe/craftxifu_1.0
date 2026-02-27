<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="User Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间，解决编译错误 --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // 临时设置测试 ID，防止未登录重定向
        Session["UserId"] = 5;

        if (Session["UserId"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else if (!IsPostBack)
        {
            try {
                int currentUserId = Convert.ToInt32(Session["UserId"]);
                LoadUserData(currentUserId);
            }
            catch (Exception) {
                Response.Redirect("Login.aspx");
            }
        }
    }

    private void LoadUserData(int userId)
    {
        // 使用 Web.config 中的 "ConnectionString"
        var connSettings = ConfigurationManager.ConnectionStrings["ConnectionString"];
        if (connSettings == null) return;

        string connString = connSettings.ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT * FROM userTable WHERE UserId = @id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", userId);

            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                // 将数据库数据绑定到 Label 控件
                lblFullName.Text = reader["FName"].ToString() + " " + reader["LName"].ToString();
                lblUsername.Text = "@" + reader["Username"].ToString();
                lblEmail.Text = reader["Email"].ToString();
                lblRole.Text = reader["Role"].ToString();
                lblCountry.Text = reader["Country"].ToString();
                lblCurrency.Text = reader["Currency"].ToString();
                
                // 处理 Bio 为空的情况
                lblBio.Text = reader["Bio"] != DBNull.Value && !string.IsNullOrEmpty(reader["Bio"].ToString()) 
                               ? reader["Bio"].ToString() : "No bio available.";
                
                // 绑定头像路径
                imgAvatar.ImageUrl = reader["ProfilePicture"].ToString();
            }
            conn.Close();
        }
    }

    // 处理跳转到编辑页面的逻辑
    protected void btnGoToEdit_Click(object sender, EventArgs e)
    {
        // 使用相对路径跳转，前提是两个文件在同一文件夹
        Response.Redirect("EditProfile.aspx"); 
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* 保持 Minecraft 像素风格 UI */
        .profile-box { background: rgba(0,0,0,0.9); border: 5px solid #464646; padding: 50px; width: 85%; margin: 40px auto; color: #FFF; box-shadow: 0 0 20px rgba(104, 255, 0, 0.3); }
        .header-flex { display: flex; align-items: center; gap: 40px; border-bottom: 4px solid #68ff00; padding-bottom: 30px; }
        .avatar-frame { width: 180px; height: 180px; border: 4px solid #68ff00; image-rendering: pixelated; object-fit: cover; }
        .name-main { font-size: 3.5rem; color: #68ff00; margin: 0; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-top: 40px; }
        .data-item { background: #111; padding: 25px; border: 2px solid #333; }
        .label-text { color: #68ff00; font-size: 1.4rem; text-transform: uppercase; display: block; }
        .value-text { font-size: 2.2rem; display: block; margin-top: 10px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-box">
        <div class="header-flex">
            <asp:Image ID="imgAvatar" runat="server" CssClass="avatar-frame" />
            <div>
                <asp:Label ID="lblFullName" runat="server" CssClass="name-main" />
                <br />
                <asp:Label ID="lblUsername" runat="server" style="color:#999; font-size:1.8rem;" />
                <br />
                <span style="border: 2px solid #68ff00; padding: 5px 15px; color: #68ff00; font-size: 1.2rem; display: inline-block; margin-top: 10px;">
                    Rank: <asp:Label ID="lblRole" runat="server" />
                </span>
            </div>
        </div>

        <div class="info-grid">
            <div class="data-item">
                <span class="label-text">Email Address</span>
                <asp:Label ID="lblEmail" runat="server" CssClass="value-text" />
            </div>
            <div class="data-item">
                <span class="label-text">Origin / Country</span>
                <asp:Label ID="lblCountry" runat="server" CssClass="value-text" />
            </div>
            <div class="data-item">
                <span class="label-text">Emerald Balance</span>
                <asp:Label ID="lblCurrency" runat="server" CssClass="value-text" style="color:#fbbf24;" />
            </div>
            <div class="data-item">
                <span class="label-text">Biography</span>
                <asp:Label ID="lblBio" runat="server" CssClass="value-text" style="font-size:1.6rem;" />
            </div>
        </div>

        <asp:Button ID="btnGoToEdit" runat="server" 
            Text="[ EDIT CHARACTER INFO ]" 
            style="margin-top:20px; background:none; border:2px solid #68ff00; color:#68ff00; padding:10px 20px; cursor:pointer; font-weight:bold;" 
            OnClick="btnGoToEdit_Click" />
    </div>
</asp:Content>