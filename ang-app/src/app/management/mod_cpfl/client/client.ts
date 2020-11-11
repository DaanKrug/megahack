export class Client {
	constructor(
		public id: number, 
		public conditions: string, 
		public a1_name: string,
		public a2_type: string,
		public a3_cpf: string,
		public a4_cnpj: string,
		public a5_birthdate: string,
		public a6_doctype: string,
		public a7_document: string,
		public a8_gender: string,
		public a9_email: string,
		public a10_phone: string,
		public a11_cep: string,
		public a12_uf: string,
		public a13_city: string,
		public a14_street: string,
		public a15_number: string,
		public a16_compl1type: string,
		public a17_compl1desc: string,
		public a18_compl2type: string,
		public a19_compl2desc: string,
		public a5_birthdateLabel: string,
		public ownerId: number,
		public _token: string,
		public objectClass: string
	) { 
	}
}