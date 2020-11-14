import BaseCrudService from '../base/basecrud.service.js';

const ViaCepService = {
	async findByCep(cep) {
		const url = 'http://cep.la/' + cep;
		let requestOptions = {method: 'get', headers: {'Accept': 'application/json'}};
		return BaseCrudService.getDataFetch(url,requestOptions);
	}
};
export default ViaCepService;
