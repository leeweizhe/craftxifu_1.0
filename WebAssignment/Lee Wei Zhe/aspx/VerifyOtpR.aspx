<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VerifyOtpR.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.VerifyOtpR" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/Login.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
    <h1>Verify Your OTP</h1>
    <div class="input-section">
        <asp:TextBox type="text" id="txtOtp" runat="server" ClientIDMode="Static" placeholder=" " required="required"/>
        <label>OTP code</label>
    </div>

    <asp:Label id="errorMsg" runat="server">If that email matches an account, an OTP has been sent.</asp:Label>

    <asp:Button id="btnVerify" runat="server" Text="Verify" OnClick="btnVerify_Click" />

    <asp:LinkButton class="normal-link" id="lnkBack" runat="server" OnClick="lnkBack_Click" CausesValidation="false">Back</asp:LinkButton>
</div>
</asp:Content>
