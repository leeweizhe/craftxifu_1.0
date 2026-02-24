document.addEventListener('DOMContentLoaded', function () {

    // 1. Find the dropdown parent
    var dropdownBtn = document.querySelector('.dropdown-parent > .main-link');

    // Safety check: If there is no dropdown on this page, stop here so we don't get errors
    if (!dropdownBtn) return;

    // 2. Add a click event listener
    dropdownBtn.addEventListener('click', function (e) {
        // Prevent jumping to top of page
        e.preventDefault();

        // CRITICAL: Stop the click from bubbling up to the document
        e.stopPropagation();

        // Toggle the class
        var parentLi = this.parentElement;
        parentLi.classList.toggle('open');
    });

    // 3. Close dropdown if user clicks anywhere else
    document.addEventListener('click', function (e) {
        // We have to define parentLi here too!
        var parentLi = dropdownBtn.parentElement;

        // If the click happened outside the entire dropdown area, remove 'open'
        if (!parentLi.contains(e.target)) {
            parentLi.classList.remove('open');
        }
    });

});