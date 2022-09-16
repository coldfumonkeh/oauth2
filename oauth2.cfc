/**
* @displayname oauth2
* @output false
* @hint The oauth2 object.
* @author Matt Gifford
* @website https://www.monkehworks.com
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
		var stuParams = arguments.parameters;
		stuParams[ 'client_id' ] = getClient_id();
		stuParams[ 'redirect_uri' ] = getRedirect_uri();
		return getAuthEndpoint() & buildParamString( argScope = stuParams );
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
	    httpService.addParam( type="formfield", name="client_id", value=getClient_id() );
	    httpService.addParam( type="formfield", name="client_secret", value=getClient_secret() );
	    httpService.addParam( type="formfield", name="code", value=arguments.code );
	    httpService.addParam( type="formfield", name="redirect_uri", value=getRedirect_uri() );
		httpService.addParam( type="formfield", name="grant_type", value='authorization_code' );
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
	* I make the HTTP request to obtain the access token AND send a PKCE code verifier value.
	* @code The code returned from the authentication request.
	* @code_verifier The PKCE code verifier value to send to the server.
	* @formfields An optional array of structs for the provider requirements to add new form fields.
	* @headers An optional array of structs to add custom headers to the request if required.
	**/
	public struct function makeAccessTokenRequestWithPKCE(
		required string code,
		required string code_verifier,
		array formfields = [],
		array headers    = []
	){
		var arrFormFields = arguments.formfields;
		arrayAppend( arrFormFields, {
			'name': 'code_verifier',
			'value': arguments.code_verifier
		} );
		return makeAccessTokenRequest(
			code       = arguments.code,
			formfields = arrFormFields,
			headers    = arguments.headers
		);
	}

	/**
	* I make the HTTP request to refresh the access token.
	* @refresh_token The refresh_token returned from the accessTokenRequest request.
	**/
	public struct function refreshAccessTokenRequest(
		required string refresh_token,
		array formfields = [],
		array headers    = []
	){
		var stuResponse = {};
	    var httpService = new http();
	    httpService.setMethod( "post" ); 
	    httpService.setCharset( "utf-8" );
	    httpService.setUrl( getAccessTokenEndpoint() );
	    httpService.addParam( type="header", name="Content-Type", value="application/x-www-form-urlencoded" );
	    if( arrayLen( arguments.headers ) ){
	    	for( var item in arguments.headers ){
	    		httpService.addParam( type="header", name=item[ 'name' ],  value=item[ 'value' ] );
	    	}
	    }
	    httpService.addParam( type="formfield", name="client_id", 	 value=getClient_id() );
	    httpService.addParam( type="formfield", name="client_secret", value=getClient_secret() );
	    httpService.addParam( type="formfield", name="refresh_token", value=arguments.refresh_token );
	    httpService.addParam( type="formfield", name="grant_type",  value="refresh_token" );
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
		var strURLParam = '?';
		if( structCount( arguments.argScope ) ) {
			var intCount = 1;
			for( var key in arguments.argScope ) {
				if( listLen( strURLParam ) && intCount > 1 ) {
					strURLParam = strURLParam & '&';
				}
				strURLParam = strURLParam & lcase( key ) & '=' & trim( arguments.argScope[ key ] );
				intCount++;
			}
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

	/**
	 * Generates a struct containing the code verifier and code challenger values
	 *
	 * @length The length of the code verifier string to be generated. Between 43 and 128 characters. Defaults to 100.
	 */
	public struct function generatePKCE( numeric length = 100 ){
		var code_verifier = generateRandomString( arguments.length );
		return {
			'code_verifier': code_verifier,
			'code_challenge': binaryEncode( charsetDecode( hash( code_verifier, 'sha-256' ), 'utf-8' ), 'base64' ),
			'code_challenge_method': 'S256'
		};
	}


	/**
	 * Generates a random string to the given length of characters
	 *
	 * @length The length of the string to be generated. Between 43 and 128 characters. Defaults to 100.
	 */
	private string function generateRandomString( numeric length = 100 ){
		var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
		var str = '';
		var intLength = ( arguments.length < 43 || arguments.length > 128 ) ? 100 : arguments.length;
		for( var i = 0; i < intLength; i++){
			str &= mid( chars, randrange( 1, len( chars ) ), 1 );
		}
		return str;
	}

}