<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LiveStream.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.LiveStream" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="/Lee Wei Zhe/css/LiveStream.css" />
        <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="stream-page-wrapper">
        <asp:Label ID="lblStatus" runat="server" CssClass="status-badge"></asp:Label>

        <%-- VIDEO PLAYER + CHAT side by side --%>
        <div class="stream-wrapper">

            <%-- LEFT: Video Player --%>
            <div class="player-section">

                <%-- Hidden field stores the stream URL so JavaScript can read it --%>
                <asp:HiddenField ID="hdnStreamUrl" runat="server" />

                <%-- The actual video element --%>
                <video id="videoPlayer" controls autoplay muted>
                    Your browser does not support HTML5 video.
                </video>

                <%-- Stream title and viewer count --%>
                <div class="stream-info">
                    <asp:Label ID="lblStreamTitle" runat="server" CssClass="stream-title"></asp:Label>
                    <asp:Label ID="lblViewerCount" runat="server" CssClass="viewer-count"></asp:Label>
                </div>

            </div>

            <%-- RIGHT: Chat Box --%>
            <div class="chat-section">

                <h3>Live Chat</h3>

                <%-- Scrollable area where messages appear --%>
                <div class="chat-box">
                    <asp:Literal ID="litChatMessages" runat="server"></asp:Literal>
                </div>

                <%-- Input: username --%>
                <asp:TextBox ID="txtUsername" runat="server"
                    placeholder="Your name"
                    CssClass="input-field"
                    MaxLength="20">
                </asp:TextBox>

                <%-- Input: message --%>
                <asp:TextBox ID="txtMessage" runat="server"
                    placeholder="Type a message..."
                    CssClass="input-field"
                    MaxLength="200">
                </asp:TextBox>

                <%-- Send button --%>
                <asp:Button ID="btnSend" runat="server"
                    Text="Send"
                    CssClass="btn-send"
                    OnClick="btnSend_Click" />

                <%-- Feedback (success/error after clicking Send) --%>
                <asp:Label ID="lblFeedback" runat="server" CssClass="chat-feedback"></asp:Label>

            </div>
        </div>

        <%-- HLS.js Script: connects the stream URL to the video player --%>
        <script type="text/javascript">

            // Read the stream URL from the hidden field
            var streamUrl = document.getElementById('<%= hdnStreamUrl.ClientID %>').value;
            var video = document.getElementById('videoPlayer');

            if (Hls.isSupported()) {
                var hls = new Hls();
                hls.loadSource(streamUrl);   // Load the HLS stream
                hls.attachMedia(video);      // Attach to our video element
                hls.on(Hls.Events.MANIFEST_PARSED, function () {
                    video.play();            // Auto-play when ready
                });
            } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
                // Safari supports HLS natively
                video.src = streamUrl;
                video.play();
            }

        </script>
    </div>
</asp:Content>
