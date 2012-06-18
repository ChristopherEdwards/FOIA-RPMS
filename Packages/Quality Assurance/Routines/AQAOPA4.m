AQAOPA4 ; IHS/ORDC/LJF - PRINT ACTION PLANS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn includes the user interface and calls to DIP to print
 ;action plan summaries selected by number by the user.
 ;
ASK ; >>> ask for action plans by number or category
 K AQAOARR S (X,Y)=0 F  Q:X=""  Q:X=U  Q:Y=-1  D
 .W !! K DIC S DIC="^AQAO(5,",DIC(0)="AEMQZ"
 .S DIC("A")="ACTION PLAN (ID # or Category):  "
 .S DIC("A")=$S('$D(AQAOARR):"Select ",1:"Select Another ")_DIC("A")
 .S DIC("S")="D ACTCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 .D ^DIC Q:X=""  Q:X="^"  Q:Y=-1
 .S AQAOARR($P(Y,U,2))=+Y
 G END:'$D(AQAOARR)
 ;
 ;
DEV ; >>> get print device
 W !! S %ZIS="QP" D ^%ZIS G END:POP S AQAODEV=ION
 I '$D(IO("Q")) G PRINT
 K IO("Q") S ZTRTN="PRINT^AQAOPA4",ZTDESC="PRINT ACTION PLANS"
 S ZTSAVE("AQAOARR(")="",ZTSAVE("AQAODEV")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC G END
 ;
 ;
PRINT ; >>> print each summary by looping through array & call ^dip
 S AQAONUM=0
 F  S AQAONUM=$O(AQAOARR(AQAONUM)) Q:AQAONUM=""  D
 .S AQAOPN=AQAOARR(AQAONUM) Q:AQAOPN=""
 .S L="",DIC="^AQAO(5,",FLDS="[AQAO LONG DISPLAY]"
 .S BY="@NUMBER",(TO,FR)=AQAOPN,IOP=AQAODEV
 .I $D(ZTQUEUED) S IOP="Q;"_AQAODEV,DQTIME="NOW"
 .D EN1^DIP K AQAOCHK("OK"),IOP ;display action plan
 .I '$D(ZTQUEUED),(IOST["C-") K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR
 ;
 ;
END ; >>> eoj
 D ^%ZISC D KILL^AQAOUTIL Q
