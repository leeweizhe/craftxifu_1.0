/* ═══════════════════════════════════════════════════════════════════
   AdminStatistics.js
   Statistics Dashboard — Chart.js 4  |  ASP.NET WebForms PageMethod
   ═══════════════════════════════════════════════════════════════════ */

// ── Design tokens (matches AdminStatistics.css + site theme) ─────────
var C = {
    green: '#00ff55',
    greenDim: 'rgba(0, 255, 85, 0.15)',
    greenMid: 'rgba(0, 255, 85, 0.55)',
    greenBright: 'rgba(0, 255, 85, 0.85)',
    blue: 'rgba(0, 180, 255, 0.75)',
    blueDim: 'rgba(0, 180, 255, 0.20)',
    grid: 'rgba(255, 255, 255, 0.04)',
    // FIX 1: Changed global text default to white
    text: '#ffffff',
    // Donut / multi-series palette
    palette: [
        'rgba(0,   255, 85,  0.80)', // 1. Mint Green
        'rgba(0,   182, 59,  0.80)', // 2. Emerald Green
        'rgba(0,   104, 33,  0.80)', // 3. Dark Moss Green
        'rgba(104, 255, 0,   0.80)', // 4. Lime Green
        'rgba(0,   220, 220, 0.80)', // 5. Cyan
        'rgba(0,   150, 255, 0.80)', // 6. Sky Blue
        'rgba(255, 200, 0,   0.80)', // 7. Gold/Amber
        'rgba(255, 68,  68,  0.80)', // 8. Red
        'rgba(200, 100, 255, 0.80)', // 9. Purple/Lavender
        'rgba(255, 140, 0,   0.80)', // 10. Deep Orange
        'rgba(170, 170, 170, 0.80)',  // 11. Common (Grey) - Added to the end
        'rgba(255, 105, 180, 0.80)'  // [11] Pink (Female)
    ]
};

// ── Chart.js global defaults ─────────────────────────────────────────
Chart.defaults.color = C.text;
Chart.defaults.font.family = "'Minecraft', sans-serif";
Chart.defaults.font.size = 11;
Chart.defaults.plugins.legend.labels.boxWidth = 12;
Chart.defaults.plugins.legend.labels.padding = 14;

// ── Module-level state ───────────────────────────────────────────────
var _activeCharts = [];

// ════════════════════════════════════════════════════════════════════
// PUBLIC — called by the two <select> onchange handlers
// ════════════════════════════════════════════════════════════════════
function loadStats() {
    _destroyAll();
    _showLoading(true);
    _showError(null);

    var category = document.getElementById('ddlCategory').value;
    var days = parseInt(document.getElementById('ddlDateRange').value, 10);

    var methodMap = {
        users: 'GetUserStats',
        minigames: 'GetMinigameStats',
        shop: 'GetShopStats',
        content: 'GetContentStats',
        moderation: 'GetModerationStats'
    };

    var renderMap = {
        users: _renderUsers,
        minigames: _renderMinigames,
        shop: _renderShop,
        content: _renderContent,
        moderation: _renderModeration
    };

    _callMethod(methodMap[category], { days: days }, function (data) {
        _showLoading(false);
        if (data && data.error) {
            _showError('Database error: ' + data.error);
            return;
        }
        renderMap[category](data);
    });
}

// ════════════════════════════════════════════════════════════════════
// AJAX helper — calls an ASP.NET [WebMethod] on the same page
// ════════════════════════════════════════════════════════════════════
function _callMethod(methodName, params, callback) {
    // Resolve the ASPX page URL relative to the current location
    var url = window.location.pathname + '/' + methodName;

    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=utf-8' },
        body: JSON.stringify(params)
    })
        .then(function (r) {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        })
        .then(function (json) {
            // ASP.NET wraps WebMethod results in { "d": ... }
            callback(json.d !== undefined ? json.d : json);
        })
        .catch(function (err) {
            _showLoading(false);
            _showError('Could not load data. (' + err.message + ')');
        });
}

// ════════════════════════════════════════════════════════════════════
// UI helpers
// ════════════════════════════════════════════════════════════════════
function _showLoading(show) {
    document.getElementById('loadingIndicator').style.display = show ? 'flex' : 'none';
}

function _showError(msg) {
    var el = document.getElementById('errorBanner');
    if (!msg) { el.style.display = 'none'; return; }
    document.getElementById('errorMessage').textContent = msg;
    el.style.display = 'block';
}

