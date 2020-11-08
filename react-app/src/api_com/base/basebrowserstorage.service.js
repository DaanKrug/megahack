const BaseBrowserStorageService = {
	getAppId(){
		let meta = window.parent.document.querySelector("meta[name='app-id']");
		return (null != meta ? meta.getAttribute("content") : null);
	},
	getLocalItem(name){
		return localStorage.getItem(name + BaseBrowserStorageService.getAppId());
	},
	getSessionItem(name){
		return sessionStorage.getItem(name + BaseBrowserStorageService.getAppId());
	},
	setLocalItem(name,value){
		return localStorage.setItem(name + BaseBrowserStorageService.getAppId(),'' + value);
	},
	setSessionItem(name,value){
		return sessionStorage.setItem(name + BaseBrowserStorageService.getAppId(),'' + value);
	},
	getToken(){
		return BaseBrowserStorageService.getSessionItem('_token_');
	},
	getOwnerId(){
		return BaseBrowserStorageService.getSessionItem('_ownerId_');
	}
};
export default BaseBrowserStorageService;
