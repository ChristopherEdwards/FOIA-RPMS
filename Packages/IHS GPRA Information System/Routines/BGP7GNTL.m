BGP7GNTL ; IHS/CMI/LAB - IHS Diabetes Audit 2003 27 Apr 2007 10:56 PM ; 13 Dec 2006  7:35 AM
 ;;7.0;IHS CLINICAL REPORTING;**1**;JAN 24, 2007
 ;
 ;
TESTNTL ;
 S ERR=""
 D EP(.ERR,1,2522,"BGP 07 NATIONAL GPRA REPORT",338,1,"B",$$NOW^XLFDT)
 W !,ERR
 Q
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPTAXI,BGPEXPT,BGPROT,BGPRTIME,BGPMFITI,BGPYWCHW,BGPONEF) ;EP - called from GUI to produce national gpra report (NTL-GP)
 ;  BGPUSER - DUZ
 ;  BGPDUZ2 - DUZ(2)
 ;  BGPOPTN - OPTION NAME
 ;  BGPTAXI - IEN OF COMMUNITY TAXONOMY NAME
 ;  BGPEXPT - EXPORT TO AREA?  1 IS YES, 0 IS NO
 ;  BGPROT - type of output  P for printed, D For Delimited, B for both
 ;  BGPRTIME - report will be queued automatically, this variable
 ;             contains the time it will run, internal fileman format
 ;             must be date and time
 ;  BGPONEF - one or multiple files of height/weight
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
 I $G(BGPTAXI)="" S BGPRET=0_"^IEN OF COMMUNITY TAXONOMY NOT PASSED" Q
 I '$D(^ATXAX(BGPTAXI)) S BGPRET=0_"^INVALID COMMUNITY TAXONOMY IEN PASSED" Q
 I $G(BGPEXPT)="" S BGPRET=0_"^AREA EXPORT VALUE NOT PASSED" Q
 I "PDB"'[$G(BGPROT) S BGPRET=0_"^REPORT OUTPUT TYPE NOT PASSED" Q
 S BGPRTIME=$G(BGPRTIME)
 S DUZ=BGPUSER
 S DUZ(2)=BGPDUZ2
 S:'$D(DT) DT=$$DT^XLFDT
 D ^XBKVAR
 S BGPGUI=1
 S IOM=80,BGPIOSL=55
 S BGPRTYPE=1,BGP7RPTH=""
 S BGPBD=3060701,BGPED=3070630
 S BGPBBD=2990701,BGPBED=3000630
 S BGPPBD=3050701,BGPPED=3060630
 S BGPPER=3070000,BGPQTR=3
 S BGPBEN=1
 ;S BGPYWCHW=0  ;LAB - ADDED V6.1
 ;LORI REMOVE THIS AFTER TESTING
 ;S BGPBD=3030101,BGPED=3031231
 ;S BGPBBD=3000101,BGPBED=3001231
 ;S BGPPBD=3020101,BGPPED=3021231
 ;S BGPPER=3030000,BGPQTR=3,BGPBEN=1
 K BGPTAX S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 S X=0 F  S X=$O(^BGPINDA("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDT="G",BGPHWNOW=$$NOW^XLFDT()
 S BGPEXCEL=""
 I BGPYWCHW="",BGPEXPT S BGPYWCHW=$S($P($G(^BGPSITE(DUZ(2),0)),U,11)=0:0,1:1)
 S BGPUF=""
 I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic/"
 D REPORT^BGP7UTL
 I $G(BGPQUIT) S BGPRET=0_"^COULD NOT CREATE REPORT ENTRY" Q
 I BGPRPT="" S BGPRET=0_"^COULD NOT CREATE REPORT ENTRY" Q
 S BGPFILEN="BG07"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT_"  in directory "_BGPUF
 S BGPDELT=""
 I BGPYWCHW=2 D
 .S BGPNOW=$$NOW^XLFDT() S BGPNOW=$P(BGPNOW,".")_"."_$$RZERO^BGP7UTL($P(BGPNOW,".",2),6)
 .S BGPFN="HW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP7UTL(BGPBD)_$$D^BGP7UTL(BGPED)_$$D^BGP7UTL(BGPNOW)_"_000001"_".TXT"
 ;create entry in GUI file
 D ^XBFMK
 S X=BGPUSER_$$NOW^XLFDT
 S BGPGFNM=X
 S DIC="^BGPGUIA(",DIC(0)="L",DIADD=1,DLAYGO=90531.08,DIC("DR")=".02////"_BGPUSER_";.03////"_$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT)_";.05///"_BGPOPTN_";.06///R;.07///"_$G(BGPROT)
 K DD,D0,DO D FILE^DICN K DLAYGO,DIADD,DD,D0,DO
 I Y=-1 S BGPRET=0_"^UNABLE TO CREATE ENTRY IN GUI OUTPUT FILE" Q
 S BGPGIEN=+Y
 ;SEND THE REPORT PROCESS OFF TO THE BACKGROUND USING TASKMAN CALL
 D TSKMN
 S BGPRET=BGPGIEN
 I BGPEXPT S $P(BGPRET,U,3)=BGPFILEN
 I BGPYWCHW=2 S $P(BGPRET,U,4)=BGPFN
 Q
 ;
TSKMN ;
 S ZTIO=""
 K ZTSAVE S ZTSAVE("*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="NTLGP^BGP7GNTL",ZTDTH=$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT),ZTDESC="GUI NATIONAL GPRA REPORT 06" D ^%ZTLOAD Q
 Q
NTLGP ;
 D ^BGP7D1
 K ^TMP($J,"BGPGUI")
 S IOM=80,BGPIOSL=55
 ;cmi/anch/maw added 5/12/2007 for word output
 D GUIR^XBLM("^BGP7DP","^TMP($J,""BGPGUI"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BGPGUI",X)) Q:X'=+X  D
 . S C=C+1
 . N BGPDATA
 . S BGPDATA=$G(^TMP($J,"BGPGUI",X))
 . I BGPDATA="ZZZZZZZ" S BGPDATA=$C(12)
 . S ^BGPGUIA(BGPGIEN,11,C,0)=BGPDATA
 S ^BGPGUIA(BGPGIEN,11,0)="^90531.0811^"_C_"^"_C_"^"_DT
 K ^TMP($J,"BGPGUI")
 ;cmi/anch/maw end of mods
 I BGPEXPT D GS^BGP7UTL
 I $G(BGPYWCHW)=2 D HWSF^BGP7DNG
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
 S DIE="^BGPGUIA(",DA=BGPGIEN,DR=".04////"_$$NOW^XLFDT_";.06///C"
 D ^DIE
 K DIE,DR,DA
 Q
