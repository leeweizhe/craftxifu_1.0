<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageComments.aspx.cs" Inherits="WebAssignment.Tong_Yu_Hong.aspx.ManageComments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .admin-wrapper { width: 100%; padding: 40px 0; display: flex; justify-content: center; }
        .main-content-box { width: 90%; max-width: 1200px; background-color: rgba(18, 18, 18, 0.95); border-radius: 8px; overflow: hidden; border: 1px solid #333; }
        
        .report-row { background: #1a1a1a; border-bottom: 1px solid #333; width: 100%; }
        .report-summary { display: flex; justify-content: space-between; align-items: center; padding: 30px 40px; cursor: pointer; background: #1e1e1e; }
        
        /* Fixed Column System for perfect vertical alignment */
        .report-meta { 
            display: flex; 
            align-items: center; 
            flex-grow: 1; /* Allows columns to take up space before the arrow */
            font-family: 'Minecraft', sans-serif; 
        }

        /* Column 1: Commenter Name (Centered in 250px box, not bold) */
        .col-author {
            width: 250px; 
            text-align: center;
            color: #00ff41;
            font-size: 1.25rem;
            font-weight: normal; 
            padding-right: 20px;
        }

        /* Column 2: Comment Date (Fixed distance) */
        .col-date {
            width: 200px;
            color: #555;
            font-size: 1rem;
        }

        /* Column 3: Section Name */
        .col-section {
            flex-grow: 1;
            color: #fbbf24;
            font-size: 1rem;
        }
        .section-text { color: #fff; }

        .toggle-arrow { color: #00ff41; font-size: 1.5rem; font-family: Arial, sans-serif; transition: transform 0.8s ease; }
        
        /* Smooth Animation Setup */
        .report-details { 
            max-height: 0; 
            overflow: hidden; 
            opacity: 0; 
            padding: 0 40px; 
            background: #0c0c0c; 
            border-top: 1px solid transparent;
            /* Balanced speeds for both directions */
            transition: max-height 0.8s cubic-bezier(0.4, 0, 0.2, 1), 
                        opacity 0.6s cubic-bezier(0.4, 0, 0.2, 1), 
                        padding 0.8s cubic-bezier(0.4, 0, 0.2, 1); 
        }

        .report-details.active { 
            max-height: 800px; 
            opacity: 1; 
            padding: 25px 40px; 
            border-top: 1px solid #333; 
        }
        
        .reporter-info { color: #888; font-size: 1.1rem; margin-top: 12px; font-family: 'Minecraft', sans-serif; text-transform: uppercase; }
        .reporter-highlight { color: #ff4444; }
        .report-date-highlight { color: #555; margin-left: 10px; font-size: 0.95rem; }

        .action-btn { border: none; padding: 12px 35px; cursor: pointer; font-weight: bold; font-size: 1rem; border-radius: 20px; font-family: 'Minecraft', sans-serif; transition: 0.2s; }
        .btn-ignore { background: #333; color: #fff; }
        .btn-delete { background: #ff4444; color: #000; }
        .action-btn:hover { filter: brightness(1.2); }
    </style>

    <script type="text/javascript">
        function toggleReport(element) {
            var details = element.nextElementSibling;
            var arrow = element.querySelector('.toggle-arrow');
            details.classList.toggle('active');

            if (details.classList.contains('active')) {
                arrow.innerHTML = "▲";
            } else {
                arrow.innerHTML = "▼";
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-wrapper">
        <div class="main-content-box">
            <div style="display: flex; justify-content: space-between; align-items: baseline; border-bottom: 3px solid #333; padding: 30px 40px;">
                <h1 style="color: #00ff41; font-size: 2.8rem; text-transform: uppercase; margin: 0; font-family: 'Minecraft', sans-serif;">Manage Comments</h1>
                <div style="color: #888; font-family: 'Minecraft', sans-serif;">TOTAL REPORTS: <asp:Literal ID="litReportCount" runat="server" /></div>
            </div>

            <asp:Repeater ID="rptReports" runat="server" OnItemCommand="rptReports_ItemCommand">
                <ItemTemplate>
                    <div class="report-row">
                        <div class="report-summary" onclick="toggleReport(this)">
                            <div class="report-meta">
                                <div class="col-author">
                                    <%# Eval("CommentAuthor") %>
                                </div>
                                
                                <div class="col-date">
                                    <%# Eval("CommentDate", "{0:yyyy-MM-dd HH:mm}") %>
                                </div>
                                
                                <div class="col-section">
                                    SECTION: <span class="section-text"><%# Eval("SectionName") %></span>
                                </div>
                            </div>
                            <div class="toggle-arrow">▼</div>
                        </div>

                        <div class="report-details">
                            <p style="color: #bbb; margin-bottom: 10px; font-size: 1.1rem; background: #000; padding: 20px; border: 1px solid #222; font-family: 'Minecraft', sans-serif;">
                                <%# Eval("CommentText") %>
                            </p>
                
                            <div class="reporter-info">
                                Reported By: <span class="reporter-highlight"><%# Eval("ReporterName") %></span> 
                                <span class="report-date-highlight"><%# Eval("ReportDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                            </div>

                            <div style="display: flex; justify-content: flex-end; gap: 15px; margin-top: 5px;">
                                <asp:Button ID="btnIgnore" runat="server" Text="IGNORE" CommandName="Ignore" 
                                    CommandArgument='<%# Eval("ReportId") %>' CssClass="action-btn btn-ignore" />
                                <asp:Button ID="btnDelete" runat="server" Text="DELETE" CommandName="Delete" 
                                    CommandArgument='<%# Eval("CommentId") %>' CssClass="action-btn btn-delete" />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
