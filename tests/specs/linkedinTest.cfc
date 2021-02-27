component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'LinkedIn Component Suite', function(){
			
			variables.thisProvider = 'linkedIn';
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

			var oLinkedIn = new linkedIn(
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

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var strURL = oLinkedIn.buildRedirectToAuthURL( state = strState );

				expect( strURL ).toBeString();
				// expect( strURL ).toBe( oLinkedIn.getAuthEndpoint() & '?client_id=' & clientId & '&redirect_uri=' & oLinkedIn.getRedirect_uri() & '&state=' & strState & '&response_type=code' );

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

				var arrData = listToArray( strURL, '&?' );

				expect( arrData ).toHaveLength( 6 );
				expect( arrData[ 1 ] )
					.toBeString()
					.toBe( oLinkedIn.getAuthEndpoint() );

				var stuParams = {};
				for( var i = 2; i <= arrayLen( arrData ); i++ ){
					structInsert( stuParams, listGetAt( arrData[ i ], 1, '=' ), listGetAt( arrData[ i ], 2, '=' ) );
				}

				expect( stuParams[ 'client_id' ] ).toBeString().toBe( clientId );
				expect( stuParams[ 'redirect_uri' ] ).toBeString().toBe( oLinkedIn.getRedirect_URI() );
				expect( stuParams[ 'scope' ] ).toBeString().toBe( 'r_fullprofile%20r_emailaddress%20w_share' );
				expect( stuParams[ 'state' ] ).toBeString().toBe( strState );
				expect( stuParams[ 'response_type' ] ).toBeString().toBe( 'code' );

			} );

		} );

	}
	
}
