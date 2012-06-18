ORCDPS1 ;SLC/MKB-Pharmacy dialog utilities ; 08 May 2002  2:12 PM
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**94,117,141,149**;Dec 17, 1997
EN(TYPE) ; -- entry action for Meds dialogs
 S ORINPT=$$INPT^ORCD,ORCAT=$G(TYPE) I ORCAT="" D
 . I $G(ORENEW)!$G(OREWRITE)!$D(OREDIT),$L($P($G(OR0),U,12)) S ORCAT=$P(OR0,U,12) Q  ;use value from order, via ORCACT4
 . S ORCAT=$S(ORINPT:"I",1:"O")
 S ORDG=+$O(^ORD(100.98,"B",$S(ORCAT="I":"UD RX",1:"O RX"),0))
 K ^TMP("PSJMR",$J),^TMP("PSJNOUN",$J),^TMP("PSJSCH",$J)
 I $G(ORENEW)!$G(OREWRITE)!$D(OREDIT)!$G(ORXFER) D
 . K ORDIALOG($$PTR("START DATE/TIME"),1)
 . K ORDIALOG($$PTR("NOW"),1) Q:ORCAT'="O"
 . I $G(OREDIT)!$G(OREWRITE) N PI S PI=$$PTR("PATIENT INSTRUCTIONS") K ORDIALOG(PI,1),^TMP("ORWORD",$J,PI) ;start over
 . I $D(OREDIT),'$O(ORDIALOG($$PTR^ORCD("OR GTX INSTRUCTIONS"),0)) K ^TMP("ORWORD",$J)
 I ORINPT,ORCAT="O" W $C(7),!!,"NOTE: This will create an outpatient prescription for an inpatient!",!
 Q
 ;
EN1 ; -- setup Meds dialog for quick order editor using ORDG
 N DG S DG=$P($G(^ORD(100.98,+$G(ORDG),0)),U,3)
 I $P(DG," ")="O" S ORINPT=0,ORCAT="O"
 E  S ORINPT=1,ORCAT="I"
 K ^TMP("PSJMR",$J),^TMP("PSJNOUN",$J),^TMP("PSJSCH",$J)
 Q
 ;
ENOI ; -- setup OI prompt
 N D S D=$G(ORDIALOG(PROMPT,"D"))
 S:D="S.RX" ORDIALOG(PROMPT,"D")=$S(ORCAT="I":"S.UD RX",1:"S.O RX")
 I ORCAT="I",'ORINPT,D="S.UD RX" D  ;limit to IV meds for outpt's
 . S ORDG=+$O(^ORD(100.98,"B","O RX",0)),ORDIALOG(PROMPT,"D")="S.IVM RX"
 . S ORDIALOG(PROMPT,"?")="Enter the IV medication you wish to order for this patient."
 Q
 ;
DEA ; -- ck DEA# of ordering provider if SchedII drug
 Q:$G(ORTYPE)="Z"  N DEAFLG,PSOI
 S PSOI=+$P($G(^ORD(101.43,+$G(Y),0)),U,2) Q:PSOI'>0
 S DEAFLG=$$OIDEA^PSSUTLA1(PSOI,ORCAT) Q:DEAFLG'>0  ;ok
 I $G(ORNP),'$L($P($G(^VA(200,+ORNP,"PS")),U,2)),'$L($P($G(^("PS")),U,3)) W $C(7),!,$P($G(^(0)),U)_" must have a DEA# or VA# to order this drug!" K DONE Q
 I DEAFLG=1 W $C(7),!,"This order will require a wet signature!"
 Q
 ;
CHANGED(X) ; -- Kill dependent values when prompt X changes
 N PROMPTS,NAME,PTR,P,I
 S PROMPTS=X I X="OI" D
 . S PROMPTS="INSTRUCTIONS^ROUTE^SCHEDULE^START DATE/TIME^DURATION^AND/THEN^DOSE^DISPENSE DRUG^SIG^PATIENT INSTRUCTIONS^DAYS SUPPLY^QUANTITY^REFILLS^SERVICE CONNECTED"
 . K ORDRUG,ORDOSE,OROUTE,ORSCH,ORSD,ORDSUP,ORQTY,ORQTYUNT,OREFILLS,ORCOPAY
 . K ^TMP("PSJINS",$J),^TMP("PSJMR",$J),^TMP("PSJNOUN",$J),^TMP("PSJSCH",$J)
 I X="DS" S PROMPTS="QUANTITY^REFILLS" K OREFILLS
 F P=1:1:$L(PROMPTS,U) S NAME=$P(PROMPTS,U,P) D
 . S PTR=$$PTR(NAME) Q:'PTR
 . S I=0 F  S I=$O(ORDIALOG(PTR,I)) Q:I'>0  K ORDIALOG(PTR,I)
 . K ORDIALOG(PTR,"LIST"),^TMP("ORWORD",$J,PTR)
 Q
 ;
