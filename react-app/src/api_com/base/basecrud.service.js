import BaseBrowserStorageService from './basebrowserstorage.service.js';
import DataService from './data.service.js';

const BaseCrudService = {
	inDebugg(){
		let debugg = BaseBrowserStorageService.getSessionItem('_debugg_mode_on_');
		return (debugg === 'true');
	},
	getBase(){
		let mockForRemote = BaseBrowserStorageService.getSessionItem('_remote_server_');
		if(mockForRemote === 'true'){
			const url = 'https://megahack2020.skallerten.com.br/megahack2020/';
			if(BaseCrudService.inDebugg()){
				console.log('mockForRemote === \'true\', url: ' + url);
			}
			return url;
		}
		return BaseBrowserStorageService.getSessionItem('_doc_base_');
	},
	getRequestOptions(method,bodyObject){
		const requestOptions = {
	        method: method,
	        headers: {
	        	'X-CSRF-TOKEN': BaseBrowserStorageService.getToken(),
				'Content-Type': 'application/json', 
				'Access-Control-Allow-Origin': '*'
	        },
	        body: JSON.stringify(bodyObject)
	    };
		return requestOptions;
	},
	async getDataFetch(url,requestOptions){
		const response = await fetch(url,requestOptions);
		try{
			const data = await response.json();
			if(Array.isArray(data)){
				return DataService.clearRowZeroObjectsValidated(data);
			}
			return data;
		}catch(e){
			if(BaseCrudService.inDebugg()){
				console.log('Error: ', e);
				console.log('Requested URL: ', response.url);
			}
			return null;
		}
	},
	async makeRequestToAPI(resorceUrl,method,bodyObject){
		let url = BaseCrudService.getBase() + resorceUrl + '?v=' + new Date().getTime();
		bodyObject = (undefined === bodyObject || null === bodyObject) ? {} : bodyObject;
		bodyObject._token = BaseBrowserStorageService.getToken();
		bodyObject.ownerId = BaseBrowserStorageService.getOwnerId();
		let requestOptions = BaseCrudService.getRequestOptions(method,bodyObject);
		return BaseCrudService.getDataFetch(url,requestOptions);
	}
};
export default BaseCrudService;








