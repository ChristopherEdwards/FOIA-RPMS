 ;BSTS.ns1.TItemsConnected.1
 ;(C)InterSystems, generated for class BSTS.ns1.TItemsConnected.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;564E6769;BSTS.ns1.TItemsConnected
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",C,S,T,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",C,S,T")) }
