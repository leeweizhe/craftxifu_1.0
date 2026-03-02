using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAssignment.Lee_Wei_Zhe.aspx
{
    public partial class LiveStream : System.Web.UI.Page
    {
        private string connStr = System.Web.Configuration.WebConfigurationManager
                            .ConnectionStrings["DefaultConnection"].ConnectionString;

        // Stores the StreamID from the URL (?id=X)
        private int streamId = 0;

        // Tracks if the logged-in user owns this stream
        private bool isOwner = false;

        // Chat stored in Session (key includes StreamID so chats don't mix)
        private List<string> ChatMessages
        {
            get
            {
                string key = "Chat_" + streamId;
                if (Session[key] == null) Session[key] = new List<string>();
                return (List<string>)Session[key];
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Read StreamID from URL e.g. LiveStream.aspx?id=3
            if (!int.TryParse(Request.QueryString["id"], out streamId))
            {
                Response.Redirect("InstructorList.aspx"); // No ID? go back to list
                return;
            }

            if (!IsPostBack)
            {
                LoadStream();
                LoadChat();
            }
        }

        // -------------------------------------------------------
        // Load stream data from database and set up the page
        // -------------------------------------------------------
        private void LoadStream()
        {
            string sql = @"
                SELECT ls.StreamID, ls.StreamTitle, ls.ViewerCount, ls.IsLive, ls.userId,
                       u.userName AS UserName    -- ⚠️ change userName to your actual column
                FROM LiveStreams ls
                INNER JOIN userTable u ON ls.userId = u.userId
                WHERE ls.StreamID = @streamId";

            DataTable dt = GetData(sql, new SqlParameter("@streamId", streamId));

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("InstructorList.aspx"); // Stream not found
                return;
            }

            DataRow row = dt.Rows[0];
            bool isLive = Convert.ToBoolean(row["IsLive"]);
            int ownerUserId = Convert.ToInt32(row["userId"]);

            // Check if the logged-in user owns this stream
            isOwner = Session["userId"] != null &&
                      Convert.ToInt32(Session["userId"]) == ownerUserId;

            // Set video player stream URL
            hdnStreamUrl.Value = "http://localhost:8080/hls/stream.m3u8";

            // Set stream title + viewer count below video
            lblStreamTitle.Text = row["UserName"] + " — " + row["StreamTitle"];
            lblViewerCount.Text = row["ViewerCount"] + " viewers";

            // Set LIVE badge
            lblStatus.Text = isLive ? "LIVE" : "OFFLINE";
            lblStatus.CssClass = isLive ? "status-badge live" : "status-badge";

            // ---- Show instructor panel only if this is their stream ----
            if (isOwner)
            {
                pnlInstructorControls.Visible = true;

                // Pre-fill the title textbox with current title
                txtStreamTitle.Text = row["StreamTitle"].ToString();

                // Show viewer count in the stat box
                litViewerCount.Text = row["ViewerCount"].ToString();

                // Show only the relevant button (Go Live OR End Stream, not both)
                btnStartStream.Visible = !isLive; // Show "Go Live" if currently offline
                btnEndStream.Visible = isLive;  // Show "End Stream" if currently live
            }
        }

        // -------------------------------------------------------
        // Save new stream title to database
        // -------------------------------------------------------
        protected void btnSaveTitle_Click(object sender, EventArgs e)
        {
            string newTitle = txtStreamTitle.Text.Trim();

            if (string.IsNullOrEmpty(newTitle))
            {
                lblPanelFeedback.Text = "Title cannot be empty.";
                lblPanelFeedback.CssClass = "chat-feedback error";
                LoadStream(); LoadChat();
                return;
            }

            string sql = "UPDATE LiveStreams SET StreamTitle = @title WHERE StreamID = @id";
            ExecuteSQL(sql,
                new SqlParameter("@title", newTitle),
                new SqlParameter("@id", streamId));

            lblPanelFeedback.Text = "Title updated!";
            lblPanelFeedback.CssClass = "chat-feedback success";
            LoadStream(); LoadChat();
        }

        // -------------------------------------------------------
        // Set IsLive = 1 (Go Live)
        // -------------------------------------------------------
        protected void btnStartStream_Click(object sender, EventArgs e)
        {
            string sql = "UPDATE LiveStreams SET IsLive = 1 WHERE StreamID = @id";
            ExecuteSQL(sql, new SqlParameter("@id", streamId));

            lblPanelFeedback.Text = "You are now LIVE!";
            lblPanelFeedback.CssClass = "chat-feedback success";
            LoadStream(); LoadChat();
        }

        // -------------------------------------------------------
        // Set IsLive = 0 (End Stream)
        // -------------------------------------------------------
        protected void btnEndStream_Click(object sender, EventArgs e)
        {
            string sql = "UPDATE LiveStreams SET IsLive = 0 WHERE StreamID = @id";
            ExecuteSQL(sql, new SqlParameter("@id", streamId));

            lblPanelFeedback.Text = "Stream ended.";
            lblPanelFeedback.CssClass = "chat-feedback error";
            LoadStream(); LoadChat();
        }

        // -------------------------------------------------------
        // Chat: load messages
        // -------------------------------------------------------
        private void LoadChat()
        {
            string html = "";
            foreach (string msg in ChatMessages)
                html += "<div class='chat-message'>" + msg + "</div>";

            if (html == "")
                html = "<p class='no-messages'>No messages yet. Say hello!</p>";

            litChatMessages.Text = html;
        }

        // -------------------------------------------------------
        // Chat: send a message
        // -------------------------------------------------------
        protected void btnSend_Click(object sender, EventArgs e)
        {
            string name = txtUsername.Text.Trim();
            string msg = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(msg))
            {
                lblFeedback.Text = "Please enter your name and a message.";
                lblFeedback.CssClass = "chat-feedback error";
                LoadStream(); LoadChat();
                return;
            }

            string time = DateTime.Now.ToString("hh:mm tt");
            string formatted = "<span class='chat-user'>" + name + "</span> " +
                               "<span class='chat-time'>[" + time + "]</span>: " +
                               Server.HtmlEncode(msg);

            ChatMessages.Add(formatted);
            txtMessage.Text = "";

            lblFeedback.Text = "Message sent!";
            lblFeedback.CssClass = "chat-feedback success";
            LoadStream(); LoadChat();
        }

        // -------------------------------------------------------
        // Helper: run a SELECT and return DataTable
        // -------------------------------------------------------
        private DataTable GetData(string sql, params SqlParameter[] parameters)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null) cmd.Parameters.AddRange(parameters);
                conn.Open();
                new SqlDataAdapter(cmd).Fill(dt);
            }
            return dt;
        }

        // -------------------------------------------------------
        // Helper: run an INSERT/UPDATE/DELETE
        // -------------------------------------------------------
        private void ExecuteSQL(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (parameters != null) cmd.Parameters.AddRange(parameters);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }


}