import { Component, EventEmitter, Input, Output, OnInit, OnDestroy } from '@angular/core';

import { BaseCustomComponent } from '../basecustomcomponent';

@Component({
  selector: 'continue-confirmation',
  templateUrl: './continueconfirmation.component.html'
})
export class ContinueConfirmationComponent extends BaseCustomComponent implements OnInit, OnDestroy{

  @Input() titlee: string;
  @Input() content: string;
  @Input() noCancel: boolean;
  
  @Output() confirmContinueProcessEmitter = new EventEmitter<void>();
  @Output() cancelContinueProcessEmitter = new EventEmitter<void>();
  
  constructor() {
	  super();
  }
  
  ngOnInit(){}
  
  ngOnDestroy(){
      this.titlee = null;
      this.content = null;
      this.noCancel = null;
      this.confirmContinueProcessEmitter = null;
      this.cancelContinueProcessEmitter = null;
  }
  
  confirmContinueProcess(){
  	  this.confirmContinueProcessEmitter.emit();
  }
  
  cancelContinueProcess(){
  	  this.cancelContinueProcessEmitter.emit();
  }
  
}


