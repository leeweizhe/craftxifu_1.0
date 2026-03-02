using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class LiveStream : System.Web.UI.Page
    {
        private List<string> ChatMessages
        {
            get
            {
                if (Session["ChatMessages"] == null)
                    Session["ChatMessages"] = new List<string>();

                return (List<string>)Session["ChatMessages"];
            }
        }

        // Runs every time the page loads
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // Only on first load, not when button is clicked
            {
                SetupStream();
                LoadChat();
            }
        }

        private void SetupStream()
        {
            // Your local Nginx HLS stream URL — change this if needed
            hdnStreamUrl.Value = "http://localhost:8080/hls/stream.m3u8";

            lblStreamTitle.Text = "My Live Stream";

            // Simulated viewer count (use a database in a real project)
            Random rnd = new Random();
            lblViewerCount.Text = rnd.Next(10, 500) + " viewers";

            // Show LIVE badge
            lblStatus.Text = "LIVE";
            lblStatus.CssClass = "status-badge live";
        }

        private void LoadChat()
        {
            string html = "";

            foreach (string msg in ChatMessages)
                html += "<div class='chat-message'>" + msg + "</div>";

            if (html == "")
                html = "<p class='no-messages'>No messages yet. Say hello!</p>";

            litChatMessages.Text = html;
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string name = txtUsername.Text.Trim();
            string msg = txtMessage.Text.Trim();

            // Validate: both fields must be filled
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(msg))
            {
                lblFeedback.Text = "Please enter your name and a message.";
                lblFeedback.CssClass = "chat-feedback error";
                LoadChat();
                return;
            }

            // Format: Name [3:45 PM]: message
            string time = DateTime.Now.ToString("hh:mm tt");
            string formatted = "<span class='chat-user'>" + name + "</span> " +
                               "<span class='chat-time'>[" + time + "]</span>: " +
                               Server.HtmlEncode(msg); // HtmlEncode = security against XSS

            ChatMessages.Add(formatted);
            txtMessage.Text = "";

            lblFeedback.Text = "Message sent!";
            lblFeedback.CssClass = "chat-feedback success";

            LoadChat();
        }

    }
}