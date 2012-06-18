AQAOLKP ; IHS/ORDC/LJF - LOOKUP UTILITIES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for occurrence selection, adding an
 ;occurrence and extrinsic variables for asking user to select occ
 ;date, indicator, beginning date, and ending date.  Also includes
 ;extrinsic variable for a screen on review type.
 ;
ASK ;ENTRY POINT for selecting occurrence
 ; >>> ask for occ id or patient name or indicator
 K AQAOIFN W !! K DIC S DIC="^AQAOC(",DIC(0)="AEMQZ"
 S DIC("A")="Select OCCURRENCE (ID #, Patient, or Indicator):  "
 S DIC("S")="D OCCCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 D ^DIC Q:$D(DTOUT)  Q:$D(DUOUT)  Q:X=""  Q:Y=-1
 S AQAOIFN=+Y,AQAOCID=Y(0,0)
 S AQAOPAT=$P(Y(0),U,2),AQAOIND=$P(Y(0),U,8),AQAODATE=$P(Y(0),U,4)
 ;
 ; >> display occurrence
 S L="",DIC="^AQAOC(",FLDS="[AQAO OCC SHORT DISPLAY]"
 S BY="@NUMBER",(TO,FR)=AQAOIFN,IOP=IO(0) D EN1^DIP ;display occurrence
 K DIR S DIR(0)="E"
 S DIR("A")="Press RETURN to continue OR '^' to select another occurrence"
 D ^DIR
 Q
 ;
 ;
ADD ;ENTRY POINT for adding new occurrence
 ; >>> ask patient name & date & indicator then enter
 W ! K DIC S DIC="^DPT(",DIC(0)="AEMQ" D ^DIC Q:Y=-1  S AQAOPAT=+Y
 ;
 W ! S %DT="AEX",%DT("A")="Enter OCCURRENCE DATE: " D ^%DT
 G:Y=-1 ADD S AQAODATE=+Y
 ;
 W ! K DIC S DIC="^AQAO(2,",DIC(0)="AEMQ" ;indicator lookup
 S DIC("S")="D INDCHK^AQAOSEC I $D(AQAOCHK(""OK"")),+$G(^AQAO(2,Y,1))"
 S DIC("A")="Enter CLINICAL INDICATOR:  "
 D ^DIC K AQAOCHK("OK") W ! G:Y=-1 ADD S AQAOIND=+Y
 ;
 ;
CHECK ; >>> check if occurrence already entered; if so go to edit
 D ^AQAOENTQ I $D(DIRUT) K DIRUT G ADD
 I $D(AQAO) S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="E",AQAOUDIT("COMMENT")="EDIT OCCURRENCE" D ^AQAOAUD Q
 D CREATE G ASK:'$D(AQAOCID)
 Q
 ;
 ;
CREATE ;ENTRY POINT else, create case identifier than add entry
 W !!,"Please wait while I create the occurrence entry . . ."
 S AQAOCID=$$OCCID^AQAOCID Q:AQAOCID=""
 S DIC="^AQAOC(",DIC(0)="AEMQ"
 S DIC("DR")=".02////"_AQAOPAT_";.04////"_AQAODATE_";.08////"_AQAOIND_";.09////"_DUZ(2)_";.11///^S X=0"
 L +^AQAGU(0):1 I '$T W !!,"CANNOT ADD; AUDIT FILE LOCKED. TRY AGAIN.",! Q
 L +(^AQAOC(0)):1 I '$T W !,"CANNOT ADD NEW ENTRY; ANOTHER USER ADDING TO FILE. TRY AGAIN." Q
 S X=AQAOCID K DD,DO,DINUM D FILE^DICN K DIC("DR")
 L -(^AQAOC(0)):0 I Y=-1 L -^AQAGU(0) Q
 S AQAOIFN=+Y ;ifn in qi occurrence file
 W !!,"Your CASE # is ",AQAOCID,!
 ;
AUDIT S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="O"
 S AQAOUDIT("COMMENT")="OPEN A RECORD" D ^AQAOAUD
 Q
 ;
 ;
OCCDT(V) ;ENTRY POINT  EXTR FUNC to ask user for occ date;PATCH 2
 N Y,%DT
 W ! S %DT="AEX",%DT("A")="Enter OCCURRENCE DATE: "
 S %DT("B")=V D ^%DT ;PATCH 2
 Q Y
 ;
 ;
IND() ;ENTRY POINT  EXTR VAR to ask user for indicator
 N DIC,Y
 W !! S DIC="^AQAO(2,",DIC(0)="AEMQZ"
 S DIC("S")="D INDCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 S DIC("A")="Enter CLINICAL INDICATOR:  " D ^DIC K AQAOCHK("OK")
 I $D(DTOUT)!($D(DUOUT))!(X="") S Y=U
 Q Y
 ;
 ;
BDATE() ;ENTRY POINT  EXTR VAR ask user to choose beginning date for report
BD1 N DIR,Y
 W !! S DIR(0)="DO^::EX",DIR("A")="Select EARLIEST OCCURRENCE DATE"
 D ^DIR I Y>DT W *7,"   NO FUTURE DATES" G BD1
 S Y=$S(Y>0:Y,$D(DTOUT):U,1:"")
 Q Y
 ;
EDATE() ;ENTRY POINT  EXTR VAR ask user to choose ending date for report
ED1 N DIR,Y
 W ! S DIR(0)="DO^::EX",DIR("A")="Select LATEST OCCURRENCE DATE"
 D ^DIR I Y>DT W *7,"   NO FUTURE DATES" G ED1
 I +Y,(Y<AQAOBD) W *7," ENDING DATE MUST BE AFTER BEGINNING DATE" S Y=""
 S Y=$S(Y>0:Y,$D(DTOUT):U,1:"")
 Q Y
 ;
 ;
RTYPE() ;EP; EXTRN VAR - screen on selecting review types 
 ; to select BTR must have Blood Product file
 ; to select PTF must have Drug file
 N X S X=0
 I (Y<3)!(Y>5) S X=1 G RTEND ;not type that needs screen
 I (Y=3),$O(^LAB(66,0)) S X=1 G RTEND ;check for blood product file
 I $O(^PSDRUG(0)),$D(^DD(50.6,0))#2 S X=1 ;check for drug file
RTEND Q X
 ;
EXCEP(X) ;EP; EXTRN FUNC to test whether ind has exception recorded
 Q $S($P($G(^AQAOC(X,1)),U,2)]"":1,1:0)
