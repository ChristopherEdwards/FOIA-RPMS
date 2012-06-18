FHASMR1 ; HISC/REL/NCA/JH - Assessment Report (cont) ;5/17/96  12:48
 ;;5.0;Dietetics;**4,11**;Oct 11, 1995
EN ; Print Report
 D NOW^%DTC S NOW=% K % S ANS=""
 S LN="",$P(LN,"-",80)="",PG=0,S1=$S(IOST?1"C".E:IOSL-2,1:IOSL-6) D HEAD
 W !!,NAM,?40,$S(SEX="M":"Male",1:"Female"),?60,"Age ",AGE
 S DTP=ADT D DTP^FH W !!?25,"Date of Assessment: ",$E(DTP,1,9)
EN1 S X1=$S(HGT\12:HGT\12_"'",1:"")_$S(HGT#12:" "_(HGT#12)_"""",1:""),X2=+$J(HGT*2.54,0,0)_" cm"
 W !!,"Height:       ",$S(FHU'="M":X1,1:X2)," (",$S(FHU'="M":X2,1:X1),")" W:HGP'="" " ",$S(HGP="K":"knee hgt",HGP="S":"stated",1:"")
 S X1=WGT_" lbs",X2=+$J(WGT/2.2,0,1)_" kg"
 W !,"Weight:       ",$S(FHU'="M":X1,1:X2)," (",$S(FHU'="M":X2,1:X1),")" W:WGP'="" " ",$S(WGP="A":"anthro",WGP="S":"stated",1:"") S DTP=DWGT D DTP^FH W ?50,"Weight Taken:    ",DTP
 I UWGT S X1=UWGT_" lbs",X2=+$J(UWGT/2.2,0,1)_" kg"
 W !,"Usual Weight: " W:UWGT $S(FHU'="M":X1,1:X2)," (",$S(FHU'="M":X2,1:X1),")" W ?50,"Weight/Usual Wt:  " W:UWGT $J(WGT/UWGT*100,3,0),"%"
 S X1=IBW_" lbs",X2=+$J(IBW/2.2,0,1)_" kg"
 W !,"Ideal Weight: ",$S(FHU'="M":X1,1:X2)," (",$S(FHU'="M":X2,1:X1),")" W ?50,"Weight/IBW:       " W:IBW $J(WGT/IBW*100,3,0),"%"
 I AMP W !?6,"Ideal weight adjusted for amputation"
 W !,"Frame Size:   ",$S(FRM="S":"Small",FRM="M":"Medium",FRM="L":"Large",1:"")
 W ?50,"Body Mass Index:  ",BMI W:BMIP'="" " (",BMIP,"%)"
 D:$Y'<(S1-3) HF Q:ANS="^"  G:EXT'="Y" Q4 W !!?26,"Anthropometric Measurements",!?35,"%ile",?71,"%ile",!
 W !?4,"Triceps Skinfold (mm)" I TSF W ?31,$J(+TSF,3,0),?36,$J(TSFP,3)
 W ?43,"Arm Circumference (cm)" I ACIR W ?67,$J(+ACIR,3,0),?72,$J(ACIRP,3)
 W !?4,"Subscapular Skinfold (mm)" I SCA W ?31,$J(+SCA,3,0),?36,$J(SCAP,3)
 W ?43,"Bone-free AMA (cm2)" I BFAMA W ?67,$J(+BFAMA,3,0),?72,$J(BFAMAP,3)
 W !?4,"Calf Circumference (cm)" I CCIR W ?31,$J(+CCIR,3,0),?36,$J(CCIRP,3)
Q4 W !!?32,"Laboratory Data",!?5,"Test",?30,"Result    units",?51,"Ref.   range",?67,"Date"
 S N1=0 F K=0:0 S K=$O(LRTST(K)) Q:K=""  D LAB
 I 'N1 W !!?5,"No laboratory data available last ",$S($D(^FH(119.9,1,3)):$P(^(3),"^",2),1:90)," days"
 S N=PRO/6.25 I $Y'<(S1-4) D HF Q:ANS="^"
 W !!,"Energy Requirements:  ",KCAL," Kcal/day" W:N ?50,"Kcal:N  ",$J(KCAL/N,0,0),":1" W:NB'="" ?67,"N-Bal: ",NB
 W !,"Protein Requirements: ",PRO," gm/day" W:N ?50,"NPC:N   ",$J(KCAL-(PRO*4)/N,0,0),":1"
 I FLD'="" W !,"Fluid Requirements:   ",FLD," ml/day"
 G:'PRT Q6
 D:$Y'<(S1-4) HF Q:ANS="^"  W:APP'="" !!,"Appearance: ",?20,APP
 I XD W !,"Nutrition Class: " W ?20,$P($G(^FH(115.3,XD,0)),"^",1)
 I RC W !,"Nutrition Status: " W ?20,$P($G(^FH(115.4,RC,0)),"^",2)
 D:$Y'<(S1-4) HF Q:ANS="^"  W !!,"Comments",!
 I ASN F K=0:0 S K=$O(^FHPT(DFN,"N",ASN,"X",K)) Q:K<1  D:$Y'<S1 HF Q:ANS="^"  W !,^FHPT(DFN,"N",ASN,"X",K,0)
 S SIGN=$P(^FHPT(DFN,"N",ASN,0),U,23) W:SIGN'="" !!,"Entered by: ",$P($P(^VA(200,SIGN,0),U),",",2)," ",$P($P(^VA(200,SIGN,0),U),",")
 G:$E(IOST)="C" Q6 F KK=1:1:IOSL-$Y-7 W !
 S $P(UL,"-",39)="" W !?38,UL W !?38,"Signature",?68,"Date"
Q6 D FOOT Q
LAB S X1=$P(LRTST(K),"^",7) Q:X1=""  S DTP=X1\1 D DTP^FH W:'N1 ! S N1=N1+1
 I $Y'<S1 D HF Q:ANS="^"
 W !?5,$P(LRTST(K),"^",1),?27,$P(LRTST(K),"^",6),?40,$P(LRTST(K),"^",4),?51,$P(LRTST(K),"^",5),?65,DTP Q
HF ; Do Header and Footer
 D FOOT Q:ANS="^"  D HEAD
 Q
HEAD ; Page Header
 I IOST?1"C".E W @IOF Q
 W:PG @IOF S PG=PG+1,DTP=DT D DTP^FH
 W !,LN,!,DTP,?29,"NUTRITION ASSESSMENT",?73,"Page ",PG,!,LN Q
FOOT ; Page Footer
 D PAUSE Q:IOST?1"C-".E
 F KK=1:1:IOSL-$Y-5 W !
 D SITE^FH W !,LN,!,NAM W ?(80-$L(SITE)\2),SITE,?67,"VAF 10-9034"
 W ! W:PID'="" PID
 S W1=$G(^DPT(DFN,.1)) S:$D(^DPT(DFN,.101)) W1=W1_"/"_^DPT(DFN,.101) W:W1'="" ?(80-$L(W1)\2),W1,?66,"(Vice SF 509)"
 W !,LN,! Q
PAUSE ; Pause to Scroll
 I IOST?1"C".E R !!,"Press RETURN to continue. ",YN:DTIME S:'$T!(YN["^") ANS="^" Q:ANS="^"  I "^"'[YN W !,"Enter a RETURN to Continue." G PAUSE
 Q
