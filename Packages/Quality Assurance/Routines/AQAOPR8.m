AQAOPR8 ; IHS/ORDC/LJF - INDICATOR MATRIX ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine contains the user interface for setting up the
 ;Performance Measurement Matrix report
 ;Added in Enhancement #1
 ;
 D MATRIX^AQAOHPRT
 ;
CHOOSE ; -- ask user which grouping to include
 W !! K DIR S DIR(0)="NO^1:3",DIR("B")=3
 S DIR("A",1)="  REPORT CHOICES:"
 S DIR("A",2)=" "
 S DIR("A",3)="  1. KEY FUNCTIONS ONLY"
 S DIR("A",4)="  2. DIMENSIONS OF PERFORMANCE ONLY"
 S DIR("A",5)="  3. INCLUDE BOTH"
 S DIR("A",6)=" "
 S DIR("A")="  Select Which Groupings to include in the Matrix"
 S DIR("?",1)="Choose #1 to print up to 22 Key Functions and their"
 S DIR("?",2)="linked Indicators in a matrix. Select up to 11 Key"
 S DIR("?",3)="Functions to stay within 80 columns."
 S DIR("?",4)=" "
 S DIR("?",5)="Choose #2 for a matrix with only Indicators and"
 S DIR("?",6)="Dimensions of Performance. You can include Review"
 S DIR("?",7)="Criteria with the dimension each one measures."
 S DIR("?",8)=" "
 S DIR("?",9)="Choose #3 to include up to 11 Key Functions plus the"
 S DIR("?",10)="Dimensions of Performance in the matrix. You can also"
 S DIR("?",11)="choose to see the Review Criteria. To stay within"
 S DIR("?",12)="80 columns you can select only 3 Key Functions."
 S DIR("?")=" " F I=1:1:12 S DIR("?",I)="     "_DIR("?",I)
 D ^DIR I $D(DIRUT)!(Y=-1) D EXIT Q
 S AQAOSEL=Y
 ;
 ; -- choose which functions to include
 I AQAOSEL'=2 D FUNCTION I $D(DTOUT)!$D(DUOUT)!'$D(AQAOFNC) D CHOOSE Q
 ;
 ; -- choose whether to include review criteria
 S AQAOCRT=0 I AQAOSEL'=1 D CRITERIA I $D(DIRUT) D CHOOSE Q
 ;
 ; -- calculate right margin for report
 S AQAOIOMX=$S($D(AQAOFNC($$MARGIN80+1)):132,1:80)
 I AQAOIOMX=132 D MSG("Use wide paper or condensed print!")
 ;
DEV ; -- SUBRTN to get print device and call print rtn
 W !! S %ZIS="QP" D ^%ZIS
 I POP D EXIT Q
 I '$D(IO("Q")) D ^AQAOPR81 Q
 K IO("Q") S ZTRTN="^AQAOPR81",ZTDESC="INDICATOR MATRIX"
 F I="AQAOSEL","AQAOFNC(","AQAOCRT","AQAOIOMX" S ZTSAVE(I)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 D PRTOPT^AQAOVAR D EXIT Q
 ;
 ;
EXIT ; -- SUBRTN for eoj
 I '$D(ZTQUEUED),(IOST["C-") D PRTOPT^AQAOVAR ;ask to  hit return
 D ^%ZISC D KILL^AQAOUTIL Q
 ;
 ;
FUNCTION ; -- SUBRTN to ask user for functions to include
 NEW AQAOCNT,DIC,X,Y K AQAOFNC S (X,AQAOCNT)=1
F2 S DIC="^AQAO(1,",DIC(0)="AEMQZ"
 F  Q:AQAOCNT>$$MOST  Q:$D(DTOUT)  Q:$D(DUOUT)  Q:X=""  D
 . W ! D ^DIC Q:$D(DTOUT)  Q:$D(DUOUT)  Q:Y=-1
 . S AQAOFNC(AQAOCNT)=+Y_U_Y(0,0)
 . I AQAOCNT=$$MARGIN80 D MSG("Selecting more Functions requires wide paper or condensed print")
 . S AQAOCNT=AQAOCNT+1
 ;
 I AQAOCNT=$$MOST D MSG("You have reached the maximum # of functions that can fit on this report")
 I '$D(AQAOFNC) D MSG("You have NOT selected any Key Functions")
 I $D(AQAOFNC) W !!?3,"You have selected:" D
 . S X=0 F  S X=$O(AQAOFNC(X)) Q:X=""  D
 .. W !?3,$P(AQAOFNC(X),U,2)
 ;
 I AQAOCNT'=$$MOST D  I Y=1 D F2 Q
 . W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 . S DIR("A")="Do you wish to select more Key Functions"
 . D ^DIR
 Q
 ;
 ;
CRITERIA ; -- SUBRTN to ask is criteria should be included in report
 NEW DIR,X,Y S AQAOCRT=0
 S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="List Review Criteria with each Indicator"
 S DIR("?",1)="Do you wish to list all Review Criteria for each"
 S DIR("?",2)="Clinical Indicator? This shows which review criteria"
 S DIR("?",3)="measure which dimensions of performance."
 S DIR("?")="Answer YES to include review criteria in the matrix."
 W ! D ^DIR I Y=1 S AQAOCRT=1
 Q
 ;
 ;
MOST() ; -- SUBRTN to return # of functions that can fit on this report
 Q $S(AQAOSEL=1:22,1:13)
 ;
MARGIN80() ; -- SUBRTN to return # of functions to fit in 80 columns
 Q $S(AQAOSEL=1:11,1:3)
 ;
MSG(X) ; -- SUBRTN to print warning messages
 W !!?5,*7,X Q
