component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized microsoft object instance.
	* @client_id The client ID for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public microsoft function init(
		required string client_id,
		required string client_secret,
		required string authEndpoint = 'https://login.live.com/oauth20_authorize.srf', 
		required string accessTokenEndpoint = 'https://login.live.com/oauth20_token.srf',
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
	* More info on parameters: https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow#request-an-authorization-code
	* @parameters An optional structure containing key / value pairs of data to be included in the URL string.
	**/
	public string function buildRedirectToAuthURL(
		struct parameters = {}
	){
		var sParams = {
			'response_type' = 'code'
		};
		if( !structIsEmpty( arguments.parameters ) ){
			structAppend( sParams, arguments.parameters, true );
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

}
