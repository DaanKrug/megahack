import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'user-root',
  templateUrl: './user.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class UserComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
	
  passwordValidationMessage: any;
  categories: Object[];
  disponiblePermissions: any[];
  permissionsAuditor: any[];
  permissionsAdmin: any[];
  permissionsEnroll: any[];
  permissionsExternal: any[];
  selectedPermissions: string[];
  additionalUserInfo: any;


  ngOnInit() {
	  this.setInitializationServices(['user','additionaluserinfo']);
	  this.crudService = this.userService;
	  this.sucessErrorMessages = {
		  200:  'Paciente/Profissional da saúde adicionado com sucesso.',
		  201:  'Paciente/Profissional da saúde alterado com sucesso.',
		  2010: 'Paciente/Profissional da saúde inativado com sucesso.',
		  2011: 'Paciente/Profissional da saúde ativado com sucesso.',
		  204:  'Paciente/Profissional da saúde excluído com sucesso.',
		  207:  'Paciente/Profissional da saúde restaurado com sucesso.',
		  208:  'Paciente/Profissional da saúde excluído [PERMANENTE] com sucesso.',
		  520:  'Falha ao criar informações complementares.',
		  521:  'Falha ao alterar informações complementares.',
	  };
	  this.dataForm = new FormGroup({
          name: new FormControl('', [Validators.required]),
          email: new FormControl('', [Validators.required,Validators.email]),
          password: new FormControl('', []),
          category: new FormControl('', [Validators.required]),
          a1_rg: new FormControl('', []),
		  a2_cpf: new FormControl('', []),
		  a3_cns: new FormControl('', []),
		  a4_phone: new FormControl('', []),
		  a5_address: new FormControl('', []),
		  a6_otherinfo: new FormControl('', []),
      });
      this.categories = [
      	  {value: 'enroll' , label: 'Paciente'},
      	  {value: 'admin' , label: 'Profissional da Saúde'},
      	  {value: 'system_auditor', label: 'Auditor do Sistema'},
      ];
      this.permissionsAuditor = [
          {value: 'mailerconfig' , label: 'Configuração Envio E-mail', dependOf: null, breakBefore: false},
          {value: 'file' , label: 'Arquivo', dependOf: null, breakBefore: false},
          {value: 'image' , label: 'Imagem', dependOf: null, breakBefore: false},
          {value: 'simplemail' , label: 'Envio E-mail', dependOf: null, breakBefore: false},
          {value: 'user' , label: 'Pacientes/Profissionais da Saúde', dependOf: null, breakBefore: true},
          {value: 'cancerdiagnostic' , label: 'Diagnósticos de Câncer', dependOf: null, breakBefore: true}
          
	  ];
	  this.permissionsAdmin = this.permissionsAuditor;
	  this.permissionsExternal = [
	      {value: 'simplemail' , label: 'Envio E-mail', dependOf: null, breakBefore: false}
	  ];
	  this.permissionsEnroll = [];
      super.ngOnInit();
      this.listTitle = 'Pacientes/Profissionais da saúde';
	  this.addTitle = this.fitMode ? 'Adicionar Pac./Prof. da saúde' : 'Adicionar Paciente/Profissional da saúde';
	  this.editTitle = this.fitMode ? 'Editar Pac./Prof. da saúde' : 'Editar Paciente/Profissional da saúde';
	  this.formInfo = ['** Requerido para criar paciente/profissional da saúde. Em branco mantém o valor atual.'];
  }
  
  afterNgOnInit(){
	  this.parameterName = 'name/email';
  }
  
  ngOnDestroy(){
	  this.passwordValidationMessage = null;
	  this.categories = null;
	  this.disponiblePermissions = null;
	  this.permissionsAuditor = null;
	  this.permissionsAdmin = null;
	  this.permissionsEnroll = null;
	  this.permissionsExternal = null;
	  this.selectedPermissions = null;
	  this.additionalUserInfo = null;
	  super.ngOnDestroy();
  }
  
  getAdditionalConditions(): string{ 
	  var conditions = ' xoo id <> ' + this.logged.id;
	  conditions += ' and category <> quaspaadmin_masterquaspa ';
	  conditions += super.getAdditionalConditions();
	  return conditions;
  }
  
  setTab(tab){
  	  super.setTab(tab);
  	  if(tab == 1){
  	      this.adjustPermissions(this.dataForm.value.category);
  	  }
  }
  
  setObject(user){
	  super.setObject(user);
	  this.dataForm.setValue({
			name: user.name,
			email: user.email,
			password: null,
			category: user.category,
			a1_rg: null,
			a2_cpf: null,
			a3_cns: null,
			a4_phone: null,
			a5_address: null,
			a6_otherinfo: null
	  });
	  this.adjustPermissions(user.category);
	  this.loadAndPatchAddtionalInfo(user);
  }
  
  loadAndPatchAddtionalInfo(user){
	  this.additionalUserInfo = null;
	  if(this.emptyObject(user) || !(user.id > 0)){
		  return;
	  }
	  this.additionaluserinfoService.invalidateCache();
	  var conditions = ' xoo a7_userid = ' + user.id;
	  this.additionaluserinfoService.getAll(-1,-1,conditions).then(additionalUserInfos => {
		  additionalUserInfos = this.clearRowZeroObjectsValidated(additionalUserInfos);
		  if(this.emptyArray(additionalUserInfos)){
			  return;
		  }
		  this.additionalUserInfo = additionalUserInfos[0];
		  this.patchValue('a1_rg',this.additionalUserInfo.a1_rg);
		  this.patchValue('a2_cpf',this.additionalUserInfo.a2_cpf);
		  this.patchValue('a3_cns',this.additionalUserInfo.a3_cns);
		  this.patchValue('a4_phone',this.additionalUserInfo.a4_phone);
		  this.patchValue('a5_address',this.additionalUserInfo.a5_address);
		  this.patchValue('a6_otherinfo',this.additionalUserInfo.a6_otherinfo);
	  });
  }
  
  adjustPermissions(category){
      this.selectedPermissions = [];
      this.disponiblePermissions = null;
      if(this.emptyString(category)){
          return;
      }
      this.disponiblePermissions = this.permissionsEnroll;
      if(category == 'system_auditor'){
      	  this.disponiblePermissions = this.permissionsAuditor;
      }
      if(category == 'admin'){
      	  this.disponiblePermissions = this.permissionsAdmin;
      }
      if(category == 'external'){
      	  this.disponiblePermissions = this.permissionsExternal;
      }
	  if(null!=this.selectedObject.id && this.selectedObject.id > 0){
	      var userPermissions = this.selectedObject.permissions.split(",");
	      var size = userPermissions.length;
	      var size2 = this.disponiblePermissions.length;
	      for(var i = 0; i < size; i++){
	          for(var j = 0; j < size2; j++){
	              if(userPermissions[i] == this.disponiblePermissions[j].value 
	            		  || userPermissions[i] == this.disponiblePermissions[j].value + '_write'){
	              	  this.selectedPermissions = [...this.selectedPermissions,userPermissions[i]];
	              	  break;
	              }
	      	  }
	      }
	  }
  }
  
  checkPermission(permission){
  	  if(!(this.selectedPermissions.includes(permission))){
  	      this.selectedPermissions.unshift(permission);
  	  }
  }
  
  uncheckPermission(permission){
  	  this.selectedPermissions = this.removeFromArray(this.selectedPermissions,permission);
  	  if(permission == 'blogarticle'){
  	      this.uncheckPermission('blogarticlecomment');
  	  }
  	  if(permission == 'pagemenu'){
  	      this.uncheckPermission('pagemenuitem');
  	  }
  	  if(permission == 'pagemenuitem'){
  	  	  this.uncheckPermission('pagemenuitemfile');
  	  }
  	  if(permission == 'user'){
  	  	  this.uncheckPermission('userpaymentticket');
  	  }
  	  if(permission.indexOf('_write') == -1){
  	  	  this.uncheckPermission(permission + '_write');
  	  }
  }
  
  makeSelectSearchedItemDestaked(user,destakSearch): Object{
	  user.name = this.makeDestak(user.name,destakSearch);
	  user.email = this.makeDestak(user.email,destakSearch);
	  return user;
  }
  
  prepareToSaveUpdate(user){
      user.permissions = this.selectedPermissions.join(",");
	  return user;
  }
  
  callbackAfterCreate(user){
	  this.saveOrUpdateAditionalInfo(user);
  }
  
  callbackAfterUpdate(user){
	  this.saveOrUpdateAditionalInfo(user);
  }
  
  private prepareToSaveUpdateAditionalInfo(user){
	  var newAdditionalInfo: any = this.additionaluserinfoService.getEmptyObject(null);
	  if(this.emptyObject(this.additionalUserInfo)){
		  this.additionalUserInfo = newAdditionalInfo;
	  }
      this.additionalUserInfo.a1_rg = user.a1_rg;
      this.additionalUserInfo.a2_cpf = user.a2_cpf;
      this.additionalUserInfo.a3_cns = user.a3_cns;
      this.additionalUserInfo.a4_phone = user.a4_phone;
      this.additionalUserInfo.a5_address = user.a5_address;
      this.additionalUserInfo.a6_otherinfo = user.a6_otherinfo;
      this.additionalUserInfo.email = user.email;
      this.additionalUserInfo.a7_userid = user.id;
      this.additionalUserInfo._token = newAdditionalInfo._token;
      this.additionalUserInfo.ownerId = newAdditionalInfo.ownerId;
  }
  
  private saveOrUpdateAditionalInfo(user){
	  this.prepareToSaveUpdateAditionalInfo(user);
	  if(this.additionalUserInfo.id > 0){
		  this.additionaluserinfoService.update(this.additionalUserInfo.id,this.additionalUserInfo)
			          					.then(result => {
			  this.additionalUserInfo = null;
			  if(result.code != 201){
				  this.setStatusCode(521);
				  this.clearMessages(3000);
			  }
			  this.setProcessing(false);
		  });
		  return;
	  }
	  this.additionaluserinfoService.create(this.additionalUserInfo).then(result => {
		  this.additionalUserInfo = null;
		  if(result.code != 200){
			  this.setStatusCode(520);
			  this.clearMessages(3000);
		  }
		  this.setProcessing(false);
	  });
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Nome é requerido!');
	  }
	  if(this.errorRequired('category')){
		  this.addValidationMessage('Categoria/Permissão é requerida!');
	  }
	  if(this.errorRequired('email')){
		  this.addValidationMessage('E-mail é requerido!');
	  }
	  if(this.errorEmail('email')){
		  this.addValidationMessage('E-mail deve ser um endereço de email válido!');
	  }
	  return !this.inValidationMsgs();
  }
  
  validatePasswordForce(password){
	  this.validationMessages = null;
	  this.processValidation = false;
	  this.passwordValidationMessage = null;
	  if(this.emptyString(password)){
		  return;
	  }
	  var validation = this.stringService.validatePassword(password,true);
	  if(validation.code == 200){
		  this.passwordValidationMessage = validation;
		  return;
	  }
	  this.processValidation = true;
	  this.addValidationMessage(validation.msg);
  }
  
  preValidateToSaveUpdate(user): boolean{
	  this.passwordValidationMessage = null;
	  if(this.emptyString(user.email)){
		  this.addValidationMessage('E-mail é requerido!');
	  }
	  if(!(this.stringService.validateEmail(user.email))){
	      this.addValidationMessage('E-mail deve ser um endereço de email válido!');
	  }
	  if(!this.emptyString(user.a3_cns) && user.a3_cns.trim().length != 15){
		  this.addValidationMessage('C.N.S. deve ter 15 números para ser válido!');
	  }
	  if(!this.emptyString(user.a3_cns) && user.a3_cns.trim().charAt(0) == '0'){
		  this.addValidationMessage('C.N.S. não pode iniciar com 0!');
	  }
	  if(!this.emptyString(user.a2_cpf) && user.a2_cpf.trim().length != 11){
		  this.addValidationMessage('C.P.F. deve ter 11 números para ser válido!');
	  }
	  if(!this.emptyString(user.password)){
		  var validation = this.stringService.validatePassword(user.password,false);
		  if(validation.code == 977 && !(this.idObjectEdit > 0)){
			  this.addValidationMessage(validation.msg);
		  }
		  if(validation.code != 200 && validation.code != 977){
			  this.addValidationMessage(validation.msg);
		  }
	  }
	  return !this.inValidationMsgs();
  }
    
  patchValue(target,value){
	  super.patchValue(target,value);
 	  if(target == 'a1_rg'){
		  this.dataForm.patchValue({a1_rg: value});
	  }
	  if(target == 'a2_cpf'){
		  this.dataForm.patchValue({a2_cpf: value});
	  }
	  if(target == 'a3_cns'){
		  this.dataForm.patchValue({a3_cns: value});
	  }
	  if(target == 'a4_phone'){
		  this.dataForm.patchValue({a4_phone: value});
	  }
	  if(target == 'a5_address'){
		  this.dataForm.patchValue({a5_address: value});
	  }
	  if(target == 'a6_otherinfo'){
		  this.dataForm.patchValue({a6_otherinfo: value});
	  }
  } 
  
}
