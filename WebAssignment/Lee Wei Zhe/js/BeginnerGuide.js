// ══════════════════════════════════════════════════════════════════════
// BeginnerGuide.js
// Handles all UI toggling for the inline instructor editor.
//
// IMPORTANT: This file only shows/hides HTML elements.
// The actual saving/deleting is always done by ASP.NET (server-side).
// JS never touches the database directly.
// ══════════════════════════════════════════════════════════════════════

// ── On page ready: show separator "+" buttons for instructors ─────────────
// window.isInstructor is set by RegisterStartupScript in Page_Load
// if the logged-in user is an Instructor.
document.addEventListener('DOMContentLoaded', function () {
    if (window.isInstructor) {
        document.querySelectorAll('.add-part-separator-wrapper').forEach(function (el) {
            el.style.display = 'flex';
        });
    }
});

// ── Toggle STEP edit mode ─────────────────────────────────────────────────
// Called by both the "✏️ Edit" button and the "✖ Cancel" button inside a step.
// Uses .closest() to walk UP the DOM tree to find the parent .step-card,
// then swaps which panel is visible.
function toggleStepEdit(btn) {
    var card = btn.closest('.step-card');
    var viewPanel = card.querySelector('.step-view-panel');
    var editPanel = card.querySelector('.step-edit-panel');

    // Check current state
    var isEditing = editPanel.style.display !== 'none' && editPanel.style.display !== '';

    if (isEditing) {
        // Cancel — go back to view mode
        editPanel.style.display = 'none';
        viewPanel.style.display = '';       // '' = restore CSS default (flex)
    } else {
        // Open edit mode
        viewPanel.style.display = 'none';
        editPanel.style.display = 'flex';
        // Auto-focus the title field so instructor can type immediately
        var firstInput = editPanel.querySelector('input[type="text"], textarea');
        if (firstInput) firstInput.focus();
    }
}



// ── Toggle PART TITLE edit mode ───────────────────────────────────────────
// Called by "✏️ Edit Title" and "✖ Cancel" buttons in the part header.
// Walks up to .guide-container, swaps .part-title-view / .part-title-edit
function togglePartEdit(btn) {
    var container = btn.closest('.guide-container');
    var viewPanel = container.querySelector('.part-title-view');
    var editPanel = container.querySelector('.part-title-edit');

    var isEditing = editPanel.style.display !== 'none' && editPanel.style.display !== '';

    if (isEditing) {
        editPanel.style.display = 'none';
        viewPanel.style.display = '';
    } else {
        viewPanel.style.display = 'none';
        editPanel.style.display = 'flex';
        // Select the text so instructor can retype straight away
        var input = editPanel.querySelector('input[type="text"]');
        if (input) { input.focus(); input.select(); }
    }
}

// ── Toggle ADD STEP inline form ───────────────────────────────────────────
// Called by both the "＋ Add Step" button and the "✖ Cancel" inside the form.
// Walks up to .add-step-row, hides the + button and shows the form (or vice versa).
function toggleAddStepForm(el) {
    var row = el.closest('.add-step-row');
    var toggleBtn = row.querySelector('.add-step-toggle');
    var form = row.querySelector('.add-step-form');

    var isShowing = form.style.display !== 'none' && form.style.display !== '';

    if (isShowing) {
        // Close — show + button, hide form
        form.style.display = 'none';
        toggleBtn.style.display = '';
    } else {
        // Open — hide + button, show form
        toggleBtn.style.display = 'none';
        form.style.display = 'block';
        var firstInput = form.querySelector('input[type="text"], textarea');
        if (firstInput) firstInput.focus();
    }
}

// ── Show the ADD PART overlay ─────────────────────────────────────────────
// Called by the separator "＋" buttons and the sidebar button.
function showAddPartForm() {
    var overlay = document.getElementById('addPartFormOverlay');
    if (overlay) {
        overlay.style.display = 'flex';
        var input = overlay.querySelector('input[type="text"]');
        if (input) input.focus();
    }
}

// ── Hide the ADD PART overlay ─────────────────────────────────────────────
// Called by the Cancel button inside the overlay.
function hideAddPartForm() {
    var overlay = document.getElementById('addPartFormOverlay');
    if (overlay) overlay.style.display = 'none';
}

function previewStepImage(input, previewId) {
    var preview = document.getElementById(previewId);
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
        };

        reader.readAsDataURL(input.files[0]);
    } else {
        preview.src = "";
        preview.style.display = 'none';
    }
}
