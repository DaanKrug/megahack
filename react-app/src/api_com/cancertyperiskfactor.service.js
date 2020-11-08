import BaseCrudService from './base/basecrud.service.js';

const CancerTypeRiskFactorService = {
	getUrlBase(){
		return '/cancertyperiskfactors';
	},
	getAll(page,rows,conditions){
		const url = CancerTypeRiskFactorService.getUrlBase() + '/' + page + '/' + rows;
		return BaseCrudService.makeRequestToAPI(url,'post',{conditions: conditions})
						      .then(cancertyperiskfactors => { 
						    	  return (null === cancertyperiskfactors ? [] : cancertyperiskfactors); 
						      });
	},
};
export default CancerTypeRiskFactorService;

