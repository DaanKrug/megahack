import React from 'react';

export default function BigButton(props){
    return (
			<div className="btLargeContainer">
	    		<button className="btn btn-primary clickable btLarge"
	    			    onClick={() => props.onClick()}>
		    		<div>
						<i className={props.className + ' btIconLarge'}></i>
					</div>
					<div>
						{props.label}
					</div>
				</button>  
	    	</div>
    );
}