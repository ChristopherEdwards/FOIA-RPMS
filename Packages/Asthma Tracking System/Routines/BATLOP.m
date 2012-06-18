BATLOP ; IHS/CMI/LAB - ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("*** Print ASTHMA REMINDER LETTER for ONE PATIENT ***"),!!
 W "This option will produce an Asthma Visit Reminder Letter that",!,"can be sent to the patient.",!!
 S BATDFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 D EXIT Q
 S BATDFN=+Y
 W !!,$P(^DPT(BATDFN,0),U),"'s last asthma visit (visit on which asthma data",!,"elements were entered) was on ",$S($$LASTAV^BATU(BATDFN,2)]"":$$FMTE^XLFDT($$LASTAV^BATU(BATDFN,2)),1:"<<no asthma visits found>>"),".",!
 W !
 S DIR(0)="Y",DIR("A")="Do you still want to print a visit reminder letter",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S BATOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BATLOP",XBRC="",XBRX="EXIT^BATLOP",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATLOP"")"
 S XBRC="",XBRX="EXIT^BATLOP",XBIOP=0 D ^XBDBQUE
 Q
PRINT ;EP
 S BATAL=$O(^BATAL("B","ASTHMA VISIT REMINDER",0))
 S BATPG=1 K BATQ
 W:$D(IOF) @IOF
 D SET(BATDFN)
 S BATX=0 F  S BATX=$O(^TMP($J,"ASTHMA LETTER",BATX)) Q:BATX'=+BATX!($D(BATQ))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(BATQ)
 .W !,^TMP($J,"ASTHMA LETTER",BATX)
 Q
SET(BATP) ;EP
 ;set up letter in ^TMP
 K ^TMP($J,"ASTHMA LETTER")
 S ^TMP($J,"ASTHMA LETTER",0)=0
 S X="",$E(X,57)="Date: "_$$FMTE^XLFDT(DT) D S(X,1)
 ;write out facility and address
 S X=$$CTR^BATU($P(^DIC(4,DUZ(2),0),U),80) D S(X)
 S X=$$CTR^BATU($$VAL^XBDIQ1(9999999.06,DUZ(2),.14)) I X]"" D S(X)
 I $P(^AUTTLOC(DUZ(2),0),U,15)]"" S X=$$CTR^BATU($$VAL^XBDIQ1(9999999.06,DUZ(2),.15)_","_" "_$$VAL^XBDIQ1(9999999.06,DUZ(2),.16)_"  "_$$VAL^XBDIQ1(9999999.06,DUZ(2),.17)) D S(X)
 S X=$P(^DPT(BATP,0),U) D S(X,2)
 S X=$$VAL^XBDIQ1(2,BATP,.111) D S(X)
 I $P($G(^DPT(BATP,11)),U,2)]"" S X=$$VAL^XBDIQ1(2,BATP,.112) D S(X)
 I $P($G(^DPT(BATP,11)),U,3)]"" S X=$$VAL^XBDIQ1(2,BATP,.113) D S(X)
 S X=$$VAL^XBDIQ1(2,BATP,.114)_", "_$$VAL^XBDIQ1(2,BATP,.115)_"  "_$$VAL^XBDIQ1(2,BATP,.116) D S(X)
 S X="Dear "_$P($P(^DPT(BATP,0),U),",",2)_" "_$P($P(^DPT(BATP,0),U),",",1)_"," D S(X,3)
 S X="According to our records your last visit to the clinic for your asthma was " D S(X,2)
 S X="on "_$$FMTE^XLFDT($$LASTAV^BATU(BATP,2))_"." D S(X)
 S X="" D S(X)
 NEW BATX
 S BATX=0 F  S BATX=$O(^BATAL(1,1,BATX)) Q:BATX'=+BATX  S X=$G(^BATAL(1,1,BATX,0)) D S(X)
 ;S X="" D S(X,6)
 S X="Please call "_$S($P($G(^BATSITE(DUZ(2),0)),U,4)]"":$P(^BATSITE(DUZ(2),0),U,4),1:$P(^DIC(4,DUZ(2),0),U))_" at "_$S($P($G(^BATSITE(DUZ(2),0)),U,5)]"":$P(^BATSITE(DUZ(2),0),U,5),1:$P(^AUTTLOC(DUZ(2),0),U,11))
 S X=X_" to schedule" D S(X,7)
 S X="your appointment." D S(X)
 S X="" D S(X)
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP($J,"ASTHMA LETTER",0),U)+1,$P(^TMP($J,"ASTHMA LETTER",0),U)=%
 S ^TMP($J,"ASTHMA LETTER",%)=X
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EXIT ;
 D EN^XBVK("BAT")
 D ^XBFMK
 Q
