 ;BSTS.ns1.SESearchAttribute.1
 ;(C)InterSystems, generated for class BSTS.ns1.SESearchAttribute.  Do NOT edit. 10/22/2016 08:53:35AM
 ;;7746566D;BSTS.ns1.SESearchAttribute
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",CONCEPT_NAME,CONCEPT_NAME_OR_SYNONYM,ASSOCIATION,PROPERTY,SYNONYM,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",CONCEPT_NAME,CONCEPT_NAME_OR_SYNONYM,ASSOCIATION,PROPERTY,SYNONYM")) }