ORDITM(OI) ; -- Check OI inactive date & type, get dependent info
 Q:OI'>0  ;quit - no value
 N ORPS,PSOI S ORPS=$G(^ORD(101.43,+OI,"PS")),PSOI=+$P($G(^(0)),U,2)
 S ORIV=$S($P(ORPS,U)=2:1,1:0)
 I $G(ORCAT)="O",'$P(ORPS,U,2) W $C(7),!,"This drug may not be used in an outpatient order." S ORQUIT=1 D WAIT Q
 I $G(ORCAT)="I" D  Q:$G(ORQUIT)
 . I $G(ORINPT),'$P(ORPS,U) W $C(7),!,"This drug may not be used in an inpatient order." S ORQUIT=1 D WAIT Q
 . I '$G(ORINPT),'ORIV W $C(7),!,"This drug may not be ordered for an outpatient." S ORQUIT=1 D WAIT Q
 I $G(ORTYPE)="Q" D  I $G(ORQUIT) D WAIT Q
 . N DEAFLG S DEAFLG=$$OIDEA^PSSUTLA1(PSOI,ORCAT) Q:DEAFLG'>0  ;ok
 . I $G(ORNP),'$L($P($G(^VA(200,+ORNP,"PS")),U,2)),'$L($P($G(^("PS")),U,3)) W $C(7),!,$P($G(^(0)),U)_" must have a DEA# or VA# to order this drug!" S ORQUIT=1 Q
 . I DEAFLG=1 W $C(7),!,"This order will require a wet signature!"
OI1 ; -ck NF status
 I $P(ORPS,U,6),'$G(ORENEW) D  ;prompt for alternative
 . W !!,"*** This medication is not in the formulary! ***"
 . N PSX,CNT,ORX,DIR,X,Y,DTOUT,DUOUT
 . D EN1^PSSUTIL1(.PSOI,ORCAT) I '$O(PSOI(0)) D  Q
 .. W !,"    There are no formulary alternatives entered for this item."
 .. W !,"    Please consult with your pharmacy before ordering it."
 . S PSX=0,CNT=0 F  S PSX=$O(PSOI(PSX)) Q:PSX'>0  D
 .. S ORX=+$O(^ORD(101.43,"ID",PSX_";99PSP",0)) Q:ORX'>0
 .. S CNT=CNT+1,PSOI("OI",CNT)=ORX_U_PSX
 .. S DIR("A",CNT)=$J(CNT,3)_" "_$P($G(^ORD(101.43,ORX,0)),U)
 . S DIR(0)="NAO^1:"_CNT,DIR("A")="Select alternative (or <return> to continue): "
 . S DIR("?")="The medication selected is not in the formulary; you may select one of the above listed alternatives instead, or press <return> to continue processing this order."
 . Q:CNT'>0  W !,"    Formulary alternatives:" D ^DIR
 . I Y'>0 S:$D(DTOUT)!$D(DUOUT) ORQUIT=1 Q
 . D:OI'=+PSOI("OI",+Y) CHANGED("OI") ;reset parameters if different
 . S OI=+PSOI("OI",+Y),ORDIALOG(PROMPT,INST)=OI,OROI=OI
 . S PSOI=+$P(PSOI("OI",+Y),U,2)
OI2 ; -get selectable routes, doses [also called from NF^ORCDPS]
 D:'$D(^TMP("PSJMR",$J)) START^PSSJORDF(PSOI,$G(ORCAT))
 I '$D(ORDOSE) D
 . D DOSE^PSSORUTL(.ORDOSE,PSOI,$S($G(ORCAT)="I":"U",1:"O"),+ORVP)
 . K:$G(ORDOSE(1))=-1 ORDOSE
 Q
 ;
