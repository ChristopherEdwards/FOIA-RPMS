SROACL1 ;B'HAM ISC/MAM - CARDIAC PREOP CLINICAL DATA ; [ 08/15/00  08:19 AM ]
 ;;3.0; Surgery ;**38,71,95**;24 Jun 93
 D CREAT^SROAL1 F I=0,200,202,205,206,206.1,208 S SRA(I)=$G(^SRF(SRTN,I))
 S NYUK=$P(SRA(206),"^") S:NYUK'="" NYUK=$S(NYUK["C":+NYUK_" cm",1:+NYUK_" in") S SRAO(1)=NYUK_"^236"
 S NYUK=$P(SRA(206),"^",2) S:NYUK'="" NYUK=$S(NYUK["K":+NYUK_" kg",1:+NYUK_" lb") S SRAO(2)=NYUK_"^237"
 K SRA(0) S NYUK=$P(SRA(200),"^",2),SRAO(3)=$S(NYUK="N":"NO",NYUK="O":"ORAL",NYUK="I":"INSULIN",1:"")_"^346",NYUK=$P(SRA(200),"^",11) D YN S SRAO(4)=SHEMP_"^203"
 S SRAO(5)=$P(SRA(206),"^",5)_"^347",NYUK=$P(SRA(206),"^",6) D YN S SRAO(6)=SHEMP_"^209",NYUK=$P(SRA(206),"^",7) D YN S SRAO(7)=SHEMP_"^348"
 ; current smoker, creatinine, hemoglobin, serum albumin
 S Y=$P(SRA(200),"^",3),C=$P(^DD(130,202,0),"^",2) D Y^DIQ S SRAO(8)=$E(Y,1,19)_"^202"
 S SRAO(9)=$P($G(^SRF(SRTN,201)),"^",4)_"^223",SRAO(10)=$P($G(^SRF(SRTN,201)),"^",20)_"^219",SRAO(11)=$P($G(^SRF(SRTN,201)),"^",8)_"^225"
 S NYUK=$P(SRA(206),"^",10) D YN S SRAO(12)=SHEMP_"^349"
 S NYUK=$P(SRA(206),"^",11) D YN S SRAO(13)=SHEMP_"^350",NYUK=$P(SRA(200),"^",8),SRAO(14)=$S(NYUK=1:"INDEPENDENT",NYUK=2:"PARTIAL DEPENDENT",NYUK=3:"TOTALLY DEPENDENT",NYUK="NS":"NO STUDY",1:"")_"^240"
 S NYUK=$P(SRA(206),"^",13),SRAO(15)=$S(NYUK=1:"NONE RECENT",NYUK=2:"  12-72 HRS",NYUK=3:"    <12 HRS",NYUK="NS":"NO STUDY",1:"")_"^351"
 S NYUK=$P(SRA(206),"^",14),SRAO(16)=$S(NYUK=0:"NONE",NYUK=1:"< OR = 7 DAYS",NYUK=2:"> 7 DAYS",1:"")_"^205"
 S NYUK=$P(SRA(206),"^",15) D YN S SRAO(17)=SHEMP_"^352",NYUK=$P(SRA(206),"^",16) D YN S SRAO(18)=SHEMP_"^265",NYUK=$P(SRA(206),"^",17) D YN S SRAO(19)=SHEMP_"^264"
 S SRAO(20)=$P(SRA(206),"^",18)_"^267",SRAO(21)=$P(SRA(206),"^",19)_"^207",NYUK=$P(SRA(206),"^",20) D YN S SRAO(22)=SHEMP_"^353",NYUK=$P(SRA(206),"^",21) D YN S SRAO(23)=SHEMP_"^354"
 S NYUK=$P(SRA(206),"^",22) D YN S SRAO(24)=SHEMP_"^355",NYUK=$P(SRA(206),"^",23) D YN S SRAO(25)=SHEMP_"^356"
 S NYUK=$P(SRA(206),"^",38) D YN S SRAO(26)=SHEMP_"^463"
DISP ; display fields
 S SRPAGE="PAGE: 1" D HDR^SROAUTL
 W !," 1. Height:",?27,$P(SRAO(1),"^"),?40,"14. Functional Status: ",$J($P(SRAO(14),"^"),17)
 W !," 2. Weight:",?27,$P(SRAO(2),"^"),?40,"15. PTCA: ",$J($P(SRAO(15),"^"),30)
 W !," 3. Diabetes:",?27,$P(SRAO(3),"^"),?40,"16. Prior MI: ",$J($P(SRAO(16),"^"),26)
 W !," 4. COPD:",?27,$P(SRAO(4),"^"),?40,"17. Prior Heart Surgery: ",?75,$P(SRAO(17),"^")
 W !," 5. FEV1:",?27,$P(SRAO(5),"^")_$S($P(SRAO(5),"^")="":"",$P(SRAO(5),"^")="NS":"",1:" liters"),?40,"18. Peripheral Vascular Disease:",?75,$P(SRAO(18),"^")
 W !," 6. Cardiomegaly (X-ray):",?27,$P(SRAO(6),"^"),?40,"19. Cerebral Vascular Disease:",?75,$P(SRAO(19),"^")
 W !," 7. Pulmonary Rales:",?27,$P(SRAO(7),"^"),?40,"20. Angina (use CCS Class):",?75,$P(SRAO(20),"^")
 W !," 8. Current Smoker: ",$J($P(SRAO(8),"^"),19),?40,"21. CHF (use NYHA Class):",?75,$P(SRAO(21),"^")
 W !," 9. Creatinine:",?20,$P(SRAO(9),"^")_$S($P(SRAO(9),"^")'="":" mg/dl",1:""),?40,"22. Current Diuretic Use:",?75,$P(SRAO(22),"^")
 W !,"10. Hemoglobin:",?20,$P(SRAO(10),"^")_$S($P(SRAO(10),"^")'="":"  g/dl",1:""),?40,"23. Current Digoxin Use:",?75,$P(SRAO(23),"^")
 W !,"11. Serum Albumin:",?20,$P(SRAO(11),"^")_$S($P(SRAO(11),"^")'="":"  g/dl",1:""),?40,"24. IV NTG within 48 Hours:",?75,$P(SRAO(24),"^")
 W !,"12. Active Endocarditis:",?27,$P(SRAO(12),"^"),?40,"25. Preop Use of IABP:",?75,$P(SRAO(25),"^")
 W !,"13. Resting ST Depression:",?27,$P(SRAO(13),"^"),?40,"26. Hypertension (Y/N):",?75,$P(SRAO(26),"^")
 W !! F MOE=1:1:80 W "-"
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
