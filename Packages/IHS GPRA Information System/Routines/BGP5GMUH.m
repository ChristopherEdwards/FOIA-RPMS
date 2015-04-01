BGP5GMUH ; IHS/CMI/LAB - GUI MU HOS REPORT ;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
 ;
TESTMU ;
 S ERR=""
 S BGPND(1)="",BGPND(3)=""
 S BGPLIST(3)=""
 D EP(.ERR,5459,5217,"BGP 15 ME EP REPORT",338,"C",.BGPND,1,311010,3000000,1,"A",.BGPLIST,"BUTCHER,LORI","5459","P",$$NOW^XLFDT,"","LORITESTMU")
 W !,ERR
 Q
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPTAXI,BGPINDT,BGPIND,BGPQTR,BGPPER,BGPVDT,BGPBEN,BGPLSTT,BGPLIST,BGPPRV,BGPPROV,BGPROT,BGPRTIME,BGPMFITI,BGPFILE) ;EP - called from GUI to produce COM REPORT CI05-RPT-LOC-COM
 ; SEE ROUTINE BGP5DL if you have questions about any of these variables
 ;  BGPUSER - DUZ
 ;  BGPDUZ2 - DUZ(2)
 ;  BGPOPTN - OPTION NAME
 ;  BGPINDT - $E (1st character) of the answer to the following DIR call:
 ;            value will be a S, C, M, A
 ;               Select one of the following:
 ;
 ;               Which set of Measures should be included in this report:
 ;
 ;  BGPIND - note:  THIS ARRAY IS ONLY REQUIRED IF BGPINDT="S" OR "M"
 ;           array containing iens of the measures selected by the user
 ;           for example, BGPIND(3)=""
 ;                        BGPIND(6)="" if the user selected measures
 ;                        1 and 6 from the BGP 15 INDICATORS file.  When
 ;                        you present them to the user for selection use all of them
 ;                        in the file, do not screen out any of them.
 ;
 ;  BGPQTR - this is equal to 1,2
 ;               Select one of the following:
 ;
 ;         1         90 DAYS
 ;         2         ONE YEAR
 ;
 ;       Enter the date range for your report:
 ;
 ;  BGPPER - this is beginning date in fileman format
 ;
 ;  BGPVDT - baseline year entered by user in internal fileman format, year only
 ;           e.g.  3010000
 ;
 ;  BGPBEN - 1 for Indians only, 2 for Not Indian, 3 for both (see reader call
 ;           at subroutine BEN in BGP5MUEP
 ;
 ;  BGPLIST (array) contains the iens of the measures they want a list for.
 ;        when you present the choices for lists only present the measures they pick
 ;        that are in array BGPIND (run report to see this)
 ;        e.g.  BGPLIST="A"
 ;              BGPLIST(3)=""
 ;
 ;  BGPLPRV - will equal ien of provider if they picked FOR THE REPORT
 ;  BGPLPROV - will equal provider name if they picked FOR THE REPORT
 ;
 ;  BGPROT - type of output  P for printed, D For Delimited, B for both, X XML
 ;  BGPRTIME - report will be queued automatically, this variable
 ;             contains the time it will run, internal fileman format
 ;             must be date and time
 ;
 ;  BGPRET - return value is ien^error message^export file name. a zero (0) is
 ;  passed as ien if error occurred, display the filename back to the user
 ;  if they chose to export to area
 ;
 ;create entry in gui output file
 ;queue report to run with/GUIR
 D EP1
 S Y=BGPRET
 ;D EN^XBVK("BGP") S:$D(ZTQUEUED) ZTREQ="@"
 S BGPRET=Y
 Q
EP1 ;
 S U="^"
 I $G(BGPUSER)="" S BGPRET=0_"^USER NOT PASSED" Q
 I $G(BGPDUZ2)="" S BGPRET=0_"^DUZ(2) NOT PASSED" Q
 I $G(BGPOPTN)="" S BGPRET=0_"^OPTION NAME NOT PASSED" Q
 I $G(BGPINDT)="" S BGPRET=0_"^INDICATOR TYPE NOT PASSED" Q
 I "ACMS"'[BGPINDT S BGPRET=0_"^INDICATOR TYPE INVALID" Q
 I BGPINDT="S",'$D(BGPIND) S BGPRET=0_"^INDICATOR ARRAY NOT PASSED" Q
 I BGPINDT="S",'$O(BGPIND(0)) S BGPRET=0_"^INDICATOR ARRAY NOT PASSED" Q
 I BGPINDT="M",'$D(BGPIND) S BGPRET=0_"^INDICATOR ARRAY NOT PASSED" Q
 I BGPINDT="M",'$O(BGPIND(0)) S BGPRET=0_"^INDICATOR ARRAY NOT PASSED" Q
 I $G(BGPPER)="" S BGPRET=0_"^YEAR VARIABLE NOT PASSED" Q
 I $G(BGPQTR)="" S BGPRET=0_"^QUARTER/DATE TYPE NOT PASSED" Q
 I $G(BGPVDT)="" S BGPRET=0_"^BASELINE YEAR NOT PASSED" Q
 I $G(BGPBEN)="" S BGPRET=0_"^BENEFICIARY TYPE NOT PASSED" Q
 I "PDBX"'[$G(BGPROT) S BGPRET=0_"^REPORT OUTPUT TYPE NOT PASSED" Q
 I $G(BGPLSTT)="" S BGPRET=0_"^LIST TYPE NOT PASSED" Q
 S BGPRTIME=$G(BGPRTIME)
 S BGPLIST=$G(BGPLSTT)
 I $G(BGPPROV)'?.N S BGPPROV=BGPPRV
 ;I $G(BGPLIST)="P",$G(BGPLPRV)="" S BGPRET=0_"^PROVIDER NOT PASSED FOR LIST TYPE P" Q
 ;S DUZ=BGPUSER
 S DUZ(2)=BGPDUZ2
 S:'$D(DT) DT=$$DT^XLFDT
 D ^XBKVAR
 S BGPGUI=1
 S IOM=80,BGPIOSL=55
 ;S BGPINDT=""
 S BGPINDT=""
 S BGPMUYF="90595.11"
 S BGPRTYPE=4,BGP0RPTH="A"
 S BGPMUT="H" ; BGPMU Hospital Measures
 I BGPINDT="H" K BGPIND D HI
 ;I BGPINDT="A" K BGPIND D AI
 S BGPLEN=$S(BGPQTR=1:89,1:364)
BY ;get baseline year
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBD=BGPPER
 S:$E(BGPBD,4,7)="0000" $E(BGPBD,4,7)="0101"
 S BGPED=$$FMADD^XLFDT(BGPPER,BGPLEN)
PY ;get previous  year
 N X1,X2,X
 S X1=BGPBD,X2=-365
 D C^%DTC
 S BGPPBD=X
 S X1=BGPED,X2=-365
 D C^%DTC
 S BGPPED=X
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 ;create entry in GUI file
 D ^XBFMK
 S X=BGPFILE
 ;S X=BGPUSER_$$NOW^XLFDT
 S BGPGFNM=X   ;S X=BGPUSER_$$NOW^XLFDTS X=BGPUSER_$$NOW^XLFDT
 S DIC="^BGPGUIK(",DIC(0)="L",DIADD=1,DLAYGO=90554.19,DIC("DR")=".02////"_BGPUSER_";.03////"_$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT)_";.05///"_BGPOPTN_";.06///R;.07///"_$G(BGPROT)
 K DD,D0,DO D FILE^DICN K DLAYGO,DIADD,DD,D0,DO
 I Y=-1 S BGPRET=0_"^UNABLE TO CREATE ENTRY IN GUI OUTPUT FILE" Q
 S BGPGIEN=+Y
 S BGPDELT=""
 ;SEND THE REPORT PROCESS OFF TO THE BACKGROUND USING TASKMAN CALL
 D TSKMN
 S BGPRET=BGPGIEN
 Q
 ;
