FHASM6	; HISC/REL - Protein/Fluid Requirements ;10/30/90  13:42
	;;5.0;Dietetics;;Oct 11, 1995
H2O	W !!,"Calculate Fluid Requirements By:"
	W !!?5,"1)  Adult (35 ml/kg/day)",!?9,"Adolescent (40-60 ml/kg/day)",!?9,"Children (70-110 ml/kg/day)",!?9,"Infant (100-150 ml/kg/day)"
	W !?5,"2)  100 ml/kg first 10 kg +",!?9,"50 ml/kg second 10 kg +",!?9,"25 ml/kg remaining kg"
	W !?5,"3)  1 ml/Kcal",!?5,"4)  0.5 ml/Kcal  (Fluid Overload)"
	W !?5,"5)  1500 ml/sq meter"
	W !?5,"6)  Set Your Own Fluid Level",!?5,"7)  Omit Calculation"
H0	R !!,"Choose: ",H2O:DTIME G:'$T!(H2O["^") KIL^FHASM1 I "1234567"'[H2O!(H2O'?1N) W !,"Choose 1 - 7 Only" G H0
	I "125"[H2O S CB="Fluid" D GETW^FHASM5 G:CB=0 KIL^FHASM1
	G H1:H2O=1,H2:H2O=2,H3:H2O=3,H4:H2O=4,H5:H2O=5,H6:H2O=6 S FLD="" G PRO
H1	I AGE>18 S FLD=35 G H12
	I AGE>10 S A1=40,A2=60 G H11
	I AGE'<1 S A1=70,A2=110 G H11
	S A1=100,A2=150
H11	W !!,"Select Level Between ",A1," and ",A2," ml/kg/day: " R FLD:DTIME G:'$T!(FLD["^") KIL^FHASM1
	I FLD<A1!(FLD>A2) W *7,!,"Fluid Level is not within range." G H11
H12	S FLD=W2*FLD G H7
H2	S W1=W2,FLD=$S(W1<10:W1*100,W1<20:W1-10*50+1000,1:W1-20*25+1500) G H7
H3	S FLD=KCAL G H7
H4	S FLD=.5*KCAL G H7
H5	S X=W2,X1=.425 D PWR S FLD=Y,X=HGT*2.54,X1=.725 D PWR S FLD=FLD*Y*.007184*1500 G H7
H6	R !!,"Enter Fluid Requirements (ml/day): ",FLD:DTIME G:'$T!(FLD["^") KIL^FHASM1
	I FLD'?1N.N!(FLD<0)!(FLD>10000) W *7,!,"Level must be between 0-10000 ml/day" G H6
	S FLD=+$J(FLD,0,0) G PRO
H7	S FLD=+$J(FLD,0,0)
H8	W !!,"Select Fluid Requirements (ml/day): ",FLD," // " R X:DTIME I '$T!(X["^") G KIL^FHASM1
	I X'="",X'?1N.N!(X<0)!(X>10000) W *7,!,"Level must be between 0-10000 ml/day" G H8
	I X'="",X'=FLD S FLD=+$J(X,0,0),H2O=6
PRO	S CB="Protein" D GETW^FHASM5 G:CB=0 KIL^FHASM1 W !!?11,"Protein Requirements (g/kg)",!?16,"(Examples)"
	W !!,"Acute Burn, Injury,  Trauma",?35,"2-4",!,"Convalescent Burn, Injury Trauma",?35,"2"
	W !,"Malabsorption Syndrome",?35,"1",!,"Ulcerative Colitis",?35,"1-1.4"
	W !,"Ileocolostomy",?35,"1-1.4",!,"Chronic Liver Disease",?35,"1-1.5"
	W !,"Acute Encephalopathy",?35,"0.5",!,"Chronic Renal Failure",?35,"0.6"
	W !,"Nephrotic Syndrome",?35,"1-1.4"
	W !,"Burn",?35,"1.4",!,"Protein-Sparing",?35,"1.5"
	W !,"Anabolism",?35,"1.2-1.5"
	S P1=$S(AGE>18:.8,AGE>14:.84,AGE>10:1,AGE>6:1.2,AGE>3:1.5,AGE>1:1.8,AGE>.5:2,1:2.2)
P6	W !!,"Enter Protein Level (g/kg) ",P1," // " R PRO:DTIME S:PRO="" PRO=P1 G:'$T!(PRO["^") KIL^FHASM1
	I PRO'?.1N.1".".2N!(PRO<.4)!(PRO>4) W *7,"  Level must be .4 to 4.0" G P6
	S PRO=+$J(PRO*W2,0,0)
P7	W !!,"Enter Protein Requirements (gm/day): ",PRO," // " R X:DTIME I '$T!(X["^") G KIL^FHASM1
	I X'="",X'>0!(X>400) W *7," Enter a value greater than 0 but not more than 400." G P7
	I X'="",X'=PRO S PRO=+$J(X,0,0)
	I KCAL W "  ",$J(PRO*400/KCAL,0,0)," % of KCAL"
NEXT	G ^FHASM7
	;
PWR	; Raise X to X1 power - Output in Y
	I X'>0 S Y=0 Q
	S X2=1 I X>0 F X3=0:1 Q:(X/X2)<10  S X2=X2*10
	I X<1 F X3=0:-1 Q:(X/X2)>.1  S X2=X2*.1
	S X=X/X2
	S X=(X-1)/(X+1),(Y,X5)=X F X4=3:2 S X5=X5*X*X,X2=X5/X4,Y=X2+Y S:X2<0 X2=-X2 Q:X2<.000001
	S Y=Y*2+(X3*2.302585),X=Y*X1
	S (Y,X5)=X,Y=Y+1 F X4=2:1 S X5=X5*X/X4,Y=Y+X5 Q:X5<.000001
	S Y=+$J(Y,0,5) K X2,X3,X4,X5 Q
