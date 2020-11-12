import React from 'react';
import Button from 'react-bootstrap/Button';

export default function BigButton(props){
    return (
			<div className="btLargeContainer">
	    		<Button variant="primary" 
	    			    className="btLarge"
	    			    onClick={() => props.onClick()}>
	    			<div>
	    				<i className={props.className + ' btIconLarge'}></i>
	    			</div>
	    			<div>
	    				{props.label}
	    			</div>
	    		</Button>
	    	</div>
    );
}