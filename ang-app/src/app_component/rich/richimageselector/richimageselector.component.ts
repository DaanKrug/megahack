import { Component, EventEmitter, Input, 
	     Output, OnInit, OnDestroy }               from '@angular/core';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-image-selector',
  templateUrl: './richimageselector.component.html'
})
export class RichImageSelectorComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Output() infoContainEmitter = new EventEmitter<void>();
  @Output() filterObjectsEmitter = new EventEmitter<string>();
  @Output() valueChangedEmitter = new EventEmitter<any>();
  
  constructor() {
	  super(null);
  }
  
  ngOnInit(){
	  super.ngOnInit();
	  setTimeout(() => {
		  if(null == this.oldSelectedObject){
			  return;
		  }
		  this.setSrcInElement(this.id + 'OldImage',this.oldSelectedObject.link);
	  },100);
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
	  setTimeout(() => {
		  if(null == this.selectedObject){
			  return;
		  }
		  this.setSrcInElement(this.id + 'NewImage',this.selectedObject.link);
	  },200);
  }
  
  setSrcInElement(id,link){
	  if(this.emptyString(link)){
		  return;
	  }
	  var elem: any = document.getElementById(id);
      if(null == elem){
    	  setTimeout(() => {this.setSrcInElement(id,link);},100);
    	  return;
      }
	  elem.src = link.trim();
  }
  
}