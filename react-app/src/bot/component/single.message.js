import React from 'react';

export default class SingleMessage extends React.Component {
	
	onClick(){
		if(undefined === this.props.handler || null === this.props.handler 
				|| undefined === this.props.msgid || null === this.props.msgid
				|| undefined === this.props.id || null === this.props.id){
			return;
		}
		this.props.handler.handleMsgClick(this.props.msgid,this.props.msg,this.props.id);
	}
	
	render() {
	    return (
	    		<div className={(this.props.type === 'user' ? 'userMsg' : 'botMsg') + ' rsc-ts-bubble'}
	    		     onClick={() => {this.onClick();}}>
	    			{this.props.msg}
	    		</div>
	    );
    }
	
}