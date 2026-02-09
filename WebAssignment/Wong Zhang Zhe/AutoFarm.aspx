<%@ Page Language="C#" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // 检查用户是否登录 (Check if user is logged in)
        // 实际运行时，Session["UserID"] 会在 Login.aspx 登录成功后设置
        bool IsLoggedIn = (Session["UserID"] != null);

        // 根据权限控制反馈区域的显示
        phMemberFeedback.Visible = IsLoggedIn;
        lblVisitorNotice.Visible = !IsLoggedIn;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CraftXiFu - Auto Farm Guides</title>
    <style type="text/css">
        /* Minecraft 风格 CSS 样式 */
        body { 
            background-color: #313233; 
            color: #FFFFFF; 
            font-family: 'Segoe UI', Arial, sans-serif; 
            margin: 0; padding: 20px;
        }

        .container { max-width: 1000px; margin: auto; }

        /* 搜索栏样式 */
        .search-section {
            background: #C6C6C6;
            border: 4px solid #555;
            padding: 15px;
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }
        .mc-input { 
            flex-grow: 1; 
            border: 2px solid #373737; 
            padding: 10px; 
            background: #FFF;
        }

        /* 选项卡样式 - 模拟 Minecraft 快捷栏 (Hotbar) */
        .tabs-row { display: flex; gap: 5px; margin-bottom: 20px; }
        .tab-item {
            background: #8B8B8B;
            border: 4px solid #373737;
            padding: 10px 20px;
            cursor: pointer;
            font-weight: bold;
            color: #DDD;
        }
        .tab-item.active { background: #C6C6C6; color: #000; border-color: #FFF; }

        /* 卡片网格布局 */
        .farm-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }

        .farm-card {
            background: #C6C6C6;
            border: 4px solid #1E1E1E;
            color: #333;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .card-img { width: 100%; height: 180px; background: #555; object-fit: cover; }
        .card-body { padding: 15px; flex-grow: 1; }

        /* 难度标签样式 */
        .badge {
            position: absolute; top: 10px; left: 10px;
            padding: 5px 10px; font-weight: bold; color: #FFF;
            border: 2px solid #000;
        }
        .easy { background: #3c8527; }
        .medium { background: #e28e00; }
        .hard { background: #aa0000; }

        /* 锁定覆盖层 (针对 Visitor) */
        .lock-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.85);
            display: flex; flex-direction: column;
            justify-content: center; align-items: center;
            color: #FFD700; text-align: center; padding: 10px;
            z-index: 10;
        }

        /* 按钮样式 */
        .mc-button {
            background: #8B8B8B;
            border: 3px solid #000;
            color: white;
            padding: 8px 15px;
            cursor: pointer;
            box-shadow: inset -3px -3px #5A5A5A;
        }
        .mc-button:hover { background: #C6C6C6; color: #000; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1 style="text-shadow: 2px 2px #000;">[CraftXiFu] Automated Farms</h1>

            <div class="search-section">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="mc-input" placeholder="Search for farms (Iron, Gold, etc.)..." />
                <asp:Button ID="btnSearch" runat="server" Text="SEARCH" CssClass="mc-button" />
            </div>

            <div class="tabs-row">
                <div class="tab-item active">IRON (刷铁机)</div>
                <div class="tab-item">STONE (刷石机)</div>
                <div class="tab-item">MOB (刷怪)</div>
                <div class="tab-item">FOOD (食物)</div>
            </div>

            <div class="farm-grid">
                
                <div class="farm-card">
                    <div class="badge easy">EASY</div>
                    <img src="https://via.placeholder.com/300x180?text=Simple+Iron+Farm" class="card-img" alt="Iron Farm" />
                    <div class="card-body">
                        <h3>Village Iron Golem Farm</h3>
                        <p>适合生存初期的简易刷铁机，仅需3名村民。 [cite: 7]</p>
                        <div style="font-size: 0.8em; color: #555;">👍 150 Likes</div>
                    </div>
                </div>

                <div class="farm-card">
                    <div class="badge hard">HARD</div>
                    
                    <%-- 逻辑判断：如果用户未登录，显示锁定层 --%>
                    <% if (Session["UserID"] == null) { %>
                    <div class="lock-overlay">
                        <h2 style="margin:0;">🔒 LOCKED</h2>
                        <p>Deep-dive guides are for members only. [cite: 13]</p>
                        <asp:HyperLink runat="server" NavigateUrl="Login.aspx" CssClass="mc-button" Text="LOGIN TO UNLOCK" />
                    </div>
                    <% } %>

                    <img src="https://via.placeholder.com/300x180?text=Mega+Iron+Titan" class="card-img" alt="Hard Farm" />
                    <div class="card-body">
                        <h3>Iron Titan v2.0</h3>
                        <p>高效率工业刷铁机，每小时产出极高。 [cite: 9]</p>
                    </div>
                </div>

            </div>

            <div style="margin-top: 40px; padding: 20px; background: #444; border: 4px solid #000;">
                <h2 style="margin-top:0;">Community Feedback</h2>
                
                <asp:PlaceHolder ID="phMemberFeedback" runat="server">
                    <p>Share your tips or ask questions about these farms: [cite: 19]</p>
                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="3" Width="100%" CssClass="mc-input" />
                    <br /><br />
                    <asp:Button ID="btnPost" runat="server" Text="POST COMMENT" CssClass="mc-button" />
                </asp:PlaceHolder>

                <asp:Label ID="lblVisitorNotice" runat="server" ForeColor="#FFD700" Font-Bold="true">
                    Notice: Please sign in to leave feedback or likes. [cite: 94]
                </asp:Label>
            </div>

        </div>
    </form>
</body>
</html>