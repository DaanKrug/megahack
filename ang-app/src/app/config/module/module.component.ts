import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'module-root',
  templateUrl: './module.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class ModuleComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

  modules: Object[];
	
  ngOnInit() {
	  this.setInitializationServices(['module']);
	  this.crudService = this.moduleService;
	  this.sucessErrorMessages = {
		  200:  'Módulo adicionado com sucesso.',
		  201:  'Módulo alterado com sucesso.',
		  2010: 'Módulo inativado com sucesso.',
		  2011: 'Módulo ativado com sucesso.',
		  204:  'Módulo excluído com sucesso.',
		  207:  'Módulo restaurado com sucesso.',
		  208:  'Módulo excluído [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Módulos';
	  this.addTitle = 'Adicionar Módulo';
	  this.editTitle = 'Editar Módulo';
	  this.dataForm = new FormGroup({
          name: new FormControl('', [Validators.required])
      });
      this.modules = [
	      {value: 'file' , label: 'Arquivos'},
	      {value: 's3upload' , label: 'AWS S3 Upload'},
	      {value: 'slider' , label: 'Carrossel de Imagens'},
	      {value: 'image' , label: 'Imagens'},
		  {value: 'register' , label: 'Registro de Usuários'}
	  ];
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'name';
  }
  
  ngOnDestroy(){
      this.modules = null;
	  super.ngOnDestroy();
  }
  
  setObject(module){
	  super.setObject(module);
	  this.dataForm.setValue({
	      name: module.name
	  });
  }
 
  makeSelectSearchedItemDestaked(module,destakSearch): Object{
	  module.name = this.makeDestak(module.name,destakSearch);
	  return module;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Identificação é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
  callbackAfterCreate(object){
      this.listDataNoCache();
      this.eventEmitterService.get('loadModules').emit({});
  }
  
  callbackAfterUpdate(object){
      this.listDataNoCache();
      this.eventEmitterService.get('loadModules').emit({});
  }
 
}






