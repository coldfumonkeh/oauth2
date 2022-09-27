component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized xero object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	* see https://developer.xero.com/documentation/oauth2/auth-flow
	* see https://developer.xero.com/myapps/
	* see https://github.com/richardmh/xero2
	**/
	public xero function init(
		required string client_id, 
		required string client_secret, 
		required string redirect_uri,
		required string authEndpoint = 'https://login.xero.com/identity/connect/authorize', 
		required string accessTokenEndpoint = 'https://identity.xero.com/connect/token'
	)
	{
		super.init(
			client_id           = arguments.client_id, 
			client_secret       = arguments.client_secret, 
			authEndpoint        = arguments.authEndpoint, 
			accessTokenEndpoint = arguments.accessTokenEndpoint, 
			redirect_uri        = arguments.redirect_uri
		);
		return this;
	}

	/**
	* I return the URL as a string which we use to redirect the user for authentication.
	* @state A unique string value of your choice that is hard to guess. Used to prevent CSRF.
	* @scope An optional array of values to pass through for scope access.
	* @usePKCE Boolean value. If true, the PKCE extension is triggered and will generate PKCE data and also store it as a CFC property.
	**/
	public string function buildRedirectToAuthURL(
		required string state,
		array scope = [],
		boolean usePKCE = false
	){
		var sParams = {
			'response_type' = 'code',
			'state'         = arguments.state
		};
		if( arrayLen( arguments.scope ) ){
			structInsert(
				sParams,
				'scope',
				arrayToList( arguments.scope, '%20' )
			);
		}
		if( arguments.usePKCE ){
			var stuPKCE = super.generatePKCE();
			setPKCE( stuPKCE );
			structAppend( sParams, stuPKCE );
		}
		return super.buildRedirectToAuthURL( sParams );
	}

	/**
	* I make the HTTP request to obtain the access token.
	* @code The code returned from the authentication request.
	* @usePKCE Boolean value. If true, the PKCE extension is triggered and will use the stored PKCE code_verifier
	**/
	public struct function makeAccessTokenRequest(
		required string code,
		boolean usePKCE = false
	){
		var aFormFields = [];
		if( arguments.usePKCE ){
			arrayAppend( aFormFields, {
				'name': 'code_verifier',
				'value': getPKCE()[ 'code_verifier' ]
			} );
		}
		return super.makeAccessTokenRequest(
			code       = arguments.code,
			formfields = aFormFields
		);
	}
	
	/**
	* I make the HTTP request to refresh the access token.
	* @refresh_token As returned with the most recent access token.
	* xero requires:
	* header:  Authorization: "Basic " + toBase64(client_id + ":" + client_secret)
	* body: grant_type="refresh_token"
	* body: refresh_token="Your refresh token"
	**/
	public struct function makeRefreshTokenRequest(
		required string refresh_token
	){
		var stuResponse = {};
	    var httpService = new http();
	    httpService.setMethod( "post" ); 
	    httpService.setCharset( "utf-8" );
	    httpService.setUrl( getAccessTokenEndpoint() );
	    httpService.addParam( type="header", name="Content-Type", value="application/x-www-form-urlencoded" );
	    var str = "#getClient_id()#:#getClient_secret()#";
	    httpService.addParam( type="header", name="Authorization", value="Basic #toBase64(str)#" );
	    httpService.addParam( type="formfield", name="grant_type", 	 value="refresh_token" );
	    httpService.addParam( type="formfield", name="refresh_token", 	 value=arguments.refresh_token );
	    
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

}