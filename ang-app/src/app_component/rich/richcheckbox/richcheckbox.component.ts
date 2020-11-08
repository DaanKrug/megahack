import { Component, EventEmitter, Input, 
	     Output, OnInit, OnDestroy }               from '@angular/core';
import { NgControl } from '@angular/forms';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-checkbox',
  templateUrl: './richcheckbox.component.html'
})
export class RichCheckboxComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Output() valueChangedEmitter = new EventEmitter<any>();
  
  constructor(private ngControl: NgControl) {
	  super(ngControl);
  }
  
  ngOnInit(){
	  super.ngOnInit();
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
	  this.valueChangedEmitter = null;
  }
  
  valueChanged(){
	  this.valueChangedEmitter.emit(this.getContent());
  }
  
}