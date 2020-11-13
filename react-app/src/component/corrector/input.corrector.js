export default class InputCorrector{
	
	validChars: any[];

    constructor(validChars){
    	this.validChars = validChars;
    }
	
    adjustValue(value){
		let newValue = '';
		const size = value.length;
		for(let i = 0; i < size; i++){
			if(this.validChars.includes(value.charAt(i))){
				newValue += value.charAt(i);
			}
		}
		return newValue;
	}
	
}