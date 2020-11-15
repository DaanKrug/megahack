const alphaE: string[] = [
	'Ñ','Ã','Á','À','Â','Ä','É','È','Ê','Ë','Í','Ì','Î','Ï','Õ','Ó','Ò','Ô','Ö','Ú','Ù','Û','Ü','Ç'
];
const alphae: string[] = [
	'ñ','ã','á','à','â','ä','é','è','ê','ë','í','ì','î','ï','õ','ó','ò','ô','ö','ú','ù','û','ü','ç'
];
const alphaA: string[] = [
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
];
const alphaa: string[] = [
	'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
];
const numbers: string[] = ['0','1','2','3','4','5','6','7','8','9'];
const specials: string[] = [
	'(',')','*','-','+','%','@','_','.',',','$',':',' ','|',';','/','\\','?','=','&','[',']','{','}'
];
const alphas = alphaA.concat(alphaa).concat(alphaE).concat(alphae).concat([' ']);

export default class InputCorrector{
	
	validChars: any[];

    constructor(type){
    	this.validChars = [];
    	if(type === 'alpha'){
    		this.validChars = alphas.concat([' ']);
    	}
    	if(type === 'alphanum'){
    		this.validChars = alphas.concat(numbers).concat(specials).concat([' ']);
    	}
    	if(type === 'email'){
    		this.validChars = alphaA.concat(alphaa).concat(numbers).concat(['@','.','-','_']);
    	}
    	if(type === 'phone'){
    		this.validChars = numbers.concat([' ','-','(',')']);
    	}
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