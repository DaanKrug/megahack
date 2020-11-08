import { Component, EventEmitter, Input, Output, 
	     OnInit, OnDestroy, AfterViewInit }        from '@angular/core';
import { NgControl } from '@angular/forms';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-input-text',
  templateUrl: './richinputtext.component.html'
})
export class RichInputTextComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Input() forNumber: boolean;
  @Input() forAlphaNum: boolean;
  @Input() forAlphaNumName: boolean;
  @Input() forAlpha: boolean;
  @Input() forMail: boolean;
  @Input() forPassword: boolean;

  @Output() valueChangedEmitter = new EventEmitter<any>();
  
  constructor(private ngControl: NgControl) {
	  super(ngControl);
  }
  
  ngOnInit(){
	  super.ngOnInit();
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
	  this.forNumber = null;
	  this.forAlphaNum = null;
	  this.forAlphaNumName = null;
	  this.forAlpha = null;
	  this.forMail = null;
	  this.forPassword = null;
	  this.valueChangedEmitter = null;
  }
  
  onChangeValue(event){
	  var value = event.target.value.trim();
	  if(this.forNumber){
		  this.adjustInputNumberValueAfterChange(value);
		  return;
	  }
	  if(this.forAlphaNum){
		  this.adjustInputAlphaNumValueAfterChange(value);
		  return;
	  }
	  if(this.forAlphaNumName){
		  this.adjustInputAlphaNumNameValueAfterChange(value);
		  return;
	  }
	  if(this.forAlpha){
		  this.adjustInputAlphaValueAfterChange(value);
		  return;
	  }
	  if(this.forMail){
		  this.adjustInputTextMailAddressValueAfterChange(value);
		  return;
	  }
	  if(this.forPassword){
		  this.valueChangedEmitter.emit(value);
		  return;
	  }
	  this.adjustInputTextValueAfterChange(value);
  }
 
}
