 ;BPHR.PMQueryServiceHttpsSoap12Endpoint.1
 ;(C)InterSystems, generated for class BPHR.PMQueryServiceHttpsSoap12Endpoint.  Do NOT edit. 10/22/2016 08:43:38AM
 ;;52646B74;BPHR.PMQueryServiceHttpsSoap12Endpoint
 ;
zqueryRequest(request) public {
 Quit ..WebMethod("queryRequest").Invoke($this,"urn:queryRequest",.request) }
