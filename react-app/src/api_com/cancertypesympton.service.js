import BaseCrudService from './base/basecrud.service.js';

const CancerTypeSymptonService = {
	getUrlBase(){
		return '/cancertypesymptons';
	},
	getAll(page,rows,conditions){
		const url = CancerTypeSymptonService.getUrlBase() + '/' + page + '/' + rows;
		return BaseCrudService.makeRequestToAPI(url,'post',{conditions: conditions})
						      .then(cancertypesymptons => { 
						    	  return (null === cancertypesymptons ? [] : cancertypesymptons); 
						      });
	},
};
export default CancerTypeSymptonService;

