<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="Farm Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间 --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string farmId = Request.QueryString["id"];

        if (!string.IsNullOrEmpty(farmId))
        {
            LoadFarmDetails(farmId);
        }
        else
        {
            Response.Redirect("AutoFarm.aspx");
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
                // 1. 绑定基础文字信息
                lblTitle.Text = reader["Title"].ToString();
                lblDesc.Text = reader["Description"].ToString();
                lblEfficiency.Text = reader["Efficiency"].ToString();
                litContent.Text = reader["FullContent"].ToString();

                // 2. 绑定详情页大图
                imgFarmDisplay.ImageUrl = reader["DetailImage"].ToString();

                // 3. 绑定材料清单图片 (新功能)
                string matImg = reader["MaterialImage"].ToString();
                if (!string.IsNullOrEmpty(matImg))
                {
                    imgMaterial.ImageUrl = matImg;
                    materialPanel.Visible = true;
                }

                // 4. 处理视频 URL (兼容长短链接)
                string videoUrl = reader["VideoUrl"].ToString();
                if (!string.IsNullOrEmpty(videoUrl))
                {
                    string finalEmbedUrl = "";
                    if (videoUrl.Contains("watch?v=")) {
                        finalEmbedUrl = videoUrl.Replace("watch?v=", "embed/");
                    }
                    else if (videoUrl.Contains("youtu.be/")) {
                        finalEmbedUrl = videoUrl.Replace("youtu.be/", "www.youtube.com/embed/");
                    }
                    videoFrame.Src = finalEmbedUrl;
                    videoPanel.Visible = true;
                }
            }
            conn.Close();
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .detail-container { width: 85%; margin: 30px auto; color: #fff; background: rgba(0,0,0,0.92); padding: 40px; border: 4px solid #444; }
        .back-link { color: #68ff00; text-decoration: none; font-weight: bold; margin-bottom: 25px; display: inline-block; }
        .farm-header { border-bottom: 3px solid #68ff00; padding-bottom: 15px; margin-bottom: 30px; }
        .efficiency-badge { background: #fbbf24; color: #000; padding: 5px 15px; font-weight: bold; float: right; }
        
        /* 图片通用样式 */
        .pixel-img { width: 100%; border: 4px solid #68ff00; margin-bottom: 30px; image-rendering: pixelated; object-fit: cover; }
        .mat-img { max-width: 600px; border: 2px dashed #fbbf24; display: block; margin: 0 auto; }
        
        /* 视频容器 */
        .video-wrapper { position: relative; padding-bottom: 56.25%; height: 0; margin: 20px 0; border: 3px solid #333; background: #000; }
        .video-wrapper iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        
        .content-box { line-height: 1.8; font-size: 1.1rem; color: #ddd; background: #1a1a1a; padding: 25px; border: 1px solid #333; }
        .section-label { color: #68ff00; text-transform: uppercase; margin-top: 40px; display: block; font-size: 1.4rem; border-left: 5px solid #68ff00; padding-left: 15px; margin-bottom: 15px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="detail-container">
        <a href="AutoFarm.aspx" class="back-link"><< BACK TO DATABASE</a>
        
        <div class="farm-header">
            <span class="efficiency-badge">RANK: <asp:Label ID="lblEfficiency" runat="server" /></span>
            <h1 style="font-size: 2.8rem; color: #68ff00; margin: 0;"><asp:Label ID="lblTitle" runat="server" /></h1>
        </div>

        <p style="font-size: 1.4rem; color: #fbbf24; margin-bottom: 30px;"><asp:Label ID="lblDesc" runat="server" /></p>

        <%-- 1. 预览大图 --%>
        <span class="section-label">Gallery / Preview</span>
        <asp:Image ID="imgFarmDisplay" runat="server" CssClass="pixel-img" />

        <%-- 2. 视频教程 --%>
        <asp:Panel ID="videoPanel" runat="server" Visible="false">
            <span class="section-label">Video Tutorial</span>
            <div class="video-wrapper">
                <iframe id="videoFrame" runat="server" frameborder="0" allowfullscreen></iframe>
            </div>
        </asp:Panel>

        <%-- 3. 材料清单 (新增加部分) --%>
        <asp:Panel ID="materialPanel" runat="server" Visible="false">
            <span class="section-label">Required Materials</span>
            <div style="text-align:center; padding: 20px; background: rgba(0,0,0,0.5); margin-bottom: 30px;">
                <asp:Image ID="imgMaterial" runat="server" CssClass="mat-img" />
            </div>
        </asp:Panel>

        <%-- 4. 详细步骤 --%>
        <span class="section-label"> Description </span>
        <div class="content-box">
            <asp:Literal ID="litContent" runat="server" />
        </div>
    </div>
</asp:Content>