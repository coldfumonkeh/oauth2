component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function beforeAll() {

	}

	function run(){

		describe( 'Bitly Component Suite', function(){

			variables.thisProvider = 'bitly';
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

			var oBitly = new bitly(
				client_id     = clientId,
				client_secret = clientSecret,
				redirect_uri  = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oBitly ).toBeInstanceOf( 'bitly' );
				expect( oBitly ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oBitly.getMemento();

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

				expect( oBitly ).toHaveKey( 'init' );
				expect( oBitly ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oBitly ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oBitly ).toHaveKey( 'buildParamString' );
				expect( oBitly ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();

				var strURL = oBitly.buildRedirectToAuthURL(
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oBitly.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oBitly.getRedirect_URI()
					& '&state=' & strState
					& '&response_type=code'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				var test = oBitly.makeAccessTokenRequest(
					code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
				);

			} );


		});

	}
	
}
