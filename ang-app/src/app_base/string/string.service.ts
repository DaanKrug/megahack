import { Injectable } from '@angular/core';
import { ValidationResult } from '../validation/validation.result';

@Injectable({providedIn: 'root'})
export class StringService{
	
	alphaA: any[];
    alphaa: any[];
	alphaE: any[];
	alphae: any[];
    nums: any[];
    hexs: any[];
    doubles: any[];
    specials: any[];
    specialsPassword: any[];
    specialsPasswordLabel: string;
    minChars: number;
    maxChars: number;
	
	constructor(){
		this.alphaE = ['Ã','Á','À','Â','Ä','É','È','Ê','Ë','Í','Ì','Î','Ï','Õ','Ó','Ò','Ô','Ö','Ú','Ù','Û','Ü','Ç'];
		this.alphae = ['ã','á','à','â','ä','é','è','ê','ë','í','ì','î','ï','õ','ó','ò','ô','ö','ú','ù','û','ü','ç'];
		this.alphaA = ['A','B','C','D','E','F','G','H','I','J','K','L',
	                    'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	    this.alphaa = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
	                    'q','r','s','t','u','v','w','x','y','z'];
	    this.nums = ['0','1','2','3','4','5','6','7','8','9'];
	    this.hexs = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'];
	    this.doubles = ['0','1','2','3','4','5','6','7','8','9',',','-'];
	    this.specials = ['(',')','*','-','+','%','@','_','.',',','$',':',' ','/'];
	    this.specialsPassword = ['*','+','%','@','_','.',',','$',':'];
	    this.specialsPasswordLabel = '<strong>* + % @ _ . , $ :</strong>';
	    this.minChars = 10;
	    this.maxChars = 52;
	}
	
	private isValidInputTextChar(char){
		return (char == ' ' || this.alphaA.includes(char) || this.alphaa.includes(char)
				|| this.alphaE.includes(char) || this.alphae.includes(char)
				|| this.nums.includes(char) || this.specials.includes(char));
	}
	
	scapeInvalidCharsFromInputText(value){
		var value2 = '';
		var size = value.length;
		for(var i = 0; i < size; i++){
			if(this.isValidInputTextChar(value.charAt(i))){
				value2 += value.charAt(i);
			}
		}
		return value2;
	}
	
	scapeInvalidCharsFromInputNumber(value){
		var value2 = '';
		var size = value.length;
		var ccommas = 0;
		var comma = ',';
		var minus = '-';
		for(var i = 0; i < size; i++){
			if((i == 0 || i == (size - 1) || ccommas > 0) && value.charAt(i) == comma){
				continue;
			}
			if(i != 0 && value.charAt(i) == minus){
				continue;
			}
			if(this.doubles.includes(value.charAt(i))){
				value2 += value.charAt(i);
			}
			if(value.charAt(i) == comma){
				ccommas ++;
			}
		}
		return value2;
	}
	
	capitalize(value) {
		const arr = value.split(' ');
		var newStr = '';
		const size = arr.length;
		for(var i = 0; i < size; i++){
			if(null==arr[i] || arr[i].trim() == ''){
				continue;
			}
			newStr += ' ';
			arr[i] = arr[i].trim();
			newStr += arr[i].charAt(0).toUpperCase();
			if(arr[i].length < 2){
				continue;
			}
			newStr += arr[i].slice(1).toLowerCase();
		}
		return newStr.trim();
    }
    
