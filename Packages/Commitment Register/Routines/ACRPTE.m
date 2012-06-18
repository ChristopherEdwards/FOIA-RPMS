ACRPTE ; GENERATED FROM 'ACR TRAINING EVALUATION' PRINT TEMPLATE (#3956) ; 09/30/09 ; (FILE 9002191.6, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3956,"DXS")
 S I(0)="^ACRTVAL(",J(0)=9002191.6
 D N:$X>0 Q:'DN  W ?0 W "DOCUMENT...............:"
 S X=$G(^ACRTVAL(D0,0)) W ?26 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 D N:$X>0 Q:'DN  W ?0 W "DHHS DOCUMENT #........:"
 W ?26 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "ATTENDEE...............:"
 S X=$G(^ACRTVAL(D0,0)) W ?26 S Y=$P(X,U,2) S Y(0)=Y S Y=$$NAME2^ACRFUTL1(Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 W "TRAINING VENDOR........:"
 W ?26 X DXS(1,9.2) S X=$P($G(^AUTTVNDR(+$P(DIP(101),U,1),0)),U) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "DATE EVALUATION ENTERED:"
 S X=$G(^ACRTVAL(D0,0)) W ?26 S Y=$P(X,U,3) D DT
 D N:$X>0 Q:'DN  W ?0 W "DATE EVALUAITON SIGNED.:"
 W ?26 S Y=$P(X,U,4) D DT
 D T Q:'DN  D N W ?0 W "COURSE EVALUATION"
 D N:$X>64 Q:'DN  W ?64 W "|  RATING"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "1. Degree to which objectives of the training were met"
 D N:$X>64 Q:'DN  W ?64 W "|"
 S X=$G(^ACRTVAL(D0,"DT")) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,1) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "2. Effectiveness of the coverage of the subject matter"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,2) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "3. Degree of difficulty of the training"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,3) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "4. Quality of the training materials"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,4) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "5. Quality of the instruction"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,5) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "6. Effectiveness of the overall administraton"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,6) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D PAUSE^ACRFWARN K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "7.  Appropriateness of the length of the training"
 D N:$X>64 Q:'DN  W ?64 W "|"
 S X=$G(^ACRTVAL(D0,"DT")) D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,7) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "8.  Adequacy of the training facilities"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,8) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "9.  Applicability of the subject matter to your job"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,9) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "10. Degree to which training improves job performance"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,10) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "11. Degree to which training will meet career development goals"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,11) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "12. Level of recommendation for others to attend this training"
 D N:$X>64 Q:'DN  W ?64 W "|"
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,12) W:Y]"" $J(Y,2,0)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "COMMENTS:"
 S I(1)=1,J(1)=9002191.61 F D1=0:0 Q:$O(^ACRTVAL(D0,1,D1))'>0  S D1=$O(^(D1)) D:$X>11 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACRTVAL(D0,1,D1,0)) S DIWL=12,DIWR=71 D ^DIWP
 Q
A1R ;
 D 0^DIWW
 D ^DIWW
 D TESIGS^ACRFTO K DIP K:DN Y
 D PAUSE^ACRFWARN K DIP K:DN Y
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
