import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 'appconfig-root',
  templateUrl: './appconfig.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class AppConfigComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

  ngOnInit() {
	  this.setInitializationServices(['appconfig']);
	  this.crudService = this.appConfigService;
	  this.sucessErrorMessages = {
		  200:  'Configuração Aplicação adicionada com sucesso.',
		  201:  'Configuração Aplicação alterada com sucesso.',
		  2010: 'Configuração Aplicação inativada com sucesso.',
		  2011: 'Configuração Aplicação ativada com sucesso.',
		  204:  'Configuração Aplicação excluída com sucesso.',
		  207:  'Configuração Aplicação restaurada com sucesso.',
		  208:  'Configuração Aplicação excluída [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Configurações';
	  this.addTitle = 'Adicionar Configuração Aplicação';
	  this.editTitle = 'Editar Configuração Aplicação';
	  this.dataForm = new FormGroup({
          name: new FormControl('', [Validators.required]),
          description:  new FormControl('', [Validators.required]),
          site:  new FormControl('', [Validators.required]),
          usePricingPolicy:  new FormControl('', []),
          pricingPolicy:  new FormControl('', []),
          usePrivacityPolicy:  new FormControl('', []),
          privacityPolicy:  new FormControl('', []),
          useUsetermsPolicy:  new FormControl('', []),
          usetermsPolicy:  new FormControl('', []),
          useUsecontractPolicy:  new FormControl('', []),
          usecontractPolicy:  new FormControl('', []),
          useAuthorInfo: new FormControl('', []),
          authorInfo: new FormControl('', [])
      });
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'name/description/site';
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
  }
		       
  setObject(appconfig){
	  super.setObject(appconfig);
	  this.dataForm.setValue({
	      name: appconfig.name,
	      description: appconfig.description,
	      site: appconfig.site,
	      usePricingPolicy: appconfig.usePricingPolicy,
	      pricingPolicy: appconfig.pricingPolicy,
	      usePrivacityPolicy: appconfig.usePrivacityPolicy,
	      privacityPolicy: appconfig.privacityPolicy,
	      useUsetermsPolicy: appconfig.useUsetermsPolicy,
	      usetermsPolicy: appconfig.usetermsPolicy,
	      useUsecontractPolicy: appconfig.useUsecontractPolicy,
	      usecontractPolicy: appconfig.usecontractPolicy,
	      useAuthorInfo: appconfig.useAuthorInfo,
          authorInfo: appconfig.authorInfo
	  });
  }
  
  prepareToSaveUpdate(appconfig){
	  appconfig.pricingPolicy = this.stringService.unentityLtGt(appconfig.pricingPolicy);
	  appconfig.privacityPolicy = this.stringService.unentityLtGt(appconfig.privacityPolicy);
	  appconfig.usetermsPolicy = this.stringService.unentityLtGt(appconfig.usetermsPolicy);
	  appconfig.usecontractPolicy = this.stringService.unentityLtGt(appconfig.usecontractPolicy);
	  appconfig.authorInfo = this.stringService.unentityLtGt(appconfig.authorInfo);
	  return appconfig;
  }
  
  makeSelectSearchedItemDestaked(appconfig,destakSearch): Object{
	  appconfig.name = this.makeDestak(appconfig.name,destakSearch);
	  appconfig.description = this.makeDestak(appconfig.description,destakSearch);
	  appconfig.site = this.makeDestak(appconfig.site,destakSearch);
	  return appconfig;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('name')){
		  this.addValidationMessage('Identificação é requerida!');
	  }
	  if(this.errorRequired('description')){
		  this.addValidationMessage('Descrição é requerida!');
	  }
	  if(this.errorRequired('site')){
		  this.addValidationMessage('URL Site é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
}