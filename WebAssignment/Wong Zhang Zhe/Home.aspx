<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="Home - Minecraft Server Hub" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间 --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Session["UserId"] = 5;
        if (Session["UserId"] != null)
        {
            visitorSection.Visible = false;
            memberSection.Visible = true;
            memberDataCards.Visible = true; // 登录后显示数据卡片
            LoadUserStatus();
        }
        else
        {
            visitorSection.Visible = true;
            memberSection.Visible = false;
            memberDataCards.Visible = false; // 访客隐藏数据卡片
        }
    }

    private void LoadUserStatus()
    {
        int userId = Convert.ToInt32(Session["UserId"]);
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT Currency FROM userTable WHERE UserId = @id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@id", userId);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                lblEmeralds.Text = reader["Currency"].ToString();
            }
            conn.Close();
        }
    }

    protected void btnLoginRedirect_Click(object sender, EventArgs e)
    {
        Response.Redirect("../Lee Wei Zhe/aspx/Login.aspx"); 
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .home-wrapper { width: 100%; color: #fff; font-family: 'Minecraft', sans-serif; }
        
        /* Hero Section - 所有人可见 */
        .hero-banner { 
            background: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.8)), url('/Wong Zhang Zhe/pic/autofarm_cover.png');
            background-size: cover;
            background-position: center;
            padding: 100px 10%;
            text-align: center;
            border-bottom: 5px solid #68ff00;
        }
        .hero-title { font-size: 4.5rem; color: #68ff00; text-shadow: 4px 4px #000; margin-bottom: 20px; }
        .hero-subtitle { font-size: 1.3rem; color: #ddd; max-width: 800px; margin: 0 auto; line-height: 1.6; }
        
        /* 会员状态栏 */
        .status-bar { 
            background: #111; padding: 20px 10%; display: flex; justify-content: space-around; 
            border-bottom: 1px solid #333; font-size: 1.2rem;
        }
        .status-item span { color: #fbbf24; margin-left: 10px; }

        /* 介绍区域 - 所有人可见 */
        .about-section { padding: 60px 10%; background: #0a0a0a; text-align: center; border-bottom: 1px solid #222; }
        .about-title { color: #68ff00; font-size: 2rem; margin-bottom: 20px; text-transform: uppercase; }
        
        /* 模块化卡片区域 - 仅限会员 */
        .main-content-area { padding: 40px 10%; background: #000; }
        .dashboard-grid { 
            display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
            gap: 25px; 
        }
        .modern-card { background: rgba(20,20,20,0.9); border: 2px solid #333; padding: 25px; transition: 0.3s; }
        .modern-card:hover { border-color: #68ff00; }
        .card-header { color: #68ff00; border-bottom: 2px solid #68ff00; padding-bottom: 10px; margin-bottom: 20px; }

        .progress-container { background: #222; height: 12px; border: 1px solid #444; margin: 15px 0; }
        .progress-fill { background: #68ff00; height: 100%; width: 75%; box-shadow: 0 0 10px #68ff00; }

        .action-btn { 
            background: #68ff00; color: #000; padding: 15px 40px; border: none; 
            cursor: pointer; font-size: 1.1rem; font-weight: bold; margin-top: 30px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="home-wrapper">
        
        <div class="hero-banner">
            <asp:Panel ID="memberSection" runat="server">
                <h1 class="hero-title">SYSTEM ONLINE</h1>
                <p class="hero-subtitle">Welcome to the Command Center. Your automated empire awaits. Monitor your resources and manage your technical support tickets from this hub.</p>
            </asp:Panel>

            <asp:Panel ID="visitorSection" runat="server">
                <h1 class="hero-title">MINECRAFT COMMUNITY</h1>
                <p class="hero-subtitle">The ultimate destination for Minecraft technical players. Learn to build advanced Auto Farms, master Alchemy, and optimize your survival experience.</p>
                <asp:Button ID="btnLoginRedirect" runat="server" Text="[ INITIALIZE LOGIN ]" OnClick="btnLoginRedirect_Click" CssClass="action-btn" />
            </asp:Panel>
        </div>

        <% if (Session["UserId"] != null) { %>
        <div class="status-bar">
            <div class="status-item">TREASURY: <span><asp:Label ID="lblEmeralds" runat="server" /> 💎</span></div>
            <div class="status-item">SERVER STATUS: <span style="color:#68ff00;">STABLE</span></div>
            <div class="status-item">GLOBAL RANK: <span>#42</span></div>
        </div>
        <% } %>

        <div class="about-section">
            <h2 class="about-title">What is Minecraft Hub?</h2>
            <p style="color:#aaa; line-height:1.8; max-width:900px; margin:0 auto;">
                Our platform provides professional-grade tools for players to track their survival progress. 
                From our <b>Auto Farm Database</b> featuring Redstone innovations, to our comprehensive <b>Bestiary</b>, 
                we ensure every member has the knowledge to dominate their world.
            </p>
        </div>

        <asp:Panel ID="memberDataCards" runat="server" CssClass="main-content-area">
            <div class="dashboard-grid">
                <div class="modern-card">
                    <h3 class="card-header">Live Quest</h3>
                    <p>Emerald Tycoon: 750 / 1000</p>
                    <div class="progress-container"><div class="progress-fill"></div></div>
                    <small style="color:#888;">Reward: [Merchant] Prefix</small>
                </div>

                <div class="modern-card">
                    <h3 class="card-header">Server Intel</h3>
                    <p style="margin-bottom:10px;"><b style="color:#fbbf24;">[!]</b> Maintenance on March 1st.</p>
                    <p><b style="color:#68ff00;">[+]</b> New Support Ticket system active. [cite: 2026-02-09]</p>
                </div>

                <div class="modern-card">
                    <h3 class="card-header">Quick Access</h3>
                    <ul style="list-style:none; padding:0; line-height:2;">
                        <li><a href="AutoFarm.aspx" style="color:#fff; text-decoration:none;">> Farm Database</a></li>
                        <li><a href="Guide.aspx" style="color:#fff; text-decoration:none;">> Training Center</a></li>
                        <li><a href="ContactUs.aspx" style="color:#fff; text-decoration:none;">> Open Support Ticket</a></li>
                    </ul>
                </div>
            </div>
        </asp:Panel>

    </div>
</asp:Content>