<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.ResetPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/RegistrationPage.css" rel="stylesheet" />
    <script src="/Lee Wei Zhe/js/Login.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="login-container">
        <h1>Reset Password</h1>
        <div class="input-section"> 
            <asp:TextBox TextMode="password" id="txtPassword" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
            <label>Password</label>
            <span class="password-toggle" id="btnTogglePassword">
                <i class="fa-solid fa-eye eye-open"></i>
                <i class="fa-solid fa-eye-slash eye-close"></i>
            </span>
        </div>

        <div class="input-section"> 
            <asp:TextBox TextMode="password" id="txtConfirmPassword" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
            <label>Confirm Password</label>
            <span class="password-toggle" id="btnTogglePassword2">
                <i class="fa-solid fa-eye eye-open"></i>
                <i class="fa-solid fa-eye-slash eye-close"></i>
            </span>
        </div>
        <asp:Label id="errorMsg" runat="server" Visible="False">err</asp:Label>

        <asp:Button ID="btnConfirm" runat="server" Text="Confirm New Password" OnClick="btnConfirm_Click"/>
        <asp:LinkButton class="normal-link" id="lnkCancel" runat="server" OnClick="lnkCancel_Click">Cancel</asp:LinkButton>

    </div>
</asp:Content>
