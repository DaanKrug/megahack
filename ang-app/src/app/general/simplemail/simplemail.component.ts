import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'simplemail-root',
  templateUrl: './simplemail.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class SimpleMailComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

  status: Object[];
	
  ngOnInit() {
	  this.setInitializationServices(['simplemail']);
      this.crudService = this.simpleMailService;
	  this.sucessErrorMessages = {
		  200:  'E-mail adicionado à fila de envio com sucesso.<br/>Será enviado assim que possível.',
		  201:  'E-mail alterado com sucesso.',
		  204:  'E-mail excluído com sucesso.',
		  207:  'E-mail restaurado com sucesso.',
		  208:  'E-mail excluído [PERMANENTE] com sucesso.'
	  };
	  this.listTitle = 'E-mails';
	  this.addTitle = 'Adicionar E-mail para Envio';
	  this.editTitle = 'Editar E-mail';
	  this.dataForm = new FormGroup({
		  subject: new FormControl('', [Validators.required]),
		  content: new FormControl('', [Validators.required]),
		  tosAddress: new FormControl('', [Validators.required])
      });
      this.status = [
		  {value: 'awaiting' , label: 'Aguardando Processamento'},
		  {value: 'reSend' , label: 'Solicitado Re-envio'},
		  {value: 'startProcessing' , label: 'Processando Envio(s)'},
		  {value: 'processing' , label: 'Processando Envio(s)'},
		  {value: 'finished' , label: 'Envio(s) Finalizado(s)'}
	  ];
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'subject/tosAddress';
  }
  
  ngOnDestroy(){
      this.status = null;
	  super.ngOnDestroy();
  }
  
  showObject(id,modalId){
	  super.showObject(id,modalId);
	  this.setSelectedObjectValues();
  }
  
  deleteObject(id,modalId){
	  super.deleteObject(id,modalId);
	  this.setSelectedObjectValues();
  }
  
  unDeleteObject(id,modalId){
	  super.unDeleteObject(id,modalId);
	  this.setSelectedObjectValues();
  }
  
  setSelectedObjectValues(){
	  var elem: any = document.getElementById('contentText');
  	  if(null == elem){
  		  setTimeout(() => {this.setSelectedObjectValues();},100);
  		  return;
  	  }
  	  if(this.emptyObject(this.selectedObject)){
  		  return;
  	  }
  	  var elem1: any = document.getElementById('failMessagesText');
	  if(!this.emptyString(this.selectedObject.content)){
		  elem.innerHTML = this.selectedObject.content.trim();
	  }
	  if(!this.emptyString(this.selectedObject.failMessages)){
		  elem1.innerHTML = this.selectedObject.failMessages.trim();
	  }
  }
  
  setObject(simplemail){
	  super.setObject(simplemail);
	  this.dataForm.setValue({
		  subject: simplemail.subject,
		  content: simplemail.content,
		  tosAddress: simplemail.tosAddress
	  });
  }
  
  prepareData(simplemail){
	  if(simplemail.alreadyPrepared){
		  return simplemail;
	  }
	  simplemail.updated_at = this.emptyString(simplemail.updated_at) 
	                        ? '----/----/-------- ----:----:----' 
	                        : this.dateService.dateBrWhitTime(this.dateService.dateSqltoDate(simplemail.updated_at));
	  simplemail.alreadyPrepared = true;
	  return simplemail;
  }
  
  prepareToSaveUpdate(simplemail){
	  simplemail.content = this.stringService.unentityLtGt(simplemail.content);
	  return simplemail;
  }
  
  makeSelectSearchedItemDestaked(simplemail,destakSearch): Object{
	  simplemail.subject = this.makeDestak(simplemail.subject,destakSearch);
	  simplemail.tosAddress = this.makeDestak(simplemail.tosAddress,destakSearch);
	  return simplemail;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('tosAddress')){
		  this.addValidationMessage('Destinatário(s) é requerido!');
	  }
	  if(this.errorRequired('subject')){
		  this.addValidationMessage('Assunto é requerido!');
	  }
	  if(this.errorRequired('content')){
		  this.addValidationMessage('Conteúdo Mensagem é requerido!');
	  }
	  return !this.inValidationMsgs();
  }
  
  preValidateToDelete(simplemail){
  	  if(simplemail.successTotal > 0){
  	      this.addValidationStatusMessage(403,'E-mail já foi recebido por um dos destinatários, não é possível excluir.');
  	      return false;
  	  }
	  if(!(['awaiting','finished','reSend'].includes(simplemail.status))){
	  	  this.addValidationStatusMessage(403,'E-mail está em processamento, não é possível excluir.');
  	      return false;
	  }
	  return true;
  }
  
  reSend(id,modalId){
	  this.validationMessages = null;
	  this.simpleMailService.loadFromCache(id).then(simpleMail => {
		  if(!this.processObjectAndValidationResult(simpleMail,true)){
			  return;
		  }
		  if(simpleMail.status != 'finished'){
			  this.addValidationMessage('E-mail ainda em processamento. Aguarde a finalização para tentar o re-envio.');
			  return;
		  }
		  this.selectedObject = simpleMail;
		  this.continueProcessOpenMessage(modalId);
	  });
  }
  
  cancelProcess(){
	  this.cancelReSend();
  }
  
  continueProcess(){
	  this.confirmReSend();
  }
  
  cancelReSend(){
	  this.formModal.close();
	  this.canceling = false;
	  this.setSelectedObject(null);
  }
  
  confirmReSend(){
	  if(null!=this.formModal){
		  this.formModal.close();
	  }
      if(this.canceling){
	      this.canceling = false;
	      this.setSelectedObject(null);
	      return;
	  }
      var id = this.selectedObject.id;
      this.setSelectedObject(null);
      this.setProcessing(true);
      this.simpleMailService.load(id).then(simpleMail => {
		  if(!this.processObjectAndValidationResult(simpleMail,true)){
			  this.setProcessing(false);
			  return;
		  }
		  simpleMail = this.prepareData(simpleMail);
		  var oldStatus = simpleMail.status;
		  simpleMail.status = 'reSend';
		  simpleMail.ownerId = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
		  simpleMail._token = this.storageService.localStorageGetItem('_token_' + this.getAppId());
		  this.simpleMailService.update(id,simpleMail).then(result => {
			  this.setProcessing(false);
			  if(!this.processObjectAndValidationResult(result,true)){
				  simpleMail.status = oldStatus;
				  return;
			  }
			  simpleMail.failTotal = 0;
			  simpleMail.failAddress = '';
		  });
	  });
  }
  
}