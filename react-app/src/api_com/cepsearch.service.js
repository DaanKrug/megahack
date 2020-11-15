import BaseCrudService from './base/basecrud.service.js';

const CepSearchService = {
	getUrlBase(){
		return '/cepsearchs';
	},
	findByCep(cep){
		const url = CepSearchService.getUrlBase() + '/' + cep.replace(/-/gi,'');
		return BaseCrudService.makeRequestToAPI(url,'post',{})
						      .then(response => { return JSON.parse(response); });
	},
};
export default CepSearchService;

