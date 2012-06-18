BGP1GGPU ; IHS/CMI/LAB - IHS Diabetes Audit 2003 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
TESTNTL ;
 S ERR=""
 D EP(.ERR,1,2522,"BGP 11 GPRA PERF REPORT",338,1,3040000,3000000,1,1,"B",$$NOW^XLFDT)
 W !,ERR
 Q
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPTAXI,BGPQTR,BGPPER,BGPVDT,BGPBEN,BGPEXPT,BGPROT,BGPRTIME,BGPMFITI,BGPFILE,BGPYNPN,BGPPN) ;EP - called from GUI to produce national GPU report (OTH-GPU)
 ;  BGPUSER - DUZ
 ;  BGPDUZ2 - DUZ(2)
 ;  BGPOPTN - OPTION NAME
 ;  BGPTAXI - IEN OF COMMUNITY TAXONOMY NAME
 ;
 ;  BGPQTR - this is equal to 1,2,3,4 or 5 depending on how the user answers the following
 ;           DIR call:
 ;               Select one of the following:
 ;
 ;         1         January 1 - December 31
 ;         2         April 1 - March 31
 ;         3         July 1 - June 30
 ;         4         October 1 - September 30
 ;         5         User defined date range
 ;       Enter the date range for your report:
 ;
 ;  BGPPER - this is the year they select if they answered the above question
 ;           with a 1 through 4  e.g  305000 (fileman imprecise date for 2010)
 ;           if they chose 5 then this will be the end date the enter
 ;
 ;  BGPVDT - baseline year entered by user in internal fileman format, year only
 ;           e.g.  3010000
 ;
 ;  BGPBEN - 1 for Indians only, 2 for Not Indian, 3 for both (see reader call
 ;           at subroutine BEN in BGP1DL
 ;
 ;  BGPEXPT - EXPORT TO AREA?  1 IS YES, 0 IS NO
 ;  BGPROT - type of output  P for printed, D For Delimited, B for both
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
 I $G(BGPTAXI)="" S BGPRET=0_"^IEN OF COMMUNITY TAXONOMY NOT PASSED" Q
 I '$D(^ATXAX(BGPTAXI)) S BGPRET=0_"^INVALID COMMUNITY TAXONOMY IEN PASSED" Q
 I $G(BGPPER)="" S BGPRET=0_"^YEAR VARIABLE NOT PASSED" Q
 I $G(BGPQTR)="" S BGPRET=0_"^QUARTER/DATE TYPE NOT PASSED" Q
 I $G(BGPVDT)="" S BGPRET=0_"^BASELINE YEAR NOT PASSED" Q
 I $G(BGPBEN)="" S BGPRET=0_"^BENIFICIARY TYPE NOT PASSED" Q
 I $G(BGPEXPT)="" S BGPRET=0_"^AREA EXPORT VALUE NOT PASSED" Q
 I "PDB"'[$G(BGPROT) S BGPRET=0_"^REPORT OUTPUT TYPE NOT PASSED" Q
 S BGPRTIME=$G(BGPRTIME)
 ;S DUZ=BGPUSER
 S DUZ(2)=BGPDUZ2
 S:'$D(DT) DT=$$DT^XLFDT
 D ^XBKVAR
 S BGPGUI=1
 S IOM=80,BGPIOSL=55
 S BGPRTYPE=1,BGP1RPTH="",BGP1GPU=1
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 S X=0 F  S X=$O(^BGPINDB("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDB="G"
 S BGPEXCEL=""
 S BGPUF=""
 I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic/"
 I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPQTR=5 S BGPBD=$$FMADD^XLFDT(BGPPER,-364),BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 I $G(BGPPN)]"" D
 . S BGPSEAT=BGPPN,BGPBEN=3
 K BGPTAX S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 D REPORT^BGP1UTL
 I $G(BGPQUIT) S BGPRET=0_"^COULD NOT CREATE REPORT ENTRY" Q
 I BGPRPT="" S BGPRET=0_"^COULD NOT CREATE REPORT ENTRY" Q
 S BGPFILEN="" I BGPEXPT S BGPFILEN="BG11"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT_"  in directory "_BGPUF
 S BGPDELT=""
 ;create entry in GUI file
 D ^XBFMK
 S X=BGPFILE
 ;S X=BGPUSER_$$NOW^XLFDT
 S BGPGFNM=X
 S DIC="^BGPGUIB(",DIC(0)="L",DIADD=1,DLAYGO=90546.08,DIC("DR")=".02////"_BGPUSER_";.03////"_$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT)_";.05///"_BGPOPTN_";.06///R;.07///"_$G(BGPROT)_";1///"_$G(BGPFILEN)
 K DD,D0,DO D FILE^DICN K DLAYGO,DIADD,DD,D0,DO
 I Y=-1 S BGPRET=0_"^UNABLE TO CREATE ENTRY IN GUI OUTPUT FILE" S ^BGPTMP("GPU")="" Q
 S BGPGIEN=+Y
 ;SEND THE REPORT PROCESS OFF TO THE BACKGROUND USING TASKMAN CALL
 D TSKMN
 S BGPRET=BGPGIEN
 I BGPEXPT S $P(BGPRET,"~",3)=BGPFILEN
 Q
 ;
TSKMN ;
 S ZTIO=""
 K ZTSAVE S ZTSAVE("*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="OTHGPU^BGP1GGPU",ZTDTH=$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT),ZTDESC="GUI GPU GPRA REPORT 06" D ^%ZTLOAD Q
 Q
OTHGPU ;
 I $G(BGPSEAT) D ^BGP1D10
 I '$G(BGPSEAT) D ^BGP1D1
 K ^TMP($J,"BGPGUI")
 S IOM=80,BGPIOSL=55
 D GUIR^BGPXBLM("^BGP1DP","^TMP($J,""BGPGUI"",")
 ;cmi/anch/maw added 5/12/2009 for word output
 S X=0,C=0 F  S X=$O(^TMP($J,"BGPGUI",X)) Q:X'=+X  D
 . S C=C+1
 . N BGPDATA
 . S BGPDATA=$G(^TMP($J,"BGPGUI",X))
 . I BGPDATA="ZZZZZZZ" S BGPDATA=$C(12)
 . S ^BGPGUIB(BGPGIEN,11,C,0)=BGPDATA
 S ^BGPGUIB(BGPGIEN,11,0)="^90546.0811^"_C_"^"_C_"^"_DT
 K ^TMP($J,"BGPGUI")
 ;cmi/anch/maw end of mods
 I BGPEXPT D GS^BGP1UTL
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
 S DIE="^BGPGUIB(",DA=BGPGIEN,DR=".04////"_$$NOW^XLFDT_";.06///C"
 D ^DIE
 K DIE,DR,DA
 Q
