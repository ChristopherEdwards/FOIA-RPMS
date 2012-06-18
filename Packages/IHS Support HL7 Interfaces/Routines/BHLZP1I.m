BHLZP1I ; cmi/sitka/maw - BHL File Incoming ZP1 segment ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine has two purposes, it will be used to determine if this
 ;is a new patient or existing, and then it will be used to update
 ;other health record numbers if necessary
 ;
MAIN ;-- this is the main routine driver     
 D PROCESS,EOJ
 Q
 ;
PROCESS ;-- process and file the data
 S BHLDA=0 F  S BHLDA=$O(@BHLTMP@(BHLDA)) Q:BHLDA=""  D
 . S BHLHRCN=$G(@BHLTMP@(BHLDA,1))
 . S BHLHRFAC=$P(@BHLTMP@(BHLDA,2),U)
 . S BHLDI=$G(@BHLTMP@(BHLDA,3))
 . S BHLRD=$G(@BHLTMP@(BHLDA,4))
 . S BHLRS=$G(@BHLTMP@(BHLDA,5))
 . K DIE,DA,DR
 . S DIE="^AUPNPAT(",DA=BHLPAT,DR="4101///`"_BHLHRFAC
 . S DR(2,9000001.41)=".02///"_BHLHRCN
 . D ^DIE
 . I $D(Y) S BHLERCD="NOUP41" X BHLERR Q
 . S BHLFL="^AUPNPAT("_BHLPAT_",41,",BHLFL2="9000001.41",BHLX=BHLPAT
 . S BHLVAL=BHLHRFAC
 . S BHLFLD=.03,BHLVAL2=BHLDI X BHLDIEM
 . S BHLFLD=.04,BHLVAL2=BHLRD X BHLDIEM
 . S BHLFLD=.05,BHLVAL2=BHLRS X BHLDIEM
 Q
 ;
CHKPAT ;-- this will get the HRCN and lookup to find the patient
 ;this has become obsolete with GCPR
 N BHLR
 S BHLR="ZP1",BHLSGIEN=$O(^BHLS("B",BHLR,0))
 S BHLDA=0 F  S BHLDA=$O(@BHLTMP@(BHLDA)) Q:BHLDA=""!($D(BHLPAT))  D
 . S BHLHRCN=$G(@BHLTMP@(BHLDA,1))
 . S BHLHRFAC=$P(@BHLTMP@(BHLDA,2),U)
 . Q:$G(@BHLTMP@(BHLDA,3))
 . S (BHLDUZ2,DUZ(2))=BHLHRFAC
 . K DIC S DIC=9000001,DIC(0)="MZ",X=BHLHRCN D ^DIC
 . I +Y>0 S BHLDFN=+Y
 . D CHKPAT^BHLPIDI
 . Q:$D(BHLPAT)
 K DIC
 Q
 ;
EOJ ;-- end of job kill variables
 K @BHLTMP
 K BHLHRCN,BHLHRFAC,BHLDR,BHLRD,BHLRD,BHLVAL,BHLFL,BHLFLD,BHLFL2
 K BHLFLD2,BHLVAL2,BHLX
 Q
 ;
