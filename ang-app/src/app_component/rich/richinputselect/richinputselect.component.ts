import { Component, EventEmitter, Input, Output, 
	     OnInit, OnDestroy, AfterViewInit }        from '@angular/core';
import { NgControl } from '@angular/forms';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-input-select',
  templateUrl: './richinputselect.component.html'
})
export class RichInputSelectComponent extends RichBaseComponent implements OnInit, OnDestroy{
	
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
	  var elem = document.getElementById(this.id) as HTMLInputElement;
	  this.valueChangedEmitter.emit(elem.value);
  }
  
}
