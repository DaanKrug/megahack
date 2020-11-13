import React from 'react';

import ClientService from '../api_com/client.service.js';
import SolicitationService from '../api_com/solicitation.service.js';
import CitiesUtil from '../util/cities.util.js';

import InputCorrector from '../component/corrector/input.corrector.js';
import InputText from '../component/inputtext.js';
import RadioButton from '../component/radiobutton.js';
import SelectBox from '../component/selectbox.js';

import '../css/solicitacao.css';

const alphaE: string[] = [
	'Ñ','Ã','Á','À','Â','Ä','É','È','Ê','Ë','Í','Ì','Î','Ï','Õ','Ó','Ò','Ô','Ö','Ú','Ù','Û','Ü','Ç'
];
const alphae: string[] = [
	'ñ','ã','á','à','â','ä','é','è','ê','ë','í','ì','î','ï','õ','ó','ò','ô','ö','ú','ù','û','ü','ç'
];
const alphaA: string[] = [
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
];
const alphaa: string[] = [
	'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'
];
const numbers: string[] = ['0','1','2','3','4','5','6','7','8','9'];
const specials: string[] = [
	'(',')','*','-','+','%','@','_','.',',','$',':',' ','|',';','/','\\','?','=','&','[',']','{','}'
];
const alphas = alphaA.concat(alphaa).concat(alphaE).concat(alphae).concat([' ']);
const doubles = numbers.concat([',','-']);
const dates = numbers.concat(['/']);


const OnlyAlphaCorrector = new InputCorrector(alphas);
const OnlyNumberCorrector = new InputCorrector(numbers);
const AlphaNumberCorrector = new InputCorrector(alphas.concat(numbers).concat(specials));
const DateCorrector = new InputCorrector(numbers.concat(['/']));
const DocumentCorrector = new InputCorrector(numbers.concat(['.','-']));
const CpfCorrector = new InputCorrector(numbers.concat(['.','-']));
const CnpjCorrector = new InputCorrector(numbers.concat(['.','-','/']));
const EmailCorrector = new InputCorrector(alphaA.concat(alphaa).concat(numbers).concat(['@','.','-','_']));
const PhoneCorrector = new InputCorrector(numbers.concat([' ','-','(',')']));
const CepCorrector = new InputCorrector(numbers.concat(['-']));

export default class SolicitationForm extends React.Component{
	
	a2_caracteristics: any[];
	a2_types: any[];
	a6_doctypes: any[];
	a8_genders: any[];
	a16_compl1types: any[];
	a18_compl2types: any[];
    client: any;
    statesOptions: any[];
    citiesOptions: any[];
	statesOptions2: any[];
	citiesOptions2: any[];
	
