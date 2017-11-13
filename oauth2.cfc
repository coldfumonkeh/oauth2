/**
* @displayname oauth2
* @output false
* @hint The oauth2 object.
* @author Matt Gifford
* @website http://www.mattgifford.co.uk/
* @purpose A ColdFusion Component to manage authentication using the OAuth2 protocol.
**/
component accessors="true"{

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";

	/**
	* I return an initialized oauth2 object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public oauth2 function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint, 
		required string accessTokenEndpoint, 
		required string redirect_uri
	){
		setClient_id( arguments.client_id );
		setClient_secret( arguments.client_secret );
		setAuthEndpoint( arguments.authEndpoint );
		setAccessTokenEndpoint( arguments.accessTokenEndpoint );
		setRedirect_uri( arguments.redirect_uri );
		return this;
	}
	
	/**
	* I return the URL as a string which we use to redirect the user for authentication. |
	* The method will handle the client_id and redirect_uri values for you. Anything else you need to send to the provider in the URL can be sent via the parameters argument.
	* @parameters A structure containing key / value pairs of data to be included in the URL string.
	**/
	public string function buildRedirectToAuthURL( struct parameters={} ) {
		return getAuthEndpoint() & '?client_id=' & getClient_id() & '&redirect_uri=' & getRedirect_uri() & buildParamString( argScope = arguments.parameters );
	}
	
	/**
	* I make the HTTP request to obtain the access token.
	* @code The code returned from the authentication request.
	* @formfields An optional array of structs for the provider requirements to add new form fields.
	* @headers An optional array of structs to add custom headers to the request if required.
	**/
	public struct function makeAccessTokenRequest(
		required string code,
		array formfields = [],
		array headers    = []
	){
		var stuResponse = {};
	    var httpService = new http();
	    httpService.setMethod( "post" ); 
	    httpService.setCharset( "utf-8" );
	    httpService.setUrl( getAccessTokenEndpoint() );
	    if( arrayLen( arguments.headers ) ){
	    	for( var item in arguments.headers ){
	    		httpService.addParam( type="header", name=item[ 'name' ],  value=item[ 'value' ] );
	    	}
	    }
	    httpService.addParam( type="formfield", name="client_id", 	 value=getClient_id() );
	    httpService.addParam( type="formfield", name="client_secret", value=getClient_secret() );
	    httpService.addParam( type="formfield", name="code", 		 value=arguments.code );
	    httpService.addParam( type="formfield", name="redirect_uri",  value=getRedirect_uri() );
	    if( arrayLen( arguments.formfields ) ){
	    	for( var item in arguments.formfields ){
	    		httpService.addParam( type="formfield", name=item[ 'name' ],  value=item[ 'value' ] );
	    	}
	    }
	    var result = httpService.send().getPrefix();
	    if( '200' == result.ResponseHeader[ 'Status_Code' ] ) {
	    	stuResponse.success = true;
	    	stuResponse.content = result.FileContent;
	    } else {
	    	stuResponse.success = false;
	    	stuResponse.content = result.Statuscode;
	    }
    	return stuResponse;
	}
	
	/**
	* I return a string containing any extra URL parameters to concatenate and pass through when authenticating.
	* @argScope A structure containing key / value pairs of data to be included in the URL string.
	**/
	public string function buildParamString( struct argScope={} ) {
		var strURLParam = '';
		if( structCount( arguments.argScope ) ) {
			for( var key in arguments.argScope ) {
				if( listLen( strURLParam ) ) {
					strURLParam = strURLParam & '&';
				}
				strURLParam = strURLParam & lcase( key ) & '=' & trim( arguments.argScope[ key ] );
			}
			strURLParam = '&' & strURLParam;
		}
		return strURLParam;	
	}

	/**
	* Returns the properties as a struct
	*/
	public struct function getMemento(){
		var result = {};
		for( var thisProp in getMetaData( this ).properties ){
			if( structKeyExists( variables, thisProp[ 'name' ] ) ){
				result[ thisProp[ 'name' ] ] = variables[ thisProp[ 'name' ] ];
			}
		}
		return result;
	}

}