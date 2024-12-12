document.addEventListener('DOMContentLoaded', function () {

    var logoutForm = document.getElementById('logoutForm');
    if (logoutForm) {
        logoutForm.addEventListener('submit', function (e) {
            e.preventDefault();
            if (confirm('¿Estás seguro que deseas cerrar sesión?')) {
                this.submit();
            }
        });
    }
    // Definir la función toggleTheme antes de usarla
    function toggleTheme() {
        const currentTheme = document.body.getAttribute('data-theme');
        const themeToggleButton = document.getElementById('themeToggle');

        if (currentTheme === 'dark') {
            // Cambiar tema
            document.body.setAttribute('data-theme', 'light');
            if (themeToggleButton) themeToggleButton.innerText = 'Tema Oscuro';
            localStorage.setItem('theme', 'light');
        } else {        
            document.body.setAttribute('data-theme', 'dark');
            if (themeToggleButton) themeToggleButton.innerText = 'Tema Claro';
            localStorage.setItem('theme', 'dark');
        }
    }

    const themeToggleButton = document.getElementById('themeToggle');
    if (themeToggleButton) {
        themeToggleButton.addEventListener('click', toggleTheme);

        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            document.body.setAttribute('data-theme', savedTheme);
            themeToggleButton.innerText = savedTheme === 'dark' ? 'Tema Claro' : 'Tema Oscuro';
        }
    }


    const openSidebarBtn = document.getElementById('openSidebarBtn');
    if (openSidebarBtn) {
        openSidebarBtn.addEventListener('click', function () {
            document.body.classList.toggle('sidebar-open');
        });
    }

    // 3. Convertir números a palabras
    const numberInput = document.getElementById('numberInput');
    const convertButton = document.getElementById('convertButton');
    const resultInput = document.getElementById('NumberToCharacter');
    if (numberInput && convertButton && resultInput) {
        numberInput.addEventListener('input', function () {
            this.value = this.value.replace(/[^-0-9]/g, '').replace(/(?!^-)-/g, '');
            if (this.value.length > 11) this.value = this.value.substring(0, 11);
        });

        convertButton.addEventListener('click', function () {
            const inputNumber = numberInput.value;
            if (!inputNumber || !/^-?\d+$/.test(inputNumber)) {
                showNotification('Por favor, ingresa un número válido.', 'warning');
                resultInput.value = '';
                addLog(`Intento de conversión fallido: entrada no válida, se intentó convertir: ${numberInput.value}`, true);
                return;
            }
            const numberInWords = convertNumberToWords(parseInt(inputNumber, 10));
            resultInput.value = numberInWords;
            showNotification(`Número ${inputNumber} convertido exitosamente.`, 'success');
            addLog(`Número ${inputNumber} convertido a: "${numberInWords}`, false);
        });
    }
    // Función para exportar el log a un archivo CSV
    const exportButton = document.getElementById("exportButton");
    if (exportButton) {
        exportButton.addEventListener("click", function () {
            const logConsole = document.getElementById("logConsole");
            if (!logConsole) return;

            // Capturar todas las líneas del log
            const logEntries = Array.from(logConsole.getElementsByTagName("p"));

            if (logEntries.length === 0) {
                alert("No hay entradas en el log para exportar.");
                return;
            }

            // Agregar los encabezados
            let csvContent = "\uFEFF";
            csvContent += "Hora;Mensaje\n"; // Cambiar la coma por punto y coma

            logEntries.forEach(entry => {
                const parts = entry.textContent.split(" - ");
                const timestamp = parts[0] || "";
                const message = parts.slice(1).join(" - ") || "";

                // Escapar comillas dobles y usar punto y coma como separador
                const escapedMessage = message.replace(/"/g, '""');
                csvContent += `${timestamp};${escapedMessage}\n`; // Usar punto y coma como separador
            });

            // Especificar el separador
            const blob = new Blob([csvContent], {
                type: "text/csv;charset=utf-8;separator=semicolon"
            });

            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = "log_actividades.csv";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

            alert("Log exportado exitosamente como CSV.");
        });
    }
});




