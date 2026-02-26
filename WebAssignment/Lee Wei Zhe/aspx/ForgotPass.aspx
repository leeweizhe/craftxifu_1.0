<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPass.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.ForgotPass" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <link href="../css/Login.css" rel="stylesheet" />
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="login-container">
        <h1>Reset Password using Email</h1>
        <div class="input-section">
            <asp:TextBox type="text" id="txtEmail" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
            <label>Email</label>
        </div>

        <asp:Label id="errorMsg" runat="server" Visible="False">err</asp:Label>

        <asp:Button id="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" />

        <asp:LinkButton class="normal-link" id="lnkLogin" runat="server" OnClick="lnkLogin_Click">Back to Login</asp:LinkButton>
        <asp:LinkButton class="normal-link" id="lnkRegister" runat="server" OnClick="lnkRegister_Click" >New? Register here</asp:LinkButton>
    </div>

</asp:Content>
