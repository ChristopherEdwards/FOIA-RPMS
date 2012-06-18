FHASM3	; HISC/REL - Antropometrics ;5/14/93  09:17
	;;5.0;Dietetics;;Oct 11, 1995
	I EXT="Y" G NEXT
EXT	R !!,"Do you wish Anthropometric Assessment? NO// ",EXT:DTIME S:EXT="" EXT="N" G:'$T!(EXT["^") KIL^FHASM1 S X=EXT D TR^FHASM1 S EXT=X
	I $P("YES",EXT,1)'="",$P("NO",EXT,1)'="" W *7,!," Enter YES if you have Anthropometric measurements; Otherwise NO" G EXT
	S EXT=$E(EXT,1) I EXT="Y" D ANT G:EXT="" KIL^FHASM1
NEXT	; Calculate BMI
	S A2=HGT*.0254,BMI=+$J(WGT/2.2/(A2*A2),0,1)
	D ^FHASM3A G ^FHASM4
ANT	; Anthropometric measurements
	R !!,"Triceps Skin Fold (mm): ",TSF:DTIME G QT:'$T!(TSF["^"),A1:TSF=""
	I TSF'?.N.1".".N!(TSF<1)!(TSF>100) W !?5,"Enter value between 1 and 100; outside values should be assessed manually" G ANT
A1	R !,"Subscapular Skinfold (mm): ",SCA:DTIME G QT:'$T!(SCA["^"),A2:SCA=""
	I SCA'?.N.1".".N!(SCA<1)!(SCA>100) W !?5,"Enter value between 1 and 100; outside values should be assessed manually" G A1
A2	R !,"Arm Circumference (cm): ",ACIR:DTIME G QT:'$T!(ACIR["^"),A3:ACIR=""
	I ACIR'?.N.1".".N!(ACIR<5)!(ACIR>100) W !?5,"Enter number between 5 and 100; outside values should be assessed manually" G A2
A3	R !,"Calf Circumference (cm): ",CCIR:DTIME G QT:'$T!(CCIR["^"),A4:CCIR=""
	I CCIR'?.N.1".".N!(CCIR<10)!(CCIR>250) W !?5,"Enter value between 10 and 250; outside values should be assessed manually" G A3
A4	I ACIR,TSF S X1=ACIR-(TSF/10*3.1416),BFAMA=X1*X1/12.5664-$S(AGE<18:0,SEX="M":10,1:6.5),BFAMA=$J(BFAMA,0,1)
	Q
QT	S EXT="" Q
