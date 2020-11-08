import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'applog-root',
  templateUrl: './applog.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class AppLogComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
	
  counter: number;

  ngOnInit() {
	  this.setInitializationServices(['applog']); 
	  this.crudService = this.appLogService;
	  this.listTitle = 'Logs';
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'userName/userEmail/operation/objTitle/ffrom/tto';
  }
  
  ngOnDestroy(){
	  this.counter = null;
	  super.ngOnDestroy();
  }
  
  makeSelectSearchedItemDestaked(applog,destakSearch): Object{
	  applog.userName = this.makeDestak(applog.userName,destakSearch);
	  applog.userEmail = this.makeDestak(applog.userEmail,destakSearch);
	  applog.operation = this.makeDestak(applog.operation,destakSearch);
	  applog.objTitle = this.makeDestak(applog.objTitle,destakSearch);
	  applog.ffrom = this.makeDestak(applog.ffrom,destakSearch);
	  applog.tto = this.makeDestak(applog.tto,destakSearch);
	  return applog;
  }
  
}
