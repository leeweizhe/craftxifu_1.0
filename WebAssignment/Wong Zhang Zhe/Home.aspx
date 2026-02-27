<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="Home - Minecraft Server Hub" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间 --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // 根据 Session 判断显示内容：登录玩家显示专属面板，访客显示引导面板

        //Session["UserId"] = 5;
        if (Session["UserId"] != null)
        {
            visitorPanel.Visible = false;
            playerPanel.Visible = true;
            memberExclusiveSection.Visible = true; // 开启 Member 专属区域
            LoadUserStatus();
        }
        else
        {
            visitorPanel.Visible = true;
            playerPanel.Visible = false;
            memberExclusiveSection.Visible = false; // 隐藏 Member 专属区域
        }
    }

    private void LoadUserStatus()
    {
        int userId = Convert.ToInt32(Session["UserId"]);
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            // 从 userTable 抓取 Member 的实时数据
            string sql = "SELECT Username, Role, Currency, ProfilePicture FROM userTable WHERE UserId = @id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", userId);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                lblPlayerName.Text = reader["Username"].ToString().ToUpper();
                lblRoleDisplay.Text = reader["Role"].ToString();
                lblEmeralds.Text = reader["Currency"].ToString();
                imgSmallAvatar.ImageUrl = reader["ProfilePicture"].ToString();
            }
            conn.Close();
        }
    }

    // 跨文件夹跳转至邻居 Lee Wei Zhe 的登录页
    protected void btnLoginRedirect_Click(object sender, EventArgs e)
    {
        Response.Redirect("../Lee Wei Zhe/aspx/Login.aspx"); 
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .home-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 30px; width: 90%; margin: 30px auto; color: #fff; }
        
        /* 介绍区域样式 */
        .intro-box { background: rgba(0,0,0,0.85); border-left: 10px solid #68ff00; padding: 40px; }
        .intro-title { font-size: 3rem; color: #68ff00; margin-bottom: 20px; text-transform: uppercase; }
        
        /* Member 专属仪表盘样式 */
        .member-dashboard { background: rgba(17, 17, 17, 0.95); border: 2px solid #68ff00; padding: 30px; margin-top: 25px; box-shadow: 0 0 15px rgba(104, 255, 0, 0.2); }
        .quest-bar-bg { background: #333; height: 20px; width: 100%; border-radius: 10px; margin: 15px 0; overflow: hidden; border: 1px solid #444; }
        .quest-bar-fill { background: linear-gradient(90deg, #52cc00, #68ff00); height: 100%; width: 75%; /* 模拟进度 */ box-shadow: 0 0 10px #68ff00; }
        
        .status-card { background: #111; border: 3px solid #333; padding: 30px; position: sticky; top: 20px; }
        .section-header { border-bottom: 2px solid #68ff00; padding-bottom: 10px; margin-bottom: 20px; color: #68ff00; text-transform: uppercase; letter-spacing: 2px; }
        
        /* 按钮与交互 */
        .login-btn { background: #68ff00; color: #000; padding: 15px; display: block; text-align: center; font-weight: bold; margin-top: 20px; border: none; cursor: pointer; width: 100%; font-size: 1.2rem; }
        .login-btn:hover { background: #52cc00; box-shadow: 0 0 10px #68ff00; }
        
        .stat-line { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
        .avatar-small { width: 55px; height: 55px; border: 2px solid #68ff00; image-rendering: pixelated; object-fit: cover; }
        
        .info-pill { background: #222; padding: 15px; border: 1px solid #444; text-align: center; }
        .info-pill span { display: block; font-size: 1.5rem; color: #fbbf24; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="home-grid">
        <div>
            <div class="intro-box">
                <h1 class="intro-title">Server Command Center</h1>
                <p style="font-size: 1.2rem; line-height: 1.8; color: #ccc;">
                    Welcome back to the Realm. As a registered member, you have access to advanced tracking tools and server-wide statistics. 
                    Prepare your gear, manage your treasury, and dominate the leaderboard.
                </p>
            </div>

            <%-- Member 专属内容面板 --%>
            <asp:Panel ID="memberExclusiveSection" runat="server">
                <div class="member-dashboard">
                    <h3 class="section-header">Live Quest: Emerald Tycoon</h3>
                    <div style="display:flex; justify-content:space-between; color:#fbbf24;">
                        <span>Progress: 750 / 1000 Emeralds</span>
                        <span>75%</span>
                    </div>
                    <div class="quest-bar-bg">
                        <div class="quest-bar-fill"></div>
                    </div>
                    <p style="font-size: 0.9rem; color: #888; margin-top: 5px;">*Complete this quest to earn the [Merchant] Rank and bonus loot.</p>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; margin-top: 30px;">
                        <div class="info-pill">
                            <small>PVP KILLS</small>
                            <span>128</span>
                        </div>
                        <div class="info-pill">
                            <small>WORLD RANK</small>
                            <span>#42</span>
                        </div>
                        <div class="info-pill">
                            <small>UPGRADE STATUS</small>
                            <span style="font-size: 1rem; color:#68ff00;">ELIGIBLE</span>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <div class="news-box" style="margin-top: 40px;">
                <h3 class="section-header">Latest Server Intel</h3>
                <div style="background: #1a1a1a; padding: 20px; border-left: 4px solid #fbbf24; margin-bottom: 15px;">
                    <strong style="color:#fbbf24;">[MAINTENANCE]</strong> Server hardware upgrade scheduled for March 1st.
                </div>
                <div style="background: #1a1a1a; padding: 20px; border-left: 4px solid #68ff00;">
                    <strong style="color:#68ff00;">[NEW FEATURE]</strong> Use the Contact Us page to request Rank Upgrades directly. [cite: 2026-02-09]
                </div>
            </div>
        </div>

        <div>
            <%-- 登录玩家状态卡片 --%>
            <asp:Panel ID="playerPanel" runat="server" CssClass="status-card">
                <h3 class="section-header">Active Character</h3>
                <div class="stat-line">
                    <asp:Image ID="imgSmallAvatar" runat="server" CssClass="avatar-small" />
                    <div>
                        <asp:Label ID="lblPlayerName" runat="server" style="font-weight:bold; font-size:1.4rem;" /><br />
                        <span style="color:#fbbf24; font-size:0.9rem;">RANK: <asp:Label ID="lblRoleDisplay" runat="server" /></span>
                    </div>
                </div>
                <div style="background:#000; padding:20px; border:1px solid #333; margin-top:20px; text-align:center;">
                    <small style="color:#888;">CURRENT TREASURY</small><br />
                    <span style="font-size:2rem; color:#68ff00;"><asp:Label ID="lblEmeralds" runat="server" /> 💎</span>
                </div>
            </asp:Panel>

            <%-- 访客引导卡片 --%>
            <asp:Panel ID="visitorPanel" runat="server" CssClass="status-card">
                <h3 class="section-header">Restricted Access</h3>
                <p style="color:#aaa; line-height:1.6;">
                    You are viewing the hub as a Guest. Join the server to unlock your personalized dashboard and track your survival progress.
                </p>
                <asp:Button ID="btnLoginRedirect" runat="server" Text="[ LOGIN TO UNLOCK ]" OnClick="btnLoginRedirect_Click" CssClass="login-btn" />
                <p style="text-align:center; margin-top:20px;">
                    <%-- 跨文件夹跳转至邻居 Lee Wei Zhe 的注册页 --%>
                    <a href="../Lee Wei Zhe/aspx/RegistrationPage.aspx" style="color:#68ff00; font-size:0.9rem; text-decoration:none;">
                        Become a Member? Register here
                    </a>
                </p>
            </asp:Panel>
        </div>
    </div>
</asp:Content>