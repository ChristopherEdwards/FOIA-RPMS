APCDCAF ; IHS/CMI/LAB - MENTAL HLTH ROUTINE 16-AUG-1994 ;
 ;;2.0;IHS PCC SUITE;**2,7,8,11,15**;MAY 14, 2009;Build 11
 ;
 ;
EN ; EP -- main entry point
 S VALMCC=1
 NEW VALCNT
 D TERM^VALM0
 D CLEAR^VALM1
 D EN^VALM("APCDCAF MAIN VIEW")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)="Visit Dates:  "_$$FMTE^XLFDT(APCDBD)_" to "_$$FMTE^XLFDT(APCDED)
 S X=" #",$E(X,6)="VISIT DATE",$E(X,21)="PATIENT NAME",$E(X,35)="HRN",$E(X,42)="FAC",$E(X,47)="HOSP LOC",$E(X,56)="S",$E(X,58)="CL",$E(X,61)="INS",$E(X,66)="PRIM PROV",$E(X,76)="STATUS ERROR"
 S VALMHDR(3)=X
 S VALMHDR(2)="* an asterisk beside the visit number indicates the visit has an error"
 Q
 ;
INIT ;EP -- init variables/list array
 S VALMSG="Q - Quit/?? for more actions/+ next/- previous"
 D GATHER  ;GATHER UP ALL VISITS FOR DISPLAY
 D RECDISP
 S VALMCNT=APCDRCNT
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K APCDRCNT,^TMP($J),^TMP("APCDCAF",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SCW(C) ;EP
 I C="" Q 0
 I C="E" Q 0
 I C="D" Q 0  ;NOT USED BY IHS
 I C="X" Q 0  ;NOT USED BY IHS
 I $D(^APCDSITE(DUZ(2),13,"B",C)) Q 0
 Q 1
 ;
GATHER ;
 K ^TMP("APCDCAF",$J),^TMP($J)
 I $G(APCDCAFP) D GATHERP Q
 S APCDODAT=$P(APCDBD,".")-1,APCDODAT=APCDODAT_".9999"
 S (APCDRCNT,APCDVIEN)=0 F  S APCDODAT=$O(^AUPNVSIT("B",APCDODAT)) Q:APCDODAT=""!($P(APCDODAT,".")>$P(APCDED,"."))  D
 .S APCDVIEN=0 F  S APCDVIEN=$O(^AUPNVSIT("B",APCDODAT,APCDVIEN)) Q:APCDVIEN'=+APCDVIEN  D
 ..S APCDV0=$G(^AUPNVSIT(APCDVIEN,0))
 ..Q:APCDV0=""
 ..Q:$P(APCDV0,U,5)=""
 ..Q:'$D(^AUPNPAT($P(APCDV0,U,5),0))  ;no patient
 ..Q:'$D(^DPT($P(APCDV0,U,5),0))  ;no patient
 ..Q:$$DEMO^APCLUTL($P(APCDV0,U,5),APCDDEMO)
 ..Q:$P(APCDV0,U,7)=""
 ..Q:'$$SCW($P(APCDV0,U,7))
 ..Q:'$P(APCDV0,U,9)        ;NO DEP ENTRIES
 ..Q:$P(APCDV0,U,11)        ;DELETED
 ..Q:$P(APCDV0,U,3)="C"     ;CONTRACT
 ..I $P(^APCDSITE(DUZ(2),0),U,28)=0,APCDPRVT'="X" Q:'$D(^AUPNVPRV("AD",APCDVIEN))  ;no provider
 ..S APCDVPP=$$PRIMPROV^APCLV(APCDVIEN,"I")
 ..;Q:'APCDVPP  ;no primary provider
 ..S APCDVLOC=$P(APCDV0,U,6)
 ..Q:APCDVLOC=""  ;no location of encounter
 ..I $D(APCDLOCS),'$D(APCDLOCS(APCDVLOC)) Q  ;not a location we want
 ..S APCDVCLN=$P(APCDV0,U,8)
 ..I APCDCLNT="X",APCDVCLN]"" Q
 ..I APCDVCLN="",$D(APCDCLNS) Q
 ..I $D(APCDCLNS),'$D(APCDCLNS(APCDVCLN)) Q  ;not a CLINIC we want
 ..S APCDVHL=$P(APCDV0,U,22)
 ..I APCDVHL="",$D(APCDHLS) Q
 ..I $D(APCDHLS),'$D(APCDHLS(APCDVHL)) Q  ;not a HOSP LOC we want
 ..I APCDVPP="",$D(APCDPRVS) Q
 ..I APCDPRVT="X",APCDVPP Q
 ..I $D(APCDPRVS),'$D(APCDPRVS(APCDVPP)) Q  ;not a PRIM PROV we want
 ..S APCDVCAS=$P($G(^AUPNVSIT(APCDVIEN,11)),U,11)
 ..I APCDVCAS="R" Q  ;DON'T DISPLAY REVIEWED VISITS
 ..K APCDVCDR D GETVCDR^APCDCAFS(APCDVIEN,"APCDVCDR")  ;GET ALL PENDING REASONS
 ..I '$D(APCDVCDR),$D(APCDCDRS) Q  ;
 ..S G=0 I $D(APCDCDRS) D
 ...S X=0 F  S X=$O(APCDVCDR(X)) Q:X'=+X  I $D(APCDCDRS(X)) S G=1
 ..I $D(APCDCDRS),'G Q
 ..S ^TMP($J,"APCDCAF",$$SORT(APCDVIEN,APCDSORT),APCDVIEN)=""
 ..Q
 .Q
 Q
 ;
