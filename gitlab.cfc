component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized gitlab object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public gitlab function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint = 'https://gitlab.com/oauth/authorize', 
		required string accessTokenEndpoint = 'https://gitlab.com/oauth/token',
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
	* @usePKCE Boolean value. If true, the PKCE extension is triggered and will generate PKCE data and also store it as a CFC property.
	**/
	public string function buildRedirectToAuthURL(
		required string state,
		boolean usePKCE = false
	){
		var sParams = {
			'response_type' = 'code',
			'state'         = arguments.state
		};
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

}