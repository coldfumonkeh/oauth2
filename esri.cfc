component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized esri object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public esri function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint = 'https://www.arcgis.com/sharing/rest/oauth2/authorize/', 
		required string accessTokenEndpoint = 'https://www.arcgis.com/sharing/rest/oauth2/token/',
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
	* @expiration 
	**/
	public string function buildRedirectToAuthURL(
		string expiration = ''
	){
		var sParams = {
			'response_type' = 'code'
		};
		if( len( arguments.expiration ) ){
			structInsert( sParams, 'expiration', arguments.expiration );
		}
		return super.buildRedirectToAuthURL( sParams );
	}

	/**
	* I make the HTTP request to obtain the access token.
	* @code The code returned from the authentication request.
	**/
	public struct function makeAccessTokenRequest(
		required string code
	){
		var aFormFields = [];
		return super.makeAccessTokenRequest(
			code       = arguments.code,
			formfields = aFormFields
		);
	}

	/**
	* I make the HTTP request to refresh the access token.
	* @refresh_token The refresh_token returned from the accessTokenRequest request.
	**/
	public struct function refreshAccessTokenRequest(
		required string refresh_token
	){
		return super.refreshAccessTokenRequest(
			refresh_token       = refresh_token
		);
	}

	/**
	* I make the HTTP request to refresh the refresh and access token.
	* @code The code returned from the authentication request.
	* @formfields An optional array of structs for the provider requirements to add new form fields.
	* @headers An optional array of structs to add custom headers to the request if required.
	**/
	public struct function makeRefreshTokenRequest(
		required string refresh_token,
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
			httpService.addParam( type="formfield", name="refresh_token", value=arguments.refresh_token );
	    httpService.addParam( type="formfield", name="grant_type",  value="exchange_refresh_token" );
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

}