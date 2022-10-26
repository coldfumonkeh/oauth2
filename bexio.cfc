/**
 * bexio oauth2 component
 */
component extends="oauth2" accessors="true" {

    property name="client_id" type="string";
    property name="client_secret" type="string";
    property name="authEndpoint" type="string";
    property name="accessTokenEndpoint" type="string";
    property name="redirect_uri" type="string";
    
    public bexio function init(
        required string client_id, 
        required string client_secret, 
        required string authEndpoint = 'https://idp.bexio.com/authorize', 
        required string accessTokenEndpoint = 'https://idp.bexio.com/token',
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

    public string function buildRedirectToAuthURL(
        required array scope,
        string require_role     = '',
        boolean force_reapprove = false,
        boolean disable_signup  = false,
        string locale           = '',
        boolean force_reauthentication = false
    )
    {
        var sParams = {
            'response_type'          = 'code',
            'scope'                  = arrayToList( arguments.scope, ' ' ),
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
    )
    {
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
