import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../../base/basecrudfilter.component';

@Component({
	selector: 'billet-root',
	templateUrl: './billet.component.html',
	encapsulation: ViewEncapsulation.None,
	preserveWhitespaces: false
})
export class BilletComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

	selectedConsumerUnit: any;
	
	ngOnInit() {
   		this.setInitializationServices(['billet']);
   		this.crudService = this.billetService;
   		this.selectedConsumerUnit = this.storageService.get()[0];
   		this.sucessErrorMessages = {
			200:  'Fatura Energia adicionada com sucesso.',
			201:  'Fatura Energia alterada com sucesso.', 
			2010: 'Fatura Energia inativada com sucesso.',
			2011: 'Fatura Energia ativada com sucesso.',
			204:  'Fatura Energia exclu&iacute;da com sucesso.',
			207:  'Fatura Energia restaurada com sucesso.',
			208:  'Fatura Energia exclu&iacute;da [PERMANENTE] com sucesso.'
		}; 
		this.listTitle = 'Faturas Energia';
		this.addTitle = 'Adicionar Fatura Energia';
		this.editTitle = 'Editar Fatura Energia';
		this.dataForm = new FormGroup({
			a3_value: new FormControl('', [Validators.required]),
			a4_billingdate: new FormControl('', [Validators.required])
		});    
		super.ngOnInit();
	}

	afterNgOnInit(){
   		this.parameterName = '';        
	}

	ngOnDestroy(){    
		this.selectedConsumerUnit = null;
		super.ngOnDestroy();
	}

	setObject(billet){
   		super.setObject(billet);
		this.dataForm.setValue({
			a3_value: ('' + billet.a3_value).replace('.',','),
			a4_billingdate: this.dateService.dateToForm(billet.a4_billingdate)
		}); 
	} 

	getAdditionalConditions(): string{ 
		return ' xoo a2_consumerunitid = ' + this.selectedConsumerUnit.id + ' ' + super.getAdditionalConditions();
	} 

	prepareData(billet){
   		if(billet.alreadyPrepared){
   			return billet;
   		}
		billet.a3_valueLabel = ('' + billet.a3_value).replace('.',',');
		billet.a4_billingdateLabel = this.dateService.dateToForm(billet.a4_billingdate);
		billet.activeLabel = (['true',1,true].includes(billet.active) ? 'Sim' : 'N&atilde;o');
		billet.alreadyPrepared = true;
		return billet;
   	}

	prepareToSaveUpdate(billet){
		if(billet.alreadyPreparedToSave){
   			return billet;
   		}
		billet.alreadyPreparedToSave = true;
		billet.a1_clientid = this.selectedConsumerUnit.a15_clientid;
		billet.a2_consumerunitid = this.selectedConsumerUnit.id;
		billet.a3_value = parseFloat(('' + billet.a3_value).replace(',','.'));
		billet.a4_billingdate = this.dateService.dateFromForm(billet.a4_billingdate);
		return billet;
	}

	makeSelectSearchedItemDestaked(billet,destakSearch): Object{
		return billet;
	}

	validateFormFields(): Boolean{
		if(this.errorRequired('a3_value')){
			this.addValidationMessage('Valor &eacute; requerido!');
		}
		if(this.errorRequired('a4_billingdate')){
			this.addValidationMessage('Data Vencimento &eacute; requerida!');
		}
		return !this.inValidationMsgs();
	}

	preValidateToSaveUpdate(billet): boolean{
		if(this.emptyObject(this.selectedConsumerUnit)){
			this.addValidationMessage('Unidade Consumidora &eacute; requerida!');
		}
		if(this.emptyString(this.dateService.dateFromForm(billet.a4_billingdate))){
			this.addValidationMessage('Data Vencimento est&aacute; incorreta!');
		}
		return !this.inValidationMsgs();
	}

	backToOrigin(){
		this.crudService.getStorageService().clear();
		this.clientService.loadFromCache(this.selectedConsumerUnit.a15_clientid).then(client => {
			if(this.processObjectAndValidationResult(client,true)){
				this.eventEmitterService.get('consumerunits').emit({object: client});
			}
		});
	} 

	patchValue(target,value){
		if(target == 'a3_value'){
			this.dataForm.patchValue({a3_value: value});
		}
		if(target == 'a4_billingdate'){
			this.dataForm.patchValue({a4_billingdate: value});
		}
   	} 
}