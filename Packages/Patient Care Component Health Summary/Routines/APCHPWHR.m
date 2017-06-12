APCHPWHR ; IHS/CMI/LAB - PCC HEALTH SUMMARY ; 
 ;;2.0;IHS PCC SUITE;**7,11**;MAY 14, 2009;Build 58
 ;
 W:$D(IOF) @IOF
 W !!,"This report will tally the number of Patient Wellness Handouts given to"
 W !,"patients.  The user will be able to tally based on handout type, location"
 W !,"date the handout was generated and user/provider who generated the handout."
 W !,"Optionally, the user can produce a list of patients receiving the handout."
 W !!
 S APCHJ=$J,APCHH=$H
GETDATES ;
BD ;get beginning date
 W ! K DIR S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date of Patient Wellness Handout" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EXIT Q
 S APCHBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCHBD_":DT:EP",DIR("A")="Enter ending date of Patient Wellness Handout:  " S Y=APCHBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCHED=Y
 S X1=APCHBD,X2=-1 D C^%DTC S APCHSD=X
 ;
TYPE ;
 K APCHTYPE
 W ! S DIR(0)="Y",DIR("A")="Do you wish to run the report for a particular patient handout",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GETDATES
 I 'Y G LOCT
TYPE1 ;
 W ! S DIC="^APCHPWHT(",DIC("A")="Enter Patient Wellness Type: ",DIC(0)="AEMQ" D ^DIC
 I Y=-1,'$D(APCHTYPE) W !,"No handout types selected." G TYPE
 I Y=-1,$D(APCHTYPE) G LOCT
 S APCHTYPE(+Y)=""
 G TYPE1
LOCT ;
 K APCHLOCT
 W ! S DIR(0)="Y",DIR("A")="Do you wish to run the report for a particular location",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G TYPE
 I Y=0 D  G PROVT
 .K APCHLOCT
LOCT1 ;
 W ! S DIC="^AUTTLOC(",DIC("A")="Enter Location: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1,'$D(APCHLOCT) W !,"No locations selected." G TYPE
 I Y=-1,$D(APCHLOCT) G PROVT
 S APCHLOCT(+Y)=""
 G LOCT1
PROVT ;
 ;
 K APCHPRVT
 W ! S DIR(0)="Y",DIR("A")="Do you wish to run the report for a particular provider/user",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LOCT
 I 'Y D  G LIST
 .K APCHPRVT
PROVT1 ;
 W ! S DIC="^VA(200,",DIC("A")="Enter Provider: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1,'$D(APCHPRVT) W !,"No providers selected." G LOCT
 I Y=-1,$D(APCHPRVT) G LIST
 S APCHPRVT(+Y)=""
 G PROVT1
 ;
LIST ;
 S APCHLIST=""
 W !! S DIR(0)="Y",DIR("A")="Do you want a list of patients",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S APCHLIST=Y
 I 'APCHLIST S APCHSORT="" G ZIS
SORT ;
 S APCHSORT=""
 S DIR(0)="S^N:Name of Patient;P:Provider/User;L:Location;T:Type of Handout;D:Date Handout Generated",DIR("A")="How do you want the list sorted"
 S DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S APCHSORT=Y
 ;
ZIS ;EP
 D DEMOCHK^APCLUTL(.APCHDEMO)
 I APCHDEMO=-1 G LIST
 W !! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^APCHPWHR",XBRC="EN^APCHPWHR",XBRX="EXIT^APCHPWHR",XBNS="APCH;DFN"
 D ^XBDBQUE
 D EXIT1
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCHPWHR"")"
 S XBRC="EN^APCHPWHR",XBRX="EXIT^APCHPWHR",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 ;K ^XTMP("APCHPWHR",APCHJ,APCHH)
 D EN^XBVK("APCH")
 K DFN
 D ^XBFMK
 Q
 ;
EXIT1 ;
 D CLEAR^VALM1
 D FULL^VALM1
 D EN^XBVK("APCH")
 K DFN
 D ^XBFMK
 Q
 ;
