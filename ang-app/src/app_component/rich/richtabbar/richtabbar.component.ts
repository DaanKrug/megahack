import { Component, EventEmitter, Input, Output, OnInit, OnDestroy, AfterViewInit }  from '@angular/core';

import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-tab-bar',
  templateUrl: './richtabbar.component.html'
})
export class RichTabBarComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Input() selectedTab: any;
  @Output() setTabEmitter = new EventEmitter<any>();
  
  constructor() {
	  super(null);
  }
  
  ngOnInit(){
	  super.ngOnInit();
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
	  this.selectedTab = null;
	  this.setTabEmitter = null;
  }
  
  isSelected(value: string){
	  if(null==this.selectedTab){
		  return false;
	  }
	  if(value.indexOf('|') == -1){
		  return (value.trim() == ('' + this.selectedTab).trim());
	  }
	  return (value.trim().split('|')[1] == ('' + this.selectedTab).trim());
  }
  
  setTab(value: any){
	  this.setTabEmitter.emit(value);
  }
  
}
