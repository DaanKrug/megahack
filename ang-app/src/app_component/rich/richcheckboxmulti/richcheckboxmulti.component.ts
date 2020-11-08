import { Component, EventEmitter, Input, Output, OnInit, OnDestroy }  from '@angular/core';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-checkbox-multi',
  templateUrl: './richcheckboxmulti.component.html'
})
export class RichCheckboxMultiComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Input() widthInput: number;
  @Output() valueChangedAddEmitter = new EventEmitter<any>();
  @Output() valueChangedRemoveEmitter = new EventEmitter<any>();
  
  constructor() {
	  super(null);
  }
  
  ngOnInit(){
	  super.ngOnInit();
	  if(null == this.widthInput){
		  this.widthInput = 8.5;
	  }
	  if(this.widthInput < 4){
		  this.widthInput = 4;
	  }
	  if(this.widthInput > 20){
		  this.widthInput = 20;
	  }
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
	  this.widthInput = null;
	  this.valueChangedAddEmitter = null;
	  this.valueChangedRemoveEmitter = null;
  }
  
  valueChangedAdd(value: any){
	  this.valueChangedAddEmitter.emit(value);
  }
  
  valueChangedRemove(value: any){
	  this.valueChangedRemoveEmitter.emit(value);
  }
  
}