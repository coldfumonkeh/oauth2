component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'LinkedIn Component Suite', function(){
			
			var clientId            = '1234567890';
			var clientSecret        = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX';
			var redirect_uri        = 'http://redirect.fake';

			var oLinkedIn = new providers.linkedIn(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oLinkedIn ).toBeInstanceOf( 'linkedIn' );
				expect( oLinkedIn ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oLinkedIn.getMemento();

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

				expect( oLinkedIn ).toHaveKey( 'init' );
				expect( oLinkedIn ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oLinkedIn ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oLinkedIn ).toHaveKey( 'buildParamString' );
				expect( oLinkedIn ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildParamString` method', function() {

				var strParams = oLinkedIn.buildParamString(
					argScope = {
						'one' = 'one',
						'two' = 'two'
					}
				);

				expect( strParams ).toBeString();
				expect( strParams ).toBe( '&two=two&one=one' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var strURL = oLinkedIn.buildRedirectToAuthURL( state = strState );

				expect( strURL ).toBeString();
				expect( strURL ).toBe( oLinkedIn.getAuthEndpoint() & '?client_id=' & clientId & '&redirect_uri=' & oLinkedIn.getRedirect_uri() & '&state=' & strState & '&response_type=code' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method with scopes', function() {

				var strState = createUUID();
				var aScope = [
					'r_fullprofile',
					'r_emailaddress',
					'w_share'
				];

				var strURL = oLinkedIn.buildRedirectToAuthURL(
					state = strState,
					scope = aScope
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe( oLinkedIn.getAuthEndpoint() & '?client_id=' & clientId & '&redirect_uri=' & oLinkedIn.getRedirect_uri() & '&state=' & strState & '&scope=r_fullprofile&r_emailaddress&w_share&response_type=code' );

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				oLinkedIn.makeAccessTokenRequest(
					code = '1234567890'
				);

			} );

		});

	}
	
}
