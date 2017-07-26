component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized google object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public google function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint = 'https://accounts.google.com/o/oauth2/v2/auth', 
		required string accessTokenEndpoint = 'https://www.googleapis.com//oauth2/v4/token',
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
	* @access_type Indicates whether your application can refresh access tokens when the user is not present at the browser. Valid parameter values are online, which is the default value, and offline.
	* @state A unique string value of your choice that is hard to guess. Used to prevent CSRF.
	* @include_granted_scopes Enables applications to use incremental authorization to request access to additional scopes in context. If you set this parameter's value to true and the authorization request is granted, then the new access token will also cover any scopes to which the user previously granted the application access
	* @login_hint If your application knows which user is trying to authenticate, it can use this parameter to provide a hint to the Google Authentication Server. The server uses the hint to simplify the login flow either by prefilling the email field in the sign-in form or by selecting the appropriate multi-login session.
	* @prompt A space-delimited, case-sensitive list of prompts to present the user. If you don't specify this parameter, the user will be prompted only the first time your app requests access. Possible values are:

Set the parameter value to an email address or sub identifier.
	**/
	public string function buildRedirectToAuthURL(
		required array scope,
		required string access_type = 'online',
		required string state,
		boolean include_granted_scopes = true,
		string login_hint,
		string prompt
	){
		var sParams = {
			'response_type' = 'code',
			'scope'         = arrayToList( arguments.scope, ' ' ),
			'access_type' = arguments.access_type,
			'state'         = arguments.state,
			'include_granted_scopes' = arguments.include_granted_scopes
		};
		if( len( arguments.login_hint ) ){
			structInsert( sParams, 'login_hint', arguments.login_hint );
		}
		if( len( arguments.prompt ) ){
			structInsert( sParams, 'prompt', arguments.prompt );
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
		var aFormFields = [
			{
				'name'  = 'grant_type',
				'value' = 'authorization_code'
			}
		];
		return super.makeAccessTokenRequest(
			code       = arguments.code,
			formfields = aFormFields
		);
	}

}