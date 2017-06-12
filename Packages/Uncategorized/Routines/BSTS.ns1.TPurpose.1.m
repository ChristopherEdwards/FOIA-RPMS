 ;BSTS.ns1.TPurpose.1
 ;(C)InterSystems, generated for class BSTS.ns1.TPurpose.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;63346D47;BSTS.ns1.TPurpose
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",A,M,H,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",A,M,H")) }
