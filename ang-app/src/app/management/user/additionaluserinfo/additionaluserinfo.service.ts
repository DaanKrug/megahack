import { Additionaluserinfo } from './additionaluserinfo';
import { BaseCrudService } from '../../../../app_base/basecrud.service';

export class AdditionaluserinfoService extends BaseCrudService {

	getUrl(){
		return this.getBase() + '/additionaluserinfos';
	}

	getUrlForCache(){
		return this.getUrl();
	}

	getEmptyObject(conditions) :Object{
		var ownerId: number = 
			parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
		return new Additionaluserinfo(0,conditions,
		                              null,null,null,null,null,null,0,
		                              ownerId,
		                              this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
	}

	getAll(page,rows,conditions): Promise<Additionaluserinfo[]> {
		return new Promise<Additionaluserinfo[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
	}

	load(id): Promise<Additionaluserinfo> {
		return new Promise<Additionaluserinfo>(r => r(super.load(id)));
	} 

	mergeAnotherInObject(object,anotherObject){
		object.a1_rg = super.getChangedValue(anotherObject.a1_rg,object.a1_rg);
		object.a2_cpf = super.getChangedValue(anotherObject.a2_cpf,object.a2_cpf);
		object.a3_cns = super.getChangedValue(anotherObject.a3_cns,object.a3_cns);
		object.a4_phone = super.getChangedValue(anotherObject.a4_phone,object.a4_phone);
		object.a5_address = super.getChangedValue(anotherObject.a5_address,object.a5_address);
		object.a6_otherinfo = super.getChangedValue(anotherObject.a6_otherinfo,object.a6_otherinfo);
		object.a7_userid = super.getChangedValue(anotherObject.a7_userid,object.a7_userid); 
		object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
		return object;
	}

}