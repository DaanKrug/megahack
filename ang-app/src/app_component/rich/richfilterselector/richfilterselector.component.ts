import { Component, EventEmitter, Input, Output, OnInit, OnDestroy }  from '@angular/core';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-filter-selector',
  templateUrl: './richfilterselector.component.html'
})
export class RichFilterSelectorComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Output() infoContainEmitter = new EventEmitter<void>();
  @Output() filterObjectsEmitter = new EventEmitter<string>();
  @Output() valueChangedEmitter = new EventEmitter<any>();
  
  constructor() {
	  super(null);
  }
  
  ngOnInit(){
	  super.ngOnInit();
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
      this.infoContainEmitter = null;
      this.filterObjectsEmitter = null;
      this.valueChangedEmitter = null;
  }
  
  infoContain(){
      this.infoContainEmitter.emit();
  }
  
  filterObjects(){
	  var elem = document.getElementById(this.id + 'Contain') as HTMLInputElement;
	  this.filterObjectsEmitter.emit(elem.value);
  }
  
  valueChanged(){
	  var elem = document.getElementById(this.id + 'Select') as HTMLInputElement;
	  this.valueChangedEmitter.emit(elem.value);
  }
  
}