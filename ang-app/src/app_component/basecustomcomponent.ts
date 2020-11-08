import { EventEmitter, Input, Output, OnInit, OnDestroy }  from '@angular/core';

export class BaseCustomComponent implements OnInit, OnDestroy{
	
	fitMode: boolean;
	@Input() helpMessage: string;
	@Output() helpEmitter = new EventEmitter<string>();
	
	constructor() {
		this.fitMode = window.innerWidth < 350;
	}
	
	ngOnInit(){}
	  
	ngOnDestroy(){
	    this.helpMessage = null;
	    this.helpEmitter = null;
	    this.fitMode = null;
	}
	
	help(){
		this.helpEmitter.emit(this.helpMessage);
	}
	
}