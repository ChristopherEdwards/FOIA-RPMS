 ;BSTS.ns1.SqlParameterType.1
 ;(C)InterSystems, generated for class BSTS.ns1.SqlParameterType.  Do NOT edit. 10/22/2016 08:53:35AM
 ;;50767770;BSTS.ns1.SqlParameterType
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",STRING,INT,LONG,DATE,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",STRING,INT,LONG,DATE")) }
