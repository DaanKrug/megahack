import BaseCrudService from './base/basecrud.service.js';

const CancerTypeService = {
	getUrlBase(){
		return '/cancertypes';
	},
	getAll(page,rows,conditions){
		const url = CancerTypeService.getUrlBase() + '/' + page + '/' + rows;
		return BaseCrudService.makeRequestToAPI(url,'post',{conditions: conditions})
						      .then(cancertypes => { return (null === cancertypes ? [] : cancertypes); });
	},
};
export default CancerTypeService;