NFI(OI) ; -- Show NFI restrictions, if exist
 N PSOI,I,J,LCNT,MAX,X,STOP
 S PSOI=+$P($G(^ORD(101.43,+$G(OI),0)),U,2)
 D EN^PSSDIN(PSOI,"") Q:'$D(^TMP("PSSDIN",$J,"OI",PSOI))
 S I=0,LCNT=0,MAX=$S($G(IOBM)&$G(IOTM):IOBM-IOTM+1,1:24) W !
 F  S I=$O(^TMP("PSSDIN",$J,"OI",PSOI,I)) Q:I'>0  D
 . S J=0 F  S J=$O(^TMP("PSSDIN",$J,"OI",PSOI,I,J)) Q:J'>0  S X=$G(^(J)) D  Q:$G(STOP)
 .. S LCNT=LCNT+1 I LCNT'<MAX S:'$$CONT STOP=1 Q:$G(STOP)  S LCNT=1
 .. W !,X
 W ! K ^TMP("PSSDIN",$J,"OI",PSOI)
 Q
 ;
CONT() ; -- Press return to cont or ^ to stop
 N X,Y,DIR,DUOUT,DTOUT,DIRUT,DIROUT S DIR(0)="EA"
 S DIR("A")="Press <return> to continue or ^ to stop ..."
 D ^DIR S:$D(DUOUT)!$D(DTOUT) Y=""
 Q +Y
 ;
WAIT ; -- Wait for user
 N X W !,"Press <return> to continue ..." R X:DTIME
 Q
 ;
ROUTES ; -- Get allowable med routes
 Q:$G(ORDIALOG(PROMPT,"LIST"))  N I,X,CNT S (I,CNT)=0
 F  S I=$O(^TMP("PSJMR",$J,I)) Q:I'>0  S X=^(I),CNT=CNT+1,ORDIALOG(PROMPT,"LIST",CNT)=$P(X,U,3)_U_$P(X,U,1,2),ORDIALOG(PROMPT,"LIST","B",$P(X,U))=$P(X,U,3)
 S:$G(CNT) ORDIALOG(PROMPT,"LIST")=CNT
 S:$G(ORTYPE)'="Z" REQD=$S(ORCAT="I":1,$P($G(^ORD(101.43,+$G(OROI),"PS")),U,5):0,1:1)
 Q
 ;
DEFRTE ; -- Get default route
 N INST1 S INST1=$O(ORDIALOG(PROMPT,0)) S:INST1'>0 INST1=INST ;1st inst
 I INST1=INST S Y=+$P($G(^TMP("PSJMR",$J,1)),U,3) K:Y'>0 Y Q
 S Y=+$G(ORDIALOG(PROMPT,INST1)) K:Y'>0 Y S:$G(Y) EDITONLY=1
 Q
 ;
CKSCH ; -- validate schedule [Called from P-S Action]
 N ORX S ORX=ORDIALOG(PROMPT,ORI) Q:ORX=$G(ORESET)  K ORSD ;reset
 D EN^PSSGS0(.ORX,$G(ORCAT))
 I $D(ORX) S ORDIALOG(PROMPT,ORI)=ORX D CHANGED("QUANTITY") Q  ;ok
 W $C(7),!,"Enter either a standard administration schedule or one of your own,",!,"up to 70 characters and no more than 2 spaces.",!
 K DONE
 Q
 ;