PRINT ;
 S APCHPG=0
 K APCHQUIT
 I APCHLIST I '$D(^XTMP("APCHPWHR",APCHJ,APCHH)) D HEADER W !!,"No data to report.",! Q
 I APCHPWHC=0 D HDR W !!,"No data to report.",! Q
 ;print tally then print list
 D HDR
 S APCHX=0 F  S APCHX=$O(APCHPWHT(APCHX)) Q:APCHX'=+APCHX  D
 .I $Y>(IOSL-3) D HDR Q:$D(APCHQUIT)
 .W APCHPWHT(APCHX,0),!
 .Q
 Q:$D(APCHQUIT)
 ;first reorder by sort item
 S APCHIEN=0 F  S APCHIEN=$O(^XTMP("APCHPWHR",APCHJ,APCHH,APCHIEN)) Q:APCHIEN'=+APCHIEN  D
 .D
 ..S V=""
 ..I APCHSORT="T" S V=$$VAL^XBDIQ1(9001027,APCHIEN,.02) Q
 ..I APCHSORT="D" S V=$$VALI^XBDIQ1(9001027,APCHIEN,.04) Q
 ..I APCHSORT="N" S V=$$VAL^XBDIQ1(9001027,APCHIEN,.01) Q
 ..I APCHSORT="L" S V=$$VAL^XBDIQ1(9001027,APCHIEN,.06) Q
 ..I APCHSORT="P" S V=$$VAL^XBDIQ1(9001027,APCHIEN,.03) Q
 .I V="" S V="UNKNOWN"
 .S ^XTMP("APCHPWHR",APCHJ,APCHH,"SORT",V,APCHIEN)=""
 I 'APCHLIST G N
 D HEADER
 S APCHSV="" F  S APCHSV=$O(^XTMP("APCHPWHR",APCHJ,APCHH,"SORT",APCHSV)) Q:APCHSV=""!($D(APCHQUIT))  D
 .S APCHIEN=0 F  S APCHIEN=$O(^XTMP("APCHPWHR",APCHJ,APCHH,"SORT",APCHSV,APCHIEN)) Q:APCHIEN=""!($D(APCHQUIT))  D
 ..I $Y>(IOSL-3) D HEADER I $D(APCHQUIT) Q
 ..W !,$$HRN^AUPNPAT($$VALI^XBDIQ1(9001027,APCHIEN,.01),DUZ(2)),?8,$E($$VAL^XBDIQ1(9001027,APCHIEN,.01),1,20)
 ..W ?30,$$DATE^APCHSMU($$VALI^XBDIQ1(9001027,APCHIEN,.04)),?39,$E($$VAL^XBDIQ1(9001027,APCHIEN,.02),1,20)
 ..W ?60,$E($$VAL^XBDIQ1(9001027,APCHIEN,.03),1,14),?75,$$VAL^XBDIQ1(9999999.06,+$$VALI^XBDIQ1(9001027,APCHIEN,.06),.08)
 ..Q
 .Q
N ;
 W !!
 Q
HEADER ;
 G:APCHPG=0 HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 S APCHPG=APCHPG+1
 W !,"********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********",!
 W !,"Patient Wellness Handout",?45,"Report Date: ",$$FMTE^XLFDT(DT),?72,"Page: ",APCHPG,!,$TR($J("",(IOM-2))," ","-"),!
 W !,"HRN",?8,"Patient Name",?30,"Date",?39,"Type",?60,"Provider",?75,"Loc"
 W !,$$REPEAT^XLFSTR("-",79),!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;---------- 
 ;
