<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SupportChat.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.SupportChat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* Main Chat Layout Container */
        .chat-container { display: flex; height: 80vh; background: #121212; border: 2px solid #333; border-radius: 8px; overflow: hidden; margin: 20px auto; width: 95%; max-width: 1400px; font-family: 'Minecraft', sans-serif; }
        
        /* Sidebar: Ticket List */
        .chat-sidebar { width: 350px; border-right: 1px solid #333; display: flex; flex-direction: column; background: #1e1e1e; }
        .sidebar-header { padding: 20px; font-size: 1.2rem; font-weight: bold; color: #00b63b; border-bottom: 1px solid #333; text-transform: uppercase; display: flex; justify-content: space-between; align-items: center; }
        
        /* New Sidebar Dropdown */
        .status-dropdown { background: #1e1e1e; color: #00b63b; border: 1px solid #333; font-family: 'Minecraft', sans-serif; font-size: 11px; padding: 2px; cursor: pointer; }

        .chat-list { flex: 1; overflow-y: auto; }
        .chat-item { padding: 15px 20px; border-bottom: 1px solid #333; display: flex; flex-direction: column; align-items: flex-start; transition: 0.3s; background: #1e1e1e; cursor: pointer; }
        .ticket-link { text-decoration: none; color: inherit; display: block; width: 100%; text-align: left; }
        .chat-item:hover { background: #2a2a2a; }
        .chat-item.active { background: #333; border-left: 4px solid #00b63b; }

        .chat-info { display: flex; flex-direction: column; gap: 3px; overflow: hidden; width: 100%; }
        .chat-subject { color: #00b63b; font-size: 0.9rem; text-transform: uppercase; font-weight: bold; }
        .chat-preview { display: block; max-width: 280px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #aaa; font-size: 0.85rem; }
        .chat-details { color: #666; font-size: 0.75rem; margin-top: 2px; } 

        /* Main Window: Conversation Area */
        .chat-main { flex: 1; display: flex; flex-direction: column; background: #0b0b0b; position: relative; }
        .chat-main-header { padding: 15px 25px; background: #1e1e1e; border-bottom: 1px solid #333; display: flex; align-items: center; justify-content: space-between; }
        .active-subject { color: #fff; font-size: 1.1rem; }
        .status-badge { font-size: 0.7rem; padding: 4px 8px; border-radius: 4px; background: #00b63b; color: #fff; }
        .header-profile-pic { width: 35px; height: 35px; border-radius: 50%; border: 2px solid #00b63b; object-fit: cover; background: #333; display: inline-block; vertical-align: middle; }

        /* Message Bubbles */
        .message-area { flex: 1; padding: 30px; overflow-y: auto; display: flex; flex-direction: column; gap: 20px; background-color: #474747; position: relative; z-index: 1; }
        .creeper-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: url('/Tong%20Yu%20Hong/Image/creeper_logo.png') no-repeat center; background-size: 450px; opacity: 0.05; z-index: -1; pointer-events: none; }
        
        .msg-bubble.user { align-self: flex-start; background: rgba(0, 0, 0, 0.7); border: 1px solid #555; padding: 15px; border-radius: 4px; max-width: 80%; color: #ffffff; box-shadow: 0 4px 10px rgba(0,0,0,0.5); }
        .msg-bubble.user p { margin: 0; line-height: 1.5; font-size: 1rem; color: #ffffff !important; text-shadow: 1px 1px #000; } 
        .msg-bubble.admin { align-self: flex-end; background: #005c4b; border: 1px solid #00b63b; padding: 15px; border-radius: 4px; max-width: 80%; color: #ffffff; box-shadow: 0 4px 10px rgba(0,0,0,0.5); margin-left: auto; }
        
        .msg-time { font-size: 0.7rem; color: #bbb; display: block; margin-top: 8px; text-align: right; text-transform: uppercase; letter-spacing: 1px; }

        /* New Unlock Bar */
        .unlock-panel { padding: 10px 25px; background: #000; border-top: 1px solid #333; display: flex; align-items: center; justify-content: space-between; color: #aaa; font-size: 11px; }
        .unlock-btn { background: #fff; color: #000; border: none; padding: 4px 12px; cursor: pointer; font-family: 'Minecraft', sans-serif; font-size: 11px; font-weight: bold; text-transform: uppercase; }

        /* Input Area */
        .chat-input-box { padding: 20px 25px; background: #1e1e1e; border-top: 1px solid #333; display: flex; gap: 15px; align-items: center; }
        .reply-input { flex: 1; background: #2a2a2a; border: 1px solid #444; padding: 12px 15px; color: #fff; border-radius: 6px; font-family: sans-serif; resize: none; }
        .reply-input:focus { outline: none; border-color: #00b63b; }
        .send-btn { background: #00b63b; color: #fff; border: none; padding: 12px 25px; cursor: pointer; border-radius: 6px; text-transform: uppercase; font-weight: bold; transition: 0.3s; }
        .send-btn:hover { background: #008f2e; transform: scale(1.05); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="chat-container">
        
        <div class="chat-sidebar">
            <div class="sidebar-header">
                Support Tickets
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" 
                    OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" 
                    CssClass="status-dropdown">
                    <asp:ListItem Text="Submitted" Value="Submitted" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="chat-list">
                <asp:Repeater ID="rptTicketList" runat="server" OnItemCommand="rptTicketList_ItemCommand">
                    <ItemTemplate>
                        <div class="chat-item">
                            <asp:LinkButton ID="btnSelect" runat="server" CommandName="Select" CommandArgument='<%# Eval("Id") %>' CssClass="ticket-link">
                                <div class="chat-info">
                                    <span class="chat-subject"><%# Eval("Subject") %></span>
                                    <span class="chat-preview"><%# Eval("Message") %></span>
                                    <span class="chat-details">
                                        <%# Eval("Username") %> • <%# Eval("Date", "{0:dd/MM/yy}") %> • <%# Eval("Date", "{0:t}") %>
                                    </span>
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
                    <asp:Image ID="imgActiveUser" runat="server" 
                        ImageUrl="~/images/default-avatar.png" 
                        CssClass="header-profile-pic" />
                    <span class="active-subject">[ <asp:Literal ID="litActiveSubject" runat="server" Text="Select a Ticket" /> ]</span>
                </div>
                <span class="status-badge">Active</span>
            </div>
            
            <div class="message-area">
                <div class="creeper-overlay"></div>
                <div class="msg-bubble user">
                    <p><asp:Literal ID="litOriginalMessage" runat="server" /></p>
                    <span class="msg-time"><asp:Literal ID="litUserTime" runat="server" /></span>
                </div>
                <asp:Panel ID="pnlAdminReply" runat="server" Visible="false" CssClass="msg-bubble admin">
                    <p><asp:Literal ID="litAdminMessage" runat="server" /></p>
                    <span class="msg-time"><asp:Literal ID="litAdminTime" runat="server" /></span>
                </asp:Panel>
            </div>

            <asp:Panel ID="pnlUnlockArea" runat="server" Visible="false" CssClass="unlock-panel">
                <span>Chat Locked - Do you want to edit the message?</span>
                <asp:Button ID="btnUnlock" runat="server" Text="Unlock" OnClick="btnUnlock_Click" CssClass="unlock-btn" />
            </asp:Panel>

            <div class="chat-input-box">
                <asp:TextBox ID="txtReply" runat="server" TextMode="MultiLine" Rows="1" placeholder="Type your reply here..." CssClass="reply-input" />
                <asp:Button ID="btnSend" runat="server" Text="Send" CssClass="send-btn" OnClick="btnSend_Click" />
            </div>
        </div>
    </div>
</asp:Content>
