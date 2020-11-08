export class Additionaluserinfo {
	constructor(
		public id: number, 
		public conditions: string, 
		public a1_rg: string,
		public a2_cpf: string,
		public a3_cns: string,
		public a4_phone: string,
		public a5_address: string,
		public a6_otherinfo: string,
		public a7_userid: number,
		public ownerId: number,
		public _token: string,
		public objectClass: string
	) { 
	}
}