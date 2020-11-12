import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../../base/basecrudfilter.component';


@Component({
	selector: 'client-root',
	templateUrl: './client.component.html',
	encapsulation: ViewEncapsulation.None,
	preserveWhitespaces: false
})
export class ClientComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

	a2_types: Object[];
	a6_doctypes: Object[];
	a8_genders: Object[];
	a16_compl1types: Object[];
	a18_compl2types: Object[];
    selectedPersonType: string;
   	
	ngOnInit() {
   		this.setInitializationServices(['client']);
   		this.crudService = this.clientService;
   		this.sucessErrorMessages = {
			200:  'Cliente adicionado com sucesso.',
			201:  'Cliente alterado com sucesso.', 
			204:  'Cliente exclu&iacute;do com sucesso.',
			207:  'Cliente restaurado com sucesso.',
			208:  'Cliente exclu&iacute;do [PERMANENTE] com sucesso.'
		}; 
		this.listTitle = 'Clientes';
		this.addTitle = 'Adicionar Cliente';
		this.editTitle = 'Editar Cliente';
		this.dataForm = new FormGroup({
			a1_name: new FormControl('', [Validators.required]),
			a2_type: new FormControl('', [Validators.required]),
			a3_cpf: new FormControl('', [Validators.required]),
			a4_cnpj: new FormControl('', [Validators.required]),
			a5_birthdate: new FormControl('', [Validators.required]),
			a6_doctype: new FormControl('', [Validators.required]),
			a7_document: new FormControl('', [Validators.required]),
			a8_gender: new FormControl('', [Validators.required]),
			a9_email: new FormControl('', []),
			a10_phone: new FormControl('', [Validators.required]),
			a11_cep: new FormControl('', [Validators.required]),
			a12_uf: new FormControl('', [Validators.required]),
			a13_city: new FormControl('', [Validators.required]),
			a14_street: new FormControl('', [Validators.required]),
			a15_number: new FormControl('', []),
			a16_compl1type: new FormControl('', []),
			a17_compl1desc: new FormControl('', []),
			a18_compl2type: new FormControl('', []),
			a19_compl2desc: new FormControl('', [])
		});  
		this.a2_types = [
			{value: 'PF', label: 'Pessoa Física'},
			{value: 'PJ', label: 'Pessoa Jurídica'}
		];
		this.a6_doctypes = [
			{value: 'rg', label: 'RG'},
			{value: 'cnh', label: 'CNH'},
			{value: 'passport', label: 'Passaporte'},
			{value: 'reservistcart', label: 'Carteira de Reservista'},
			{value: 'workcart', label: 'Carteira de Trabalho'},
			{value: 'nre', label: 'Número de Registro de Estrangeiro'},
		];
		this.a8_genders = [
			{value: 'men', label: 'Masculino'},
			{value: 'women', label: 'Feminino'},
			{value: 'unknow', label: 'Outro'}
		];
		this.a16_compl1types = [
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
		this.a18_compl2types = [
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
   		this.parameterName = 'a1_name|type:string/a3_cpf|type:string/a4_cnpj|';
   		this.parameterName += 'type:string/a10_phone|type:string'; 
	}

	ngOnDestroy(){   
		this.a2_types = null;
		this.a6_doctypes = null;
		this.a8_genders = null;
		this.a16_compl1types = null;
		this.a18_compl2types = null;
		this.selectedPersonType = null;
		super.ngOnDestroy();
	}

	setObject(client){
   		super.setObject(client);
   		var a2_type: any = this.a2_types[0];
		this.dataForm.setValue({
			a1_name: client.a1_name,
			a2_type: this.emptyString(client.a2_type) ? a2_type.value : client.a2_type,
			a3_cpf: client.a3_cpf,
			a4_cnpj: client.a4_cnpj,
			a5_birthdate: this.dateService.dateToForm(client.a5_birthdate),
			a6_doctype: client.a6_doctype,
			a7_document: client.a7_document,
			a8_gender: client.a8_gender,
			a9_email: client.a9_email,
			a10_phone: client.a10_phone,
			a11_cep: client.a11_cep,
			a12_uf: client.a12_uf,
			a13_city: client.a13_city,
			a14_street: client.a14_street,
			a15_number: client.a15_number,
			a16_compl1type: client.a16_compl1type,
			a17_compl1desc: client.a17_compl1desc,
			a18_compl2type: client.a18_compl2type,
			a19_compl2desc: client.a19_compl2desc
		}); 
		this.setSelectedPersonType(client.a2_type);
	} 
	
	setSelectedPersonType(selectedPersonType){
		if(this.emptyString(selectedPersonType)){
			var type: any = this.a2_types[0];
			selectedPersonType = type.value;
		}
		this.selectedPersonType = selectedPersonType;
	}

	getAdditionalConditions(): string{ 
		return ' ' + super.getAdditionalConditions();
	} 

	prepareData(client){
   		if(client.alreadyPrepared){
   			return client;
   		}
   		client.a5_birthdateLabel = this.dateService.dateToForm(client.a5_birthdate);
		client.alreadyPrepared = true;
		return client;
   	}

	prepareToSaveUpdate(client){
		if(client.alreadyPreparedToSave){
   			return client;
   		}
		client.alreadyPreparedToSave = true;
		client.a5_birthdate = this.dateService.dateFromForm(client.a5_birthdate);
		return client;
	}

	makeSelectSearchedItemDestaked(client,destakSearch): Object{
		client.a1_name = this.makeDestak(client.a1_name,destakSearch);
		client.a3_cpf = this.makeDestak(client.a3_cpf,destakSearch);
		client.a4_cnpj = this.makeDestak(client.a4_cnpj,destakSearch);
		client.a10_phone = this.makeDestak(client.a10_phone,destakSearch);
		return client;
	}

	validateFormFields(): Boolean{
		if(this.errorRequired('a1_name')){
			this.addValidationMessage('Nome/raz&atilde;o Social &eacute; requerido!');
		}
		if(this.errorRequired('a2_type')){
			this.addValidationMessage('Tipo &eacute; requerido!');
		}
		if(this.errorRequired('a5_birthdate')){
			this.addValidationMessage('Data Nascimento &eacute; requerida!');
		}
		if(this.errorRequired('a6_doctype')){
			this.addValidationMessage('Tipo Documento &eacute; requerido!');
		}
		if(this.errorRequired('a7_document')){
			this.addValidationMessage('Documento &eacute; requerido!');
		}
		if(this.errorRequired('a8_gender')){
			this.addValidationMessage('Sexo/g&ecirc;nero &eacute; requerido!');
		}
		if(this.errorRequired('a10_phone')){
			this.addValidationMessage('Telefone(s) &eacute; requerido!');
		}
		if(this.errorRequired('a11_cep')){
			this.addValidationMessage('Cep &eacute; requerido!');
		}
		if(this.errorRequired('a12_uf')){
			this.addValidationMessage('Estado/uf &eacute; requerido!');
		}
		if(this.errorRequired('a13_city')){
			this.addValidationMessage('Cidade &eacute; requerido!');
		}
		if(this.errorRequired('a14_street')){
			this.addValidationMessage('Logradouro &eacute; requerido!');
		}
		return !this.inValidationMsgs();
	}

	preValidateToSaveUpdate(client): boolean{
		if(client.a2_type == 'PF' && this.errorRequired('a3_cpf')){
			this.addValidationMessage('CPF &eacute; requerido!');
		}
		if(client.a2_type == 'PJ' && this.errorRequired('a4_cnpj')){
			this.addValidationMessage('CNPJ &eacute; requerido!');
		}
		if(this.emptyString(this.dateService.dateFromForm(client.a5_birthdate))){
			this.addValidationMessage('Data Nascimento est&aacute; incorreta!');
		}
		return !this.inValidationMsgs();
	}

	toSolicitations(id){
		this.crudService.loadFromCache(id).then(client => {
			if(this.processObjectAndValidationResult(client,true)){
				this.eventEmitterService.get('solicitations').emit({object: client});
			}
		});
	}
	
	toConsumerUnits(id){
		this.crudService.loadFromCache(id).then(client => {
			if(this.processObjectAndValidationResult(client,true)){
				this.eventEmitterService.get('consumerunits').emit({object: client});
			}
		});
	}

	patchValue(target,value){
   		if(target == 'a1_name'){
			this.dataForm.patchValue({a1_name: value});
		}
		if(target == 'a2_type'){
			this.dataForm.patchValue({a2_type: value});
		}
		if(target == 'a3_cpf'){
			this.dataForm.patchValue({a3_cpf: value});
		}
		if(target == 'a4_cnpj'){
			this.dataForm.patchValue({a4_cnpj: value});
		}
		if(target == 'a5_birthdate'){
			this.dataForm.patchValue({a5_birthdate: value});
		}
		if(target == 'a6_doctype'){
			this.dataForm.patchValue({a6_doctype: value});
		}
		if(target == 'a7_document'){
			this.dataForm.patchValue({a7_document: value});
		}
		if(target == 'a8_gender'){
			this.dataForm.patchValue({a8_gender: value});
		}
		if(target == 'a9_email'){
			this.dataForm.patchValue({a9_email: value});
		}
		if(target == 'a10_phone'){
			this.dataForm.patchValue({a10_phone: value});
		}
		if(target == 'a11_cep'){
			this.dataForm.patchValue({a11_cep: value});
		}
		if(target == 'a12_uf'){
			this.dataForm.patchValue({a12_uf: value});
		}
		if(target == 'a13_city'){
			this.dataForm.patchValue({a13_city: value});
		}
		if(target == 'a14_street'){
			this.dataForm.patchValue({a14_street: value});
		}
		if(target == 'a15_number'){
			this.dataForm.patchValue({a15_number: value});
		}
		if(target == 'a16_compl1type'){
			this.dataForm.patchValue({a16_compl1type: value});
		}
		if(target == 'a17_compl1desc'){
			this.dataForm.patchValue({a17_compl1desc: value});
		}
		if(target == 'a18_compl2type'){
			this.dataForm.patchValue({a18_compl2type: value});
		}
		if(target == 'a19_compl2desc'){
			this.dataForm.patchValue({a19_compl2desc: value});
		}
   	}
	
}