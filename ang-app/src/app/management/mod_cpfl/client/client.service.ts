import { Client } from './client';
import { BaseCrudService } from '../../../../app_base/basecrud.service';

export class ClientService extends BaseCrudService {

	getUrl(){
		return this.getBase() + '/clients';
	}

	getUrlForCache(){
		return this.getUrl();
	}

	getEmptyObject(conditions) :Object{
		var ownerId: number = 
			parseInt('0' + this.storageService.localStorageGetItem('_ownerId_' + this.getAppId()));
		return new Client(0,conditions,
		                  null,null,null,null,null,null,null,null,null,null,null,null,
		                  null,null,null,null,null,null,null,'null',
		                  ownerId,
		                  this.storageService.localStorageGetItem('_token_' + this.getAppId()),null);
	}

	getAll(page,rows,conditions): Promise<Client[]> {
		return new Promise<Client[]>(r => r(super.getAll(page,rows,this.getEmptyObject(conditions))));
	}

	load(id): Promise<Client> {
		return new Promise<Client>(r => r(super.load(id)));
	} 

	mergeAnotherInObject(object,anotherObject){
		object.a1_name = super.getChangedValue(anotherObject.a1_name,object.a1_name);
		object.a2_type = super.getChangedValue(anotherObject.a2_type,object.a2_type);
		object.a3_cpf = super.getChangedValue(anotherObject.a3_cpf,object.a3_cpf);
		object.a4_cnpj = super.getChangedValue(anotherObject.a4_cnpj,object.a4_cnpj);
		object.a5_birthdate = super.getChangedValue(anotherObject.a5_birthdate,object.a5_birthdate);
		object.a6_doctype = super.getChangedValue(anotherObject.a6_doctype,object.a6_doctype);
		object.a7_document = super.getChangedValue(anotherObject.a7_document,object.a7_document);
		object.a8_gender = super.getChangedValue(anotherObject.a8_gender,object.a8_gender);
		object.a9_email = super.getChangedValue(anotherObject.a9_email,object.a9_email);
		object.a10_phone = super.getChangedValue(anotherObject.a10_phone,object.a10_phone);
		object.a11_cep = super.getChangedValue(anotherObject.a11_cep,object.a11_cep);
		object.a12_uf = super.getChangedValue(anotherObject.a12_uf,object.a12_uf);
		object.a13_city = super.getChangedValue(anotherObject.a13_city,object.a13_city);
		object.a14_street = super.getChangedValue(anotherObject.a14_street,object.a14_street);
		object.a15_number = super.getChangedValue(anotherObject.a15_number,object.a15_number);
		object.a16_compl1type = super.getChangedValue(anotherObject.a16_compl1type,object.a16_compl1type);
		object.a17_compl1desc = super.getChangedValue(anotherObject.a17_compl1desc,object.a17_compl1desc);
		object.a18_compl2type = super.getChangedValue(anotherObject.a18_compl2type,object.a18_compl2type);
		object.a19_compl2desc = super.getChangedValue(anotherObject.a19_compl2desc,object.a19_compl2desc); 
		object.a5_birthdateLabel = 
			super.getChangedValue(anotherObject.a5_birthdateLabel,object.a5_birthdateLabel);
		object.ownerId = super.getChangedValue(anotherObject.ownerId,object.ownerId);
		return object;
	}

}