    validatePassword(password: string, verifyForce: boolean): ValidationResult{
    	var validation = new ValidationResult(200,'OK','OperationsSuccess');
    	if(undefined == password || null==password){
    		validation.code = 977;
    		validation.msg = 'Senha é requerida.';
    		return validation;
    	}
    	password = password.trim();
    	if((password.length < this.minChars || password.length > this.maxChars)){
    		validation.code = 978;
    		validation.msg = 'Senha inválida. Deve ter entre ' + this.minChars + ' e ' + this.maxChars + ' caracteres.';
    		return validation;
    	}
    	const size = password.length;
    	var isAlphaA = false;
    	var isAlphaa = false;
    	var isNums   = false;
    	var isSpecials = false;
    	var Aas = [];
    	var aas = [];
    	var nuns = [];
    	var spcs = [];
    	for(var i = 0; i < size; i++){
    		var inChars = false;
    		if(this.alphaA.includes(password.charAt(i))){
    			inChars  = true;
    			isAlphaA = true;
    			if(!(Aas.includes(password.charAt(i)))){
    				Aas = [...Aas,password.charAt(i)];
    			}
    		}
    		if(this.alphaa.includes(password.charAt(i))){
    			inChars  = true;
    			isAlphaa = true;
    			if(!(aas.includes(password.charAt(i)))){
    				aas = [...aas,password.charAt(i)];
    			}
    		}
    		if(this.nums.includes(password.charAt(i))){
    			inChars = true;
    			isNums  = true;
    			if(!(nuns.includes(password.charAt(i)))){
    				nuns = [...nuns,password.charAt(i)];
    			}
    		}
    		if(this.specialsPassword.includes(password.charAt(i))){
    			inChars = true;
    			isSpecials = true;
    			if(!(spcs.includes(password.charAt(i)))){
    				spcs = [...spcs,password.charAt(i)];
    			}
    		}
    		if(!inChars){
    			var msg = 'Senha inválida. O caracter da posição [' + (i + 1) + '] não está';
    			msg += ' entre os caracteres permitidos: letras maiúsculas e minúsculas, números,';
    			msg += ' e os caracteres: ' + this.specialsPasswordLabel;
    			validation.code = 979;
        		validation.msg = msg;
        		return validation;
    		}
    	}
    	if(!isAlphaA || !isAlphaa || !isNums || !isSpecials){
    		var msg = 'Senha inválida. Deve conter ao menos: 1 letra maiúscula,';
    		msg += ' 1 letra minúscula, 1 número, e 1 dos seguintes';
    		msg += ' caracteres: ' + this.specialsPasswordLabel;
			validation.code = 979;
    		validation.msg = msg;
    		return validation;
    	}
    	var repeated = 0;
    	for(var i = 0; i < size; i++){
    		if(i > 0 && (password.charAt(i) == password.charAt(i - 1))){
    			repeated++;
    		}
    		if(repeated > 0){
    			var msg = 'Senha inválida. O caracter da posição [' + (i + 1) + '] repete o caracter anterior.';
    			msg += ' Não é aceita a repetição de caracteres.';
    			validation.code = 980;
        		validation.msg = msg;
        		return validation;
    		}
    	}
    	if(verifyForce){
    		var diffMax = this.maxChars - this.minChars;
	    	var max = 350;
	    	var force = Math.pow(password.length - 1,2);
	    	if(repeated > 0){
	    		force -= Math.pow(repeated,3);
	    	}
	    	if(force > max){
	    		force = max;
	    	}
	    	if(force < 0){
	    		force = 0;
	    	} 
	    	var perc = parseInt('0' + (force/max * 100));
	    	var passForce = 'Segurança inadequada';
	    	if(perc > 30){
	    		passForce = 'Segurança regular';
	    	}
	    	if(perc > 50){
	    		passForce = 'Segurança média';
	    	}
	    	if(perc > 65){
	    		passForce = 'Segurança média alta';
	    	}
	    	if(perc > 75){
	    		passForce = 'Segurança alta';
	    	}
	    	if(perc > 85){
	    		passForce = 'Segurança quase ideal';
	    	}
	    	if(perc > 90){
	    		passForce = 'Segurança ideal';
	    	}
	    	var msg = 'Força da senha: ' + passForce;
	    	validation.msg = msg;
    	}
    	return validation;
    }
    
    generateCodeHex(size){
		var seq = '';
		for(var i = 0; i < size; i++){
			 seq += this.hexs[Math.floor(Math.random() * this.hexs.length)];
		}
		return seq;
	}
    
