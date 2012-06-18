FHASM1 ; HISC/REL - Nutrition Assessment ;1/25/00  12:08
 ;;5.0;Dietetics;**2,4,22,24**;Oct 11, 1995
 W @IOF,!!?20,"N U T R I T I O N   A S S E S S M E N T",!! S X="T",%DT="X" D ^%DT S DT=+Y
F1 ; Select Patient
 S ALL=1 D ^FHDPA G PAT:X="*",KIL:'DFN S Y(0)=^DPT(DFN,0),NAM=$P(Y(0),U,1),SEX=$P(Y(0),U,2),AGE=$P(Y(0),U,3)
 I $P($G(^DPT(DFN,.35)),"^",1) W *7,!!?5,"  [ Patient has expired. ]" G KIL
 I AGE'="" S AGE=$E(DT,1,3)-$E(AGE,1,3)-($E(DT,4,7)<$E(AGE,4,7))
 I SEX=""!(AGE="") G P1
F2 S X="NOW",%DT="XT" D ^%DT S ADT=Y
F3 I DFN,$D(^FHPT(DFN,"N",9999999-ADT)) S ADT=$$FMADD^XLFDT(ADT,,,1) G F3
 S FHAP=$G(^FH(119.9,1,3)),FHU=$P(FHAP,"^",1)
 S (TSF,TSFP,SCA,SCAP,ACIR,ACIRP,CCIR,CCIRP,BFAMA,BFAMAP,BMI,BMIP,X1,X2)=""
 G:'DFN F4 S XX=$O(^FHPT(DFN,"N",0)) G:XX="" F4 S XX=$G(^(XX,0)),HGT=$P(XX,"^",4),HGP=$P(XX,"^",5)
 I HGP'="S" S X1=$S(HGT\12:HGT\12_"'",1:"")_$S(HGT#12:" "_(HGT#12)_"""",1:""),X2=+$J(HGT*2.54,0,0)_"CM",X1=$S(FHU'="M":X1,1:X2)
F4 S (KNEE,EXT)="" W !!,"Height: " W:X1'="" X1,"// " R X:DTIME G:'$T!(X["^") KIL I X="",X1'="" S Y0=$J(HGT,0,0),H1=Y0 G F5
 D TR,HGT I Y<1 D HGP G F4
 S HGT=Y,H1=Y0,HGP=Y1
F5 R !!,"Weight: ",X:DTIME S:X="" X="?" G:'$T!(X["^") KIL
 S:X="a" X="A"
 I X="A",AGE>39 D A^FHASM2D G:Y<1 F5 S WGT=Y,WGP="A" G F6
 D WGT I Y<1 D WGP W:AGE>39 !,"You may enter an A to calculate weight anthropometrically." G F5
 S WGT=Y,WGP=Y1
F6 S %DT="AEP",%DT("A")="Date Weight Taken: ",%DT("B")="TODAY",%DT(0)="-T" W ! D ^%DT K %DT G KIL:X["^"!$D(DTOUT),F6:Y<1
 S DWGT=Y
F7 R !!,"Usual Weight: ",X:DTIME G:'$T!(X["^") KIL I X="" S UWGT="" G F8
 D WGT S UWGT=Y I Y<1 D WGP G F7
F8 K %DT,A1,K,X,Y G ^FHASM2
HGT ; Convert Height to inches
 S A1=+X I 'A1 S Y=-1 Q
 S X=$P(X,A1,2,99) S:$E(X,1)=" " X=$E(X,2,99) I "SMK"[$E(X,1) S Y=A1 S:FHU="M" Y=Y/2.54 G H1
 I """I"[$E(X,1) S Y=A1 G H1
 I $E(X,1)="C" S Y=A1/2.54 G H1
 I "'F"'[$E(X,1) S Y=-1 G H2
 S Y=A1*12 F K=1:1 Q:$E(X,K)?.N
 I $E(X,K,99)="" G H1
 S A1=+$E(X,K,99),X=$P(X,A1,2,99) S:$E(X,1)=" " X=$E(X,2,99)
 I """I"'[$E(X,1) S Y=-1 G H2
 S Y=Y+A1
H1 I X["K" D K^FHASM2D
H2 I Y<12!(Y>96) S Y=-1
 S:Y>0 Y0=+$J(Y,0,0),Y=+$J(Y,0,1) S Y1=$S(X["K":"K",X["S":"S",1:"") Q
HGP ; Height Help
 W !!,"Enter height as: 6' 2"" or 74"" or 74IN or 6FT 2 IN or 30CM"
 W !,"Add an S if height is stated rather than measured."
 W !,"Add a K if value is a Knee Height measurement."
 W !,"Height should be between 12"" and 96"" (8')." Q
WGT ; Convert Weight to lbs.
 D TR S A1=+X I 'A1 S Y=-1 Q
 S X=$P(X,A1,2,99) S:$E(X,1)=" " X=$E(X,2,99) I "SM"[$E(X,1) S Y=A1 S:FHU="M" Y=Y*2.2 G W1
 I $E(X,1)="O" S Y=A1/16 G W1
 I $E(X,1)="G" S Y=A1/1000*2.2 G W1
 I $E(X,1)="K" S Y=A1*2.2 G W1
 I "L#"'[$E(X,1) S Y=-1 G W1
 S Y=A1 F K=1:1 Q:$E(X,K)?.N
 I $E(X,K,99)="" G W1
 S A1=+$E(X,K,99),X=$P(X,A1,2,99) S:$E(X,1)=" " X=$E(X,2,99)
 I $E(X,1)'="O" S Y=-1 G W1
 S Y=A1/16+Y
W1 I Y<0!(Y>750) S Y=-1
 S:Y>0 Y0=+$J(Y,0,0),Y=+$J(Y,0,1) S Y1="" S:X["S" Y1="S" Q
WGP ; Weight help
 W !!,"Enter Weight as 150# or 150# 6OZ or 800G or 70KG"
 W !,"Add an S if weight is stated rather than measured."
 W !,"Enter an A to determine weight anthropometrically."
 W !,"Weight should be between 0 Lbs and 750 Lbs." Q
TR ; Translate Lower to Upper Case
 D TR^FH
 Q
KIL ; Final variable kill
 G KILL^XUSCLEAN
PAT S (DFN,SEX,AGE,PID)="" R !!,"Enter Patient's Name: ",NAM:DTIME G:'$T!(NAM["^") KIL
 I NAM["?"!(NAM'?.ANP)!(NAM="") W *7,!?5,"Enter Patient's Name to be printed on the report." G PAT
P1 I SEX="" R !,"Sex: ",SEX:DTIME S:SEX="" SEX="?" G:'$T!(SEX["^") KIL S X=SEX D TR S SEX=X I $P("FEMALE",SEX,1)'="",$P("MALE",SEX,1)'="" W *7,"  Enter M or F" S SEX="" G P1
 S SEX=$E(SEX,1)
P2 I AGE="" R !,"Age: ",AGE:DTIME S:AGE="" AGE="?" G:'$T!(AGE["^") KIL S X=AGE D TR S AGE=X
 S:AGE["M" AGE=+$J($P(AGE,"M",1)/12,0,2) I AGE'>0!(AGE>124) W !?5,"Enter Age Less Than 124 in Years or Months (followed by M) but Not Both" S AGE="" G P2
 G F2