function _destroyAll() {
    _activeCharts.forEach(function (c) { c.destroy(); });
    _activeCharts = [];
    document.getElementById('chartsContainer').innerHTML = '';
}

// ════════════════════════════════════════════════════════════════════
// DOM builders
// ════════════════════════════════════════════════════════════════════

// Inserts 4 summary KPI boxes spanning the full grid width
function _addSummaryRow(stats) {
    var container = document.getElementById('chartsContainer');
    var row = document.createElement('div');
    row.className = 'stat-summary-row';
    row.innerHTML = stats.map(function (s) {
        return '<div class="stat-box">' +
            '<span class="stat-box-value">' + _esc(String(s.value)) + '</span>' +
            '<span class="stat-box-label">' + _esc(s.label) + '</span>' +
            '</div>';
    }).join('');
    container.appendChild(row);
}

// Inserts a chart card and returns the <canvas> id
function _addCard(id, title, subtitle, fullWidth) {
    var container = document.getElementById('chartsContainer');
    var card = document.createElement('div');
    card.className = 'chart-card' + (fullWidth ? ' full-width' : '');
    card.innerHTML =
        '<p class="chart-card-title">' + _esc(title) + '</p>' +
        '<p class="chart-card-subtitle">' + _esc(subtitle) + '</p>' +
        '<div class="chart-wrapper"><canvas id="' + id + '"></canvas></div>';
    container.appendChild(card);
    return id;
}

function _esc(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
}

// ════════════════════════════════════════════════════════════════════
// Chart factories
// ════════════════════════════════════════════════════════════════════

function _bar(id, labels, data, label) {
    var ctx = document.getElementById(id);
    if (!ctx) return;
    var c = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: label || '',
                data: data,
                backgroundColor: C.greenDim,
                borderColor: C.greenBright,
                borderWidth: 1.5,
                borderRadius: 3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: C.grid }, ticks: { maxRotation: 40 } },
                y: { grid: { color: C.grid }, beginAtZero: true }
            }
        }
    });
    _activeCharts.push(c);
}

function _donut(id, labels, data) {
    var ctx = document.getElementById(id);
    if (!ctx) return;

    // ── Mapping for Rarity & Gender ──────────────────────────────────
    var customColors = labels.map(function (label, i) {
        var l = label.toLowerCase().trim();

        // Rarity Logic
        if (l.includes("common") && !l.includes("uncommon")) return C.palette[10]; // Grey
        if (l.includes("uncommon")) return C.palette[0];  // Mint Green
        if (l.includes("rare")) return C.palette[4];  // Cyan
        if (l.includes("epic")) return C.palette[8];  // Purple
        if (l.includes("legendary")) return C.palette[6];  // Gold

        // Gender Logic
        if (l === "male") return C.palette[4];  // Cyan
        if (l === "female") return C.palette[11]; // Pink

        // 3. Roles
        if (l === "member") return C.palette[5]; // Sky Blue
        if (l === "instructor") return C.palette[1]; // Emerald
        if (l === "admin") return C.palette[7]; // Red

        // 4. Guides
        if (l.includes("farm")) return C.palette[6]; // Gold/Amber (Harvest)
        if (l.includes("mob")) return C.palette[7]; // Red (Combat)
        if (l.includes("stream")) return C.palette[5]; // Sky Blue (Live)
        if (l.includes("beginner")) return C.palette[0]; // Mint Green (Fresh)
        if (l.includes("potion")) return C.palette[5]; // Sky Blue 
        if (l.includes("enchantment")) return C.palette[8];

        // 5. Reports Status
        if (l === "pending") return C.palette[7]; // [7] Red
        if (l === "resolved") return C.palette[0]; // [0] Mint

        // 6. Comment Status
        if (l === "visible") return C.palette[0]; // [0] Mint
        if (l === "hidden") return C.palette[10]; // [10] Grey

        // Default: If no match, use palette in order
        return C.palette[i % C.palette.length];
    });

    var c = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: customColors, // Use the mapped colors
                borderColor: '#111',
                borderWidth: 2,
                hoverOffset: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        generateLabels: function (chart) {
                            var ds = chart.data.datasets[0];
                            var total = ds.data.reduce(function (a, b) { return a + b; }, 0);
                            return chart.data.labels.map(function (label, i) {
                                var val = ds.data[i];
                                var pct = total > 0 ? Math.round(val / total * 100) : 0;
                                return {
                                    text: label + '  ' + val + ' (' + pct + '%)',
                                    fontColor: '#ffffff',
                                    fillStyle: ds.backgroundColor[i],
                                    strokeStyle: ds.borderColor,
                                    lineWidth: ds.borderWidth,
                                    hidden: !chart.getDataVisibility(i),
                                    index: i
                                };
                            });
                        }
                    }
                }
            }
        }
    });
    _activeCharts.push(c);
}

