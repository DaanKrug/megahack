export default class CnpjMask{
	
	// 00.000.000/0000-00)
	
    adjustValue(value){
    	value = value.replace(/\D/g, '')
			         .replace(/(\d{2})(\d)/, '$1.$2') 
			         .replace(/(\d{3})(\d)/, '$1.$2') 
			         .replace(/(\d{3})(\d)/, '$1/$2')
			         .replace(/(\d{4})(\d{1,2})/, '$1-$2')
			         .replace(/(-\d{2})\d+?$/, '$1');
		return value;
	}
	
}