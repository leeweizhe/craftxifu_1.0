<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LiveStream.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.LiveStream" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="/Lee Wei Zhe/css/LiveStream.css" />
        <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="page-wrapper">

        <%-- LIVE badge --%>
        <asp:Label ID="lblStatus" runat="server" CssClass="status-badge"></asp:Label>

        <div class="stream-wrapper">

            <%-- LEFT: Video + controls --%>
            <div class="player-section">

                <asp:HiddenField ID="hdnStreamUrl" runat="server" />
                <video id="videoPlayer" controls autoplay muted>
                    Your browser does not support HTML5 video.
                </video>

                <div class="stream-info">
                    <asp:Label ID="lblStreamTitle" runat="server" CssClass="stream-title"></asp:Label>
                    <asp:Label ID="lblViewerCount" runat="server" CssClass="viewer-count"></asp:Label>
                </div>

                <%-- ================================================
                     INSTRUCTOR PANEL — only visible to stream owner
                     ================================================ --%>
                <asp:Panel ID="pnlInstructorControls" runat="server" Visible="false" CssClass="instructor-panel">

                    <h4 class="panel-title">⚙️ Stream Controls</h4>

                    <%-- Viewer count display (refreshes on postback) --%>
                    <div class="stat-box">
                        <span class="stat-label">Current Viewers</span>
                        <span class="stat-value">
                            <asp:Literal ID="litViewerCount" runat="server"></asp:Literal>
                        </span>
                    </div>

                    <%-- Edit stream title --%>
                    <div class="control-group">
                        <label>Stream Title</label>
                        <asp:TextBox ID="txtStreamTitle" runat="server"
                            CssClass="input-field"
                            MaxLength="200">
                        </asp:TextBox>
                        <asp:Button ID="btnSaveTitle" runat="server"
                            Text="Save Title"
                            CssClass="btn-secondary"
                            OnClick="btnSaveTitle_Click" />
                    </div>

                    <%-- Start / End stream buttons --%>
                    <div class="control-group">
                        <%-- Only one button shows at a time depending on IsLive status --%>
                        <asp:Button ID="btnStartStream" runat="server"
                            Text="🔴 Go Live"
                            CssClass="btn-golive"
                            OnClick="btnStartStream_Click" />

                        <asp:Button ID="btnEndStream" runat="server"
                            Text="⏹ End Stream"
                            CssClass="btn-endstream"
                            OnClick="btnEndStream_Click" />
                    </div>

                    <%-- Feedback after any action --%>
                    <asp:Label ID="lblPanelFeedback" runat="server" CssClass="chat-feedback"></asp:Label>

                </asp:Panel>

            </div>

            <%-- RIGHT: Chat --%>
            <div class="chat-section">

                <h3>Live Chat</h3>

                <div class="chat-box">
                    <asp:Literal ID="litChatMessages" runat="server"></asp:Literal>
                </div>

                <asp:TextBox ID="txtUsername" runat="server"
                    placeholder="Your name" CssClass="input-field" MaxLength="20">
                </asp:TextBox>

                <asp:TextBox ID="txtMessage" runat="server"
                    placeholder="Type a message..." CssClass="input-field" MaxLength="200">
                </asp:TextBox>

                <asp:Button ID="btnSend" runat="server"
                    Text="Send" CssClass="btn-send" OnClick="btnSend_Click" />

                <asp:Label ID="lblFeedback" runat="server" CssClass="chat-feedback"></asp:Label>

            </div>

        </div>
    </div>

    <script type="text/javascript">
        var streamUrl = document.getElementById('<%= hdnStreamUrl.ClientID %>').value;
        var video = document.getElementById('videoPlayer');

        if (Hls.isSupported()) {
            var hls = new Hls();
            hls.loadSource(streamUrl);
            hls.attachMedia(video);
            hls.on(Hls.Events.MANIFEST_PARSED, function () { video.play(); });
        } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
            video.src = streamUrl;
            video.play();
        }
    </script>

</asp:Content>
