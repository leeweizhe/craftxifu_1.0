<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="Guides Hub" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<%-- 2. 导入命名空间 --%>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void Guide_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string guideName = btn.CommandArgument; 
        string targetUrl = "";

        switch (guideName)
        {
            case "AutoFarm": targetUrl = "AutoFarm.aspx"; break;
            case "Beginner": targetUrl = "/Lee Wei Zhe/aspx/BeginnerGuide.aspx"; break;
            case "Mob": targetUrl = "MobGuide.aspx"; break;
            case "Potion": targetUrl = "PotionGuide.aspx"; break;
        }

        // 数据库点击计数逻辑
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "UPDATE guideStatsTable SET ClickCount = ClickCount + 1 WHERE GuideName = @name";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@name", guideName);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        Response.Redirect(targetUrl);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* 核心修改：移除容器边距，让它填满宽度 */
        .guide-hub-wrapper { width: 100%; margin: 0; padding: 0; overflow: hidden; }
        
        /* 强制 4 列布局，不留间隙 */
        .guide-grid { 
            display: grid; 
            grid-template-columns: repeat(4, 1fr); 
            width: 100vw; 
            height: calc(100vh - 120px); /* 减去 nav 和 footer 的大致高度 */
            gap: 0; 
        }
        
        /* 卡片基础样式 */
        .guide-card { 
            position: relative; 
            height: 100%; 
            background: #000; 
            border: 1px solid #222; 
            overflow: hidden; 
            cursor: pointer; 
            display: block; 
            text-decoration: none; 
        }
        
        /* 边框交互：悬停时内部高亮 */
        .guide-card:hover { border: 2px solid #68ff00; z-index: 10; }
        
        /* 图片展示 */
        .card-img { width: 100%; height: 100%; object-fit: cover; transition: 0.6s; opacity: 0.7; }
        .guide-card:hover .card-img { opacity: 0.40; transform: scale(1.1); }

        /* 标题样式 */
        .card-title { 
            position: absolute; 
            bottom: 40px; 
            left: 0; 
            width: 100%; 
            color: #fff; 
            font-size: 2rem; 
            text-align: center;
            text-shadow: 3px 3px #000; 
            text-transform: uppercase; 
            font-family: 'Minecraft', sans-serif;
        }

        /* 介绍文本层（初始隐藏） */
        .card-intro { 
            position: absolute; 
            top: 0; 
            left: 0; 
            width: 100%; 
            height: 100%; 
            display: flex; 
            flex-direction: column;
            align-items: center; 
            justify-content: center; 
            padding: 30px; 
            box-sizing: border-box; 
            color: #68ff00; 
            font-size: 1.3rem; 
            opacity: 0; 
            transition: 0.5s; 
            text-align: center; 
            background: rgba(0,0,0,0.6);
        }
        .guide-card:hover .card-intro { opacity: 1; }
        
        .click-hint { font-size: 0.8rem; color: #fbbf24; margin-top: 20px; text-transform: uppercase; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="guide-hub-wrapper">
        <div class="guide-grid">

            <asp:LinkButton ID="btnBeginner" runat="server" CssClass="guide-card" OnClick="Guide_Click" CommandArgument="Beginner">
                <img src="/Wong Zhang Zhe/pic/beginner_cover.png" class="card-img" />
                <div class="card-title">Beginner</div>
                <div class="card-intro">
                    <p>A Beginner Guide covers the core loop of gathering, crafting, and building to help players survive their first few days. Beyond basic survival, it outlines the path to "beating" the game: players must collect resources to open a portal to The End, where defeating the Ender Dragon triggers the credits and completes the main progression.</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>

            <asp:LinkButton ID="btnMob" runat="server" CssClass="guide-card" OnClick="Guide_Click" CommandArgument="Mob">
                <img src="/Wong Zhang Zhe/pic/mob_cover.png" class="card-img" />
                <div class="card-title">Mob Bestiary</div>
                <div class="card-intro">
                    <p>A Mob Bestiary is a comprehensive guide or collection that details every creature (mob) found in Minecraft. It categorizes them by their behavior—Passive (friendly), Neutral (attacks if provoked), and Hostile (attacks on sight)—while providing vital info on their health, spawn locations, and the loot they drop.</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>

            <asp:LinkButton ID="btnPotion" runat="server" CssClass="guide-card" OnClick="Guide_Click" CommandArgument="Potion">
                <img src="/Wong Zhang Zhe/pic/potion_cover.png" class="card-img" />
                <div class="card-title">Potion & Enchantment</div>
                <div class="card-intro">
                    <p>Potions are consumable liquids from a Brewing Stand that grant temporary status effects like fire resistance or underwater breathing, essential for surviving extreme environments. Enchantments are permanent magical upgrades for gear applied via an Enchanting Table or Anvils, boosting power and durability for late-game challenges and boss fights.</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>

            <asp:LinkButton ID="btnAutoFarm" runat="server" CssClass="guide-card" OnClick="Guide_Click" CommandArgument="AutoFarm">
                <img src="/Wong Zhang Zhe/pic/autofarm_cover.png" class="card-img" />
                <div class="card-title">Auto Farm</div>
                <div class="card-intro">
                    <p>An Auto Farm is a player-made machine in Minecraft that harvests and stores resources without manual intervention. By using Redstone and game mechanics (like plant growth or mob spawning), it turns manual labor into a continuous, hands-free supply of items.</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>
        </div>
    </div>
</asp:Content>