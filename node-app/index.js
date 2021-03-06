const config = require("./config.js");
const token = config.token, apiUrl = config.apiUrl;
const app = require('express')();
const bodyParser = require('body-parser');
const fetch = require('node-fetch');
const { text } = require("body-parser");
app.use(bodyParser.json());

process.on('unhandledRejection', err => {
    console.log(err)
});	

app.get('/', function (req, res) {
    res.send("It's working.");
}); 

app.post('/webhook', async function (req, res) {
    const data = req.body;
    for (var i in data.messages) {
        const author = data.messages[i].author;
        const body = data.messages[i].body;
        const chatId = data.messages[i].chatId;
        const senderName = data.messages[i].senderName;
        let save= {};
        if(data.messages[i].fromMe)return;

        console.log(data);
        
        if(/1/.test(body) && save[`${chatId}`] === 'choice'){
            const text = `Por favor informe o CPF ou CNPJ do responsável`;
            await apiChatApi('sendMessage', {chatId: chatId, body: text});
            save[`${chatId}`] = 'choice1'
        } else if(/2/.test(body) && save[`${chatId}`] === 'choice') {
            const text = `Digite seu CPF e mande sua localização para enviarmos uma equipe`;
            await apiChatApi('sendMessage', {chatId: chatId, body: text});
            save[`${chatId}`] = 'choice2'
        } else if (/05432246945/.test(body) && save[`${chatId}`] === 'choice1') {
            const text = `Olá Daniel Augusto Krug! Envie sua localização para enviarmos uma equipe para o local`;
            await apiChatApi('sendMessage', {chatId: chatId, body: text});

            const text = `A equipe irá chegar no local com um tempo mínimo de 3 horas`;
            await apiChatApi('sendMessage', {chatId: chatId, body: text});
        } else if (/12345678912/.test(body) && save[`${chatId}`] === 'choice1') {
            const text = `Olá Daniel Augusto Krug! Envie sua localização para enviarmos uma equipe para o local`;
            await apiChatApi('sendMessage', {chatId: chatId, body: text});

            const text = `A equipe irá chegar no local com um tempo mínimo de 3 horas`;
            await apiChatApi('sendMessage', {chatId: chatId, body: text});
        } else {
            if(!save[`${chatId}`]) {
                const text = `Oi, eu sou a Joana, assistente virtual da CPFL. Estou aqui pra te ajudar. Por favor digite o número do serviço que deseja solicitar.
1. Queda de energia elétrica 
2. Religação de energia`;
                await apiChatApi('sendMessage', {chatId: chatId, body: text});
            }

            save[`${chatId}`] = 'choice';
        }
    }
    res.send('Ok');
});

app.listen(process.env.PORT || 8080, function () {
    console.log(`Listening on port ${process.env.PORT || 8080}...`);
});

async function apiChatApi(method, params){
    const options = {};
    options['method'] = "POST";
    options['body'] = JSON.stringify(params);
    options['headers'] = { 'Content-Type': 'application/json' };
    
    const url = `${apiUrl}/${method}?token=${token}`; 
    console.log(url);
    
    const apiResponse = await fetch(url, options);
    console.log(apiResponse);
    const jsonResponse = await apiResponse.json();
    console.log(jsonResponse);
    return jsonResponse;
}