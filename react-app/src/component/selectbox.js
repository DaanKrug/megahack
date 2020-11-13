import React from 'react';

export default class SelectBox extends React.Component{
	
	constructor(props){
		super(props);
		this.state = {
			key: new Date().getTime(),
			value: '' + this.props.defaultValue
		};
	}
	
	onChange(value){
		this.setState({value: value,key: new Date().getTime()});
		if(null !== this.props.handler){
			this.props.handler.valueChanged(this.props.id,value);
		}
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
		let readOnly = (undefined != this.props.readOnly 
		        && null !== this.props.readOnly && this.props.readOnly);
	    let clazz = readOnly ? 'form-control disabled' : 'form-control clickable';
		return (
				<div key={this.state.key}>
					{this.renderLabel()}
					<select id={this.props.id} 
			                className={clazz}
					        readonly={readOnly}
			                style={{'height':'calc(1.5em + 0.65rem + 2px)'}}
			                onChange={(e) => {this.onChange(e.target.value);}}>
						{this.props.options.map((option, idx) => (
							<option value={option.value} 
							        selected={option.value === this.state.value}>
								{option.label}
							</option>	
						))}		
					</select>
				</div>
		);
	}
}