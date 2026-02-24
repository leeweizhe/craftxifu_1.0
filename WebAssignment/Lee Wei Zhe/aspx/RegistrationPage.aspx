<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistrationPage.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.RegistrationPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../css/RegistrationPage.css" rel="stylesheet" />
    <script src="../js/Login.js"></script>
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
        
    <div class="input-section">
        <label>Gender</label>
        <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" CssClass="radio-options">
            <asp:ListItem Text="Male" Value="male" />
            <asp:ListItem Text="Female" Value="female" />
        </asp:RadioButtonList>
    </div>
        
    <div class="input-section">
        <label>Country</label>
    
        <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control">
            <asp:ListItem Text="Select your country" Value="" Selected="True" />
            <asp:ListItem Text="Malaysia" Value="my" />
            <asp:ListItem Text="United States" Value="us" />
            <asp:ListItem Text="United Kingdom" Value="uk" />
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

    <asp:Label id="errorMsg" runat="server" Visible="False">geh</asp:Label>

    <asp:Button ID="btnRegister" runat="server" Text="Register" />


    <asp:LinkButton class="normal-link" id="lnkHaveAccount" runat="server" OnClick="lnkHaveAccount_Click">Already Have Account? Login Here</asp:LinkButton>
</div>
</asp:Content>
