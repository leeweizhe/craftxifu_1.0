<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUser.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.ManageUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* KILL DIRT Borders */
        html, body, form, .container, .body-content, #MainContent { margin: 0 !important; padding: 0 !important; width: 100% !important; max-width: none !important; overflow-x: hidden; }
        
        /* Dashboard Reset - Moved up by reducing padding-top */
        .admin-page-wrapper { background: transparent; min-height: 100vh; font-family: 'Minecraft', sans-serif; position: relative; width: 100%; display: flex; flex-direction: column; align-items: center; justify-content: flex-start; padding-top: 60px; }
        .admin-page-wrapper::before { display: none; }
        
        /* THE WIDE BOX: Combined Header and Results */
        .admin-content-container { width: 98%; max-width: 1800px; z-index: 2; position: relative; margin-top: 0px; background: transparent; border: none; }
        
        /* TOP PART: Connected Header */
        .admin-header-row { display: flex; align-items: center; justify-content: space-between; padding: 35px 50px; border-radius: 12px 12px 0 0; background: rgba(15, 15, 15, 0.95); border: 1px solid #333; border-bottom: none; backdrop-filter: blur(10px); }
        .main-title { font-size: 3rem; color: #00ff55; text-transform: uppercase; letter-spacing: 5px; text-shadow: 2px 2px #000; margin: 0; }
        
        /* Search Area - Oval Style */
        .search-container { display: flex; align-items: center; gap: 20px; }
        .search-label { color: #fff; text-transform: uppercase; font-size: 1.1rem; letter-spacing: 2px; }
        .oval-search-bar { width: 400px; padding: 15px 30px; border-radius: 50px; background: rgba(0,0,0,0.8); border: 2px solid #444; color: #fff; font-size: 1.1rem; transition: 0.3s; }
        
        /* Clear Button Style - Red theme for reset action */
        .clear-btn { padding: 14px 40px; border-radius: 50px; border: 1px solid #ff4444; background: transparent; color: #ff4444; font-size: 1.1rem; text-transform: uppercase; cursor: pointer; transition: 0.3s; }
        .clear-btn:hover { background: #ff4444; color: #fff; box-shadow: 0 0 20px rgba(255, 68, 68, 0.5); }
       
        /* BOTTOM PART: Connected Grid Container */
        .users-results-area { background: rgba(10, 10, 10, 0.85); border: 1px solid #333; border-radius: 0 0 12px 12px; padding: 40px; min-height: 600px; }
        
        /* THE 3-USER ROW GRID */
        .users-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; width: 100%; }
       
        /* User Card Styling */
        .user-card { background: rgba(25, 25, 25, 0.9); border: 1px solid #333; padding: 25px; display: flex; align-items: center; gap: 20px; border-radius: 4px; transition: 0.3s; }
        .user-card:hover { transform: translateY(-5px); border-color: #00ff55; background: rgba(35, 35, 35, 0.95); }
        
        /* ADD USER CARD - Minecraft Style */
        .add-user-card { background: rgba(0, 255, 85, 0.05); border: 2px dashed #00ff55; padding: 25px; display: flex; align-items: center; gap: 20px; border-radius: 4px; transition: 0.3s; cursor: pointer; text-decoration: none; }
        .add-user-card:hover { background: rgba(0, 255, 85, 0.15); transform: translateY(-5px); box-shadow: 0 0 20px rgba(0, 255, 85, 0.2); }
        .plus-icon-area { width: 110px; height: 110px; background: #000; border: 1px solid #00ff55; display: flex; justify-content: center; align-items: center; flex-shrink: 0; position: relative; }
        .plus-icon-area::before { content: ""; position: absolute; width: 50px; height: 8px; background-color: #00ff55; }
        .plus-icon-area::after { content: ""; position: absolute; width: 8px; height: 50px; background-color: #00ff55; }
        .add-text-area .add-title { color: #00ff55; font-size: 1.7rem; text-transform: uppercase; margin: 0; text-shadow: 1px 1px #000; font-family: 'Minecraft', sans-serif; }
        .add-text-area .add-desc { color: #888; font-size: 0.95rem; font-family: 'Minecraft', sans-serif; }

        /* Card Content Components */
        .profile-pic-area { width: 110px; height: 110px; overflow: hidden; border-radius: 4px; background: #000; flex-shrink: 0; border: 1px solid #444; }
        .profile-img { width: 100%; height: 100%; object-fit: cover; }
        .user-info-area { flex: 1; display: flex; flex-direction: column; gap: 8px; }
        .user-name { color: #fff; font-size: 1.7rem; text-transform: uppercase; margin: 0; text-shadow: 1px 1px #000; }
        .user-email { color: #888; font-size: 0.95rem; }
        .edit-btn { padding: 10px 25px; border-radius: 50px; border: 1px solid #444; background: transparent; color: #aaa; text-transform: uppercase; cursor: pointer; transition: 0.3s; align-self: flex-end; }
        .edit-btn:hover { border-color: #00ff55; color: #fff; background: rgba(0, 255, 85, 0.1); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="admin-page-wrapper">
        <div class="admin-content-container">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="admin-header-row">
                        <h1 class="main-title">Manage Users</h1>
                        <div class="search-container">
                            <span class="search-label">Search (🔍):</span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="oval-search-bar" 
                                placeholder="Enter username or email..." onkeyup="triggerSearch();" 
                                ClientIDMode="Static"></asp:TextBox>
    
                            <asp:Button ID="btnHiddenSearch" runat="server" OnClick="btnHiddenSearch_Click" style="display:none;" ClientIDMode="Static" />
    
                            <asp:Button ID="btnClearSearch" runat="server" Text="Clear" CssClass="clear-btn" OnClick="btnClearSearch_Click" />
                        </div>
                    </div>

                    <div class="users-results-area">
                        <asp:Repeater ID="rptUsers" runat="server">
                            <HeaderTemplate>
                                <div class="users-grid">
                                    <a href="/Lee Wei Zhe/aspx/RegistrationPage.aspx" class="add-user-card">
                                        <div class="plus-icon-area"></div>
                                        <div class="add-text-area">
                                            <h2 class="add-title">ADD USER</h2>
                                            <span class="add-desc">CREATE NEW ACCOUNT</span>
                                        </div>
                                    </a>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div class="user-card">
                                    <div class="profile-pic-area">
                                        <img src='<%# ResolveUrl(string.IsNullOrEmpty(Eval("ProfilePicture")?.ToString()) ? "~/images/default-pfp.png" : Eval("ProfilePicture").ToString()) %>' 
                                             alt='PFP' 
                                             class="profile-img" />
                                    </div>
                                    <div class="user-info-area">
                                        <h2 class="user-name"><%# Eval("Username") %></h2>
                                        <span class="user-email"><%# Eval("Email") %></span>
                                    </div>
                                    <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="edit-btn" 
                                        PostBackUrl='<%# "ManageUserDetail.aspx?id=" + Eval("UserId") %>' />
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                </div>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <script type="text/javascript">
        function triggerSearch() {
            var btn = document.getElementById('btnHiddenSearch');
            if (btn) btn.click();
        }

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            var searchInput = document.getElementById('txtSearch');
            if (searchInput) {
                searchInput.focus();
                var val = searchInput.value;
                searchInput.value = '';
                searchInput.value = val;
            }
        });
    </script>
</asp:Content>
