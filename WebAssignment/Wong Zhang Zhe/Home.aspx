<%@ Page Title="Home - Minecraft Server Hub" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="WebAssignment.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* Dark gray gradient background */
        body { background-color: #0d0d0d; }
        .home-wrapper { width: 100%; color: #fff; font-family: 'Minecraft', sans-serif; background: linear-gradient(180deg, #1a1a1a 0%, #0d0d0d 100%); }
        
        /* hero-banner */
        .hero-banner { 
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.7)), url('/Wong Zhang Zhe/pic/home_cover.png');
            background-size: cover; background-position: center; padding: 120px 10%; text-align: center; border-bottom: 4px solid #68ff00;
        }
        .hero-title { font-size: 4.5rem; color: #68ff00; text-shadow: 4px 4px #000; margin-bottom: 20px; }
        .hero-subtitle { font-size: 1.3rem; color: #ddd; max-width: 800px; margin: 0 auto; line-height: 1.6; }

        /* status */
        .status-bar { background: rgba(30, 30, 30, 0.8); backdrop-filter: blur(10px); padding: 25px 10%; display: flex; justify-content: space-around; border-bottom: 1px solid #333; }
        .status-item { font-size: 1.1rem; text-transform: uppercase; }
        .status-item span { color: #fbbf24; font-weight: bold; margin-left: 8px; }

        /* Quick Access */
        .quick-access-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 30px; }
        .qa-card { 
            background: #1a1a1a; border: 2px solid #333; padding: 30px 20px; text-align: center; 
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); text-decoration: none; color: #fff; display: block;
        }
        .qa-card:hover { border-color: #68ff00; transform: translateY(-10px); background: #252525; box-shadow: 0 10px 30px rgba(104, 255, 0, 0.2); }
        .qa-icon { font-size: 3rem; margin-bottom: 15px; display: block; }
        .qa-title { font-size: 1.3rem; color: #68ff00; font-weight: bold; text-transform: uppercase; }
        .qa-desc { font-size: 0.9rem; color: #888; margin-top: 10px; }

        .section-padding { padding: 80px 10%; }
        .intro-card { background: rgba(40, 40, 40, 0.3); padding: 50px; border: 1px solid #333; border-radius: 4px; }
        .about-title { color: #68ff00; font-size: 2.5rem; margin-bottom: 25px; text-transform: uppercase; }

        .news-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-top: 30px; }
        .news-item { background: #1a1a1a; border: 1px solid #333; border-top: 4px solid #68ff00; padding: 25px; }
        
        .action-btn { background: #68ff00; color: #000; padding: 18px 45px; border: none; cursor: pointer; font-size: 1.2rem; font-weight: bold; margin-top: 30px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="home-wrapper">
        <div class="hero-banner">
            <asp:Panel ID="memberSection" runat="server">
                <h1 class="hero-title">COMMAND CENTER</h1>
                <p class="hero-subtitle">Welcome back, <asp:Literal ID="litUsername" runat="server" />. Rank: <b><asp:Literal ID="litRole" runat="server" /></b>.</p>
            </asp:Panel>
            <asp:Panel ID="visitorSection" runat="server">
                <h1 class="hero-title">MINECRAFT HUB</h1>
                <p class="hero-subtitle">The ultimate destination for technical players. Initialize your connection.</p>
                <asp:Button ID="btnLoginRedirect" runat="server" Text="[ INITIALIZE ]" OnClick="btnLoginRedirect_Click" CssClass="action-btn" />
            </asp:Panel>
        </div>

        <asp:PlaceHolder ID="phMemberStatus" runat="server" Visible="false">
            <div class="status-bar">
                <div class="status-item">TREASURY: <span><asp:Label ID="lblEmeralds" runat="server" /> 💎</span></div>
                <div class="status-item">INVENTORY: <span><asp:Label ID="lblItemCount" runat="server" /> Items</span></div>
                <div class="status-item">NET WORTH: <span><asp:Label ID="lblInvValue" runat="server" /> EM</span></div>
                <div class="status-item">SYSTEM: <span style="color:#68ff00;">ONLINE</span></div>
            </div>
        </asp:PlaceHolder>

        <div class="section-padding">
            <div class="intro-card">
                <h2 class="about-title" style="text-align:center; font-weight: normal !important;">About the Platform</h2>
                <p style="text-align:center; color:#ccc; line-height:2; font-size:1.2rem;">
                    Minecraft Server Hub is a professional portal for technical survivalists. 
                    We integrate an Auto Farm Database with a Character Equipment System to help you master the technical grid.
                </p>
            </div>
        </div>

        <asp:Panel ID="memberDataCards" runat="server" CssClass="section-padding" Visible="false" style="padding-top:0;">
            <h2 class="about-title" style="text-align:left; font-size:2rem;">Quick Access</h2>
            <div class="quick-access-grid">
                <a href="/Wong Zhang Zhe/UserProfile.aspx" class="qa-card">
                    <span class="qa-icon">👤</span>
                    <span class="qa-title">Profile</span>
                    <p class="qa-desc">View your character and active gear.</p>
                </a>
                <a href="/Wong Zhang Zhe/EditProfile.aspx" class="qa-card">
                    <span class="qa-icon">⚙️</span>
                    <span class="qa-title">Settings</span>
                    <p class="qa-desc">Modify identity and upload avatars.</p>
                </a>
                <a href="/Wong Zhang Zhe/Guide.aspx" class="qa-card">
                    <span class="qa-icon">📖</span>
                    <span class="qa-title">Guides</span>
                    <p class="qa-desc">Master redstone and farm automation.</p>
                </a>
                <a href="/Wong Zhang Zhe/ContactUs.aspx" class="qa-card">
                    <span class="qa-icon">✉️</span>
                    <span class="qa-title">Support</span>
                    <p class="qa-desc">Open tickets for technical assistance.</p>
                </a>
            </div>
        </asp:Panel>

        <div class="section-padding news-section">
            <h2 class="about-title" style="text-align:left;">Minecraft Patch Intel</h2>
            <div class="news-grid">
                <div class="news-item">
                    <span style="color:#fbbf24;">v1.21 Update</span>
                    <h4 style="margin:10px 0;">Tricky Trials</h4>
                    <p style="font-size:0.9rem; color:#aaa;">Explore Trial Chambers and collect Mace materials.</p>
                </div>
                <div class="news-item">
                    <span style="color:#fbbf24;">Technical News</span>
                    <h4 style="margin:10px 0;">Crafter Mastery</h4>
                    <p style="font-size:0.9rem; color:#aaa;">Automated crafting block is now fully integrated into our guides.</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>