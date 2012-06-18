BMCLKID2 ; IHS/OIT/FCJ - IDENTIFIERS FOR REFERRAL LOOKUP 3 ;      [ 09/27/2006  2:03 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**2**;JAN 09, 2006
 ;4.0*2 IHS/OIT/FCJ Added Entry point for API rtn
 ;      and test variable to screen closed variables and sec ref
 ;This Routine Displays Lookup for BMCREF Global
 ;This routine is called from ^BMCRDSP and if selected by patient name
 ;then display of last entered referral is displayed first
 ;
 ;At Lookup - Displays Date Initiated
 ;            Referral Number
 ;            Facility or Provider Referred To
 ;            Purpose of Referral
 ;    If Facility Referred to or Purpose are Null Displays UNKNOWN
 ;
START ; ENTRY POINT - 
 ; IF DISPLAY SELECTED BY PATIENT AND LAST IN FIRST OUT DISPLAY OF REF
 W !
 S DIR(0)="FO^1:30"
 S DIR("A")="Select RCIS REFERRAL by Patient or by Referral Date or #"
 S DIR("?")="Enter the Patient name, Referral # or last 5 digits of referral # (and) secondary suffix."
 D ^DIR K DIR Q:$D(DIRUT)!$D(DTOUT)
 I Y=" " S Y=^DISV(DUZ,"^BMCREF(") G REFLKUP1
 W !,Y S X=Y
 I $E(Y,1)?1A D PATLKUP,XIT Q
REFLKUP ;
 S DIC="^BMCREF(",DIC(0)="QEM",X=Y
 D DIC^BMCFMC
 Q:Y<1
REFLKUP1 S BMCRIEN=+Y
 D XIT
 Q
PATLKUP ;EP FOR PATIENT LOOK UP CALLED BY BMCAPI  ;BMC*4.0*2 IHS/OIT/FCJ
 S DIC="^AUPNPAT(",DIC(0)="QEM",X=Y
 D DIC^BMCFMC
 Q:Y<1
 S BMCDFN=+Y,BMCREC("PAT NAME")=$P(^DPT(+Y,0),U)
REFDISP ;DISPLAY LATEST REFERRAL ENTERED-5 AT A TIME
 S BMCFLG=1,BMCQ=1
 I '$D(^BMCREF("AA",BMCDFN)) W !,"PATIENT DOES NOT HAVE ANY REFERRALS" Q
 S BMCDT="",BMCCT=0,BMCRIENT="",BMCQ=0
 F  S BMCDT=$O(^BMCREF("AA",BMCDFN,BMCDT),-1) Q:BMCDT'?1N.N  D  Q:BMCQ
 .S BMCRIEN=""
 .F  S BMCRIEN=$O(^BMCREF("AA",BMCDFN,BMCDT,BMCRIEN),-1) Q:BMCRIEN'?1N.N  D  Q:BMCQ
 .. I $G(BMCAPI) Q:$P(^BMCREF(BMCRIEN,0),U,15)'="A"
 .. I $G(BMCAPIS) Q:$P($G(^BMCREF(BMCRIEN,1)),U)'=""
 .. S BMCCT=BMCCT+1,^TMP("BMCRDSP",$J,BMCCT)=BMCRIEN
 .. D START^BMCLKID1
 ..I BMCCT#5=0 D CONT
 I BMCCT#5'=0 D CONT
 S:BMCRIENT BMCRIEN=BMCRIENT Q:BMCRIENT!$D(DUOUT)
 I 'BMCRIENT S BMCQ=1
 Q
CONT ;Ask to Continue
 S DIR("A")="Select referral to display OR Return to continue"
 S BMCQ=0
 W !! S DIR(0)="NO^1:"_BMCCT
 K DA D ^DIR K DIR
 I $D(DUOUT) S BMCQ=1 Q
 I Y>0 S BMCRIENT=$P(^TMP("BMCRDSP",$J,Y),U),BMCQ=1
 Q
 ;
XIT ;Kill off Variables no longer needed
 K BMCPAT,BMCPTDFN,BMCPURP,BMCPURPP,BMCRFAC,BMCSVDT,BMCSVDTP,BMCRDT,BMCRDTP,BMCRNUMB
 K BMCFLG,BMCCT,^TMP("BMCRDSP",$J)
 Q
 ;
