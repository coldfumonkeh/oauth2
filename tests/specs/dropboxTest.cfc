component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Dropbox Component Suite', function(){
			
			var clientId            = '1234567890';
			var clientSecret        = 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX';
			var redirect_uri        = 'http://redirect.fake';

			var oDropbox = new providers.dropbox(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oDropbox ).toBeInstanceOf( 'dropbox' );
				expect( oDropbox ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oDropbox.getMemento();

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

				expect( oDropbox ).toHaveKey( 'init' );
				expect( oDropbox ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oDropbox ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oDropbox ).toHaveKey( 'buildParamString' );
				expect( oDropbox ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();

				var strURL = oDropbox.buildRedirectToAuthURL(
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oDropbox.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oDropbox.getRedirect_URI()
					& '&force_reauthentication=false'
					& '&disable_signup=false'
					& '&force_reapprove=false'
					& '&state=' & strState
					& '&response_type=code'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				var test = oDropbox.makeAccessTokenRequest(
					code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
				);

			} );


		});

	}
	
}
