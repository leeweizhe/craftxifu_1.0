using System;
using System.Collections.Generic;
using System.Configuration;
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
        private string connStr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        private int streamId = 0;

        // Exposed to .aspx so JavaScript can read it
        public string YouTubeVideoID { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Read StreamID from URL: LiveStream.aspx?id=3
            if (!int.TryParse(Request.QueryString["id"], out streamId))
            {
                Response.Redirect("StreamList.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStream();
                LoadChat();
                CountViewer(increment: true); // Add 1 to viewer count when page loads
            }
        }

        // -------------------------------------------------------
        // Subtract viewer count when user leaves the page
        // -------------------------------------------------------
        protected void Page_Unload(object sender, EventArgs e)
        {
            // Only decrement on first load (not on every postback)
            if (!IsPostBack && streamId > 0)
                CountViewer(increment: false);
        }

        // -------------------------------------------------------
        // Load stream data and set up the page
        // -------------------------------------------------------
        private void LoadStream()
        {
            string sql = @"
                SELECT ls.StreamID, ls.StreamTitle, ls.ViewerCount,
                       ls.IsLive, ls.UserId, ls.YouTubeVideoID,
                       u.Username AS UserName
                FROM LiveStreams ls
                INNER JOIN userTable u ON ls.UserId = u.UserId
                WHERE ls.StreamID = @streamId";

            DataTable dt = GetData(sql, new SqlParameter("@streamId", streamId));

            if (dt.Rows.Count == 0) { Response.Redirect("InstructorList.aspx"); return; }

            DataRow row = dt.Rows[0];
            bool isLive = Convert.ToBoolean(row["IsLive"]);
            int ownerUserId = Convert.ToInt32(row["UserId"]);
            string ytID = row["YouTubeVideoID"] == DBNull.Value ? "" : row["YouTubeVideoID"].ToString().Trim();

            // Pass YouTube ID to JavaScript
            YouTubeVideoID = ytID;

            // LIVE / OFFLINE badge
            lblStatus.Text = isLive ? "LIVE" : "OFFLINE";
            lblStatus.CssClass = isLive ? "status-badge live" : "status-badge";

            // Stream title + viewer count below video
            lblStreamTitle.Text = row["UserName"] + " — " + row["StreamTitle"];
            lblViewerCount.Text = row["ViewerCount"] + " viewers";

            // Show YouTube video if ID exists, else show placeholder
            if (!string.IsNullOrEmpty(ytID))
            {
                pnlVideo.Visible = true;
                pnlNoVideo.Visible = false;
                pnlYouTubeChat.Visible = true;  // Show YouTube chat
                pnlOwnChat.Visible = false;      // Hide our fallback chat
            }
            else
            {
                pnlVideo.Visible = false;
                pnlNoVideo.Visible = true;       // Show placeholder
                pnlYouTubeChat.Visible = false;
                pnlOwnChat.Visible = true;       // Show fallback chat
            }

            // Check if logged-in user owns this stream
            bool isOwner = Session["userId"] != null &&
                           Convert.ToInt32(Session["userId"]) == ownerUserId;

            if (isOwner)
            {
                pnlInstructorControls.Visible = true;
                txtStreamTitle.Text = row["StreamTitle"].ToString();
                txtYouTubeID.Text = ytID;
                litViewerCount.Text = row["ViewerCount"].ToString();
                btnStartStream.Visible = !isLive;
                btnEndStream.Visible = isLive;
            }
        }

        // -------------------------------------------------------
        // Increment or decrement ViewerCount in database
        // -------------------------------------------------------
        private void CountViewer(bool increment)
        {
            string sql = increment
                ? "UPDATE LiveStreams SET ViewerCount = ViewerCount + 1 WHERE StreamID = @id"
                : "UPDATE LiveStreams SET ViewerCount = CASE WHEN ViewerCount > 0 THEN ViewerCount - 1 ELSE 0 END WHERE StreamID = @id";

            ExecuteSQL(sql, new SqlParameter("@id", streamId));
        }

        // -------------------------------------------------------
        // Save new stream title
        // -------------------------------------------------------
        protected void btnSaveTitle_Click(object sender, EventArgs e)
        {
            string newTitle = txtStreamTitle.Text.Trim();
            if (string.IsNullOrEmpty(newTitle))
            {
                ShowFeedback("Title cannot be empty.", false);
                return;
            }
            ExecuteSQL("UPDATE LiveStreams SET StreamTitle = @title WHERE StreamID = @id",
                new SqlParameter("@title", newTitle),
                new SqlParameter("@id", streamId));
            ShowFeedback("Title updated!", true);
        }

        // -------------------------------------------------------
        // Save YouTube Video ID
        // -------------------------------------------------------
        protected void btnSaveYouTubeID_Click(object sender, EventArgs e)
        {
            string ytID = txtYouTubeID.Text.Trim();
            ExecuteSQL("UPDATE LiveStreams SET YouTubeVideoID = @ytID WHERE StreamID = @id",
                new SqlParameter("@ytID", ytID),
                new SqlParameter("@id", streamId));
            ShowFeedback("YouTube ID saved! Reload to see the stream.", true);
        }

        // -------------------------------------------------------
        // Go Live: set IsLive = 1
        // -------------------------------------------------------
        protected void btnStartStream_Click(object sender, EventArgs e)
        {
            ExecuteSQL("UPDATE LiveStreams SET IsLive = 1 WHERE StreamID = @id",
                new SqlParameter("@id", streamId));
            ShowFeedback("You are now LIVE!", true);
        }

        // -------------------------------------------------------
        // End Stream: set IsLive = 0 and reset viewer count
        // -------------------------------------------------------
        protected void btnEndStream_Click(object sender, EventArgs e)
        {
            ExecuteSQL("UPDATE LiveStreams SET IsLive = 0, ViewerCount = 0 WHERE StreamID = @id",
                new SqlParameter("@id", streamId));
            ShowFeedback("Stream ended.", false);
        }

        // -------------------------------------------------------
        // Chat: send a message — persisted to LSCommentTable
        // -------------------------------------------------------
        protected void btnSend_Click(object sender, EventArgs e)
        {
            // Guard: user must be logged in
            if (Session["userId"] == null || Session["username"] == null)
            {
                lblFeedback.Text = "You must be logged in to chat.";
                lblFeedback.CssClass = "chat-feedback error";
                LoadStream(); LoadChat();
                return;
            }

            int userId = Convert.ToInt32(Session["userId"]);
            string msg = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(msg))
            {
                lblFeedback.Text = "Please enter a message.";
                lblFeedback.CssClass = "chat-feedback error";
                LoadStream(); LoadChat();
                return;
            }

            // Insert comment into LSCommentTable
            // FarmId column is used to store the StreamID so the schema is reused as-is
            string sql = @"INSERT INTO LSCommentTable (FarmId, UserId, CommentText, CommentDate)
                           VALUES (@streamId, @userId, @commentText, GETDATE())";

            ExecuteSQL(sql,
                new SqlParameter("@streamId", streamId),
                new SqlParameter("@userId", userId),
                new SqlParameter("@commentText", Server.HtmlEncode(msg)));

            txtMessage.Text = "";
            lblFeedback.Text = "Message sent!";
            lblFeedback.CssClass = "chat-feedback success";
            LoadStream(); LoadChat();
        }

        // -------------------------------------------------------
        // Chat: load messages from LSCommentTable into Literal
        // -------------------------------------------------------
        private void LoadChat()
        {
            // Fetch the latest 50 messages for this stream, oldest first so they read top-to-bottom
            string sql = @"
                SELECT TOP 50
                       c.CommentText,
                       c.CommentDate,
                       u.Username
                FROM LSCommentTable c
                INNER JOIN userTable u ON c.UserId = u.UserId
                WHERE c.FarmId = @streamId
                ORDER BY c.CommentDate ASC";

            DataTable dt = GetData(sql, new SqlParameter("@streamId", streamId));

            string html = "";
            foreach (DataRow row in dt.Rows)
            {
                string name = row["Username"].ToString();
                string text = row["CommentText"].ToString();  // already HTML-encoded on insert
                string time = Convert.ToDateTime(row["CommentDate"]).ToString("hh:mm tt");

                html += "<div class='chat-message'>"
                      + "<span class='chat-user'>" + HttpUtility.HtmlEncode(name) + "</span> "
                      + "<span class='chat-time'>[" + time + "]</span>: "
                      + text
                      + "</div>";
            }

            if (string.IsNullOrEmpty(html))
                html = "<p class='no-messages'>No messages yet. Say hello!</p>";

            litChatMessages.Text = html;
        }

        // -------------------------------------------------------
        // Helper: show feedback in instructor panel
        // -------------------------------------------------------
        private void ShowFeedback(string msg, bool success)
        {
            lblPanelFeedback.Text = msg;
            lblPanelFeedback.CssClass = success ? "chat-feedback success" : "chat-feedback error";
            LoadStream(); LoadChat();
        }

        // Helper: run SELECT → DataTable
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

        // Helper: run INSERT / UPDATE / DELETE
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