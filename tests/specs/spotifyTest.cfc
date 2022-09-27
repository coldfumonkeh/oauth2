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

			var oSpotify = new spotify(
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


			describe( 'The buildRedirectToAuthURL() method', function(){

				it( 'should return the expected string', function() {

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

					var arrData = listToArray( strURL, '&?' );

					expect( arrData ).toHaveLength( 7 );
					expect( arrData[ 1 ] )
						.toBeString()
						.toBe( oSpotify.getAuthEndpoint() );

					var stuParams = {};
					for( var i = 2; i <= arrayLen( arrData ); i++ ){
						structInsert( stuParams, listGetAt( arrData[ i ], 1, '=' ), listGetAt( arrData[ i ], 2, '=' ) );
					}

					expect( stuParams ).notToHaveKey( 'code_challenge' );
					expect( stuParams ).notToHaveKey( 'code_challenge_method' );

					expect( stuParams[ 'client_id' ] ).toBeString().toBe( clientId );
					expect( stuParams[ 'redirect_uri' ] ).toBeString().toBe( oSpotify.getRedirect_URI() );
					expect( stuParams[ 'show_dialog' ] ).toBeString().toBe( 'false' );
					expect( stuParams[ 'scope' ] ).toBeString().toBe( 'playlist-read-private user-library-read' );
					expect( stuParams[ 'state' ] ).toBeString().toBe( strState );
					expect( stuParams[ 'response_type' ] ).toBeString().toBe( 'code' );

				} );

				it( 'should return the expected string with PKCE when usePKCE is true', function() {

					var strState = createUUID();
					var aScope = [
						'playlist-read-private',
						'user-library-read'
					];
					var strURL = oSpotify.buildRedirectToAuthURL(
						scope = aScope,
						state = strState,
						usePKCE = true
					);

					expect( strURL ).toBeString();

					var arrData = listToArray( strURL, '&?' );

					expect( arrData ).toHaveLength( 9 );
					expect( arrData[ 1 ] )
						.toBeString()
						.toBe( oSpotify.getAuthEndpoint() );

					var stuParams = {};
					for( var i = 2; i <= arrayLen( arrData ); i++ ){
						structInsert( stuParams, listGetAt( arrData[ i ], 1, '=' ), listGetAt( arrData[ i ], 2, '=' ) );
					}

					expect( stuParams ).toHaveKey( 'code_challenge' );
					expect( stuParams ).toHaveKey( 'code_challenge_method' );

					expect( oSpotify.getPKCE() )
						.toBeStruct()
						.toHaveLength( 3 )
						.toHaveKey( 'code_challenge_method' )
						.toHaveKey( 'code_challenge' )
						.toHaveKey( 'code_verifier' );

					expect( stuParams[ 'client_id' ] ).toBeString().toBe( clientId );
					expect( stuParams[ 'redirect_uri' ] ).toBeString().toBe( oSpotify.getRedirect_URI() );
					expect( stuParams[ 'show_dialog' ] ).toBeString().toBe( 'false' );
					expect( stuParams[ 'scope' ] ).toBeString().toBe( 'playlist-read-private user-library-read' );
					expect( stuParams[ 'state' ] ).toBeString().toBe( strState );
					expect( stuParams[ 'response_type' ] ).toBeString().toBe( 'code' );

				} );

			} );

		} );

	}

}
