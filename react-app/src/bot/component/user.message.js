import React from 'react';
import UserIcon from './user.icon.js';
import SingleMessage from './single.message.js';

export default class UserMessage extends React.Component {
	
	render() {
	    return (
	    		<div className="chatMsgContainer rsc-ts rsc-ts-user">
	    			<UserIcon />
	    			<SingleMessage msg={this.props.msg} 
	    			               type="user" />
				</div>
	    );
    }
	
}