import BaseCrudService from './base/basecrud.service.js';

const AgeRangeService = {
	getUrlBase(){
		return '/ageranges';
	},
	getAll(page,rows,conditions){
		const url = AgeRangeService.getUrlBase() + '/' + page + '/' + rows;
		return BaseCrudService.makeRequestToAPI(url,'post',{conditions: conditions})
						      .then(ageranges => { return (null === ageranges ? [] : ageranges); });
	},
};
export default AgeRangeService;

