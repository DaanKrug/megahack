import React from 'react';

export default class BotIcon extends React.Component {
	
	render() {
	    return (
	    		<div className="botIconContainer rsc-ts-image-container">
	    			<img className="botIcon rsc-ts-image" 
	    				 src={require('../../img/joana.png')} 
	    				 alt="avatar" />
	    		</div>
	    );
    }
	
}