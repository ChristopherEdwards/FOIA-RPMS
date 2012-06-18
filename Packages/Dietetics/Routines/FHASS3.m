FHASS3 ; GLRISC/REL - Print Assessment Report ; 8-Feb-86  9:08 pm [ 06/18/90  11:19 AM ]
 ;;3.16;NUTRITION & DIETETICS;;*;;1NOV90
 W @IOF,@FHZRVN,!?14,"N U T R I T I O N A L   A S S E S S M E N T",?78,@FHZRVF S X="T" D ^%DT S DT=+Y,DTP=DT\1 D DTP^FH  ;IHS/ANMC/LJF 9/25/89 added reverse video
 W !!,NAM,?32,$S(SEX="F":"Female",1:"Male"),?45,"Age ",AGE,?63,DTP
 W !!,"Weight: ",$J(WGT,3)," lbs.",?20,"%IBW:   ",$J(WGT*100/IBW,3,0),?35,"Ideal Wgt: ",$J(IBW,3)," lbs.",?57,"Frame: ",$S(FRM="S":"Small",FRM="M":"Medium",1:"Large")
 W !,"Height: ",$J(HGT,3)," in.",?20,"%Usual: ",$J(WGT*100/UWGT,3,0),?35,"Usual Wgt: ",$J(UWGT,3)," lbs.",?57,"BEE:   ",BEE G:'AMP P1
 W !!,"** IBW Adjusted for Amputation (",$J(AMP*100,0,1),"% of IBW) **"
P1 I TYP'="Y" W !!,"Activity Level: ",$S(ACT="S":"Sedentary",ACT="M":"Moderate",1:"High")
 W !!,"Estimated Energy Needs: ",$J(KCAL,6,0)," Kcal." W:RTE " (For ",RTE," lb/wk ",$S(OPT="G":"gain",1:"loss"),")"
 W !!,"Estimated Protein Needs: ",$J(PRO,5,1)," gm. (",$J(NIT,0,1)," gm. Nitrogen)" G:EXT'="Y" P2
 F J=1,2,4,5,6,9 I Y(J)'="" S Y(J)=$P("Normal,Mild,Moderate,Severe",",",Y(J))_$S(Y(J)'=1:" Depletion",1:"")
 W ! I X(1) W !,"Albumin",?25,$J(X(1),7,1)," g/dl",?45,Y(1)
 I X(10) W !,"Pre-albumin",?25,$J(X(10),7,1)," mg/dl",?45,$S(X(10)<10:"Ina",1:"A"),"dequate Protein Synthesis"
 I X(2) W !,"Total Lymphocyte Count",?25,$J(X(2),7,1)," /cmm",?45,Y(2)
 I X(4) W !,"Transferrin",?25,$J(X(4),7,1)," mg/dl",?45,Y(4)
 W ! I X(5) W !,"Triceps Skin Fold",?25,$J(X(5),7,1)," mm",?45,Y(5)
 I X(6) W !,"Arm Circumference",?25,$J(X(6),7,1)," cm",?45,Y(6)
 I X(9) W !,"Muscle Circumference",?25,$J(X(9),7,1)," cm",?45,Y(9)
 W ! I Y(7) W !,"Nitrogen Balance",?25,$J(Y(7),7,1)
 G:'X(11) P2 S X(11)=(140-AGE)*WGT/158.4/X(11)*$S(SEX="F":.85,1:1)
 W !,"Creatinine Clearance",?25,$J(X(11),7,0)," ml/min",?45,$S(X(11)<80:"Abn",1:"N"),"ormal"
P2 W !!,?11,"*****Confidential Patient Data Covered by Privacy Act***",! Q  ;IHS/ANMC/LJF 6/6/90 added line
