ANSES1 ;IHS/OIRM/DSD/CSC - ENTER/EDIT STAFFING DATA; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;ENTER/EDIT STAFFING DATA
EN F  D EN1 Q:$D(DTOUT)!$D(DUOUT)
 K DTOUT,DUOUT
 Q
EN1 S DIC="^ANSD(59.2,",DIC(0)="AQZEM",DIC("A")="Non-Direct Area.....: "
 W !
 D DIC^ANSDIC
 I Y<1 S DUOUT="" Q
 S ANSSTR=+Y
 I $D(^ANS(ANSDA,"N",+ANSSTR,0)) S ANSSTR=+^(0) D SET Q
 D SB1
 Q:$D(DTOUT)!$D(DUOUT)
 D SET
 Q
SET S:'$D(^ANS(ANSDA,"N",0)) ^(0)="^9009053.1P^^"
 I '$P(ANSSTR,U,2) D DEL Q
 D SET2:$D(^ANS(ANSDA,"N",+ANSSTR)),SET1:'$D(^ANS(ANSDA,"N",+ANSSTR))
 Q
SET1 S DIC="^ANS("_ANSDA_",""N"",",DIC(0)="L",DA(1)=ANSDA,(X,DINUM)=+ANSSTR
 D FILE^ANSDIC
 S DA=+Y
 D SET2
 Q
SET2 S DIE="^ANS("_ANSDA_",""N"",",DA=+ANSSTR,DA(1)=ANSDA,DR=".02////"_$P(ANSSTR,U,2)
 D DIE^ANSDIC
 Q
DEL S DA(1)=ANSDA,DA=+ANSSTR,DIK="^ANS("_ANSDA_",""N"","
 D DIK^ANSDIC
 Q
SB1 S DIR(0)="FO^^D SBCC^ANSES1",DIR("A")="Non-Direct Care Hrs."  ;CSC 12-97
 S:'$G(T) T=0  ;CSC 12-97
 S DIR("B")=T  ;CSC 12-97
 S DIR("?",1)="Enter A Number From 0 to 999, Fractional Numbers (eg. 12.25)",DIR("?")="May Also Be Entered In Quarter Hours."
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 I 'Y S DUOUT=""
 E  S $P(ANSSTR,U,2)=+Y
 Q
SBD W !!,"Currently Listed Non-Direct Care Areas",!
 S (T,C,N)=0
 F  S N=$O(^ANS(ANSDA,"N",N)) Q:'N  D
 .S X=^ANS(ANSDA,"N",N,0),Y=$P(X,U,2),X=+X
 .Q:'X
 .Q:'$D(^ANSD(59.2,X,0))
 .S X=$P(^ANSD(59.2,X,0),U),T=T+Y
 .W:C ?40
 .W "  ",$E(X,1,20),?20
 .W:C ?60
 .W $J(Y,5)
 .S C='C
 .I $X>41 W !
 Q
SBCC ;;CSC 12-97 
 Q:X?.N
 Q:X?1".".2N
 Q:X?2N1"."2N
 K X 
 Q
