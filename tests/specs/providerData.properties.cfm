<cfscript>
variables.providerInfo = {
	'default': {
		'clientId'    :'1234567890',
		'clientSecret': 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX',
		'redirect_uri': 'http://redirect.fake'
	}
};
</cfscript>

<!---

This properties file can be extended should you wish to test the providers using real 
application data.

Simply add a new struct to the `variables.providerInfo` above with the 
name of the provider (which must match the value used in the associated test suite) and 
apply your clientId, clientSecret and redirect_uri values to that struct.

If no match for a specific provider is found, the tests will use the default dummy values.

--->