TSKMN ;
 S ZTIO=""
 K ZTSAVE S ZTSAVE("*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="MU^BGP5GMUH",ZTDTH=$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT),ZTDESC="CRS GUI MU HOS REPORT" D ^%ZTLOAD
 D UPLOG^BGPGUA(BGPGIEN,ZTSK)
 Q
MU ;EP
 D ^BGPMUEHD
 K ^TMP($J,"BGPGUI")
 S IOM=80,BGPIOSL=55
 D GUIR^BGPXBLM("^BGPMUPP","^TMP($J,""BGPGUI"",")
 ;cmi/anch/maw added 5/12/2009 for word output
 S X=0,C=0 F  S X=$O(^TMP($J,"BGPGUI",X)) Q:X'=+X  D
 . S C=C+1
 . N BGPDATA
 . S BGPDATA=$G(^TMP($J,"BGPGUI",X))
 . I BGPDATA="ZZZZZZZ" S BGPDATA=$C(12)
 . S ^BGPGUIK(BGPGIEN,11,C,0)=BGPDATA
 S ^BGPGUIK(BGPGIEN,11,0)="^90554.1911^"_C_"^"_C_"^"_DT
 K ^TMP($J,"BGPGUI")
 ;cmi/anch/maw end of mods
 D ENDLOG
 D XIT
 Q
 ;
XIT ;
 K ^TMP($J)
 D EN^XBVK("BGP") S:$D(ZTQUEUED) ZTREQ="@"
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
 D KILL^AUPNPAT
 D ^XBFMK
 L -^BGPDATA
 Q
 ;
ENDLOG ;-- UPDATE LOG AT END
 S DIE="^BGPGUIK(",DA=BGPGIEN,DR=".04////"_$$NOW^XLFDT_";.06///C"
 D ^DIE
 K DIE,DR,DA
 Q
HI ;-- get all mu hospital indicators
 S X=0 F  S X=$O(^BGPMUIND(BGPMUYF,"AMS","H",X)) Q:X'=+X  S BGPIND(X)=""
 Q
 ;
