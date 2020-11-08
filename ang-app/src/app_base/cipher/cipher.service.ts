import { Injectable } from '@angular/core';
import { BaseService } from '../base.service';

const factor: number = 5116;
const headers: string[] = [
    'CAFEBABE31AF','CAFEBABE319F','CAFEBABE4129','CAFEBABE4101','CAFEBABE4159',
    '7F454C4631BF','7F454C46318F','7F454C464102','7F454C464161','7F454C464121',
    '504B0304310F','504B0304317F','504B03044111','504B03044149','504B03044109',
    '504B0506313F','504B0506315F','504B05064139','504B05064102','504B05064131',
    '504B0708313F','504B070831BF','504B07084141','504B07084109','504B07084161',
    '52617221317F','52617221310F','526172214149','526172214131','526172214159',
    'FFD8FFDB314F','FFD8FFDB318F','FFD8FFDB4119','FFD8FFDB4111','FFD8FFDB4151','FFD8FFDB4161',
    'FFD8FFEE31AF','FFD8FFEE317F','FFD8FFEE4102','FFD8FFEE4129','FFD8FFEE4139','FFD8FFEE4111',
    '69660000316F','6966000031BF','696600004119','696600004131','696600004149','696600004151','696600004102',
    '00000100310F','00000100313F','000001004141','000001004149','000001004109','000001004101','000001004161',
    'D0CF11E0A1B11AE1315F','D0CF11E0A1B11AE14109','D0CF11E0A1B11AE14139','D0CF11E0A1B11AE14129',
    '377ABCAF271C312F','377ABCAF271C4121','377ABCAF271C4149','377ABCAF271C4161','377ABCAF271C4111',
    '1F8B313F','1F8B314F','1F8B4111','1F8B4129','1F8B4141','1F8B4102','1F8B4151','1F8B4161',
    '774F4646310F','774F4646318F','774F46464109','774F46464121','774F46464159','774F46464139',
    '774F4632311F','774F4632312F','774F46324111','774F46324139','774F46324159','774F46324151',
    '3C3F786D6C20310F','3C3F786D6C20314F','3C3F786D6C204149','3C3F786D6C204121','3C3F786D6C204111',
    '7B5C72746631311F','7B5C72746631317F','7B5C727466314101','7B5C727466314119','7B5C727466314139',
    '789C311F','789C31AF','789C4102','789C4109','789C4111','789C4131','789C4139','789C4151','789C4159','789C4161',
    '78DA313F','78DA318F','78DA4101','78DA4102','78DA4109','78DA4121','78DA4131','78DA4149','78DA4159',
    'CAFEBABE',
    '7F454C46',
    '504B0304',
    '504B0506',
    '504B0708',
    '52617221',
    'FFD8FFDB',
    'FFD8FFEE',
    '69660000',
    '00000100',
    'D0CF11E0A1B11AE1',
    '377ABCAF271C',
    '1F8B',
    '774F4646',
    '774F4632',
    '3C3F786D6C20',
    '7B5C72746631',
    '789C',
    '78DA'
];
const validChars: string[] = [
    'A','Ä','Ã','Â','Á','À',
    'B','C','Ç','D',
    'E','Ë','Ẽ','Ê','É','È',
    'F','G','H',
    'I','Ï','Ĩ','Î','Í','Ì',
    'J','K','L','M','N',
    'O','Ö','Õ','Ô','Ó','Ò',
    'P','Q','R','S','T',
    'U','Ü','Ũ','Û','Ú','Ù',
    'V','X','W',
    'Y','Ÿ','Ỹ','Ŷ','Ý','Ỳ',
    'Z',
    'a','ä','ã','â','á','à',
    'b','c','ç','d',
    'e','ë','ẽ','ê','é','è',
    'f','g','h',
    'i','ï','ĩ','î','í','ì',
    'j','k','l','m','n',
    'o','ö','õ','ô','ó','ò',
    'p','q','r','s','t',
    'u','ü','ũ','û','ú','ù',
    'v','x','w',
    'y','ÿ','ỹ','ŷ','ý','ỳ',
    'z',
    '0','1','2','3','4','5','6','7','8','9',
    ' ','.',',',';',':','<','>','/','\\','?','|',
    '[',']','{','}','(',')','º','°','ª',
    '+','-','=','_','*','&','%','$','#','@',
    '!','"','\'','\n','\r','\t'
];

@Injectable({providedIn: 'root'})
export class CipherService extends BaseService{
	
	cipher(string){
	    var chars = string.split('');
	    var randSize = 9999 - validChars.length;
	    var summer = this.toInt(((1 + Math.random()) * randSize) % randSize);
	    var sumChars = (this.leftZeros(summer,4)).split('');
	    var header = this.cipherChars(sumChars,['0','1','2','3','4','5','6','7','8','9'],4,factor).join('');
	    var body = this.cipherChars(chars,validChars,chars.length,summer).join('');
	    var pos = this.toInt(((1 + Math.random()) * headers.length) % headers.length);
	    return headers[pos] + header + body;
	}
	
	private toInt(number){
		if(('' + number).indexOf('.') != -1){
			return parseInt(('' + number).split('.')[0]);
		}
		return number;
	}
	
	private cipherChars(chars,desiredChars,max,summer){
		var newChars = [];
		var size = chars.length;
		for(var i = 0; i < size; i++){
			if(i > max){
				return newChars;
			}
			if(!(desiredChars.includes(chars[i]))){
				continue;
			}
			newChars = [...newChars,this.cipherChar(desiredChars,chars[i],summer)];
		}
		return newChars;
	}
	
	private cipherChar(desiredChars,char,summer){
		var i = summer + this.getPosChar(desiredChars,char);
		var chars2 = this.leftZeros(i.toString(16),4).split('');
		return chars2[1] + chars2[0] + chars2[3] + chars2[2];
	}
	
	private getPosChar(chars,char){
		var size = chars.length;
		for(var i = 0; i < size; i++){
			if(chars[i] == char){
				return i;
			}
		}
		return 0;
	}
	
}