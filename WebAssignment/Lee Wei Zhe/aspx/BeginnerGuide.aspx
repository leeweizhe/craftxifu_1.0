<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BeginnerGuide.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.BeginnerGuide" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Lee Wei Zhe/css/BeginnerGuide.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-layout">

        <aside class="toc-sidebar">
            <h3>Contents</h3>
            <ul>
                <asp:Repeater ID="rptMenu" runat="server">
                    <ItemTemplate>
                        <li>
                            <a href='#part-<%# Eval("PartId") %>'>▶ <%# Eval("PartTitle") %></a>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
        </aside>

        <div class="all-guides-wrapper">
        <asp:Repeater ID="rptGuideParts" runat="server" OnItemDataBound="rptGuideParts_ItemDataBound">
                <ItemTemplate>
                
                    <div class="guide-container">
                        <h1 class="guide-title"><%# Eval("PartTitle") %></h1>
                    
                        <asp:HiddenField ID="hfPartId" runat="server" Value='<%# Eval("PartId") %>' />

                        <asp:Repeater ID="rptSteps" runat="server">
                            <ItemTemplate>
                                <div class="step-card">
                                    <div class="step-badge">Step <%# Container.ItemIndex + 1 %></div>
                                
                                    <div class="step-content">
                                        <h2><%# Eval("StepTitle") %></h2>
                                        <p><%# Eval("StepDescription") %></p>
                                    </div>
                                
                                    <div class="step-image-box">
                                        <img src='<%# Eval("ImagePath") %>' alt='<%# Eval("StepTitle") %>' class="guide-img" />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>            
                    </div>

                </ItemTemplate>
            </asp:Repeater>

            <div class="crafting-section">
                <h2 class="section-title">Essential Crafting Recipes</h2>
        
                <details class="accordion-item">
                    <summary>How to craft a Crafting Table</summary>
                    <div class="accordion-content accordion-flex"> 
        
                        <div class="accordion-text">
                            <p>Place 4 Wooden Planks in your 2x2 inventory crafting grid. This gives you a 3x3 grid to build advanced tools!</p>
                        </div>
        
                        <div class="step-image-box multiple-images">
                            <img src="../../images/profiles/troll.jpg" alt="Raw Iron" class="guide-img" />
    
                            <img src="../../images/profiles/DPick.jpg" alt="Iron Ingot" class="guide-img" />
                        </div>
        
                    </div>
                </details>

                <details class="accordion-item">
                    <summary>How to craft a Wooden Pickaxe</summary>
                    <div class="accordion-content accordion-flex"> 

                        <div class="accordion-text">
                            <p>Place 3 Wooden Planks across the top row of your Crafting Table, and 2 Sticks down the middle column.</p>
                        </div>

                        <div class="step-image-box">
                            <span>[Pickaxe Image]</span>
                        </div>

                    </div>
                </details>

                <details class="accordion-item"> 
                    <summary>How to craft a Wooden Pickaxe</summary>
                    <div class="accordion-content">
                        <p>Place 3 Wooden Planks across the top row of your Crafting Table, and 2 Sticks down the middle column.</p>
                    </div>
                </details>
            </div>
        </div>
    </div>
</asp:Content>
