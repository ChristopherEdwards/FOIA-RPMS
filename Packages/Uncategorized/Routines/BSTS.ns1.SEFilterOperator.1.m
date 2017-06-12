 ;BSTS.ns1.SEFilterOperator.1
 ;(C)InterSystems, generated for class BSTS.ns1.SEFilterOperator.  Do NOT edit. 10/22/2016 08:53:35AM
 ;;48316A6F;BSTS.ns1.SEFilterOperator
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",MATCHES,NONE,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",MATCHES,NONE")) }
