INXHR04 ; GENERATED FROM 'INH MESSAGE DISPLAY' PRINT TEMPLATE (#2832) ; 10/25/01 ; (FILE 4001, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2832,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W ""
 W "" K DIP K:DN Y
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Date/Time:"
 S X=$G(^INTHU(D0,0)) D N:$X>11 Q:'DN  W ?11 S Y=$P(X,U,1) D DT
 D N:$X>31 Q:'DN  W ?31 W "Msg ID:"
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,5),1,30)
 D N:$X>70 Q:'DN  W ?70 W "Seq#:"
 D N:$X>76 Q:'DN  W ?76,$E($P(X,U,17),1,4)
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "Destination:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^INRHD(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,50)
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "Status:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "Direction:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>29 Q:'DN  W ?29 W "Priority:"
 D N:$X>39 Q:'DN  W ?39,$E($P(X,U,16),1,2)
 D N:$X>42 Q:'DN  W ?42 W ""
 N DIP,X1 S DIP(1)=$G(^INTHU(D0,0)) S X=$P(DIP(1),U,19),DIP(2)=$G(X) S X="TIME",X1=DIP(2) S:X]""&(X?.ANP) DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 D N:$X>45 Q:'DN  W ?45 W "Time to Process:"
 D N:$X>62 Q:'DN  W ?62 W ""
 W $$CDATASC^UTDT($G(DIPA("TIME")),1,1) K DIP K:DN Y
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Incoming Msg ID:"
 S X=$G(^INTHU(D0,2)) D N:$X>20 Q:'DN  W ?20,$E($P(X,U,1),1,20)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "Parent Message ID:"
 D N:$X>20 Q:'DN  W ?20 X DXS(1,9) K DIP K:DN Y W $E(X,1,30)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "Orig. Transaction:"
 S X=$G(^INTHU(D0,0)) D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^INRHT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,54)
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "Source:"
 D N:$X>20 Q:'DN  W ?20,$E($P(X,U,8),1,50)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "Acknowledge Req'd:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>26 Q:'DN  W ?26 W "Accept ACK Msg ID:"
 D N:$X>45 Q:'DN  W ?45 X DXS(2,9) K DIP K:DN Y W $E(X,1,30)
 D T Q:'DN  D N D N:$X>26 Q:'DN  W ?26 W "Applic ACK Msg ID:"
 D N:$X>45 Q:'DN  W ?45 X DXS(3,9) K DIP K:DN Y W $E(X,1,30)
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "# of Attempts:"
 S X=$G(^INTHU(D0,0)) D N:$X>20 Q:'DN  W ?20,$E($P(X,U,12),1,5)
 D N:$X>29 Q:'DN  W ?29 W "Last Attempt Date/Time:"
 D N:$X>53 Q:'DN  W ?53 S Y=$P(X,U,9) D DT
 D T Q:'DN  D N D N:$X>10 Q:'DN  W ?10 W "Division:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,21) S Y=$S(Y="":Y,$D(^DG(40.8,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>8 Q:'DN  W ?8 W "Created by:"
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,15) S Y=$S(Y="":Y,$D(^DIC(3,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,40)
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "Edited by:"
 S X=$G(^INTHU(D0,2)) D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(3,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W ""
 D MESS^INHU1(D0) K DIP K:DN Y
 D T Q:'DN  D N D N:$X>27 Q:'DN  W ?27 W "****  Activity Log  ****"
 S I(1)=1,J(1)=4001.01 F D1=0:0 Q:$O(^INTHU(D0,1,D1))'>0  X:$D(DSC(4001.01)) DSC(4001.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>27 T Q:'DN  D A1
 G A1R
A1 ;
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Date                Status Set to             Replicated Message ID"
 S X=$G(^INTHU(D0,1,D1,0)) D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) D DT
 D N:$X>23 Q:'DN  W ?23 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>49 Q:'DN  W ?49 N DIP X DXS(4,9.2) S D1=I(1,0) K DIP K:DN Y W $E(X,1,20)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "Message:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(2)=1,J(2)=4001.02 F D2=0:0 Q:$O(^INTHU(D0,1,D1,1,D2))'>0  S D2=$O(^(D2)) D:$X>1 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^INTHU(D0,1,D1,1,D2,0)) S DIWL=3,DIWR=78 D ^DIWP
 Q
A2R ;
 D A^DIWW
 Q
A1R ;
 G ^INXHR041
