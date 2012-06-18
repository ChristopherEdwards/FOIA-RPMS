BGP1GNPL ; IHS/CMI/LAB - IHS Diabetes Audit 2003 26 Mar 2010 5:09 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
TESTNTL ;
 S ERR=""
 S BGPND(4)="",BGPND(3)=""
 F X=2:1:5 S BGPINDL(3,X)=""
 F X=6:1:9 S BGPINDL(4,X)=""
 D EP(.ERR,1,2522,"BGP 11 NATIONAL PAT LISTS",338,.BGPND,.BGPINDL,1,3040000,"A","","","B",$$NOW^XLFDT)
 W !,ERR
 Q
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPTAXI,BGPIND,BGPINDL,BGPQTR,BGPPER,BGPLIST,BGPLPRV,BGPLPROV,BGPROT,BGPRTIME,BGPMFITI,BGPVDT,BGPBEN,BGPFILE) ;EP - called from GUI to produce national gpra report (NTL-GP)
 ; SEE ROUTINE BGP1NPL if you have questions about any of these variables
 ;  BGPUSER - DUZ
 ;  BGPDUZ2 - DUZ(2)
 ;  BGPOPTN - OPTION NAME
 ;  BGPTAXI - IEN OF COMMUNITY TAXONOMY NAME
 ;  BGPIND - array containing iens of the measures selected by the user
 ;           for example, BGPIND(3)=""
 ;                        BGPIND(6)="" if the user selected measures
 ;                        1 and 6 from the BGP 11 INDICATORS file.  When
 ;                        you present them to the user for selection use the
 ;                        ^BGPINDB("AGPRA",1,ien) xref as the ones with a second
 ;                        subscript of 1 are the GPRA measures.   Or you can set
 ;                        DIC("S")="I $P(^(0),U,7)=1" , if the 7th piece is one
 ;                        then show that measure to the user.
 ;  BGPINDL - array containing the lists wanted for each measure selected
 ;            and put in array BGPIND, you will loop through the measures they
 ;            selected and you put in BGPIND and then display to the user the
 ;            entries from BGP 11 NATIONAL PATIENT LISTS that point to that
 ;            measure by using the "B" index on ^BGPNPLB(.  ^BGPNPLB("B",measure ien,ien)
 ;            For example, measure 3 Nephropathy assessment has 4 lists available:
 ;            Documented A1c, No Documented A1c, Poor Glycemic Control, Ideal Glycemic Control
 ;            If the user wants lists 1 and 2 the array would look like:
 ;            BGPINDL(3,2)=""
 ;            BGPINDL(3,3)=""
 ;
 ;  BGPQTR - this is equal to 1,2,3,4 or 5 depending on how the user answers the following
 ;           DIR call:
 ;               Select one of the following:
 ;
 ;         1         January 1 - December 31
 ;         2         April 1 - March 31
 ;         3         July 1 - June 30
 ;         4         October 1 - September 30
 ;         5         User-Defined Report Period
 ;       Enter the date range for your report:
 ;
 ;  BGPPER - this is the year they select if they answered the above question
 ;           with a 1 through 4  e.g  305000 (fileman imprecise date for 2010)
 ;           If they chose 5 then this would be the end date they entered, e.g.
 ;           3050301
 ;
 ;  BGPLIST - this contains the answer to the following DIR call:
 ;          
 ;        Select one of the following:
 ;         P         Patient List by Provider
 ;         A         All Patients
 ;
 ;        Choose report type for the Lists: R//
 ;
 ;  BGPLPRV - will equal ien of provider if they picked "P" above
 ;  BGPLPROV - will equal provider name if they picked "P" above
 ;
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
 I '$D(BGPIND) S BGPRET=0_"^INDICATOR ARRAY NOT PASSED" Q
 I '$O(BGPIND(0)) S BGPRET=0_"^INDICATOR ARRAY NOT PASSED" Q
 I '$D(BGPINDL) S BGPRET=0_"^REPORT LISTS ARRAY NOT PASSED" Q
 I '$O(BGPINDL(0)) S BGPRET=0_"^REPORT LISTS ARRAY NOT PASSED" Q
 I $G(BGPPER)="" S BGPRET=0_"^YEAR VARIABLE NOT PASSED" Q
 I $G(BGPQTR)="" S BGPRET=0_"^QUARTER/DATE TYPE NOT PASSED" Q
 I "PDB"'[$G(BGPROT) S BGPRET=0_"^REPORT OUTPUT TYPE NOT PASSED" Q
 I $G(BGPLIST)="" S BGPRET=0_"^LIST TYPE NOT PASSED" Q
 I $G(BGPVDT)="" S BGPRET=0_"^BASELINE YEAR NOT PASSED" Q
 I $G(BGPBEN)="" S BGPRET=0_"^BENEFICIARY TYPE NOT PASSED" Q
 I $G(BGPLIST)="P",$G(BGPLPRV)="" S BGPRET=0_"^PROVIDER NOT PASSED FOR LIST TYPE P" Q
 S BGPRTIME=$G(BGPRTIME)
 S BGPRTC="U"
 ;S DUZ=BGPUSER
 S DUZ(2)=BGPDUZ2
 S:'$D(DT) DT=$$DT^XLFDT
 D ^XBKVAR
 S BGPGUI=1
 S IOM=80,BGPIOSL=55
 S BGPRTYPE=1,BGP1RPTH="",BGPNPL=1,BGPINDB="G",BGP1GPU=1  ;maw orig 3/11/2010
 I BGPOPTN="CRS 11 OTHER NATIONAL MEASURES PAT LISTS" D  ;maw orig 3/11/2010
 . S BGPRTYPE=7,BGP1RPTH="",BGPNPL=1,BGPINDB="G",BGP1GPU=1,BGPONMR=1  ;maw new 3/11/2010
 I BGPOPTN="CRS 11 OTHER NATIONAL MEASURES PAT LISTS" D  ;maw orig 3/11/2010
 . S BGPRTYPE=7,BGP1RPTH="",BGPNPL=1,BGPINDB="G",BGP1GPU=1,BGPONMR=1  ;maw new 6/9/2011
 K BGPTAX S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPQTR=5 S BGPBD=$$FMADD^XLFDT(BGPPER,-364),BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
BY ;get baseline year
 ;S BGPVDT=3000000
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 ;S BGPBEN=1
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 S BGPINDB="G"
 D REPORT^BGP1UTL
 I $G(BGPQUIT) S BGPRET=0_"^COULD NOT CREATE REPORT ENTRY" Q
 I BGPRPT="" S BGPRET=0_"^COULD NOT CREATE REPORT ENTRY" Q
 S BGPDELT=""
 ;create entry in GUI file
 D ^XBFMK
 S X=BGPFILE
 ;S X=BGPUSER_$$NOW^XLFDT
 S BGPGFNM=X
 S DIC="^BGPGUIB(",DIC(0)="L",DIADD=1,DLAYGO=90546.08,DIC("DR")=".02////"_BGPUSER_";.03////"_$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT)_";.05///"_BGPOPTN_";.06///R;.07///"_$G(BGPROT)
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
 S ZTCPU=$G(IOCPU),ZTRTN="NTLGP^BGP1GNPL",ZTDTH=$S(BGPRTIME]"":BGPRTIME,1:$$NOW^XLFDT),ZTDESC="GUI NATIONAL GPRA REPORT LISTS 09" D ^%ZTLOAD Q
 Q
NTLGP ;
 D ^BGP1D1
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
