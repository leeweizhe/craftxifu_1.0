<%@ Page Title="User Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="WebAssignment.UserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* 保持 Minecraft 像素风格 UI */
        .profile-box { background: rgba(0,0,0,0.9); border: 5px solid #464646; padding: 50px; width: 85%; margin: 40px auto; color: #FFF; box-shadow: 0 0 20px rgba(104, 255, 0, 0.3); }
        .header-flex { display: flex; align-items: center; gap: 40px; border-bottom: 4px solid #68ff00; padding-bottom: 30px; }
        
        /* 头像容器 */
        .avatar-container { position: relative; width: 180px; height: 180px; }
        .avatar-main { width: 100%; height: 100%; border: 4px solid #68ff00; image-rendering: pixelated; object-fit: cover; }
        .frame-overlay { position: absolute; top: -10px; left: -10px; width: 200px; height: 200px; pointer-events: none; image-rendering: pixelated; z-index: 10; }

        .name-main { font-size: 3.5rem; color: #68ff00; margin: 0; }
        
        /* 容器：让 Rank 和 NameTag 并排显示 */
        .rank-tag-container { display: flex; align-items: center; gap: 10px; margin-top: 10px; }

        /* 统一勋章样式：青框、青字、透明背景 */
        .rank-badge, .nametag-badge { 
            border: 2px solid #68ff00; 
            padding: 5px 15px; 
            color: #68ff00; 
            font-size: 1.2rem; 
            display: inline-block; 
            text-transform: uppercase; 
            background: transparent; /* 确保是透明背景 */
        }
        
        /* 覆盖原本可能存在的加粗或特殊边框设置，确保完全一致 */
        .nametag-badge { font-weight: normal; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-top: 40px; }
        .data-item { background: #111; padding: 25px; border: 2px solid #333; }
        .label-text { color: #68ff00; font-size: 1.4rem; text-transform: uppercase; display: block; }
        .value-text { font-size: 2.2rem; display: block; margin-top: 10px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-box">
        <div class="header-flex">
            <div class="avatar-container">
                <asp:Image ID="imgAvatar" runat="server" CssClass="avatar-main" />
                <asp:Image ID="imgFrameOverlay" runat="server" CssClass="frame-overlay" Visible="false" />
            </div>

            <div>
                <asp:Label ID="lblFullName" runat="server" CssClass="name-main" />
                <br />
                <asp:Label ID="lblUsername" runat="server" style="color:#999; font-size:1.8rem;" />
                
                <div class="rank-tag-container">
                    <span class="rank-badge">
                        Rank: <asp:Label ID="lblRole" runat="server" />
                    </span>
                    <asp:Label ID="lblNameTag" runat="server" CssClass="nametag-badge" Visible="false" />
                </div>
            </div>
        </div>

        <div class="info-grid">
            <div class="data-item">
                <span class="label-text">Email Address</span>
                <asp:Label ID="lblEmail" runat="server" CssClass="value-text" />
            </div>
            <div class="data-item">
                <span class="label-text">Origin / Country</span>
                <asp:Label ID="lblCountry" runat="server" CssClass="value-text" />
            </div>
            <div class="data-item">
                <span class="label-text">Emerald Balance</span>
                <asp:Label ID="lblCurrency" runat="server" CssClass="value-text" style="color:#fbbf24;" />
            </div>
            <div class="data-item">
                <span class="label-text">Biography</span>
                <asp:Label ID="lblBio" runat="server" CssClass="value-text" style="font-size:1.6rem;" />
            </div>
        </div>

        <asp:Button ID="btnGoToEdit" runat="server" 
            Text="[ EDIT CHARACTER INFO ]" 
            style="margin-top:20px; background:none; border:2px solid #68ff00; color:#68ff00; padding:10px 20px; cursor:pointer; font-weight:bold;" 
            OnClick="btnGoToEdit_Click" />
    </div>
</asp:Content>