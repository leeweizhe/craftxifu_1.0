<%@ Page Title="Minigame & Shop" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Minigame.aspx.cs" Inherits="WebAssignment.Brayden.Minigame" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .mg-container { width: 90%; margin: 30px auto; color: #fff; }
        .page-title { font-size: 2.5rem; color: #68ff00; text-transform: uppercase; border-bottom: 4px solid #68ff00; padding-bottom: 10px; margin-bottom: 5px; }

        /* Tab Bar */
        .tab-bar { display: flex; gap: 0; margin-bottom: 30px; border-bottom: 3px solid #333; }
        .tab-btn { background: transparent; border: none; color: #888; font-family: inherit; font-size: 1.2rem; padding: 12px 30px; cursor: pointer; text-transform: uppercase; transition: 0.2s; border-bottom: 3px solid transparent; margin-bottom: -3px; }
        .tab-btn:hover, .tab-btn.active { color: #68ff00; border-bottom-color: #68ff00; }

        /* Points Bar */
        .points-bar { background: rgba(0,0,0,0.7); border: 2px solid #68ff00; padding: 10px 20px; display: inline-flex; align-items: center; gap: 12px; margin-bottom: 25px; }
        .points-val { color: #68ff00; font-size: 1.4rem; }
        .points-lbl { color: #888; font-size: 0.9rem; }

        /* Game */
        .game-area { display: flex; flex-direction: column; align-items: center; }
        .game-header { text-align: center; margin-bottom: 20px; }
        .game-header h2 { font-size: 2rem; color: #68ff00; margin-bottom: 5px; }
        .game-header p  { color: #aaa; font-size: 0.95rem; }
        .game-stats { display: flex; gap: 30px; justify-content: center; margin-bottom: 20px; }
        .stat-box { background: #111; border: 2px solid #333; padding: 10px 20px; text-align: center; min-width: 100px; }
        .stat-box label { color: #888; font-size: 0.75rem; text-transform: uppercase; display: block; }
        .stat-box span  { color: #fff; font-size: 1.4rem; }

        .memory-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 10px; max-width: 720px; width: 100%; margin-bottom: 25px; }
        .mc-card { aspect-ratio: 1; cursor: pointer; perspective: 600px; background: transparent; }
        .mc-card-inner { width: 100%; height: 100%; position: relative; transform-style: preserve-3d; transition: transform 0.4s; }
        .mc-card.flipped .mc-card-inner { transform: rotateY(180deg); }
        .mc-card.matched .mc-card-inner { transform: rotateY(180deg); }
        .mc-card.matched .mc-card-front { border-color: #68ff00; box-shadow: 0 0 12px #68ff00; }
        .mc-card-back, .mc-card-front { position: absolute; width: 100%; height: 100%; backface-visibility: hidden; display: flex; align-items: center; justify-content: center; border: 3px solid #555; font-size: 2rem; }
        .mc-card-back  { background: #1a1a1a; }
        .mc-card-back::before { content: '?'; color: #555; font-size: 2.5rem; }
        .mc-card-front { background: #0d0d0d; border-color: #444; transform: rotateY(180deg); flex-direction: column; padding: 5px; }
        .mc-card-front span { font-size: 0.6rem; color: #888; text-align: center; line-height: 1.2; margin-top: 3px; }

        .btn-start { background: #68ff00; color: #000; border: none; padding: 12px 35px; font-size: 1.2rem; cursor: pointer; font-family: inherit; text-transform: uppercase; }
        .btn-start:hover { background: #52cc00; }
        .diff-select { background: #1a1a1a; border: 2px solid #555; color: #fff; padding: 8px 15px; font-family: inherit; font-size: 1rem; margin-right: 15px; }
        .win-banner { background: rgba(0,100,0,0.8); border: 4px solid #68ff00; padding: 25px 40px; text-align: center; margin-bottom: 20px; display: none; }
        .win-banner h2 { color: #68ff00; font-size: 2rem; }
        .win-banner p  { color: #fff; margin-top: 8px; }

        /* Shop */
        .shop-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
        .shop-card { background: rgba(0,0,0,0.8); border: 3px solid #333; padding: 20px; text-align: center; transition: 0.2s; position: relative; }
        .shop-card:hover { border-color: #68ff00; transform: translateY(-4px); }
        .rarity-banner { position: absolute; top: 0; left: 0; right: 0; padding: 4px; font-size: 0.7rem; text-transform: uppercase; text-align: center; }
        .shop-item-icon { font-size: 3rem; margin: 30px 0 10px; display: block; }
        .shop-item-img { width: 80px; height: 80px; object-fit: contain; margin: 20px auto 8px; display:block; image-rendering: pixelated; }
        .shop-item-name { font-size: 1.1rem; margin-bottom: 6px; }
        .shop-item-desc { color: #888; font-size: 0.85rem; margin-bottom: 15px; min-height: 40px; }
        .price-tag { background: #111; border: 2px solid #68ff00; padding: 5px 18px; display: inline-block; color: #68ff00; margin-bottom: 12px; font-size: 1rem; }
        .btn-buy { background: #68ff00; color: #000; border: none; padding: 8px 22px; cursor: pointer; font-size: 0.9rem; font-family: inherit; width: 100%; text-transform: uppercase; }
        .btn-buy:hover { background: #52cc00; }
        .shop-msg { padding: 10px 15px; margin-bottom: 15px; font-size: 1rem; display: block; }

        /* Inventory */
        .inv-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 20px; }
        .inv-card { background: rgba(0,0,0,0.8); border: 3px solid #333; padding: 20px; text-align: center; }
        .inv-item-img { width: 90px; height: 90px; object-fit: contain; image-rendering: pixelated; display:block; margin: 10px auto; }
        .inv-card.equipped { border-color: #68ff00; box-shadow: 0 0 15px rgba(104,255,0,0.3); }
        .equipped-badge { background: #68ff00; color: #000; padding: 3px 12px; font-size: 0.75rem; display: inline-block; margin-bottom: 8px; }
        .btn-equip { background: transparent; border: 2px solid #9b59b6; color: #9b59b6; padding: 7px 20px; cursor: pointer; font-family: inherit; width: 100%; margin-top: 10px; text-transform: uppercase; font-size: 0.85rem; }
        .btn-equip:hover { background: #9b59b6; color: #fff; }
        .inv-msg { padding: 10px 15px; margin-bottom: 15px; font-size: 1rem; display: block; }
        .empty-inv { text-align: center; padding: 50px; color: #555; font-size: 1.2rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="mg-container">

    <h1 class="page-title">🎮 Minigame & Shop</h1>

    <%-- Points bar --%>
    <asp:Panel ID="pnlPointsTop" runat="server" Visible="false">
        <div class="points-bar">
            <span style="font-size:1.4rem;">💎</span>
            <span class="points-val"><asp:Label ID="lblPoints" runat="server" Text="0" /></span>
            <span class="points-lbl">Points Available</span>
        </div>
    </asp:Panel>

    <%-- Tab Bar --%>
    <div class="tab-bar">
        <asp:Button runat="server" CssClass="tab-btn active" ID="tabGame" Text="🎮 LOOT DROP GAME" OnClick="ShowGame"      OnClientClick="setActive(this);" />
        <asp:Button runat="server" CssClass="tab-btn"        ID="tabShop" Text="🛒 NAME TAG SHOP"  OnClick="ShowShop"      OnClientClick="setActive(this);" />
        <asp:Button runat="server" CssClass="tab-btn"        ID="tabInv"  Text="🎒 MY INVENTORY"   OnClick="ShowInventory" OnClientClick="setActive(this);" />
    </div>

    <%-- Hidden award button triggered by JS --%>
    <asp:Button ID="btnAwardPoints" runat="server" OnClick="AwardPoints" Style="display:none;" />

    <%-- ===== GAME SECTION ===== --%>
    <asp:Panel ID="gameSection" runat="server">
        <div class="game-area">
            <div class="game-header">
                <h2>⚔️ Loot Drop Memory Match</h2>
                <p>Match each Mob to its Rare Drop. Learn which monsters to farm for resources!</p>
            </div>

            <div class="game-stats">
                <div class="stat-box"><label>Moves</label><span id="statMoves">0</span></div>
                <div class="stat-box"><label>Pairs</label><span id="statPairs">0</span> / <span id="statTotal">6</span></div>
                <div class="stat-box"><label>⏱ Time</label><span id="statTime">0s</span></div>
            </div>

            <div style="margin-bottom:20px;">
                <select id="selDifficulty" class="diff-select" onchange="changeDifficulty(this.value)">
                    <option value="easy">Easy (4 pairs)</option>
                    <option value="normal" selected>Normal (6 pairs)</option>
                    <option value="hard">Hard (8 pairs)</option>
                </select>
                <button class="btn-start" onclick="startGame(); return false;">▶ START / RESTART</button>
            </div>

            <div id="winBanner" class="win-banner">
                <h2>🎉 YOU WIN!</h2>
                <p id="winMsg">You matched all pairs!</p>
                <asp:Panel ID="pnlWinPoints" runat="server" Visible="false">
                    <p style="color:#68ff00; font-size:1.1rem; margin-top:8px;">+10 Points Awarded!</p>
                </asp:Panel>
                <asp:Panel ID="pnlWinGuest" runat="server" Visible="false">
                    <p style="color:#f39c12; font-size:1rem; margin-top:8px;">Log in to earn points for your score!</p>
                </asp:Panel>
            </div>

            <div id="memoryGrid" class="memory-grid"></div>
            <div style="margin-top:10px; color:#555; font-size:0.85rem; text-align:center;">
                Click a card to reveal it. Match the mob with its rare loot drop!
            </div>
        </div>

        <div style="margin-top:40px; background:rgba(0,0,0,0.7); border:3px solid #333; padding:25px; max-width:720px; margin-left:auto; margin-right:auto;">
            <h3 style="color:#fbbf24; font-size:1.2rem; margin-bottom:15px;">📖 Mob Drop Cheat Sheet</h3>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:8px; font-size:0.85rem; color:#ccc;">
                <div>🦴 Wither Skeleton → Wither Skull</div>
                <div>🪙 Drowned → Trident / Copper</div>
                <div>🧟 Zombie → Iron Ingot</div>
                <div>💀 Skeleton → Bone / Arrow</div>
                <div>🕷️ Cave Spider → Spider Eye</div>
                <div>👾 Enderman → Ender Pearl</div>
                <div>🔥 Blaze → Blaze Rod</div>
                <div>🌿 Creeper → Gunpowder</div>
                <div>🦇 Phantom → Phantom Membrane</div>
                <div>🐠 Pufferfish → Puffer Fish Drop</div>
            </div>
        </div>
    </asp:Panel>

    <%-- ===== SHOP SECTION ===== --%>
    <asp:Panel ID="shopSection" runat="server" Visible="false">
        <h2 style="color:#68ff00; font-size:1.8rem; margin-bottom:5px;">🛒 Name Tag Shop</h2>
        <p style="color:#aaa; margin-bottom:15px;">Spend your hard-earned points on exclusive rank titles and avatar frames.</p>

        <asp:Panel ID="pnlShopPoints" runat="server" Visible="false">
            <div class="points-bar" style="margin-bottom:20px;">
                <span style="font-size:1.4rem;">💎</span>
                <span class="points-val"><asp:Label ID="lblPointsShop" runat="server" Text="0" /></span>
                <span class="points-lbl">Points Available</span>
            </div>
        </asp:Panel>

        <asp:Label ID="lblShopMsg" runat="server" CssClass="shop-msg" />

        <div class="shop-grid">
            <asp:Repeater ID="shopRepeater" runat="server">
                <ItemTemplate>
                    <div class="shop-card" style='border-color:<%# ((WebAssignment.Brayden.Minigame)Page).GetRarityColor(Eval("Rarity").ToString()) %>'>
                        <div class="rarity-banner" style='background:<%# ((WebAssignment.Brayden.Minigame)Page).GetRarityColor(Eval("Rarity").ToString()) %>; color:#000;'>
                            <%# Eval("Rarity") %>
                        </div>
                        <img src='<%# ResolveUrl(Eval("ImagePath").ToString()) %>' class="shop-item-img" onerror="this.style.display='none'" alt='<%# Eval("Name") %>' />
                        <div class="shop-item-name" style='color:<%# ((WebAssignment.Brayden.Minigame)Page).GetRarityColor(Eval("Rarity").ToString()) %>'>
                            <%# Eval("Name") %>
                        </div>
                        <div class="shop-item-desc"><%# Eval("Description") %></div>
                        <div class="price-tag">💎 <%# Eval("Price") %> pts</div><br />
                        <asp:LinkButton runat="server" CssClass="btn-buy"
                            CommandArgument='<%# Eval("ItemId") %>'
                            OnClick="BuyItem"
                            OnClientClick='<%# "return confirm(\"Purchase " + Eval("Name") + " for " + Eval("Price") + " points?\");" %>'>
                            BUY NOW
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlShopGuest" runat="server" Visible="false">
            <div style="text-align:center; padding:40px; color:#555; font-size:1.2rem;">
                Please log in to purchase items from the shop.
            </div>
        </asp:Panel>
    </asp:Panel>

    <%-- ===== INVENTORY SECTION ===== --%>
    <asp:Panel ID="invSection" runat="server" Visible="false">
        <h2 style="color:#68ff00; font-size:1.8rem; margin-bottom:5px;">🎒 My Inventory</h2>

        <asp:Panel ID="pnlInvPoints" runat="server" Visible="false">
            <div class="points-bar" style="margin-bottom:20px;">
                <span style="font-size:1.4rem;">💎</span>
                <span class="points-val"><asp:Label ID="lblPointsInv" runat="server" Text="0" /></span>
                <span class="points-lbl">Points Available</span>
            </div>
        </asp:Panel>

        <asp:Label ID="lblInvMsg" runat="server" CssClass="inv-msg" />
        <asp:Label ID="invEmptyMsg" runat="server" CssClass="empty-inv" Visible="false"
            Text="Your inventory is empty. Play the minigame and earn points to buy titles!" />

        <div class="inv-grid">
            <asp:Repeater ID="inventoryRepeater" runat="server">
                <ItemTemplate>
                    <div class='inv-card <%# Eval("IsEquipped").ToString()=="True" ? "equipped" : "" %>'
                         style='border-color:<%# ((WebAssignment.Brayden.Minigame)Page).GetRarityColor(Eval("Rarity").ToString()) %>'>
                        <%# Eval("IsEquipped").ToString()=="True" ? "<div class='equipped-badge'>✓ EQUIPPED</div>" : "" %>
                        <img src='<%# ResolveUrl(Eval("ImagePath")!=null && Eval("ImagePath").ToString().Length>0 ? Eval("ImagePath").ToString() : (Eval("FrameImagePath")!=null ? Eval("FrameImagePath").ToString() : "") ) %>'
                             class="inv-item-img" onerror="this.style.display='none'" alt='<%# Eval("Name") %>' />
                        <div style='color:<%# ((WebAssignment.Brayden.Minigame)Page).GetRarityColor(Eval("Rarity").ToString()) %>; font-size:1.1rem; margin-bottom:5px;'>
                            <%# Eval("Name") %>
                        </div>
                        <div style="color:#888; font-size:0.8rem; margin-bottom:8px;">
                            <span style='background:<%# ((WebAssignment.Brayden.Minigame)Page).GetRarityColor(Eval("Rarity").ToString()) %>; color:#000; padding:1px 8px;'><%# Eval("Rarity") %></span>
                        </div>
                        <div style="color:#666; font-size:0.8rem; margin-bottom:10px;">
                            Purchased: <%# Eval("PurchaseDate", "{0:MMM dd, yyyy}") %>
                        </div>
                        <asp:LinkButton runat="server" CssClass="btn-equip"
                            CommandArgument='<%# Eval("InventoryId") %>'
                            OnClick="EquipItem"
                            Text='<%# Eval("IsEquipped").ToString()=="True" ? "✓ EQUIPPED" : "EQUIP" %>'
                            Enabled='<%# !Eval("IsEquipped").ToString().Equals("True") %>' />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlInvGuest" runat="server" Visible="false">
            <div class="empty-inv">Please log in to view your inventory.</div>
        </asp:Panel>
    </asp:Panel>

</div>

<script type="text/javascript">
    // Tab visual toggle
    function setActive(btn) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }

    // Game Data – all mob/drop pairs
    const ALL_PAIRS = [
        { mob: '🦴', mobName: 'Wither Skeleton', item: '💀', itemName: 'Wither Skull' },
        { mob: '🧟', mobName: 'Zombie',          item: '🔩', itemName: 'Iron Ingot' },
        { mob: '💀', mobName: 'Skeleton',         item: '🏹', itemName: 'Arrow' },
        { mob: '👾', mobName: 'Enderman',         item: '🔮', itemName: 'Ender Pearl' },
        { mob: '🔥', mobName: 'Blaze',            item: '🪄', itemName: 'Blaze Rod' },
        { mob: '🌿', mobName: 'Creeper',          item: '💥', itemName: 'Gunpowder' },
        { mob: '🕷️', mobName: 'Cave Spider',      item: '👁️', itemName: 'Spider Eye' },
        { mob: '🪙', mobName: 'Drowned',          item: '🔱', itemName: 'Trident' },
        { mob: '🦇', mobName: 'Phantom',          item: '🪶', itemName: 'Phantom Membrane' },
        { mob: '🐠', mobName: 'Pufferfish',       item: '🫧', itemName: 'Puffer Fish Drop' },
    ];

    let difficulty = 'normal';
    let cards = [], flipped = [], matched = 0, totalPairs = 6;
    let moves = 0, locked = false, seconds = 0, timerInterval = null, gameWon = false;

    function changeDifficulty(val) { difficulty = val; }

    function startGame() {
        clearInterval(timerInterval);
        seconds = 0; moves = 0; matched = 0; locked = false; flipped = []; gameWon = false;

        let pairCount = difficulty === 'easy' ? 4 : difficulty === 'hard' ? 8 : 6;
        totalPairs = pairCount;

        document.getElementById('statTotal').textContent = pairCount;
        document.getElementById('statMoves').textContent = '0';
        document.getElementById('statPairs').textContent = '0';
        document.getElementById('statTime').textContent  = '0s';
        document.getElementById('winBanner').style.display = 'none';

        let pool = shuffle([...ALL_PAIRS]).slice(0, pairCount);
        cards = [];
        pool.forEach((pair, i) => {
            cards.push({ id: i*2,   pairId: i, emoji: pair.mob,  label: pair.mobName,  type: 'mob'  });
            cards.push({ id: i*2+1, pairId: i, emoji: pair.item, label: pair.itemName, type: 'item' });
        });
        cards = shuffle(cards);
        renderGrid();

        timerInterval = setInterval(() => {
            if (!gameWon) { seconds++; document.getElementById('statTime').textContent = seconds + 's'; }
        }, 1000);
    }

    function renderGrid() {
        const grid = document.getElementById('memoryGrid');
        const cols = difficulty === 'easy' ? 4 : difficulty === 'hard' ? 8 : 6;
        grid.style.gridTemplateColumns = 'repeat(' + cols + ', 1fr)';
        grid.innerHTML = '';
        cards.forEach(card => {
            const el = document.createElement('div');
            el.className = 'mc-card';
            el.dataset.id = card.id;
            el.innerHTML = '<div class="mc-card-inner"><div class="mc-card-back"></div>'
                + '<div class="mc-card-front">' + card.emoji
                + '<span>' + card.label + '</span></div></div>';
            el.addEventListener('click', () => flipCard(el, card));
            grid.appendChild(el);
        });
    }

    function flipCard(el, card) {
        if (locked) return;
        if (el.classList.contains('flipped') || el.classList.contains('matched')) return;
        el.classList.add('flipped');
        flipped.push({ el, card });
        if (flipped.length === 2) {
            locked = true;
            moves++;
            document.getElementById('statMoves').textContent = moves;
            checkMatch();
        }
    }

    function checkMatch() {
        const [a, b] = flipped;
        if (a.card.pairId === b.card.pairId && a.card.type !== b.card.type) {
            a.el.classList.add('matched');
            b.el.classList.add('matched');
            matched++;
            document.getElementById('statPairs').textContent = matched;
            flipped = []; locked = false;
            if (matched === totalPairs) onWin();
        } else {
            setTimeout(() => {
                a.el.classList.remove('flipped');
                b.el.classList.remove('flipped');
                flipped = []; locked = false;
            }, 900);
        }
    }

    function onWin() {
        clearInterval(timerInterval);
        gameWon = true;
        document.getElementById('winBanner').style.display = 'block';
        document.getElementById('winMsg').textContent =
            'Completed in ' + moves + ' moves and ' + seconds + ' seconds!';
        const awardBtn = document.getElementById('<%= btnAwardPoints.ClientID %>');
        if (awardBtn) setTimeout(() => awardBtn.click(), 500);
    }

    function shuffle(arr) {
        for (let i = arr.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
        return arr;
    }

    window.addEventListener('DOMContentLoaded', startGame);
</script>
</asp:Content>
