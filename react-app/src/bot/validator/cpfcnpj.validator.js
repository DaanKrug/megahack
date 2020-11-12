const CpfCnpjValidator = (cpf) => {
	if(null === cpf || cpf.trim() === ''){
		return 'Ei, o CPF/CNPJ deve ser um valor numérico.';
	}
	cpf = cpf.trim();
	cpf = cpf.replace(/\./gi,'');
	cpf = cpf.replace(/-/gi,'');
	cpf = cpf.replace(/\//gi,'');
    if(isNaN(cpf)){
    	return 'Ei, o CPF/CNPJ deve ser um valor numérico.';
    }
    if(![11,14].includes(cpf.length)){
    	return 'Ei, para informar o CPF digite 11 números. Se quiser informar o CNPJ informe 14 números.';
    }
    return null;
};

export default CpfCnpjValidator;