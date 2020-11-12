import { Billet } from './billet';
import { BaseCrudService } from '../../../../app_base/basecrud.service';

export class BilletService extends BaseCrudService {

	getUrl(){
		return this.getBase() + '/billets';
	}

	getUrlForCache(){
		return this.getUrl();
	}

	getEmptyObject(conditions) :Object{
		var ownerId: number = 
			parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
		return new Billet(0,conditions,
		                  0,0,0,null,false,'0','null','false',
		                  ownerId,
		                  this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
	}

	getAll(page,rows,conditions): Promise<Billet[]> {
		return new Promise<Billet[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
	}

	load(id): Promise<Billet> {
		return new Promise<Billet>(r => r(super.load(id)));
	} 

	mergeAnotherInObject(object,anotherObject){
		object.a1_clientid = super.getChangedValue(anotherObject.a1_clientid,object.a1_clientid);
		object.a2_consumerunitid = 
			super.getChangedValue(anotherObject.a2_consumerunitid,object.a2_consumerunitid);
		object.a3_value = super.getChangedValue(anotherObject.a3_value,object.a3_value);
		object.a4_billingdate = super.getChangedValue(anotherObject.a4_billingdate,object.a4_billingdate);
		object.active = super.getChangedValue(anotherObject.active,object.active); 
		object.a3_valueLabel = super.getChangedValue(anotherObject.a3_valueLabel,object.a3_valueLabel);
		object.a4_billingdateLabel = 
			super.getChangedValue(anotherObject.a4_billingdateLabel,object.a4_billingdateLabel);
		object.activeLabel = super.getChangedValue(anotherObject.activeLabel,object.activeLabel);
		object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
		return object;
	}

}