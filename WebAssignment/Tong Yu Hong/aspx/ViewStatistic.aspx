<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewStatistic.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.ViewStatistic" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* Layout Containers - Horizontal & Centered */
        .stats-page-wrapper { background: #0b0b0b; min-height: 80vh; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px; font-family: 'Minecraft', sans-serif; }
        .stats-title { color: #00b63b; text-transform: uppercase; margin-bottom: 50px; font-size: 2.5rem; letter-spacing: 4px; text-shadow: 3px 3px #000; }
        .stats-horizontal-row { display: flex; flex-direction: row; gap: 25px; justify-content: center; width: 100%; max-width: 1300px; flex-wrap: nowrap; }

        /* Stat Card Design - Wide & Professional */
        .stat-card { background: #1a1a1a; border: 1px solid #333; width: 250px; display: flex; box-shadow: 0 15px 30px rgba(0,0,0,0.6); transition: all 0.3s ease; }
        .stat-card:hover { transform: translateY(-8px); border-color: #00b63b; box-shadow: 0 20px 40px rgba(0, 182, 59, 0.15); }
        .stat-accent { width: 8px; background: #00b63b; box-shadow: 2px 0 10px rgba(0, 182, 59, 0.4); }
        .stat-content { padding: 25px; flex: 1; }

        /* Text Styling */
        .stat-category { color: #555; font-size: 0.65rem; text-transform: uppercase; display: block; margin-bottom: 8px; letter-spacing: 1px; }
        .stat-name { color: #fff; font-size: 1.1rem; margin: 0 0 25px 0; text-transform: uppercase; letter-spacing: 1px; }
        .stat-value-area { display: flex; align-items: baseline; gap: 10px; border-top: 1px solid #333; padding-top: 15px; }
        .stat-number { font-size: 3rem; color: #00b63b; font-weight: bold; text-shadow: 0 0 10px rgba(0, 182, 59, 0.2); }
        .stat-label { color: #888; font-size: 0.8rem; text-transform: uppercase; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="stats-page-wrapper">
        <h1 class="stats-title">Guide Analytics</h1>
        
        <div class="stats-horizontal-row">
            <asp:Repeater ID="rptStats" runat="server">
                <ItemTemplate>
                    <div class="stat-card">
                        <div class="stat-accent"></div>
                        <div class="stat-content">
                            <span class="stat-category">Category</span>
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
