<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StreamList.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.StreamList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/Lee Wei Zhe/css/StreamList.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="hero-banner">
        <h1 class="hero-title">WELCOME TO LIVE STREAM SECTION</h1>
        <p class="hero-subtitle">Watch and learn from our expert instructors</p>
    </div>

    <div class="page-wrapper">

        <h2 class="page-title">Live Streams</h2>
        <p class="page-subtitle">Click on an instructor to watch their stream</p>

        <%-- ============================================
             YOUR STREAM section (only visible if logged-in
             user is an instructor with a stream)
             ============================================ --%>
        <asp:Panel ID="pnlMyStream" runat="server" Visible="false">
            <h3 class="section-label">Your Stream</h3>

            <%-- Single card for the logged-in instructor's own stream --%>
            <a class="instructor-card my-stream-card" href='LiveStream.aspx?id=<%= MyStreamID %>'>
                <div class="card-avatar my-avatar">
                    <asp:Literal ID="litMyAvatar" runat="server"></asp:Literal>
                </div>
                <p class="card-name">
                    <asp:Literal ID="litMyName" runat="server"></asp:Literal>
                    <span class="owner-tag">You</span>
                </p>
                <p class="card-stream-title">
                    <asp:Literal ID="litMyStreamTitle" runat="server"></asp:Literal>
                </p>
                <p class="card-viewers">
                    <asp:Literal ID="litMyStatus" runat="server"></asp:Literal>
                </p>
            </a>

            <hr class="divider" />
        </asp:Panel>

        <%-- ============================================
             ALL OTHER instructors grid
             ============================================ --%>
        <h3 class="section-label">All Streams</h3>

        <div class="card-grid">
            <asp:Repeater ID="rptInstructors" runat="server">
                <ItemTemplate>
                    <a class="instructor-card" href='LiveStream.aspx?id=<%# Eval("StreamID") %>'>
                        <div class="card-avatar">
                               <img src='<%# Eval("ProfilePicture") %>' 
                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"
                                     class="avatar-img" />
                                <%-- Fallback: show initial letter if image fails to load --%>
                                <span class="avatar-initial" style="display:none;">
                                    <%# Eval("UserName").ToString().Substring(0, 1).ToUpper() %>
                                </span>
                        </div>
                        <p class="card-name"><%# Eval("Username") %></p>
                        <p class="card-stream-title"><%# Eval("StreamTitle") %></p>
                        <p class="card-viewers">
                            <%# (bool)Eval("IsLive")
                                ? "<span class='badge-live'>LIVE</span> " + Eval("ViewerCount") + " viewers"
                                : "<span class='badge-offline'>OFFLINE</span>" %>
                        </p>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Label ID="lblEmpty" runat="server" Visible="false" CssClass="empty-msg"
            Text="No streams found.">
        </asp:Label>

    </div>

</asp:Content>
