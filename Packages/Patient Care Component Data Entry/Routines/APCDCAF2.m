APCDCAF2 ; IHS/CMI/LAB - MENTAL HLTH ROUTINE 16-AUG-1994 ;
 ;;2.0;IHS PCC SUITE;**2,7,8,11**;MAY 14, 2009;Build 58
 ;; ;
 ;
EN ; EP -- main entry point for CHART AUDIT LISTMANAGER DISPLAY
 S VALMCC=1
 NEW VALMCNT
 D TERM^VALM0
 D CLEAR^VALM1
 D EN^VALM("APCDCAF OP MAIN VIEW")
 D CLEAR^VALM1
 K ^TMP($J),^TMP("APCDCAF OP",$J)
 Q
 ;
HDR ;EP -- header code
 S X=" #",$E(X,6)="VISIT DATE",$E(X,21)="PATIENT NAME",$E(X,38)="HRN",$E(X,44)="FAC",$E(X,49)="HOSP LOC",$E(X,59)="S",$E(X,61)="CL",$E(X,64)="PRIM PROV",$E(X,75)="STATUS ERROR"
 S VALMHDR(2)=X
 S VALMHDR(1)="* an asterisk beside the visit number indicates the visit has an error"
 Q
 ;
INIT ;EP -- init variables and list array
 S VALMSG="Q - Quit/?? for more actions/+ next/- previous"
 D GATHER ;GATHER UP ALL VISITS FOR DISPLAY
 D RECDISP ;sort list by desired sort variable and set up listman display
 S VALMCNT=APCDRCNT
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K APCDRCNT,^TMP($J,"APCDCAF OP"),^TMP($J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GATHER ;
 K ^TMP($J),^TMP("APCDCAF OP",$J)
 S APCDODAT=9999999-APCDCAFD,APCDSTOP=9999999-APCDCAFD
 S (APCDRCNT,APCDVIEN)=0 F  S APCDODAT=$O(^AUPNVSIT("AA",APCDDFN,APCDODAT)) Q:APCDODAT=""!($P(APCDODAT,".")>APCDSTOP)  D
 .S APCDVIEN=0 F  S APCDVIEN=$O(^AUPNVSIT("AA",APCDDFN,APCDODAT,APCDVIEN)) Q:APCDVIEN'=+APCDVIEN  D
 ..S APCDV0=$G(^AUPNVSIT(APCDVIEN,0))
 ..Q:APCDV0=""
 ..Q:$P(APCDV0,U,11)        ;DELETED
 ..Q:$P(APCDV0,U,3)="C"     ;CONTRACT
 ..S APCDVLOC=$P(APCDV0,U,6)
 ..Q:APCDVLOC=""  ;no location of encounter
 ..S ^TMP($J,"APCDCAF OP",APCDVIEN,APCDVIEN)=""
 ..Q
 .Q
 Q
RECDISP ;
 S APCDSV="" F  S APCDSV=$O(^TMP($J,"APCDCAF OP",APCDSV)) Q:APCDSV=""  D
 .S APCDV=0 F  S APCDV=$O(^TMP($J,"APCDCAF OP",APCDSV,APCDV)) Q:APCDV'=+APCDV  D
 ..S APCDRCNT=APCDRCNT+1
 ..S APCDX="",DFN=$P(^AUPNVSIT(APCDV,0),U,5) D REC
 ..S ^TMP("APCDCAF OP",$J,APCDRCNT,0)=APCDX
 ..S ^TMP("APCDCAF OP",$J,"IDX",APCDRCNT,APCDRCNT)=APCDV
 K APCDV,APCDX,APCDSV
 Q
 ;
DATE(D) ;
 NEW X,Y
 S X=$P(D,".")
 S X=$E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 S Y=$$FMTE^XLFDT(D,"2S"),Y=$P(Y,"@",2),Y=$P(Y,":",1,2)
 Q X_"@"_Y
 ;
REC ;
 S APCDERR=$$ERRORCHK^APCDCAF(APCDV)
 S APCDX=""
 S APCDX=APCDRCNT_")"_$S(APCDERR]"":"*",1:"")
 S $E(APCDX,6)=$$DATE($P(^AUPNVSIT(APCDV,0),U))
 S $E(APCDX,21)=$E($P(^DPT(DFN,0),U),1,15)
 S $E(APCDX,37)=$$LBLK($$HRN^AUPNPAT(DFN,DUZ(2)),6)
 S L=$P(^AUPNVSIT(APCDV,0),U,6)
 S L=$P($G(^AUTTLOC(L,0)),U,7)
 S $E(APCDX,44)=L
 S $E(APCDX,49)=$E($$VAL^XBDIQ1(9000010,APCDV,.22),1,9)
 S $E(APCDX,59)=$P(^AUPNVSIT(APCDV,0),U,7)
 S $E(APCDX,61)=$$CLINIC^APCLV(APCDV,"C")
 S $E(APCDX,64)=$E($$PRIMPROV^APCLV(APCDV,"N"),1,10)
 S L=$P($G(^AUPNVSIT(APCDV,11)),U,11)
 S $E(APCDX,75)=L
 S $E(APCDX,77)=APCDERR
 Q
 ;
RBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
 ;
LASTCDR(V,F) ;EP - get last chart deficiency reason
 I $G(F)="" S F="I"  ;default to ien
 I '$D(^AUPNVCA("AD",V)) Q ""
 NEW X,A,D,L
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCA(X,0))
 .S D=$P(^AUPNVCA(X,0),U)
 .S A((9999999-$P(D,".")))=X
 S L=$O(A(0)) I L="" Q ""
 S X=A(L)
 Q $S(F="I":$P(^AUPNVCA(X,0),U,6),1:$$VAL^XBDIQ1(9000010.45,X,.06))
 ;
BACK ;EP - go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
NOTEDISP ;
 K DIR
 I $T(BROWS1^TIURA2)="" W !!,"TIU not installed" D EOP G NOTEX
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Display Note for which Visit"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP G NOTEX
 I $D(DIRUT) W !,"No VISIT selected." D EOP G NOTEX
 S APCDVSIT=^TMP("APCDCAF OP",$J,"IDX",Y,Y)
 D FULL^VALM1
 I '$D(^AUPNVNOT("AD",APCDVSIT)) W !!,"That visit does not have any notes to view" D EOP G NOTEX
 S (C,X)=0 F  S X=$O(^AUPNVNOT("AD",APCDVSIT,X)) Q:X'=+X  S C=C+1
 I C=1 S APCDVNOT=$O(^AUPNVNOT("AD",APCDVSIT,0)) D NOTE1 G NOTEX
 ;
MNOTE ;
 W !!,"There are more than one note associated with this visit.",!,"Please choose which note to display.",!
 K APCDN
 S (X,C)=0 F  S X=$O(^AUPNVNOT("AD",APCDVSIT,X)) Q:X'=+X  S C=C+1 D
 .W !?3,C,")  ",$$VAL^XBDIQ1(9000010.28,X,.01),?40,$$VAL^XBDIQ1(9000010.28,X,1202)
 .S APCDN(C)=X
 .Q
 K DIR
 S DIR(0)="NO^1:"_C,DIR("A")="Display which Note"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" G NOTEX
 I $D(DIRUT) G NOTEX
 S APCDVNOT=APCDN(Y)
NOTE1 ;
 S APCDTIU=$P(^AUPNVNOT(APCDVNOT,0),U)
 D BROWS1^TIURA2("TIU BROWSE FOR READ ONLY",APCDTIU)
 ;
NOTEX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDVNOT,X,APCDTIU
 D KILL^AUPNPAT
 D BACK
 Q
 ;
CASHX ;EP
 D FULL^VALM1
 K DIR
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Display Chart Audit History for which Visit"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP G CASHXX
 I $D(DIRUT) W !,"No VISIT selected." D EOP G CASHXX
 S APCDVSIT=^TMP("APCDCAF OP",$J,"IDX",Y,Y)
 D VIEWR^XBLM("DCAH^APCDCAF")
 D EOP
 ;
CASHXX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT
 D BACK
 Q
CDE ;EP
 K DIR
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Which Visit"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP^APCDCAF G CDEX
 I $D(DIRUT) W !,"No VISIT selected." D EOP^APCDCAF G CDEX
 S APCDVSIT=^TMP("APCDCAF OP",$J,"IDX",Y,Y)
 K VALMBCK
 S APCDCAFV=APCDVSIT,APCDPAT=$P(^AUPNVSIT(APCDVSIT,0),U,5) D EN^APCDCAF6(APCDVSIT)
 ;
CDEX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV
 ;
 D BACK
 Q
 ;
HS ;
 D FULL^VALM1
 I $G(APCDDFN) S (DFN,APCHSPAT,APCDPAT,Y)=APCDDFN G HS1
 K DIR
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Select Visit for Patient's Health summary"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP G HSX
 I $D(DIRUT) W !,"No VISIT selected." D EOP G HSX
 S APCDVSIT=^TMP("APCDCAF OP",$J,"IDX",Y,Y)
 S (Y,APCDPAT,DFN,APCHSPAT)=$P(^AUPNVSIT(APCDVSIT,0),U,5)
HS1 ;
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3) I X,$D(^APCHSCTL(X,0)) S X=$P(^APCHSCTL(X,0),U)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 K DIC,DR,DD S DIC("B")=X,DIC="^APCHSCTL(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DD,D0,D1,DQ
 I Y=-1 D EOP G HSX
 S APCHSTYP=+Y,APCHSPAT=DFN
 S APCDHDR="PCC Health Summary for "_$P(^DPT(APCHSPAT,0),U)
 D VIEWR^XBLM("EN^APCHS",APCDHDR)
