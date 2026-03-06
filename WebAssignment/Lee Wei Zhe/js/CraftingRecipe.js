// ══════════════════════════════════════════════════════════════════
// CRAFTING RECIPE — MOUSE-FOLLOWING TOOLTIP
// ══════════════════════════════════════════════════════════════════

function showRecipeTooltip(event, card) {
    var tooltip = document.getElementById('recipeTooltip');
    document.getElementById('tooltipImg').src = card.dataset.img || '';
    document.getElementById('tooltipImg').alt = card.dataset.name || '';
    document.getElementById('tooltipName').textContent = card.dataset.name || '';
    document.getElementById('tooltipDesc').textContent = card.dataset.desc || '';
    tooltip.style.display = 'block';
    _positionTooltip(event, tooltip);
    setTimeout(function () { tooltip.classList.add('visible'); }, 10);
}

function moveRecipeTooltip(event) {
    var tooltip = document.getElementById('recipeTooltip');
    if (tooltip && tooltip.style.display !== 'none') _positionTooltip(event, tooltip);
}

function hideRecipeTooltip() {
    var tooltip = document.getElementById('recipeTooltip');
    if (!tooltip) return;
    tooltip.classList.remove('visible');
    setTimeout(function () {
        if (!tooltip.classList.contains('visible')) tooltip.style.display = 'none';
    }, 130);
}

function _positionTooltip(event, tooltip) {
    var offset = 20, x = event.clientX + offset, y = event.clientY + offset;
    var w = tooltip.offsetWidth || 270, h = tooltip.offsetHeight || 260;
    if (x + w > window.innerWidth - 10) x = event.clientX - w - offset;
    if (y + h > window.innerHeight - 10) y = event.clientY - h - offset;
    tooltip.style.left = x + 'px';
    tooltip.style.top = y + 'px';
}

// ══════════════════════════════════════════════════════════════════
// SEARCH / FILTER
// ══════════════════════════════════════════════════════════════════

function filterRecipes(query) {
    var q = query.trim().toLowerCase();
    var anyVisible = false;

    document.querySelectorAll('.recipe-card').forEach(function (card) {
        var matches = q === '' || (card.dataset.name || '').toLowerCase().indexOf(q) !== -1;
        card.classList.toggle('hidden-recipe', !matches);
        if (matches) anyVisible = true;
    });

    // Hide categories that end up with zero visible cards
    document.querySelectorAll('.crafting-category').forEach(function (cat) {
        cat.style.display =
            cat.querySelectorAll('.recipe-card:not(.hidden-recipe)').length > 0 ? '' : 'none';
    });

    var noMsg = document.getElementById('noRecipesMsg');
    if (noMsg) noMsg.style.display = (!anyVisible && q !== '') ? 'block' : 'none';
}

// ══════════════════════════════════════════════════════════════════
// ADD / EDIT RECIPE OVERLAY
// ══════════════════════════════════════════════════════════════════

function showAddRecipeForm() {
    // Clear all fields
    _setVal('hfRecipeFormMode', 'add');
    _setVal('hfEditRecipeId', '0');
    _setVal('hfCurrentThumbPath', '');
    _setVal('hfCurrentRecipePath', '');

    var nameEl = document.getElementById('txtRecipeName');
    var descEl = document.getElementById('txtRecipeDescription');
    if (nameEl) nameEl.value = '';
    if (descEl) descEl.value = '';

    var ddl = document.getElementById('ddlRecipeCategory');
    if (ddl) ddl.selectedIndex = 0;

    _setPreview('imgThumbPreview', '');
    _setPreview('imgRecipePreview', '');

    var title = document.getElementById('recipeFormTitle');
    if (title) title.textContent = '➕ Add Recipe';

    _clearError();
    document.getElementById('recipeFormOverlay').style.display = 'flex';
}

function showEditRecipeForm(btn) {
    var d = btn.dataset;

    _setVal('hfRecipeFormMode', 'edit');
    _setVal('hfEditRecipeId', d.recipeid || '0');
    _setVal('hfCurrentThumbPath', d.thumbpath || '');
    _setVal('hfCurrentRecipePath', d.recipepath || '');

    var nameEl = document.getElementById('txtRecipeName');
    var descEl = document.getElementById('txtRecipeDescription');
    if (nameEl) nameEl.value = d.name || '';
    if (descEl) descEl.value = d.desc || '';

    // Select the correct category
    var ddl = document.getElementById('ddlRecipeCategory');
    if (ddl) {
        for (var i = 0; i < ddl.options.length; i++) {
            if (ddl.options[i].value === String(d.categoryid)) { ddl.selectedIndex = i; break; }
        }
    }

    // Show current images as previews
    _setPreview('imgThumbPreview', d.thumburl || '');
    _setPreview('imgRecipePreview', d.recipeurl || '');

    var title = document.getElementById('recipeFormTitle');
    if (title) title.textContent = '✏️ Edit Recipe';

    _clearError();
    document.getElementById('recipeFormOverlay').style.display = 'flex';
}

function hideRecipeForm() {
    var overlay = document.getElementById('recipeFormOverlay');
    if (overlay) overlay.style.display = 'none';
}

// Live preview when user picks a file
document.addEventListener('change', function (e) {
    if (e.target.id === 'fileUploadThumb') _previewFile(e.target, 'imgThumbPreview');
    if (e.target.id === 'fileUploadRecipeImg') _previewFile(e.target, 'imgRecipePreview');
});

// Click on the dark backdrop closes the modal
document.addEventListener('click', function (e) {
    var overlay = document.getElementById('recipeFormOverlay');
    if (overlay && e.target === overlay) hideRecipeForm();
});

// ── private helpers ────────────────────────────────────────────────

function _setVal(id, val) {
    var el = document.getElementById(id);
    if (el) el.value = val;
}

function _setPreview(id, src) {
    var el = document.getElementById(id);
    if (!el) return;
    if (src) { el.src = src; el.style.display = 'block'; }
    else { el.src = ''; el.style.display = 'none'; }
}

function _previewFile(input, imgId) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (ev) { _setPreview(imgId, ev.target.result); };
        reader.readAsDataURL(input.files[0]);
    }
}

function _clearError() {
    var lbl = document.querySelector('#recipeFormOverlay .form-error');
    if (lbl) lbl.style.display = 'none';
}