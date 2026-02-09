<%@ Page Language="C#" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>CraftXiFu - Home</title>
    <link href="CSS/Style.css" rel="stylesheet" />
    <style>
        /* Home 页面专属样式 */
        .welcome-hero {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('Images/mc-landscape.jpg');
            background-size: cover;
            padding: 60px 20px;
            text-align: center;
            border: 6px solid #373737;
            margin-bottom: 30px;
        }

        .hero-title { font-size: 3em; text-shadow: 4px 4px #000; color: #FFF; }
        .hero-subtitle { font-size: 1.2em; color: #DDD; margin-top: 10px; }

        .update-section {
            background: #C6C6C6;
            border: 5px solid #373737;
            padding: 20px;
            color: #373737;
        }

        .version-tag {
            background: #3c8527;
            color: white;
            padding: 5px 15px;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 10px;
        }

        .update-list { list-style: none; padding: 0; }
        .update-list li { 
            padding: 10px; 
            border-bottom: 2px solid #8B8B8B;
            display: flex;
            align-items: center;
        }
        .update-list li::before {
            content: "■";
            margin-right: 10px;
            color: #3c8527;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            
            <div class="welcome-hero">
                <h1 class="hero-title">Welcome to CraftXiFu!</h1>
                <p class="hero-subtitle">
                    降低 Minecraft 学习曲线，开启你的生存大师之路。 [cite: 7]
                </p>
                <div style="margin-top: 20px;">
                    <asp:HyperLink ID="lnkStart" runat="server" NavigateUrl="BeginnerGuide.aspx" CssClass="mc-button" Text="Start Learning" />
                </div>
            </div>

            <div class="update-section">
                <div class="version-tag">LATEST VERSION: 1.21 (Tricky Trials)</div>
                <h2>What's New in Minecraft?</h2>
                <p>根据我们的数据库，以下是最新的官方 Java 版内容更新 ：</p>
                
                <ul class="update-list">
                    <li><strong>Trial Chambers:</strong> 探索全新的地下结构，挑战多种陷阱与生物。</li>
                    <li><strong>The Breeze:</strong> 面对操控风能的新敌对生物。</li>
                    <li><strong>Crafter:</strong> 革命性的全自动工作台，实现自动化合成的关键。</li>
                    <li><strong>New Blocks:</strong> 增加了多样的铜（Copper）和凝灰岩（Tuff）变体方块。</li>
                </ul>

                <div style="margin-top: 15px; font-style: italic;">
                    注意：本站内容主要针对 Java Edition。Bedrock 玩家请留意机制差异。 
                </div>
            </div>

            <div style="margin-top: 30px; display: flex; gap: 20px;">
                <asp:Button ID="btnFarms" runat="server" Text="View Auto Farms" CssClass="mc-button" PostBackUrl="Autofarm.aspx" />
                <asp:Button ID="btnMinigame" runat="server" Text="Play Daily Minigame" CssClass="mc-button" PostBackUrl="Minigame.aspx" />
            </div>

        </div>
    </form>
</body>
</html>