	constructor(props){
		super(props);
		this.client = null;
		this.a2_caracteristics = [
			{value: 'l1', label: 'Ligação para casa ou comércio, em local com até duas instalações'},
			{value: 'l2', label: 'Ligação para apartamentos residenciais ou sala/loja comercial em edifícios e galerias'},
			{value: 'l3', label: 'Ligação de projeto para loteamentos'},
			{value: 'l4', label: 'Ligação de projeto edifícios'}
		];
		this.a2_types = [
			{value: 'PF', label: 'C.P.F'},
			{value: 'PJ', label: 'C.N.P.J.'}
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
			{value: 'M', label: 'Masculino'},
			{value: 'F', label: 'Feminino'},
			{value: 'O', label: 'Outro'}
		];
		this.a16_compl1types = [
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
		this.a18_compl2types = [
			{value: '', label: ''},
			{value: 'acesso', label: 'Acesso'},
			{value: 'andar', label: 'Andar'},
			{value: 'anexo', label: 'Anexo'},
			{value: 'clube', label: 'Clube'},
			{value: 'colegio', label: 'Colégio'},
			{value: 'colonia', label: 'Colônia'},
			{value: 'cruzamento', label: 'Cruzamento'}
		]; 
		this.statesOptions = CitiesUtil.getStateOptions();
		this.citiesOptions = [];
		this.statesOptions2 = CitiesUtil.getStateOptions();
		this.citiesOptions2 = [];
		this.state = {
			key: new Date().getTime(),
			a1_name: '',
			a2_type: this.a2_types[0].value,
			a3_cpf: '',
			a4_cnpj: '',
			a5_birthdate: '',
			a6_doctype: '',
			a7_document: '',
			a8_gender: '',
			a9_email: '',
			a10_phone: '',
			a11_cep: '',
			a12_uf: '',
			a13_city: '',
			a14_street: '',
			a15_number: '',
			a16_compl1type: '',
			a17_compl1desc: '',
			a18_compl2type: '',
			a19_compl2desc: '',
			tab: 0,
			s_a2_caracteristic: '',
			s_a5_cep: '',
			s_a6_uf: '',
			s_a7_city: '',
			s_a8_street: '',
			s_a9_number: '',
			s_a10_compl1type: '',
			s_a11_compl1desc: '',
			s_a12_compl2type: '',
			s_a13_compl2desc: '',
			s_a14_reference: '',
			errorMsg: '',
			successMsg: '',
		};
	}
	
	setValidationMessage(response){
		this.setState({errorMsg: response.msg, sucessMsg: '', key: new Date().getTime()});
	}
	
	setSuccesMessage(msg){
		this.setState({errorMsg: '', successMsg: msg, key: new Date().getTime()});
	}
	
	loadClientAndNext(){
		this.setProcessing(true);
		if(this.state.a2_type === 'PF'){
			ClientService.loadByCpf(this.state.a3_cpf).then(client => {
				this.setClientData(client);
				this.setProcessing(false);
				let newTab = null === this.client ? 1 : 3;
				this.setState({tab: newTab, key: new Date().getTime()});
			});
			return;
		}
		ClientService.loadByCnpj(this.state.a4_cnpj).then(client => {
			this.setClientData(client);
			this.setProcessing(false);
			let newTab = null === this.client ? 1 : 3;
			this.setState({tab: newTab, key: new Date().getTime()});
		});
	}
	
	previousStep(){
		if(this.state.tab === 0){
			return;
		}
		let newTab = null === this.client ? this.state.tab - 1 : this.state.tab - 3;
		if(newTab === 0){
			this.client = null;
			this.valueChanged('a3_cpf','');
		}
		this.setState({tab: newTab, key: new Date().getTime()});
	}
	
	nextStep(){
		if(this.state.tab === 3){
			return;
		}
		let newTab = this.state.tab + 1;
		if(newTab === 1){
			this.loadClientAndNext();
			return;
		}
		if(newTab === 3 && null === this.client){
			let client = {
				a1_name: this.state.a1_name,
				a2_type: this.state.a2_type,
				a3_cpf: this.state.a3_cpf,
				a4_cnpj: this.state.a4_cnpj,
				a5_birthdate: this.state.a5_birthdate,
				a6_doctype: this.state.a6_doctype,
				a7_document: this.state.a7_document,
				a8_gender: this.state.a8_gender,
				a9_email: this.state.a9_email,
				a10_phone: this.state.a10_phone,
				a11_cep: this.state.a11_cep,
				a12_uf: this.state.a12_uf,
				a13_city: this.state.a13_city,
				a14_street: this.state.a14_street,
				a15_number: this.state.a15_number,
				a16_compl1type: this.state.a16_compl1type,
				a17_compl1desc: this.state.a17_compl1desc,
				a18_compl2type: this.state.a18_compl2type,
				a19_compl2desc: this.state.a19_compl2desc
			};
			this.setProcessing(true);
			ClientService.create(client).then(response => {
				if(response.code !== 200){
					this.setProcessing(false);
					this.setValidationMessage(response);
					return;
				}
				this.loadClientAndNext();
			});
			return;
		}
		this.setState({tab: newTab, key: new Date().getTime()});
		
	}
	
	createSolicitation(){
		let solicitation = {
			a1_name: this.client.a1_name,
			a3_cpf: this.client.a3_cpf,
			a4_cnpj: this.client.a4_cnpj,
			a2_caracteristic: this.state.s_a2_caracteristic,
			a5_cep: this.state.s_a5_cep,
			a6_uf: this.state.s_a6_uf,
			a7_city: this.state.s_a7_city, 
			a8_street: this.state.s_a8_street, 
			a9_number: this.state.s_a9_number,
			a10_compl1type: this.state.s_a10_compl1type,
			a11_compl1desc: this.state.s_a11_compl1desc,
			a12_compl2type: this.state.s_a12_compl2type,
			a13_compl2desc: this.state.s_a13_compl2desc,
			a14_reference: this.state.s_a14_reference,
			a15_clientid: this.client.id
		};
		this.setProcessing(true);
		SolicitationService.create(solicitation).then(response => {
			this.setProcessing(false);
			if(response.code !== 200){
				this.setValidationMessage(response);
				return;
			}
			this.setState({tab: 0, key: new Date().getTime()});
			this.setSuccesMessage('Solicitação Efetuada com Sucesso!');
		});
	}
	
	valueChanged(id,value){
		if(id === 'a1_name'){
			this.setState({a1_name: value});
		}
		if(id === 'a2_type'){
			this.setState({a2_type: value, key: new Date().getTime()});
		}
		if(id === 'a3_cpf'){
			this.setState({a3_cpf: value, a4_cnpj: ''});
		}
		if(id === 'a4_cnpj'){
			this.setState({a3_cpf: '', a4_cnpj: value});
		}
		if(id === 'a5_birthdate'){
			this.setState({a5_birthdate: value});
		}
		if(id === 'a6_doctype'){
			this.setState({a6_doctype: value});
		}
		if(id === 'a7_document'){
			this.setState({a7_document: value});
		}
		if(id === 'a8_gender'){
			this.setState({a8_gender: value});
		}
		if(id === 'a9_email'){
			this.setState({a9_email: value.toLowerCase()});
		}
		if(id === 'a10_phone'){
			this.setState({a10_phone: value});
		}
		if(id === 'a11_cep'){
			this.setState({a11_cep: value});
		}
		if(id === 'a12_uf'){
			this.citiesOptions = value.trim() === '' 
				               ? [{value: '', label: ''}] 
			                   :  CitiesUtil.getCitiesOptions(value);
		    this.setState({a12_uf: value, a13_city: this.citiesOptions[0].value, key: new Date().getTime()});
		}
		if(id === 'a13_city'){
			this.setState({a13_city: value});
		}
		if(id === 'a14_street'){
			this.setState({a14_street: value});
		}
		if(id === 'a15_number'){
			this.setState({a15_number: value});
		}
		if(id === 'a16_compl1type'){
			this.setState({a16_compl1type: value, key: new Date().getTime()});
		}
		if(id === 'a17_compl1desc'){
			this.setState({a17_compl1desc: value});
		}
		if(id === 'a18_compl2type'){
			this.setState({a18_compl2type: value, key: new Date().getTime()});
		}
		if(id === 'a19_compl2desc'){
			this.setState({a19_compl2desc: value});
		}
		if(id === 's_a2_caracteristic'){
			this.setState({s_a2_caracteristic: value});
		}
		if(id === 's_a5_cep'){
			this.setState({s_a5_cep: value});
		}
		if(id === 's_a6_uf'){
			this.citiesOptions2 = value.trim() === '' 
				               ? [{value: '', label: ''}] 
			                   :  CitiesUtil.getCitiesOptions(value);
		    this.setState({s_a6_uf: value, s_a7_city: this.citiesOptions[0].value, key: new Date().getTime()});
		}
		if(id === 's_a7_city'){
			this.setState({s_a7_city: value});
		}
		if(id === 's_a8_street'){
			this.setState({s_a8_street: value});
		}
		if(id === 's_a9_number'){
			this.setState({s_a9_number: value});
		}
		if(id === 's_a10_compl1type'){
			this.setState({s_a10_compl1type: value, key: new Date().getTime()});
		}
		if(id === 's_a11_compl1desc'){
			this.setState({s_a11_compl1desc: value});
		}
		if(id === 's_a12_compl2type'){
			this.setState({s_a12_compl2type: value, key: new Date().getTime()});
		}
		if(id === 's_a13_compl2desc'){
			this.setState({s_a13_compl2desc: value});
		}
		if(id === 's_a14_reference'){
			this.setState({s_a14_reference: value});
		}
	}
	
	setProcessing(block){
		// show|hide a shadow mask and a loading icon
	}
	
	setClientData(client){
		this.client = client;
		this.valueChanged('a1_name',null != client ? client.a1_name : '');
		this.valueChanged('a5_birthdate',null != client ? client.a5_birthdate : '');
		this.valueChanged('a6_doctype',null != client ? client.a6_doctype : '');
		this.valueChanged('a7_document',null != client ? client.a7_document : '');
		this.valueChanged('a8_gender',null != client ? client.a8_gender : '');
		this.valueChanged('a9_email',null != client ? client.a9_email : '');
		this.valueChanged('a10_phone',null != client ? client.a10_phone : '');
		this.valueChanged('a11_cep',null != client ? client.a11_cep : '');
		this.valueChanged('a12_uf',null != client ? client.a12_uf : '');
		this.valueChanged('a13_city',null != client ? client.a13_city : '');
		this.valueChanged('a14_street',null != client ? client.a14_street : '');
		this.valueChanged('a15_number',null != client ? client.a15_number : '');
		this.valueChanged('a16_compl1type',null != client ? client.a16_compl1type : '');
		this.valueChanged('a17_compl1desc',null != client ? client.a17_compl1desc : '');
		this.valueChanged('a18_compl2type',null != client ? client.a18_compl2type : '');
		this.valueChanged('a19_compl2desc',null != client ? client.a19_compl2desc : '');
	}
	
	render(){
		let clazzTab0 = this.state.tab === 0 ? 'nav-link active' : 'nav-link';
		let clazzTab1 = this.state.tab === 1 ? 'nav-link active' : 'nav-link';
		let clazzTab2 = this.state.tab === 2 ? 'nav-link active' : 'nav-link';
		let clazzTab3 = this.state.tab === 3 ? 'nav-link active' : 'nav-link';
		let clazzTab4 = this.state.tab === 4 ? 'nav-link active' : 'nav-link';
		let clazzPanel0 = this.state.tab === 0 ? 'card' : 'none';
		let clazzPanel1 = this.state.tab === 1 ? 'card' : 'none';
		let clazzPanel2 = this.state.tab === 2 ? 'card' : 'none';
		let clazzPanel3 = this.state.tab === 3 ? 'card' : 'none';
		let clazzPanel4 = this.state.tab === 4 ? 'card' : 'none';
		if(null !== this.client){
			clazzTab1 = 'none';
			clazzTab2 = 'none';
			clazzPanel1 = 'none';
			clazzPanel2 = 'none';
		}
		return(
			<div className="dataForm"
				 key={this.state.key}>
				<h3>Solicitação de Nova Instalação</h3>
				<div>
					<ul className="tabs" 
						style={{'margin-left':'.5em'}}>
						<li>
							<span className={clazzTab0}>
						   	    CPF/CNPJ
							</span>
						</li>
						<li>
							<span className={clazzTab1}>
						   	    Dados Pessoais
							</span>
						</li>
						<li>
							<span className={clazzTab2}>
						   	    Endereço
							</span>
						</li>
						<li>
							<span className={clazzTab3}>
						   	    Endereço Nova Instalação
							</span>
						</li>
					</ul>
					<div className="clear" 
						 style={{'marginBottom':'.4em'}}>
					</div>
				</div>
				<div className={clazzPanel0}>
					<h4>Informe CPF ou CNPJ</h4>
					<RadioButton id="a2_type" 
						         defaultValue={this.state.a2_type}
						         options={this.a2_types}
						         handler={this}>
					</RadioButton>
					<InputText id="a3_cpf" 
						       noRender={this.state.a2_type !== 'PF'}
						       corrector={CpfCorrector}
						       maxlength="14"
					           handler={this}>
					</InputText>
					<InputText id="a4_cnpj" 
						       noRender={this.state.a2_type !== 'PJ'}
						       corrector={CnpjCorrector}
					           maxlength="18"
					           handler={this}>
					</InputText>
				</div>
				<div className={clazzPanel1}>
					<h4>Informe os Dados Pessoais</h4>
					<div className={null !== this.client ? 'alert-info' : 'none'}>
						Encontramos seu cadastro. Para alterar os dados realize 
						solicitação de alteração de dados pessoais.
					</div>
					<InputText id="a1_name" 
						       label="Nome"
						       defaultValue={this.state.a1_name}
						       corrector={OnlyAlphaCorrector}
					           readOnly={null !== this.client}
					           handler={this}>
					</InputText>
					<InputText id="a5_birthdate" 
						       label="Data de Nascimento"
						       defaultValue={this.state.a5_birthdate}
						       corrector={DateCorrector}
							   readOnly={null !== this.client}
					           handler={this}>
					</InputText>
					<SelectBox id="a6_doctype"
						       label="Tipo Outro Documento"
						       defaultValue={this.state.a6_doctype}
						       options={this.a6_doctypes}
					           readOnly={null !== this.client}
						       handler={this}>
					</SelectBox>
					<InputText id="a7_document" 
						       label="Número Outro Documento"
						       defaultValue={this.state.a7_document}
						       corrector={DocumentCorrector}
					           readOnly={null !== this.client}
					           handler={this}>
					</InputText>
					<SelectBox id="a8_gender"
						       label="Sexo/Gênero"
						       defaultValue={this.state.a8_gender}
						       options={this.a8_genders}
					           readOnly={null !== this.client}
						       handler={this}>
					</SelectBox>
					<InputText id="a9_email" 
						       label="E-mail"
						       defaultValue={this.state.a9_email}
						       corrector={EmailCorrector}
					           readOnly={null !== this.client}
					           handler={this}>
					</InputText>
					<InputText id="a10_phone" 
						       label="Telefone(s)"
						       defaultValue={this.state.a10_phone}
						       corrector={PhoneCorrector}
					           readOnly={null !== this.client}
					           handler={this}>
					</InputText>
				</div>
				<div className={clazzPanel2}>
					<h4>Informe O Seu Endereço</h4>
					<div className={null !== this.client ? 'alert-info' : 'none'}>
						Encontramos seu cadastro. Para alterar os dados realize 
						solicitação de alteração de dados pessoais.
					</div>
					<InputText id="a11_cep" 
						       label="CEP"
						       defaultValue={this.state.a11_cep}
						       corrector={CepCorrector}
					           maxlength="9"
					           readOnly={null !== this.client}
					           handler={this}>
					</InputText>
					<SelectBox id="a12_uf"
						       label="Estado/UF"
						       defaultValue={this.state.a12_uf}
						       options={this.statesOptions}
					           readOnly={null !== this.client}
						       handler={this}>
					</SelectBox>
					<SelectBox id="a13_city" 
						       label="Cidade"
						       defaultValue={this.state.a13_city}
					           options={this.citiesOptions}
					           readOnly={null !== this.client}
					           handler={this}>
					</SelectBox>
					<InputText id="a14_street" 
						       label="Logradouro"
						       defaultValue={this.state.a14_street}
						       corrector={OnlyAlphaCorrector}
					           readOnly={null !== this.client}
					           handler={this}>
					</InputText>
					<InputText id="a15_number" 
						       label="Número"
						       defaultValue={this.state.a15_number}
						       corrector={OnlyNumberCorrector}
					           readOnly={null !== this.client}
					           handler={this}>
					</InputText>
					<SelectBox id="a16_compl1type"
						       label="Complemento 1 Tipo"
						       defaultValue={this.state.a16_compl1type}
						       options={this.a16_compl1types}
					           readOnly={null !== this.client}
						       handler={this}>
					</SelectBox>
					<InputText id="a17_compl1desc" 
						       label="Complemento 1 Descrição"
						       defaultValue={this.state.a17_compl1desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={null !== this.client || this.state.a16_compl1type.trim() === ''}
					           handler={this}>
					</InputText>
					<SelectBox id="a18_compl2type"
						       label="Complemento 2 Tipo"
						       defaultValue={this.state.a18_compl2type}
						       options={this.a18_compl2types}
					           readOnly={null !== this.client}
						       handler={this}>
					</SelectBox>
					<InputText id="a19_compl2desc" 
						       label="Complemento 2 Descrição"
						       defaultValue={this.state.a19_compl2desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={null !== this.client || this.state.a18_compl2type.trim() === ''}
					           handler={this}>
					</InputText>
				</div>
				<div className={clazzPanel3}>
					<h4>Informe O Endereço Da Nova Instalação</h4>
					<SelectBox id="s_a2_caracteristic"
						       label="Característica da Instalação"
						       defaultValue={this.state.s_a2_caracteristic}
						       options={this.a2_caracteristics}
						       handler={this}>
					</SelectBox>
					<InputText id="s_a5_cep" 
						       label="CEP"
						       defaultValue={this.state.s_a5_cep}
						       corrector={CepCorrector}
					           maxlength="9"
					           handler={this}>
					</InputText>
					<SelectBox id="s_a6_uf"
						       label="Estado/UF"
						       defaultValue={this.state.s_a6_uf}
						       options={this.statesOptions2}
						       handler={this}>
					</SelectBox>
					<SelectBox id="s_a7_city" 
						       label="Cidade"
						       defaultValue={this.state.s_a7_city}
					           options={this.citiesOptions2}
					           handler={this}>
					</SelectBox>
					<InputText id="s_a8_street" 
						       label="Logradouro"
						       defaultValue={this.state.s_a8_street}
						       corrector={OnlyAlphaCorrector}
					           handler={this}>
					</InputText>
					<InputText id="s_a9_number" 
						       label="Número"
						       defaultValue={this.state.s_a9_number}
						       corrector={OnlyNumberCorrector}
					           handler={this}>
					</InputText>
					<SelectBox id="s_a10_compl1type"
						       label="Complemento 1 Tipo"
						       defaultValue={this.state.s_a10_compl1type}
						       options={this.a16_compl1types}
						       handler={this}>
					</SelectBox>
					<InputText id="s_a11_compl1desc" 
						       label="Complemento 1 Descrição"
						       defaultValue={this.state.s_a11_compl1desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={this.state.s_a10_compl1type.trim() === ''}
					           handler={this}>
					</InputText>
					<SelectBox id="s_a12_compl2type"
						       label="Complemento 2 Tipo"
						       defaultValue={this.state.s_a12_compl2type}
						       options={this.a18_compl2types}
						       handler={this}>
					</SelectBox>
					<InputText id="s_a13_compl2desc" 
						       label="Complemento 2 Descrição"
						       defaultValue={this.state.s_a13_compl2desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={this.state.s_a12_compl2type.trim() === ''}
					           handler={this}>
					</InputText>
					<InputText id="s_a14_reference" 
						       label="Referência"
						       defaultValue={this.state.s_a14_reference}
						       corrector={OnlyAlphaCorrector}
					           handler={this}>
					</InputText>
				</div>
				
				<div className={this.state.errorMsg !== '' ? 'alert-danger' : 'none'}> 
					{this.state.errorMsg}
				</div>
				<div className={this.state.successMsg !== '' ? 'alert-info' : 'none'}> 
					{this.state.successMsg}
				</div>
				
				<div className="buttons clear"> 
					<button className="btn btn-primary clickable"
						    onClick={() => {this.previousStep();}}>
					    <i className="fas fa-backward"></i>
						<span style={{'marginLeft':'1em;'}}>
							Anterior
						</span>
					</button>  
					<button className={this.state.tab === 3 ? 'none' : 'btn btn-primary clickable'}
						    onClick={() => {this.nextStep();}}>
						<span style={{'marginRight':'1em;'}}>
							Seguinte
						</span>
						<i className="fas fa-forward"></i>
					</button>  
					<button className={this.state.tab !== 3 ? 'none' : 'btn btn-primary clickable'}
						    onClick={() => {this.createSolicitation();}}>
					    <i className="fas fa-check-double"></i>
						<span style={{'marginRight':'1em;'}}>
							Confirmar Envio da Solicitação
						</span>
					</button>  
				</div>
			</div>
		);
	}
	
}