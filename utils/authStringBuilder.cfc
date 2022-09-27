component {

    property name="authEndpoint" type="string" default="";
    property name="client_id" type="string" default="";
    property name="redirect_uri" type="string" default="";
    property name="response_type" type="string" default="code";
    property name="state" type="string" default="";

    property name="PKCECodeChallenge" type="string" default="";
    property name="PKCECodeChallengeMethod" type="string" default="S256";
    property name="PKCECodeVerifier" type="string" default="";

    public authStringBuilder function init(
        required string authEndpoint,
        required string client_id,
        required string redirect_uri,
        string response_type = 'code'
    ){
        setAuthEndpoint( arguments.authEndpoint );
        setClientId( arguments.client_id );
        setRedirectURI( arguments.redirect_uri );
        setResponseType( arguments.response_type );
        return this;
    }

    public void function setAuthEndpoint( required string authEndpoint ){
        variables.authEndpoint = arguments.authEndpoint;
    }

    public void function setClientId( required string client_id ){
        variables.params[ 'client_id' ] = arguments.client_id;
    }

    public void function setRedirectURI( required string redirect_uri ){
        variables.params[ 'redirect_uri' ] = arguments.redirect_uri;
    }

    public void function setResponseType( required string response_type ){
        variables.params[ 'response_type' ] = arguments.response_type;
    }

    public void function setPKCECodeChallenge( required string code_challenge ){
        variables.params[ 'code_challenge' ] = arguments.code_challenge;
    }

    public void function setPKCECodeChallengeMethod( required string code_challenge_method ){
        variables.params[ 'code_challenge_method' ] = arguments.code_challenge_method;
    }

    public void function setPKCECodeVerifier( required string code_verifier ){
        variables.params[ 'code_verifier' ] = arguments.code_verifier;
    }



    public authStringBuilder function withAuthEndpoint(
        required string authEndpoint
    ){
        setAuthEndpoint( arguments.authEndpoint );
        return this;
    }

    public authStringBuilder function withClientId(
        required string client_id
    ){
        setClientId( arguments.client_id );
        return this;
    }

    public authStringBuilder function withResponseType(
        required string response_type
    ){
        setResponseType( arguments.response_type );
        return this;
    }

    public authStringBuilder function withRedirectURI(
        required string redirect_uri
    ){
        setRedirectURI( arguments.redirect_uri );
        return this;
    }

    public authStringBuilder function withState(
        required string state
    ){
        variables.params[ 'state' ] = arguments.state;
        return this;
    }

    public authStringBuilder function withPKCE(
        required string code_challenge,
        required string code_challenge_method,
        required string code_verifier
    ){
        setPKCECodeChallenge( arguments.code_challenge );
        setPKCECodeChallengeMethod( arguments.code_challenge_method );
        setPKCECodeVerifier( arguments.code_verifier );
        return this;
    }

    public authStringBuilder function withParams( required struct parameters ){
        for( var item in arguments.parameters ){
            variables.params[ item ] = arguments.parameters[ item ];
        }
        return this;
    }


    public string function get(){
        var stuParams = duplicate( variables.params );
        structDelete( stuParams, 'code_verifier' );
        return variables.authEndpoint & buildParamString( argScope = stuParams );
    }

    /**
     * Returns a struct representation of the params values stored in variables.params.
     */
    public struct function paramsMemento(){
        return variables.params;
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

}