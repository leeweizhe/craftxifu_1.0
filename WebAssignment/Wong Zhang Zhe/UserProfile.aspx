<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>My Profile | CraftXiFu</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3c8527;
            --bg-dark: #121212;
            --card-bg: rgba(255, 255, 255, 0.05);
            --border: rgba(255, 255, 255, 0.1);
            --text-main: #ffffff;
            --text-dim: #a0a0a0;
        }

        body {
            background-color: var(--bg-dark);
            background-image: radial-gradient(circle at 50% 50%, #1a3a10 0%, #121212 100%);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-main);
            margin: 0;
            padding: 40px;
        }

        .profile-wrapper {
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 30px;
        }

        /* Sidebar Profile Card */
        .profile-side {
            background: var(--card-bg);
            border: 1px solid var(--border);
            padding: 30px;
            text-align: center;
            backdrop-filter: blur(10px);
        }

        .avatar-container {
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
            border: 3px solid var(--primary);
            padding: 5px;
            border-radius: 50%;
        }

        .avatar-container img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-role {
            background: var(--primary);
            color: white;
            padding: 4px 12px;
            font-size: 12px;
            font-weight: 800;
            border-radius: 20px;
            text-transform: uppercase;
        }

        /* Main Content Area */
        .profile-main {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            padding: 25px;
            backdrop-filter: blur(10px);
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title::before {
            content: '';
            width: 4px;
            height: 18px;
            background: var(--primary);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .input-group label {
            display: block;
            font-size: 13px;
            color: var(--text-dim);
            margin-bottom: 8px;
        }

        .modern-input {
            width: 100%;
            background: rgba(0,0,0,0.3);
            border: 1px solid var(--border);
            padding: 12px;
            color: white;
            font-family: inherit;
            box-sizing: border-box;
            transition: 0.3s;
        }

        .modern-input:focus {
            outline: none;
            border-color: var(--primary);
            background: rgba(0,0,0,0.5);
        }

        .btn-update {
            background: var(--primary);
            color: white;
            border: none;
            padding: 12px 30px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 10px;
            transition: 0.3s;
        }

        .btn-update:hover {
            background: #4ea334;
            box-shadow: 0 0 20px rgba(60, 133, 39, 0.4);
        }

        /* Achievement Stats */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .stat-item {
            background: rgba(255,255,255,0.03);
            padding: 15px;
            text-align: center;
            border: 1px solid var(--border);
        }

        .stat-value {
            font-size: 24px;
            font-weight: 800;
            display: block;
        }

        .stat-label {
            font-size: 12px;
            color: var(--text-dim);
            text-transform: uppercase;
        }
    </style>
</head>
<body>
    <form id="profileForm" runat="server">
        <div class="profile-wrapper">
            <div class="profile-side">
                <div class="avatar-container">
                    <img src="https://api.dicebear.com/7.x/pixel-art/svg?seed=Zhangzhe" alt="User Avatar">
                </div>
                <h2 style="margin: 10px 0;">Zhangzhe Wong</h2>
                <span class="user-role">Member</span>
                <p style="color: var(--text-dim); font-size: 14px; margin-top: 20px;">
                    Joined: Feb 2026
                </p>
            </div>

            <div class="profile-main">
                
                <div class="section-card">
                    <div class="section-title">Account Settings</div>
                    <div class="form-grid">
                        <div class="input-group">
                            <label>Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="modern-input" Text="Zhangzhe_W"></asp:TextBox>
                        </div>
                        <div class="input-group">
                            <label>Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="modern-input" Text="tp080517@mail.apu.edu.my"></asp:TextBox>
                        </div>
                        <div class="input-group">
                            <label>New Password</label>
                            <asp:TextBox ID="txtPass" runat="server" CssClass="modern-input" TextMode="Password" placeholder="Leave blank to keep current"></asp:TextBox>
                        </div>
                        <div class="input-group">
                            <label>In-game Name (IGN)</label>
                            <asp:TextBox ID="txtIGN" runat="server" CssClass="modern-input" placeholder="e.g. Dream"></asp:TextBox>
                        </div>
                    </div>
                    <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" CssClass="btn-update" />
                </div>

                <div class="section-card">
                    <div class="section-title">Learning Progress</div>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-value">12</span>
                            <span class="stat-label">Guides Read</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-value">5</span>
                            <span class="stat-label">Auto Farms Mastered</span>
                        </div>
                        <div class="stat-item" style="border-color: var(--primary);">
                            <span class="stat-value" style="color: var(--primary);">Level 4</span>
                            <span class="stat-label">Survivalist</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </form>
</body>
</html>