FHASM2	; HISC/REL - Assessment (cont) ;5/14/93  10:03
	;;5.0;Dietetics;;Oct 11, 1995
FRM	; Calculate Frame Size
	R !!,"Wrist Circumference (cm): ",X:DTIME G KIL^FHASM1:'$T!(X["^"),F1:X=""
	I X'?1.2N.1".".N!(X<2)!(X>50) W *7,!,"Value should be between 2 and 50cm.; press RETURN to bypass." G FRM
	S WCIR=+X,RAT=HGT*2.54/WCIR
	I SEX="F" S FRM=$S(RAT>11.0:"S",RAT<10.1:"L",1:"M")
	I SEX="M" S FRM=$S(RAT>10.4:"S",RAT<9.6:"L",1:"M")
	W "   ",$S(FRM="S":"Small",FRM="M":"Medium",1:"Large")," Frame" G IBW
F1	R !!,"Frame Size (SMALL,MEDIUM,LARGE) MED// ",FRM:DTIME G:'$T!(FRM["^") KIL^FHASM1 S:FRM="" FRM="M" S X=FRM D TR^FHASM1 S FRM=X
	I $P("SMALL",FRM,1)'="",$P("MEDIUM",FRM,1)'="",$P("LARGE",FRM,1)'="" W *7,"  Enter S, M or L" G F1
	S FRM=$E(FRM,1)
IBW	; Ideal Body Weight
	W !!,"Calculation of Ideal Body Weight",! S METH=""
	I H1'<60 W !?10,"H   Hamwi" S METH=METH_"H"
	I SEX="M",(H1<76),(H1>60),(AGE'<19) W !?10,"M   Metropolitan 83" W !?10,"S   Spinal Cord Injury" S METH=METH_"MS"
	I SEX="F",(H1<73),(H1>57),(AGE'<19) W !?10,"M   Metropolitan 83" W !?10,"S   Spinal Cord Injury" S METH=METH_"MS"
	I SEX="M",(H1<74),(H1>60),(AGE>64) W !?10,"G   Geriatric" S METH=METH_"G"
	I SEX="F",(H1<70),(H1>57),(AGE>64) W !?10,"G   Geriatric" S METH=METH_"G"
	I AGE<10 W !?10,"P   Pediatric" S METH=METH_"P"
	W !?10,"E   Enter Manually" S METH=METH_"E"
SEL	R !!,"Method: ",X:DTIME I '$T!(X["^") G KIL^FHASM1
	D TR^FHASM1
	I METH'[$E(X,1)!(X="") W *7,!,"   You Must Choose from the List Above" G SEL
	S METH=$E(X,1) D E:METH="E",H^FHASM2D:METH="H",^FHASM2A:METH="M",^FHASM2A:METH="S",^FHASM2B:METH="G",^FHASM2C:METH="P" I IBW'>0 G KIL^FHASM1:IBW="^",IBW
AMP	R !!,"Does Patient have an Amputation? NO// ",AMP:DTIME G:'$T!(AMP["^") KIL^FHASM1 S:AMP="" AMP="N" S X=AMP D TR^FHASM1 S AMP=X I $P("YES",AMP,1)'="",$P("NO",AMP,1)'="" W *7," Answer YES or NO" G AMP
	S AMP=$E(AMP,1),AMP=AMP="Y" G:'AMP A5
A1	W !!,"Amputee Types: (may be multiple, e.g: 2,2,5)"
	W !!?5,"1 Hand              (0.7%)",?36,"2 Total Leg        (16.1%)",!?5,"3 Total Arm         (4.9%)",?36,"4 Foot              (1.5%)"
	W !?5,"5 Forearm and Hand  (2.3%)",?36,"6 Calf and Foot     (5.8%)"
A2	S AMP=0 R !!?2,"Amputee Types: ",X:DTIME G:'$T!(X["^") KIL^FHASM1
	F K=1:1 S Y=$P(X,",",K) Q:Y=""  G:Y'?1N!(Y<1)!(Y>6) A6 S AMP=AMP+$P(".7,16.1,4.9,1.5,2.3,5.8",",",Y)
A3	W !!,"Total Amputee %: ",AMP," // " R X:DTIME S:X="" X=AMP G:'$T!(X["^") KIL^FHASM1
	I X<.5!(X>50) W *7,!,"Total % of amputations should be .5% to 50%" G A3
	S AMP=+$J(X,0,1),IBW=100-AMP*IBW/100,IBW=+$J(IBW,0,0)
A4	S X1=$S(FHU'="M":IBW_"#",1:+$J(IBW/2.2,0,1)_"kg")
	W !!,"Select IBW after Amputee Correction: ",X1," // " R X:DTIME I '$T!(X["^") G KIL^FHASM1
	I X=""!(X=+X1) G A5
	D WGT^FHASM1 I Y<1 D WGP^FHASM1 G A4
	S IBW=+Y
A5	S IBW=+$J(IBW,0,0) G ^FHASM3
A6	W *7,!!?5,"Enter a string of types (e.g: 1,1,4); no digit can exceed 6." G A2
E	; Manual Entry of Ideal Weight
	R !!,"Enter Ideal Body Weight: ",X:DTIME S:X="" X="?" I '$T!(X["^") S IBW="^" Q
	D WGT^FHASM1 I Y<1 D WGP^FHASM1 G E
	S IBW=+Y Q
