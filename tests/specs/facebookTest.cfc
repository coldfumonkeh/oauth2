component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Facebook Component Suite', function(){
			
			variables.thisProvider = 'facebook';
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

			var oFacebook = new facebook(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oFacebook ).toBeInstanceOf( 'facebook' );
				expect( oFacebook ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oFacebook.getMemento();

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

				expect( oFacebook ).toHaveKey( 'init' );
				expect( oFacebook ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oFacebook ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oFacebook ).toHaveKey( 'buildParamString' );
				expect( oFacebook ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var aScope = [
					'public_profile',
					'email'
				];
				var strURL = oFacebook.buildRedirectToAuthURL(
					scope = aScope,
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oFacebook.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oFacebook.getRedirect_URI()
					& '&state=' & strState
					& '&scope=public_profile email'
					& '&response_type=code'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				oFacebook.makeAccessTokenRequest(
					code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
				);

			} );


		});

	}
	
}
