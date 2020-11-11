import ConsumerUnitService from '../../api_com/consumerunit.service.js';

export default class BotIAUtil {
	
	registerFault(cpf){
		return ConsumerUnitService.registerFault(cpf).then(response => {
			return response;
		});
	}
	
	registerFaultByConsumerUnitId(id){
		return ConsumerUnitService.registerFaultByConsumerUnitId(id).then(response => {
			return response;
		});
	}
	
	registerReBinding(cpf){
		return ConsumerUnitService.registerReBinding(cpf).then(response => {
			return response;
		});
	}
	
	registerReBindingByConsumerUnitId(id){
		return ConsumerUnitService.registerReBindingByConsumerUnitId(id).then(response => {
			return response;
		});
	}

}