HSX ;
 K APCDVSIT,APCDPAT,X,Y,AUPNVSIT,AUPNDAYS,DFN,APCDHDR,APCDPLPT
 D EN^XBVK("APCH")
 D KILL^AUPNPAT
 D BACK
 Q
 ;
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 ;Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="Press Enter to Continue",DIR(0)="E" D ^DIR
 Q
 ;----------
ADDVISIT ;
 S APCDCAF("IN CAF W/PATIENT")=APCDDFN
 D EN^XBNEW("^APCDEA","APCDCAF")
 K APCDCAF
 D BACK
 Q
BH ;EP
 K DIR
 ;I $T(BROWS1^TIURA2)="" W !!,"TIU not installed" D EOP G NOTEX
 I '$D(^XUSEC("AMHZ CODING REVIEW",DUZ)) W !!,"You do not have the security access to see Behavioral Health Notes.",!,"Please see your supervisor for access.  The security key needed is AMHZ CODING REVIEW.",! D PAUSE^APCDALV1,BHX Q
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Display Behavioral Health Note for which Visit"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP G BHX
 I $D(DIRUT) W !,"No VISIT selected." D EOP G BHX
 S APCDVSIT=^TMP("APCDCAF",$J,"IDX",Y,Y)
 D FULL^VALM1
 I '$D(^AMHREC("AVISIT",APCDVSIT)) D  G BHX
 .W !!,"There is no visit in the Behavioral Health module that is associated"
 .W !,"with this visit.  Use the N - Note Display action to display notes for "
 .W !,"non-BH visits."
 .D EOP
 S APCDVBH=$O(^AMHREC("AVISIT",APCDVSIT,0))
 I '$D(^AUPNVNOT("AD",APCDVSIT)) G BHSOAP
 S (C,X)=0 F  S X=$O(^AUPNVNOT("AD",APCDVSIT,X)) Q:X'=+X  S C=C+1
 I C=1 S APCDVNOT=$O(^AUPNVNOT("AD",APCDVSIT,0)) D BH1 G BHSOAP
 ;
BHM ;
 W !!,"There are more than one note associated with this visit.",!,"Please choose which note to display.",!
 K APCDN
 S (X,C)=0 F  S X=$O(^AUPNVNOT("AD",APCDVSIT,X)) Q:X'=+X  S C=C+1 D
 .W !?3,C,")  ",$$VAL^XBDIQ1(9000010.28,X,.01),?40,$$VAL^XBDIQ1(9000010.28,X,1202)
 .S APCDN(C)=X
 .Q
 K DIR
 S DIR(0)="NO^1:"_C,DIR("A")="Display which Note"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" G BHSOAP
 I $D(DIRUT) G BHSOAP
 S APCDVNOT=APCDN(Y)
BH1 ;
 S APCDTIU=$P(^AUPNVNOT(APCDVNOT,0),U)
 D BROWS1^TIURA2("TIU BROWSE FOR READ ONLY",APCDTIU)
 ;
BHSOAP ;look for SOAP note and display if it exists
 I $O(^AMHREC(APCDVBH,31,0)) D
 .W !!,"The SOAP note from the Behavioral Health module will now be displayed."
 .W !! S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) Q
 .I 'Y Q
 .D ARRAY^XBLM("^AMHREC("_APCDVBH_",31,","Behavior Health SOAP Note for visit: "_$$VAL^XBDIQ1(9002011,APCDVBH,.01))
 .Q
BHX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDVNOT,X,APCDTIU
 D KILL^AUPNPAT
 D BACK
 Q
VAV ;EP - view any visit when in OP
 ;
 Q
CP ;EP - change patient if in one patient
 ;
 D FULL^VALM1
 I '$D(APCDPEHR) W !!,"This item is only allowed to be used when you are in the PEHR option." D PAUSE^APCDALV1,BACK^APCDCAF Q
 ;change patient
 W !
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y<0 D BACK^APCDCAF Q
 I $D(APCDPARM),$P(APCDPARM,U,3)="Y" W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S (DFN,APCDPATF)=+Y
PROC1 ; call listmanager
 S APCDCAFP=DFN,APCDBD=$P(^APCCCTRL(DUZ(2),0),U,12),APCDED=DT,APCDPEHR=1
 D BACK^APCDCAF
 Q
DISP ;EP
 D FULL^VALM1
 D EN^XBNEW("DISP1^APCDCAF2","VALM*;APCDCAFP;APCDPEHR;DFN")
 ;
 ;
DISPX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV
 D KILL^AUPNPAT
 D BACK
 Q
DISP1 ;
 S APCDPAT=DFN
 D GETVISIT^APCDDISP
 I '$G(APCDVSIT) W !!,"No visit selected." D PAUSE^APCDALV1 Q
 D DSPLY^APCDDISP
 D PAUSE^APCDALV1
 Q