function _groupedBar(id, labels, datasets) {
    var ctx = document.getElementById(id);
    if (!ctx) return;
    var c = new Chart(ctx, {
        type: 'bar',
        data: { labels: labels, datasets: datasets },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'top' } },
            scales: {
                x: { grid: { color: C.grid }, ticks: { maxRotation: 40 } },
                y: { grid: { color: C.grid }, beginAtZero: true }
            }
        }
    });
    _activeCharts.push(c);
}

function _line(id, labels, data, label) {
    var ctx = document.getElementById(id);
    if (!ctx) return;
    if (!labels || labels.length === 0) {
        ctx.closest('.chart-wrapper').innerHTML =
            '<div class="empty-chart">No data for this period</div>';
        return;
    }
    var c = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: label || '',
                data: data,
                borderColor: C.green,
                backgroundColor: C.greenDim,
                borderWidth: 2,
                pointBackgroundColor: C.green,
                pointRadius: 4,
                pointHoverRadius: 6,
                tension: 0.35,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: C.grid }, ticks: { maxRotation: 40 } },
                y: { grid: { color: C.grid }, beginAtZero: true }
            }
        }
    });
    _activeCharts.push(c);
}

// ════════════════════════════════════════════════════════════════════
// Category renderers
// ════════════════════════════════════════════════════════════════════

function _renderUsers(d) {
    var totalUsers = _sum(d.role.data);
    var memberIdx = d.role.labels.indexOf('Member');
    var memberCount = memberIdx >= 0 ? d.role.data[memberIdx] : 0;

    _addSummaryRow([
        { value: totalUsers, label: 'Total Users' },
        { value: d.country.data.length, label: 'Countries' },
        { value: memberCount, label: 'Members' },
        { value: d.currency.data[0] || 0, label: 'Highest Currency' }
    ]);

    _addCard('cRole', 'Users by Role', 'Account role distribution', false);
    _donut('cRole', d.role.labels, d.role.data);

    _addCard('cGender', 'Gender Distribution', 'Male / Female / Unknown split', false);
    _donut('cGender', d.gender.labels, d.gender.data);

    _addCard('cCurrency', 'Top 10 by Currency', 'Richest players on the platform', false);
    _bar('cCurrency', d.currency.labels, d.currency.data, 'Currency');

    _addCard('cCountry', 'Users by Country', 'Top 10 countries by user count', false);
    _bar('cCountry', d.country.labels, d.country.data, 'Users');
}

function _renderMinigames(d) {
    var totalPlays = _sum(d.plays.data);
    var topPlayer = d.leaderboard.labels[0] || '—';
    var highScore = d.scores.maxData.length ? Math.max.apply(null, d.scores.maxData) : 0;

    _addSummaryRow([
        { value: totalPlays, label: 'Total Plays' },
        { value: d.plays.labels.length, label: 'Games Available' },
        { value: topPlayer, label: 'Top Player' },
        { value: highScore, label: 'Highest Score' }
    ]);

    _addCard('cPlays', 'Plays per Game', 'Which game is played most', false);
    _bar('cPlays', d.plays.labels, d.plays.data, 'Plays');

    _addCard('cLB', 'Top 10 Players', 'Total points earned', false);
    _bar('cLB', d.leaderboard.labels, d.leaderboard.data, 'Total Points');

    _addCard('cScores', 'Avg vs Max Score per Game', 'Score difficulty comparison', true);
    _groupedBar('cScores', d.scores.labels, [
        {
            label: 'Average Score',
            data: d.scores.avgData,
            backgroundColor: C.greenMid,
            borderColor: C.green,
            borderWidth: 1.5,
            borderRadius: 3
        },
        {
            label: 'Max Score',
            data: d.scores.maxData,
            backgroundColor: C.blueDim,
            borderColor: C.blue,
            borderWidth: 1.5,
            borderRadius: 3
        }
    ]);
}

