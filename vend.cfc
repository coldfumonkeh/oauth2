component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized vend object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public vend function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint 		= 'https://secure.vendhq.com/connect', 
		required string accessTokenEndpoint,  // 'https://SUBDOMAIN.vendhq.com/api/1.0/token'
		required string redirect_uri
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
	**/
	public string function buildRedirectToAuthURL(

	){
		var sParams = {
			'response_type' = 'code'
		};
		return super.buildRedirectToAuthURL( sParams );
	}

	/**
	* I make the HTTP request to obtain the access token.
	* @code The code returned from the authentication request.
	**/
	public struct function makeAccessTokenRequest(
		required string code
	){
		var aHeaders = [
			{
				'name'  = 'Content-Type',
				'value' = 'application/x-www-form-urlencoded'
			}
		];
		
		var aFormFields = [
			{
				'name'  = 'grant_type',
				'value' = 'authorization_code'
			}
		];
		return super.makeAccessTokenRequest(
			code       = arguments.code,
			formfields = aFormFields,
			headers    = aHeaders
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

}