import React from 'react';

export default class InputText extends React.Component{
	
	constructor(props){
		super(props);
		if(undefined !== this.props.defaultValue && null !== this.props.defaultValue){
			setTimeout(() => {
				document.getElementById(this.props.id).value = this.props.defaultValue;
			},500);
		}
	}
	
	onChange(){
		let elem = document.getElementById(this.props.id);
		let value = elem.value.trim();
		if(null !== this.props.corrector){
			value = this.props.corrector.adjustValue(value);
		}
		if(null !== this.props.handler){
			this.props.handler.valueChanged(this.props.id,value);
		}
		elem.value = value;
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
		return (
				<div>
					{this.renderLabel()}
					<input id={this.props.id} 
						   type="text" 
						   style={{'width':'100% !important;'}} 
						   autocomplete="off"
					       maxlength={this.props.maxchars > 0 ? this.props.maxchars : 250} 
					       readonly={readOnly}
					       className={clazz}
					       onKeyUp={() => {this.onChange();}}  />
				</div>
		);
	}
}