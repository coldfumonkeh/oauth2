/**
* @displayname CFC OAuth2 Manager
* @name OAuth2 CFC
* @output false
* @hint The oauth2 object.
* @author Giampiero Bonifazi (forked  https://github.com/coldfumonkeh/oauth2 - Matt Gifford)
* @purpose A ColdFusion Component to manage authentication using the OAuth2 protocol.
**/
component accessors="true" {
	
	/**
	* @getter true
	* @setter true
	* @type string
	* @validate string
	* @validateParams { minLength=1 }
	* @hint The client ID for your application.
	**/
	property name="client_id";
	
	/**
	* @getter true
	* @setter true
	* @type string
	* @validate string
	* @validateParams { minLength=1 }
	* @hint The client secret for your application.
	**/
	property name="client_secret";
	
	/**
	* @getter true
	* @setter true
	* @type string
	* @validate string
	* @validateParams { minLength=1 }
	* @hint The URL endpoint that handles the authorization.
	**/
	property name="authEndpoint";
	
	/**
	* @getter true
	* @setter true
	* @type string
	* @validate string
	* @validateParams { minLength=1 }
	* @hint The URL endpoint that handles retrieving the access token.
	**/
	property name="accessTokenEndpoint";
	
	/**
	* @getter true
	* @setter true
	* @type string
	* @validate string
	* @validateParams { minLength=1 }
	* @hint The URL to redirect the user back to following authentication.
	**/
	property name="redirect_uri";

	/**
	* @getter true
	* @setter true
	* @type string
	* @validate string
	* @hint If 'code' indicates that your server expects to receive an authorization code.
	**/
	property name="response_type";

	/**
	* @hint I return an initialized instance.
	* @description I return an initialize oauth2 object instance.
	**/
	public oauth2 function init(
		required string client_id, 
		required string client_secret, 
		required string authEndpoint, 
		required string accessTokenEndpoint, 
		required string redirect_uri,
		string response_type) {

		param name="arguments.response_type" type="string" default="code";

		setClient_id(arguments.client_id);
		setClient_secret(arguments.client_secret);
		setAuthEndpoint(arguments.authEndpoint);
		setAccessTokenEndpoint(arguments.accessTokenEndpoint);
		setRedirect_uri(arguments.redirect_uri);
		setResponse_type(arguments.response_type);
		
		return this;
	}
	
	/**
	* @hint I return the URL as a string which we use to redirect the user for authentication.
	* @description I return the URL as a string which we use to redirect the user for authentication.
	* @parameters A structure containing key / value pairs of data to be included in the URL string.
	**/
	public string function buildRedirectToAuthURL( struct parameters={} ) {
		return getAuthEndpoint() & '?client_id=' & getClient_id() & '&response_type=' & getResponse_type() & '&redirect_uri=' & getRedirect_uri() & buildParamString(argScope = arguments.parameters);
	}
	
	/**
	* @hint I make the HTTP request to obtain the access token.
	* @description I make the HTTP request to obtain the access token.
	* @code The code returned from the authentication request.
	**/
	public struct function makeAccessTokenRequest( required string code ) {
		var stResponse = {};
			httpService = new http(); 
			httpService.setMethod("post"); 
			httpService.setCharset("utf-8"); 
			httpService.setUrl(getAccessTokenEndpoint());
			httpService.addParam(type="header", name="Authorization", value="Basic #ToBase64(getClient_id() & ":" & getClient_secret())#");
			httpService.addParam(type="formfield", name="grant_type", value="authorization_code");
			httpService.addParam(type="formfield", name="client_id", value="#getClient_id()#");
			httpService.addParam(type="formfield", name="client_secret", value="#getClient_secret()#");
			httpService.addParam(type="formfield", name="code", value="#arguments.code#");
			httpService.addParam(type="formfield", name="redirect_uri", value="#getRedirect_uri()#");

			result = httpService.send().getPrefix();

			if (result.ResponseHeader['Status_Code'] == "200") {
				stResponse.success = true;
				stResponse.content = result.FileContent;
			}
			else {
				stResponse.success = false;
				stResponse.content = result.Statuscode;
			}
		return stResponse;
	}
	
	/**
	* @hint I return a string containing any extra URL parameters to concatenate and pass through when authenticating.
	* @description I return a string containing any extra URL parameters to concatenate and pass through when authenticating.
	* @argScope A structure containing key / value pairs of data to be included in the URL string.
	**/
	public string function buildParamString( struct argScope={} ) {
		var strURLParam = '';
			if (structCount(arguments.argScope)) {
				for (key in arguments.argScope) {
					if (listLen(strURLParam)) {
						strURLParam = strURLParam & '&';
					}
					strURLParam = strURLParam & lcase(key) & '=' & trim(arguments.argScope[key]);
				}
				strURLParam = '&' & strURLParam;
			}
		return strURLParam;	
	}

}