<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewStatistic.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.ViewStatistic" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        html, body, form, .main-content, .container, .body-content, #MainContent { margin: 0 !important; padding: 0 !important; width: 100% !important; max-width: none !important; overflow-x: hidden; }
        
        /* Layout - Responsive Background Scaling */
        .stats-page-wrapper { background: url('/Tong%20Yu%20Hong/Image/Minecraft_Background.png') no-repeat center 0px fixed; background-size: 100% auto; min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: flex-start; width: 100%; position: relative; font-family: 'Minecraft', sans-serif; background-color: #1a1a1a; }
        .stats-page-wrapper::before { content: ""; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.2); z-index: 1; }
        
        /* Title Position - Push down so it doesn't block the background logo */
        .stats-title { color: #00ff55; text-transform: uppercase; margin-top: 250px; margin-bottom: 60px; font-size: 4rem; letter-spacing: 8px; text-shadow: 0 0 20px rgba(0, 182, 59, 0.5), 4px 4px #000; z-index: 2; position: relative; animation: fadeInDown 0.8s ease; }
        .stats-horizontal-row { display: flex; flex-direction: row; gap: 35px; justify-content: center; width: 95%; max-width: 1600px; flex-wrap: nowrap; z-index: 2; position: relative; }

        /* Advanced Card Design */
        .stat-card { background: rgba(15, 15, 15, 0.85); border: 1px solid rgba(255,255,255,0.1); width: 300px; display: flex; box-shadow: 0 20px 40px rgba(0,0,0,0.7); transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); backdrop-filter: blur(12px); border-radius: 4px; }
        .stat-card:hover { transform: translateY(-15px) scale(1.03); border-color: #00ff55; box-shadow: 0 0 30px rgba(0, 255, 85, 0.2); }
        .stat-accent { width: 10px; background: linear-gradient(to bottom, #00ff55, #00b63b); animation: pulseGlow 2s infinite alternate; }
        .stat-content { padding: 35px; flex: 1; }

        /* Typography & Numbers */
        .stat-category { color: #00ff55; font-size: 0.75rem; text-transform: uppercase; display: block; margin-bottom: 12px; letter-spacing: 2px; opacity: 0.8; }
        .stat-name { color: #fff; font-size: 1.4rem; margin: 0 0 35px 0; text-transform: uppercase; letter-spacing: 2px; text-shadow: 2px 2px #000; }
        .stat-value-area { display: flex; align-items: baseline; gap: 15px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px; }
        .stat-number { font-size: 4.5rem; color: #fff; font-weight: bold; text-shadow: 0 0 15px rgba(0, 255, 85, 0.4); }
        .stat-label { color: #777; font-size: 1rem; text-transform: uppercase; }

        /* Keyframes for animations */
        @keyframes pulseGlow { from { box-shadow: 0 0 5px #00b63b; } to { box-shadow: 0 0 20px #00ff55; } }
        @keyframes fadeInDown { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="stats-page-wrapper">
        <h1 class="stats-title">Guide Analytics</h1>
        <div class="stats-horizontal-row">
            <asp:Repeater ID="rptStats" runat="server">
                <ItemTemplate>
                    <div class="stat-card">
                        <a href="../../Wong%20Zhang%20Zhe/uploads/">../../Wong Zhang Zhe/uploads/</a>
                        <div class="stat-accent"></div>
                        <div class="stat-content">
                            <span class="stat-category">Tracking</span>
                            <h2 class="stat-name"><%# Eval("GuideName") %></h2>
                            <div class="stat-value-area">
                                <span class="stat-number"><%# Eval("ClickCount") %></span>
                                <span class="stat-label">Views</span>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>


