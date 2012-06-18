BRNU ; IHS/OIT/LJF - UTILITY & FUNCTION CALLS
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/19/2007 PATCH 1 Added this routine
 ;
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,Y,DIRUT
 S DIR(0)=TYPE
 I $E(TYPE,1)="P",$P(TYPE,":",2)["L" S DLAYGO=+$P(TYPE,U,2)
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
PAUSE ;EP; -- ask user to press return - no form feed
 NEW DIR Q:IOST'["C-"
 S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR
 Q
 ;
ZIS(X,BRNRTN,BRNDESC,BRNVAR,BRNDEV) ;EP; -- called to select device and send print
 K %ZIS,IOP,ZTIO
 I X="F" D     ;forced queuing; no user interaction
 . S ZTIO=BRNDEV,ZTDTH=$H
 E  D   Q:POP  I '$D(IO("Q")) D @BRNRTN Q
 . S %ZIS=X I $G(BRNDEV)]"" S %ZIS("B")=BRNDEV
 . D ^%ZIS
 ;
 K IO("Q") S ZTRTN=BRNRTN,ZTDESC=BRNDESC
 F I=1:1 S J=$P(BRNVAR,";",I) Q:J=""  S ZTSAVE(J)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 Q
 ;
NAMEPRT(DFN,CONVERT) ;EP; return printable name
 ;CONVERT=1 means convert to mixed case letters
 NEW VADM,X
 D DEM^VADPT
 S X=$P($P(VADM(1),",",2)," ")_" "_$P(VADM(1),",")
 I $G(CONVERT) X ^DD("FUNC",14,1)
 Q X
 ;
XTMP(N,J,D) ;EP - set xtmp 0 node
 Q:$G(N)=""  Q:'$G(J)
 S ^XTMP(N,J,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
 ;
SUSPEND(IEN) ;EP; called by computed SUSPENDED DISCLOSURE field
 NEW START,STOP
 S START=$P($G(^BRNREC(IEN,24)),U,3) I START="" Q ""
 S STOP=$P($G(^BRNREC(IEN,24)),U,4)
 I (START'>DT)&((STOP="")!(STOP>DT)) Q "YES"
 Q ""
 ;
 ;SUBROUTINES BASED ON NEW FACILITY FIELD
ACTIVFAC(BRN,DA) ;EP - returns 1 if facility parameter entry is active
 ; Called by screen on field FACILITY in ROI LISTING RECORD file
 I '$D(^BRNPARM(BRN,0)) Q 0                                     ;not in file
 I $P($G(^BRNPARM(BRN,0)),U,6)="" Q 1                           ;no inactivation date
 I '$G(DA),$G(BRNBD) I $P(^BRNPARM(BRN,0),U,6)>(BRNBD-1) Q 1    ;if running RRU
 I $P(^BRNPARM(BRN,0),U,6)>$P($G(^BRNREC(+$G(DA),0)),U) Q 1     ;inactivation date after request date
 Q 0
 ;
USERFAC ;EP - checks if user's DUZ(2) matches an active facility
 ;     in the ROI LISTING PARAMETER file
 I '$G(DUZ(2)) W !,"NO DIVISION SET - CANNOT USE ROI" D PAUSE^BRNU S XQUIT=1 Q
 I '$D(^BRNPARM("B",DUZ(2))) D  Q
 . W !!,"Your DIVISION is NOT set to a facility defined in the ROI PARAMETERS"
 . W !,"Therefore, you CANNOT perform any DATA ENTRY FUNCTIONS until either your"
 . W !,"DIVISION is RESET OR the facility is ADDED to the ROI PARAMETERS file."
 . D PAUSE^BRNU
 . S XQUIT=1
 ;
 NEW X,IDATE
 S X=$O(^BRNPARM("B",DUZ(2),0)),IDATE=$P($G(^BRNPARM(+X,0)),U,6)
 I IDATE="" Q
 I IDATE>DT Q
 W !!,$$REPEAT^XLFSTR("* ",30)
 W !,"Your DIVISION is set to a facilitiy that has been INACTIVATED in the"
 W !,"in the ROI PARAMETER file.  You will ONLY be able to ADD requests"
 W !,"with a request date BEFORE ",$$FMTE^XLFDT(IDATE),"."
 W !,$$REPEAT^XLFSTR("* ",30),!
 D PAUSE^BRNU
 Q
 ;
FACOK(DATE) ;EP - returns 1 if DATE is before INACTIVATION DATE for
 ; faciliy set to user's DUZ(2)
 I '$D(^BRNPARM("B",DUZ(2))) Q 0
 NEW X,IDATE
 S X=$O(^BRNPARM("B",DUZ(2),0)),IDATE=$P($G(^BRNPARM(+X,0)),U,6)
 I IDATE="" Q 1
 I IDATE>DATE Q 1
 Q 0
 ;
ASKFAC(BRNFAC) ;EP; returns BRNFAC variable set to facility choice
 ; called using D ASKFAC^BRNU(.BRNFAC)
 ; If only one facility in parameter file, BRNFAC=0
 ; If user selected ALL facilities, BRNFAC=0
 ; Else, BRNFAC=IEN of facility parameter entry chosen
 ; OR if user ^ out or didn't choose, then BRNFAC=""
 ;
 I '$O(^BRNPARM(+$O(^BRNPARM(0)))) S BRNFAC=0 Q
 NEW Y S Y=$$READ^BRNU("Y","Print for ALL Facilities","YES")
 I Y=U S BRNFAC="" Q         ;^ out
 I Y=1 S BRNFAC=0 Q          ;Yes to ALL facilities
 S BRNFAC=+$$READ^BRNU("P^90264.2:AEMQZ","Select Facility")
 I BRNFAC<1 S BRNFAC=""
 Q
