document.addEventListener("DOMContentLoaded", function () {
    const generateButton = document.getElementById("generate-button");
    const passwordList = document.getElementById("password-list");

    generateButton.addEventListener("click", function () {
        passwordList.innerHTML = ""; // Limpar senhas anteriores

        // Gere senhas e adicione à lista
        for (let i = 0; i < 5; i++) {
            const password = generateRandomPassword(12); // Tamanho da senha desejada
            const listItem = document.createElement("li");
            listItem.textContent = password;
            passwordList.appendChild(listItem);
        }
    });

    function generateRandomPassword(length) {
        // Implemente a lógica para gerar senhas aleatórias
        // Você pode usar caracteres alfanuméricos ou símbolos
    }
});
