INHSYS11 ;PO/SAIC; 17 Jun 99 15:45; installation utiltiy,  error summary 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;
 ;
 ;COPYRIGHT 1999 SAIC
 Q
 ;
FLSUMERR(INFILE,INFLD,INIEN,INDAT,INROOT) ; record file/fields error summaries
 ;Input:
 ; INFILE  - file or sub-file number
 ; INFDL   - field number
 ; INIEN   - entry ien
 ; INDAT   - data value of the field that calling program was trying to
 ;           insert
 ; INROOT  - root node of the entry
 ;
 Q:'$G(^UTILITY("INHSYS_FILERR",$J))   ;error summary will not be collected, if this node is not set to true
 S ^UTILITY("INHSYS_FILERR",$J,+$G(INFILE),INROOT)=""
 I INIEN>0 D   ; this is a failed field insert
 .S ^UTILITY("INHSYS_FILERR",$J,+$G(INFILE),INROOT,"FLD",+$G(INIEN),+$G(INFLD))=INDAT
 E  D          ; this is a failed DIC lookup
 .S:INDAT="" INDAT="unknown .01 field"
 .S ^UTILITY("INHSYS_FILERR",$J,+$G(INFILE),INROOT,"FILE",INDAT)=""
 Q
 ;
FLRPTERR() ;report file/fields error summary
 ;Input:
 ;  None
 ; Output
 ;  returns 1 if any error was found
 ;
 N C,INCNT,INDAT,INERRMSG,INFILE,INFLD,INIEN,INX,INROOT,Y
 Q:'$O(^UTILITY("INHSYS_FILERR",$J,0)) 0
 D HEADER("FILE/FIELD RESTORE ERROR SUMMARY")
 W !,"File number and name"
 W !,?3,"Error Type",?23,".01 value or"
 W !,?23,"Zero node --> Zero node value"
 W !,?7,"Field#",?17,"Value"
 D DASHLINE()
 ;
 S INFILE=0
 F  S INFILE=$O(^UTILITY("INHSYS_FILERR",$J,INFILE)) Q:'INFILE  D
 .;S INX=$P($G(^DIC(INFILE,0)),U)
 .S INX=$O(^DD(+INFILE,0,"NM",""))
 .W !,INFILE,"-",INX,!
 .S INROOT=""
 .F  S INROOT=$O(^UTILITY("INHSYS_FILERR",$J,INFILE,INROOT)) Q:INROOT=""  D
 ..S INDAT=""
 ..I $O(^UTILITY("INHSYS_FILERR",$J,INFILE,INROOT,"FILE",""))'="" W ?3,"Failed DIC Lookup"
 ..F  S INDAT=$O(^UTILITY("INHSYS_FILERR",$J,INFILE,INROOT,"FILE",INDAT)) Q:INDAT=""  D
 ...W ?23,INDAT,!
 ..;
 ..S INIEN=""
 ..;I $O(^UTILITY("INHSYS_FILERR",$J,INFILE,INROOT,"FLD",""))'="" W ?3,"Failed Update:"
 ..F  S INIEN=$O(^UTILITY("INHSYS_FILERR",$J,INFILE,INROOT,"FLD",INIEN)) Q:INIEN=""  D
 ...;  get the external value of the field data
 ...;  note: make sure C=$P(^DD(INFILE,.01,0),U,2) is exactly before the
 ...;        call to Y^DIQ,  otherwise you get intermittent results
 ...S Y=$P($G(@(INROOT_INIEN_",0)")),U),C=$P(^DD(INFILE,.01,0),U,2) D Y^DIQ
 ...W ?3,"Failed Update",?23,(INROOT_INIEN_",0)"),"-->",Y,!
 ...S INFLD=0
 ...F  S INFLD=$O(^UTILITY("INHSYS_FILERR",$J,INFILE,INROOT,"FLD",INIEN,INFLD)) Q:INFLD=""  D
 ....W ?7,INFLD,?17,^UTILITY("INHSYS_FILERR",$J,INFILE,INROOT,"FLD",INIEN,INFLD),!
 W !!,"            ****  End of File/Field Restore Error Summary  ****",!
 Q 1
 ;
SUMERR(INERRMSG) ;record the error messages for error summary
 ;Input:
 ;  INERRMSG  - error message text
 ;
 Q:'$G(^UTILITY("INHSYS_FILERR",$J))   ;error summary will not be collected, if this node is not set to true.  please notice the INHSYS_FILERR vs INSHSYS_SUMERR subscript.
 N INCNT
 S INCNT=$G(^UTILITY("INHSYS_SUMERR",$J))+1
 S ^UTILITY("INHSYS_SUMERR",$J)=INCNT
 S ^UTILITY("INHSYS_SUMERR",$J,INCNT)=INERRMSG
 Q
 ;
RPTERR() ;report the error summary
 ;Input:
 ;  None
 ; Output
 ;  returns 1 if any error was found
 N INCNT
 Q:'$O(^UTILITY("INHSYS_SUMERR",$J,0)) 0
 D HEADER("COMPILATION ERROR SUMMARY")
 D DASHLINE()
 S INCNT=0
 F  S INCNT=$O(^UTILITY("INHSYS_SUMERR",$J,INCNT)) Q:'INCNT  D
 .W !,^UTILITY("INHSYS_SUMERR",$J,INCNT)
 W !!,"                ****  End of Compilation Error Summary  ****",!
 Q 1
 ;
HEADER(INTITLE) ;write the first two lines of the header
 ;Input:
 ;  INTITLE - title of the header
 ;
 N INMTF,INTIME
 S INMTF=$$GETMTF(),INTIME=$$CDATASC^%ZTFDT($H,1,1)
 W !,INMTF,?(80-$L(INTIME)),INTIME
 W !,$G(INTITLE)
 Q
DASHLINE() ; display a dashline
 W !,"--------------------------------------------------------------------------------"
 Q
 ;
SPRTCNTR() ; display a message to contact support center
 W !!
 W !,?9,"********************************************************"
 W !,?9,"*  Errors encountered during this installation. It is  *"
 W !,?9,"*  recommended that you contact the Support Center.    *"
 W !,?9,"********************************************************"
 W !!
 Q
 ;
GETMTF() ;Get the name of the primary MTF (only one per CHCS system)
 ;Input:
 ;  none
 ;Output:
 ;  returns name of the primary MTF
 N Y,X
 S Y=$G(^DD("SITE",1)) Q:'Y ""
 S X=$P($G(^DIC(4,Y,0)),U)
 Q X
 ;
ALLSUMER(INKILL) ;report summary errors if any. kill the utility global if it is required
 ;Input:
 ;  INKILL  = if true kill the Utility global that contains these errors
 ;
 ;if error summary is requested, display it on the user's current device 
 N X,Y
 I $G(^UTILITY("INHSYS_FILERR",$J)) D
 .S X=$$FLRPTERR^INHSYS11()
 .S Y=$$RPTERR^INHSYS11()
 I $G(X)!$G(Y) D SPRTCNTR()
 K:$G(INKILL) ^UTILITY("INHSYS_SUMERR",$J),^UTILITY("INHSYS_FILERR",$J)
 Q
