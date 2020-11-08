import React from 'react';

export default class InputMessage extends React.Component {
	
	constructor(props){
		super(props);
		this.state = {
			key: new Date().getTime(),
			disabled: false,
			inputId: 'input_' + (new Date().getTime()) + '_' + this.props.id
		};
	}
	
	onClick(){
		if(this.state.disabled){
			return;
		}
		if(undefined === this.props.handler || null === this.props.handler 
				|| undefined === this.props.msgid || null === this.props.msgid
				|| undefined === this.props.id || null === this.props.id){
			return;
		}
		const value = document.getElementById(this.state.inputId).value;
		if(value.trim() === ''){
			return;
		}
		this.props.handler.handleMsgClick(this.props.msgid,value,this.props.id);
		this.setState({
			key: new Date().getTime(),
			disabled: true
		});
	}
	
	render() {
	    return (
	    		<div key={this.state.key}>
	    			<div className="field" 
	    				 style={{'width':'calc(100% - 3.7em)','marginLeft':'.5em'}}>
		    			<input id={this.state.inputId} 
				    	       type="text" 
				    		   className="form-control" 
				    		   placeholder="Digite a resposta ..." >
				    	</input>
	    			</div>
	    			<div className="field" 
	    				 style={{'width':'2.5em'}}>
		    			<button className="btn btn-primary clickable"
				    		    onClick={() => {this.onClick();}}>
				    		<i className="fas fa-paper-plane"></i>
				    	</button>
	    			</div>
			    </div>
	    );
    }
	
}











