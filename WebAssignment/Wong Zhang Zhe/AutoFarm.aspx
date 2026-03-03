<%-- 1. 页面指令与母版页关联 --%>
<%@ Page Title="Auto Farm Guides" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AutoFarm.aspx.cs" Inherits="WebAssignment.AutoFarm" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .farm-container { width: 90%; margin: 30px auto; color: #fff; }
        .page-title { font-size: 2.5rem; color: #68ff00; text-transform: uppercase; border-bottom: 4px solid #68ff00; padding-bottom: 10px; margin-bottom: 30px; }
        .farm-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        
        /* 分类卡片样式 */
        .category-card { background: rgba(0,0,0,0.85); border: 3px solid #444; padding: 25px; cursor: pointer; text-decoration: none; display: block; transition: 0.3s; text-align: center; }
        .category-card:hover { border-color: #68ff00; transform: translateY(-5px); box-shadow: 0 5px 15px rgba(104, 255, 0, 0.4); }
        .category-card h2 { color: #68ff00; text-transform: uppercase; margin-top: 15px; font-size: 1.5rem; }
        .category-icon { width: 80px; height: 80px; image-rendering: pixelated; object-fit: contain; }
        
        /* 列表卡片样式 */
        .sub-farm-card { background: #1a1a1a; border-left: 5px solid #68ff00; padding: 15px; margin-bottom: 15px; display: flex; gap: 20px; align-items: center; }
        .sub-farm-card img { width: 150px; height: 100px; object-fit: cover; border: 1px solid #333; }
        .details-link { background: #68ff00; color: #000; padding: 8px 20px; text-decoration: none; font-weight: bold; border-radius: 2px; }
        .details-link:hover { background: #52cc00; }
        .back-btn { color: #fbbf24; cursor: pointer; text-decoration: underline; margin-bottom: 20px; display: inline-block; font-weight: bold; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="farm-container">
        
        <%-- 面板 1：动态分类面板 --%>
        <asp:Panel ID="categoryPanel" runat="server">
            <h1 class="page-title">Farm Categories</h1>
            <div class="farm-grid">
                <asp:Repeater ID="categoryRepeater" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnCat" runat="server" CssClass="category-card" 
                            CommandArgument='<%# Eval("Category") %>' OnClick="SelectCategory">
                            
                            <%-- 核心修改：路径指向 pic 文件夹，文件名自动转小写并匹配图标 --%>
                            <%-- 例如：food_icon.png, xp_icon.png --%>
                            <img src='/Wong Zhang Zhe/pic/<%# Eval("Category").ToString().ToLower() %>_icon.png' 
                                 class="category-icon" 
                                 onerror="this.src='/Wong Zhang Zhe/pic/iron_1.png';" />
                            
                            <h2><%# Eval("Category") %> Farms</h2>
                            <p style="color:#888; font-size:0.9rem;">Click to explore designs</p>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div> 
        </asp:Panel>

        <%-- 面板 2：农场具体列表 --%>
        <asp:Panel ID="subFarmPanel" runat="server">
            <asp:LinkButton ID="btnBack" runat="server" OnClick="BackToCategories" CssClass="back-btn"><< BACK TO CATEGORIES</asp:LinkButton>
            <h1 class="page-title"><asp:Label ID="lblCategoryTitle" runat="server" /></h1>
            
            <asp:Repeater ID="farmRepeater" runat="server">
                <ItemTemplate>
                    <div class="sub-farm-card">
                        <%-- 读取数据库中的 Thumbnail 路径 --%>
                        <img src='<%# ResolveUrl(Eval("Thumbnail").ToString()) %>' />
                        <div style="flex-grow:1;">
                            <h3 style="color:#fbbf24; margin-bottom:5px;"><%# Eval("Title") %></h3>
                            <p style="font-size:0.9rem; color:#ccc;"><%# Eval("Description") %></p>
                        </div>
                        <div style="text-align:right; min-width:160px;">
                            <span style="display:block; margin-bottom:10px;">EFFICIENCY: <b style="color:#68ff00;"><%# Eval("Efficiency") %></b></span>
                            <a href='FarmDetails.aspx?id=<%# Eval("FarmId") %>' class="details-link">VIEW TUTORIAL</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

    </div>
</asp:Content>