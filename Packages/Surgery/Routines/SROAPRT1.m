SROAPRT1 ;B'HAM ISC/MAM - PREOP INFO (PAGE 1) ; 17 MAR 1992 5:05 pm
 ;;3.0; Surgery ;**38,47**;24 Jun 93
 F I=0,200 S SRA(I)=$G(^SRF(SRTN,I))
 S NYUK=$P(SRA(200),"^") D YN S SRAO(1)=SHEMP_"^402"
 S X=$P(SRA(200),"^",2),X=$S(X="N":"NO",X="O":"ORAL",X="I":"INSULIN",X="NS":"NO STUDY",1:""),SRAO("1A")=X_"^346"
 S NYUK=$P(SRA(200),"^",3) D YN S SRAO("1B")=SHEMP_"^202",NYUK=$P(SRA(200),"^",4) D YN S SRAO("1C")=SHEMP_"^246"
 S X=$P(SRA(200),"^",6),X=$S(X=1:"                   NO",X=2:"          MINIMAL EXERTION",X=3:"                AT REST",X="NS":"                   NS",1:""),SRAO("1D")=X_"^325"
 S NYUK=$P(SRA(200),"^",7) D YN S SRAO("1E")=SHEMP_"^238",X=$P(SRA(200),"^",8),X=$S(X=1:"INDEPENDENT",X=2:"PARTIAL DEPENDENT",X=3:"TOTAL DEPENDENT",1:""),SRAO("1F")=X_"^240"
 S NYUK=$P(SRA(200),"^",9) D YN S SRAO(2)=SHEMP_"^241",NYUK=$P(SRA(200),"^",10) D YN S SRAO("2A")=SHEMP_"^204",NYUK=$P(SRA(200),"^",11) D YN S SRAO("2B")=SHEMP_"^203"
 S NYUK=$P(SRA(200),"^",12) D YN S SRAO("2C")=SHEMP_"^326"
 S NYUK=$P(SRA(200),"^",13) D YN S SRAO(3)=SHEMP_"^244",NYUK=$P(SRA(200),"^",15) D YN S SRAO("3A")=SHEMP_"^212"
 S NYUK=$P(SRA(200),"^",30) D YN S SRAO(4)=SHEMP_"^242",NYUK=$P(SRA(200),"^",35) D YN S SRAO("4A")=SHEMP_"^396"
 S NYUK=$P(SRA(200),"^",37) D YN S SRAO(5)=SHEMP_"^243",NYUK=$P(SRA(200),"^",38) D YN S SRAO("5A")=SHEMP_"^328",NYUK=$P(SRA(200),"^",39) D YN S SRAO("5B")=SHEMP_"^211"
 S X=$P($G(^SRF(SRTN,208)),"^",9),SRAO("1B1")=X_"^202.1"
 W:$E(IOST)="P" ! W !,?28,"PREOPERATIVE INFORMATION",!
 W !!,"GENERAL:",?29,$P(SRAO(1),"^"),?40,"HEPATOBILIARY:",?72,$P(SRAO(3),"^")
 W !,"Diabetes Mellitus:",?29,$P(SRAO("1A"),"^"),?40,"Ascites:",?72,$P(SRAO("3A"),"^")
 W !,"Current Smoker W/I 1 Year:",?29,$P(SRAO("1B"),"^"),!,"Pack/Years:",?29,$P(SRAO("1B1"),"^")
 W !,"ETOH > 2 Drinks/Day:",?29,$P(SRAO("1C"),"^"),?40,"CARDIAC:",?72,$P(SRAO(4),"^")
 W !,"Dyspnea:  "_$P(SRAO("1D"),"^"),?40,"CHF Within 1 Month:",?72,$P(SRAO("4A"),"^")
 W !,"DNR Status: ",?29,$P(SRAO("1E"),"^"),!,"Functional Status:  "_$P(SRAO("1F"),"^"),?40,"RENAL:",?72,$P(SRAO(5),"^"),!,?40,"Acute Renal Failure:",?72,$P(SRAO("5A"),"^")
 W !,"PULMONARY:",?29,$P(SRAO(2),"^"),?40,"Currently on Dialysis:",?72,$P(SRAO("5B"),"^")
 W !,"Ventilator Dependent:",?29,$P(SRAO("2A"),"^")
 W !,"History of Severe COPD:",?29,$P(SRAO("2B"),"^"),!,"Current Pneumonia:",?29,$P(SRAO("2C"),"^")
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
