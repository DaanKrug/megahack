import { Injectable } from '@angular/core';
import { BaseService } from '../base.service';

@Injectable({providedIn: 'root'})
export class MathService extends BaseService{
	
	formatNumber(value,decimals,separator){
		separator = (null != separator && separator != '.') ? separator : '.';
		value = ('' + value).trim();
		if(value == '' || value.indexOf(separator) == 0){
			value = '0' + value;
		}
		if(value.indexOf(separator) == -1){
			return (value + '.' + this.rightZeros('',decimals));
		}
		var partsArray = value.split(separator);
		return (partsArray[0] + '.' + this.rightZeros(partsArray[1],decimals));
	}
	
	parseDouble(value,decimals,separator){
		return parseFloat(this.formatNumber(value,decimals,separator));
	}
	
}