<%@ Page Language="VB" %>

<head>
    <style type="text/css">
        .avatar-img {}
    </style>
</head>
<form id="form1" runat="server">

<div class="profile-container">
    <h2>User Profile </h2>
    
    <div class="profile-header">
        <asp:Image ID="imgAvatar" runat="server" CssClass="avatar-img" Height="125px" Width="184px" />
        &nbsp;<asp:Label ID="lblBadge" runat="server" CssClass="name-tag" Text="Newbie"></asp:Label>
    </div>

    <hr />

    <div class="edit-section">
        <label>Username :</label>
        <asp:TextBox ID="txtUsername" runat="server" ReadOnly="true"></asp:TextBox>

        <label>
        <br />
        Email :</label>
        <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>

        <label>
        <br />
        Description :<br />
        <br />
        </label>
        
        <asp:Button ID="btnUpdate" runat="server" Text="Save Changes " OnClick="btnUpdate_Click" />
    </div>
</div>
</form>

