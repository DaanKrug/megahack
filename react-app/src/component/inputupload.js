import React from 'react';
import FileValidator from './validator/file.validator.js';

export default class InputUpload extends React.Component{
	
	fileInput: any;
	
	constructor(props){
		super(props);
		this.fileInput = React.createRef();
		this.state = {
			key: new Date().getTime(),
			value: null,
			fileData: null,
			base64: null,
			validationMessage: null,
		};
	}
	
	reset(){
		this.setState({
			key: new Date().getTime(),
			value: null,
			fileData: null,
			base64: null,
			validationMessage: null,
		});
	}
	
	onChange(){
		this.reset();
		this.setToUpload();
	}
	
	setToUpload() {
		let fileData = this.fileInput.current.files[0];
		if(fileData.size > ((2 * 1024 * 1024) + 50)){
		    this.setState({key: new Date().getTime(), 
		    	           validationMessage: 'Arquivo maior que 2 MB.'});
		  	return;
		}
		this.setState({fileData: fileData});
		let reader = new FileReader();
	    reader.onload = () => { this.validateBase64(reader.result);};
	    reader.readAsArrayBuffer(fileData);
	}
	
	validateBase64(arrayBuffer){
	    if(!FileValidator.validateFileContentBase64(this.state.fileData.type,arrayBuffer)){
		  	this.reset();
		  	this.setState({key: new Date().getTime(), 
		  		           validationMessage: 'Conteúdo do arquivo não condiz com a extensão.'});
	      	return;
		}
		let reader = new FileReader();
		reader.onload = () => { 
			this.setState({base64: '' + reader.result});
			this.setDataToHandler();
	    };
		reader.readAsDataURL(this.state.fileData);
	}
	
	setDataToHandler(){
		if(undefined === this.props.handler || null === this.props.handler){
			return;
		}
		let data = {fileName: this.state.fileData.name,base64: this.state.base64};
		this.props.handler.valueChanged(this.props.id,data);
	}
	
	renderLabel(){
		if(undefined === this.props.label 
			|| null === this.props.label 
			|| this.props.label.trim() === ''){
			return (<></>);
		}
		return (
				<div>
					<label forHtml={this.props.id}>{this.props.label}</label>
				</div>
		);
	}
	
	render(){
		if(null !== this.props.noRender && this.props.noRender){
			return (<></>);
		}
		let readOnly = (undefined !== this.props.readOnly 
				        && null !== this.props.readOnly && this.props.readOnly);
		let clazz = readOnly ? 'form-control disabled' : 'form-control';
		let vclazz = (undefined !== this.state.validationMessage 
				      && null !== this.state.validationMessage && this.state.validationMessage.trim () !== '')
				   ? 'alert-danger' : 'none';
		return (
				<div>
					{this.renderLabel()}
					<input id={this.props.id} 
						   type="file" 
						   style={{'width':'100% !important;'}} 
					       readonly={readOnly}
					       className={clazz}
					       ref={this.fileInput}
					       onChange={() => {this.onChange();}}  />
					<div key={this.state.key}
					     className={vclazz}>
						{this.state.validationMessage}
					</div>
				</div>
		);
	}
}