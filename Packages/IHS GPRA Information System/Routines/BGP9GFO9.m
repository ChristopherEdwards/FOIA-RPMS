BGP9GFO9 ; IHS/CMI/LAB - GUI Patient Forecast Report ;
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
 ;
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPRT1,BGPDIVI,BGPABD,BGPAED,BGPCLN,BGPPATS,BGPRTIME,BGPFILE) ;EP - called from GUI to produce national GPU report (OTH-GPU)
 ;  BGPUSER - DUZ
 ;  BGPDUZ2 - DUZ(2)
 ;  BGPOPTN - OPTION NAME
 ;  BGPLST - Type of Sort Selected
 ;
 ;  BGPDIV - Medical Center Division
 ;  BGPBDT - Appointment Begin Date
 ;  BGPEDT - Appointment End Date
 ;  BGPCLN - Clinic List
 ;  BGPPAT - Patient List
 ;  BGPPATI - Individual Patient
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
 I $G(BGPLST)="" S BGPRET=0_"^TYPE OF LIST NOT PASSED" Q
 S BGPRTIME=$G(BGPRTIME)
 ;S DUZ=BGPUSER
 S DUZ(2)=BGPDUZ2
 S:'$D(DT) DT=$$DT^XLFDT
 D ^XBKVAR
 S BGPGUI=1
 S IOM=80,BGPIOSL=55
 S BGPRTYPE=1,BGP9RPTH="",BGP9GPU=1,BGPALLPT=1,BGPBEN=3
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 S BGPINDT="G"
 S BGPEXCEL=""
 S BGPUF=$$GETDIR^BGP9UTL2()
 ;I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 ;I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic/" ;AI ;gather all gpra measures
 S X=0 F  S X=$O(^BGPINDN("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S X=$O(^BGPCTRL("B",2009,0))
 S Y=^BGPCTRL(X,0)
 S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 S BGPPER=$P(Y,U,14),BGPQTR=3
 ;ADDED FOR 09 REPORT
 S BGPBD=3090701,BGPED=3100630
 S BGPPBD=3080701,BGPPED=3090630
 S BGPPER=3100000
 S BGPNGR09=1
 S BGPLIST="A"
 S BGPCPLC=0
 S BGPROT="P"  ;output type
 I $G(BGPQUIT) S BGPRET=0_"^COULD NOT CREATE REPORT ENTRY" Q
 ;create entry in GUI file
 D ^XBFMK
 S X=BGPFILE
 S DIC="^BGPGUIN(",DIC(0)="L",DIADD=1,DLAYGO=90537.08,DIC("DR")=".02////"_BGPUSER_";.03////"_$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT)_";.05///"_BGPOPTN_";.06///R;.07///"_$G(BGPROT)
 K DD,D0,DO D FILE^DICN K DLAYGO,DIADD,DD,D0,DO
 I Y=-1 S BGPRET=0_"^UNABLE TO CREATE ENTRY IN GUI OUTPUT FILE" Q
 S BGPGIEN=+Y
 ;SEND THE REPORT PROCESS OFF TO THE BACKGROUND USING TASKMAN CALL
 D TSKMN
 S BGPRET=BGPGIEN
 Q
 ;
TSKMN ;
 S ZTIO=""
 K ZTSAVE S ZTSAVE("*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="GUIP^BGP9GFO9",ZTDTH=$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT),ZTDESC="GUI FORECAST 09 FOR 09" D ^%ZTLOAD Q
 Q
GUIP ;
 D PROC^BGP9DPA9
 K ^TMP($J,"BGP9DPA")
 S IOM=80,BGPIOSL=55
 D GUIR^XBLM("PRINT^BGP9DPAW","^TMP($J,""BGP9DPA"",")
 ;cmi/anch/maw added 5/12/2007 for word output
 S X=0,C=0 F  S X=$O(^TMP($J,"BGP9DPA",X)) Q:X'=+X  D
 . S C=C+1
 . N BGPDATA
 . S BGPDATA=$G(^TMP($J,"BGP9DPA",X))
 . I BGPDATA="ZZZZZZZ" S BGPDATA=$C(12)
 . S ^BGPGUIN(BGPGIEN,11,C,0)=BGPDATA
 S ^BGPGUIN(BGPGIEN,11,0)="^90537.0811^"_C_"^"_C_"^"_DT
 K ^TMP($J,"BGP9DPA")
 ;cmi/anch/maw end of mods
 D ENDLOG
 D XIT
 Q
 ;
XIT ;
 K ^TMP($J)
 S:$D(ZTQUEUED) ZTREQ="@"
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
 S DIE="^BGPGUIN(",DA=BGPGIEN,DR=".04////"_$$NOW^XLFDT_";.06///C"
 D ^DIE
 K DIE,DR,DA
 Q
