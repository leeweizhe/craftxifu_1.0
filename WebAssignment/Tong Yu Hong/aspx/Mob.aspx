<%@ Page Title="Mobs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Mob.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.Mob" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /* Position the Add Mob button at the top right of the guide-container */
        .add-mob-wrapper { position: absolute; top: 40px; right: 40px; }
        .btn-add-new { background-color: #68ff00; color: #000; padding: 12px 20px; font-family: 'Minecraft', sans-serif; font-weight: normal; text-decoration: none; border: 2px solid #000; transition: 0.3s; text-transform: uppercase; font-size: 0.9rem; }
        .btn-add-new:hover { background-color: #000; color: #68ff00; border-color: #68ff00; transform: scale(1.05); }

        /* The main black container from your friend's code */
        .guide-container { background-color: #1e1e1e; border-radius: 10px; padding: 40px; width: 95%; max-width: 1600px; margin: 40px auto; color: white; font-family: 'Minecraft', sans-serif; position: relative;}
        .page-title { text-align: center; color: #00b63b; font-size: 3rem; text-shadow: 2px 2px 0px #000; margin-bottom: 40px; width: 100%; display: block; }
        
        /* This Flexbox setup handles the "Columns" automatically - Reverted to multiple rows (wrap) */
        .mobs-wrapper { display: flex; flex-direction: row; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 20px 10px; }
        
        /* Individual Mob Box - Base border increased to 5px grey */
        .mob-card { flex: 0 0 220px; background-color: #d5d5d5; color: black; border: 5px solid #808080; border-radius: 8px; padding: 15px; text-align: center; transition: transform 0.3s ease, border 0.2s ease, box-shadow 0.3s; margin-bottom: 10px; cursor: pointer; }
        
        /* Hover effect: Increased altitude, thicker 7px green border, and glowing shadow */
        .mob-card:hover { transform: translateY(-15px); border: 5px solid #00b63b; box-shadow: 0px 10px 25px rgba(0, 182, 59, 0.5); }
        
        .mob-card h2 { margin: 0 0 10px 0; font-size: 1.4rem; font-weight: normal; letter-spacing: 1px; color: #1e1e1e; }
        
        /* Image styling for your 3D renders - Condensed code, centered and scaled for high-res PNGs */
        .mob-img { width: 100%; height: 180px; object-fit: contain; image-rendering: pixelated; display: block; margin: 0 auto 10px; }

        /* --- Add these under .mob-img --- */
        .filter-toolbar { display: flex; justify-content: center; gap: 15px; margin: 20px 0 40px 0; }
        
        .filter-btn { 
            background-color: #333; color: #00b63b; border: 2px solid #00b63b; 
            padding: 12px 24px; font-family: 'Minecraft', sans-serif; cursor: pointer; 
            transition: all 0.2s; text-transform: uppercase; border-radius: 4px;
        }

        .filter-btn:hover { background-color: #00b63b; color: white; box-shadow: 0px 0px 15px rgba(0, 182, 59, 0.4); }

        .behavior-header { 
            width: 100%; color: #00b63b; font-size: 2.2rem; border-bottom: 3px solid #333; 
            margin: 50px 0 20px 0; padding-bottom: 10px; text-transform: uppercase;
            text-shadow: 2px 2px 0px #000;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="guide-container">
        <div class="add-mob-wrapper">
            <asp:HyperLink ID="lnkAddMob" runat="server" NavigateUrl="AddMob.aspx" CssClass="btn-add-new" Visible="false">
                + Add New Mob
            </asp:HyperLink>
        </div>
        <h1 class="page-title">Minecraft Mobs</h1>

        <div class="filter-toolbar">
            <asp:Button ID="btnBehavior" runat="server" Text="By Behavior" OnClick="btnBehavior_Click" CssClass="filter-btn" />
            <asp:Button ID="btnAlpha" runat="server" Text="A-Z" OnClick="btnAlpha_Click" CssClass="filter-btn" />
        </div>

        <asp:MultiView ID="mvMobViews" runat="server" ActiveViewIndex="1">
            
            <asp:View ID="vwStandard" runat="server">
                <div class="mobs-wrapper">
                    <asp:Repeater ID="MobRepeater" runat="server">
                        <ItemTemplate>
                            <a href='<%# "MobDetail.aspx?MobID=" + Eval("MobID") %>' style="text-decoration: none; display: block; flex: 0 0 220px;">
                                <div class="mob-card" style="width: 100%; margin-bottom: 0;">
                                    <h2><%# Eval("MobName") %></h2>
                                    <img src='<%# ResolveUrl("~/Tong Yu Hong/mobImage/" + System.IO.Path.GetFileName(Eval("MobPicture").ToString())) %>' 
                                         alt='<%# Eval("MobName") %>' class="mob-img" />
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:View>

            <asp:View ID="vwBehavior" runat="server">
                <div class="behavior-header">Passive (<asp:Literal ID="litPassiveCount" runat="server" />)</div>
                <div class="mobs-wrapper">
                    <asp:Repeater ID="rptPassive" runat="server">
                        <ItemTemplate>
                             <a href='<%# "MobDetail.aspx?MobID=" + Eval("MobID") %>' style="text-decoration: none; display: block; flex: 0 0 220px;">
                                <div class="mob-card">
                                    <h2><%# Eval("MobName") %></h2>
                                    <img src='<%# ResolveUrl("~/Tong Yu Hong/mobImage/" + System.IO.Path.GetFileName(Eval("MobPicture").ToString())) %>' class="mob-img" />
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="behavior-header">Neutral (<asp:Literal ID="litNeutralCount" runat="server" />)</div>
                <div class="mobs-wrapper">
                    <asp:Repeater ID="rptNeutral" runat="server">
                        <ItemTemplate>
                             <a href='<%# "MobDetail.aspx?MobID=" + Eval("MobID") %>' style="text-decoration: none; display: block; flex: 0 0 220px;">
                                <div class="mob-card">
                                    <h2><%# Eval("MobName") %></h2>
                                    <img src='<%# ResolveUrl("~/Tong Yu Hong/mobImage/" + System.IO.Path.GetFileName(Eval("MobPicture").ToString())) %>' class="mob-img" />
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="behavior-header">Hostile (<asp:Literal ID="litHostileCount" runat="server" />)</div>
                <div class="mobs-wrapper">
                    <asp:Repeater ID="rptHostile" runat="server">
                        <ItemTemplate>
                             <a href='<%# "MobDetail.aspx?MobID=" + Eval("MobID") %>' style="text-decoration: none; display: block; flex: 0 0 220px;">
                                <div class="mob-card">
                                    <h2><%# Eval("MobName") %></h2>
                                    <img src='<%# ResolveUrl("~/Tong Yu Hong/mobImage/" + System.IO.Path.GetFileName(Eval("MobPicture").ToString())) %>' class="mob-img" />
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:View>
        </asp:MultiView>
    </div>
</asp:Content>


