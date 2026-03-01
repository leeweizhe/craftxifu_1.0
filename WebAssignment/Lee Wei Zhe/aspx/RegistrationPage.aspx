<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistrationPage.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.RegistrationPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/RegistrationPage.css" rel="stylesheet" />
    <script src="/Lee Wei Zhe/js/Login.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
    <h1>Registration Page</h1>

    <div class="input-section">
        <asp:TextBox type="text" id="txtFname" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
        <label>First Name</label>
    </div>

    <div class="input-section">
        <asp:TextBox type="text" id="txtLname" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
        <label>Last Name</label>
    </div>

    <div class="input-section">
        <asp:TextBox type="text" id="txtEmail" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
        <label>Email</label>
    </div>
        
    <div class="input-section gender-box">
    <label class="static-label">Gender</label>
    <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" CssClass="radio-options">
        <asp:ListItem Text="Male" Value="M" />
        <asp:ListItem Text="Female" Value="F" />
    </asp:RadioButtonList>
</div>
        
<div class="input-section">
    <label class="static-label">Country</label>
    <asp:DropDownList ID="ddlCountry" runat="server" CssClass="country-dropdown">
        <asp:ListItem Text="Select your country" Value="" Selected="True" />
        <asp:ListItem Text="Malaysia" Value="Malaysia" />
        <asp:ListItem Text="United States" Value="United States" />
        <asp:ListItem Text="United Kingdom" Value="United Kingdom" />
    </asp:DropDownList>
</div>
        
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

    <div class="input-section"> 
        <asp:TextBox TextMode="password" id="txtConfirmPassword" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
        <label>Confirm Password</label>
        <span class="password-toggle" id="btnTogglePassword2">
            <i class="fa-solid fa-eye eye-open"></i>
            <i class="fa-solid fa-eye-slash eye-close"></i>
        </span>
    </div>

    <asp:Label id="errorMsg" runat="server" Visible="False">err</asp:Label>

    <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click"/>


    <asp:LinkButton class="normal-link" id="lnkHaveAccount" runat="server" OnClick="lnkHaveAccount_Click">Already Have Account? Login Here</asp:LinkButton>
</div>
</asp:Content>
