import React from 'react';

export default class RadioButton extends React.Component{
	
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
		return (
				<div key={this.state.key}>
				    {this.renderLabel()}
				    <div>
						{this.props.options.map((option, idx) => (
							<div key={idx}
							     className="field clickable" 
								 style={{'marginRight':'1em'}}
							     onClick={() => {this.onChange(option.value);}}>
								<span className={this.state.value === option.value ? '' : 'none'}>
									<i className="fas fa-circle"></i>
								</span>
								<span className={this.state.value !== option.value ? '' : 'none'}>
									<i className="far fa-circle"></i>
								</span>
								<span style={{'marginLeft':'.3em'}}>
									{option.label}
								</span>
							</div>
						))}
						<div className="clear"></div>
					</div>
				</div>
		);
	}
}