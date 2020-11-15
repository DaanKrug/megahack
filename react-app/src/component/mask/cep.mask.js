export default class CepMask{
	
    adjustValue(value){
    	value = value.replace(/\D/g, '')
    	             .replace(/(\d{5})(\d)/, '$1-$2')
			         .replace(/(\d{5})(\d{1,2,3})/, '$1-$2')
			         .replace(/(-\d{3})\d+?$/, '$1');
		return value;
	}
	
}