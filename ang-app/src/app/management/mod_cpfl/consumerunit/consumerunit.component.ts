import { Component, OnInit, OnDestroy, ViewEncapsulation } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';

import { BaseCrudFilterComponent } from '../../../base/basecrudfilter.component';

@Component({
	selector: 'consumerunit-root',
	templateUrl: './consumerunit.component.html',
	encapsulation: ViewEncapsulation.None,
	preserveWhitespaces: false
})
export class ConsumerunitComponent extends BaseCrudFilterComponent implements OnInit, OnDestroy{

	a2_caracteristics: Object[];
	a10_compl1types: Object[];
	a12_compl2types: Object[];
	a13_compl2descs: Object[];
    selectedClient: any;
   	
	ngOnInit() {
   		this.setInitializationServices(['consumerunit']);
   		this.crudService = this.consumerunitService;
   		this.selectedClient = this.storageService.get()[0];
   		this.sucessErrorMessages = {
			204:  'Unidade Consumidora excluído com sucesso.',
			207:  'Unidade Consumidora restaurado com sucesso.',
			208:  'Unidade Consumidora excluído [PERMANENTE] com sucesso.'
		}; 
		this.listTitle = 'Unidades Consumidoras';
		this.dataForm = new FormGroup({});  
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

	getAdditionalConditions(): string{ 
		var conditions = this.emptyObject(this.selectedClient) 
		        ? '' : ' xoo a15_clientid = ' + this.selectedClient.id;
		return conditions + ' ' + super.getAdditionalConditions();
	} 

	makeSelectSearchedItemDestaked(consumerunit,destakSearch): Object{
		consumerunit.a1_name = this.makeDestak(consumerunit.a1_name,destakSearch);
		consumerunit.a3_cpf = this.makeDestak(consumerunit.a3_cpf,destakSearch);
		consumerunit.a4_cnpj = this.makeDestak(consumerunit.a4_cnpj,destakSearch);
		return consumerunit;
	}

	/*toObjects(id){
		this.crudService.loadFromCache(id).then(consumerunit => {
			if(this.processObjectAndValidationResult(consumerunit,true)){
				this.eventEmitterService.get('objectDests').emit({object: consumerunit});
			}
		});
	}*/

	backToOrigin(){
		this.crudService.getStorageService().clear();
		this.eventEmitterService.get('clients').emit({});
	} 
	
}