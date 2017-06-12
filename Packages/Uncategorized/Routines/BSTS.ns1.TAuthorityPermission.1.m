 ;BSTS.ns1.TAuthorityPermission.1
 ;(C)InterSystems, generated for class BSTS.ns1.TAuthorityPermission.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;34436663;BSTS.ns1.TAuthorityPermission
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",R,M,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",R,M")) }
