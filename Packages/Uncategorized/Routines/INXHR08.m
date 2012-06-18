INXHR08 ; GENERATED FROM 'INHSG MESSAGE' PRINT TEMPLATE (#2828) ; 10/25/01 ; (FILE 4011, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2828,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W "***** Message *****************************************************************"
 S X=$G(^INTHL7M(D0,0)) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,45)
 D N:$X>66 Q:'DN  W ?66 W "Inactive:"
 D N:$X>76 Q:'DN  W ?76 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 S I(1)=3,J(1)=4011.03 F D1=0:0 Q:$O(^INTHL7M(D0,3,D1))'>0  S D1=$O(^(D1)) D:$X>76 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^INTHL7M(D0,3,D1,0)) S DIWL=5,DIWR=78 D ^DIWP
 Q
A1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "Standard:"
 S X=$G(^INTHL7M(D0,0)) D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,12) W:Y]"" $S($D(DXS(18,Y)):DXS(18,Y),1:Y)
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Event Type:"
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,2),1,20)
 D N:$X>41 Q:'DN  W ?41 W "Message Type:"
 D N:$X>56 Q:'DN  W ?56,$E($P(X,U,6),1,3)
 D T Q:'DN  D N D N:$X>1 Q:'DN  W ?1 W "Send Applic.:"
 S X=$G(^INTHL7M(D0,7)) D N:$X>15 Q:'DN  W ?15,$E($P(X,U,1),1,25)
 D N:$X>41 Q:'DN  W ?41 W "Rec. Applic.:"
 D N:$X>55 Q:'DN  W ?55,$E($P(X,U,3),1,25)
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "Facility:"
 D N:$X>15 Q:'DN  W ?15,$E($P(X,U,2),1,25)
 D N:$X>45 Q:'DN  W ?45 W "Facility:"
 D N:$X>55 Q:'DN  W ?55,$E($P(X,U,4),1,25)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Processing ID:"
 S X=$G(^INTHL7M(D0,0)) D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(19,Y)):DXS(19,Y),1:Y)
 D N:$X>28 Q:'DN  W ?28 W "HL7 Version:"
 D N:$X>41 Q:'DN  W ?41,$E($P(X,U,4),1,5)
 D N:$X>48 Q:'DN  W ?48 W "Lookup Parameter:"
 D N:$X>66 Q:'DN  W ?66 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(20,Y)):DXS(20,Y),1:Y)
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Accept Ack:"
 D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,10) W:Y]"" $S($D(DXS(21,Y)):DXS(21,Y),1:Y)
 D N:$X>49 Q:'DN  W ?49 W "Application Ack:"
 D N:$X>66 Q:'DN  W ?66 S Y=$P(X,U,11) W:Y]"" $S($D(DXS(22,Y)):DXS(22,Y),1:Y)
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "Root File:"
 D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^DIC(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,40)
 D N:$X>57 Q:'DN  W ?57 W "Audited:"
 D N:$X>66 Q:'DN  W ?66 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(23,Y)):DXS(23,Y),1:Y)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Routine for Lookup/Store:"
 S X=$G(^INTHL7M(D0,5)) D N:$X>26 Q:'DN  W ?26,$E($E(X,1,200),1,54)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Transaction Types:"
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W ""
 D RPTRANS^INHMG1(D0,"D T^DIWW") K DIP K:DN Y
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "MUMPS Code for Lookup:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(1)=4,J(1)=4011.06 F D1=0:0 Q:$O(^INTHL7M(D0,4,D1))'>0  S D1=$O(^(D1)) D:$X>0 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^INTHL7M(D0,4,D1,0)) S DIWL=4,DIWR=80 D ^DIWP
 Q
B1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Outgoing Initial MUMPS Code:"
 S:'$D(DIWF) DIWF="" S:DIWF'["N" DIWF=DIWF_"N" S X="" S I(1)=6,J(1)=4011.08 F D1=0:0 Q:$O(^INTHL7M(D0,6,D1))'>0  S D1=$O(^(D1)) D:$X>0 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^INTHL7M(D0,6,D1,0)) S DIWL=4,DIWR=80 D ^DIWP
 Q
C1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Generated Scripts -"
 D T Q:'DN  D N D N:$X>3 Q:'DN  W ?3 W "Input:"
 S X=$G(^INTHL7M(D0,"S")) D N:$X>10 Q:'DN  W ?10 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^INRHS(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,60)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "Output:"
 D N:$X>10 Q:'DN  W ?10 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^INRHS(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,60)
 S I(1)=1,J(1)=4011.01 F D1=0:0 Q:$O(^INTHL7M(D0,1,D1))'>0  X:$D(DSC(4011.01)) DSC(4011.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>10 T Q:'DN  D D1
 G D1R^INXHR082
D1 ;
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "=====Segment Name==================================ID=====Seq No==Req==Rep==OF=="
 S X=$G(^INTHL7M(D0,1,D1,0)) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^INTHL7S(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,45)
 G ^INXHR081
