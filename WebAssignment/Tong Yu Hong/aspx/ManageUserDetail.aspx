<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUserDetail.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.ManageUserDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/RegistrationPage.css" rel="stylesheet" />
    <script src="/Lee Wei Zhe/js/Login.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style type="text/css">
        /* Base container and layout */
        .login-container { background-color: white; box-shadow: 0 4px 5px rgba(255, 255, 255, 0.3); border-radius: 10px; padding: 20px 30px; max-width: 450px; width: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center; margin: 40px auto; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .login-container h1 { margin-bottom: 20px; color: #333; }
    
        /* Input layout */
        .input-section { position: relative; margin: 10px 0; height: 50px; width: 100%; }
        .input-section label { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); font-size: 1rem; pointer-events: none; transition: all 0.3s ease; color: #666; }
        .input-section input, .country-dropdown { background-color: #d5d5d5; height: 100%; width: 100%; padding: 20px 10px 5px 10px; border-radius: 8px; border: 1px solid #808080; font-size: 1rem; transition: all 0.3s ease; box-sizing: border-box; cursor: pointer;}
    
        /* --- LOCKED FIELD STYLES --- */
        /* Applied to ReadOnly TextBoxes and Disabled Selects */
        .readonly-input, 
        .country-dropdown:disabled { 
            background-color: #ebebeb !important; 
            border-color: #b5b5b5 !important; 
            color: #777 !important; 
            cursor: not-allowed !important; 
            pointer-events: none; 
        }
    
        /* Adjusts label color for locked fields */
        .readonly-input ~ label,
        .country-dropdown:disabled ~ .static-label { color: #888 !important; }

        /* Label float effects (for editable fields) */
        .input-section input:focus ~ label, 
        .input-section input:not(:placeholder-shown) ~ label { top: 5px; transform: translateY(0); font-size: 0.75rem; color: #00b63b; }

        /* Focus Highlights */
        .input-section input:focus, 
        .country-dropdown:focus:not(:disabled) { border-color: #00b63b; background-color: white; outline: none; }

        /* Static labels (Gender/Country/Role) */
        .static-label { top: 5px !important; transform: translateY(0) !important; font-size: 0.75rem !important; color: black !important; z-index: 10; position: absolute; left: 10px; transition: all 0.3s ease; }
        .input-section:focus-within .static-label { color: #00b63b !important; }
    
        /* GENDER BOX STYLE */
        .gender-box { background-color: #d5d5d5; border-radius: 8px; border: 1px solid #808080; height: 55px !important; transition: all 0.3s ease; }
        /* Visual lock for Gender RadioList */
        .gender-box[style*="pointer-events: none"], .gender-box:has(input:disabled) { background-color: #ebebeb !important; opacity: 0.8; }

        .radio-options { position: absolute; bottom: 5px; left: 10px; display: flex; align-items: center; }
        .radio-options label { position: static !important; transform: none !important; font-size: 1rem !important; pointer-events: auto !important; margin-left: 5px; margin-right: 30px; color: black !important; font-weight: bold; transition: color 0.3s ease; }
        .radio-options input[type="radio"] { height: auto !important; width: auto !important; appearance: radio !important; cursor: pointer; margin: 0 !important; }
    
        /* Error Font */
        .error-pixel-font { font-family: 'PF Tempesta Seven', sans-serif; font-size: 12px; text-transform: uppercase; color: red; margin: 10px 0; display: block; }
    
        /* Buttons & Links */
        .login-container input[type="submit"] { background-color: #009731; color: white; width: 100%; padding: 0.75rem; margin: 20px 0; font-size: 1.3rem; border-radius: 8px; border: none; cursor: pointer; transition: all 0.3s ease; font-family: 'Segoe UI', sans-serif;}
        .login-container input[type="submit"]:hover { background-color: #00b63b; transform: scale(1.05); }
    
        .normal-link { text-decoration: none; color: #555; font-size: 1.1rem; font-weight: bold; margin-top: 20px; transition: all 0.3s ease; display: inline-block;}
        .normal-link:hover { color: #007bff; transform: scale(1.1); text-decoration: underline;}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
        <h1>Edit User Profile</h1>
        
        <div class="input-section">
            <asp:TextBox ID="txtFname" runat="server" placeholder=" " ReadOnly="true" CssClass="readonly-input"/>
            <label>First Name</label>
        </div>

        <div class="input-section">
            <asp:TextBox ID="txtLname" runat="server" placeholder=" " ReadOnly="true" CssClass="readonly-input"/>
            <label>Last Name</label>
        </div>
        
        <div class="input-section">
            <asp:TextBox ID="txtEmail" runat="server" placeholder=" " ReadOnly="true" CssClass="readonly-input" />
            <label>Email</label>
        </div>
        
        <div class="input-section gender-box">
            <label class="static-label">GENDER</label>
            <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" CssClass="radio-options" Enabled="false">
                <asp:ListItem Text="Male" Value="M" />
                <asp:ListItem Text="Female" Value="F" />
            </asp:RadioButtonList>
        </div>

        <div class="input-section">
            <label class="static-label">Country</label>
            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="country-dropdown" Enabled="false">
                <asp:ListItem Text="-- Select Country --" Value="" />
            </asp:DropDownList>
        </div>

        <div class="input-section">
            <asp:TextBox ID="txtUsername" runat="server" placeholder=" " ReadOnly="true" CssClass="readonly-input"/>
            <label>Username</label>
        </div>
        
        <div class="input-section">
            <label class="static-label">Account Role</label>
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="country-dropdown">
                <asp:ListItem Text="Member" Value="Member" />
                <asp:ListItem Text="Instructor" Value="Instructor" />
                <asp:ListItem Text="Admin" Value="Admin" />
            </asp:DropDownList>
        </div>

        <asp:Label id="errorMsg" runat="server" Visible="False" CssClass="error-pixel-font"></asp:Label>
        
        <asp:Button ID="btnUpdate" runat="server" Text="Update Role Only" OnClick="btnUpdate_Click"/>
        
        <asp:LinkButton class="normal-link" id="lnkBack" runat="server" OnClick="lnkBack_Click">Back to Manage Users</asp:LinkButton>
    </div>
</asp:Content>
