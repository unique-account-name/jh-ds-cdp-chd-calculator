//alert( 'lipidCalc(...) loaded' )
var DEBUG = true;

$( document ).ready(function() {
    
    $( "#age" ).change(function() {
        updateRisk( "age" );
    });
    $( "#gender" ).change(function() {
        updateRisk( "gender" );
    });
    $( "#sbp" ).change(function() {
        updateRisk( "sbp" );
    });
    $( "#trtbp" ).change(function() {
        updateRisk( "trtbp" );
    });
    $( "#smoker" ).change(function() {
        updateRisk( "smoker" );
    });
    $( "#diabetes" ).change(function() {
        updateRisk( "diabetes" );
    });
    $( "#hdl" ).change(function() {
        updateRisk( "hdl" );
    });
    $( "#tcl" ).change(function() {
        updateRisk( "tcl" );
    });

    setTimeout( updateRiskNone, 250 )
    console.log( "document.ready(...) DONE" );
});
// wrapper to set caller as none
var updateRiskNone = function() {
    updateRisk( "none" )
}
var updateRisk = function( foo ) {
    
    //alert( "updateRisk() called..." );
    console.log( "updateRisk() called..." )
    lipidCalc.doCalculation( foo )
};
var lipidCalc = new function()
{
    var copyObject = function(obj)
    {
        copy = Object.keys(obj).reduce(function(c,k){c[k]=obj[k];return c;},{});
        return copy;
    };

	var getFormData = function() {
	    
	    formData = new Object();
	    
	    formData[ "gender" ] = ( $( "#gender" ).val() == "Male" ) ? 1 : 0;
	    formData[ "age" ] = $( "#age" ).val();
	    formData[ "sbp" ] = $( "#sbp" ).val();
	    
	    formData[ "trtbp" ] = ( $( "#trtbp" ).val() == "Yes" ) ? 1 : 0;
	    formData[ "smoker" ] = ( $( "#smoker" ).val() == "Yes" ) ? 1 : 0;
	    formData[ "diabetes" ] = ( $( "#diabetes" ).val() == "Yes" ) ? 1 : 0;
	    
	    formData[ "hdl" ] = $( "#hdl" ).val();
	    formData[ "tcl" ] = $( "#tcl" ).val();
	    
	    console.log( formData[ "gender" ] )
	    console.log( formData[ "age" ] )
	    console.log( formData[ "sbp" ] )
	    console.log( formData[ "trtbp" ] )
	    console.log( formData[ "smoker" ] )
	    console.log( formData[ "diabetes" ] );
	    console.log( formData[ "hdl" ] );
	    console.log( formData[ "tcl" ] )
	    
	    return formData;
	};
	
	
	//
	// Coefficients
	// 
	var COEFS_MALE_NO_TREATMENT_FOR_BP =
	{
	    age: 3.06117, sbp: 1.93303, tcl: 1.1237, hdl: -0.93263, smoker: 0.65451, diabetes: 0.57367
	};
	
	var COEFS_FEMALE_NO_TREATMENT_FOR_BP =
	{
	    age: 2.32888, sbp: 2.76157, tcl: 1.20904, hdl: -0.70833, smoker: 0.52873, diabetes: 0.69154
	};
	
	var COEFS_SYSBP_MALE_TREATMENT_FOR_BP   = 1.99881; // replaces sbp coef if being treated
	var COEFS_SYSBP_FEMALE_TREATMENT_FOR_BP = 2.82263; // replaces sbp coef if being treated
	
	// Is contribution to some coef*data or coef*ln(data)?
	var useLogData =
	{
	    age: true, sbp: true, tcl: true, hdl: true, smoker: false, diabetes: false			
	};	
	
	// Constant term in sum
	var BETA_ZERO_MALE   = -23.9802;
	var BETA_ZERO_FEMALE = -26.1931;	
	
	// Base for pow() calculation
	var BASE_MALE = 0.88936;
	var BASE_FEMALE = 0.95012;
	
	// Baseline values. Need to fill in gender and age
	var baselineNormalData =
	{
	    gender: 0,  age: 30, sbp: 125, tcl: 180, hdl: 45, smoker: 0, diabetes: 0, trtbp: 0			
	};	
	
	var baselineOptimalData =
	{
	    gender: 0, age: 30, sbp: 110, tcl: 160, hdl: 60, smoker: 0, diabetes: 0, trtbp: 0		
	};	
	
	//
	// Funcs
	//
	var calcRisk = function( data ) { 
	    
		var coefs = {};
		var base;
		var betaZero;
		
		// male
		if (data['gender'] == 1 ) 
		{
			betaZero = BETA_ZERO_MALE;
			base = BASE_MALE;
			coefs = copyObject( COEFS_MALE_NO_TREATMENT_FOR_BP ); // make a copy, since we might change it
			if (data['trtbp'] == 1)
				coefs['sbp'] = COEFS_SYSBP_MALE_TREATMENT_FOR_BP;
		}
		else
		{
			betaZero = BETA_ZERO_FEMALE;
			base = BASE_FEMALE;			
			coefs = copyObject( COEFS_FEMALE_NO_TREATMENT_FOR_BP ); // copy the array
			if ( data['trtbp'] == 1 )
				coefs['sbp'] = COEFS_SYSBP_FEMALE_TREATMENT_FOR_BP;			
		}

	    
	    // do computation
	    var betaSum = betaZero;
	    for(var k in coefs)
	    {
	    	var m = parseFloat(data[k]);
	    	if (useLogData[k])
	    		m = Math.log(m);
	    	
	        var dBeta = coefs[k] * m;
	        
	        betaSum += dBeta;
	    }
	
	    var risk =  1.0 - Math.pow(base, Math.exp(betaSum));
   
	    return risk;
	
	};
	
	this.doCalculation = function( last_widget )
	{
	
	    var data = getFormData();
	    
	    var risk = calcRisk( data );
	    if ( DEBUG ) console.log( "risk:" + risk )

        // 'normal' risk    
        var testData = copyObject(baselineNormalData); // copy
        testData['age'] = data['age'];
        testData['gender'] = data['gender'];	   	        
        var normalRisk = calcRisk(testData);
        if ( DEBUG ) console.log( "normalRisk:" + normalRisk )
        
        // 'optimal' risk
        testData = copyObject(baselineOptimalData);	        
        testData['age'] = data['age'];	   
        testData['gender'] = data['gender'];		        
        var optRisk = calcRisk(testData);
        if ( DEBUG ) console.log( "optRisk:" + optRisk )
        
        Shiny.unbindAll()
        $( '#risk_yours' ).val( Math.round( 1000 * risk) / 10 );
        $( '#risk_average' ).val( Math.round( 1000 * normalRisk ) / 10 );
        $( '#risk_optimal' ).val( Math.round( 1000 * optRisk ) / 10 );
        $( "#last_widget_used" ).val( last_widget )
        Shiny.bindAll()
        
        // phaux enter on risk_yours to update on server.R
        /*
        var e = jQuery.Event( 'keydown', { which: $.ui.keyCode.ENTER } );
        $( "#risk_yours" ).trigger( e );
        if ( DEBUG ) console.log( e + " sent..." )
        */
        
	};

}; 
