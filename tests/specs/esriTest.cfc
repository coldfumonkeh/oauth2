component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'ESRI Component Suite', function(){
			
			variables.thisProvider = 'esri';
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

			var oESRI = new esri(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oESRI ).toBeInstanceOf( 'esri' );
				expect( oESRI ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oESRI.getMemento();

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

				expect( oESRI ).toHaveKey( 'init' );
				expect( oESRI ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oESRI ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oESRI ).toHaveKey( 'refreshAccessTokenRequest' );
				expect( oESRI ).toHaveKey( 'buildParamString' );
				expect( oESRI ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strURL = oESRI.buildRedirectToAuthURL();

				expect( strURL ).toBeString();
				
				var arrData = listToArray( strURL, '&?' );

				expect( arrData ).toHaveLength( 4 );
				expect( arrData[ 1 ] )
					.toBeString()
					.toBe( oESRI.getAuthEndpoint() );

				var stuParams = {};
				for( var i = 2; i <= arrayLen( arrData ); i++ ){
					structInsert( stuParams, listGetAt( arrData[ i ], 1, '=' ), listGetAt( arrData[ i ], 2, '=' ) );
				}

				expect( stuParams[ 'client_id' ] ).toBeString().toBe( clientId );
				expect( stuParams[ 'redirect_uri' ] ).toBeString().toBe( oESRI.getRedirect_URI() );
				expect( stuParams[ 'response_type' ] ).toBeString().toBe( 'code' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method with an expiration', function() {

				var expiration = 'foo';

				var strURL = oESRI.buildRedirectToAuthURL(
					expiration = expiration
				);

				expect( strURL ).toBeString();

				var arrData = listToArray( strURL, '&?' );

				expect( arrData ).toHaveLength( 5 );
				expect( arrData[ 1 ] )
					.toBeString()
					.toBe( oESRI.getAuthEndpoint() );

				var stuParams = {};
				for( var i = 2; i <= arrayLen( arrData ); i++ ){
					structInsert( stuParams, listGetAt( arrData[ i ], 1, '=' ), listGetAt( arrData[ i ], 2, '=' ) );
				}

				expect( stuParams[ 'client_id' ] ).toBeString().toBe( clientId );
				expect( stuParams[ 'redirect_uri' ] ).toBeString().toBe( oESRI.getRedirect_URI() );
				expect( stuParams[ 'response_type' ] ).toBeString().toBe( 'code' );
				expect( stuParams[ 'expiration' ] ).toBeString().toBe( expiration );

			} );

		} );

	}
	
}