// Convertir número a palabras
function convertNumberToWords(num) {
    // Convertir entrada a un número
    num = parseFloat(num);

    if (isNaN(num)) return "Entrada no válida";

    const unidades = ["", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve"];
    const decenas = ["", "", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"];
    const especiales = ["diez", "once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve"];
    const veintitantos = ["veintiuno", "veintidós", "veintitrés", "veinticuatro", "veinticinco", "veintiséis", "veintisiete", "veintiocho", "veintinueve"];
    const centenas = ["", "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"];

    if (num === 0) return "cero";

    let texto = "";

    // Manejo de números negativos
    if (num < 0) {
        texto += "menos ";
        num = Math.abs(num); // Convertir a positivo para procesar
    }

    function convertirHastaMil(n) {
        let resultado = "";

        if (n >= 100) {
            if (n === 100) {
                resultado += "cien"; // Exactamente 100
            } else {
                resultado += centenas[Math.floor(n / 100)] + " ";
            }
            n %= 100;
        }

        if (n >= 20) {
            if (n >= 21 && n <= 29) {
                resultado += veintitantos[n - 21];
            } else {
                resultado += decenas[Math.floor(n / 10)];
                if (n % 10 > 0) resultado += " y " + unidades[n % 10];
            }
        } else if (n >= 10) {
            resultado += especiales[n - 10];
        } else if (n > 0) {
            resultado += unidades[n];
        }

        return resultado.trim();
    }

    // Manejo de millones
    if (num >= 1_000_000) {
        const millones = Math.floor(num / 1_000_000);
        texto += millones === 1 ? "un millón " : `${convertirHastaMil(millones)} millones `;
        num %= 1_000_000;
    }

    // Manejo de miles
    if (num >= 1_000) {
        const miles = Math.floor(num / 1_000);
        if (miles === 1) {
            texto += "mil ";
        } else {
            texto += `${convertirHastaMil(miles)} mil `;
        }
        num %= 1_000;
    }

    // Manejo de unidades y centenas
    texto += convertirHastaMil(num);

    // Reemplazar casos como "uno mil" -> "un mil"
    return texto.trim().replace(/\buno mil\b/g, "un mil");
}

function addLog(message, isError = false) {
    const logConsole = document.getElementById("logConsole");
    const newLog = document.createElement("p");
    newLog.textContent = new Date().toLocaleTimeString() + " - " + message;

    if (isError) {
        newLog.style.color = 'red';
    } else {
        newLog.style.color = 'green';
    }

    logConsole.appendChild(newLog);
    logConsole.scrollTop = logConsole.scrollHeight;    
    logEventToDatabase(message, isError, userId);
}

function logEventToDatabase(message, isError, userId) {    
    const executionResult = isError ? false : true;
    fetch('/Dashboard/LogEvent', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            executionResult: executionResult,
            userId: userId, 
            description: message
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                console.log("Evento registrado en la base de datos.");
            } else {
                console.error("No se pudo registrar el evento en la base de datos.");
            }
        })
        .catch(error => {
            console.error("Error al registrar el evento:", error);
        });
}

function showNotification(message, type = 'success') {
    const notificationContainer = document.getElementById('notificationContainer');
    const notification = document.createElement('div');

    let icon;
    switch (type) {
        case 'success':
            icon = '<i class="fas fa-check-circle"></i>';
            break;
        case 'error':
            icon = '<i class="fas fa-times-circle"></i>';
            break;
        case 'warning':
            icon = '<i class="fas fa-exclamation-triangle"></i>';
            break;
        default:
            icon = '<i class="fas fa-info-circle"></i>';
    }

    notification.className = `notification ${type}`;
    notification.innerHTML = `${icon} ${message}`;

    notificationContainer.appendChild(notification);

    notification.addEventListener('animationend', () => {
        notification.remove();
    });
}
