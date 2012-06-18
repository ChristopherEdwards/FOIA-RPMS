SROAPCA ;B'HAM ISC/MAM - PRINT CLINICAL DATA ; [ 09/20/00  8:45 AM ]
 ;;3.0; Surgery ;**38,47,71,95**;24 Jun 93
 F I=0,206,207,208 S SRA(I)=$G(^SRF(SRTN,I))
 S X=$P(SRA(0),"^",9),SRADATE=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 W:$Y @IOF W !,?20,"VA CARDIAC SURGERY RISK ASSESSMENT PROGRAM",!!,"Patient: "_SRANM,?55,"Surgery Date: "_SRADATE
 S STATNUM=+$P($$SITE^SROVAR,"^",3)
 W !,"Assessment Number: "_SRTN,?55,"Hospital Number: "_STATNUM
 S SRAO(1)=SRADATE,NYUK=$P(SRA(0),"^",4),SRAO(2)=$P(VADM(5),"^",2)
 S SRAO(3)=AGE,NYUK=$P(SRA(206),"^") S:NYUK'="" NYUK=$S(NYUK["C":+NYUK_" cm",1:+NYUK_" in") S SRAO(4)=NYUK_"^236"
 S NYUK=$P(SRA(206),"^",2) S:NYUK'="" NYUK=$S(NYUK["K":+NYUK_" kg",1:+NYUK_" lb") S SRAO(5)=NYUK_"^237"
 S SRA(200)=$G(^SRF(SRTN,200)),NYUK=$P(SRA(200),"^",2),SRAO(6)=$S(NYUK="N":"NO",NYUK="O":"ORAL",NYUK="I":"INSULIN",1:"")_"^346",NYUK=$P(SRA(200),"^",11) D YN S SRAO(7)=SHEMP_"^203"
 S SRAO(8)=$P(SRA(206),"^",5)_"^347",NYUK=$P(SRA(206),"^",6) D YN S SRAO(9)=SHEMP_"^209",NYUK=$P(SRA(206),"^",7) D YN S SRAO(10)=SHEMP_"^348"
 S Y=$P(SRA(200),"^",3),C=$P(^DD(130,202,0),"^",2) D Y^DIQ S SRAO(11)=$E(Y,1,22)_"^202"
 S SRAO(12)=$P($G(^SRF(SRTN,201)),"^",4)_"^223",SRAO(13)=$P($G(^SRF(SRTN,201)),"^",20)_"^219"
 S NYUK=$P(SRA(206),"^",11) D YN S SRAO(14)=SHEMP_"^350",NYUK=$P(SRA(200),"^",8),SRAO(15)=$S(NYUK=1:"INDEPENDENT",NYUK=2:"PARTIAL DEPENDENT",NYUK=3:"TOTALLY DEPENDENT",NYUK="NS":"NS",1:"")_"^240"
 S NYUK=$P(SRA(206),"^",13),SRAO(16)=$S(NYUK=1:"NONE RECENT",NYUK=2:"  12-72 HRS",NYUK=3:"    <12 HRS",NYUK="NS":"NS",1:"")_"^351"
 S NYUK=$P(SRA(206),"^",14),SRAO(17)=$S(NYUK=0:"NONE",NYUK=1:"< OR = 7 DAYS",NYUK=2:"> 7 DAYS",NYUK="NS":"NS",1:"")_"^205"
 S NYUK=$P(SRA(206),"^",15) D YN S SRAO(18)=SHEMP_"^352",NYUK=$P(SRA(206),"^",16) D YN S SRAO(19)=SHEMP_"^265",NYUK=$P(SRA(206),"^",17) D YN S SRAO(20)=SHEMP_"^264"
 S SRAO(21)=$P(SRA(206),"^",18)_"^267",SRAO(22)=$P(SRA(206),"^",19)_"^207",NYUK=$P(SRA(206),"^",20) D YN S SRAO(23)=SHEMP_"^353",NYUK=$P(SRA(206),"^",21) D YN S SRAO(24)=SHEMP_"^354"
 S NYUK=$P(SRA(206),"^",22) D YN S SRAO(25)=SHEMP_"^355",NYUK=$P(SRA(206),"^",23) D YN S SRAO(26)=SHEMP_"^356"
 S NYUK=$P(SRA(206),"^",38) D YN S SRAO(27)=SHEMP_"^463",SRAO(28)=$P($G(^SRF(SRTN,201)),"^",8)_"^225"
 S NYUK=$P(SRA(206),"^",10) D YN S SRAO(29)=SHEMP_"^349",NYUK=$P(SRA(206),"^",41) D YN S SRAO(30)=SHEMP_"^472"
DISP ; display fields
 W !,"Cardiac Surgery Performed at Non-VA Facility (but funded by VA): ",$P(SRAO(30),"^")
 W !,"I. CLINICAL DATA"
 W !,"Gender:",?26,$P(SRAO(2),"^"),?40,"Resting ST Depression:",?75,$P(SRAO(14),"^")
 W !,"Age:",?26,SRAO(3),?40,"Functional Status: ",$J($P(SRAO(15),"^"),18)
 W !,"Height:",?26,$P(SRAO(4),"^"),?40,"PTCI: ",$J($P(SRAO(16),"^"),31)
 W !,"Weight:",?26,$P(SRAO(5),"^"),?40,"Prior MI:",$J($P(SRAO(17),"^"),28)
 W !,"Diabetes:",?26,$P(SRAO(6),"^"),?40,"Prior Heart Surgery:",?75,$P(SRAO(18),"^")
 W !,"COPD:",?26,$P(SRAO(7),"^"),?40,"Peripheral Vascular Disease:",?75,$P(SRAO(19),"^")
 W !,"FEV1:",?26,$P(SRAO(8),"^")_$S($P(SRAO(8),"^")="":"",$P(SRAO(8),"^")="NS":"",1:" liters"),?40,"Cerebral Vascular Disease:",?75,$P(SRAO(20),"^")
 W !,"Cardiomegaly (X-ray): ",?26,$P(SRAO(9),"^"),?40,"Angina (use CCS Class):",?75,$P(SRAO(21),"^")
 W !,"Pulmonary Rales:",?26,$P(SRAO(10),"^"),?40,"CHF (use NYHA Class):",?75,$P(SRAO(22),"^")
 W !,"Current Smoker: ",$J($P(SRAO(11),"^"),22),?40,"Current Diuretic Use:",?75,$P(SRAO(23),"^")
 W !,"Creatinine:",?26,$P(SRAO(12),"^")_$S($P(SRAO(12),"^")'="":" mg/dl",1:""),?40,"Current Digoxin Use:",?75,$P(SRAO(24),"^")
 W !,"Hemoglobin:",?26,$P(SRAO(13),"^")_$S($P(SRAO(13),"^")'="":"  g/dl",1:""),?40,"IV NTG 48 Hours Preceding Surgery:",?75,$P(SRAO(25),"^")
 W !,"Serum Albumin:",?26,$P(SRAO(28),"^")_$S($P(SRAO(28),"^")'="":"  g/dl",1:""),?40,"Preop Use of IABP:",?75,$P(SRAO(26),"^")
 W !,"Active Endocarditis:",?26,$P(SRAO(29),"^"),?40,"Hypertension:",?75,$P(SRAO(27),"^")
 K SRA,SRAO D ^SROAPCA1
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
PAGE I $E(IOST)'="P" W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 W @IOF,!,SRANM,! F MOE=1:1:80 W "-"
 Q
