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
solicitation object - fields for "create" and "update"
solicitation {
	a1_name: string - * *1
	a3_cpf: string - ** *1
	a4_cnpj: string - ** *1
	a2_caracteristic: string - * 
	a5_cep: string - * 
	a6_uf: string - * 
	a7_city: string - * 
	a8_street: string - * 
	a9_number: string - * 
	a10_compl1type: string - x
	a11_compl1desc: string - x
	a12_compl2type: string - x
	a13_compl2desc: string - x
	a14_reference: string - x
	a15_clientid: number - * *1
}
- * Required
- ** One of all required
- x Optional
- come from "client" object *1


this.a2_caracteristics = [
	{value: 'l1', label: 'Ligação para casa ou comércio, em local com até duas instalações'},
	{value: 'l2', label: 'Ligação para apartamentos residenciais ou sala/loja comercial em edifícios e galerias'},
	{value: 'l3', label: 'Ligação de projeto para loteamentos'},
	{value: 'l4', label: 'Ligação de projeto edifícios'}
];
this.a10_compl1types = [
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
this.a12_compl2types = [
	{value: 'acesso', label: 'Acesso'},
	{value: 'andar', label: 'Andar'},
	{value: 'anexo', label: 'Anexo'},
	{value: 'clube', label: 'Clube'},
	{value: 'colegio', label: 'Colégio'},
	{value: 'colonia', label: 'Colônia'},
	{value: 'cruzamento', label: 'Cruzamento'}
]; 
**/
const SolicitationService = {
	getUrlBase(){
		return '/solicitations';
	},
	create(solicitation: any){// return responseobject
		const url = SolicitationService.getUrlBase();
		solicitation.id = -1;
		return BaseCrudService.makeRequestToAPI(url,'post',solicitation)
						      .then(response => { return response; });
	},
	update(id: number,solicitation: any){// return responseobject
		const url = SolicitationService.getUrlBase() + '/' + id;
		return BaseCrudService.makeRequestToAPI(url,'put',solicitation)
						      .then(response => { return response; });
	},
	getAll(page: number,rowsPerPage: number,conditions: string){// return solicitation[] - use -1,-1,conditions for load all
		const url = SolicitationService.getUrlBase() + '/' + page + '/' + rowsPerPage;
		return BaseCrudService.makeRequestToAPI(url,'post',{conditions: conditions})
						      .then(response => { return response; });
	},
	load(id){// return responseobject
		const url = SolicitationService.getUrlBase() + '/' + id;
		return BaseCrudService.makeRequestToAPI(url,'post',{})
						      .then(response => { return response; });
	},
};
export default SolicitationService;

