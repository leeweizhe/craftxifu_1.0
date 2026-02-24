<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support Center | CraftXiFu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --mc-green: #3c8527;
            --mc-dark-green: #2a5d1b;
            --panel-bg: rgba(255, 255, 255, 0.95);
            --border-color: #313233;
        }

        body {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), 
                        url('https://www.minecraft.net/content/dam/minecraftnet/games/minecraft/key-art/MC_Essential_KeyArt_16x9.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            font-family: 'Inter', sans-serif;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #1a1a1a;
        }

        .main-card {
            background: var(--panel-bg);
            width: 100%;
            max-width: 500px;
            padding: 40px;
            border: 4px solid var(--border-color);
            box-shadow: 12px 12px 0px rgba(0,0,0,0.3);
            position: relative;
        }

        .header-section {
            text-align: left;
            border-left: 8px solid var(--mc-green);
            padding-left: 20px;
            margin-bottom: 30px;
        }

        .header-section h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: -1px;
        }

        .instruction-tag {
            background: #f0f0f0;
            border-left: 4px solid #555;
            padding: 12px;
            font-size: 13px;
            margin-bottom: 25px;
            color: #444;
            line-height: 1.4;
        }

        .field-label {
            display: block;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 8px;
            color: #666;
        }

        .input-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            background: #fafafa;
            font-family: inherit;
            font-size: 15px;
            box-sizing: border-box;
            transition: all 0.2s ease;
            margin-bottom: 20px;
        }

        .input-control:focus {
            outline: none;
            border-color: var(--mc-green);
            background: #fff;
        }

        .btn-modern {
            background: var(--mc-green);
            color: white;
            border: none;
            width: 100%;
            padding: 16px;
            font-weight: 700;
            font-size: 14px;
            text-transform: uppercase;
            cursor: pointer;
            letter-spacing: 1px;
            transition: transform 0.1s, background 0.2s;
        }

        .btn-modern:hover {
            background: var(--mc-dark-green);
        }

        .btn-modern:active {
            transform: translateY(2px);
        }

        .contact-footer {
            margin-top: 25px;
            text-align: center;
            font-size: 13px;
            color: #777;
        }

        .contact-footer a {
            color: var(--mc-green);
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-card">
            <div class="header-section">
                <h1>Contact Admin</h1>
                <span style="font-size: 14px; color: #888;">CraftXiFu Support Portal</span>
            </div>

            <div class="instruction-tag">
                <strong>INSTRUCTORS:</strong> To request a content creator account, please include your portfolio in your message[cite: 30].
            </div>

            <div class="form-body">
                <label class="field-label">Support Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="input-control">
                    <asp:ListItem Text="Wiki Correction" Value="Wiki" />
                    <asp:ListItem Text="Account Recovery" Value="Account" />
                    <asp:ListItem Text="Technical Issue" Value="Tech" />
                    <asp:ListItem Text="Report Misbehavior" Value="Report" />
                </asp:DropDownList>

                <label class="field-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="input-control" placeholder="steve@minecraft.net"></asp:TextBox>

                <label class="field-label">Description</label>
                <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="4" CssClass="input-control" placeholder="How can we help you?"></asp:TextBox>

                <asp:Button ID="btnSend" runat="server" Text="Dispatch Ticket" CssClass="btn-modern" 
                    OnClientClick="alert('Ticket successfully sent to Admin!'); return false;" />
            </div>

            <div class="contact-footer">
                Direct Inquiry: <a href="mailto:support@craftxifu.com">support@craftxifu.com</a>
            </div>
        </div>
    </form>
</body>
</html>