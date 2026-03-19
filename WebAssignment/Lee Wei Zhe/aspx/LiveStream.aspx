<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LiveStream.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.LiveStream" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/LiveStream.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="top-bar">
        <a href="/Lee Wei Zhe/aspx/StreamList.aspx" class="btn-back">Back</a>
    </div>

    <div class="page-wrapper">

        <%-- LIVE / OFFLINE badge --%>
        <asp:Label ID="lblStatus" runat="server" CssClass="status-badge"></asp:Label>

        <div class="stream-wrapper">

            <%-- ===== LEFT: Video + Instructor Panel ===== --%>
            <div class="player-section">

                <%-- YouTube embed — src is set in code-behind --%>
                <%-- Shows a placeholder message if no YouTube ID is set --%>
                <asp:Panel ID="pnlVideo" runat="server">
                    <iframe id="youtubePlayer"
                        src=""
                        frameborder="0"
                        allow="autoplay; encrypted-media"
                        allowfullscreen>
                    </iframe>
                </asp:Panel>

                <%-- Shown when instructor hasn't set a YouTube Video ID yet --%>
                <asp:Panel ID="pnlNoVideo" runat="server" Visible="false" CssClass="no-video-box">
                    <p>⚠️ No stream set up yet. Check back soon!</p>
                </asp:Panel>

                <%-- Stream title + viewer count below video --%>
                <div class="stream-info">
                    <asp:Label ID="lblStreamTitle" runat="server" CssClass="stream-title"></asp:Label>
                    <asp:Label ID="lblViewerCount" runat="server" CssClass="viewer-count"></asp:Label>
                </div>

                <%-- ================================================
                        INSTRUCTOR PANEL — only visible to stream owner
                        ================================================ --%>
                <asp:Panel ID="pnlInstructorControls" runat="server" Visible="false" CssClass="instructor-panel">
                    <div class="panel-header" onclick="toggleInstructorPanel()" style="cursor: pointer; display: flex; justify-content: space-between; align-items: center;">
                        <h4 class="panel-title">⚙️ Stream Controls</h4>
                        <span id="toggleIcon" style="font-size: 18px; transition: transform 0.3s;">▼</span>
                    </div>

                    <div id="panelContent" class="panel-content">
                    <%-- Viewer count stat --%>
                        <div class="stat-box">
                            <span class="stat-label">Page Viewers</span>
                            <span class="stat-value">
                                <asp:Literal ID="litViewerCount" runat="server"></asp:Literal>
                            </span>
                        </div>

                        <%-- Edit stream title --%>
                        <div class="control-group">
                            <label>Stream Title</label>
                            <asp:TextBox ID="txtStreamTitle" runat="server"
                                CssClass="input-field" MaxLength="200">
                            </asp:TextBox>
                            <asp:Button ID="btnSaveTitle" runat="server"
                                Text="Save Title"
                                CssClass="btn-secondary"
                                OnClick="btnSaveTitle_Click" />
                        </div>

                        <%-- YouTube Video ID input --%>
                        <%-- Instructor pastes the ID from their YouTube Live URL --%>
                        <div class="control-group">
                            <label>YouTube Video ID</label>
                            <small class="input-hint">
                                From your YouTube Live URL:<br />
                                youtube.com/live/<strong>THIS_PART</strong>
                            </small>
                            <asp:TextBox ID="txtYouTubeID" runat="server"
                                CssClass="input-field" MaxLength="20"
                                placeholder="e.g. dQw4w9WgXcQ">
                            </asp:TextBox>
                            <asp:Button ID="btnSaveYouTubeID" runat="server"
                                Text="Save YouTube ID"
                                CssClass="btn-secondary"
                                OnClick="btnSaveYouTubeID_Click" />
                        </div>

                        <%-- Start / End stream --%>
                        <div class="control-group">
                            <asp:Button ID="btnStartStream" runat="server"
                                Text="🔴 Go Live"
                                CssClass="btn-golive"
                                OnClick="btnStartStream_Click" />
                            <asp:Button ID="btnEndStream" runat="server"
                                Text="⏹ End Stream"
                                CssClass="btn-endstream"
                                OnClick="btnEndStream_Click" />
                        </div>
                    </div>
                <asp:Label ID="lblPanelFeedback" runat="server" CssClass="chat-feedback"></asp:Label>

            </asp:Panel>
        </div>

            <%-- ===== RIGHT: Chat ===== --%>
            <div class="chat-section">

                <h3>Live Chat</h3>

                    <asp:Panel ID="pnlChatToggle" runat="server" Visible="false">
                        <button type="button" class="btn-chat-toggle" onclick="toggleChat(this)">
                            Switch to Local Chat
                        </button>
                    </asp:Panel>

                <%-- YouTube live chat embed — switches to fallback if no video ID --%>
                <asp:Panel ID="pnlYouTubeChat" runat="server" Visible="false">
                    <%-- src is set in code-behind using the YouTube Video ID --%>
                    <iframe id="youtubeChat"
                        src=""
                        frameborder="0"
                        class="youtube-chat">
                    </iframe>
                </asp:Panel>

                <%-- Fallback: our own simple chat (shown when no YouTube ID is set) --%>
                <asp:Panel ID="pnlOwnChat" runat="server">

                    <%-- Chat messages rendered via Repeater so each row can hold a server-side report button --%>
                    <div class="chat-box">
                        <asp:Repeater ID="rptChat" runat="server">
                            <ItemTemplate>
                                <div class="chat-message">
                                    <div class="chat-message-header">
                                        <span class="chat-user"><%# HttpUtility.HtmlEncode(Eval("Username").ToString()) %></span>
                                        <span class="chat-time">[<%# Convert.ToDateTime(Eval("CommentDate")).ToString("hh:mm tt") %>]</span>
                                    </div>
                                    <div class="chat-message-body">
                                        <span class="chat-text"><%# Eval("CommentText") %></span>
                                        <asp:LinkButton ID="lnkReport" runat="server"
                                            CssClass="btn-report"
                                            CommandName="Report"
                                            CommandArgument='<%# Eval("CommentId") + "|" + Eval("StreamId") %>'
                                            OnCommand="lnkReport_Command"
                                            ToolTip="Report this message"
                                            OnClientClick="return confirm('Report this message?');">
                                            &#9873;
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <%-- Shown only when there are no messages --%>
                        <asp:Label ID="lblNoMessages" runat="server"
                            CssClass="no-messages"
                            Text="No messages yet. Say hello!">
                        </asp:Label>
                    </div>

                    <asp:TextBox ID="txtMessage" runat="server"
                        placeholder="Type a message..." CssClass="input-field" MaxLength="200">
                    </asp:TextBox>

                    <asp:Button ID="btnSend" runat="server"
                        Text="Send" CssClass="btn-send" OnClick="btnSend_Click" />

                    <asp:Label ID="lblFeedback" runat="server" CssClass="chat-feedback"></asp:Label>
                </asp:Panel>

            </div>
        </div>
    </div>

    <%-- Set the YouTube iframe src via JavaScript to avoid browser warnings --%>
    <asp:HiddenField ID="hdnActiveChat" runat="server" Value="youtube" />
    <script type="text/javascript">

        // YouTubeID and domain are passed from code-behind via hidden fields
        var ytID     = '<%= YouTubeVideoID %>';
        var domain   = '<%= Request.Url.Host %>';

        if (ytID !== '') {
            var player = document.getElementById('youtubePlayer');
            if (player)
                player.src = 'https://www.youtube.com/embed/' + ytID + '?autoplay=1';

            var chat = document.getElementById('youtubeChat');
            if (chat)
                chat.src = 'https://www.youtube.com/live_chat?v=' + ytID + '&embed_domain=' + domain;

            // Restore whichever chat was active before postback
            var hdnChat = document.getElementById('<%= hdnActiveChat.ClientID %>');
            var localChat = document.getElementById('<%= pnlOwnChat.ClientID %>');
            var toggleBtn = document.querySelector('.btn-chat-toggle');

            if (hdnChat && hdnChat.value === 'local') {
                // Was showing local chat — restore it
                document.getElementById('youtubeChat').parentElement.style.display = 'none';
                localChat.style.display = 'block';
                if (toggleBtn) toggleBtn.textContent = 'Switch to YouTube Chat';
            } else {
                // Default: hide local chat, show YouTube
                if (localChat) localChat.style.display = 'none';
            }
        }

        function toggleInstructorPanel() {
            var content = document.getElementById('panelContent');
            var icon = document.getElementById('toggleIcon');

            if (content.classList.contains('panel-collapsed')) {
                content.classList.remove('panel-collapsed');
                icon.style.transform = 'rotate(0deg)';
            } else {
                content.classList.add('panel-collapsed');
                icon.style.transform = 'rotate(-90deg)';
            }
        }

        function toggleChat(btn) {
            var ytChat = document.getElementById('youtubeChat').parentElement;
            var localChat = document.getElementById('<%= pnlOwnChat.ClientID %>');
            var hdnChat = document.getElementById('<%= hdnActiveChat.ClientID %>');

            if (ytChat.style.display === 'none') {
                ytChat.style.display = 'block';
                localChat.style.display = 'none';
                btn.textContent = 'Switch to Local Chat';
                hdnChat.value = 'youtube';   // Save state
            } else {
                ytChat.style.display = 'none';
                localChat.style.display = 'block';
                btn.textContent = 'Switch to YouTube Chat';
                hdnChat.value = 'local';     // Save state
            }
        }
    </script>

</asp:Content>
