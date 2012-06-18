XBHEDD7 ;402,DJB,10/23/91,EDD - Count fields, Printing
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
 ;;This is run each time EDD is run, right after you select a File.
 ;;It sets up multiples in ^UTILITY($J,"TMP")
MULT ;
 D MULTBLD K CNT,TMP Q
MULTBLD ;
 K ^UTILITY($J)
 S CNT=1,^UTILITY($J,"TMP",ZNUM)=$P(^DD(ZNUM,0),U,4)_"^"_CNT,^UTILITY($J,"TOT")=$P(^DD(ZNUM,0),U,4)
 Q:'$D(^DD(ZNUM,"SB"))  S TMP(1)=ZNUM,CNT=2,TMP(CNT)=""
 F  S TMP(CNT)=$O(^DD(TMP(CNT-1),"SB",TMP(CNT))) D MULTBLD1 Q:CNT=1
 Q
MULTBLD1 ;
 I TMP(CNT)="" S CNT=CNT-1 Q
 I '$D(^DD(TMP(CNT),0)) Q
 S ^UTILITY($J,"TMP",TMP(CNT))=$P(^DD(TMP(CNT),0),U,4)_"^"_CNT_"^"_$O(^DD(TMP(CNT-1),"SB",TMP(CNT),""))
 S ^UTILITY($J,"TOT")=^UTILITY($J,"TOT")+$P(^DD(TMP(CNT),0),U,4)
 I $D(^DD(TMP(CNT),"SB")) S CNT=CNT+1,TMP(CNT)=""
 Q
PRINTM ;Option 11 in Main Menu
 S FLAGP1=1 ;Redraws Main Menu. See MENU+2^XBHEDD.
PRINT ;
 I FLAGS W *27,"[?4l" S FLAGS=0 ;Reset scroll to normal
 S FLAGP=FLAGP=0 I FLAGP=0 W:IO'=IO(0)&('FLAGM) @IOF D ^%ZISC S SIZE=(IOSL-5) Q  ;If FLAGM user hit <RETURN> at Main Menu pompt.
 S %ZIS("A")="        DEVICE: " D ^%ZIS K %ZIS("A") I POP S FLAGP=0 Q
 S SIZE=(IOSL-5) Q
TXT ;
 W @IOF Q:'FLAGP  W:IO'=IO(0) !!!
 I '$D(EDDDATE) S X="NOW",%DT="T" D ^%DT K %DT S EDDDATE=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)
 W !,$E(ZLINE1,1,IOM),!?2,"File:---- ",ZNAM,!?2,"Global:-- ",ZGL,?(IOM-17),"Date: ",EDDDATE,!,$E(ZLINE1,1,IOM),!
 Q
SCROLL ;Adjust scroll rate
 W !!?8,"SCROLLING:  [N]ormal  [S]mooth . . . . ","Select: N//"
 R SCROLL:DTIME S:'$T SCROLL="^" S SCROLL=$E(SCROLL) I SCROLL="^" S FLAGQ=1 Q
 I SCROLL="?" W !?8,"Since you're printing to your CRT and you've asked for a page",!?8,"length greater than 25, you may now adjust the scroll rate.",!?8,"For DEC VT-100 compatible devices only." G SCROLL
 S:SCROLL="" SCROLL="N" Q:"S,s"'[SCROLL  S FLAGS=1 W *27,"[?4h" Q
INIT ;
 I FLAGP,IO=IO(0),IOSL>25 D SCROLL Q:FLAGQ
 I FLAGP W:IO'=IO(0) "  Printing.." U IO
 D TXT Q
