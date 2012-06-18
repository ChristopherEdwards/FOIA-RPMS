AMER1 ; IHS/ANMC/GIS - ER ADMISSION QUESTIONS ;  
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
 Q
QA1 D QA1^AMER1A ; PATIENT NAME
 Q
 ;
QA2 ; DATE AND TIME OF ADMISSION TO ER
 I $D(^TMP("AMER",$J,1,2)) S Y=^(2) X ^DD("DD") S DIR("B")=Y
 E  S DIR("B")=$S($D(AMERBCH):"",1:"NOW")
 S DIR(0)="D^::ER",DIR("A")="*Date and time of admission to ER",DIR("?")="Enter date and time in the usual Fileman format (e.g. 1/1/2000@1PM)" D ^DIR K DIR
 D NOW^%DTC
 I Y>% D EN^DDIOL("FUTURE DATES NOT ALLOWED","","!!") G QA2
 I $D(AMEREFLG),X=U S AMERRUN=999 Q
 D OUT^AMER
 Q:$D(AMERQUIT)
 D APPNTMNT^AMERBSDU(AMERDFN,1,Y)
 ;
 Q
 ;
QA3 ; PRESENTING COMPLAINT
 K DIR("B") I $D(^TMP("AMER",$J,1,3)) S DIR("B")=^(3)
 I $D(AMERDOA) S DIR("B")="DOA"
 S DIR(0)="F^1:80",DIR("A")="*Presenting complaint",DIR("?")="Enter free text chief complaint (80 characters max.)" D ^DIR K DIR
 D CKSC I $D(AMERCKSC)!($TR(Y," ")="") K AMERCKSC G QA3
 D OUT^AMER
 Q
 ;
QA4 ; FULL REG EDIT
 N SDSEX
 S SDFN=AMERDFN,SDAMTYP="P"
 D ^BSDREG
 K SDFN,SDAMTYP
 S (X,Y)=""
 I $D(DUOUT) S X="^"
 I $D(DIROUT) S X="^^"
 K AMER1,AMER2
 I $D(AMERDOA) D
 . S AMERRUN=9,AMEROPT=""
 . S ^TMP("AMER",$J,1,4)=$$OPT^AMER0("EMERG","CLINIC TYPE")_U_"EMERG"
 . S ^TMP("AMER",$J,1,5)=$$OPT^AMER0("UNSCHEDULED REVISIT","VISIT TYPE")_U_"UNSCHEDULED REVISIT"
 . S ^TMP("AMER",$J,1,9)=$$OPT^AMER0("EMERGENT","TRIAGE CAT")_U_"EMERGENT"
 . Q
 Q
 ;
QA5 ; VISIT TYPE
 N AMERVTYP
 S DIC("B")=""
 S DIC("A")="*Visit type: "
 S AMERVTYP=$O(^AMER(3,"B","UNSCHEDULED VISIT",0))
 S:AMERVTYP="" AMERVTYP=$O(^AMER(3,"B","UNSCHEDULED",0))  ;IHS/OIT/SCR 10/10/08 - CHANGED TO MATCH NEW OPTION 
 ;S:AMERVTYP="" AMERVTYP=$O(^AMER(3,"B","FIRST VISIT",0))
 I $D(^TMP("AMER",$J,1,5)) S %=+^(5),DIC("B")=$P(^AMER(3,%,0),U)
 I DIC("B")=""&(AMERVTYP'="") S DIC("B")=$P($G(^AMER(3,AMERVTYP,0)),U,1) ;IF 'FIRST VISIT' exists, set it to default if original entry doesn't exist
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("VISIT TYPE"),DIC(0)="AEQ"
 D ^DIC K DIC
 D OUT^AMER
 Q
 ;
QA10 ; MODE OF TRANSPORT TO HOSPITAL
 S DIC("A")="*Mode of transport to the ER: " K DIC("B")
 I $D(^TMP("AMER",$J,1,10)) S %=+^(10),DIC("B")=$P(^AMER(3,%,0),U)
 E  S DIC("B")="PRIVATE VEHICLE/WALK IN"
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("MODE OF TRANSPORT"),DIC(0)="AEQ"
 D ^DIC K DIC
 D OUT^AMER I $D(AMERQUIT) Q
 I Y'["AMBULANCE",X'?1."^" S AMERRUN=99 K ^TMP("AMER",$J,1,11),^(12),^(13),^(14)
 Q
 ; 
QA11 ; AMBULANCE NUMBER
 S DIR("A")="Ambulance number" D QAXX
 Q
 ;
QA12 ; AMBULANCE HRCN/BILLING NUMBER
 S DIR("A")="Ambulance HRCN/billing number" D QAXX
 I $D(AMERDOA) S AMERRUN=13 Q
 Q
 ;
QA14 ; AMBULANCE COMPANY
 S DIC("A")="Ambulance company: " K DIC("B")
 I $D(^TMP("AMER",$J,1,14)) S %=+^(14),DIC("B")=$P(^AMER(3,%,0),U)
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("AMBULANCE COMPANY"),DIC(0)="AEQ"
 D ^DIC K DIC
 D OUT^AMER I $D(AMERQUIT) Q
 I '$D(AMERDOA) S AMERRUN=20 Q
 S AMERRUN=99
 Q
 ;
QAXX ; TEXT CAPTURE
 K DIR("B") I $D(^TMP("AMER",$J,1,AMERRUN)) S DIR("B")=^(AMERRUN)
 S DIR(0)="FO^1:20",DIR("?")="Enter free text (30 characters max.)" D ^DIR K DIR
 D CKSC I $D(AMERCKSC) K AMERCKSC G QAXX
 D OUT^AMER
 Q
 ;
CKSC ; ENTRY POINT FROM SEVERAL ROUTINES
 N X
 S X=$S(Y[";":"semi-colon",Y[":":"colon",1:"") K AMERCKSC
 I X'="" S AMERCKSC="" W !!,*7,"Sorry, you can't use a ",X," in your answer...Try again",!!
 Q
 ;
CHKINGO(CLINIC) ; return 1 if okay to proceed with checkin
 NEW GO,DATE,END
 S DATE=DT,END=DT+.24,GO=1
 F  S DATE=$O(^DPT(DFN,"S",DATE)) Q:DATE=""  Q:DATE>END  D
 . I +$G(^DPT(DFN,"S",DATE,0))=CLINIC D  S GO=0
 .. W !!,"*** Patient already checked in at "_$$FMTE^XLFDT(DATE)_" ***"
 I GO Q 1
 Q +$$READ("Y","Want to Check Patient In Again")
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ; EP; calls reader, returns response
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
