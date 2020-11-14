import BaseCrudService from './base/basecrud.service.js';

const AwsRekognitionService = {
	getUrlBase(){
		return '/awsrekoginitions';
	},
	rekognize(image: any){
		const url = AwsRekognitionService.getUrlBase();
		return BaseCrudService.makeRequestToAPI(url,'post',image)
						      .then(response => { return response; });
	},
};
export default AwsRekognitionService;