EN ;
 S APCHCNT=0,APCHPWHC=0
 K APCHT,APCHPWHT
 K ^XTMP("APCHPWHR",APCHJ,APCHH)
 S ^XTMP("APCHPWHR",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^APCH PWH REPORT"
 NEW X,Y,APCHN,L,P,T
 ;
 F  S APCHSD=$O(^APCHPWHL("AC",APCHSD)) Q:APCHSD'=+APCHSD!(APCHSD>APCHED)  D
 .S APCHIEN=0 F  S APCHIEN=$O(^APCHPWHL("AC",APCHSD,APCHIEN)) Q:APCHIEN'=+APCHIEN  D
 ..S APCHN=^APCHPWHL(APCHIEN,0)
 ..S P=$P(^APCHPWHL(APCHIEN,0),U,1)
 ..Q:$$DEMO^APCLUTL(P,APCHDEMO)
 ..Q:'$P(APCHN,U,2)
 ..I $D(APCHTYPE) Q:'$D(APCHTYPE($P(APCHN,U,2)))
 ..I $D(APCHLOCT) Q:'$P(APCHN,U,6)  Q:'$D(APCHLOCT($P(APCHN,U,6)))
 ..I $D(APCHPRVT) Q:'$P(APCHN,U,3)  Q:'$D(APCHPRVT($P(APCHN,U,3)))
 ..S APCHT($$VAL^XBDIQ1(9001027,APCHIEN,.06))=$G(APCHT($$VAL^XBDIQ1(9001027,APCHIEN,.06)))+1
 ..S APCHT($$VAL^XBDIQ1(9001027,APCHIEN,.06),$$VAL^XBDIQ1(9001027,APCHIEN,.02))=$G(APCHT($$VAL^XBDIQ1(9001027,APCHIEN,.06),$$VAL^XBDIQ1(9001027,APCHIEN,.02)))+1
 ..S APCHT($$VAL^XBDIQ1(9001027,APCHIEN,.06),$$VAL^XBDIQ1(9001027,APCHIEN,.02),$$VAL^XBDIQ1(9001027,APCHIEN,.03))=$G(APCHT($$VAL^XBDIQ1(9001027,APCHIEN,.06),$$VAL^XBDIQ1(9001027,APCHIEN,.02),$$VAL^XBDIQ1(9001027,APCHIEN,.03)))+1
 ..S ^XTMP("APCHPWHR",APCHJ,APCHH,APCHIEN)="",APCHPWHC=APCHPWHC+1
 ;S X="LOCATION",$E(X,55)="#" D S(X)
 S L="" F  S L=$O(APCHT(L)) Q:L=""  D
 .D S(" ")
 .S Y=L,$E(Y,55)=$J(APCHT(L),6) D S(Y)
 .S T="" F  S T=$O(APCHT(L,T)) Q:T=""  D
 ..D S(" ") S Y="",$E(Y,3)=T,$E(Y,55)=$J(APCHT(L,T),6) D S(Y)
 ..D S(" ") S P="" F  S P=$O(APCHT(L,T,P)) Q:P=""  D
 ...S Y="",$E(Y,6)=P,$E(Y,55)=$J(APCHT(L,T,P),6) D S(Y)
 Q
S(T) ;
 S APCHCNT=APCHCNT+1
 S APCHPWHT(APCHCNT,0)=T
 Q
HDR ;
 G:APCHPG=0 HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HDR1 ;
 W:$D(IOF) @IOF
 S APCHPG=APCHPG+1
 W !,"********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********",!
 W $$CTR("PATIENT WELLNESS HANDOUT TALLY",80),!
 W $$CTR("Date Range:  "_$$FMTE^XLFDT(APCHBD)_" - "_$$FMTE^XLFDT(APCHED)),!
 S X=0,Y="" F  S X=$O(APCHTYPE(X)) Q:X'=+X  S:Y]"" Y=Y_"; " S Y=Y_$P(^APCHPWHT(X,0),U)
 W "Handout Types Selected: "_$S('$D(APCHTYPE):"All",1:""),Y,!
 S Y="" S X=0 F  S X=$O(APCHLOCT(X)) Q:X'=+X  S:Y]"" Y=Y_"; " S Y=Y_$E($P(^DIC(4,X,0),U),1,18)
 W "Locations Selected: "_$S('$D(APCHLOCT):"All",1:""),Y,!
 S Y="",X=0 F  S X=$O(APCHPRVT(X)) Q:X'=+X  S:Y]"" Y=Y_"; " S Y=Y_$E($P(^VA(200,X,0),U),1,18)
 W "Providers/Users Selected: "_$S('$D(APCHPRVT):"All",1:""),Y,!
 W "--------------------------------------------------------------------",!
 W "LOCATION",?55,"#",!
 W "--------------------------------------------------------------------",!
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
LMEXIT ; -- exit code
 K APCHPWHT,APCHT
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
