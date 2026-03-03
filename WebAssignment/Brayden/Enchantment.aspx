<%@ Page Title="Enchantment Guide" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Enchantment.aspx.cs" Inherits="WebAssignment.Brayden.Enchantment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .enc-container { width: 90%; margin: 30px auto; color: #fff; }
        .page-title { font-size: 2.5rem; color: #9b59b6; text-transform: uppercase; border-bottom: 4px solid #9b59b6; padding-bottom: 10px; margin-bottom: 30px; }
        .section-label { color: #9b59b6; text-transform: uppercase; margin: 30px 0 12px; display: block; font-size: 1.3rem; border-left: 5px solid #9b59b6; padding-left: 15px; }

        /* Category grid */
        .enc-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; }
        .category-card { background: rgba(0,0,0,0.85); border: 3px solid #555; padding: 25px; cursor: pointer; text-decoration: none; display: block; transition: 0.3s; text-align: center; }
        .category-card:hover { border-color: #9b59b6; transform: translateY(-5px); box-shadow: 0 5px 20px rgba(155,89,182,0.5); }
        .cat-icon { font-size: 3rem; margin-bottom: 10px; display: block; }
        .category-card h2 { color: #9b59b6; text-transform: uppercase; font-size: 1.3rem; margin-top: 8px; }
        .category-card p  { color: #888; font-size: 0.85rem; margin-top: 6px; }

        /* List rows */
        .enc-row { background: #1a1a1a; border-left: 5px solid #9b59b6; padding: 15px 20px; margin-bottom: 12px; display: flex; align-items: center; gap: 20px; transition: 0.2s; }
        .enc-row:hover { background: #242424; }
        .enc-row-thumb { width: 70px; height: 70px; object-fit: contain; image-rendering: pixelated; border: 2px solid #444; background: #0d0d0d; flex-shrink: 0; }
        .enc-row-info { flex: 1; }
        .enc-row-info h3 { color: #e0a0ff; font-size: 1.2rem; margin-bottom: 4px; }
        .enc-row-info p  { color: #aaa; font-size: 0.9rem; }
        .badge-treasure { background: #f39c12; color: #000; padding: 2px 10px; font-size: 0.75rem; margin-left: 10px; }
        .level-badge { background: #9b59b6; color: #fff; padding: 2px 12px; font-size: 0.8rem; white-space: nowrap; }

        /* Detail page */
        .detail-box { background: rgba(0,0,0,0.9); border: 4px solid #555; padding: 35px; }
        .detail-header { border-bottom: 3px solid #9b59b6; padding-bottom: 20px; margin-bottom: 25px; display: flex; align-items: flex-start; gap: 25px; }
        .detail-thumb { width: 110px; height: 110px; image-rendering: pixelated; object-fit: contain; border: 3px solid #9b59b6; background: #0d0d0d; padding: 5px; flex-shrink: 0; }
        .detail-title { font-size: 2.4rem; color: #e0a0ff; }
        .detail-sub   { color: #9b59b6; font-size: 1rem; margin-top: 6px; }
        .level-pip { background: #9b59b6; color: #fff; padding: 4px 12px; margin-right: 6px; font-size: 0.9rem; display: inline-block; margin-top: 10px; }
        .meta-row { display: flex; gap: 40px; flex-wrap: wrap; margin-bottom: 20px; }
        .meta-item label { color: #888; font-size: 0.8rem; text-transform: uppercase; display: block; }
        .meta-item span  { color: #fff; font-size: 1rem; }

        /* Detail image – the big visual shown below the header */
        .detail-main-img { width: 100%; max-height: 700px; height: 700px; object-fit: cover; border: 3px solid #9b59b6; image-rendering: pixelated; margin-bottom: 8px; }
        .img-caption { color: #666; font-size: 0.8rem; text-align: center; margin-bottom: 25px; }

        .content-box { background: #111; border: 1px solid #333; padding: 20px; color: #ccc; line-height: 1.8; font-size: 1rem; }

        /* Buttons */
        .btn-edit   { background: #2980b9; color: #fff; border: none; padding: 8px 20px; cursor: pointer; font-size: 0.9rem; margin-right: 10px; font-family: inherit; }
        .btn-delete { background: #c0392b; color: #fff; border: none; padding: 8px 20px; cursor: pointer; font-size: 0.9rem; font-family: inherit; }
        .btn-add    { background: #27ae60; color: #fff; border: none; padding: 8px 20px; cursor: pointer; font-size: 0.9rem; font-family: inherit; margin-bottom: 20px; }
        .btn-save   { background: #27ae60; color: #fff; border: none; padding: 10px 25px; cursor: pointer; font-size: 1rem; font-family: inherit; }
        .btn-cancel { background: #555; color: #fff; border: none; padding: 10px 25px; cursor: pointer; font-size: 1rem; font-family: inherit; margin-left: 10px; }
        .back-btn   { color: #f39c12; cursor: pointer; text-decoration: none; margin-bottom: 20px; display: inline-block; font-size: 1rem; }
        .back-btn:hover { color: #fbbf24; }
        .view-btn   { background: #9b59b6; color: #fff; padding: 8px 18px; text-decoration: none; font-size: 0.85rem; border: none; cursor: pointer; font-family: inherit; }

        /* Form */
        .form-panel { background: rgba(0,0,0,0.9); border: 4px solid #555; padding: 35px; max-width: 800px; margin: 0 auto; }
        .form-panel h2 { color: #9b59b6; font-size: 1.8rem; border-bottom: 2px solid #9b59b6; padding-bottom: 10px; margin-bottom: 25px; }
        .form-row { margin-bottom: 18px; }
        .form-row label { color: #aaa; font-size: 0.9rem; display: block; margin-bottom: 6px; text-transform: uppercase; }
        .form-input, .form-textarea, .form-select { width: 100%; background: #1a1a1a; border: 2px solid #555; color: #fff; padding: 10px; font-family: inherit; font-size: 0.95rem; }
        .form-textarea { height: 120px; resize: vertical; }
        .form-row-half { display: flex; gap: 20px; }
        .form-row-half .form-row { flex: 1; }
        .error-msg { color: #e74c3c; font-size: 0.9rem; margin-bottom: 15px; display: block; }
        .chk-row { display: flex; align-items: center; gap: 10px; color: #ccc; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="enc-container">

    <%-- PANEL 1: CATEGORIES --%>
    <asp:Panel ID="categoryPanel" runat="server">
        <h1 class="page-title">✦ Enchantment Guide</h1>
        <p style="color:#aaa; margin-bottom:25px; font-size:1rem;">Master the art of enchanting to supercharge your gear. Select a category to explore all 20 enchantments.</p>
        <div class="enc-grid">
            <asp:Repeater ID="categoryRepeater" runat="server">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CssClass="category-card"
                        CommandArgument='<%# Eval("Category") %>' OnClick="SelectCategory">
                        <span class="cat-icon"><%# ((WebAssignment.Wong_Zhang_Zhe.Enchantment)Page).GetCategoryIcon(Eval("Category").ToString()) %></span>
                        <h2><%# Eval("Category") %></h2>
                        <p>Click to explore</p>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>

    <%-- PANEL 2: LIST --%>
    <asp:Panel ID="listPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToCategories">« BACK TO CATEGORIES</asp:LinkButton>
        <asp:Button ID="btnAddNew" runat="server" CssClass="btn-add" Text="+ ADD ENCHANTMENT" OnClick="ShowAddForm" Style="float:right;" Visible="false" />
        <h1 class="page-title"><asp:Label ID="lblListTitle" runat="server" /></h1>

        <asp:Repeater ID="enchantRepeater" runat="server">
            <ItemTemplate>
                <div class="enc-row">
                    <%-- Thumbnail image on list row --%>
                    <img src='<%# ResolveUrl(Eval("Thumbnail").ToString()) %>'
                         class="enc-row-thumb"
                         onerror="this.style.display='none'" alt='<%# Eval("Name") %>' />
                    <div class="enc-row-info">
                        <h3>
                            <%# Eval("Name") %>
                            <%# Eval("TreasureOnly").ToString()=="True" ? "<span class='badge-treasure'>TREASURE</span>" : "" %>
                        </h3>
                        <p><%# Eval("Description") %></p>
                    </div>
                    <span class="level-badge">MAX LV <%# Eval("MaxLevel") %></span>
                    <asp:LinkButton runat="server" CssClass="view-btn"
                        CommandArgument='<%# Eval("EnchantmentId") %>' OnClick="ViewDetail">VIEW »</asp:LinkButton>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <%-- PANEL 3: DETAIL --%>
    <asp:Panel ID="detailPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToList">« BACK TO LIST</asp:LinkButton>
        <div class="detail-box">

            <div class="detail-header">
                <asp:Image ID="imgDetailThumb" runat="server" CssClass="detail-thumb" />
                <div>
                    <div class="detail-title"><asp:Label ID="lblDetailName" runat="server" /></div>
                    <div class="detail-sub">
                        <asp:Label ID="lblDetailCategory" runat="server" /> &nbsp;|&nbsp;
                        <asp:Label ID="lblDetailMaxLevel" runat="server" />
                        &nbsp;|&nbsp; Treasure: <asp:Label ID="lblDetailTreasure" runat="server" />
                    </div>
                    <div><asp:Literal ID="litLevelPips" runat="server" /></div>
                </div>
            </div>

            <%-- Large detail image --%>
            <asp:Panel ID="pnlDetailImage" runat="server" Visible="false">
                <asp:Image ID="imgDetailLarge" runat="server" CssClass="detail-main-img"
                    onerror="this.parentElement.style.display='none'" />
                <p class="img-caption"><asp:Label ID="lblDetailName2" runat="server" /> – in-game preview</p>
            </asp:Panel>

            <span class="section-label">Effect</span>
            <p style="color:#ddd; font-size:1.05rem; margin-bottom:20px;"><asp:Label ID="lblDetailDesc" runat="server" /></p>

            <div class="meta-row">
                <div class="meta-item">
                    <label>Applies To</label>
                    <span><asp:Label ID="lblDetailApplies" runat="server" /></span>
                </div>
                <div class="meta-item">
                    <label>Conflicts With</label>
                    <span><asp:Label ID="lblDetailConflicts" runat="server" /></span>
                </div>
            </div>

            <span class="section-label">Detailed Guide</span>
            <div class="content-box"><asp:Literal ID="litDetailContent" runat="server" /></div>

            <div style="margin-top:25px;">
                <asp:Button ID="btnEditEnchant" runat="server" CssClass="btn-edit" Text="✎ EDIT" OnClick="ShowEditForm" Visible="false" />
                <asp:LinkButton ID="btnDeleteEnchant" runat="server" CssClass="btn-delete" Text="✖ DELETE"
                    OnClick="DeleteEnchantment" OnClientClick="return confirm('Delete this enchantment?');" Visible="false" />
            </div>
        </div>
    </asp:Panel>

    <%-- PANEL 4: EDIT --%>
    <asp:Panel ID="editPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToList">« CANCEL & BACK</asp:LinkButton>
        <div class="form-panel">
            <h2>✎ Edit Enchantment</h2>
            <asp:Label ID="lblEditError" runat="server" CssClass="error-msg" />
            <div class="form-row-half">
                <div class="form-row"><label>Name</label><asp:TextBox ID="txtEditName" runat="server" CssClass="form-input" /></div>
                <div class="form-row">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-select">
                        <asp:ListItem>Sword</asp:ListItem><asp:ListItem>Armor</asp:ListItem><asp:ListItem>Tool</asp:ListItem>
                        <asp:ListItem>Bow</asp:ListItem><asp:ListItem>Crossbow</asp:ListItem><asp:ListItem>Trident</asp:ListItem>
                        <asp:ListItem>Fishing Rod</asp:ListItem><asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-row-half">
                <div class="form-row"><label>Max Level (1–5)</label><asp:TextBox ID="txtEditMaxLevel" runat="server" CssClass="form-input" /></div>
                <div class="form-row"><label>Thumbnail Path (small)</label><asp:TextBox ID="txtEditThumbnail" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Detail Image Path (large)</label><asp:TextBox ID="txtEditDetailImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Short Description</label><asp:TextBox ID="txtEditDesc" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Applies To (comma separated)</label><asp:TextBox ID="txtEditApplies" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Conflicts With (comma separated)</label><asp:TextBox ID="txtEditConflicts" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Detailed Content</label><asp:TextBox ID="txtEditContent" runat="server" CssClass="form-textarea" TextMode="MultiLine" /></div>
            <div class="form-row chk-row">
                <asp:CheckBox ID="chkEditTreasure" runat="server" />
                <label style="margin:0;">Treasure Only Enchantment</label>
            </div>
            <div style="margin-top:20px;">
                <asp:Button runat="server" CssClass="btn-save" Text="SAVE CHANGES" OnClick="SaveEdit" />
                <asp:Button runat="server" CssClass="btn-cancel" Text="CANCEL" OnClick="BackToList" />
            </div>
        </div>
    </asp:Panel>

    <%-- PANEL 5: ADD --%>
    <asp:Panel ID="addPanel" runat="server" Visible="false">
        <asp:LinkButton runat="server" CssClass="back-btn" OnClick="BackToList">« CANCEL & BACK</asp:LinkButton>
        <div class="form-panel">
            <h2>+ Add New Enchantment</h2>
            <asp:Label ID="lblAddError" runat="server" CssClass="error-msg" />
            <div class="form-row-half">
                <div class="form-row"><label>Name</label><asp:TextBox ID="txtAddName" runat="server" CssClass="form-input" /></div>
                <div class="form-row">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlAddCategory" runat="server" CssClass="form-select">
                        <asp:ListItem>Sword</asp:ListItem><asp:ListItem>Armor</asp:ListItem><asp:ListItem>Tool</asp:ListItem>
                        <asp:ListItem>Bow</asp:ListItem><asp:ListItem>Crossbow</asp:ListItem><asp:ListItem>Trident</asp:ListItem>
                        <asp:ListItem>Fishing Rod</asp:ListItem><asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-row-half">
                <div class="form-row"><label>Max Level (1–5)</label><asp:TextBox ID="txtAddMaxLevel" runat="server" CssClass="form-input" /></div>
                <div class="form-row"><label>Thumbnail Path (small)</label><asp:TextBox ID="txtAddThumbnail" runat="server" CssClass="form-input" /></div>
            </div>
            <div class="form-row"><label>Detail Image Path (large)</label><asp:TextBox ID="txtAddDetailImage" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Short Description</label><asp:TextBox ID="txtAddDesc" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Applies To (comma separated)</label><asp:TextBox ID="txtAddApplies" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Conflicts With (comma separated)</label><asp:TextBox ID="txtAddConflicts" runat="server" CssClass="form-input" /></div>
            <div class="form-row"><label>Detailed Content</label><asp:TextBox ID="txtAddContent" runat="server" CssClass="form-textarea" TextMode="MultiLine" /></div>
            <div class="form-row chk-row">
                <asp:CheckBox ID="chkAddTreasure" runat="server" />
                <label style="margin:0;">Treasure Only Enchantment</label>
            </div>
            <div style="margin-top:20px;">
                <asp:Button runat="server" CssClass="btn-save" Text="ADD ENCHANTMENT" OnClick="SaveAdd" />
                <asp:Button runat="server" CssClass="btn-cancel" Text="CANCEL" OnClick="BackToList" />
            </div>
        </div>
    </asp:Panel>

</div>
</asp:Content>
