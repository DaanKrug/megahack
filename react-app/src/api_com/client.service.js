import BaseCrudService from './base/basecrud.service.js';

/**
responseobject - various types
if dont pass in some validation
{
  objectClass: "ValidationResult",
  code: codeReturn,                     // Variated codes
  msg: msgResult
}
if fail
{
  objectClass: "OperationError",
  code: 500,                            // always 500
  msg: msgError
}
if sucess
{
  objectClass: "OperationSuccess",
  code: codeReturn,                     // 200 for "create", 201 for "update", 204 for "delete"
  msg: msgSucess,
  object: objectReturn                  // used for log registration in backend logic. Ignore it here.
}
client object - fields for "create" and "update"
{
	a1_name: string - *
	a2_type: string - *
	a3_cpf: string - **
	a4_cnpj: string- *
	a5_birthdate: string - *
	a6_doctype: string - *
	a7_document: string - *
	a8_gender: string - *
	a9_email: string - x
	a10_phone: string - *
	a11_cep: string - *
	a12_uf: string - *
	a13_city: string - *
	a14_street: string - *
	a15_number: string - x
	a16_compl1type: string - x
	a17_compl1desc: string - x
	a18_compl2type: string - x
	a19_compl2desc: string - x
}
- * Required
- ** One of all required
- x Optional

this.a2_types = [
	{value: 'PF', label: 'Pessoa Física'},
	{value: 'PJ', label: 'Pessoa Jurídica'}
];
this.a6_doctypes = [
	{value: 'rg', label: 'RG'},
	{value: 'cnh', label: 'CNH'},
	{value: 'passport', label: 'Passaporte'},
	{value: 'reservistcart', label: 'Carteira de Reservista'},
	{value: 'workcart', label: 'Carteira de Trabalho'},
	{value: 'nre', label: 'Número de Registro de Estrangeiro'},
];
this.a8_genders = [
	{value: 'men', label: 'Masculino'},
	{value: 'women', label: 'Feminino'},
	{value: 'unknow', label: 'Outro'}
];
this.a16_compl1types = [
	{value: 'adminstracao', label: 'Administração'},
	{value: 'altos', label: 'Altos'},
	{value: 'apartamento', label: 'Apartamento'},
	{value: 'armazem', label: 'Armazém'},
	{value: 'baixos', label: 'Balcão'},
	{value: 'bancajornal', label: 'Banca de Jornal'},
	{value: 'barraca', label: 'Barraca'},
	{value: 'barracao', label: 'Barracão'},
	{value: 'bilheteria', label: 'Bilheteria'},
	{value: 'loja', label: 'Loja'},
	{value: 'lote', label: 'Lote'},
	{value: 'sala', label: 'Sala'},
	{value: 'salao', label: 'Salão'}
];
this.a18_compl2types = [
	{value: 'acesso', label: 'Acesso'},
	{value: 'andar', label: 'Andar'},
	{value: 'anexo', label: 'Anexo'},
	{value: 'clube', label: 'Clube'},
	{value: 'colegio', label: 'Colégio'},
	{value: 'colonia', label: 'Colônia'},
	{value: 'cruzamento', label: 'Cruzamento'}
]; 
**/
const ClientService = {
	getUrlBase(){
		return '/clients';
	},
	create(client: any){// return responseobject
		const url = ClientService.getUrlBase();
		return BaseCrudService.makeRequestToAPI(url,'post',client)
						      .then(response => { return response; });
	},
	update(id: number,client: any){// return responseobject
		const url = ClientService.getUrlBase() + '/' + id;
		return BaseCrudService.makeRequestToAPI(url,'put',client)
						      .then(response => { return response; });
	},
	getAll(page: number,rowsPerPage: number,conditions: string){// return client[] - use -1,-1,conditions for load all
		const url = ClientService.getUrlBase() + '/' + page + '/' + rowsPerPage;
		return BaseCrudService.makeRequestToAPI(url,'post',{conditions: conditions})
						      .then(response => { return response; });
	},
	load(id){// return responseobject
		const url = ClientService.getUrlBase() + '/' + id;
		return BaseCrudService.makeRequestToAPI(url,'post',{})
						      .then(response => { return response; });
	},
};
export default ClientService;

