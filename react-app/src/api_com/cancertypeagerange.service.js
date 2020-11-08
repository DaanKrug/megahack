import BaseCrudService from './base/basecrud.service.js';

const CancerTypeAgeRangeService = {
	getUrlBase(){
		return '/cancertypeageranges';
	},
	getAll(page,rows,conditions){
		const url = CancerTypeAgeRangeService.getUrlBase() + '/' + page + '/' + rows;
		return BaseCrudService.makeRequestToAPI(url,'post',{conditions: conditions})
						      .then(cancertypeageranges => { 
						    	  return (null === cancertypeageranges ? [] : cancertypeageranges); 
						      });
	},
};
export default CancerTypeAgeRangeService;

