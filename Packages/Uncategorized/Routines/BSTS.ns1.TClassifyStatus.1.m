 ;BSTS.ns1.TClassifyStatus.1
 ;(C)InterSystems, generated for class BSTS.ns1.TClassifyStatus.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;48396C4B;BSTS.ns1.TClassifyStatus
 ;
zIsValid(%val) public {
	Q $s(%val'[","&&(",SUCCESS,CLASSIFY_NOT_REQUIRED,MISSING_KIND_ERROR,MISSING_DEFINING_CONCEPT_ERROR,CYCLE_ERROR,EQ_ERROR,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",SUCCESS,CLASSIFY_NOT_REQUIRED,MISSING_KIND_ERROR,MISSING_DEFINING_CONCEPT_ERROR,CYCLE_ERROR,EQ_ERROR")) }
