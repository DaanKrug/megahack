import { Consumerunit } from './consumerunit';
import { BaseCrudService } from '../../../../app_base/basecrud.service';

export class ConsumerunitService extends BaseCrudService {

	getUrl(){
		return this.getBase() + '/consumerunits';
	}

	getUrlForCache(){
		return this.getUrl();
	}

	getEmptyObject(conditions) :Object{
		var ownerId: number = 
			parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
		return new Consumerunit(0,conditions,
		                        null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,0,
		                        ownerId,
		                        this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
	}

	getAll(page,rows,conditions): Promise<Consumerunit[]> {
		return new Promise<Consumerunit[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
	}

	load(id): Promise<Consumerunit> {
		return new Promise<Consumerunit>(r => r(super.load(id)));
	} 

	mergeAnotherInObject(object,anotherObject){
		object.a1_name = super.getChangedValue(anotherObject.a1_name,object.a1_name);
		object.a3_cpf = super.getChangedValue(anotherObject.a3_cpf,object.a3_cpf);
		object.a4_cnpj = super.getChangedValue(anotherObject.a4_cnpj,object.a4_cnpj);
		object.a2_caracteristic = 
			super.getChangedValue(anotherObject.a2_caracteristic,object.a2_caracteristic);
		object.a5_cep = super.getChangedValue(anotherObject.a5_cep,object.a5_cep);
		object.a6_uf = super.getChangedValue(anotherObject.a6_uf,object.a6_uf);
		object.a7_city = super.getChangedValue(anotherObject.a7_city,object.a7_city);
		object.a8_street = super.getChangedValue(anotherObject.a8_street,object.a8_street);
		object.a9_number = super.getChangedValue(anotherObject.a9_number,object.a9_number);
		object.a10_compl1type = super.getChangedValue(anotherObject.a10_compl1type,object.a10_compl1type);
		object.a11_compl1desc = super.getChangedValue(anotherObject.a11_compl1desc,object.a11_compl1desc);
		object.a12_compl2type = super.getChangedValue(anotherObject.a12_compl2type,object.a12_compl2type);
		object.a13_compl2desc = super.getChangedValue(anotherObject.a13_compl2desc,object.a13_compl2desc);
		object.a14_reference = super.getChangedValue(anotherObject.a14_reference,object.a14_reference);
		object.a15_clientid = super.getChangedValue(anotherObject.a15_clientid,object.a15_clientid);
		object.a16_solicitationid = 
			super.getChangedValue(anotherObject.a16_solicitationid,object.a16_solicitationid); 
		object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
		return object;
	}

}