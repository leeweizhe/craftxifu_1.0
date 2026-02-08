// Wait for the HTML to fully load before running
document.addEventListener('DOMContentLoaded', function () {

    // 1. Find the dropdown parent (The "Guide" link)
    // Note: We use querySelector to find the class we added earlier
    var dropdownBtn = document.querySelector('.dropdown-parent > .main-link');

    // 2. Add a click event listener
    dropdownBtn.addEventListener('click', function (e) {

        // Prevent the link from jumping to top of page
        e.preventDefault();

        // 3. Find the parent <li>
        var parentLi = this.parentElement;

        // 4. Toggle the class "open" on the parent
        // If it has "open", remove it. If not, add it.
        parentLi.classList.toggle('open');
    });

    // OPTIONAL: Close dropdown if user clicks anywhere else on the screen
    document.addEventListener('click', function (e) {
        if (!dropdownBtn.contains(e.target)) {
            dropdownBtn.parentElement.classList.remove('open');
        }
    });

});