APCHAAP1 ; IHS/CMI/LAB - ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR("*** Print ASTHMA ACTION PLAN ***"),!!
 W "This option will produce an Asthma Action Plan that",!,"can be given to the patient.",!!
SELPT ;
 W !
 S DFN=""
 K DIC S DIC=9000001,DIC("A")="Select patient: ",DIC(0)="AEQM" D ^DIC K DIC
 I Y=-1 D EXIT Q
 S DFN=+Y W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) !,"Patient's chart number is ",$P(^(0),U,2),! W !
RELMED ;
 S APCHRELM=$P($$REDZONE(DFN),U)  ;get last recorded red zone instructions
 W !!,"Please enter the RED ZONE Plan for this patient, including medication name(s)"
 W !,"and instructions.",!
 I APCHRELM]"" W !,"Red Zone Instructions currently recorded:",!?2,APCHRELM,!
 S DIR(0)="S^B:Display a Blank line for the Instructions to be Hand Written;N:Enter a New Set of Red Zone Instructions"_$S(APCHRELM]"":";E:Use Existing Red Zone Instructions shown above",1:"")
 S DIR("A")="Red Zone Instructions" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G SELPT
 I Y="" G SELPT
 S APCHRZC=Y
 I APCHRZC="B" S APCHRELM="" G RESMED
 I APCHRZC="E" G RESMED
 ;S DIR(0)="FO^2:200",DIR("A")="Enter Patient's Red Zone instructions" KILL DA D ^DIR KILL DIR
 S DIR(0)="9000010.41,1301",DIR("A")="Enter Red Zone Instructions" KILL DA D ^DIR KILL DIR
 I X="^" G SELPT
 I $D(DIRUT) G SELPT
 S APCHRELM=Y ;I APCHRELM="" S APCHRELM="________________________________________________________________"
RESMED ;
 S APCHRESM=$P($$YELZONE(DFN),U)  ;get last recorded YELLOW zone instructions
 W !!,"Please enter the YELLOW ZONE Plan for this patient, including medication name(s)"
 W !,"and instructions.",!
 I APCHRESM]"" W !,"Red Zone Instructions currently recorded:",!?2,APCHRESM,!
 S DIR(0)="S^B:Display a Blank line for the Instructions to be Hand Written;N:Enter a New Set of Yellow Zone Instructions"_$S(APCHRESM]"":";E:Use Existing Yellow Zone Instructions on File",1:"")
 S DIR("A")="Yellow Zone Instructions" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G RELMED
 I Y="" G RELMED
 S APCHRZY=Y
 I APCHRZY="B" S APCHRESM="" G VISIT
 I APCHRZY="E" G VISIT
 ;S DIR(0)="FO^2:200",DIR("A")="Enter Patient's Red Zone instructions" KILL DA D ^DIR KILL DIR
 S DIR(0)="9000010.41,1101",DIR("A")="Enter Yellow Zone Instructions" KILL DA D ^DIR KILL DIR
 I X="^" G RESMED
 I $D(DIRUT) G RESMED
 S APCHRESM=Y ;I APCHRELM="" S APCHRELM="________________________________________________________________"
 ;
VISIT ;
 I APCHRZY="B",APCHRZC="B" G ZIS  ;if 2 blank lines then don't ask for visit as there is nothing to store in V ASTHMA
 ;CHECK TO SEE IF ALREADY STORED TODAY
 S (O,T)=""
 S R=$$REDZONE(DFN) I $P(R,U)=APCHRELM,$P(R,U,2)=DT S O=1
 S Y=$$YELZONE(DFN) I $P(Y,U)=APCHRESM,$P(Y,U,2)=DT S T=1
 I O,T W !!,"These instuctions are already stored for today." G ZIS
 ;get visit to attach the instructions to
 K APCHIN
 S APCHIN("PAT")=DFN
 S APCHIN("VISIT DATE")=DT_".12"
 S APCHIN("SITE")=DUZ(2)
 S APCHIN("VISIT TYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^APCCCTRL(DUZ(2),0),U,4),1:"O")
 S APCHIN("SRV CAT")="A"
 S APCHIN("USR")=DUZ
 S APCHIN("SHOW VISITS")=1
 S APCHIN("TIME RANGE")=-1
VISIT1 ;
 K APCDALVR
 K APCHV
 D GETVISIT^APCDAPI4(.APCHIN,.APCHV)
 S APCHERR=$P(APCHV(0),U,2)
 I APCHERR]"" W !!,"Error creating visit......." G SELPT
 I $P(APCHV(0),U)=1 S V=$O(APCHV(0)) I APCHV(V)="ADD" S APCDVSIT=V G VAST
 ;since more than one passed back display them to the user and quit
 W !!,"You must now select a visit to attach these instuctions to.  Select the "
 W !,"appropriate visit or create a new visit.",!
