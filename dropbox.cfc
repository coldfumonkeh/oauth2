component extends="oauth2" accessors="true" {

	property name="client_id" type="string";
	property name="client_secret" type="string";
	property name="authEndpoint" type="string";
	property name="accessTokenEndpoint" type="string";
	property name="redirect_uri" type="string";
	
	/**
	* I return an initialized dropbox object instance.
	* @client_id The client ID for your application.
	* @client_secret The client secret for your application.
	* @authEndpoint The URL endpoint that handles the authorisation.
	* @accessTokenEndpoint The URL endpoint that handles retrieving the access token.
	* @redirect_uri The URL to redirect the user back to following authentication.
	**/
	public dropbox function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint = 'https://www.dropbox.com/oauth2/authorize', 
		required string accessTokenEndpoint = 'https://api.dropboxapi.com/oauth2/token',
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
	* @require_role If this parameter is specified, the user will be asked to authorize with a particular type of Dropbox account, either work for a team account or personal for a personal account. Your app should still verify the type of Dropbox account after authorization since the user could modify or remove the require_role parameter.
	* @force_reapprove Whether or not to force the user to approve the app again if they've already done so. If false (default), a user who has already approved the application may be automatically redirected to the URI specified by redirect_uri. If true, the user will not be automatically redirected and will have to approve the app again.
	* @disable_signup When true (default is false) users will not be able to sign up for a Dropbox account via the authorization page. Instead, the authorization page will show a link to the Dropbox iOS app in the App Store. This is only intended for use when necessary for compliance with App Store policies.
	* @locale If the locale specified is a supported language, Dropbox will direct users to a translated version of the authorization website. Locale tags should be IETF language tags.
	* @force_reauthentication
	**/
	public string function buildRedirectToAuthURL(
		required string state,
		string require_role,
		boolean force_reapprove = false,
		boolean disable_signup = false,
		string locale,
		boolean force_reauthentication = false
	){
		var sParams = {
			'response_type'          = 'code',
			'state'                  = arguments.state,
			'force_reapprove'        = arguments.force_reapprove,
			'disable_signup'         = arguments.disable_signup,
			'force_reauthentication' = arguments.force_reauthentication
		};
		if( len( arguments.require_role ) ){
			structInsert( sParams, 'require_role', arguments.require_role );
		}
		if( len( arguments.locale ) ){
			structInsert( sParams, 'locale', arguments.locale );
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