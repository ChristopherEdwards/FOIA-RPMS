 ;BSTS.ns1.TModifiesItemType.1
 ;(C)InterSystems, generated for class BSTS.ns1.TModifiesItemType.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;32304B75;BSTS.ns1.TModifiesItemType
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",C,T,N,V,A,S,E,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",C,T,N,V,A,S,E")) }
