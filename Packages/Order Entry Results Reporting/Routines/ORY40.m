ORY40 ; SLC/PKS Remove Parameter Entries ; [2/10/00 1:40pm]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**40**;Dec 17, 1997
 Q
 ;
EN ; Entry for removing old parameter and stuffing value into new one.
 ;
 N ORMP
 ;
 S ORMP="ORM TASKMAN QUEUE FREQUENCY"
 D REM(ORMP)  ; Remove parameter entries at PKG, SYS, & DIV levels.
 ;
 S ORMP="ORM ORMTIME LAST RUN"
 D STUF(ORMP) ; Put date/time in new parameter.
 ;
 Q
 ;
REM(ORMP) ; Remove parameters.
 ;
 N ORLST,ORERR,ORE,ORFILE,OROI,ORENT,ORFILE,ORDERR
 ;
 D ENVAL^XPAR(.ORLST,ORMP,"",.ORERR)
 Q:+$G(ORERR)>0
 I 'ORERR,$G(ORLST)>0 D
 .S ORE=""
 .F  S ORE=$O(ORLST(ORE)) Q:+$G(ORE)<1  D
 ..S ORFILE=$P(ORE,";",2)
 ..I ORFILE="DIC(4,"!(ORFILE="DIC(4.2,")!(ORFILE="DIC(9.4") D  ; Institution, Domain, or Package.
 ...S OROI=0
 ...F  S OROI=$O(ORLST(ORE,OROI)) Q:+$G(OROI)<1  D
 ....S ORFILE=+$P(ORE,"(",2)
 ....S ORENT=+ORE
 ....D DEL^XPAR(ORE,ORMP,"`"_OROI,.ORDERR)
 ;
 Q
 ;
STUF(ORMP) ; Put current date/time at System level into new parameter.
 ;
 N ORMERR
 S ORMERR=""
 ;
 D PUT^XPAR("SYS",ORMP,1,$$IDATE2^ORMTIME("NOW"),.ORMERR)
 ;
 Q
 ;
