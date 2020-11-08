const AgeValidator = (age) => {
    if(isNaN(age)){
    	return 'Idade deve ser um valor numérico!';
    }
    if (age < 0){
    	return 'Idade deve ser maior que zero!';
    }
    if (age > 120) {
    	return (age + '? Por favor, informe corretamente!');
    }
    return null;
};

export default AgeValidator;