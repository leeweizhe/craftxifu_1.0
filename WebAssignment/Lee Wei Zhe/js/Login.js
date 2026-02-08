document.addEventListener('DOMContentLoaded', function () {

    var toggleBtn = document.getElementById('btnTogglePassword');
    var passwordInput = document.getElementById('txtPassword');

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
})