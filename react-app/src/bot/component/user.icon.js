import React from 'react';

export default class UserIcon extends React.Component {
	
	render() {
	    return (
	    		<div className="userIconContainer rsc-ts-image-container">
	    			<img className="userIcon rsc-ts-image" 
	    				 src={require('../../img/user2.png')} 
	    				 alt="avatar" />
	    		</div>
	    );
    }
	
}