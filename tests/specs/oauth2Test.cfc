component extends='testbox.system.BaseSpec'{

	function beforeAll(){
		variables.clientId            = '1234567890';
		variables.clientSecret        = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX';
		variables.authEndpoint        = 'http://authprovider.fake/authorize';
		variables.accessTokenEndpoint = 'http://authprovider.fake/token';
		variables.redirect_uri        = 'http://redirect.fake';

		variables.oOauth2 = new oauth2(
			client_id           = variables.clientId,
			client_secret       = variables.clientSecret,
			authEndpoint        = variables.authEndpoint,
			accessTokenEndpoint = variables.accessTokenEndpoint,
			redirect_uri        = variables.redirect_uri
		);
	}

	function run(){

		describe( 'OAuth2 Component Suite', function(){

			describe( 'Component Instantiation', function() {

				it( 'should return the correct object', function(){

					expect( variables.oOauth2 ).toBeInstanceOf( 'oauth2' );
					expect( variables.oOauth2 ).toBeTypeOf( 'component' );

				});

				it( 'should have the correct properties', function() {

					var sMemento = variables.oOauth2.getMemento();

					expect( sMemento ).toBeStruct().toHaveLength( 5 );

					expect( sMemento ).toHaveKey( 'client_id' );
					expect( sMemento ).toHaveKey( 'client_secret' );
					expect( sMemento ).toHaveKey( 'authEndpoint' );
					expect( sMemento ).toHaveKey( 'accessTokenEndpoint' );
					expect( sMemento ).toHaveKey( 'redirect_uri' );

					expect( sMemento[ 'client_id' ] ).toBeString().toBe( clientId );
					expect( sMemento[ 'client_secret' ] ).toBeString().toBe( clientSecret );
					expect( sMemento[ 'authEndpoint' ] ).toBeString().toBe( authEndpoint );
					expect( sMemento[ 'accessTokenEndpoint' ] ).toBeString().toBe( accessTokenEndpoint );
					expect( sMemento[ 'redirect_uri' ] ).toBeString().toBe( redirect_uri );

				} );

				it( 'should have the correct methods', function() {

					makePublic( variables.oOauth2, 'generateRandomString', 'generateRandomString' );

					expect( variables.oOauth2 ).toHaveKey( 'init' );
					expect( variables.oOauth2 ).toHaveKey( 'buildRedirectToAuthURL' );
					expect( variables.oOauth2 ).toHaveKey( 'makeAccessTokenRequest' );
					expect( variables.oOauth2 ).toHaveKey( 'buildParamString' );
					expect( variables.oOauth2 ).toHaveKey( 'getMemento' );
					expect( variables.oOauth2 ).toHaveKey( 'generateRandomString' );
					expect( variables.oOauth2 ).toHaveKey( 'generatePKCE' );

				} );

			} );

			describe( 'Running Methods', function(){

				describe( 'The buildParamString() method', function(){

					it( 'should return the expected value', function(){

						var stuParamsIn = { 'one': 'one', 'two': 'two' }

						var resp = variables.oOauth2.buildParamString( argScope = stuParamsIn );

						expect( resp )
							.toBeString()

						var paramVals = mid( resp, 2, len( resp ) );

						expect( left( resp, 1 ) ).toBe( '?' );
						expect( listLen( paramVals, '&' ) ).toBe( 2 )

						var arrValsOut = listToArray( paramVals, '&' );
						expect( arrValsOut ).toHaveLength( 2 );

						for( var item in arrValsOut ){
							var thisKey = listGetAt( item, 1, '=' );
							var thisVal = listGetAt( item, 2, '=' );
							expect( structKeyExists( stuParamsIn, thisKey ) ).toBe( true );
							expect( stuParamsIn[ thisKey ] ).toBe( thisVal );
						}

					} );

				} );

				describe( 'The buildRedirectToAuthURL() method', function(){

					it( 'should return the expected string value', function() {

						var resp = variables.oOauth2.buildRedirectToAuthURL();

						expect( resp ).toBeString();
						expect( resp ).toBe(
							authEndpoint & '?client_id=' & clientId
							& '&redirect_uri=' & redirect_uri
						);

						expect( listToArray( resp, '&?' ) ).toHaveLength( 3 );

						var stuParamsIn = { 'one' = 'one', 'two' = 'two' };
						// Now with params sent through
						var resp = variables.oOauth2.buildRedirectToAuthURL(
							parameters = stuParamsIn
						);

						expect( resp )
							.toBeString();

						var paramVals = mid( resp, 1, len( resp ) );

						var arrValsOut = listToArray( paramVals, '?&' );
						expect( arrValsOut ).toHaveLength( 5 );

						expect( arrValsOut[ 1 ] ).toBe( variables.authEndpoint );

						arrValsOut = arraySlice( arrValsOut, 2 );

						for( var item in arrValsOut ){
							var thisKey = listGetAt( item, 1, '=' );
							var thisVal = listGetAt( item, 2, '=' );
							expect( structKeyExists( stuParamsIn, thisKey ) ).toBe( true );
							expect( stuParamsIn[ thisKey ] ).toBe( thisVal );
						}

						expect( listToArray( resp, '&?' ) ).toHaveLength( 5 );


					} );

				} );

				describe( 'The generateRandomString() method', function() {

					it( 'should return a random string of the expected length', function() {

						var resp = variables.oOauth2.generateRandomString();
						expect( resp ).toBeString().toHaveLength( 100 );

						var resp2 = variables.oOauth2.generateRandomString( 45 );
						expect( resp2 ).toBeString().toHaveLength( 45 );

						var resp3 = variables.oOauth2.generateRandomString( 20 );
						expect( resp3 ).toBeString().toHaveLength( 100 );

						var resp4 = variables.oOauth2.generateRandomString( 130 );
						expect( resp4 ).toBeString().toHaveLength( 100 );

					} );

				} );

				describe( 'The generatePKCE() method', function() {

					it( 'should return a struct of expected information', function() {

						var resp = variables.oOauth2.generatePKCE( length = 100 );

						expect( resp )
							.toBeStruct()
							.toHaveKey( 'code_verifier' )
							.toHaveKey( 'code_challenge' )
							.toHaveKey( 'code_challenge_method' );

						expect( resp[ 'code_verifier' ] ).toBeString().toHaveLength( 100 );
						expect( resp[ 'code_challenge_method' ] ).toBeString().toBe( 'S256' );

						var resp = variables.oOauth2.generatePKCE( length = 43 );

						expect( resp )
							.toBeStruct()
							.toHaveKey( 'code_verifier' )
							.toHaveKey( 'code_challenge' )
							.toHaveKey( 'code_challenge_method' );

						expect( resp[ 'code_verifier' ] ).toBeString().toHaveLength( 43 );
						expect( resp[ 'code_challenge_method' ] ).toBeString().toBe( 'S256' );

					} );

					it( 'should call the generateRandomString() method once', function() {

						var mockObj = createMock( 'oauth2' ).init(
							client_id           = variables.clientId,
							client_secret       = variables.clientSecret,
							authEndpoint        = variables.authEndpoint,
							accessTokenEndpoint = variables.accessTokenEndpoint,
							redirect_uri        = variables.redirect_uri
						);

						mockObj.$(
							method = 'generateRandomString',
							returns = 'RL0XW95rTty7gxZg6Kr07w-wt5f9fMKIVuBfe3e2QioIUTta'
						);

						var resp = mockObj.generatePKCE();
						expect( mockObj.$count( 'generateRandomString' ) ).toBe( 1 );

					} );

				} );

				describe( 'The makeAccessTokenRequestWithPKCE() method', function() {

					it( 'should call the makeAccessTokenRequest() method', function() {

						var mockObj = createMock( 'oauth2' ).init(
							client_id           = variables.clientId,
							client_secret       = variables.clientSecret,
							authEndpoint        = variables.authEndpoint,
							accessTokenEndpoint = variables.accessTokenEndpoint,
							redirect_uri        = variables.redirect_uri
						);

						mockObj.$( method = 'makeAccessTokenRequest', returns = {} );

						var resp = mockObj.makeAccessTokenRequestWithPKCE(
							code = '123456',
							code_verifier = '7890'
						);

						expect( mockObj.$count( 'makeAccessTokenRequest' ) ).toBe( 1 );

					} );

				} );

			} );

		});

	}

}
