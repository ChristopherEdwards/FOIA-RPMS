AQAOPC9 ; IHS/ORDC/LJF - OCC REPORTS WITH XTRA SORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is the driver for the trending report by special review
 ;type.  This report adds an additional sort onto the 3 main trending
 ;reports available.  ONce the extra sort is selected, the user is
 ;dropped into one of those report rtns.
 ;
 D REVT^AQAOHOP3 ;intro text
SORT ; >>> ask user to choose which sort category to use
 W !! K DIC S DIC(0)="AEMZQ",DIC("A")="Choose a SORT CATEGORY:  "
 S DIC=9002169.9,DIC("S")="X ^AQAO1(9,Y,""DSPLY"")"
 D ^DIC G EXIT:$D(DUOUT),EXIT:X="",SORT:Y=-1
 S AQAOXSN=+Y,AQAOXSM=$P(Y,U,2)
 ;
ALL ; >>> ask if all sort values should be included in report
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Print Occurrences for ALL "_AQAOXSM D ^DIR
 Q:$D(DIRUT)  G ALL:Y=-1 I Y=1 S AQAOXS(0)="" G REPORT
 ;
SELECT ; >> ask user to choose which values to include
 ; code used determined by sort type
 S AQAOTYP=$P(^AQAO1(9,AQAOXSN,0),U,2)
 S X=$S(AQAOTYP="N":"NUMBER",AQAOTYP="S":"CODES",1:"POINTER") D @X
 I '$D(AQAOXS) G SORT
 I $G(^AQAO1(9,AQAOXSN,"DIRO"))]"" D XTRASCRN G SORT:'$D(AQAOXS(2))
 ;
REPORT ; >>> ask user to select report to run
 W !! K DIR S DIR(0)="NO^1:4"
 S DIR("A")="Select REPORT to print"
 F I=1:1:4 S DIR("A",I)=I_". "_$P($T(RTN+I),";;",2)
 S DIR("A",5)=" " D ^DIR G EXIT:$D(DTOUT),SORT:$D(DIRUT),REPORT:Y=-1
 S AQAORTN=$P($T(RTN+Y),";;",3) D @AQAORTN
 ;
EXIT ; >>> eoj
 D KILL^AQAOUTIL Q
 ;
 ;
POINTER ; >> SUBRTN to ask pointer values to include
 S AQAOI=0,AQAOSTOP="" K AQAOXS(1)
 F  S AQAOI=$O(^AQAO1(9,AQAOXSN,"PTR",AQAOI)) Q:AQAOI'=+AQAOI  D
 .S AQAOJ=$P(^AQAO1(9,AQAOXSN,"PTR",AQAOI,0),U) ;ptr file number
 .K DIC S DIC=AQAOJ,DIC(0)="AEMQZ"
 .S Y=0 F  D  Q:Y=-1  ;continue until all user wants are selected
 ..W ! D ^DIC Q:$D(DTOUT)  Q:$D(DUOUT)  Q:X=""  Q:Y=-1
 ..S:AQAOTYP="V" AQAOXS(1,+Y_";"_$P(^DIC(AQAOJ,0,"GL"),U,2))=$P(Y,U,2)
 ..S:AQAOTYP="P" AQAOXS(1,+Y)=$P(Y,U,2)
 Q
 ;
NUMBER ; >> SUBRTN to ask for number ranges to include
 Q
 ;
CODES ; >> SUBRTN to ask for code values to include
 Q
 ;
XTRASCRN ; >> SUBRTN to ask for xtra screen if one defined for sort
 K AQAOXS(2) W !!,"For the ",AQAOXSM," selected,",!
 K DIR S DIR("A")="Choose ONE"
 S X=^AQAO1(9,AQAOXSN,"DIR0") X X ;sets DIR(0)
 S X=0 F  S X=$O(^AQAO1(9,AQAOXSN,"DIRA",X)) Q:X'=+X  D
 .S DIR("A",X)=^AQAO1(9,AQAOXSN,"DIRA",X,0) ;set DIR(A,#)
 D ^DIR Q:$D(DIRUT)  G XTRASCRN:Y=-1
 S AQAOXS(2)=Y
 Q
 ;
RTN ;;
 ;;Occurrences By REVIEW CRITERIA;;^AQAOPC1
 ;;Occurrences By DIAGNOSIS/PROCEDURE;;^AQAOPC2
 ;;Occurrences By FINDINGS/ACTIONS;;^AQAOPC4
 ;;Occurrences for SINGLE CRITERION by MONTH;;^AQAOPC7
