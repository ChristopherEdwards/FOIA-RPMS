DGINTEG ; IHS/ADC/PDW/ENM - MAS INTEGRITY CHECKER DEC 12, 1987 ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;;MAS VERSION 5.0
 ; IHS/HQW/KML 2/12/97 replace $N with $O w/o changing functionality
 G EN
CHK S X=$E(DGR_" "_DGDOT,1,12) W !,X S DGT=0 X "ZL @DGR X:DGRU DGIN F DGY=3:1 S (DGA,DGD)="""",DGL=$T(+DGY) Q:DGL']""""  S DGLN=$L(DGL) X DGCC" I '$D(DGU) X DGWR ; W " ASCII Value of Routine ===> ",$J(DGT,15)
 Q
CC S DGCC="F DGC=1:1:DGLN S DGA=$A(DGL,DGC) S DGD=DGA_""^""_$P(DGD,""^"",1,2) S DGT=(DGA*DGC)+DGT I $S(DGLN>2:$P(DGD,""^"",2,3),1:$P(DGD,""^"",1,2))=""59^32"",DGA'=59!(DGLN=2) X DGSB Q"
 S DGSB="S DGT=DGT-($P(DGD,""^"",1)*DGC)-($P(DGD,""^"",2)*(DGC-1)) I DGC>2 S DGT=DGT-($P(DGD,""^"",3)*(DGC-2)) I DGC>3,$A(DGL,DGC-3)=32 S DGT=DGT-(32*(DGC-3))"
 S DGWR="W "" ASCII Value ===> "",$J(DGT,11),""-Now"" S Y=$O(^DG(43,1,""ROU"",""B"",DGR,0)) I Y>0,$D(^DG(43,1,""ROU"",Y,0)) S X=$P(^(0),""^"",2) I X W $J(X,11),""-Orig."" X DGWR1"
 S DGWR1="S Y=$S(DGT=X:""No Change"",DGT<X:""-""_(X-DGT),1:""+""_(DGT-X)),Y=""(""_Y_"")"" W ""  "",$J(Y,12)" Q
EN D Q F I=1:1 S J=$P($T(T+I),";;",2) Q:J="QUIT"  W !,J
EN1 K ^UTILITY($J) X ^%ZOSF("RSEL") I $O(^UTILITY($J,0))']"" W !!,"NO ROUTINES SELECTED!",*7 G Q
 S DGR=0,(DGDOT,DGRU)="",$P(DGDOT,".",30)="" F DGR1=0:0 S DGR=$O(^UTILITY($J,DGR)) Q:DGR=""  D CC,CHK
 ;
Q K %,%DT,DGA,DGC,DGCC,DGCOM,DGCT,DGD,DGDT,DGE,DGI,DGIN,DGL,DGLB,DGLN,DGM,DGMOD,DGNODE,DGR,DGRU,DGSB,DGT,DGU,DGV,DGVER,DGY,DIC,I,J,X,Y Q
T ;
 ;;This routine is used to determine the existing ASCII value of a selected routine
 ;;versus the value which was transported at the time of release.  The ASCII value
 ;;of the routine is determined as follows:
 ;;
 ;;1.  The first line of the routine is presumed to contain the routine name and a
 ;;    brief description and is excluded from the count.
 ;;
 ;;2.  All lines which start with a singular semi-colon are presumed to be comment
 ;;    lines and are excluded from the count.
 ;;
 ;;3.  All other lines, including those starting with two semi-colons are included
 ;;    in the count.
 ;;
 ;;4.  Any line which contains a space followed by a singular semi-colon are pre-
 ;;    sumed to be followed by comments and this portion of the line will be ex-
 ;;    cluded from the count.  Likewise for lines which contain a QUIT followed by
 ;;    two spaces and a singular semi-colon.
 ;;
 ;;5.  The total ASCII value of the routine is determined by taking, excluding the
 ;;    exceptions, as noted above, and multiplying the ASCII value of each
 ;;    character by its position on the line being checked.
 ;;
 ;;QUIT
