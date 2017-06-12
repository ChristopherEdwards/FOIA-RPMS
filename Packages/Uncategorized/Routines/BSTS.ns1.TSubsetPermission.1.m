 ;BSTS.ns1.TSubsetPermission.1
 ;(C)InterSystems, generated for class BSTS.ns1.TSubsetPermission.  Do NOT edit. 10/22/2016 08:53:37AM
 ;;49665272;BSTS.ns1.TSubsetPermission
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",R,W,M,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",R,W,M")) }
