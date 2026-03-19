<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManagePromote.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.ManagePromote" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .chat-container { display: flex; height: 80vh; background: #121212; border: 2px solid #333; border-radius: 8px; overflow: hidden; margin: 20px auto; width: 95%; max-width: 1400px; font-family: 'Minecraft', sans-serif; }
        .chat-sidebar { width: 350px; border-right: 1px solid #333; display: flex; flex-direction: column; background: #1e1e1e; }
        .sidebar-header { padding: 20px; font-size: 1.2rem; color: #68ff00; border-bottom: 1px solid #333; text-transform: uppercase; display: flex; justify-content: space-between; align-items: center; }
        .status-dropdown { background: #1e1e1e; color: #68ff00; border: 1px solid #333; font-family: 'Minecraft', sans-serif; font-size: 11px; padding: 2px; }
        .chat-list { flex: 1; overflow-y: auto; }
        .chat-item { padding: 15px 20px; border-bottom: 1px solid #333; transition: 0.3s; background: #1e1e1e; cursor: pointer; }
        .chat-item:hover { background: #2a2a2a; }
        .ticket-link { text-decoration: none; color: inherit; display: block; width: 100%; text-align: left; }
        .chat-info { display: flex; flex-direction: column; gap: 3px; }
        .chat-subject { color: #68ff00; font-size: 0.9rem; text-transform: uppercase; }
        .chat-preview { color: #aaa; font-size: 0.85rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        .chat-main { flex: 1; display: flex; flex-direction: column; background: #0b0b0b; }
        .chat-main-header { padding: 15px 25px; background: #1e1e1e; border-bottom: 1px solid #333; display: flex; align-items: center; justify-content: space-between; }
        .header-profile-pic { width: 35px; height: 35px; border-radius: 50%; border: 2px solid #68ff00; object-fit: cover; }
        .active-subject { color: #fff; font-size: 1.1rem; }

        .message-area { flex: 1; padding: 30px; overflow-y: auto; display: flex; flex-direction: column; gap: 20px; background-color: #222; }
        .msg-bubble { align-self: flex-start; background: rgba(0, 0, 0, 0.7); border: 1px solid #555; padding: 15px; border-radius: 4px; max-width: 80%; color: #ffffff; }
        .msg-bubble.admin { align-self: flex-end; border: 1px solid #68ff00; background: #1a4d1a; }
        .msg-time { font-size: 0.7rem; color: #bbb; display: block; margin-top: 8px; text-align: right; }

        .chat-input-box { padding: 20px 25px; background: #1e1e1e; border-top: 1px solid #333; }
        .reply-input { width: 100%; background: #2a2a2a; border: 1px solid #444; padding: 12px; color: #fff; font-family: 'Minecraft', sans-serif; margin-bottom: 15px; }
        
        .action-group { display: flex; justify-content: flex-end; gap: 15px; }
        .btn-action { padding: 10px 25px; border: none; cursor: pointer; font-family: 'Minecraft', sans-serif; text-transform: uppercase; font-weight: normal; }
        .btn-approve { background: #68ff00; color: #000; }
        .btn-reject { background: #ff4444; color: #fff; }
        .unlock-panel { background: #331a00; border: 1px solid #ff9900; padding: 10px; text-align: center; margin-bottom: 10px; color: #ff9900; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="chat-container">
        <div class="chat-sidebar">
            <div class="sidebar-header">
                Upgrade Requests
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="status-dropdown">
                    <asp:ListItem Text="Pending" Value="Submitted"></asp:ListItem>
                    <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="chat-list">
                <asp:Repeater ID="rptTicketList" runat="server" OnItemCommand="rptTicketList_ItemCommand">
                    <ItemTemplate>
                        <div class="chat-item">
                            <asp:LinkButton ID="btnSelect" runat="server" CommandName="Select" CommandArgument='<%# Eval("Id") %>' CssClass="ticket-link">
                                <div class="chat-info">
                                    <span class="chat-subject"><%# Eval("Username") %></span>
                                    <span class="chat-preview"><%# Eval("Message") %></span>
                                </div>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="chat-main">
            <div class="chat-main-header">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <asp:Image ID="imgActiveUser" runat="server" CssClass="header-profile-pic" />
                    <span class="active-subject">[ <asp:Literal ID="litActiveSubject" runat="server" Text="Select a Request" /> ]</span>
                </div>
            </div>
            
            <div class="message-area">
                <div class="msg-bubble">
                    <p><asp:Literal ID="litOriginalMessage" runat="server" /></p>
                    
                    <asp:Panel ID="pnlAttachments" runat="server" Visible="false" style="margin-top:10px; border-top:1px solid #444; padding-top:10px; display:flex; flex-direction:column; gap:5px;">
                        <asp:HyperLink ID="lnkAttachment" runat="server" Target="_blank" style="color:#68ff00; font-size:0.8rem;">[ VIEW ATTACHED PROOF ]</asp:HyperLink>
                        <asp:HyperLink ID="lnkYoutube" runat="server" Target="_blank" style="color:#ff4444; font-size:0.8rem;">[ WATCH VIDEO LINK ]</asp:HyperLink>
                    </asp:Panel>

                    <span class="msg-time"><asp:Literal ID="litUserTime" runat="server" /></span>
                </div>

                <asp:Panel ID="pnlAdminReply" runat="server" Visible="false" CssClass="msg-bubble admin">
                    <p><asp:Literal ID="litAdminMessage" runat="server" /></p>
                    <span class="msg-time"><asp:Literal ID="litAdminTime" runat="server" /></span>
                </asp:Panel>
            </div>

            <div class="chat-input-box">
                <asp:Panel ID="pnlUnlockArea" runat="server" Visible="false" CssClass="unlock-panel">
                    Request Handled. <asp:Button ID="btnUnlock" runat="server" Text="Unlock to Edit" OnClick="btnUnlock_Click" CssClass="status-dropdown" />
                </asp:Panel>

                <asp:TextBox ID="txtReply" runat="server" placeholder="Add a moderator note..." CssClass="reply-input" TextMode="MultiLine" Rows="2" />
                
                <div class="action-group">
                    <asp:Button ID="btnReject" runat="server" Text="Reject Request" OnClick="btnReject_Click" CssClass="btn-action btn-reject" />
                    <asp:Button ID="btnApprove" runat="server" Text="Approve & Promote" OnClick="btnApprove_Click" CssClass="btn-action btn-approve" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>  