FHASM5	; HISC/REL - Energy/Calorie Factors ;3/20/95  08:18
	;;5.0;Dietetics;;Oct 11, 1995
	I AGE<19 G PED
	S CB="Energy" D GETW G HARRIS:CB=3,KIL^FHASM1:CB=0 W !!,"Calculate Energy Needs by:  "
	W !!?6,"1  Harris-Benedict",!?6,"2  Kcal/Kg",!?6,"3  Enter Manually"
E2	R !!,"Choose:  ",CM:DTIME G:'$T!(CM["^") KIL^FHASM1 I "123"'[CM!(CM'?1N) W !,*7,"Choose Either 1, 2, or 3" G E2
	G HARRIS:CM=1,KCAL:CM=2,MAN
MAN	; Manual Entry
M1	R !!,"Enter Energy Requirements (Kcal/day):  ",KCAL:DTIME G:'$T!(KCAL["^") KIL^FHASM1
	S KCAL=+$J(KCAL,0,0) I KCAL'>0 W *7,!,"KCAL must be greater than 0" G M1
	G NEXT
PED	; Pediatric
	I AGE<11 S KCAL=$S(AGE<.6:115,AGE<1:105,AGE<4:100,AGE<7:85,1:86) G P1
	I SEX="M" S KCAL=$S(AGE<15:60,1:42) G P1
	S KCAL=$S(AGE<15:48,1:38)
P1	S KCAL=+$J(KCAL*WGT/2.2,0,0) G P5
HARRIS	; Harris Method
	I SEX="F" S KCAL=(655.10+(9.56*W2)+(1.85*HGT*2.54)-(4.68*AGE))
	I SEX="M" S KCAL=(66.47+(13.75*W2)+(5.0*HGT*2.54)-(6.67*AGE))
	S KCAL=$J(KCAL,0,0)
H1	R !!,"Is patient confined to bed (Y/N)? ",AF:DTIME G:'$T!(AF["^") KIL^FHASM1 S:AF="" AF="^" S X=AF D TR^FHASM1 S AF=X I $P("YES",AF,1)'="",$P("NO",AF,1)'="" W *7,!,"  Answer YES or NO" G H1
	S AF=$S(AF?1"Y".E:1.2,1:1.3) W "  (Activity Factor = ",AF,")"
	W !!?27,"Injury/Stress Factors",!
	W !,"Surgery",?25,"1.1 - 1.3",?40,"Skeletal Trauma",?65,"1.35",!,"Major Sepsis",?25,"1.6",?40,"Severe Burn",?65,"2.1"
	W !,"Blunt Trauma",?25,"1.35",?40,"Trauma w/ Steroid",?65,"1.68",!,"Starvation",?25,".7",?40,"Trauma on Ventilator",?65,"1.6"
	W !,"Mild Infection",?25,"1.2",?40,"0-20% BSA Burn",?65,"1.25",!,"Moderate Infection",?25,"1.4",?40,"20-40% BSA Burn",?65,"1.5"
	W !,"Long Bone Fracture",?25,"1.6",?40,">40% BSA Burn",?65,"1.85",!,"Peritonitis",?25,"1.15"
	W !,"Stress - Low",?25,"1.3",?40,"Anabolism",?65,"1.5-1.75"
	W !,"       - Moderate",?25,"1.5",?40,"Cancer",?65,"1.6"
	W !,"       - Severe",?25,"2.0"
	W !!,"BEE = ",KCAL," Kcal/day"
H2	R !!,"Select Energy Factor:  ",EF:DTIME G:'$T!(EF["^") KIL^FHASM1 I EF<.7!(EF>2.5) W !,*7,"Energy Factor must be Between .7 and 2.5" G H2
	S KCAL=+$J(KCAL*AF*EF,0,0) G P5
KCAL	; KCAL Method
	W !!?35,"Caloric Factors"
	W !!,"Basal Energy",?30,"25",!,"Ambulatory w/ Weight Maint.",?30,"30"
	W !,"Malnutrition w/ Mild Sepsis",?30,"40",!,"Injuries/ Sepsis - Severe",?30,"50"
	W !,"Burn - Extensive",?30,"80",!,"Non-Dialysis Renal Failure",?30,"35"
	W !,"Dialysis",?30,"40",!,"Dialysis w/ Diabetes",?30,"30",!,"Anabolism",?30,"35-45"
P4	R !!,"Enter Kcal/Kg (10-100):  ",KCAL:DTIME G:'$T!(KCAL["^") KIL^FHASM1 I KCAL'?1.3N!(KCAL<10)!(KCAL>100) W !,*7,"Kcal/Kg Must be Between 10 and 100" G P4
	S KCAL=+$J(KCAL*W2,0,0)
P5	W !!,"Enter Caloric Requirements (Kcal/day): ",KCAL," // " R X:DTIME I '$T!(X["^") G KIL^FHASM1
	I X'="",X'?.N.1".".N!(X<1)!(X>10000) W *7,!?5,"Enter a value between 1-10000" G P5
	I X'="",X'=KCAL S KCAL=+$J(X,0,0)
NEXT	G ^FHASM6
GETW	W !!,"Calculate ",CB," Requirements Based On:" S CM="12"
	W !!?2,"1  Actual Body Weight",!?2,"2  Ideal Body Weight"
	I WGT/IBW'<1.2 W !?2,"3  Obese Calculation" S CM="123"
E1	R !!,"Choose:  ",CB:DTIME I '$T!(CB["^") S CB=0 Q
	I CM'[CB!(CB'?1N) W !,*7,"Choose either 1 or 2" W:CM["3" " or 3" G E1
	S W2=$S(CB=2:IBW,CB=3:WGT-IBW*.25+IBW,1:WGT)/2.2 S:CB=3 CM=1 Q
