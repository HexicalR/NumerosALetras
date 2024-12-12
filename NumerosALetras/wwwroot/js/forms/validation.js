document.getElementById("registrationForm").addEventListener("submit", function (e) {  
    const password = document.getElementById("Password").value;
    const confirmPassword = document.getElementById("ConfirmPassword").value;

    if (password !== confirmPassword) {
        e.preventDefault();
        alert("Las contraseñas no coinciden. Por favor, verifica y vuelvelo a intentar.");
    }
});
