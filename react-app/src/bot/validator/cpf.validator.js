const CpfValidator = (cpf) => {
	if(null === cpf || cpf.trim() === ''){
		return 'Ei, o CPF deve ser um valor numérico.';
	}
	cpf = cpf.trim();
	cpf = cpf.replace(/\./gi,'');
	cpf = cpf.replace(/-/gi,'');
    if(isNaN(cpf)){
    	return 'Ei, o CPF deve ser um valor numérico.';
    }
    if(cpf.length !== 11){
    	return 'Ei, o CPF deve ter 11 números.';
    }
    return null;
};

export default CpfValidator;