    generateCode3(size){
		var seq = '';
		for(var i = 0; i < size; i++){
			 seq += this.alphaA[Math.floor(Math.random() * this.alphaA.length)];
			 seq += this.alphaa[Math.floor(Math.random() * this.alphaa.length)];
			 seq += this.nums[Math.floor(Math.random() * this.nums.length)];
		}
		return seq;
	}
    
	generateCode4(size){
		var seq = '';
		for(var i = 0; i < size; i++){
			 seq += this.alphaA[Math.floor(Math.random() * this.alphaA.length)];
			 seq += this.alphaa[Math.floor(Math.random() * this.alphaa.length)];
			 seq += this.nums[Math.floor(Math.random() * this.nums.length)];
			 seq += this.specialsPassword[Math.floor(Math.random() * this.specialsPassword.length)];
		}
		return seq;
	}
	
	generateEmail(){
		var seq = '';
		for(var i = 0; i < 4; i++){
			 seq += this.alphaa[Math.floor(Math.random() * this.alphaa.length)];
			 seq += this.nums[Math.floor(Math.random() * this.nums.length)];
		}
		seq += new Date().getTime();
		seq += '@naotememail.com';
		return seq;
	}
	
	validateEmail(email){
		if(undefined == email || null == email || email.trim() == ''){
			return false;
		}
		var indexA = email.indexOf('@');
		var lindexA = email.lastIndexOf('@');
		var lindexD = email.lastIndexOf('.');
		var len = email.length;
		if(lindexA < 1 || lindexD < 1 || lindexA > (len - 2) || lindexD > (len - 2) || (lindexD < lindexA)){
			return false;
		}
		return true;
	}
	
	truncate(text,maxChars){
		if(undefined == text || null == text 
			|| undefined == maxChars || null == maxChars){
			return text;
		}
		if(maxChars > 5 && text.length > maxChars){
			return text.substring(0,maxChars - 4) + '...';
		}
		return text;
	}
	
	translate(text,reverse){
		var arr1 = [
	            'ã','á','à','â',
	            'é','è','ê',
	            'í','ì',
	            'õ','ó','ò','ô',
	            'ú','ù',
	            'ç',
	            'Ã','Á','À','Â',
	            'É','È','Ê',
	            'Í','Ì',
	            'Õ','Ó','Ò','Ô',
	            'Ú','Ù',
	            'Ç'
	           ];
	    var arr2 = [
	            '&atilde;','&aacute;','&agrave;','&acirc;',
	            '&eacute;','&egrave;','&ecirc;',
	            '&iacute;','&igrave;',
	            '&otilde;','&oacute;','&ograve;','&ocirc;',
	            '&uacute;','&ugrave;',
	            '&ccedil;',
	            '&Atilde;','&Aacute;','&Agrave;','&Acirc;',
	            '&Eacute;','&Egrave;','&Ecirc;',
	            '&Iacute;','&Igrave;',
	            '&Otilde;','&Oacute;','&Ograve;','&Ocirc;',
	            '&Uacute;','&Ugrave;',
	            '&Ccedil;'
	           ];
	    var size = arr1.length;
	    if(reverse){
	    	for(var i = 0; i < size; i++){
	    		text = this.replaceAll(text,arr2[i],arr1[i]);
		    }
		    return text;
    	}
	    for(var i = 0; i < size; i++){
	    	text = this.replaceAll(text,arr1[i],arr2[i]);
	    }
	    return text;
	}
	
	removeEspecials(text){
		var arr1 = [
	            'ã','á','à','â',
	            'é','è','ê',
	            'í','ì',
	            'õ','ó','ò','ô',
	            'ú','ù',
	            'ç',
	            'Ã','Á','À','Â',
	            'É','È','Ê',
	            'Í','Ì',
	            'Õ','Ó','Ò','Ô',
	            'Ú','Ù',
	            'Ç'
	           ];
		var arr2 = [
            'a','a','a','a',
            'e','e','e',
            'i','i',
            'o','o','o','o',
            'u','u',
            'c',
            'A','A','A','A',
            'E','E','E',
            'I','I',
            'O','O','O','O',
            'U','U',
            'C'
           ];
	    var size = arr1.length;
		for(var i = 0; i < size; i++){
			text = this.replaceAll(text,arr1[i],arr2[i]);
	    }
	    return text;
	}
	
