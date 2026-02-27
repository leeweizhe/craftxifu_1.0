<%-- 1. 页面指令 --%>
<%@ Page Title="Farm Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间 --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // 获取 URL 传过来的 id 参数
        string farmId = Request.QueryString["id"];

        if (!string.IsNullOrEmpty(farmId))
        {
            LoadFarmDetails(farmId);
        }
        else
        {
            Response.Redirect("AutoFarm.aspx"); // 没有 ID 则返回列表
        }
    }

    private void LoadFarmDetails(string id)
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT * FROM farmTable WHERE FarmId = @id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", id);
            
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                lblTitle.Text = reader["Title"].ToString();
                lblDesc.Text = reader["Description"].ToString();
                lblEfficiency.Text = reader["Efficiency"].ToString();
                litContent.Text = reader["FullContent"].ToString();

                // 绑定视频 URL (假设是 YouTube 嵌入格式)
                string videoUrl = reader["VideoUrl"].ToString();
                if (!string.IsNullOrEmpty(videoUrl))
                {
                    videoFrame.Src = videoUrl.Replace("watch?v=", "embed/"); 
                    videoPanel.Visible = true;
                }
            }
            conn.Close();
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .detail-container { width: 85%; margin: 30px auto; color: #fff; background: rgba(0,0,0,0.9); padding: 40px; border: 4px solid #444; }
        .back-link { color: #68ff00; text-decoration: none; font-weight: bold; margin-bottom: 20px; display: inline-block; }
        .farm-header { border-bottom: 3px solid #68ff00; padding-bottom: 15px; margin-bottom: 30px; }
        .efficiency-badge { background: #fbbf24; color: #000; padding: 5px 15px; font-weight: bold; float: right; }
        
        /* 视频容器 */
        .video-wrapper { position: relative; padding-bottom: 56.25%; height: 0; margin: 30px 0; border: 3px solid #333; }
        .video-wrapper iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        
        .content-box { line-height: 1.8; font-size: 1.1rem; color: #ccc; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="detail-container">
        <a href="AutoFarm.aspx" class="back-link"><< BACK TO DATABASE</a>
        
        <div class="farm-header">
            <span class="efficiency-badge">RANK: <asp:Label ID="lblEfficiency" runat="server" /></span>
            <h1 style="font-size: 2.5rem; color: #68ff00; margin: 0;"><asp:Label ID="lblTitle" runat="server" /></h1>
        </div>

        <p style="font-size: 1.3rem; color: #fbbf24;"><asp:Label ID="lblDesc" runat="server" /></p>

        <%-- 视频播放区域 --%>
        <asp:Panel ID="videoPanel" runat="server" Visible="false">
            <h3 style="color:#68ff00; margin-top:40px;">[ VIDEO TUTORIAL ]</h3>
            <div class="video-wrapper">
                <iframe id="videoFrame" runat="server" frameborder="0" allowfullscreen></iframe>
            </div>
        </asp:Panel>

        <%-- 详细图文区域 --%>
        <h3 style="color:#68ff00; margin-top:40px;">[ STEP-BY-STEP GUIDE ]</h3>
        <div class="content-box">
            <asp:Literal ID="litContent" runat="server" />
        </div>
    </div>
</asp:Content>