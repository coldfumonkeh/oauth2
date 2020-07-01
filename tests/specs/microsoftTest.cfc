component extends='testbox.system.BaseSpec'{
	
	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( 'Microsoft Component Suite', function(){
			
			variables.thisProvider = 'microsoft';
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

			var oMicrosoft = new microsoft(
				client_id           = clientId,
				client_secret       = clientSecret,
				redirect_uri        = redirect_uri
			);
			
			it( 'should return the correct object', function(){

				expect( oMicrosoft ).toBeInstanceOf( 'microsoft' );
				expect( oMicrosoft ).toBeTypeOf( 'component' );

			});

			it( 'should have the correct properties', function() {

				var sMemento = oMicrosoft.getMemento();

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

				expect( oMicrosoft ).toHaveKey( 'init' );
				expect( oMicrosoft ).toHaveKey( 'buildRedirectToAuthURL' );
				expect( oMicrosoft ).toHaveKey( 'makeAccessTokenRequest' );
				expect( oMicrosoft ).toHaveKey( 'buildParamString' );
				expect( oMicrosoft ).toHaveKey( 'getMemento' );

			} );

			it( 'should return a string when calling the `buildRedirectToAuthURL` method', function() {

				var aScope = [
					'User.Read',
					'Contacts.Read'
				];
				var strURL = oMicrosoft.buildRedirectToAuthURL(
					scope = aScope
				);

				expect( strURL ).toBeString();
				expect( strURL ).toBe(
					oMicrosoft.getAuthEndpoint() & '?client_id=' & clientId 
					& '&redirect_uri=' & oMicrosoft.getRedirect_URI()
					& '&scope=User.Read Contacts.Read'
					& '&response_type=code'
				);

			} );

			// it( 'should call the `makeAccessTokenRequest`', function() {

			// 	oMicrosoft.makeAccessTokenRequest(
			// 		code = 'M043a6be6-1529-b05e-6691-7622e3cdd10f'
			// 	);

			// } );


		});

	}
	
}
