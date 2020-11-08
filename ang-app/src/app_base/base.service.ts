export class BaseService {
	
	leftZeros(value,len){
    	value = '' + value;
    	while(value.length < len){
    		value = '0' + value;
    	}
    	return value;
    }
	
	rightZeros(value,len){
    	value = '' + value;
    	if(value.length > len){
    		return value.slice(0,len);
    	}
    	while(value.length < len){
    		value += '0';
    	}
    	return value;
    }
	
}