GATHERP ; gather up visits for one patient
 S APCDODAT=9999999-APCDED,APCDSTOP=9999999-APCDBD
 S (APCDRCNT,APCDVIEN)=0 F  S APCDODAT=$O(^AUPNVSIT("AA",APCDCAFP,APCDODAT)) Q:APCDODAT=""!($P(APCDODAT,".")>APCDSTOP)  D
 .S APCDVIEN=0 F  S APCDVIEN=$O(^AUPNVSIT("AA",APCDCAFP,APCDODAT,APCDVIEN)) Q:APCDVIEN'=+APCDVIEN  D
 ..S APCDV0=$G(^AUPNVSIT(APCDVIEN,0))
 ..Q:APCDV0=""
 ..Q:'$$SCW($P(APCDV0,U,7))
 ..Q:'$P(APCDV0,U,9)        ;NO DEP ENTRIES
 ..Q:$P(APCDV0,U,11)        ;DELETED
 ..Q:$P(APCDV0,U,3)="C"     ;CONTRACT
 ..;Q:'$D(^AUPNVPOV("AD",APCDVIEN))  ;no pov
 ..;Q:'$D(^AUPNVPRV("AD",APCDVIEN))  ;no provider
 ..S APCDVPP=$$PRIMPROV^APCLV(APCDVIEN,"I")
 ..;Q:'APCDVPP  ;no primary provider
 ..S APCDVLOC=$P(APCDV0,U,6)
 ..Q:APCDVLOC=""  ;no location of encounter
 ..S APCDVCAS=$P($G(^AUPNVSIT(APCDVIEN,11)),U,11)
 ..I APCDVCAS="R" Q  ;DON'T DISPLAY REVIEWED VISITS
 ..S ^TMP($J,"APCDCAF",$$SORT(APCDVIEN,APCDSORT),APCDVIEN)=""
 ..Q
 .Q
 Q
RECDISP ;
 S APCDSV="" F  S APCDSV=$O(^TMP($J,"APCDCAF",APCDSV)) Q:APCDSV=""  D
 .S APCDV=0 F  S APCDV=$O(^TMP($J,"APCDCAF",APCDSV,APCDV)) Q:APCDV'=+APCDV  D
 ..S APCDRCNT=APCDRCNT+1
 ..S APCDX="",DFN=$P(^AUPNVSIT(APCDV,0),U,5) D REC
 ..S ^TMP("APCDCAF",$J,APCDRCNT,0)=APCDX
 ..S ^TMP("APCDCAF",$J,"IDX",APCDRCNT,APCDRCNT)=APCDV
 K APCDV,APCDX,APCDSV
 Q
 ;
ONEDATE ;
 W !!,"This item is used to display all visits for a patient on the",!,"same date as the visit you select from the list."
 K DIR
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Which Visit"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP G ONEDATEX
 I $D(DIRUT) W !,"No VISIT selected." D EOP G ONEDATEX
 S APCDVSIT=^TMP("APCDCAF",$J,"IDX",Y,Y)
 ;RELINKER?
 D EP^APCDKDE
 S APCDCAFD=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 S APCDCAFO=1
 S APCDDFN=$P(^AUPNVSIT(APCDVSIT,0),U,5)
 D EN^APCDCAF2
 ;
ONEDATEX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT,APCDCAF,APCDCAFV,APCDCAFD,APCDCAFO,APCDDFN
 D KILL^AUPNPAT
 D BACK
 Q
DATE(D) ;
 NEW X,Y
 S X=$P(D,".")
 S X=$E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 S Y=$$FMTE^XLFDT(D,"2S"),Y=$P(Y,"@",2),Y=$P(Y,":",1,2)
 Q X_"@"_Y
 ;
