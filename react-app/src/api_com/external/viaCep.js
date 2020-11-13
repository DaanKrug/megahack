/*
params - cep: string
return {
    bairro: string,
    complemento: string,
    ddd: string,
    gia: string,
    ibge: string,
    localidade: string,
    logradouro: string,
    siafi: string,
    uf: string
}
error - return {
    erro: boolean
}
*/
const viaCep = 'https://viacep.com.br/ws/cep/json/'
function findCep(cep) {
    const cepSearchUrl = viaCep.replace('/cep/', `/${cep}/`)
    fetch(cepSearchUrl, {method: 'get'})
        .then((response) =>  response.json())     
        .then(result => {
            if(result.erro){
                return 'Cep não encontrado'
            }
            return result
        })
}