DEFCONJ ; -- Set default conjuction for previous instance
 ;    (Called from P-S Action of Instructions prompt)
 N LAST,DUR,CONJ
 S LAST=$O(ORDIALOG(PROMPT,ORI),-1) Q:LAST'>0  ;first instance
 S CONJ=$$PTR("AND/THEN") Q:$L($G(ORDIALOG(CONJ,LAST)))
 S DUR=$G(ORDIALOG($$PTR("DURATION"),LAST))
 S ORDIALOG(CONJ,LAST)=$S(+DUR'>0:"A",1:"T")
 Q
 ;
ENCONJ ; -- Get allowable values, if req'd for INST
 N P S P=$$PTR("INSTRUCTIONS")
 S REQD=$S($O(ORDIALOG(P,INST)):1,1:0)
 S ORDIALOG(PROMPT,"A")="And/then"_$S(ORCAT="O":"/except: ",1:": ")
 S $P(ORDIALOG(PROMPT,0),U,2)="A:AND;T:THEN;"_$S(ORCAT="O":"X:EXCEPT;",1:"")
 Q
 ;
DSUP ; -- Get max/default days supply
 N ORX,Y
 S ORX("PATIENT")=+$G(ORVP),ORX("DRUG")=+$G(ORDRUG)
 D DSUP^PSOSIGDS(.ORX) S Y=+$G(ORX("DAYS SUPPLY")) S:Y'>0 Y=90
 ;S $P(ORDIALOG(PROMPT,0),U,2)="1:"_Y ;max allowed
 I '$G(ORDIALOG(PROMPT,1)),$G(ORTYPE)'="Z" S ORDIALOG(PROMPT,1)=Y
 Q
 ;
QTY() ; -- Return default quantity [Expects ORDSUP]
 N INSTR,DOSE,DUR,SCH,I,ORX,X,Y
 S Y="" I $G(ORDSUP)'>0!'$G(ORDRUG) G QTYQ ;need days supply, disp drug
 S INSTR=$$PTR("INSTRUCTIONS")
 S DOSE=$$PTR("DOSE"),CONJ=$$PTR("AND/THEN")
 S DUR=$$PTR("DURATION"),SCH=$$PTR("SCHEDULE")
 S I=0 F  S I=$O(ORDIALOG(INSTR,I)) Q:I'>0  D  Q:'$D(ORX)
 . S X=$P($G(ORDIALOG(DOSE,I)),"&",3) I X'>0 K ORX Q
 . S ORX("DOSE ORDERED",I)=X,ORX("SCHEDULE",I)=$G(ORDIALOG(SCH,I))
 . S X=$G(ORDIALOG(DUR,I)),ORX("DURATION",I)=$$HL7DUR^ORMBLDPS
 . S ORX("CONJUNCTION",I)=$G(ORDIALOG(CONJ,I))
 G:'$D(ORX) QTYQ ;no doses
 S ORX("PATIENT")=+$G(ORVP),ORX("DRUG")=+$G(ORDRUG)
 S ORX("DAYS SUPPLY")=+$G(ORDSUP)
 D QTYX^PSOSIG(.ORX) S Y=$G(ORX("QTY"))
QTYQ Q Y
 ;
MAXREFS ; -- Get max refills allowed [Entry Action]
 Q:$G(ORCAT)'="O"  N ORX,X
 S ORX("ITEM")=+$P($G(^ORD(101.43,+$G(OROI),0)),U,2)
 S ORX("DRUG")=+$G(ORDRUG),ORX("PATIENT")=+$G(ORVP)
 I $G(OREVENT),$$TYPE^OREVNTX(OREVENT)="D" S ORX("DISCHARGE")=1
 S ORX("DAYS SUPPLY")=$G(ORDSUP) D MAX^PSOSIGDS(.ORX)
 S OREFILLS=$G(ORX("MAX")),X=$G(ORDIALOG(PROMPT,INST))
 I OREFILLS'>0 K ORDIALOG(PROMPT,INST) W !,"No refills allowed." Q
 S $P(ORDIALOG(PROMPT,0),U,2)="0:"_OREFILLS
 S ORDIALOG(PROMPT,"A")="Refills (0-"_OREFILLS_"): "
 I X,X>OREFILLS S ORDIALOG(PROMPT,INST)=OREFILLS
 Q
 ;
ASKSC() ; -- Return 1 or 0, if SC prompt should be asked
 I $$SC^PSOCP(+ORVP,+$G(ORDRUG)) Q 0
 ;I $$RXST^IBARXEU(+ORVP)>0 Q 0 ;exempt from copay
 Q 1
 ;
PTR(X) ; -- Return ptr to prompt OR GTX X
 Q +$O(^ORD(101.41,"AB","OR GTX "_X,0))
 ;
EXIT ; -- exit action for Meds dialogs
 S:$G(ORXNP) ORNP=ORXNP
 K ORXNP,ORINPT,ORCAT,ORPKG,OROI,ORIV,ORDRUG,ORDOSE,OROUTE,ORSCH,ORSD,ORDSUP,OREFILLS,ORQTY,ORQTYUNT,ORCOPAY,PSJNOPC,ORCOMPLX
 K ^TMP("PSJMR",$J),^TMP("PSJNOUN",$J),^TMP("PSJSCH",$J)
 Q
