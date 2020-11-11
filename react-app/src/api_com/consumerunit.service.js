import BaseCrudService from './base/basecrud.service.js';

const ConsumerUnitService = {
	getUrlBase(){
		return '/consumerunits';
	},
	registerFault(cpf){
		const url = ConsumerUnitService.getUrlBase();
		return BaseCrudService.makeRequestToAPI(url,'post',{a3_cpf: cpf})
						      .then(response => { return response; });
	},
	registerFaultByConsumerUnitId(id){
		const url = ConsumerUnitService.getUrlBase() + '/' + id;
		return BaseCrudService.makeRequestToAPI(url,'post',{})
						      .then(response => { return response; });
	},
};
export default ConsumerUnitService;

