// ══════════════════════════════════════════════════════════════════
// CRAFTING RECIPE TOOLTIP — follows the mouse cursor
// ══════════════════════════════════════════════════════════════════

function showRecipeTooltip(event, card) {
    var tooltip = document.getElementById('recipeTooltip');
    var img = document.getElementById('tooltipImg');
    var name = document.getElementById('tooltipName');
    var desc = document.getElementById('tooltipDesc');

    img.src = card.dataset.img || '';
    img.alt = card.dataset.name || '';
    name.textContent = card.dataset.name || '';
    desc.textContent = card.dataset.desc || '';

    tooltip.style.display = 'block';
    positionTooltip(event, tooltip);
    setTimeout(function () { tooltip.classList.add('visible'); }, 10);
}

function moveRecipeTooltip(event) {
    var tooltip = document.getElementById('recipeTooltip');
    if (tooltip.style.display !== 'none') {
        positionTooltip(event, tooltip);
    }
}

function hideRecipeTooltip() {
    var tooltip = document.getElementById('recipeTooltip');
    tooltip.classList.remove('visible');
    setTimeout(function () {
        if (!tooltip.classList.contains('visible')) {
            tooltip.style.display = 'none';
        }
    }, 130);
}

function positionTooltip(event, tooltip) {
    var offset = 20;
    var x = event.clientX + offset;
    var y = event.clientY + offset;
    var w = tooltip.offsetWidth || 270;
    var h = tooltip.offsetHeight || 260;

    if (x + w > window.innerWidth - 10) { x = event.clientX - w - offset; }
    if (y + h > window.innerHeight - 10) { y = event.clientY - h - offset; }

    tooltip.style.left = x + 'px';
    tooltip.style.top = y + 'px';
}

// ══════════════════════════════════════════════════════════════════
// SEARCH / FILTER
// ══════════════════════════════════════════════════════════════════

function filterRecipes(query) {
    var q = query.trim().toLowerCase();
    var cards = document.querySelectorAll('.recipe-card');
    var noMsg = document.getElementById('noRecipesMsg');
    var anyVisible = false;

    cards.forEach(function (card) {
        var matches = (q === '' || (card.dataset.name || '').toLowerCase().indexOf(q) !== -1);
        card.classList.toggle('hidden-recipe', !matches);
        if (matches) anyVisible = true;
    });

    document.querySelectorAll('.crafting-category').forEach(function (cat) {
        cat.style.display =
            cat.querySelectorAll('.recipe-card:not(.hidden-recipe)').length > 0 ? '' : 'none';
    });

    if (noMsg) {
        noMsg.style.display = (!anyVisible && q !== '') ? 'block' : 'none';
    }
}