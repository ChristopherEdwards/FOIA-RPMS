 ;BSTS.ns1.TAdminPermission.1
 ;(C)InterSystems, generated for class BSTS.ns1.TAdminPermission.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;4956784F;BSTS.ns1.TAdminPermission
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",NA,SA,AA,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",NA,SA,AA")) }
