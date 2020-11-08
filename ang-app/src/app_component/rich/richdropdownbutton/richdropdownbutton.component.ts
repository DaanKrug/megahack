import { Component, EventEmitter, Input, Output, OnInit, OnDestroy }  from '@angular/core';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-dropdown-button',
  templateUrl: './richdropdownbutton.component.html'
})
export class RichDropDownButtonComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Input() forToggle: boolean;
	
  @Output() clickEmitter = new EventEmitter<any>();
  @Output() clickEmitter1 = new EventEmitter<any>();
  @Output() clickEmitter2 = new EventEmitter<any>();
  
  constructor() {
	  super(null);
  }
  
  ngOnInit(){
	  super.ngOnInit();
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
	  this.forToggle = null;
	  this.clickEmitter = null;
	  this.clickEmitter1 = null;
	  this.clickEmitter2 = null;
  }
  
  clicked(value: any){
	  this.clickEmitter.emit(value);
	  this.clickEmitter1.emit(value);
	  this.clickEmitter2.emit(value);
  }
  
}