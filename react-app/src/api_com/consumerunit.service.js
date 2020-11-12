import BaseCrudService from './base/basecrud.service.js';

const ConsumerUnitService = {
	getUrlBase(){
		return '/consumerunits';
	},
	registerFault(cpf){
		let bodyObject = cpf.length === 11 ? {a3_cpf: cpf} : {a4_cnpj: cpf};
		const url = ConsumerUnitService.getUrlBase();
		return BaseCrudService.makeRequestToAPI(url,'post',bodyObject)
						      .then(response => { return response; });
	},
	registerFaultByConsumerUnitId(id){
		const url = ConsumerUnitService.getUrlBase() + '/' + id;
		return BaseCrudService.makeRequestToAPI(url,'post',{})
						      .then(response => { return response; });
	},
	registerReBinding(cpf){
		let bodyObject = cpf.length === 11 ? {a3_cpf: cpf} : {a4_cnpj: cpf};
		const url = ConsumerUnitService.getUrlBase();
		return BaseCrudService.makeRequestToAPI(url,'put',bodyObject)
						      .then(response => { return response; });
	},
	registerReBindingByConsumerUnitId(id){
		const url = ConsumerUnitService.getUrlBase() + '/' + id;
		return BaseCrudService.makeRequestToAPI(url,'put',{})
						      .then(response => { return response; });
	},
};
export default ConsumerUnitService;

