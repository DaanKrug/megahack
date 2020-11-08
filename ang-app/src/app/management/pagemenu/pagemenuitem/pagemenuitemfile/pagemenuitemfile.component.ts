import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../../../base/basecrudfilter.component';

@Component({
  selector: 'pagemenuitemfile-root',
  templateUrl: './pagemenuitemfile.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class PageMenuItemFileComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

  selectedFile: any;
  files: any[];
  selectedPageMenuItem: any;
	
  ngOnInit() {
	  this.setInitializationServices(['pagemenuitemfile','pagemenu','file']);
	  this.crudService = this.pageMenuItemFileService;
	  this.selectedPageMenuItem = this.storageService.get()[0];
	  this.storageService.localStorageSetItem('_pageMenuItemId_' + this.getAppId(),
			                                  '' + this.selectedPageMenuItem.id,false);
	  this.sucessErrorMessages = {
		  200:  'Arquivo em Item Menu adicionado com sucesso.',
		  201:  'Arquivo em Item Menu alterado com sucesso.',
		  204:  'Arquivo em Item Menu excluído com sucesso.',
		  207:  'Arquivo em Item Menu restaurado com sucesso.',
		  208:  'Arquivo em Item Menu excluído [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Arquivos';
	  this.addTitle = 'Adicionar Arquivo em Item Menu';
	  this.editTitle = 'Editar Arquivo em Item Menu';
	  this.dataForm = new FormGroup({
          position: new FormControl('', [Validators.required])
      });
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'name';
	  this.loadFiles();
  }
  
  ngOnDestroy(){
      this.selectedFile = null;
      this.files = null;
      this.selectedPageMenuItem = null;
	  super.ngOnDestroy();
  }
  
  setSelectedFile(id){
	  this.selectedFile = this.getFromArrayById(this.files,id,null);
	  if(this.emptyObject(id) || !(id > 0) || !this.emptyObject(this.selectedFile)){
		  return;
	  }
	  this.fileService.load(id).then(file => {
		  if(this.processObjectAndValidationResult(file,true)){
			  this.files.unshift(file);
			  this.selectedFile = file;
		  }
	  });
  }
	 
  filterFiles(name){
	  if(this.preFilterByName(name)){
		  this.loadFiles();
	  }
  }
	  
  loadFiles(){
	  this.selectedFile = null;
	  this.fileService.getAll(1,5,this.getNameToFilterCondition('name')).then(files => {
		  this.files = this.clearRowZeroObjectsValidated(files);
		  if(this.files.length > 0){
			  this.setSelectedFile(this.files[0].id);
		  }
		  this.setProcessing(false);
	  });
  }
  
  infoFileContain(){
	  this.infoContainGeneric('o','e','Arquivos','Arquivo','arquivo','pela identificação');
  }
  
  getAdditionalConditions(): string{ 
  	  return ' xoo pageMenuItemId = ' + this.selectedPageMenuItem.id + ' ' + super.getAdditionalConditions();
  }
  
  setObject(menuitemfile){
	  super.setObject(menuitemfile);
	  this.dataForm.setValue({
			position: menuitemfile.position
	  });
	  this.selectedFile = null;
	  if(menuitemfile.id > 0){
		  this.setSelectedFile(menuitemfile.fileId);
	  }
  }
  
  prepareToSaveUpdate(menuitemfile){
	  menuitemfile.pageMenuItemId = this.selectedPageMenuItem.id;
	  menuitemfile.fileId = this.selectedFile.id;
	  return menuitemfile;
  }
  
  makeSelectSearchedItemDestaked(menuitemfile,destakSearch): Object{
	  menuitemfile.name = this.makeDestak(menuitemfile.name,destakSearch);
	  return menuitemfile;
  }
  
  validateFormFields(): Boolean{
	  if(this.emptyObject(this.selectedFile)){
		  this.addValidationMessage('Arquivo é requerido!');
	  }
	  if(this.errorRequired('position')){
		  this.addValidationMessage('Ordem Apresentação é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
  toPageMenuItems(){
	  this.pageMenuService.loadFromCache(this.selectedPageMenuItem.pageMenuId).then(pagemenu => {
		  if(this.processObjectAndValidationResult(pagemenu,true)){
			  this.storageService.localStorageRemoveItem('_pageMenuItemId_' + this.getAppId());
			  this.eventEmitterService.get('pagemenuitems').emit({object: pagemenu});
		  }
	  });
  }
  
}
