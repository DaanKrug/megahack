import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'home-root',
  templateUrl: './home.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class HomeComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
	
	ngOnInit(){
		this.setInitializationServices(['user']);
		this.crudService = this.userService;
		super.ngOnInit();
	}
	
	afterNgOnInit(){
		var content = this.storageService.get()[0];
		content = this.emptyString(content) ? '' : content;
		var elem: any = document.getElementById('contentText');
		elem.innerHTML = content;
		elem.style.display = content == '' ? 'none' : 'block';
	}
		
	ngOnDestroy(){
		super.ngOnDestroy();
	}
	
	listData(){}
	
}