REC ;
 S APCDERR=$$ERRORCHK(APCDV)
 S APCDX=""
 S APCDX=APCDRCNT_")"_$S(APCDERR]"":"*",1:"")
 S $E(APCDX,6)=$$DATE($P(^AUPNVSIT(APCDV,0),U))
 S $E(APCDX,21)=$E($P(^DPT(DFN,0),U),1,13)
 S $E(APCDX,35)=$$LBLK($$HRN^AUPNPAT(DFN,DUZ(2)),6)
 S L=$P(^AUPNVSIT(APCDV,0),U,6)
 S L=$P($G(^AUTTLOC(L,0)),U,7)
 S $E(APCDX,42)=L
 S $E(APCDX,47)=$E($$VAL^XBDIQ1(9000010,APCDV,.22),1,8)
 S $E(APCDX,56)=$P(^AUPNVSIT(APCDV,0),U,7)
 S $E(APCDX,58)=$$CLINIC^APCLV(APCDV,"C")
 S $E(APCDX,61)=$$MCP(APCDV)
 S $E(APCDX,66)=$E($$PRIMPROV^APCLV(APCDV,"N"),1,9)
 S L=$P($G(^AUPNVSIT(APCDV,11)),U,11)
 S $E(APCDX,76)=L
 S $E(APCDX,78)=APCDERR
 Q
 ;
ERRORCHK(V) ;EP
 NEW E,X,C
 S E=""
 I $P(^AUPNVSIT(V,0),U,7)="E" Q ""
 I $P(^AUPNVSIT(V,0),U,7)'="I",'$D(^AUPNVPOV("AD",V)) S E="NO POV"
 S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 .I $$VAL^XBDIQ1(9000010.07,X,.01)=".9999" S:E]"" E=E_"," S E=".9999 POV" Q
 .I $$VAL^XBDIQ1(9000010.07,X,.01)="ZZZ.999" S:E]"" E=E_"," S E="ZZZ.999 POV"
 S X=0,C=0 F  S X=$O(^AUPNVPRV("AD",V,X)) Q:X'=+X  D
 .I $P(^AUPNVPRV(X,0),U,4)="P" S C=C+1
 I C>1 S:E]"" E=E_"," S E=E_"MULT PRIM PROV"
 I $$FINDPEND^APCDCAF6(V) S:E]"" E=E_"," S E=E_"CHART DEFICIENCIES"
 Q E
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
 I '$D(^AUPNVCA(V)) Q ""
 NEW X,A,D,L
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCA(X,0))
 .S D=$P(^AUPNVCA(X,0),U)
 .S A((9999999-$P(D,".")))=X
 S L=$O(A(0)) I L="" Q ""
 S X=A(L)
 Q $S(F="I":$P(^AUPNVCA(X,0),U,5),1:$$VAL^XBDIQ1(9000010.45,X,.05))
 ;
MCP(V) ;
 NEW R S R=""
 I V="" Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 NEW D
 S D=$P(^AUPNVSIT(V,0),U,5)
 I D="" Q ""
 I $$MCR^AUPNPAT(D,$P($P(^AUPNVSIT(V,0),U),".")) S R="M"
 I $$MCD^AUPNPAT(D,$P($P(^AUPNVSIT(V,0),U),".")) S:R]"" R=R_"/" S R=R_"C"
 I $$PI^AUPNPAT(D,$P($P(^AUPNVSIT(V,0),U),".")) S:R]"" R=R_"/" S R=R_"P"
 Q R
SORT(V,S) ;
 NEW R
 S R=""
 D @(S_"SORT")
 I R="" S R="ZZZZZZZZ"
 Q R
 ;
DSORT ;
 I 'V Q
 I '$D(^AUPNVSIT(V,0)) Q
 S R=$P(^AUPNVSIT(V,0),U)
 Q
 ;
SSORT ;
 I 'V Q
 I '$D(^AUPNVSIT(V,0)) Q
 S R=$$VAL^XBDIQ1(9000010,V,.07)
 Q
 ;
LSORT ;
 I 'V Q
 I '$D(^AUPNVSIT(V,0)) Q
 S R=$$VAL^XBDIQ1(9000010,V,.06)
 Q
 ;
CSORT ;
 I 'V Q
 I '$D(^AUPNVSIT(V,0)) Q
 S R=$$VAL^XBDIQ1(9000010,V,.08)
 Q
 ;
OSORT ;
 I 'V Q
 I '$D(^AUPNVSIT(V,0)) Q
 S R=$$VAL^XBDIQ1(9000010,V,.22)
 Q
 ;
PSORT ;
 S R=$$PRIMPROV^APCLV(V,"N")
 Q
 ;
ASORT ;
 I 'V Q
 I '$D(^AUPNVSIT(V,0)) Q
 S R=$$VAL^XBDIQ1(9000010,V,1111)
 I R="" S R="INCOMPLETE"
 Q
 ;
