export class Solicitation {
	constructor(
		public id: number, 
		public conditions: string, 
		public a1_name: string,
		public a3_cpf: string,
		public a4_cnpj: string,
		public a2_caracteristic: string,
		public a5_cep: string,
		public a6_uf: string,
		public a7_city: string,
		public a8_street: string,
		public a9_number: string,
		public a10_compl1type: string,
		public a11_compl1desc: string,
		public a12_compl2type: string,
		public a13_compl2desc: string,
		public a14_reference: string,
		public a15_clientid: number,
		public active: boolean,
		public activeLabel: string,
		public ownerId: number,
		public _token: string,
		public objectClass: string
	) { 
	}
}