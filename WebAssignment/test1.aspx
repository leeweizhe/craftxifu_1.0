<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test1.aspx.cs" Inherits="WebAssignment.Navigation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Navigation test</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.cdnfonts.com/css/minecraft-4" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=PT+Serif:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet" />
    <link href="Navigation.css" rel="stylesheet" type="text/css" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <nav>
            <ul>
                <li><a>Home</a></li>
                <li><a>Post</a></li>
                <li><a>Guide</a></li>
                <li><a>Donate Us</a></li>

                <li class="move-right"><a><img src="images/troll.jpg" class="profile-pic"/><span>Ok</span></a></li>
            </ul>
        </nav>
        <div class="main-content">
            <div class="login-container">
                <h1>Login Page</h1>
                <div class="input-section">
                    <input type="text" placeholder=" " required="required"/>
                    <label>Username</label>
                </div>
                <div class="input-section"> 
                    <input type="password" placeholder=" " required="required"/>
                    <label>Password</label>
                </div>
                <button>Submit</button>
            </div>
        </div>
        
        <footer>
            <p>&copy; 2026 Minecraft Community</p>
        </footer>
    </form>
</body>
</html>
