export default class DateMask{
	
    adjustValue(value){
    	value = value.replace(/\D/g, '') 
			         .replace(/(\d{2})(\d)/, '$1/$2')
			         .replace(/(\d{2})(\d)/, '$1/$2')
			         .replace(/(\/\d{4})\d+?$/, '$1');
    	let valueArr = value.split('/');
    	if(valueArr.length > 0 && parseInt(valueArr[0]) === 0){
    		valueArr[0] = '01';
    	}
    	if(valueArr.length > 0 && parseInt(valueArr[0]) > 31){
    		valueArr[0] = '31';
    	}
    	if(valueArr.length > 1 && parseInt(valueArr[1]) === 0){
    		valueArr[0] = '01';
    	}
    	if(valueArr.length > 1 && parseInt(valueArr[1]) > 12){
    		valueArr[0] = '12';
    	}
    	let year = new Date().getFullYear();
    	if(valueArr.length > 2 && parseInt(valueArr[2]) === 0){
    		valueArr[0] = year;
    	}
    	if(valueArr.length > 2 && parseInt(valueArr[1]) > year){
    		valueArr[0] = year;
    	}
		return valueArr.join('/');
	}
	
}