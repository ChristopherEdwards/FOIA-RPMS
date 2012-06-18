AQAOPA3 ; IHS/ORDC/LJF - PRINT ACTION EVAL WORKSHEETS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn includes the user interface and call to DIP to print
 ;evaluation worksheets for actions due for review.
 ;
ASK ; >>> ask for action plans by number or category
 K AQAOARR S (X,Y)=0 F  Q:X=""  Q:X=U  Q:Y=-1  D
 .W !! K DIC S DIC="^AQAO(5,",DIC(0)="AEMQZ"
 .S DIC("A")="ACTION PLAN (ID # or Category):  "
 .S DIC("A")=$S('$D(AQAOARR):"Select ",1:"Select Another ")_DIC("A")
 .S DIC("S")="I $P(^AQAO(5,Y,0),U,6)="""" D ACTCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 .D ^DIC Q:X=""  Q:X="^"  Q:Y=-1
 .S AQAOARR($P(Y,U,2))=+Y
 G END:'$D(AQAOARR)
 ;
 ;
DEV ; >>> get print device
 W !! S %ZIS="QP" D ^%ZIS G END:POP S AQAODEV=ION
 I '$D(IO("Q")) G PRINT
 K IO("Q") S ZTRTN="PRINT^AQAOPA3",ZTDESC="ACTION EVAL SHEETS"
 S ZTSAVE("AQAOARR(")="",ZTSAVE("AQAODEV")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC G END
 ;
 ;
PRINT ; >>> print each worksheet on separate page 
 S AQAONUM=0
 F  S AQAONUM=$O(AQAOARR(AQAONUM)) Q:AQAONUM=""  D
 .S AQAOPN=AQAOARR(AQAONUM) Q:AQAOPN=""
 .W !,AQAONUM,?20,AQAOPN
 .S L="",DIC="^AQAO(5,",FLDS="[AQAO EVAL WORKSHEET]"
 .S BY="@NUMBER",(TO,FR)=AQAOPN,IOP=AQAODEV
 .I $D(ZTQUEUED) S IOP="Q;"_AQAODEV,DQTIME="NOW"
 .D EN1^DIP K IOP ;display action plan
 .I '$D(ZTQUEUED),(IOST["C-") D
 ..K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR
 ;
 ;
END ; >>> eoj
 D ^%ZISC D KILL^AQAOUTIL Q
