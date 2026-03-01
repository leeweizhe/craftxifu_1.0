<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
         CodeBehind="BeginnerGuide.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.BeginnerGuide" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/BeginnerGuide.css" rel="stylesheet"/>
    <link href="/Lee Wei Zhe/css/InstructorForm.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <%-- defer means the JS loads AFTER the HTML is ready --%>
    <script src="/Lee Wei Zhe/js/BeginnerGuide.js" defer></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%-- ═══════════════════════════════════════════════════════════════════
         ADD PART OVERLAY FORM
         This is hidden by default and floats over the whole page.
         It appears when any "＋ Add Part Here" button is clicked.
         Placed OUTSIDE the repeater so it exists once on the page.
         pnlAddPartOverlay.Visible is set to false for non-instructors
         in Page_Load — so non-instructors don't even get this HTML.
    ═══════════════════════════════════════════════════════════════════ --%>
    <asp:Panel ID="pnlAddPartOverlay" runat="server" Visible="false">
        <div id="addPartFormOverlay" class="add-part-overlay" style="display:none">
            <div class="add-part-form-inner">
                <h3 class="add-part-form-title">＋ Add New Section</h3>

                <label class="edit-label">Section Title</label>
                <asp:TextBox ID="txtNewPartTitle" runat="server" CssClass="edit-input"
                    placeholder="e.g. Advanced Techniques" MaxLength="100"
                    ValidationGroup="AddPart" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewPartTitle"
                    ErrorMessage="Please enter a title." CssClass="form-error"
                    Display="Dynamic" ValidationGroup="AddPart" />

                <label class="edit-label" style="margin-top:14px">Insert Position</label>
                <%-- This dropdown is populated in Page_Load via LoadPartPositionDropdown() --%>
                <asp:DropDownList ID="ddlPartPosition" runat="server" CssClass="edit-input edit-select" />

                <div class="inline-form-actions" style="margin-top:16px">
                    <asp:LinkButton ID="btnSaveNewPart" runat="server"
                        CssClass="btn-instructor btn-save"
                        OnClick="btnSaveNewPart_Click"
                        ValidationGroup="AddPart"
                        CausesValidation="true">💾 Save Section</asp:LinkButton>
                    <%-- return false stops the form from submitting via the browser --%>
                    <button class="btn-instructor btn-cancel"
                        onclick="hideAddPartForm(); return false;">✖ Cancel</button>
                </div>
            </div>
        </div>
    </asp:Panel>

    <div class="page-layout">

        <%-- ═══════════════════════════════════════════════════════════════════
             SIDEBAR TABLE OF CONTENTS
        ═══════════════════════════════════════════════════════════════════ --%>
        <aside class="toc-sidebar">
            <h3>Contents</h3>
            <ul>
                <asp:Repeater ID="rptMenu" runat="server">
                    <ItemTemplate>
                        <li>
                            <a href='#part-<%# Eval("PartId") %>'>
                                ▶ <%# Eval("PartTitle") %>
                            </a>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>

            <%-- Shortcut "Add Section" in sidebar — only for instructors --%>
            <asp:Panel ID="pnlSidebarAddPart" runat="server" Visible="false">
                <div style="margin-top:15px; border-top:2px solid #555; padding-top:15px;">
                    <button class="btn-instructor btn-add" style="width:100%"
                        onclick="showAddPartForm(); return false;">＋ Add New Section</button>
                </div>
            </asp:Panel>
        </aside>

        <div class="all-guides-wrapper">

            <%-- ═══════════════════════════════════════════════════════════════
                 MAIN GUIDE REPEATER
                 OnItemDataBound → fires for EACH row as it's being built.
                                   We use this to load steps from DB.
                 OnItemCommand   → fires when any Button/LinkButton inside
                                   the repeater is clicked.
            ═══════════════════════════════════════════════════════════════ --%>
            <asp:Repeater ID="rptGuideParts" runat="server"
                OnItemDataBound="rptGuideParts_ItemDataBound"
                OnItemCommand="rptGuideParts_ItemCommand">

                <%-- ─────────────────────────────────────────────────────────
                     SEPARATOR TEMPLATE
                     Renders between every two parts — this is where we put
                     the "＋ Add Part Here" button.
                     We use a plain <div> (not runat=server) because there's
                     no ItemDataBound for separators.
                     JS shows/hides this based on window.isInstructor.
                ───────────────────────────────────────────────────────── --%>
                <SeparatorTemplate>
                    <div class="add-part-separator-wrapper">
                        <button class="add-part-separator-btn"
                            onclick="showAddPartForm(); return false;">
                            ＋ Add Part Here
                        </button>
                    </div>
                </SeparatorTemplate>

                <ItemTemplate>
                    <div class="guide-container" id='part-<%# Eval("PartId") %>'>

                        <%-- ─────────────────────────────────────────────────
                             PART TITLE — VIEW MODE
                             Shows title + instructor edit/delete buttons.
                             pnlPartControls.Visible is set in ItemDataBound.
                        ───────────────────────────────────────────────────── --%>
                        <asp:Panel ID="pnlPartTitleView" runat="server" CssClass="guide-title-row part-title-view">
                            <h1 class="guide-title"><%# Eval("PartTitle") %></h1>

                            <asp:Panel ID="pnlPartControls" runat="server" Visible="false" CssClass="instructor-controls">
                                <button class="btn-instructor btn-edit"
                                    onclick="togglePartEdit(this); return false;">✏️ Edit Title</button>

                                <asp:Button CommandName="DeletePart"
                                    CommandArgument='<%# Eval("PartId") %>'
                                    CssClass="btn-instructor btn-delete"
                                    CausesValidation="false"
                                    Text="🗑️ Delete Section"
                                    OnClientClick="return confirm('Delete this ENTIRE section and ALL its steps?');"
                                    runat="server" />
                            </asp:Panel>
                        </asp:Panel>

                        <%-- ─────────────────────────────────────────────────
                             PART TITLE — EDIT MODE
                             Hidden by default (style="display:none").
                             JS toggles between this and the view panel above.
                             Visible="false" is set in Page_Load for non-instructors
                             so this HTML block doesn't even render for them.
                        ───────────────────────────────────────────────────── --%>
                        <asp:Panel ID="pnlPartTitleEdit" runat="server" Visible="false"
                            CssClass="guide-title-row part-title-edit" style="display:none">

                            <asp:TextBox ID="txtEditPartTitle" runat="server"
                                CssClass="edit-input edit-title-input"
                                Text='<%# Eval("PartTitle") %>'
                                MaxLength="100" />

                            <div class="inline-form-actions">
                                <asp:Button CommandName="SavePart"
                                    CommandArgument='<%# Eval("PartId") %>'
                                    CssClass="btn-instructor btn-save"
                                    CausesValidation="false"
                                    Text="💾 Save"
                                    runat="server" />
                                <button class="btn-instructor btn-cancel"
                                    onclick="togglePartEdit(this); return false;">✖ Cancel</button>
                            </div>
                        </asp:Panel>

                        <%-- Carries the PartId through postback events --%>
                        <asp:HiddenField ID="hfPartId" runat="server" Value='<%# Eval("PartId") %>' />

                        <%-- ═════════════════════════════════════════════════
                             INNER REPEATER — STEPS
                             OnItemDataBound → toggle instructor panels per step
                             OnItemCommand   → Save / Delete per step
                        ═════════════════════════════════════════════════ --%>
                        <asp:Repeater ID="rptSteps" runat="server"
                            OnItemDataBound="rptSteps_ItemDataBound"
                            OnItemCommand="rptSteps_ItemCommand">
                            <ItemTemplate>
                                <div class="step-card">
                                    <div class="step-badge">Step <%# Container.ItemIndex + 1 %></div>

                                    <%-- ─────────────────────────────────────
                                         STEP — VIEW MODE
                                         The normal read-only card.
                                    ───────────────────────────────────────── --%>
                                    <asp:Panel ID="pnlStepView" runat="server" CssClass="step-view-panel">
                                        <div class="step-content">
                                            <h2><%# Eval("StepTitle") %></h2>
                                            <p><%# Eval("StepDescription") %></p>
                                        </div>

                                        <div class="step-image-box">
                                            <img src='<%# Eval("ImagePath") %>'
                                                alt='<%# Eval("StepTitle") %>'
                                                class="guide-img" />
                                        </div>

                                        <%-- Only visible to instructors (set in rptSteps_ItemDataBound) --%>
                                        <asp:Panel ID="pnlEditControls" runat="server" Visible="false"
                                            CssClass="step-instructor-controls">
                                            <button class="btn-instructor btn-edit"
                                                onclick="toggleStepEdit(this); return false;">✏️ Edit</button>

                                        <asp:Button CommandName="DeleteStep"
                                            CommandArgument='<%# Eval("StepId") %>'
                                            CssClass="btn-instructor btn-delete"
                                            CausesValidation="false"
                                            Text="🗑️ Delete"
                                            OnClientClick="return confirm('Delete this step?');"
                                            runat="server" />

                                        </asp:Panel>
                                    </asp:Panel>

                                    <%-- ─────────────────────────────────────
                                         STEP — EDIT MODE
                                         Hidden by default (style="display:none").
                                         JS swaps this in when Edit is clicked.
                                         Only rendered for instructors (Visible set
                                         in rptSteps_ItemDataBound).
                                    ───────────────────────────────────────── --%>
                                    <asp:Panel ID="pnlStepEdit" runat="server" Visible="false"
                                        CssClass="step-edit-panel" style="display:none">

                                        <div class="step-edit-fields">
                                            <label class="edit-label">Title</label>
                                            <asp:TextBox ID="txtEditTitle" runat="server"
                                                CssClass="edit-input"
                                                Text='<%# Eval("StepTitle") %>'
                                                MaxLength="100" />

                                            <label class="edit-label">Description</label>
                                            <asp:TextBox ID="txtEditDescription" runat="server"
                                                CssClass="edit-input edit-textarea"
                                                TextMode="MultiLine" Rows="4"
                                                Text='<%# Eval("StepDescription") %>' />

                                            <label class="edit-label">
                                                Image Path <span class="edit-hint">(optional)</span>
                                            </label>
                                            <asp:TextBox ID="txtEditImagePath" runat="server"
                                                CssClass="edit-input"
                                                Text='<%# Eval("ImagePath") %>'
                                                MaxLength="255"
                                                placeholder="~/images/guide/step.jpg" />
                                        </div>

                                        <div class="inline-form-actions">
                                            <asp:Button CommandName="SaveStep"
                                                CommandArgument='<%# Eval("StepId") %>'
                                                CssClass="btn-instructor btn-save"
                                                CausesValidation="false"
                                                Text="💾 Save"
                                                runat="server" />
                                            <button class="btn-instructor btn-cancel"
                                                onclick="toggleStepEdit(this); return false;">✖ Cancel</button>
                                        </div>
                                    </asp:Panel>

                                </div><%-- end .step-card --%>
                            </ItemTemplate>
                        </asp:Repeater>

                        <%-- ─────────────────────────────────────────────────
                             ADD STEP ROW
                             Shows a "＋ Add Step" button at the bottom of each part.
                             Clicking it reveals an inline form.
                             pnlAddStep.Visible is set in ItemDataBound.
                        ───────────────────────────────────────────────────── --%>
                        <asp:Panel ID="pnlAddStep" runat="server" Visible="false" CssClass="add-step-row">

                            <button class="btn-instructor btn-add add-step-toggle"
                                onclick="toggleAddStepForm(this); return false;">
                                ＋ Add Step
                            </button>

                            <%-- Hidden until + is clicked --%>
                            <div class="add-step-form" style="display:none">
                                <h3 class="add-step-form-title">New Step</h3>

                                <label class="edit-label">Title</label>
                                <asp:TextBox ID="txtNewStepTitle" runat="server"
                                    CssClass="edit-input" MaxLength="100"
                                    placeholder="e.g. Mine Stone" />

                                <label class="edit-label">Description</label>
                                <asp:TextBox ID="txtNewStepDesc" runat="server"
                                    CssClass="edit-input edit-textarea"
                                    TextMode="MultiLine" Rows="3"
                                    placeholder="Explain what the player needs to do..." />

                                <label class="edit-label">
                                    Image Path <span class="edit-hint">(optional)</span>
                                </label>
                                <asp:TextBox ID="txtNewStepImage" runat="server"
                                    CssClass="edit-input" MaxLength="255"
                                    placeholder="~/images/guide/step.jpg" />

                                <div class="inline-form-actions" style="margin-top:12px">
                                    <%-- CommandArgument = PartId so the server knows which part to add to --%>
                                    <asp:Button ID="btnSaveNewPart" runat="server"
                                        CssClass="btn-instructor btn-save"
                                        Text="💾 Save Section"
                                        OnClick="btnSaveNewPart_Click"
                                        ValidationGroup="AddPart"
                                        CausesValidation="true" />
                                    <button class="btn-instructor btn-cancel"
                                        onclick="toggleAddStepForm(this); return false;">✖ Cancel</button>
                                </div>
                            </div>
                        </asp:Panel>

                    </div><%-- end .guide-container --%>
                </ItemTemplate>

            </asp:Repeater>

            <%-- "Add Section" button after ALL parts (instructor only) --%>
            <asp:Panel ID="pnlEndAddPart" runat="server" Visible="false" CssClass="end-add-part-row">
                <button class="btn-instructor btn-add"
                    onclick="showAddPartForm(); return false;">＋ Add New Section</button>
            </asp:Panel>

            <%-- Static accordion section (unchanged) --%>
            <div class="crafting-section">
                <h2 class="section-title">Essential Crafting Recipes</h2>

                <details class="accordion-item">
                    <summary>How to craft a Crafting Table</summary>
                    <div class="accordion-content accordion-flex">
                        <div class="accordion-text">
                            <p>Place 4 Wooden Planks in your 2x2 inventory crafting grid.</p>
                        </div>
                        <div class="step-image-box multiple-images">
                            <img src="../../images/profiles/troll.jpg" alt="Crafting Table" class="guide-img" />
                            <img src="../../images/profiles/DPick.jpg" alt="Result" class="guide-img" />
                        </div>
                    </div>
                </details>

                <details class="accordion-item">
                    <summary>How to craft a Wooden Pickaxe</summary>
                    <div class="accordion-content accordion-flex">
                        <div class="accordion-text">
                            <p>Place 3 Wooden Planks across the top row and 2 Sticks down the middle column.</p>
                        </div>
                        <div class="step-image-box"><span>[Pickaxe Image]</span></div>
                    </div>
                </details>
            </div>

        </div><%-- end .all-guides-wrapper --%>
    </div><%-- end .page-layout --%>

</asp:Content>