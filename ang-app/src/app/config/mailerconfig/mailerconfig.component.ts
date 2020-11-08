import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'mailerconfig-root',
  templateUrl: './mailerconfig.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class MailerConfigComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
	
  additionalConditions: string;	
  providers: Object[];
  selectedUser: any;
	
  ngOnInit() {
	  this.setInitializationServices(['mailer']);
	  this.crudService = this.mailerConfigService;
	  this.adjustSelectedUser();
	  this.sucessErrorMessages = {
		  200:  'Configuração E-mail adicionada com sucesso.',
		  201:  'Configuração E-mail alterada com sucesso.',
		  204:  'Configuração E-mail excluída com sucesso.',
		  207:  'Configuração E-mail restaurada com sucesso.',
		  208:  'Configuração E-mail excluída [PERMANENTE] com sucesso.'
	  };
	  this.listTitle = 'Configurações E-mail';
	  this.addTitle = 'Adicionar Configuração E-mail';
	  this.editTitle = 'Editar Configuração E-mail';
	  this.formInfo = ['** Requerido para permitir acesso. Obrigatório na criação. Opcional para a alteração.',
	                   '*** Totalizados dentro do Limite Envio Mensal.'];
	  this.dataForm = new FormGroup({
          provider: new FormControl('', [Validators.required]),
          name: new FormControl('', [Validators.required]),
	      username: new FormControl('', [Validators.required]),
          password: new FormControl('', []),
          position: new FormControl('', [Validators.required]),
          perMonth: new FormControl('', [Validators.required]),
          perDay: new FormControl('', [Validators.required]),
          perHour: new FormControl('', [Validators.required]),
          perMinute: new FormControl('', [Validators.required]),
          perSecond: new FormControl('', [Validators.required]),
          replayTo: new FormControl('', [Validators.required])
      });
      this.providers = [
    	  {value: 'skallerten' , label: 'Skallerten'},
		  {value: 'gmail' , label: 'Gmail'},
		  {value: 'mailgun' , label: 'MailGun'},
		  {value: 'mailjet' , label: 'MailJet'},
		  {value: 'sendinblue' , label: 'SendinBlue'},
		  {value: 'sparkpost' , label: 'SparkPost'},
		  {value: 'postmark' , label: 'PostMark'},
		  {value: 'sendgrid' , label: 'SendGrid'},
		  //{value: 'mandrill' , label: 'Mandrill'},
		  //{value: 'sendpulse' , label: 'SendPulse'},
		  {value: 'smtp2go' , label: 'Smtp2Go'},
		  //{value: 'turbosmtp' , label: 'TurboSmtp'},
		  {value: 'elasticemail' , label: 'ElasticEmail'},
		  {value: 'iagente' , label: 'IAGente'},
		  {value: 'socketlab' , label: 'SocketLab'}
	  ];
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'name/username';
	  this.loadModules();
  }
  
  ngOnDestroy(){
	  this.additionalConditions = null;
	  this.providers = null;
	  this.selectedUser = null;
	  super.ngOnDestroy();
  }
  
  private adjustSelectedUser(){
	  if(this.getLogged().category != 'admin_master'){
		  this.selectedUser = this.getLogged();
		  this.additionalConditions = '';
		  return;
	  }
	  this.selectedUser = this.storageService.get()[0];
	  this.additionalConditions = ' xoo userId = ' + this.selectedUser.id;
	  if(this.selectedUser.category == 'admin_master'){
		  this.additionalConditions += ' xoo ownerId = ' + this.selectedUser.id;
	  }
  }
  
  getAdditionalConditions(): string{ 
	  return super.getAdditionalConditions() + this.additionalConditions;
  }
  
  setObject(mailerconfig){
	  super.setObject(mailerconfig);
	  this.dataForm.setValue({
			provider: mailerconfig.provider,
			name: mailerconfig.name,
			username: mailerconfig.username,
			password: null,
			position: mailerconfig.position,
			perMonth: mailerconfig.perMonth,
	        perDay: mailerconfig.perDay,
	        perHour: mailerconfig.perHour,
	        perMinute: mailerconfig.perMinute,
	        perSecond: mailerconfig.perSecond,
	        replayTo: mailerconfig.replayTo
	  });
  }
 
  makeSelectSearchedItemDestaked(mailerconfig,destakSearch): Object{
	  mailerconfig.name = this.makeDestak(mailerconfig.name,destakSearch);
	  mailerconfig.username = this.makeDestak(mailerconfig.username,destakSearch);
	  return mailerconfig;
  }
  
  prepareToSaveUpdate(mailerconfig){
	  mailerconfig.userId = this.selectedUser.id;
	  return mailerconfig;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Identificação é requerida!');
	  }
	  if(this.errorRequired('provider')){
		  this.addValidationMessage('Provedor é requerido!');
	  }
	  if(this.errorRequired('perMonth')){
		  this.addValidationMessage('Limite Envio Mensal é requerido!');
	  }
	  if(this.errorRequired('perDay')){
		  this.addValidationMessage('Limite Envio Diário é requerido!');
	  }
	  if(this.errorRequired('perHour')){
		  this.addValidationMessage('Limite Envio por Hora é requerido!');
	  }
	  if(this.errorRequired('perMinute')){
		  this.addValidationMessage('Limite Envio por Minuto é requerido!');
	  }
	  if(this.errorRequired('perSecond')){
		  this.addValidationMessage('Limite Envio por Segundo é requerido!');
	  }
	  if(this.errorRequired('username')){
		  this.addValidationMessage('Login/Endereço de E-mail é requerido!');
	  }
	  if(this.errorRequired('replayTo')){
		  this.addValidationMessage('Replay-To é requerido!');
	  }
	  if(this.errorRequired('position')){
		  this.addValidationMessage('Ordem Utilização é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
  preValidateToSaveUpdate(mailerconfig): boolean{
	  if(parseInt(mailerconfig.perDay) > parseInt(mailerconfig.perMonth)){
		  this.addValidationMessage('Limite Envio Mensal deve ser maior que Limite Envio Diário!');
	  }
	  return !this.inValidationMsgs();
  }
  
  backToUsers(){
	  if(this.getLogged().category == 'admin_master'){
		  this.storageService.clear();
		  this.eventEmitterService.get('users').emit({});
	  }
  }
  
}
