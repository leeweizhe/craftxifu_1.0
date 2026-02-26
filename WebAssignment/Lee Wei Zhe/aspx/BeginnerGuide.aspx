<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BeginnerGuide.aspx.cs" Inherits="WebAssignment.Lee_Wei_Zhe.aspx.BeginnerGuide" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../css/BeginnerGuide.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="all-guides-wrapper">
    <div class="guide-container">
        <h1 class="guide-title">Survive Your First Night</h1>

        <div class="step-card">
            <div class="step-badge">Step 1</div>
            <div class="step-content">
                <h2>Punch a Tree</h2>
                <p>Your first task is simple: find a tree and hold Left-Click to break the wood blocks. Gather at least 4 blocks of Oak Log to start your journey.</p>
            </div>
            <div class="step-image-box">
                <span>[Tree Image]</span>
            </div>
        </div>

        <div class="step-card">
            <div class="step-badge">Step 2</div>
            <div class="step-content">
                <h2>Make Wooden Planks</h2>
                <p>Open your inventory (press 'E'). Place your Oak Logs into the 2x2 crafting grid to turn them into Wooden Planks.</p>
                <br />
                <p>Place your Oak Logs into crafting grid to turn them into Wooden Planks.</p>
                <br />
                <p>Fill the 2x2 grid with four planks to make your first Crafting Table—your key to unlocking more recipes!</p>
            </div>
            <div class="step-image-box">
                <span>[Planks Image]</span>
            </div>
        </div>

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

    <div class="guide-container">
        <h1 class="guide-title">Get your first armor set</h1>
            <div class="step-card">
                <div class="step-badge">Step 1</div>
                <div class="step-content">
                    <h2>Craft a stone pickaxe</h2>
                    <p>You cant get iron using wooden pickaxe! Try to dig some stone and craft a stone pickaxe before mining.</p>
                </div>
                <div class="step-image-box">
                    <span>[Tree Image]</span>
                </div>
        </div>
    </div>
    </div>
</asp:Content>
