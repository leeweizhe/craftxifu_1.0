<%@ Page Language="C#" %>
<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // 默认显示第一类
        if (!IsPostBack) { mvFarms.ActiveViewIndex = 0; }
        
        // 只有注册会员可以查看详细产量和发表评论 [cite: 13, 19, 136]
        bool isUser = (Session["UserID"] != null);
        phMemberOnly.Visible = isUser;
        lblGuestNotice.Visible = !isUser;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        // 搜索功能逻辑：根据输入关键词过滤显示内容
        string query = txtSearch.Text.Trim().ToLower();
        if (!string.IsNullOrEmpty(query))
        {
            lblSearchMsg.Text = "Searching results for: " + query;
            
            // 模拟搜索跳转逻辑
            if (query.Contains("iron") || query.Contains("gold")) mvFarms.ActiveViewIndex = 0;
            else if (query.Contains("stone") || query.Contains("bamboo")) mvFarms.ActiveViewIndex = 1;
            else if (query.Contains("creeper") || query.Contains("xp")) mvFarms.ActiveViewIndex = 2;
            else if (query.Contains("steak") || query.Contains("food")) mvFarms.ActiveViewIndex = 3;
        }
    }

    protected void ChangeCategory(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        mvFarms.ActiveViewIndex = int.Parse(btn.CommandArgument);
        lblSearchMsg.Text = ""; // 切换分类时重置搜索提示
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Auto Farm Library - CraftXiFu</title>
    <style type="text/css">
        /* 极致清晰度设计：全黑背景 + 纯白文字 */
        body { 
            background-color: #000000; 
            color: #FFFFFF; 
            font-family: 'Arial Black', Gadget, sans-serif; 
            margin: 0; 
            padding: 40px; 
            line-height: 1.5; 
        }
        .container { max-width: 1200px; margin: auto; }

        /* 超大号标题 [cite: 55] */
        h1 { color: #4ade80; font-size: 60px; text-transform: uppercase; margin-bottom: 40px; }
        h2 { font-size: 45px; color: #4ade80; border-bottom: 6px solid #4ade80; padding-bottom: 10px; margin-top: 50px; }
        h3 { font-size: 36px; margin: 15px 0; color: #FFF; }
        p, li { font-size: 28px; color: #EEEEEE; }

        /* 搜索区域样式 */
        .search-row { 
            display: flex; 
            gap: 20px; 
            margin-bottom: 60px; 
            background: #111; 
            padding: 25px; 
            border: 4px solid #444; 
        }
        .input-box { 
            flex-grow: 1; 
            font-size: 32px; 
            padding: 20px; 
            background: #000; 
            border: 3px solid #4ade80; 
            color: #FFF; 
        }
        .btn-search { 
            background: #4ade80; 
            color: #000; 
            font-size: 32px; 
            font-weight: bold; 
            padding: 20px 60px; 
            border: none; 
            cursor: pointer; 
        }

        /* 导航按钮样式  */
        .nav-row { display: flex; gap: 10px; margin-bottom: 50px; }
        .nav-btn { 
            background: #222; 
            color: #FFF; 
            font-size: 26px; 
            padding: 25px; 
            border: 3px solid #555; 
            cursor: pointer; 
            flex: 1; 
            font-weight: bold; 
        }
        .nav-btn:hover { background: #4ade80; color: #000; }

        /* 农场内容卡片 [cite: 69] */
        .farm-detail { 
            background: #111; 
            border: 4px solid #333; 
            border-radius: 20px; 
            padding: 40px; 
            margin-bottom: 40px; 
        }
        .stats-highlight { 
            background: #064e3b; 
            border-left: 20px solid #4ade80; 
            padding: 30px; 
            margin: 30px 0; 
        }
        .yield-text { color: #4ade80; font-size: 36px; font-weight: 900; }
        .materials { color: #fbbf24; font-size: 28px; font-weight: bold; list-style-type: "◈ "; }

        .lock-panel { 
            background: #450a0a; 
            border: 5px solid #FF0000; 
            padding: 40px; 
            font-size: 32px; 
            text-align: center; 
            color: #FFD700; 
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Auto Farm Library</h1>

            <div class="search-row">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="input-box" placeholder="Search farm (e.g. Iron)..." />
                <asp:Button ID="btnSearch" runat="server" Text="SEARCH" CssClass="btn-search" OnClick="btnSearch_Click" />
            </div>
            <asp:Label ID="lblSearchMsg" runat="server" Font-Size="26px" ForeColor="#4ade80" />

            <div class="nav-row">
                <asp:Button ID="btnMin" runat="server" Text="MINERALS" CommandArgument="0" OnClick="ChangeCategory" CssClass="nav-btn" />
                <asp:Button ID="btnBld" runat="server" Text="BUILDING" CommandArgument="1" OnClick="ChangeCategory" CssClass="nav-btn" />
                <asp:Button ID="btnMob" runat="server" Text="MOBS" CommandArgument="2" OnClick="ChangeCategory" CssClass="nav-btn" />
                <asp:Button ID="btnFood" runat="server" Text="FOOD" CommandArgument="3" OnClick="ChangeCategory" CssClass="nav-btn" />
            </div>

            <asp:MultiView ID="mvFarms" runat="server">
                
                <asp:View runat="server">
                    <h2>Mineral Extraction Units</h2>
                    <div class="farm-detail">
                        <h3>Village Iron Golem Farm (Basic)</h3>
                        <p>Uses villager mechanics to spawn iron golems. Safe for beginners. [cite: 7]</p>
                        <div class="stats-highlight">
                            <strong>MATERIALS:</strong>
                            <ul class="materials">
                                <li>3 Beds, 3 Workstations</li>
                                <li>1 Zombie (Nametagged)</li>
                            </ul>
                            <span class="yield-text">YIELD: 320 INGOTS / HOUR</span>
                        </div>
                    </div>
                    <div class="farm-detail">
                        <h3>Nether Gold Portal Farm</h3>
                        <p>High-yield farm focusing on gold nuggets and XP. [cite: 61]</p>
                        <span class="yield-text">YIELD: 850 NUGGETS / HOUR</span>
                    </div>
                </asp:View>

                <asp:View runat="server">
                    <h2>Construction Resource Units</h2>
                    <div class="farm-detail">
                        <h3>Infinite Cobblestone Gen</h3>
                        <p>Automated stone generation using lava and water. [cite: 62]</p>
                        <div class="stats-highlight">
                            <ul class="materials">
                                <li>Lava & Water Sources</li>
                                <li>Pistons & Redstone Clock</li>
                            </ul>
                            <span class="yield-text">YIELD: 1200 BLOCKS / HOUR</span>
                        </div>
                    </div>
                </asp:View>

                <asp:View runat="server">
                    <h2>Hostile Mob Grinders</h2>
                    <div class="farm-detail">
                        <h3>Creeper Gunpowder Farm</h3>
                        <p>Essential for TNT and rocket fuel production. [cite: 69]</p>
                        <span class="yield-text">YIELD: 650 GUNPOWDER / HOUR</span>
                    </div>
                </asp:View>

                <asp:View runat="server">
                    <h2>Automated Agriculture</h2>
                    <div class="farm-detail">
                        <h3>Villager Crop Automation</h3>
                        <p>Automated harvesting of carrots and potatoes. [cite: 61]</p>
                        <span class="yield-text">YIELD: 450 ITEMS / HOUR</span>
                    </div>
                </asp:View>

            </asp:MultiView>

            <asp:PlaceHolder ID="phMemberOnly" runat="server">
                <div style="background:#111; padding:40px; border:4px solid #4ade80; margin-top:50px;">
                    <h2 style="margin-top:0;">Member Feedback</h2>
                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="3" Width="100%" Font-Size="28px" BackColor="#000" ForeColor="#FFF" />
                    <asp:Button ID="btnPost" runat="server" Text="POST COMMENT" CssClass="btn-search" Style="margin-top:20px;" />
                </div>
            </asp:PlaceHolder>

            <asp:Label ID="lblGuestNotice" runat="server" CssClass="lock-panel" Style="display:block;">
                🔒 NOTICE: Sign in to unlock expert efficiency tips and feedback. [cite: 15, 94]
            </asp:Label>
        </div>
    </form>
</body>
</html>