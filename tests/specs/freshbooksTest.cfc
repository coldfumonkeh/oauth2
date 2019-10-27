component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Freshbooks Component Suite', function(){
			
			variables.thisProvider = 'freshbooks';
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

			var oFreshbooks = new freshbooks(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oFreshbooks ).toBeInstanceOf( 'freshbooks' );
				expect( oFreshbooks ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oFreshbooks.getMemento();

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

				expect( oFreshbooks ).toHaveKey( 'init' );
				expect( oFreshbooks ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oFreshbooks ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oFreshbooks ).toHaveKey( 'buildParamString' );
				expect( oFreshbooks ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var strURL = oFreshbooks.buildRedirectToAuthURL(
					state = strState
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oFreshbooks.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oFreshbooks.getRedirect_URI()
					& '&state=' & strState
					& '&response_type=code'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				oFreshbooks.makeAccessTokenRequest(
					code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
				);

			} );


		});

	}
	
}
