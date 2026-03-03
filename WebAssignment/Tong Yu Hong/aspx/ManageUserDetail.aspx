<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUserDetail.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.ManageUserDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/RegistrationPage.css" rel="stylesheet" />
    <script src="/Lee Wei Zhe/js/Login.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style type="text/css">
        /* Base container and layout */
        .login-container { background-color: white; box-shadow: 0 4px 5px rgba(255, 255, 255, 0.3); border-radius: 10px; padding: 20px 30px; max-width: 450px; width: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center; margin: 40px auto; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .login-container h1 { margin-bottom: 20px; color: #333; }
        
        /* Matching the Register Page style */
        .input-section { position: relative; margin: 10px 0; height: 50px; width: 100%; }
        .input-section label { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); font-size: 1rem; pointer-events: none; transition: all 0.3s ease; color: #666; }
        .input-section input, .country-dropdown { background-color: #d5d5d5; height: 100%; width: 100%; padding: 20px 10px 5px 10px; border-radius: 8px; border: 1px solid #808080; font-size: 1rem; transition: all 0.3s ease; box-sizing: border-box; cursor: pointer;}
        
        /* Label float effects */
        .input-section input:focus ~ label, 
        .input-section input:not(:placeholder-shown) ~ label { top: 5px; transform: translateY(0); font-size: 0.75rem; color: #00b63b; }

        /* THE FIX: Highlights Country/Role when they have a selection */
        .input-section input:focus, 
        .country-dropdown:focus,
        .country-dropdown:not([value=""]) { border-color: #00b63b; background-color: white; outline: none; }

        /* Turns static labels green when box is active */
        .static-label { top: 5px !important; transform: translateY(0) !important; font-size: 0.75rem !important; color: black !important; z-index: 10; position: absolute; left: 10px; transition: all 0.3s ease; }
        .input-section:focus-within .static-label,
        .country-dropdown:not([value=""]) ~ .static-label { color: #00b63b !important; }
        
        /* GENDER BOX FIX: Restored from your register page logic */
        .gender-box { background-color: #d5d5d5; border-radius: 8px; border: 1px solid #808080; height: 55px !important; transition: all 0.3s ease; }
        
        /* Lights up Gender box when a radio is clicked */
        .gender-box:has(input:checked) { background-color: white; border-color: #00b63b; }
        .gender-box:has(input:checked) .static-label { color: #00b63b !important; }

        .radio-options { position: absolute; bottom: 5px; left: 10px; display: flex; align-items: center; }
        .radio-options label { position: static !important; transform: none !important; font-size: 1rem !important; pointer-events: auto !important; margin-left: 5px; margin-right: 30px; color: black !important; font-weight: bold; transition: color 0.3s ease; }
        
        /* Radio circle restoration */
        .radio-options input[type="radio"] { height: auto !important; width: auto !important; appearance: radio !important; -webkit-appearance: radio !important; cursor: pointer; margin: 0 !important; }

        /* Green only when clicked */
        .radio-options input:checked + label { color: #00b63b !important; }
        .input-section.gender-box:focus-within .static-label { color: #00b63b !important; }

        /* Pixel font for errors */
        .error-pixel-font { font-family: 'PF Tempesta Seven', sans-serif; font-size: 12px; text-transform: uppercase; color: red; margin: 10px 0; display: block; }
        
        .login-container input[type="submit"] { background-color: #009731; color: white; width: 100%; padding: 0.75rem; margin: 20px 0; font-size: 1.3rem; border-radius: 8px; border: none; cursor: pointer; transition: all 0.3s ease; }
        .login-container input[type="submit"]:hover { background-color: #00b63b; transform: scale(1.05); }
        .normal-link { text-decoration: none; color: #555; font-size: 1.1rem; /* Increased size for visibility */font-weight: bold; /* Made bold to be more obvious */margin-top: 20px; transition: all 0.3s ease; display: inline-block;}
        .normal-link:hover { color: #007bff; /* Brighter blue on hover */transform: scale(1.1); /* Subtle grow effect */text-decoration: underline;}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
        <h1>Edit User Profile</h1>
        
        <div class="input-section"><asp:TextBox ID="txtFname" runat="server" placeholder=" "/><label>First Name</label></div>
        <div class="input-section"><asp:TextBox ID="txtLname" runat="server" placeholder=" "/><label>Last Name</label></div>
        <div class="input-section"><asp:TextBox ID="txtEmail" runat="server" placeholder=" "/><label>Email</label></div>
        
        <div class="input-section gender-box">
            <label class="static-label">GENDER</label>
            <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" CssClass="radio-options">
                <asp:ListItem Text="Male" Value="M" /><asp:ListItem Text="Female" Value="F" />
            </asp:RadioButtonList>
        </div>

        <div class="input-section">
            <label class="static-label">Country</label>
            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="country-dropdown">
                <asp:ListItem Text="-- Select Country --" Value="" />
            </asp:DropDownList>
        </div>

        <div class="input-section"><asp:TextBox ID="txtUsername" runat="server" placeholder=" "/><label>Username</label></div>
        
        <div class="input-section"><asp:TextBox TextMode="password" id="txtPassword" runat="server" placeholder=" "/><label>New Password (Leave blank to keep current)</label></div>
        <div class="input-section"><asp:TextBox TextMode="password" id="txtConfirmPassword" runat="server" placeholder=" "/><label>Confirm New Password</label></div>
        
        <div class="input-section">
            <label class="static-label">Account Role</label>
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="country-dropdown">
                <asp:ListItem Text="Member" Value="Member" /><asp:ListItem Text="Creator" Value="Creator" /><asp:ListItem Text="Admin" Value="Admin" />
            </asp:DropDownList>
        </div>

        <asp:Label id="errorMsg" runat="server" Visible="False" CssClass="error-pixel-font"></asp:Label>
        
        <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" OnClick="btnUpdate_Click"/>
        
        <asp:LinkButton class="normal-link" id="lnkBack" runat="server" OnClick="lnkBack_Click">Back to Manage Users</asp:LinkButton>
    </div>
</asp:Content>
