<%@ Page Title="Guides Hub" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Guide.aspx.cs" Inherits="WebAssignment.Guide" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .guide-hub-wrapper { width: 100%; margin: 0; padding: 0; overflow: hidden; }
        .guide-grid { display: grid; grid-template-columns: repeat(4, 1fr); width: 100vw; height: calc(100vh - 120px); gap: 0; }
        .guide-card { position: relative; height: 100%; background: #000; border: 1px solid #222; overflow: hidden; cursor: pointer; display: block; text-decoration: none; }
        .guide-card:hover { border: 2px solid #68ff00; z-index: 10; }
        .card-img { width: 100%; height: 100%; object-fit: cover; transition: 0.6s; opacity: 0.7; }
        .guide-card:hover .card-img { opacity: 0.40; transform: scale(1.1); }
        .card-title { position: absolute; bottom: 40px; left: 0; width: 100%; color: #fff; font-size: 2rem; text-align: center; text-shadow: 3px 3px #000; text-transform: uppercase; font-family: 'Minecraft', sans-serif; }

        /* Pixel-style lock mask */
        .lock-overlay { 
            position: absolute; top: 0; left: 0; width: 100%; height: 100%; 
            background: rgba(0,0,0,0.85); display: flex; flex-direction: column; 
            align-items: center; justify-content: center; z-index: 20; 
            backdrop-filter: blur(4px);
        }

        /* Pure CSS pixel-style padlock */
        .pixel-lock {
            width: 60px; height: 50px; background: #fbbf24; position: relative;
            box-shadow: 6px 0 0 #b45309, -6px 0 0 #b45309, 0 6px 0 #b45309, 0 -6px 0 #b45309; /* Pixel border */
        }
        .pixel-lock::before {
            content: ""; position: absolute; top: -30px; left: 10px;
            width: 40px; height: 30px; border: 8px solid #9ca3af;
            border-bottom: none; border-radius: 4px 4px 0 0;
        }
        .pixel-lock::after {
            content: ""; position: absolute; top: 15px; left: 22px;
            width: 16px; height: 20px; background: #000; 
        }

        .lock-text { color: #fbbf24; margin-top: 30px; font-size: 1.2rem; text-transform: uppercase; font-weight: bold; }

        .card-intro { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 30px; box-sizing: border-box; color: #68ff00; font-size: 1.3rem; opacity: 0; transition: 0.5s; text-align: center; background: rgba(0,0,0,0.6); }
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
                    <p>Core loop of gathering, crafting, and building...</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>

            <asp:LinkButton ID="btnMob" runat="server" CssClass="guide-card" OnClick="Guide_Click" CommandArgument="Mob">
                <img src="/Wong Zhang Zhe/pic/mob_cover.png" class="card-img" />
                <div class="card-title">Mob Bestiary</div>
                <div class="card-intro">
                    <p>Details every creature found in Minecraft...</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>

            <asp:LinkButton ID="btnPotion" runat="server" CssClass="guide-card" OnClick="Guide_Click" CommandArgument="Potion">
                <img src="/Wong Zhang Zhe/pic/potion_cover.png" class="card-img" />
                <asp:Panel ID="panelLockPotion" runat="server" CssClass="lock-overlay" Visible="false">
                    <div class="pixel-lock"></div>
                    <div class="lock-text">Member Only</div>
                </asp:Panel>
                <div class="card-title">Potion & Enchantment</div>
                <div class="card-intro">
                    <p>Consumable liquids from a Brewing Stand...</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>

            <asp:LinkButton ID="btnAutoFarm" runat="server" CssClass="guide-card" OnClick="Guide_Click" CommandArgument="AutoFarm">
                <img src="/Wong Zhang Zhe/pic/autofarm_cover.png" class="card-img" />
                <asp:Panel ID="panelLockAutoFarm" runat="server" CssClass="lock-overlay" Visible="false">
                    <div class="pixel-lock"></div>
                    <div class="lock-text">Member Only</div>
                </asp:Panel>
                <div class="card-title">Auto Farm</div>
                <div class="card-intro">
                    <p>Machine that harvests and stores resources...</p>
                    <div class="click-hint">[ Click to Enter ]</div>
                </div>
            </asp:LinkButton>

        </div>
    </div>
</asp:Content>