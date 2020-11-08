import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../../base/basecrudfilter.component';

@Component({
  selector: 'pagemenuitem-root',
  templateUrl: './pagemenuitem.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class PageMenuItemComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

  selectedPageMenu: any;
  tabObjects: Object[];
	
  ngOnInit() {
	  this.setInitializationServices(['pagemenuitem']);
	  this.crudService = this.pageMenuItemService;
	  this.selectedPageMenu = this.storageService.get()[0];
	  this.storageService.localStorageSetItem('_pageMenuId_' + this.getAppId(),'' + this.selectedPageMenu.id,false);
	  this.sucessErrorMessages = {
		  200:  'Item Menu adicionado com sucesso.',
		  201:  'Item Menu alterado com sucesso.',
		  2010: 'Item Menu inativado com sucesso.',
		  2011: 'Item Menu ativado com sucesso.',
		  204:  'Item Menu excluído com sucesso.',
		  207:  'Item Menu restaurado com sucesso.',
		  208:  'Item Menu excluído [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Itens Menu';
	  this.addTitle = 'Adicionar Item Menu';
	  this.editTitle = 'Editar Item Menu';
	  this.dataForm = new FormGroup({
          name: new FormControl('', [Validators.required]),
          content: new FormControl('', [Validators.required]),
          position: new FormControl('', [Validators.required])
      });
	  this.tabObjects = [
		  {value: '0', label: 'Dados Gerais (*)', title: 'Dados Gerais'},
	      {value: '1', label: 'Conteúdo (*)', title: 'Conteúdo'}
	  ];
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'name';
  }
  
  ngOnDestroy(){
      this.selectedPageMenu = null;
      this.tabObjects = null;
	  super.ngOnDestroy();
  }
  
  getAdditionalConditions(): string{ 
  	  return ' xoo pageMenuId = ' + this.selectedPageMenu.id + ' ' + super.getAdditionalConditions();
  }
  
  setObject(pagemenuitem){
	  super.setObject(pagemenuitem);
	  this.dataForm.setValue({
	      name: pagemenuitem.name,
		  content: pagemenuitem.content,
		  position: pagemenuitem.position
	  });
  }
  
  prepareToSaveUpdate(pagemenuitem){
	  pagemenuitem.pageMenuId = this.selectedPageMenu.id;
	  pagemenuitem.content = this.stringService.unentityLtGt(pagemenuitem.content);
	  return pagemenuitem;
  }
  
  makeSelectSearchedItemDestaked(pagemenuitem,destakSearch): Object{
	  pagemenuitem.name = this.makeDestak(pagemenuitem.name,destakSearch);
	  return pagemenuitem;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Identificação é requerida!');
	  }
	  if(this.errorRequired('content')){
		  this.addValidationMessage('Conteúdo é requerido!');
	  }
	  if(this.errorRequired('position')){
		  this.addValidationMessage('Ordem Apresentação é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
  patchValue(target,value){
	  if(target == 'name'){
		  this.dataForm.patchValue({name: value});
	  }
	  if(target == 'content'){
		  this.dataForm.patchValue({content: value});
	  }
	  if(target == 'position'){
		  this.dataForm.patchValue({position: value});
	  }
	  super.patchValue(target,value);
  }
  
  toPageMenus(){
  	  this.storageService.localStorageRemoveItem('_pageMenuId_' + this.getAppId());
      this.eventEmitterService.get('pagemenus').emit({});
  }
  
  toPageMenuItemFiles(id){
	  this.crudService.loadFromCache(id).then(pageMenuItem => {
		  if(this.processObjectAndValidationResult(pageMenuItem,true)){
			  this.eventEmitterService.get('pagemenuitemfiles').emit({object: pageMenuItem});
		  }
	  });
  }
  
}
