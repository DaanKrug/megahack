import React from 'react';

import ClientService from '../api_com/client.service.js';
import SolicitationService from '../api_com/solicitation.service.js';
import ViaCepService from '../api_com/external/viacep.service.js';
import AwsRekognitionService from '../api_com/awsrekognition.service.js';

import SolicitationHelper from './helper/solicitation.helper.js';

import CitiesUtil from '../util/cities.util.js';

import CpfMask from '../component/mask/cpf.mask.js';
import CnpjMask from '../component/mask/cnpj.mask.js';
import CepMask from '../component/mask/cep.mask.js';
import DateMask from '../component/mask/date.mask.js';
import DocumentMask from '../component/mask/document.mask.js';
import RgMask from '../component/mask/rg.mask.js';

import InputText from '../component/inputtext.js';
import RadioButton from '../component/radiobutton.js';
import SelectBox from '../component/selectbox.js';
import InputUpload from '../component/inputupload.js';
import InputCorrector from '../component/corrector/input.corrector.js';

import '../css/solicitacao2.css';

const OnlyAlphaCorrector = new InputCorrector('alpha');
const AlphaNumberCorrector = new InputCorrector('alphanum');
const EmailCorrector = new InputCorrector('email');
const PhoneCorrector = new InputCorrector('phone');

const imgErrorMsg = 'Imagem selecionada não parece ser de uma instalação de padrão adequada.';

export default class SolicitationForm extends React.Component{
	
	client: any;
    statesOptions: any[];
    citiesOptions: any[];
	statesOptions2: any[];
	citiesOptions2: any[];
	
	constructor(props){
		super(props);
		this.client = null;
		this.statesOptions = CitiesUtil.getStateOptions();
		this.citiesOptions = [];
		this.statesOptions2 = CitiesUtil.getStateOptions();
		this.citiesOptions2 = [];
		this.state = {
			key: new Date().getTime(),
			a1_name: '',
			a2_type: SolicitationHelper.getA2_types()[0].value,
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
			addressMode: 'select',
			addressMode2: 'select',
			fileData: null, 
			validatedNew: false,
		};
	}
	
	emptyObject(obj){
		return (undefined === obj || null === obj);
	}
	
	emptyString(string){
		return (this.emptyObject(string) || string.trim() === '');
	}
	
	setValidationMessage(response){
		this.setState({errorMsg: response.msg, sucessMsg: '', key: new Date().getTime()});
	}
	
	setSuccesMessage(msg){
		this.setState({errorMsg: '', successMsg: msg, key: new Date().getTime()});
	}
	
	makeRekognition(){
		if(this.emptyObject(this.state.fileData)){
			this.setValidationMessage({msg: imgErrorMsg});
			return;
		}
		this.setProcessing(true);
		let image = {file: this.state.fileData.base64, filename: this.state.fileData.fileName};
		AwsRekognitionService.rekognize(image).then(result => {
			let labels = result.msg.Labels;
			if(this.emptyObject(labels)){
				this.setValidationMessage({msg: imgErrorMsg});
				return;
		    }
			let size = labels.length;
			let validated = false;
			for(let i = 0; i < size; i++){
				if(['Electrical Device','Fuse','Switch'].includes(labels[i].Name)
						&& labels[i].Confidence > 90){
					validated = true;
					break;
				}
			}
			this.setState({validatedNew: validated});
			this.loadClientAndNext();
		});
	}
	
	loadClientAndNext(){
		if(this.state.validatedNew !== true){
			this.setValidationMessage({msg: imgErrorMsg});
			this.setProcessing(false);
			return;
		}
		if(this.state.a2_type === 'PF'){
			ClientService.loadByCpf(this.state.a3_cpf).then(client => {
				this.setClientData(client);
				this.setProcessing(false);
				let newTab = this.emptyObject(this.client) ? 1 : 3;
				this.setState({tab: newTab, addressMode2: 'select', key: new Date().getTime()});
			});
			return;
		}
		ClientService.loadByCnpj(this.state.a4_cnpj).then(client => {
			this.setClientData(client);
			this.setProcessing(false);
			let newTab = this.emptyObject(this.client) ? 1 : 3;
			this.setState({tab: newTab, addressMode2: 'select', key: new Date().getTime()});
		});
	}
	
