component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Google Component Suite', function(){
			
			variables.thisProvider = 'google';
			variables.sProviderData = {};

			include 'providerData.properties.cfm';

			if( structKeyExists( variables.providerInfo, variables.thisProvider ) ){
				variables.sProviderData = variables.providerInfo[ variables.thisProvider ];
			} else {
				variables.sProviderData = variables.providerInfo[ 'default' ];
			}

			var clientId     = variables.sProviderData[ 'clientId' ];
			var clientSecret = variables.sProviderData[ 'clientSecret' ];
			var redirect_uri = variables.sProviderData[ 'redirect_uri' ];

			var oGoogle = new google(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oGoogle ).toBeInstanceOf( 'google' );
				expect( oGoogle ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oGoogle.getMemento();

				expect( sMemento ).toBeStruct().toHaveLength( 5 );

				expect( sMemento ).toHaveKey( 'client_id' );
				expect( sMemento ).toHaveKey( 'client_secret' );
				expect( sMemento ).toHaveKey( 'authEndpoint' );
				expect( sMemento ).toHaveKey( 'accessTokenEndpoint' );
				expect( sMemento ).toHaveKey( 'redirect_uri' );

				expect( sMemento[ 'client_id' ] ).toBeString().toBe( clientId );
				expect( sMemento[ 'client_secret' ] ).toBeString().toBe( clientSecret );
				expect( sMemento[ 'redirect_uri' ] ).toBeString().toBe( redirect_uri );

			} );

			it( 'should have the correct methods', function() {

				expect( oGoogle ).toHaveKey( 'init' );
				expect( oGoogle ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oGoogle ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oGoogle ).toHaveKey( 'buildParamString' );
				expect( oGoogle ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var aScope = [
					'https://www.googleapis.com/auth/drive.readonly',
					'https://www.googleapis.com/auth/analytics.readonly'
				];
				var strURL = oGoogle.buildRedirectToAuthURL(
					scope = aScope,
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oGoogle.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oGoogle.getRedirect_URI()
					& '&scope=https://www.googleapis.com/auth/drive.readonly https://www.googleapis.com/auth/analytics.readonly'
					& '&access_type=online'
					& '&state=' & strState
					& '&response_type=code'
					& '&include_granted_scopes=true'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				oGoogle.makeAccessTokenRequest(
					code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
				);

			} );


		});

	}
	
}
