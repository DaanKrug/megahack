const SolicitationHelper = {
	getA2_caracteristics(){
		return [
			{value: 'l1', label: 'Ligação para casa ou comércio, em local com até duas instalações'},
			{value: 'l2', label: 'Ligação para apartamentos residenciais ou sala/loja comercial em edifícios e galerias'},
			{value: 'l3', label: 'Ligação de projeto para loteamentos'},
			{value: 'l4', label: 'Ligação de projeto edifícios'}
		];
	},
	getA2_types(){
		return [
			{value: 'PF', label: 'C.P.F'},
			{value: 'PJ', label: 'C.N.P.J.'}
		];
	},
	getA6_doctypes(){
		return [
			{value: 'rg', label: 'RG'},
			{value: 'cnh', label: 'CNH'},
			{value: 'passport', label: 'Passaporte'},
			{value: 'reservistcart', label: 'Carteira de Reservista'},
			{value: 'workcart', label: 'Carteira de Trabalho'},
			{value: 'nre', label: 'Número de Registro de Estrangeiro'},
		];
	},
	getA8_genders(){
		return [
			{value: 'M', label: 'Masculino'},
			{value: 'F', label: 'Feminino'},
			{value: 'O', label: 'Outro'}
		];
	},
	getA16_compl1types(){
		return [
			{value: '', label: ''},
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
	},
	getA18_compl2types(){
		return [
			{value: '', label: ''},
			{value: 'acesso', label: 'Acesso'},
			{value: 'andar', label: 'Andar'},
			{value: 'anexo', label: 'Anexo'},
			{value: 'clube', label: 'Clube'},
			{value: 'colegio', label: 'Colégio'},
			{value: 'colonia', label: 'Colônia'},
			{value: 'cruzamento', label: 'Cruzamento'}
		]; 
	}
};
export default SolicitationHelper;