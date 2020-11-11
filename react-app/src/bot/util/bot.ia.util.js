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
	
}















