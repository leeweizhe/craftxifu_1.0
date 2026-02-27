<%@ Page Title="Auto Farm Guides" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 默认显示分类面板
            categoryPanel.Visible = true;
            subFarmPanel.Visible = false;
        }
    }

    // 点击分类卡片触发的事件
    protected void SelectCategory(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string category = btn.CommandArgument; // 获取点击的是哪个分类
        
        lblCategoryTitle.Text = category + " Farms Database";
        LoadFarmsByCategory(category);
        
        categoryPanel.Visible = false;
        subFarmPanel.Visible = true;
    }

    private void LoadFarmsByCategory(string category)
    {
        string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            // 从数据库根据分类查询所有农场
            string sql = "SELECT * FROM farmTable WHERE Category = @cat";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@cat", category);
            
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            
            // 绑定到 Repeater 控件显示
            farmRepeater.DataSource = dt;
            farmRepeater.DataBind();
        }
    }

    protected void BackToCategories(object sender, EventArgs e)
    {
        categoryPanel.Visible = true;
        subFarmPanel.Visible = false;
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .farm-container { width: 90%; margin: 30px auto; color: #fff; }
        .page-title { font-size: 2.5rem; color: #68ff00; text-transform: uppercase; border-bottom: 4px solid #68ff00; padding-bottom: 10px; margin-bottom: 30px; }
        .farm-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        
        /* 分类卡片样式 */
        .category-card { background: rgba(0,0,0,0.8); border: 3px solid #444; padding: 20px; cursor: pointer; text-decoration: none; display: block; transition: 0.3s; text-align: center; }
        .category-card:hover { border-color: #68ff00; transform: scale(1.05); }
        .category-card h2 { color: #68ff00; text-transform: uppercase; margin: 15px 0; }
        
        /* 从数据库加载的农场列表样式 */
        .sub-farm-card { background: #1a1a1a; border-left: 5px solid #68ff00; padding: 15px; margin-bottom: 15px; display: flex; gap: 20px; align-items: center; }
        .sub-farm-card img { width: 120px; height: 80px; object-fit: cover; border: 1px solid #333; }
        .details-link { background: #68ff00; color: #000; padding: 5px 15px; text-decoration: none; font-weight: bold; font-size: 0.9rem; }
        
        .back-btn { color: #fbbf24; cursor: pointer; text-decoration: underline; margin-bottom: 20px; display: inline-block; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="farm-container">
        
        <%-- 面板 1：分类选择 --%>
        <asp:Panel ID="categoryPanel" runat="server">
            <h1 class="page-title">Farm Categories</h1>
            <div class="farm-grid">
                <asp:LinkButton ID="btnIron" runat="server" CssClass="category-card" CommandArgument="Iron" OnClick="SelectCategory">
                    <img src="/images/icons/iron_ingot.png" style="width:64px;"/>
                    <h2>Iron Farms</h2>
                    <p>Endless iron for beacons and hoppers.</p>
                </asp:LinkButton>

                <asp:LinkButton ID="btnGold" runat="server" CssClass="category-card" CommandArgument="Gold" OnClick="SelectCategory">
                    <img src="/images/icons/gold_ingot.png" style="width:64px;"/>
                    <h2>Gold Farms</h2>
                    <p>Automated XP and bartering gold.</p>
                </asp:LinkButton>
            </div>
        </asp:Panel>

        <%-- 面板 2：详细农场列表 (从数据库获取数据) --%>
        <asp:Panel ID="subFarmPanel" runat="server">
            <asp:LinkButton ID="btnBack" runat="server" OnClick="BackToCategories" CssClass="back-btn"><< Back to Categories</asp:LinkButton>
            <h1 class="page-title"><asp:Label ID="lblCategoryTitle" runat="server" /></h1>
            
            <asp:Repeater ID="farmRepeater" runat="server">
                <ItemTemplate>
                    <div class="sub-farm-card">
                        <img src='<%# Eval("Thumbnail") %>' />
                        <div style="flex-grow:1;">
                            <h3 style="color:#fbbf24;"><%# Eval("Title") %></h3>
                            <p style="font-size:0.9rem; color:#ccc;"><%# Eval("Description") %></p>
                        </div>
                        <div style="text-align:right;">
                            <span style="display:block; margin-bottom:10px;">EFFICIENCY: <b style="color:#68ff00;"><%# Eval("Efficiency") %></b></span>
                            <%-- 这里点击后跳转到详细教学页，并带上 FarmId --%>
                            <a href='FarmDetails.aspx?id=<%# Eval("FarmId") %>' class="details-link">VIEW TUTORIAL</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

    </div>
</asp:Content>