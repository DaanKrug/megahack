import { AppLog } from './applog';
import { BaseCrudService } from '../../../app_base/basecrud.service';
 
export class AppLogService extends BaseCrudService {
	
  getUrl(){
	  return this.getBase() + '/applogs';
  }
  
  getEmptyObject(conditions) :Object{
	  var ownerId: number = parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
	  return new AppLog(0,conditions,0,null,null,null,null,null,null,
			            ownerId,
			            this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
  }
 
  getAll(page,rows,conditions): Promise<AppLog[]> {
	  return new Promise<AppLog[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
  }
  
  load(id): Promise<AppLog> {
	  return new Promise<AppLog>(r => r(super.load(id)));
  }
  
  
}