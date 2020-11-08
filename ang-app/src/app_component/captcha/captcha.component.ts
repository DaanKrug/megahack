import { Component, EventEmitter, Input, Output, OnInit, OnDestroy } from '@angular/core';
import { StringService } from '../../app_base/string/string.service';

import { BaseCustomComponent } from '../basecustomcomponent';

@Component({
  selector: 'captcha',
  templateUrl: './captcha.component.html'
})
export class CaptchaComponent extends BaseCustomComponent implements OnInit, OnDestroy{

  id: string;
  captcha: string;
  timeout: any;
  @Input() noRender: boolean;
  
  @Output() captchaOkEmitter = new EventEmitter<boolean>();

  constructor(private stringService: StringService){
	  super();
  }

  ngOnInit(){
      this.id = new Date().getTime() + '_' + this.stringService.generateCode3(3);
      this.captchaOkEmitter.emit(false);
  }
  
  ngOnDestroy(){
      this.id = null;
      this.captcha = null;
      clearTimeout(this.timeout);
  	  this.timeout = null;
  	  this.noRender = null;
      this.captchaOkEmitter = null;
  }
  
  generateCaptcha(checked){
	  if(null == this.captchaOkEmitter){
		  return;
	  }
      this.captcha = checked ? this.stringService.generateCode4(2).toLowerCase() : null;
      var elem: any = document.getElementById('reCaptcha_' + this.id);
      if(null!=elem){
    	  elem.value = '';
      }
      this.captchaOkEmitter.emit(false);
  }
  
  onkeyup(event){
      var digited = event.target.value.trim();
      var ok = (null != this.captcha && this.captcha.trim() != '' && this.captcha.trim() == digited);
  	  this.captchaOkEmitter.emit(ok);
  	  if(ok){
  	  	  this.timeout = setTimeout(() => {this.generateCaptcha(false);},10000);
  	  	  return;
  	  }
  	  clearTimeout(this.timeout);
  	  this.timeout = null;
  }
  
}
