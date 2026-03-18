<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AdminStatistics.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.AdminStatistics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/Tong Yu Hong/aspx/AdminStatistics.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="false" />

    <div class="stat-page-wrapper">

        <%-- ══ Header + Filters ══ --%>
        <div class="stat-header">
            <h1 class="stat-main-title">Statistics Dashboard</h1>
            <div class="filter-bar">

                <div class="filter-group">
                    <label class="filter-label" for="ddlCategory">Category</label>
                    <select id="ddlCategory" class="filter-select" onchange="loadStats()">
                        <option value="users">Users</option>
                        <option value="minigames">Minigames</option>
                        <option value="shop">Shop &amp; Economy</option>
                        <option value="content">Content Engagement</option>
                        <option value="moderation">Moderation</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label class="filter-label" for="ddlDateRange">Date Range</label>
                    <select id="ddlDateRange" class="filter-select" onchange="loadStats()">
                        <option value="7">Last 7 Days</option>
                        <option value="30" selected="selected">Last 30 Days</option>
                        <option value="90">Last 3 Months</option>
                        <option value="0">All Time</option>
                    </select>
                </div>

            </div>
        </div>

        <%-- ══ Loading indicator ══ --%>
        <div id="loadingIndicator" class="loading-bar" style="display: none;">
            <div class="loading-pulse"></div>
            <span>Loading data...</span>
        </div>

        <%-- ══ Error banner ══ --%>
        <div id="errorBanner" class="error-banner" style="display: none;">
            <span id="errorMessage">An error occurred while loading data.</span>
        </div>

        <%-- ══ Charts container (populated by JS) ══ --%>
        <div id="chartsContainer" class="charts-grid"></div>

    </div>

    <script src="/Tong Yu Hong/aspx/AdminStatistics.js"></script>

</asp:Content>
