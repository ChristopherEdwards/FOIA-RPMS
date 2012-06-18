BGP8GAON ; IHS/CMI/LAB - AREA OTHER NATIONAL MEASURES GPRA REPORT ; 01 Jul 2008  1:10 PM
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
TESTNTL ;
 S ERR=""
 S LORISUL(1)=""
 S LORISUL(2)=""
 D EP(.ERR,1,2522,"BGP 08 AREA OTHER NATIONAL MEASURES REPORT","A",.LORISUL,1,3030000,3000000,1,"B",$$NOW^XLFDT)
 W !,ERR
 Q
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPRPTT,BGPSUL,BGPQTR,BGPPER,BGPVDT,BGPBEN,BGPROT,BGPRTIME,BGPHC) ;EP - called from GUI to produce national gpra report (AO-AGP)
 ;SEE ROUTINE BGP8DAR for more info
 ;  BGPUSER - DUZ
 ;  BGPDUZ2 - DUZ(2)
 ;  BGPOPTN - OPTION NAME
 ;  BGPRPTT - A or F depending on whether site wants area or facility report, either way you need to display the entries to the user
 ;            from BGP 08 DATA CURRENT that match the following:
 ;            (SEE BGP8ASL or CALL ME)
 ;  BGPSUL  - array containing Iens from BGP 08 ONM DATA CURRENT that the user selected
 ;  BGPSUL - ARRAY OF IENS FROM THE D GET^BGP8ASL(.BGPSUL,.BGPFILE,5,....... call that the user selected
 ;  ;  BGPQTR - this is equal to 1,2,3,4 or 5 depending on how the user answers the following
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
 ;           with a 1 through 4  e.g  305000 (fileman imprecise date for 2008)
 ;           if they chose 5 then this will be the end date the enter
 ;
 ;  BGPVDT - baseline year entered by user in internal fileman format, year only
 ;           e.g.  3010000
 ;
 ;  BGPBEN - 1 for Indians only, 2 for Not Indian, 3 for both (see reader call
 ;           at subroutine BEN in BGP8DL
 ;
 ;  BGPROT - type of output  P for printed, D For Delimited, B for both
 ;  BGPRTIME - report will be queued automatically, this variable
 ;             contains the time it will run, internal fileman format
 ;             must be date and time
 ;  BGPRET - return value is ien^error message a zero (0)^NAME OF EXCEL FILE IF CHOSEN TO DO SO is
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
 I $G(BGPRPTT)="" S BGPRET=0_"^AREA OR FACILITY VARIABLE NOT PASSED" Q
 I '$G(BGPHC),$G(BGPPER)="" S BGPRET=0_"^YEAR VARIABLE NOT PASSED" Q
 I '$G(BGPHC),$G(BGPQTR)="" S BGPRET=0_"^QUARTER/DATE TYPE NOT PASSED" Q
 I '$G(BGPHC),$G(BGPVDT)="" S BGPRET=0_"^BASELINE YEAR NOT PASSED" Q
 I $G(BGPBEN)="" S BGPRET=0_"^BENIFICIARY TYPE NOT PASSED" Q
 I "AF"'[BGPRPTT S BGPRET=0_"^AREA OR FACILTY VARIABLE INVALID" Q
 I "PDB"'[$G(BGPROT) S BGPRET=0_"^REPORT OUTPUT TYPE NOT PASSED" Q
 I '$D(BGPSUL) S BGPRET=0_"^FACILITY ARRAY NOT PASSED" Q
 S X=0,C=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S C=C+1
 I 0 S BGPRET=0_"^FACILITY ARRAY NOT PASSED" Q
 S BGPSUCNT=0
 S BGPSUCNT=C
 I BGPSUCNT=1 S Y=$O(BGPSUL(0)),X=$P(^BGPGPDCE(Y,0),U,9),X=$O(^AUTTLOC("C",X,0)) I X S BGPSUNM=$P(^DIC(4,X,0),U)
 S BGPRTIME=$G(BGPRTIME)
 ;S DUZ=BGPUSER
 S DUZ(2)=BGPDUZ2
 S:'$D(DT) DT=$$DT^XLFDT
 D ^XBKVAR
 S BGPGUI=1
 S IOM=80,BGPIOSL=55
 S BGPAREAA=1
 S BGPRTYPE=7,BGP8RPTH=""
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 S X=0 F  S X=$O(^BGPINDE("ON",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDT="G"
 I '$G(BGPHC) D
 .I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 .I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 .I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 .I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 .I BGPQTR=5 S BGPBD=$$FMADD^XLFDT(BGPPER,-364),BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
 I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 I '$G(BGPHC) D
 .S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 .S X=X_"0000"
 .S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 .S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 .S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 .S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 S BGPRTC="U"
 I $G(BGPHC) D
 .S BGPRTC="H"
 .S (BGPBD,BGPED,BGPTP)=""
 .S X=$O(^BGPCTRL("B",2008,0))
 .S Y=^BGPCTRL(X,0)
 .S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 .S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 .S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 .S BGPPER=$P(Y,U,14),BGPQTR=3
 .S BGPBEN=1
 S BGPDELT="",BGPEXCEL=1
 S BGPC=0,X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BGPC=BGPC+1
 S BGPNOW=$$NOW^XLFDT() S BGPNOW=$P(BGPNOW,".")_"."_$$RZERO^BGP8UTL($P(BGPNOW,".",2),6)
 S BGPFONN1="CRSONMNT1"_$P(^AUTTLOC(DUZ(2),0),U,10)_2008063000000000_$$D^BGP8UTL(BGPNOW)_"_"_$$LZERO^BGP8UTL(BGPC,6)_".TXT"
 S BGPFONN2="CRSONMNT2"_$P(^AUTTLOC(DUZ(2),0),U,10)_2008063000000000_$$D^BGP8UTL(BGPNOW)_"_"_$$LZERO^BGP8UTL(BGPC,6)_".TXT"
 S BGPFONN3="CRSONMNT3"_$P(^AUTTLOC(DUZ(2),0),U,10)_2008063000000000_$$D^BGP8UTL(BGPNOW)_"_"_$$LZERO^BGP8UTL(BGPC,6)_".TXT"
 ;create entry in GUI file
 D ^XBFMK
 S X=BGPUSER_$$NOW^XLFDT
 S DIC="^BGPGUIE(",DIC(0)="L",DIADD=1,DLAYGO=90534.08,DIC("DR")=".02////"_BGPUSER_";.03////"_$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT)_";.05///"_BGPOPTN_";.06///R;.07///"_$G(BGPROT)
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
 S ZTCPU=$G(IOCPU),ZTRTN="AONM^BGP8GAON",ZTDTH=$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT),ZTDESC="GUI AREA ONM REPORT" D ^%ZTLOAD Q
 Q
AONM ;
 K ^TMP($J,"BGPGUI")
 S IOM=80,BGPIOSL=55
 ;cmi/anch/maw added 5/12/2008 for word output
 D GUIR^XBLM("PRINT^BGP8PARQ","^TMP($J,""BGPGUI"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BGPGUI",X)) Q:X'=+X  D
 . S C=C+1
 . N BGPDATA
 . S BGPDATA=$G(^TMP($J,"BGPGUI",X))
 . I BGPDATA="ZZZZZZZ" S BGPDATA=$C(12)
 . S ^BGPGUIE(BGPGIEN,11,C,0)=BGPDATA
 S ^BGPGUIE(BGPGIEN,11,0)="^90534.0811^"_C_"^"_C_"^"_DT
 I BGPRPTT="A" D ONN1^BGP8UTL
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
 S DIE="^BGPGUIE(",DA=BGPGIEN,DR=".04////"_$$NOW^XLFDT_";.06///C"
 D ^DIE
 K DIE,DR,DA
 Q