function _renderShop(d) {
    var totalPurchases = _sum(d.purchases.data);
    var totalRevenue = _sum(d.revenue.data);
    var equipped = (d.equipped.data && d.equipped.data[0]) || 0;

    _addSummaryRow([
        { value: totalPurchases, label: 'Total Purchases' },
        { value: totalRevenue.toLocaleString(), label: 'Total Revenue' },
        { value: d.rarity.labels.length, label: 'Rarity Tiers' },
        { value: equipped, label: 'Items Equipped' }
    ]);

    _addCard('cPurchases', 'Most Purchased Items', 'Top 10 items by purchase count', false);
    _bar('cPurchases', d.purchases.labels, d.purchases.data, 'Purchases');

    _addCard('cRevenue', 'Revenue per Item', 'Price × purchases (top 10)', false);
    _bar('cRevenue', d.revenue.labels, d.revenue.data, 'Revenue');

    _addCard('cRarity', 'Items by Rarity', 'Catalogue rarity breakdown', false);
    _donut('cRarity', d.rarity.labels, d.rarity.data);

    _addCard('cEquipped', 'Equipped vs Not Equipped', 'Ratio of actively worn items', false);
    _donut('cEquipped', d.equipped.labels, d.equipped.data);
}

function _renderContent(d) {
    var totalClicks = _sum(d.guides.data);
    var totalComments = _sum(d.commentTypes.data);
    var topGuide = d.guides.labels[0] || '—';

    _addSummaryRow([
        { value: totalClicks, label: 'Guide Clicks' },
        { value: topGuide, label: 'Top Guide' },
        { value: totalComments, label: 'Total Comments' },
        { value: d.streams.labels.length, label: 'Streams' }
    ]);

    _addCard('cGuides', 'Guide Click Count', 'Most visited guides', false);
    _bar('cGuides', d.guides.labels, d.guides.data, 'Clicks');

    _addCard('cCmtTypes', 'Comments by Content Type', 'Farm / Mob / Stream / Beginner / Enchantment/ Potion', false);
    _donut('cCmtTypes', d.commentTypes.labels, d.commentTypes.data);

    _addCard('cStreams', 'Stream Viewers vs Clicks', 'Top 10 streams engagement', true);
    _groupedBar('cStreams', d.streams.labels, [
        {
            label: 'Viewer Count',
            data: d.streams.viewerData,
            backgroundColor: C.greenMid,
            borderColor: C.green,
            borderWidth: 1.5,
            borderRadius: 3
        },
        {
            label: 'Click Count',
            data: d.streams.clickData,
            backgroundColor: C.blueDim,
            borderColor: C.blue,
            borderWidth: 1.5,
            borderRadius: 3
        }
    ]);
}

function _renderModeration(d) {
    var totalReports = _sum(d.reportStatus.data);
    var totalWarnings = _sum(d.warnings.data);

    // Mapping your two actual statuses
    // Index [0] = Visible, Index [1] = Hidden
    var visibleCount = (d.commentStatus.data && d.commentStatus.data[0]) || 0;
    var hiddenCount = (d.commentStatus.data && d.commentStatus.data[1]) || 0;

    // We keep 4 boxes for the UI layout, but labeled correctly now
    _addSummaryRow([
        { value: totalReports, label: 'Total Reports' },
        { value: totalWarnings, label: 'Warnings Issued' },
        { value: visibleCount, label: 'Visible Comments' },
        { value: hiddenCount, label: 'Hidden Comments' }
    ]);

    // 1. Report Status Card
    _addCard('cRptStatus', 'Reports by Status', 'Current Status Distribution', false);
    _donut('cRptStatus', d.reportStatus.labels, d.reportStatus.data);

    // 2. Report Types Card
    _addCard('cRptTypes', 'Reported Content Types', 'Categories being flagged', false);
    _bar('cRptTypes', d.reportTypes.labels, d.reportTypes.data, 'Reports');

    // 3. Comment Status Card (Removed the "/ Removed" text here)
    _addCard('cCmtStatus', 'Comment Status Breakdown', 'Visible / Hidden', false);
    _donut('cCmtStatus', d.commentStatus.labels, d.commentStatus.data);

    // 4. Warnings Trend
    _addCard('cWarnings', 'Warnings Issued Over Time', 'Daily warning trend', true);
    _line('cWarnings', d.warnings.labels, d.warnings.data, 'Warnings');
}

// ── Tiny utility ─────────────────────────────────────────────────────
function _sum(arr) {
    if (!arr || !arr.length) return 0;
    return arr.reduce(function (a, b) { return a + b; }, 0);
}

// ════════════════════════════════════════════════════════════════════
// Bootstrap — run as soon as DOM is ready
// ════════════════════════════════════════════════════════════════════
document.addEventListener('DOMContentLoaded', function () {
    loadStats();
});