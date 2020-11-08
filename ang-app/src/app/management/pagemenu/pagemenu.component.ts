import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'pagemenu-root',
  templateUrl: './pagemenu.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class PageMenuComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
	
  ngOnInit() {
	  this.setInitializationServices(['pagemenu']);
	  this.crudService = this.pageMenuService;
	  this.sucessErrorMessages = {
		  200:  'Menu adicionado com sucesso.',
		  201:  'Menu alterado com sucesso.',
		  2010: 'Menu inativado com sucesso.',
		  2011: 'Menu ativado com sucesso.',
		  204:  'Menu excluído com sucesso.',
		  207:  'Menu restaurado com sucesso.',
		  208:  'Menu excluído [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Menus';
	  this.addTitle = 'Adicionar Menu';
	  this.editTitle = 'Editar Menu';
	  this.dataForm = new FormGroup({
          name: new FormControl('', [Validators.required]),
          position: new FormControl('', [Validators.required])
      });
      super.ngOnInit();
      this.loadModules();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'name/appointmentPageName';
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
  }
  
  setObject(menu){
	  super.setObject(menu);
	  this.dataForm.setValue({
		  name: menu.name,
		  position: menu.position
	  });
  }
   
  makeSelectSearchedItemDestaked(menu,destakSearch): Object{
	  menu.name = this.makeDestak(menu.name,destakSearch);
	  return menu;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Identificação é requerida!');
	  }
	  if(this.errorRequired('position')){
		  this.addValidationMessage('Ordem Apresentação é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
  toMenuItems(id){
	  this.crudService.loadFromCache(id).then(pageMenu => {
		  if(this.processObjectAndValidationResult(pageMenu,true)){
			  this.eventEmitterService.get('pagemenuitems').emit({object: pageMenu});
		  }
	  });
  }
  
}
