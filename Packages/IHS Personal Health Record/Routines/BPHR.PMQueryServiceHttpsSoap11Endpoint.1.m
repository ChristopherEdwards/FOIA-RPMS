 ;BPHR.PMQueryServiceHttpsSoap11Endpoint.1
 ;(C)InterSystems, generated for class BPHR.PMQueryServiceHttpsSoap11Endpoint.  Do NOT edit. 10/22/2016 08:43:38AM
 ;;6F746A2F;BPHR.PMQueryServiceHttpsSoap11Endpoint
 ;
zqueryRequest(request) public {
 Quit ..WebMethod("queryRequest").Invoke($this,"urn:queryRequest",.request) }
