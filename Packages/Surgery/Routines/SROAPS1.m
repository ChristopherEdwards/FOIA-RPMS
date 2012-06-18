SROAPS1 ;B'HAM ISC/MAM - PREOP INFO (PAGE 1) ; 25 MAR 1992 9:55 am
 ;;3.0; Surgery ;**38,47**;24 Jun 93
 S SRA(200)=$G(^SRF(SRTN,200))
 S NYUK=$P(SRA(200),"^") D YN S SRAO(1)=SHEMP_"^402"
 S X=$P(SRA(200),"^",2),X=$S(X="N":"NO",X="O":"ORAL",X="I":"INSULIN",X="NS":"NO STUDY",1:""),SRAO("1A")=X_"^346"
 S NYUK=$P(SRA(200),"^",3) D YN S SRAO("1B")=SHEMP_"^202",NYUK=$P(SRA(200),"^",4) D YN S SRAO("1D")=SHEMP_"^246"
 S X=$P(SRA(200),"^",6),X=$S(X=1:"                  NO",X=2:"         MINIMAL EXERTION",X=3:"               AT REST",X="NS":"                  NS",1:""),SRAO("1E")=X_"^325"
 S NYUK=$P(SRA(200),"^",7) D YN S SRAO("1F")=SHEMP_"^238",X=$P(SRA(200),"^",8),X=$S(X=1:"  INDEPENDENT",X=2:"PARTIAL DEPENDENT",X=3:"TOTAL DEPENDENT",1:""),SRAO("1G")=X_"^240"
 S NYUK=$P(SRA(200),"^",9) D YN S SRAO(2)=SHEMP_"^241",NYUK=$P(SRA(200),"^",10) D YN S SRAO("2A")=SHEMP_"^204",NYUK=$P(SRA(200),"^",11) D YN S SRAO("2B")=SHEMP_"^203"
 S NYUK=$P(SRA(200),"^",12) D YN S SRAO("2C")=SHEMP_"^326"
 S NYUK=$P(SRA(200),"^",13) D YN S SRAO(3)=SHEMP_"^244",NYUK=$P(SRA(200),"^",15) D YN S SRAO("3A")=SHEMP_"^212"
 S NYUK=$P(SRA(200),"^",30) D YN S SRAO(4)=SHEMP_"^242",NYUK=$P(SRA(200),"^",35) D YN S SRAO("4A")=SHEMP_"^396"
 S NYUK=$P(SRA(200),"^",37) D YN S SRAO(5)=SHEMP_"^243",NYUK=$P(SRA(200),"^",38) D YN S SRAO("5A")=SHEMP_"^328",NYUK=$P(SRA(200),"^",39) D YN S SRAO("5B")=SHEMP_"^211"
 S X=$P($G(^SRF(SRTN,208)),"^",9),SRAO("1C")=X_"^202.1"
 S SRPAGE="PAGE: 1 OF 2" D HDR^SROAUTL
 W !,"1. GENERAL:",?33,$P(SRAO(1),"^"),?43,"3. HEPATOBILIARY:",?76,$P(SRAO(3),"^")
 W !,"   A. Diabetes Mellitus:",?33,$P(SRAO("1A"),"^"),?43,"   A. Ascites:",?76,$P(SRAO("3A"),"^")
 W !,"   B. Current Smoker W/I 1 Year:",?33,$P(SRAO("1B"),"^") W !,"   C. Pack/Years:",?33,$P(SRAO("1C"),"^")
 W !,"   D. ETOH > 2 Drinks/Day:",?33,$P(SRAO("1D"),"^"),?43,"4. CARDIAC:",?76,$P(SRAO(4),"^")
 W !,"   E. Dyspnea: ",$P(SRAO("1E"),"^"),?43,"   A. CHF Within 1 Month:",?76,$P(SRAO("4A"),"^")
 W !,"   F. DNR Status: ",?33,$P(SRAO("1F"),"^")
 W !,"   G. Functional Status: "_$P(SRAO("1G"),"^"),?43,"5. RENAL:",?76,$P(SRAO(5),"^")
 W !,?43,"   A. Acute Renal Failure:",?76,$P(SRAO("5A"),"^")
 W !,"2. PULMONARY:",?33,$P(SRAO(2),"^"),?43,"   B. Currently on Dialysis:",?76,$P(SRAO("5B"),"^")
 W !,"   A. Ventilator Dependent:",?33,$P(SRAO("2A"),"^")
 W !,"   B. History of Severe COPD:",?33,$P(SRAO("2B"),"^")
 W !,"   C. Current Pneumonia:",?33,$P(SRAO("2C"),"^")
 W !! F MOE=1:1:80 W "-"
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