	previousStep(){
		if(this.state.tab === 0){
			return;
		}
		this.setState({errorMsg: '', successMsg: '', key: new Date().getTime()});
		let newTab = this.emptyObject(this.client) ? this.state.tab - 1 : this.state.tab - 3;
		if(newTab === 0){
			this.client = null;
			this.valueChanged('a3_cpf','');
			this.setState({validatedNew: false});
		}
		this.setState({tab: newTab, key: new Date().getTime()});
	}
	
	nextStep(){
		if(this.state.tab === 3){
			return;
		}
		this.setState({errorMsg: '', successMsg: '', key: new Date().getTime()});
		let newTab = this.state.tab + 1;
		if(!this.validateNext(newTab)){
			this.setValidationMessage({msg: 'Preencher corretamente os campos obrigatórios (*).'})
			return;
		}
		if(newTab === 1){
			this.makeRekognition();
			return;
		}
		if(newTab === 2){
			this.setState({tab: newTab, addressMode: 'select', key: new Date().getTime() });
		}
		if(newTab === 3 && this.emptyObject(this.client)){
			let date = this.state.a5_birthdate.replace(/\//gi,'');
			let client = {
				a1_name: this.state.a1_name,
				a2_type: this.state.a2_type,
				a3_cpf: this.state.a3_cpf,
				a4_cnpj: this.state.a4_cnpj,
				a5_birthdate: date.substring(4) + '-' + date.substring(2,4) + '-' + date.substring(0,2),
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
	
	validateNext(newTab){
		if(newTab === 1){
			return this.validateNext1();
		}
        if(newTab === 2){
        	return this.validateNext2();
		}
        return this.validateNext3();
	}
	
	validateNext1(){
		if(this.emptyString(this.state.a3_cpf) && this.emptyString(this.state.a4_cnpj)){
			return false;
		}
		return true;
	}
	
	validateNext2(){
		if(this.emptyString(this.state.a1_name) 
				|| this.emptyString(this.state.a5_birthdate)
				|| this.emptyString(this.state.a6_doctype)
				|| this.emptyString(this.state.a7_document)
				|| this.emptyString(this.state.a8_gender)
				|| this.emptyString(this.state.a10_phone)){
			return false;
		}
		return true;
	}
	
	validateNext3(){
		if(this.emptyString(this.state.a11_cep) 
				|| this.emptyString(this.state.a12_uf)
				|| this.emptyString(this.state.a13_city)
				|| this.emptyString(this.state.a14_street)){
			return false;
		}
		return true;
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
	
	searchByCep(value){
		if(!([2,3].includes(this.state.tab))){
			return;
		}
		ViaCepService.findByCep(value).then(result => {
			if(this.emptyObject(result) || Array.isArray(result)){
				return;
			}
			if(this.state.tab === 2){
				this.setState({addressMode: 'text'});
				this.valueChanged('a12_uf',result.uf);
				this.valueChanged('a13_city',result.cidade);
				this.valueChanged('a14_street',result.logradouro + ' ' + result.bairro);
			}
			if(this.state.tab === 3){
				this.setState({addressMode2: 'text'});
				this.valueChanged('s_a6_uf',result.uf);
				this.valueChanged('s_a7_city',result.cidade);
				this.valueChanged('s_a8_street',result.logradouro + ' ' + result.bairro);
			}
		});
	}
	
	valueChanged(id,value){
		if(id === 'upRekognition'){
			this.setState({fileData: value, validatedNew: false});
		}
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
			if(value.trim().length === 9){
				this.searchByCep(value);
			}
		}
		if(id === 'a12_uf'){
			this.citiesOptions = this.emptyString(value) 
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
			if(value.trim().length === 9){
				this.searchByCep(value);
			}
		}
		if(id === 's_a6_uf'){
			this.citiesOptions2 = this.emptyString(value) 
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
	
	setProcessing(processing){
		setTimeout(() => {
			let elem = document.getElementById('backDropLoading');
			elem.style.display = processing ? 'block' : 'none';
		},100);
	}
	
	setClientData(client){
		this.client = client;
		this.valueChanged('a1_name',!this.emptyObject(this.client) ? client.a1_name : '');
		this.valueChanged('a5_birthdate',!this.emptyObject(this.client) ? client.a5_birthdate : '');
		this.valueChanged('a6_doctype',!this.emptyObject(this.client) ? client.a6_doctype : '');
		this.valueChanged('a7_document',!this.emptyObject(this.client) ? client.a7_document : '');
		this.valueChanged('a8_gender',!this.emptyObject(this.client) ? client.a8_gender : '');
		this.valueChanged('a9_email',!this.emptyObject(this.client) ? client.a9_email : '');
		this.valueChanged('a10_phone',!this.emptyObject(this.client) ? client.a10_phone : '');
		this.valueChanged('a11_cep',!this.emptyObject(this.client) ? client.a11_cep : '');
		this.valueChanged('a12_uf',!this.emptyObject(this.client) ? client.a12_uf : '');
		this.valueChanged('a13_city',!this.emptyObject(this.client) ? client.a13_city : '');
		this.valueChanged('a14_street',!this.emptyObject(this.client) ? client.a14_street : '');
		this.valueChanged('a15_number',!this.emptyObject(this.client) ? client.a15_number : '');
		this.valueChanged('a16_compl1type',!this.emptyObject(this.client) ? client.a16_compl1type : '');
		this.valueChanged('a17_compl1desc',!this.emptyObject(this.client) ? client.a17_compl1desc : '');
		this.valueChanged('a18_compl2type',!this.emptyObject(this.client) ? client.a18_compl2type : '');
		this.valueChanged('a19_compl2desc',!this.emptyObject(this.client) ? client.a19_compl2desc : '');
	}
	
	render(){
		let fitMode = window.innerWidth < 600;
		let clazzTab0 = this.state.tab === 0 ? 'nav-link active' : 'nav-link';
		let clazzTab1 = this.state.tab === 1 ? 'nav-link active' : 'nav-link';
		let clazzTab2 = this.state.tab === 2 ? 'nav-link active' : 'nav-link';
		let clazzTab3 = this.state.tab === 3 ? 'nav-link active' : 'nav-link';
		let clazzTab4 = this.state.tab === 4 ? 'nav-link active' : 'nav-link';
		let clazzPanel0 = this.state.tab === 0 ? '' : 'none';
		let clazzPanel1 = this.state.tab === 1 ? '' : 'none';
		let clazzPanel2 = this.state.tab === 2 ? '' : 'none';
		let clazzPanel3 = this.state.tab === 3 ? '' : 'none';
		let clazzPanel4 = this.state.tab === 4 ? '' : 'none';
		if(!this.emptyObject(this.client)){
			clazzTab1 = 'none';
			clazzTab2 = 'none';
			clazzPanel1 = 'none';
			clazzPanel2 = 'none';
		}
		return(
			<div className="dataForm"
				 key={this.state.key}>
				<div className='headerData'>
					<h3>Solicitação de Nova Instalação</h3>
					<div>
						<ul className="tabs">
							<li>
								<span className={clazzTab0}>
							   	  CPF/CNPJ
								</span>
							</li>
							<li>
								<span className={clazzTab1}>
							   	  Dados pessoais
								</span>
							</li>
							<li>
								<span className={clazzTab2}>
							   	    Seu endereço
								</span>
							</li>
							<li>
								<span className={clazzTab3}>
							   	  Endereço da Instalação
								</span>
							</li>
						</ul>
						<div className="clear" 
							 style={{'marginBottom':'.4em'}}>
						</div>
					</div>
				</div>
				<div className={clazzPanel0}>
					<RadioButton id="a2_type" 
						         defaultValue={this.state.a2_type}
						         options={SolicitationHelper.getA2_types()}
						         handler={this}>
					</RadioButton>
					<InputText id="a3_cpf" 
						       noRender={this.state.a2_type !== 'PF'}
						       corrector={new CpfMask()}
						       maxlength="14"
					           handler={this}>
					</InputText>
					<InputText id="a4_cnpj" 
						       noRender={this.state.a2_type !== 'PJ'}
						       corrector={new CnpjMask()}
					           maxlength="18"
					           handler={this}>
					</InputText>
					<InputUpload id="upRekognition" 
						         label="Adicione uma Imagem do Padrão para Validação"
						         handler={this}>
					</InputUpload>
					<img style={{'border':'0','width':'100%','height':'16em'}}
					     className={this.emptyObject(this.state.fileData) ? 'none' : ''}
					     src={this.emptyObject(this.state.fileData) ? '' : this.state.fileData.base64}>
					</img>
				</div>
				<div className={clazzPanel1}>
					<div className={!this.emptyObject(this.client) ? 'alert-info' : 'none'}>
						Encontramos seu cadastro. Para alterar os dados realize 
						solicitação de alteração de dados pessoais.
					</div>
					<InputText id="a1_name" 
						       label="Nome (*)"
						       defaultValue={this.state.a1_name}
						       corrector={OnlyAlphaCorrector}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '99'}
					           handler={this}>
					</InputText>
					<InputText id="a5_birthdate" 
						       label="Data de Nascimento (*)"
						       defaultValue={this.state.a5_birthdate}
						       corrector={new DateMask()}
							   readOnly={!this.emptyObject(this.client)}
							   width={fitMode ? '100' : '32'}
					           handler={this}>
					</InputText>
					<SelectBox id="a6_doctype"
						       label="Tipo Outro Documento (*)"
						       defaultValue={this.state.a6_doctype}
						       options={SolicitationHelper.getA6_doctypes()}
					           readOnly={!this.emptyObject(this.client)}
							   width={fitMode ? '100' : '33'}
						       handler={this}>
					</SelectBox>
					<InputText id="a7_document" 
						       label="Número Outro Documento (*)"
						       defaultValue={this.state.a7_document}
						       corrector={this.state.a6_doctype === 'rg' ? new RgMask() : new DocumentMask()}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '33'}
					           handler={this}>
					</InputText>
					<SelectBox id="a8_gender"
						       label="Sexo/Gênero (*)"
						       defaultValue={this.state.a8_gender}
						       options={SolicitationHelper.getA8_genders()}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '29'}
						       handler={this}>
					</SelectBox>
					<InputText id="a9_email" 
						       label="E-mail"
						       defaultValue={this.state.a9_email}
						       corrector={EmailCorrector}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '69'}
					           handler={this}>
					</InputText>
					<InputText id="a10_phone" 
						       label="Telefone(s) (*)"
						       defaultValue={this.state.a10_phone}
						       corrector={PhoneCorrector}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '99'}
					           handler={this}>
					</InputText>
				</div>
				<div className={clazzPanel2}>
					<div className={!this.emptyObject(this.client) ? 'alert-info' : 'none'}>
						Encontramos seu cadastro. Para alterar os dados realize 
						solicitação de alteração de dados pessoais.
					</div>
					<InputText id="a11_cep" 
						       label="CEP (*)"
						       defaultValue={this.state.a11_cep}
						       corrector={new CepMask()}
					           maxlength="9"
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '19'}
					           handler={this}>
					</InputText>
					<SelectBox id="a12_uf"
						       label="Estado/UF (*)"
						       defaultValue={this.state.a12_uf}
						       options={this.statesOptions}
					           readOnly={!this.emptyObject(this.client)}
					           noRender={this.state.addressMode === 'text'}
					           width={fitMode ? '100' : '19'}
						       handler={this}>
					</SelectBox>
					<SelectBox id="a13_city" 
						       label="Cidade (*)"
						       defaultValue={this.state.a13_city}
					           options={this.citiesOptions}
					           readOnly={!this.emptyObject(this.client)}
					           noRender={this.state.addressMode === 'text'}
					           width={fitMode ? '100' : '60'}
					           handler={this}>
					</SelectBox>
					<InputText id="a12_uf" 
						       label="Estado/UF (*)"
						       defaultValue={this.state.a12_uf}
						       corrector={OnlyAlphaCorrector}
					           readOnly={!this.emptyObject(this.client)}
					           noRender={this.state.addressMode !== 'text'}
					           width={fitMode ? '100' : '19'}
					           handler={this}>
					</InputText>
					<InputText id="a13_city" 
						       label="Cidade (*)"
						       defaultValue={this.state.a13_city}
						       corrector={OnlyAlphaCorrector}
					           readOnly={!this.emptyObject(this.client)}
					           noRender={this.state.addressMode !== 'text'}
					           width={fitMode ? '100' : '60'}
					           handler={this}>
					</InputText>
					<div className="clear"></div>
					<InputText id="a14_street" 
						       label="Logradouro (*)"
						       defaultValue={this.state.a14_street}
						       corrector={OnlyAlphaCorrector}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '78'}
					           handler={this}>
					</InputText>
					<InputText id="a15_number" 
						       label="Número"
						       defaultValue={this.state.a15_number}
						       corrector={AlphaNumberCorrector}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '20'}
					           handler={this}>
					</InputText>
					<SelectBox id="a16_compl1type"
						       label="Complemento 1 Tipo"
						       defaultValue={this.state.a16_compl1type}
						       options={SolicitationHelper.getA16_compl1types()}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '29'}
						       handler={this}>
					</SelectBox>
					<InputText id="a17_compl1desc" 
						       label="Complemento 1 Descrição"
						       defaultValue={this.state.a17_compl1desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={!this.emptyObject(this.client) || this.state.a16_compl1type.trim() === ''}
					           width={fitMode ? '100' : '69'}
					           handler={this}>
					</InputText>
					<SelectBox id="a18_compl2type"
						       label="Complemento 2 Tipo"
						       defaultValue={this.state.a18_compl2type}
						       options={SolicitationHelper.getA18_compl2types()}
					           readOnly={!this.emptyObject(this.client)}
					           width={fitMode ? '100' : '29'}
						       handler={this}>
					</SelectBox>
					<InputText id="a19_compl2desc" 
						       label="Complemento 2 Descrição"
						       defaultValue={this.state.a19_compl2desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={!this.emptyObject(this.client) || this.state.a18_compl2type.trim() === ''}
					           width={fitMode ? '100' : '69'}
					           handler={this}>
					</InputText>
				</div>
				<div className={clazzPanel3}>
					<SelectBox id="s_a2_caracteristic"
						       label="Característica da Instalação (*)"
						       defaultValue={this.state.s_a2_caracteristic}
						       options={SolicitationHelper.getA2_caracteristics()}
					           width={fitMode ? '100' : '99'}
						       handler={this}>
					</SelectBox>
					<InputText id="s_a5_cep" 
						       label="CEP (*)"
						       defaultValue={this.state.s_a5_cep}
						       corrector={new CepMask()}
					           maxlength="9"
					           width={fitMode ? '100' : '19'}
					           handler={this}>
					</InputText>
					<SelectBox id="s_a6_uf"
						       label="Estado/UF (*)"
						       defaultValue={this.state.s_a6_uf}
						       options={this.statesOptions2}
					           noRender={this.state.addressMode2 === 'text'}
					           width={fitMode ? '100' : '19'}
						       handler={this}>
					</SelectBox>
					<SelectBox id="s_a7_city" 
						       label="Cidade (*)"
						       defaultValue={this.state.s_a7_city}
					           options={this.citiesOptions2}
					           noRender={this.state.addressMode2 === 'text'}
					           width={fitMode ? '100' : '60'}
					           handler={this}>
					</SelectBox>
					<InputText id="s_a6_uf" 
						       label="Estado/UF (*)"
						       defaultValue={this.state.s_a6_uf}
						       corrector={OnlyAlphaCorrector}
					           noRender={this.state.addressMode2 !== 'text'}
					           width={fitMode ? '100' : '19'}
					           handler={this}>
					</InputText>
					<InputText id="s_a7_city" 
						       label="Cidade (*)"
						       defaultValue={this.state.s_a7_city}
						       corrector={OnlyAlphaCorrector}
					           noRender={this.state.addressMode2 !== 'text'}
					           width={fitMode ? '100' : '60'}
					           handler={this}>
					</InputText>
					<div className="clear"></div>
					<InputText id="s_a8_street" 
						       label="Logradouro (*)"
						       defaultValue={this.state.s_a8_street}
						       corrector={OnlyAlphaCorrector}
					           width={fitMode ? '100' : '78'}
					           handler={this}>
					</InputText>
					<InputText id="s_a9_number" 
						       label="Número"
						       defaultValue={this.state.s_a9_number}
						       corrector={AlphaNumberCorrector}
					           width={fitMode ? '100' : '20'}
					           handler={this}>
					</InputText>
					<SelectBox id="s_a10_compl1type"
						       label="Complemento 1 Tipo"
						       defaultValue={this.state.s_a10_compl1type}
						       options={SolicitationHelper.getA16_compl1types()}
					           width={fitMode ? '100' : '29'}
						       handler={this}>
					</SelectBox>
					<InputText id="s_a11_compl1desc" 
						       label="Complemento 1 Descrição"
						       defaultValue={this.state.s_a11_compl1desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={this.state.s_a10_compl1type.trim() === ''}
					           width={fitMode ? '100' : '69'}
					           handler={this}>
					</InputText>
					<SelectBox id="s_a12_compl2type"
						       label="Complemento 2 Tipo"
						       defaultValue={this.state.s_a12_compl2type}
						       options={SolicitationHelper.getA18_compl2types()}
					           width={fitMode ? '100' : '29'}
						       handler={this}>
					</SelectBox>
					<InputText id="s_a13_compl2desc" 
						       label="Complemento 2 Descrição"
						       defaultValue={this.state.s_a13_compl2desc}
						       corrector={OnlyAlphaCorrector}
					           readOnly={this.state.s_a12_compl2type.trim() === ''}
					           width={fitMode ? '100' : '69'}
					           handler={this}>
					</InputText>
					<InputText id="s_a14_reference" 
						       label="Referência (*)"
						       defaultValue={this.state.s_a14_reference}
						       corrector={OnlyAlphaCorrector}
					           width={fitMode ? '100' : '99'}
					           handler={this}>
					</InputText>
				</div>
				
				<div className="clear"></div> 
				<div className={!this.emptyString(this.state.errorMsg) ? 'alert-danger' : 'none'}> 
					{this.state.errorMsg}
					<div className="clear"></div> 
				</div>
				<div className={!this.emptyString(this.state.successMsg) ? 'alert-info' : 'none'}> 
					{this.state.successMsg}
					<div className="clear"></div> 
				</div>
				<div className="clear"></div> 
				
				<div className="buttons clear"> 
					<button className="btn btn-primary clickable"
						    onClick={() => {this.previousStep();}}>
					    <i className="fas fa-backward" 
					       style={{'marginRight':'1em'}}>
					    </i>
						<span>
							Anterior
						</span>
					</button>  
					<button className={this.state.tab === 3 ? 'none' : 'btn btn-primary clickable'}
						    onClick={() => {this.nextStep();}}>
						<span>
							Seguinte
						</span>
						<i className="fas fa-forward"
							style={{'marginLeft':'1em'}}>
					    </i>
					</button>  
					<button className={this.state.tab !== 3 ? 'none' : 'btn btn-primary clickable'}
						    onClick={() => {this.createSolicitation();}}>
					    <i className="fas fa-check-double" 
					       style={{'marginLeft':'1em'}}>
					    </i>
						<span>
							Enviar Solicitação
						</span>
					</button>  
				</div>
				<div id="backDropLoading"
				     style={{'zIndex':'1000050','display':'none'}} 
				     className="modal-backdrop fade show">
				</div>
			</div>
		);
	}
	
}