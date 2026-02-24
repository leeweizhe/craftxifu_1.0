document.addEventListener('DOMContentLoaded', function () {

    function setupToggle(buttonId, inputId) {

        var toggleBtn = document.getElementById(buttonId);
        var passwordInput = document.getElementById(inputId);

        if (toggleBtn && passwordInput) {
            toggleBtn.addEventListener('click', function () {

                // A. Toggle the "active" class for the animation
                this.classList.toggle('active');

                // B. Check current type and swap it
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                passwordInput.focus();

            });
        }
    }

    setupToggle('btnTogglePassword', 'txtPassword');
    setupToggle('btnTogglePassword2', 'txtConfirmPassword');
})
