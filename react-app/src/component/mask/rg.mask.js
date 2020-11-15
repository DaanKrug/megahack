export default class RgMask{
	
    adjustValue(value){
    	/*let valueArr = value.split(' ');
    	value = valueArr[0];*/
    	value = value.replace(/\D/g, '')
			         .replace(/(\d{3})(\d)/, '$1.$2')
			         .replace(/(\d{3})(\d)/, '$1.$2')
			         .replace(/(\d{3})(\d{1,2})/, '$1-$2')
			         .replace(/(-\d{2})\d+?$/, '$1');
		/*let compl = valueArr.length > 1 ? valueArr[1] : '';
		compl = compl.replace(/[A-z0-9]/g, '')
			         .replace(/(\d{3})(\d{1,2})/, '$1-$2')
			         .replace(/(-\d{2})\d+?$/, '$1'); */
    	return value;// + ' ' + compl;
	}
	
}