SELECT ; SELECT EXISTING VISIT
 W !!,"PATIENT: ",$P(^DPT(DFN,0),U)," has one or more VISITs on ",$$FMTE^XLFDT(DT),".",!,"If one of these is your visit, please select it",!
 K APCHV1 S (APCHC,APCHA,APCHX)="",APCHV1=0 F  S APCHV1=$O(APCHV(APCHV1)) Q:APCHV1'=+APCHV1  S APCHX=$G(^AUPNVSIT(APCHV1,0)),APCHX11=$G(^AUPNVSIT(APCHV1,11)) D WRITE
 S APCHC=APCHC+1 W !,APCHC,"  Create New Visit",!
 K DIR
 S DIR(0)="N^1:"_APCHC,DIR("A")="Select" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCHIN("FORCE ADD")=1 G VISIT1
 I APCHC=Y S APCHIN("FORCE ADD")=1 G VISIT1
 S APCDVSIT=APCHX1(Y)
 K APCHIN,APCDALVR
VAST ;now create V Asthma entry
 ;
 K APCDALVR
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.41 (ADD)]"
 S APCDALVR("APCDTPRV")="`"_DUZ
 S APCDAVLR("APCDTEPR")="`"_DUZ
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDTRZ")=$P(APCHRELM,U,1)
 S APCDALVR("APCDTYZ")=$P(APCHRESM,U,1)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) W !!,"Error creating V Asthma entry to store instuctions." G SELPT
 ;
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^APCHAAP1",XBRC="",XBRX="EXIT^APCHAAP1",XBNS="APCH"
 D ^XBDBQUE
 D EXIT
 Q
WRITE ; WRITE VISITS FOR SELECT
 S APCHC=APCHC+1,APCHX1(APCHC)=APCHV1
 S APCHVLT=$P(+APCHX,".",2),APCHVLT=$S(APCHVLT="":"<NONE>",$L(APCHVLT)=1:APCHVLT_"0:00 ",1:$E(APCHVLT,1,2)_":"_$E(APCHVLT,3,4)_$E("00",1,2-$L($E(APCHVLT,3,4)))_" ")
 S APCHVLOC=""
 I $P(APCHX,U,6),$D(^AUTTLOC($P(APCHX,U,6),0)) S APCHVLOC=$P(^(0),U,7),APCHVLOC=APCHVLOC_$E("    ",1,4-$L(APCHVLOC))
 S:APCHVLOC="" APCHVLOC="...."
 W !,APCHC,"  TIME: ",APCHVLT,"LOC: ",APCHVLOC," TYPE: ",$P(APCHX,U,3)," CAT: ",$P(APCHX,U,7)," CLINIC: ",$S($P(APCHX,U,8)]"":$E($P(^DIC(40.7,$P(APCHX,U,8),0),U),1,8),1:"<NONE>") D
 .W ?57,"DEC: ",$S($P(APCHX,U,9):$P(APCHX,U,9),1:0),$S($P(APCHX11,U,3)]"":" VCN:"_$P(APCHX11,U,3),1:"")
 .I $P(APCHX,U,22) W !?3,"Hospital Location: ",$P($G(^SC($P(APCHX,U,22),0)),U)
 .S APCHTIU=$$PRIMPROV^APCLV(APCHV1,"N") I APCHTIU]"" W !?3,"Provider on Visit: ",APCHTIU
 .S APCHTIU=$O(^AUPNVNOT("AD",APCHV1,0)) I APCHTIU W !?3,"TIU Note: ",$$VAL^XBDIQ1(9000010.28,APCHTIU,.01),"  AUTHOR: ",$$VAL^XBDIQ1(9000010.28,APCHTIU,1202)
 .S APCHTIU=$$PRIMPOV^APCLV(APCHV1,"C") W !?3,"Primary POV: ",APCHTIU,"  Narrative: ",$E($$PRIMPOV^APCLV(APCHV1,"N"),1,40)
 K APCHVLT,APCHVLOC,APCHTIU
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCHAAP1"")"
 S XBRC="",XBRX="EXIT^APCHAAP1",XBIOP=0 D ^XBDBQUE
 Q
PRINT ;EP
 D PRINT^APCHAAP2
 Q
REDZONE(P) ;EP - get last recorded red zone instructions
 NEW R,D,I,S
 S R=""  ;instructions
 S D=""
 S S=""
 F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(R]"")  D
 .S I=0 F  S I=$O(^AUPNVAST("AA",P,D,I)) Q:I'=+I!(R]"")  D
 ..S R=$P($G(^AUPNVAST(I,13)),U,1),S=9999999-D
 ..Q
 .Q
 Q R_U_S
YELZONE(P) ;EP - get last recorded yellow zone instructions
 NEW R,D,I
 S R=""  ;instructions
 S D="",S=""
 F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(R]"")  D
 .S I=0 F  S I=$O(^AUPNVAST("AA",P,D,I)) Q:I'=+I!(R]"")  D
 ..S R=$P($G(^AUPNVAST(I,11)),U,1),S=9999999-D
 ..Q
 .Q
 Q R_U_S
HEAD ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQ=1 Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,$P(^DIC(4,DUZ(2),0),U),?53,"Today's Date: ",$$FMTE^XLFDT(DT),!
 W "Patient Name: ",$P(^DPT(DFN,0),U)
 W ?45,"Birth Date: ",$$DOB^AUPNPAT(DFN,"E")
 W ?71,"Age: ",$$AGE^AUPNPAT(DFN),!
 W $$REPEAT^XLFSTR("_",79),!!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EXIT ;
 D EN^XBVK("APCH")
 D ^XBFMK
 Q
