component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'OAuth2 Component Suite', function(){
			
			var clientId            = '1234567890';
			var clientSecret        = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX';
			var authEndpoint        = 'http://authprovider.fake/authorize';
			var accessTokenEndpoint = 'http://authprovider.fake/token';
			var redirect_uri        = 'http://redirect.fake';

			var oOauth2 = new oauth2(
				client_id           = clientId,
				client_secret       = clientSecret,
				authEndpoint        = authEndpoint,
				accessTokenEndpoint = accessTokenEndpoint,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oOauth2 ).toBeInstanceOf( 'oauth2' );
				expect( oOauth2 ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oOauth2.getMemento();

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

				expect( oOauth2 ).toHaveKey( 'init' );
				expect( oOauth2 ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oOauth2 ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oOauth2 ).toHaveKey( 'buildParamString' );
				expect( oOauth2 ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildParamString` method', function() {

				var strParams = oOauth2.buildParamString(
					argScope = {
						'one' = 'one',
						'two' = 'two'
					}
				);

				expect( strParams ).toBeString();
				expect( strParams ).toBe( '&two=two&one=one' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strURL = oOauth2.buildRedirectToAuthURL();

				expect( strURL ).toBeString();
				expect( strURL ).toBe( authEndpoint & '?client_id=' & clientId & '&redirect_uri=' & redirect_uri );

				// Now with params sent through
				var strURL = oOauth2.buildRedirectToAuthURL(
					parameters = {
						'one' = 'one',
						'two' = 'two'
					}
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe( authEndpoint & '?client_id=' & clientId & '&redirect_uri=' & redirect_uri & '&two=two&one=one' );

			} );

		});

	}
	
}
