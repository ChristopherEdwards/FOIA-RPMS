 ;BSTS.ns1.TRoleModifier.1
 ;(C)InterSystems, generated for class BSTS.ns1.TRoleModifier.  Do NOT edit. 10/22/2016 08:53:37AM
 ;;4A7A4545;BSTS.ns1.TRoleModifier
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",1,2,3,4,5,6,7,8,9,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",1,2,3,4,5,6,7,8,9")) }
