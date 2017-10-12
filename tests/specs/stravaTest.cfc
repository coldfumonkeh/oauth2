component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Strava Component Suite', function(){
			
			variables.thisProvider = 'strava';
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

			var oStrava = new providers.strava(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oStrava ).toBeInstanceOf( 'strava' );
				expect( oStrava ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oStrava.getMemento();

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

				expect( oStrava ).toHaveKey( 'init' );
				expect( oStrava ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oStrava ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oStrava ).toHaveKey( 'buildParamString' );
				expect( oStrava ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var aScope = [
					'write'
				];
				var strURL = oStrava.buildRedirectToAuthURL(
					scope = aScope,
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oStrava.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oStrava.getRedirect_URI()
					& '&state=' & strState
					& '&scope=write'
					& '&response_type=code'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				oStrava.makeAccessTokenRequest(
					code = 'de18b29c281a8e23144126a130f2c14202187c57'
				);

			} );


		});

	}
	
}
