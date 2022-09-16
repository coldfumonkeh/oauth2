component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized twitch object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public twitch function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint = 'https://id.twitch.tv/oauth2/authorize', 
		required string accessTokenEndpoint = 'https://id.twitch.tv/oauth2/token',
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
	* @scope An optional array of values to pass through for scope access.
	* @state A unique string value of your choice that is hard to guess. Used to prevent CSRF.
	* @force_verify Specifies whether the user should be re-prompted for authorization. If this is true, the user always is prompted to confirm authorization.
	**/
	public string function buildRedirectToAuthURL(
		required array scope,
		string state = '',
		boolean force_verify = false
	){
		var sParams = {
			'response_type' = 'code',
			'scope'         = arrayToList( arguments.scope, ' ' )
		};
		if( len( arguments.state ) ){
			structInsert( sParams, 'state', arguments.state );
		}
		structInsert( sParams, 'force_verify', arguments.force_verify );
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
	* I make the HTTP request to obtain the access token.
	* @scope An optional space-separated list of scopes.
	**/
	public struct function makeClientCredentialsRequest(
		array scope = []
	){
		var aFormFields = [
			{
				'name'  = 'grant_type',
				'value' = 'client_credentials'
			},
			{
				'name'  = 'scope',
				'value' = arrayToList( arguments.scope, ' ' )
			}
		];
		
		return super.makeAccessTokenRequest(
			code       = arguments.code,
			formfields = aFormFields
		);
	}

}