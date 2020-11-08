import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../base/basecrudfilter.component';

@Component({
  selector: 's3config-root',
  templateUrl: './s3config.component.html',
  encapsulation: ViewEncapsulation.None,
  preserveWhitespaces: false
})
export class S3ConfigComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{
		
  ngOnInit() {
	  this.setInitializationServices(['s3config']);
	  this.crudService = this.s3ConfigService;
	  this.sucessErrorMessages = {
		  200:  'Configuração AWS S3 adicionada com sucesso.',
		  201:  'Configuração AWS S3 alterada com sucesso.',
		  2010: 'Configuração AWS S3 inativada com sucesso.',
		  2011: 'Configuração AWS S3 ativada com sucesso.',
		  204:  'Configuração AWS S3 excluída com sucesso.',
		  207:  'Configuração AWS S3 restaurada com sucesso.',
		  208:  'Configuração AWS S3 excluída [PERMANENTE] com sucesso.',
	  };
	  this.listTitle = 'Configurações S3';
	  this.addTitle = 'Adicionar Configuração AWS S3';
	  this.editTitle = 'Editar Configuração AWS S3';
	  this.dataForm = new FormGroup({
          bucketName: new FormControl('', [Validators.required]),
          bucketUrl:  new FormControl('', [Validators.required]),
          region:  new FormControl('', [Validators.required]),
          version:  new FormControl('', [Validators.required]),
          key:  new FormControl('', [Validators.required]),
          secret:  new FormControl('', [Validators.required])
      });
      super.ngOnInit();
  }
  
  afterNgOnInit(){
	  this.parameterName = 'bucketName/bucketUrl/region/keyy/secret';
  }
  
  ngOnDestroy(){
	  super.ngOnDestroy();
  }
  
  setObject(s3config){
	  super.setObject(s3config);
	  this.dataForm.setValue({
	      bucketName: s3config.bucketName,
	      bucketUrl: s3config.bucketUrl,
	      region: s3config.region,
	      version: s3config.version,
	      key: s3config.key,
	      secret: s3config.secret
	  });
  }
  
  makeSelectSearchedItemDestaked(s3config,destakSearch): Object{
	  s3config.bucketName = this.makeDestak(s3config.bucketName,destakSearch);
	  s3config.bucketUrl = this.makeDestak(s3config.bucketUrl,destakSearch);
	  s3config.region = this.makeDestak(s3config.region,destakSearch);
	  s3config.key = this.makeDestak(s3config.key,destakSearch);
	  s3config.secret = this.makeDestak(s3config.secret,destakSearch);
	  return s3config;
  }
  
  validateFormFields(): Boolean{
	  if(this.errorRequired('bucketName')){
		  this.addValidationMessage('Bucket Name é requerido!');
	  }
	  if(this.errorRequired('bucketUrl')){
		  this.addValidationMessage('Bucket URL é requerida!');
	  }
	  if(this.errorRequired('region')){
		  this.addValidationMessage('Region é requerida!');
	  }
	  if(this.errorRequired('key')){
		  this.addValidationMessage('Key é requerida!');
	  }
	  if(this.errorRequired('secret')){
		  this.addValidationMessage('Secret é requerida!');
	  }
	  if(this.errorRequired('version')){
		  this.addValidationMessage('Version é requerida!');
	  }
	  return !this.inValidationMsgs();
  }
  
}