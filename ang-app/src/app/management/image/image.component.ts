import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'image-root',
  templateUrl: './image.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class ImageComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
	
  ngOnInit() {
	  this.setInitializationServices(['image']);
	  this.crudService = this.imageService;
	  this.sucessErrorMessages = {
		  200:  'Imagem adicionada com sucesso.',
		  201:  'Imagem alterada com sucesso.',
		  204:  'Imagem excluída com sucesso.',
		  207:  'Imagem restaurada com sucesso.',
		  208:  'Imagem excluída [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Imagens';
	  this.addTitle = 'Adicionar Imagem';
	  this.editTitle = 'Editar Imagem';
	  this.dataForm = new FormGroup({
          link: new FormControl('', [Validators.required]),
          name: new FormControl('', [Validators.required])
      });
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.crudService.setForceDropOnDelete(this.logged.category == 'enroll');
	  this.parameterName = 'name/description';
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
  }
  
  getAdditionalConditions(): string{ 
	  return ' xoo ownerId = ' + this.logged.id + ' ' + super.getAdditionalConditions();
  } 
  
  showObject(id,modalId){
	  super.showObject(id,modalId);
	  this.setSelectedObjectLink();
  }
  
  deleteObject(id,modalId){
	  super.deleteObject(id,modalId);
	  this.setSelectedObjectLink();
  }
  
  unDeleteObject(id,modalId){
	  super.unDeleteObject(id,modalId);
	  this.setSelectedObjectLink();
  }
  
  setSelectedObjectLink(){
	  var elem: any = document.getElementById('selectedObjectLink');
  	  if(null == elem){
  		  setTimeout(() => {this.setSelectedObjectLink();},100);
  		  return;
  	  }
  	  elem.src = '';
	  if(this.emptyObject(this.selectedObject) 
	     || this.emptyString(this.selectedObject.link)){
		  return;
	  }
	  elem.src = this.selectedObject.link.trim();
  }
  
  setObject(image){
	  super.setObject(image);
	  this.dataForm.setValue({
	      link: image.link,
		  name: image.name
	  });
  }
  
  prepareToSaveUpdate(image){
	  return image;
  }
  
  makeSelectSearchedItemDestaked(image,destakSearch): Object{
	  image.name = this.makeDestak(image.name,destakSearch);
	  image.description = this.makeDestak(image.description,destakSearch);
	  return image;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('link')){
		  this.addValidationMessage('Link é requerido!');
	  }
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Identificação é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
  preValidateToSaveUpdate(image): boolean{
	  var link = image.link.trim().toLowerCase();
	  if(!(link.indexOf('https://') == 0)){
		  var msg = 'Link deve apontar para um endereço HTTPS, iniciando com: <strong>https://</strong>';
		  this.addValidationMessage(msg);
	  }
	  if(!(super.validateFileType(link,'image'))){
		  var msg = 'Link deve apontar para um arquivo do tipo Imagem: ';
		  msg += ' <strong>.png .jpg .jpeg .gif ou .bmp</strong>.';
	  	  this.addValidationMessage(msg);
	  }
	  return !this.inValidationMsgs();
  }
 
}
