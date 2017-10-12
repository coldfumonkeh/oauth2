component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Spotify Component Suite', function(){
			
			variables.thisProvider  = 'spotify';
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

			var oSpotify = new providers.spotify(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oSpotify ).toBeInstanceOf( 'spotify' );
				expect( oSpotify ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oSpotify.getMemento();

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

				expect( oSpotify ).toHaveKey( 'init' );
				expect( oSpotify ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oSpotify ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oSpotify ).toHaveKey( 'buildParamString' );
				expect( oSpotify ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var aScope = [
					'playlist-read-private',
					'user-library-read'
				];
				var strURL = oSpotify.buildRedirectToAuthURL(
					scope = aScope,
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oSpotify.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oSpotify.getRedirect_URI()
					& '&state=' & strState
					& '&scope=playlist-read-private user-library-read'
					& '&response_type=code'
					& '&show_dialog=false'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				oSpotify.makeAccessTokenRequest(
					code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
				);

			} );


		});

	}
	
}
