import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../../base/basecrudfilter.component';

@Component({
	selector: 'solicitation-root',
	templateUrl: './solicitation.component.html',
	encapsulation: ViewEncapsulation.None,
	preserveWhitespaces: false
})
export class SolicitationComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

	a2_caracteristics: Object[];
	a10_compl1types: Object[];
	a12_compl2types: Object[];  
    selectedClient: any;
   	
	ngOnInit() {
   		this.setInitializationServices(['solicitation']);
   		this.crudService = this.solicitationService;
   		this.selectedClient = this.storageService.get()[0];
   		this.sucessErrorMessages = {
			200:  'Solicitação de Nova Ligação adicionada com sucesso.',
			201:  'Solicitação de Nova Ligação alterada com sucesso.', 
			2010: 'Unidade Consumidora inativada com sucesso.',
			2011: 'Unidade Consumidora ativada com sucesso.',
			204:  'Solicitação de Nova Ligação excluída com sucesso.',
			207:  'Solicitação de Nova Ligação restaurada com sucesso.',
			208:  'Solicitação de Nova Ligação excluída [PERMANENTE] com sucesso.'
		}; 
		this.listTitle = 'Solicitações de Nova Ligação';
		this.addTitle = 'Adicionar Solicitação de Nova Ligação';
		this.editTitle = 'Editar Solicitação de Nova Ligação';
		this.dataForm = new FormGroup({
			a2_caracteristic: new FormControl('', [Validators.required]),
			a5_cep: new FormControl('', [Validators.required]),
			a6_uf: new FormControl('', [Validators.required]),
			a7_city: new FormControl('', [Validators.required]),
			a8_street: new FormControl('', [Validators.required]),
			a9_number: new FormControl('', [Validators.required]),
			a10_compl1type: new FormControl('', []),
			a11_compl1desc: new FormControl('', []),
			a12_compl2type: new FormControl('', []),
			a13_compl2desc: new FormControl('', []),
			a14_reference: new FormControl('', [Validators.required]),
			active: new FormControl('', [])
		});  
		this.a2_caracteristics = [
			{value: 'l1', label: 'Ligação para casa ou comércio, em local com até duas instalações'},
			{value: 'l2', label: 'Ligação para apartamentos residenciais ou sala/loja comercial em edifícios e galerias'},
			{value: 'l3', label: 'Ligação de projeto para loteamentos'},
			{value: 'l4', label: 'Ligação de projeto edifícios'}
		];
		this.a10_compl1types = [
			{value: 'adminstracao', label: 'Administração'},
			{value: 'altos', label: 'Altos'},
			{value: 'apartamento', label: 'Apartamento'},
			{value: 'armazem', label: 'Armazém'},
			{value: 'baixos', label: 'Balcão'},
			{value: 'bancajornal', label: 'Banca de Jornal'},
			{value: 'barraca', label: 'Barraca'},
			{value: 'barracao', label: 'Barracão'},
			{value: 'bilheteria', label: 'Bilheteria'},
			{value: 'loja', label: 'Loja'},
			{value: 'lote', label: 'Lote'},
			{value: 'sala', label: 'Sala'},
			{value: 'salao', label: 'Salão'}
		];
		this.a12_compl2types = [
			{value: 'acesso', label: 'Acesso'},
			{value: 'andar', label: 'Andar'},
			{value: 'anexo', label: 'Anexo'},
			{value: 'clube', label: 'Clube'},
			{value: 'colegio', label: 'Colégio'},
			{value: 'colonia', label: 'Colônia'},
			{value: 'cruzamento', label: 'Cruzamento'}
		]; 
		super.ngOnInit();
	}

	afterNgOnInit(){
   		this.parameterName = 'a1_name|type:string/a3_cpf|type:string/a4_cnpj|type:string'; 
	}

	ngOnDestroy(){   
		this.a2_caracteristics = null;
		this.a10_compl1types = null;
		this.a12_compl2types = null;
		this.selectedClient = null;
		super.ngOnDestroy();
	}

	setObject(solicitation){
   		super.setObject(solicitation);
		this.dataForm.setValue({
			a2_caracteristic: solicitation.a2_caracteristic,
			a5_cep: solicitation.a5_cep,
			a6_uf: solicitation.a6_uf,
			a7_city: solicitation.a7_city,
			a8_street: solicitation.a8_street,
			a9_number: solicitation.a9_number,
			a10_compl1type: solicitation.a10_compl1type,
			a11_compl1desc: solicitation.a11_compl1desc,
			a12_compl2type: solicitation.a12_compl2type,
			a13_compl2desc: solicitation.a13_compl2desc,
			a14_reference: solicitation.a14_reference,
			active: solicitation.active
		}); 
	} 

	getAdditionalConditions(): string{ 
		var conditions = this.emptyObject(this.selectedClient) 
		               ? '' : ' xoo a15_clientid = ' + this.selectedClient.id;
		return conditions + ' ' + super.getAdditionalConditions();
	} 

	prepareData(solicitation){
   		if(solicitation.alreadyPrepared){
   			return solicitation;
   		}
		solicitation.activeLabel = (['true',1,true].includes(solicitation.active) ? 'Sim' : 'Não');
		solicitation.alreadyPrepared = true;
		return solicitation;
   	}

	prepareToSaveUpdate(solicitation){
		if(solicitation.alreadyPreparedToSave || this.emptyObject(this.selectedClient)){
   			return solicitation;
   		}
		solicitation.alreadyPreparedToSave = true;
		solicitation.a1_name = this.selectedClient.a1_name;
		solicitation.a3_cpf = this.selectedClient.a3_cpf;
		solicitation.a4_cnpj = this.selectedClient.a4_cnpj;
		solicitation.a15_clientid = this.selectedClient.id;
		return solicitation;
	}

	makeSelectSearchedItemDestaked(solicitation,destakSearch): Object{
		solicitation.a1_name = this.makeDestak(solicitation.a1_name,destakSearch);
		solicitation.a3_cpf = this.makeDestak(solicitation.a3_cpf,destakSearch);
		solicitation.a4_cnpj = this.makeDestak(solicitation.a4_cnpj,destakSearch);
		return solicitation;
	}

	validateFormFields(): Boolean{
		if(this.errorRequired('a2_caracteristic')){
			this.addValidationMessage('Característica do Imóvel é requerida!');
		}
		if(this.errorRequired('a5_cep')){
			this.addValidationMessage('CEP é requerido!');
		}
		if(this.errorRequired('a6_uf')){
			this.addValidationMessage('Estado/UF é requerido!');
		}
		if(this.errorRequired('a7_city')){
			this.addValidationMessage('Cidade é requerida!');
		}
		if(this.errorRequired('a8_street')){
			this.addValidationMessage('Logradouro é requerido!');
		}
		if(this.errorRequired('a14_reference')){
			this.addValidationMessage('Refer&ecirc;ncia é requerida!');
		}
		return !this.inValidationMsgs();
	}

	preValidateToSaveUpdate(solicitation): boolean{
		if(this.emptyObject(this.selectedClient) && !(solicitation.id > 0)){
			this.addValidationMessage('Cliente é requerido!');
		}
		return !this.inValidationMsgs();
	}

	backToOrigin(){
		this.crudService.getStorageService().clear();
		this.eventEmitterService.get('clients').emit({});
	} 

	patchValue(target,value){
		if(target == 'a2_caracteristic'){
			this.dataForm.patchValue({a2_caracteristic: value});
		}
		if(target == 'a5_cep'){
			this.dataForm.patchValue({a5_cep: value});
		}
		if(target == 'a6_uf'){
			this.dataForm.patchValue({a6_uf: value});
		}
		if(target == 'a7_city'){
			this.dataForm.patchValue({a7_city: value});
		}
		if(target == 'a8_street'){
			this.dataForm.patchValue({a8_street: value});
		}
		if(target == 'a9_number'){
			this.dataForm.patchValue({a9_number: value});
		}
		if(target == 'a10_compl1type'){
			this.dataForm.patchValue({a10_compl1type: value});
		}
		if(target == 'a11_compl1desc'){
			this.dataForm.patchValue({a11_compl1desc: value});
		}
		if(target == 'a12_compl2type'){
			this.dataForm.patchValue({a12_compl2type: value});
		}
		if(target == 'a13_compl2desc'){
			this.dataForm.patchValue({a13_compl2desc: value});
		}
		if(target == 'a14_reference'){
			this.dataForm.patchValue({a14_reference: value});
		}
   	}
	
}