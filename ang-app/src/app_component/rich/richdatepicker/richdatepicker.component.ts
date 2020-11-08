import { Component, EventEmitter, Input, 
	     Output, OnInit, OnDestroy }               from '@angular/core';
import { NgControl } from '@angular/forms';
	     
import { RichBaseComponent } from '../richbase.component';

@Component({
  selector: 'rich-date-picker',
  templateUrl: './richdatepicker.component.html'
})
export class RichDatePickerComponent extends RichBaseComponent implements OnInit, OnDestroy{

  @Input() whitTime: any;
  
  constructor(private ngControl: NgControl) {
	  super(ngControl);
  }
  
  doNothing(){}
   
  ngOnInit(){
	  super.ngOnInit();
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
      this.whitTime = null;
  }
  
  onDateSelect(event){
	  var d = event.day;
	  var m = event.month;
	  var y = event.year;
	  var value = this.leftZeros(d,2) + '/' + this.leftZeros(m,2) + '/' + this.leftZeros(y,4);
	  if(this.whitTime){
		  value += ' 00:00:00';
	  }
	  this.formGroup.controls[this.formControlName].patchValue(value);
  }
  
  leftZeros(value,size){
	  value = '' + value;
	  while(value.length < size){
		  value = '0' + value;
	  }
	  return value;
  }
  
}