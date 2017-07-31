component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Instagram Component Suite', function(){
			
			var clientId            = '1234567890';
			var clientSecret        = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX';
			var redirect_uri        = 'http://redirect.fake';

			var oInstagram = new providers.instagram(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oInstagram ).toBeInstanceOf( 'instagram' );
				expect( oInstagram ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oInstagram.getMemento();

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

				expect( oInstagram ).toHaveKey( 'init' );
				expect( oInstagram ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oInstagram ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oInstagram ).toHaveKey( 'buildParamString' );
				expect( oInstagram ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();

				var strURL = oInstagram.buildRedirectToAuthURL(
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oInstagram.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oInstagram.getRedirect_URI()
					& '&state=' & strState
					& '&response_type=code'
				);

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method with scope provided', function() {

				var strState = createUUID();
				var aScope = [
					'public_content',
					'follower_list'
				];
				var strURL = oInstagram.buildRedirectToAuthURL(
					scope = aScope,
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oInstagram.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oInstagram.getRedirect_URI()
					& '&state=' & strState
					& '&scope=public_content follower_list'
					& '&response_type=code'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				var test = oInstagram.makeAccessTokenRequest(
					code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
				);

			} );


		});

	}
	
}
