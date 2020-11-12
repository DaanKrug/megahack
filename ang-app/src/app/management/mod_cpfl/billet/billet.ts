export class Billet {
	constructor(
		public id: number, 
		public conditions: string, 
		public a1_clientid: number,
		public a2_consumerunitid: number,
		public a3_value: number,
		public a4_billingdate: string,
		public active: boolean,
		public a3_valueLabel: string,
		public a4_billingdateLabel: string,
		public activeLabel: string,
		public ownerId: number,
		public _token: string,
		public objectClass: string
	) { 
	}
}