RSORT ;
 S R=$$LASTCDR(V,"E")
 Q
 ;
NSORT ;
 S R=$$VAL^XBDIQ1(9000010,V,.05)
 Q
 ;
HSORT ;
 S R=$$HRN^AUPNPAT($P(^AUPNVSIT(V,0),U,5),DUZ(2))
 Q
 ;
TSORT ;
 I V="" Q
 I '$D(^AUPNVSIT(V,0)) Q
 NEW D
 S D=$P(^AUPNVSIT(V,0),U,5)
 I D="" Q
 S R=$$HRN^AUPNPAT(D,DUZ(2))
 S R=R+10000000,R=$E(R,7,8)_$E(R,1,6)
 Q
 ;
ISORT ;
 I V="" Q
 I '$D(^AUPNVSIT(V,0)) Q
 NEW D
 S D=$P(^AUPNVSIT(V,0),U,5)
 I $$MCR^AUPNPAT(D,$P($P(^AUPNVSIT(V,0),U),".")) S R="M"
 I $$MCD^AUPNPAT(D,$P($P(^AUPNVSIT(V,0),U),".")) S:R]"" R=R_"/" S R=R_"C"
 I $$PI^AUPNPAT(D,$P($P(^AUPNVSIT(V,0),U),".")) S:R]"" R=R_"/" S R=R_"P"
 Q
BACK ;EP go back to listman
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
 S APCDVSIT=^TMP("APCDCAF",$J,"IDX",Y,Y)
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
 S APCDVSIT=^TMP("APCDCAF",$J,"IDX",Y,Y)
 D VIEWR^XBLM("DCAH^APCDCAF")
 ;
CASHXX ;
 K DIR,DIRUT,DUOUT,Y,APCDVSIT
 D BACK
 Q
DCAH ;
 ;
 W !!,"Chart Audit History for VISIT:"
 W !?1,"Visit Date:  ",$$VAL^XBDIQ1(9000010,APCDVSIT,.01),"   Patient Name:  ",$$VAL^XBDIQ1(9000010,APCDVSIT,.05)
 W !?1,"Hospital Location:  ",$$VAL^XBDIQ1(9000010,APCDVSIT,.22),"  Primary Provider: ",$$PRIMPROV^APCLV(APCDVSIT,"N")
 W !!,"DATE OF AUDIT",?24,"STATUS",?40,"USER WHO AUDITED" ;,?62,"CHART DEFICIENCY"
 S APCDX=0 F  S APCDX=$O(^AUPNVCA("AD",APCDVSIT,APCDX)) Q:APCDX'=+APCDX  D
 .W !,$$GET1^DIQ(9000010.45,APCDX,.01),?24,$$GET1^DIQ(9000010.45,APCDX,.04),?40,$$GET1^DIQ(9000010.45,APCDX,.05)
 W !!,"DEFICIENCY HISTORY"
 W !,"=================="
 S APCDX=0 F  S APCDX=$O(^AUPNVCA("AD",APCDVSIT,APCDX)) Q:APCDX'=+APCDX  D
 .Q:$P(^AUPNVCA(APCDX,0),U,6)=""
 .W !,$$GET1^DIQ(9000010.45,APCDX,.06),?31,$$DATE^APCDCAFA($P($P(^AUPNVSIT(APCDVSIT,0),U),".")),?42,$E($$GET1^DIQ(9000010.45,APCDX,.05),1,18)
 S DA=APCDVSIT,DIC="^AUPNCANT(" D EN^DIQ
 Q
RESORT ;
 D FULL^VALM1
 W !!,"Resorting Visit List",!
 S DIR(0)="S^N:Patient Name;H:HRN;D:Date of Visit;T:Terminal Digit of HRN;S:Service Category;L:Location of Encounter;C:Clinic;O:Hospital Location;P:Primary Provider"
 S DIR(0)=DIR(0)_";A:Chart Audit Status;I:Has Medicare/Medicaid or PI"
 S DIR("A")="How would you like the list of visits sorted",DIR("B")="D" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G RESORTX
 S APCDSORT=Y
 ;
RESORTX ;
 D BACK
 Q
 ;
HS ;
 D FULL^VALM1
 I $G(APCDCAFP) S (DFN,APCHSPAT,APCDPAT,Y)=APCDCAFP G HS1
 K DIR
 S DIR(0)="NO^1:"_APCDRCNT,DIR("A")="Select Visit for Patient's Health summary"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No VISIT selected." D EOP G HSX
 I $D(DIRUT) W !,"No VISIT selected." D EOP G HSX
 S APCDVSIT=^TMP("APCDCAF",$J,"IDX",Y,Y)
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
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="Press Enter to Continue",DIR(0)="E" D ^DIR
 Q
 ;----------
BH ;EP
 K DIR
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
