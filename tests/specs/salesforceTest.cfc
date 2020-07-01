component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Salesforce Component Suite', function(){
			
			variables.thisProvider = 'salesforce';
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

			var oSalesForce = new salesforce(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oSalesForce ).toBeInstanceOf( 'salesforce' );
				expect( oSalesForce ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oSalesForce.getMemento();

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

				expect( oSalesForce ).toHaveKey( 'init' );
				expect( oSalesForce ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oSalesForce ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oSalesForce ).toHaveKey( 'buildParamString' );
				expect( oSalesForce ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildParamString` method', function() {

				var strParams = oSalesForce.buildParamString(
					argScope = {
						'one' = 'one',
						'two' = 'two'
					}
				);

				expect( strParams ).toBeString();
				expect( strParams ).toBe( '&one=one&two=two' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var strState = createUUID();
				var strURL = oSalesForce.buildRedirectToAuthURL( state = strState );

				expect( strURL ).toBeString();
				expect( strURL ).toBe( oSalesForce.getAuthEndpoint() & '?client_id=' & clientId & '&redirect_uri=' & oSalesForce.getRedirect_uri() & '&state=' & strState & '&response_type=code' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method with scopes', function() {

				var strState = createUUID();
				var aScope = [
					'api',
					'refresh_token'
				];

				var strURL = oSalesForce.buildRedirectToAuthURL(
					state = strState,
					scope = aScope
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe( 
					oSalesForce.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oSalesForce.getRedirect_uri() 
					& '&scope=api refresh_token'
					& '&state=' & strState 
					& '&response_type=code'
				);

			} );

			it( 'should call the `makeAccessTokenRequest`', function() {

				oSalesForce.makeAccessTokenRequest(
					code = '1234567890'
				);

			} );

		});

	}
	
}
