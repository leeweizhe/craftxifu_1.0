<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="WebAssignment.EditProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .profile-box { background: rgba(0,0,0,0.9); border: 5px solid #464646; padding: 50px; width: 85%; margin: 40px auto; color: #FFF; box-shadow: 0 0 20px rgba(104, 255, 0, 0.3); }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-top: 30px; }
        .data-item { background: #111; padding: 20px; border: 2px solid #333; }
        .label-text { color: #68ff00; font-size: 1.2rem; text-transform: uppercase; display: block; margin-bottom: 10px; }
        .pixel-input { width: 100%; background: #000; color: #fff; border: 1px solid #444; padding: 10px; font-size: 1.5rem; box-sizing: border-box; }
        .pixel-input:focus { border-color: #68ff00; outline: none; }
        
        /* 按钮样式 */
        .btn-update { background: #68ff00; color: #000; font-weight: bold; padding: 15px 40px; border: none; cursor: pointer; font-size: 1.2rem; }
        .btn-cancel { background: #ff4444; color: #fff; font-weight: bold; padding: 15px 40px; border: none; cursor: pointer; font-size: 1.2rem; margin-right: 10px; }
        .btn-cancel:hover { background: #cc0000; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-box">
        <h2 style="color:#68ff00; font-size: 2.5rem; margin-bottom: 10px;">MODIFY CHARACTER DATA</h2>
        <asp:Label ID="lblMsg" runat="server" style="font-weight:bold; display:block; margin-bottom:15px;" />

        <div class="info-grid">
            <div class="data-item">
                <span class="label-text">First Name</span>
                <asp:TextBox ID="txtFName" runat="server" CssClass="pixel-input" />
            </div>
            <div class="data-item">
                <span class="label-text">Last Name</span>
                <asp:TextBox ID="txtLName" runat="server" CssClass="pixel-input" />
            </div>
            <div class="data-item">
                <span class="label-text">Gender</span>
                <asp:DropDownList ID="ddlGender" runat="server" CssClass="pixel-input">
                    <asp:ListItem Value="M">Male</asp:ListItem>
                    <asp:ListItem Value="F">Female</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="data-item">
                <span class="label-text">Country</span>
                <asp:TextBox ID="txtCountry" runat="server" CssClass="pixel-input" />
            </div>
            <div class="data-item" style="grid-column: span 2;">
                <span class="label-text">Biography</span>
                <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" Rows="3" CssClass="pixel-input" />
            </div>
            <div class="data-item">
                <span class="label-text">New Password</span>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Blank to skip" CssClass="pixel-input" />
            </div>
            <div class="data-item">
                <span class="label-text">Confirm New Password</span>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Repeat password" CssClass="pixel-input" />
            </div>
        </div>

        <div style="text-align: right; margin-top: 30px;">
            <asp:Button ID="btnCancel" runat="server" Text="[ CANCEL ]" OnClick="btnCancel_Click" CssClass="btn-cancel" UseSubmitBehavior="false" />
            <asp:Button ID="btnUpdate" runat="server" Text="[ SAVE CHANGES ]" OnClick="btnUpdate_Click" CssClass="btn-update" />
        </div>
    </div>
</asp:Content>