	unentityLtGt(html){
		html = this.trimm(html);
		html = html.replace(/<br>/gi,'');
		html = html.replace(/<br\/>/gi,'');
		html = this.replaceAll(html,'&#9;','');
		html = this.replaceAll(html,'  ',' ');
		html = this.replaceAll(html,'&lt;','<');
		html = this.replaceAll(html,'&gt;','>');
		html = this.replaceAll(html,'"&quot;','"');
		html = this.replaceAll(html,'&quot;"','"');
		html = this.replaceAll(html,'&#34;','"');
		html = this.replaceAll(html,'<b>','<strong>');
		html = this.replaceAll(html,'</b>','</strong>');
		html = this.replaceAll(html,'<i>','<em>');
		html = this.replaceAll(html,'</i>','</em>');
		html = this.replaceAll(html,'<u>','<span style="text-decoration: underline;">');
		html = this.replaceAll(html,'</u>','</span>');
		html = this.replaceAll(html,'<font color="','<span style="color: ');
		html = this.replaceAll(html,'<font size="','<span style="font-size: ');
		html = this.replaceAll(html,'</font>','</span>');
		html = this.replaceAll(html,'<div><br></div>','');
		html = this.replaceAll(html,'<div><br/></div>','');
		html = this.replaceAll(html,'<div','<p');
		html = this.replaceAll(html,'</div','</p');
		html = this.sanitizeHtml(html);
		return html;
	}
	
	sanitizeHtml(html){
		html = this.trimm(html);
		html = this.replaceAll(html,'  ',' ');
		html = this.replaceAll(html,'<script>','<span>');
		html = this.replaceAll(html,'<script','<span');
		html = this.replaceAll(html,'<script ','<span ');
		html = this.replaceAll(html,'< script','<span');
		html = this.replaceAll(html,'</script','</span');
		return html;
	}
	
	cleanUpHtml(text){
		return text.replace(/<.+?>/gi,'');
	}
	
	replaceAll(origin,searchFor,replaceWhit){
		if(null==origin || this.trimm(origin) == '' ||
			null==searchFor || this.trimm(searchFor) == '' ||
			null==replaceWhit || this.trimm(replaceWhit) == ''){
			return origin;
		}
		origin = this.trimm(origin);
		searchFor = this.trimm(searchFor);
		replaceWhit = this.trimm(replaceWhit);
    	while(origin.indexOf(searchFor) != -1){
    		origin = origin.replace(searchFor,replaceWhit);
    	}
    	return origin;
	}
	
	replaceFirst(origin,searchTo,replaceTo){
		if(null==origin || this.trimm(origin) == '' ||
			null==searchTo || this.trimm(searchTo) == '' ||
			null==replaceTo || this.trimm(replaceTo) == ''){
			return origin;
		}
		origin = this.trimm(origin);
		searchTo = this.trimm(searchTo);
		replaceTo = this.trimm(replaceTo);
		if(origin.indexOf(searchTo) != -1){
			origin = origin.replace(searchTo,replaceTo);
		}
		return origin;
	}
	
	trimm(str){
    	if(undefined==str || null==str){
    		return '';
    	}
    	str = '' + str;
    	return str.replace(/^\s+|\s+$/g,'');
    }
	
	generateProtocol(id){
	   if(null==id || !(id > 0)){
		   return this.calculateProtocol('0');
	   }
	   return this.calculateProtocol('' + id);
    }
   
    private calculateProtocol(numberString){
       var number = parseInt(numberString);
       number = (number/111);
       number = (number/77);
       number = (number/23);
       numberString += number;
       numberString = numberString.replace(/\./gi,'');
	   while(numberString.length < 10){
		   numberString = '0' + numberString;
	   }
	   numberString = numberString.substring(0,10);
	   var protocol = '';
	   for(var i = 9; i >= 0; i--){
		   protocol += numberString.charAt(i);
	   }
	   return protocol;
    }
	
}