component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Dropbox Component Suite', function(){
			
			variables.thisProvider = 'dropbox';
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

			var oDropbox = new dropbox(
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
				expect( listToArray( strURL, '&?' ) ).toHaveLength( 8 );

				// expect( strURL ).toBe(
				// 	oDropbox.getAuthEndpoint() & '?client_id=' & clientId 
				// 	& '&redirect_uri=' & oDropbox.getRedirect_URI()
				// 	& '&disable_signup=false'
				// 	& '&force_reauthentication=false'
				// 	& '&state=' & strState
				// 	& '&force_reapprove=false'
				// 	& '&response_type=code'
				// );

			} );

			// it( 'should call the `makeAccessTokenRequest`', function() {

			// 	var test = oDropbox.makeAccessTokenRequest(
			// 		code = 'PFddTB51o5m1GtfyhTC2pxf8MnEQrFo'
			// 	);

			// } );


		});

	}
	
}
