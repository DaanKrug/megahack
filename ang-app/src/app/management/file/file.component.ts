import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'file-root',
  templateUrl: './file.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class FileComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
	
  inUpload: boolean;
  fileData: File;
  fileTarget: any;
  base64: string;
	
  ngOnInit() {
	  this.setInitializationServices(['file','module']);
	  this.crudService = this.fileService;
	  this.sucessErrorMessages = {
		  200:  'Arquivo adicionado com sucesso.',
		  201:  'Arquivo alterado com sucesso.',
		  204:  'Arquivo excluído com sucesso.',
		  207:  'Arquivo restaurado com sucesso.',
		  208:  'Arquivo excluído [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Arquivos';
	  this.addTitle = 'Adicionar Arquivo';
	  this.editTitle = 'Editar Arquivo';
	  this.formInfo = ['** Tipo Arquivos aceitos: .png .jpeg .jpg .gif .bmp .pdf .doc .docx .xls .xlsx .ppt .pptx',
	                   '*** Tamanho máximo: 2MB.'];
	  this.dataForm = new FormGroup({
          link: new FormControl('', [Validators.required]),
          name: new FormControl('', [Validators.required])
      });
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.crudService.setForceDropOnDelete(this.logged.category == 'enroll');
	  this.parameterName = 'name';
	  this.loadModules();
  }
  
  ngOnDestroy(){
      this.inUpload = null;
	  this.fileData = null;
	  this.fileTarget = null;
	  this.base64 = null;
	  super.ngOnDestroy();
  }
  
  setObject(file){
	  super.setObject(file);
	  this.dataForm.setValue({
	      link: file.link,
		  name: file.name
	  });
  }
  
  listData(){
	  this.inUpload = false;
	  super.listData();
  }
  
  listDataNoCache(){
	  this.inUpload = false;
	  super.listDataNoCache();
  }
  
  addObject(){
	  super.addObject();
	  this.inUpload = this.modulesNames.includes('s3upload');
  }
  
  makeSelectSearchedItemDestaked(file,destakSearch): Object{
	  file.name = this.makeDestak(file.name,destakSearch);
	  return file;
  }
  
  validateFormFields(): Boolean{
	  if(!this.inUpload && this.errorRequired('link')){
		  this.addValidationMessage('Link é requerido!');
	  }
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Identificação é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
  preValidateToSaveUpdate(file): boolean{
	  if(!(file.link.trim().toLowerCase().indexOf('https://') == 0)){
		  this.addValidationMessage('Link deve apontar para um endereço HTTPS, iniciando com: <strong>https://</strong>');
	  }
	  return !this.inValidationMsgs();
  }
  
  cancelUpload(){
	  this.fileData = null;
  }
  
  setToUpload(event: any) {
      this.validationMessages = [];
      this.processValidation = true;
      this.fileData = null;
      this.base64 = null;
      if (event.target.files && event.target.files.length > 0) {
		  this.fileData = <File>event.target.files[0];
		  if(this.fileData.size > ((2 * 1024 * 1024) + 50)){
		      this.addValidationMessage('Arquivo maior que 2 MB.');
		  	  return;
		  }
		  this.fileTarget = event.target;
		  var reader = new FileReader();
	      reader.onload = () => { 
	      	  this.validateBase64(reader.result);
	      };
	      reader.readAsArrayBuffer(event.target.files[0]);
	  }
  }
  
  validateBase64(arrayBuffer){
      if(!this.validateFileContentBase64(this.fileData.type,arrayBuffer)){
	  	  this.fileData = null;
      	  this.base64 = null;
      	  this.addValidationMessage('Conteúdo do arquivo não condiz com a extensão.');
      	  return;
	  }
	  this.processValidation = false;
	  var reader = new FileReader();
	  reader.onload = () => { 
      	  this.base64 = '' + reader.result; 
      };
	  reader.readAsDataURL(this.fileData);
  }
  
  uploadSubmit(){
	  this.validationMessages = [];
	  this.processValidation = true;
	  if(null==this.fileData){
		  this.addValidationMessage('É preciso selecionar um arquivo.');
		  return;
	  }
	  if(!(this.validateFile(this.fileData,2)) || !(this.validateFormFields())){
		  return;
	  }
	  this.processValidation = false;
	  this.setProcessing(true);
	  this.fileService.s3upload(this.base64,this.fileData.name,this.dataForm.value.name).then(result => {
		  this.setProcessing(false);
		  this.clearForm();
		  if(this.processObjectAndValidationResult(result,true)){
	          this.addObject();
	          this.fileService.invalidateCache();
		  }
		  this.clearMessages(1000);
	  });
  }
 
}
