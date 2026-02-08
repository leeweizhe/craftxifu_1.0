<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebAssignment.Login1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../css/Login.css" rel="stylesheet" />
    <script src="../js/Login.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="login-container">
        <h1>Login Page</h1>
        <div class="input-section">
            <asp:TextBox type="text" id="txtUsername" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
            <label>Username</label>
        </div>
        <div class="input-section"> 
            <asp:TextBox TextMode="password" id="txtPassword" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
            <label>Password</label>
            <span class="password-toggle" id="btnTogglePassword">
                <i class="fa-solid fa-eye eye-open"></i>
                <i class="fa-solid fa-eye-slash eye-close"></i>
            </span>

        </div>
        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
        <asp:Label id="errorMsg" runat="server" Visible="False">geh</asp:Label>
    </div>

</asp:Content>
