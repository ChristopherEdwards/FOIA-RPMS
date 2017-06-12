 ;BSTS.ns1.TNamespaceType.1
 ;(C)InterSystems, generated for class BSTS.ns1.TNamespaceType.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;774B6F7A;BSTS.ns1.TNamespaceType
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",O,T,C,E,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",O,T,C,E")) }
