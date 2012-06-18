SROAPCA3 ;B'HAM ISC/MAM - CARDIAC OCCURRENCE DATA ; [ 09/19/00  9:12 AM ]
 ;;3.0; Surgery ;**38,71,95,101**;24 Jun 93
 D EN^SROCCAT K SRA S SRA(205)=$G(^SRF(SRTN,205)),SRA(208)=$G(^SRF(SRTN,208)),SRA(206)=$G(^SRF(SRTN,206))
 S NYUK=$P(SRA(208),"^") D YN S SRAO(1)=SHEMP_"^384",NYUK=$P($G(^DPT(DFN,.35)),"^") S:NYUK NYUK=$E(NYUK,4,5)_"/"_$E(NYUK,6,7)_"/"_$E(NYUK,2,3) S SRAO(2)=NYUK
 S NYUK=$P(SRA(208),"^",2) D YN S SRAO(3)=SHEMP_"^385",NYUK=$P(SRA(208),"^",3) D YN S SRAO(4)=SHEMP_"^386",NYUK=$P(SRA(205),"^",17) D YN S SRAO(5)=SHEMP_"^254",NYUK=$P(SRA(208),"^",4) D YN S SRAO(6)=SHEMP_"^387"
 S NYUK=$P(SRA(208),"^",5) D YN S SRAO(7)=SHEMP_"^388",NYUK=$P(SRA(208),"^",6) D YN S SRAO(8)=SHEMP_"^389",NYUK=$P(SRA(205),"^",13) D YN S SRAO(9)=SHEMP_"^285"
 S NYUK=$P(SRA(208),"^",7) D YN S SRAO(10)=SHEMP_"^391",NYUK=$P(SRA(205),"^",22) D YN S SRAO(11)=SHEMP_"^410"
 S NYUK=$P(SRA(205),"^",21) D YN S SRAO(12)=SHEMP_"^256",NYUK=$P(SRA(205),"^",26) D YN S SRAO(13)=SHEMP_"^411"
 S NYUK=$P(SRA(206),"^",39) D YN S SRAO(14)=SHEMP_"^466",NYUK=$P(SRA(206),"^",40) D YN S SRAO(15)=SHEMP_"^467"
 I $Y+5>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !," B. Operative Death:",?23,$P(SRAO(1),"^"),?43,"Date of Death:",?58,$P(SRAO(2),"^")
 I $Y+10>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !," C. Perioperative (30 day) Occurrences"
 W !,?4,"Perioperative MI:",?39,$P(SRAO(3),"^"),?44,"Reoperation for Bleeding:",?76,$P(SRAO(8),"^")
 W !,?4,"Endocarditis:",?39,$P(SRAO(4),"^"),?44,"On Ventilator > or = 48 Hours: ",?76,$P(SRAO(9),"^")
 W !,?4,"Renal Failure Requiring Dialysis:",?39,$P(SRAO(5),"^"),?44,"Repeat Cardiopulmonary Bypass:",?76,$P(SRAO(10),"^")
 W !,?4,"Low Cardiac Output > or = 6 Hours:",?39,$P(SRAO(6),"^"),?44,"Coma > or = 24 Hours:",?76,$P(SRAO(11),"^"),!,?4,"Mediastinitis:",?39,$P(SRAO(7),"^"),?44,"Stroke/CVA:",?76,$P(SRAO(12),"^")
 W !,?4,"Cardiac Arrest Requiring CPR:",?39,$P(SRAO(13),"^"),?44,"Trachestomy:",?76,$P(SRAO(14),"^"),!,?44,"Mechanical Circulatory Support:",?76,$P(SRAO(15),"^")
 D RES
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
 ;
RES I $Y+12>IOSL D PAGE^SROAPCA I SRSOUT Q
 S SRA(208)=$G(^SRF(SRTN,208))
 S SRA(.2)=$G(^SRF(SRTN,.2))
 W !,"V. RESOURCE DATA"
 S Y=$P(SRA(.2),"^",10) D DT^SROAPCA1 W !,?3,"Time Patient In  OR: ",?33,X
 S Y=$P(SRA(.2),"^",12) D DT^SROAPCA1 W !,?3,"Time Patient Out OR: ",?33,X
 S Y=$P($G(^SRF(SRTN,208)),"^",14) D DT^SROAPCA1 W !,?3,"Hospital Admission Date:",?33,X
 S Y=$P($G(^SRF(SRTN,208)),"^",15) D DT^SROAPCA1 W !,?3,"Hospital Discharge Date:",?33,X
 S Y=$P($G(^SRF(SRTN,208)),"^",22) I Y>1 D DT^SROAPCA1 S Y=X
 S Y=$S(Y="NS":"Unable to determine",Y="RI":"Remains intubated at 30 days",1:Y) W !,?3,"Date and Time Patient Extubated: "_Y
 S Y=$P($G(^SRF(SRTN,208)),"^",23) I Y>1 D DT^SROAPCA1 S Y=X
 S Y=$S(Y="NS":"Unable to determine",Y="RI":"Remains in ICU at 30 days",1:Y) W !,?3,"Date and Time Patient Discharged from ICU: "_Y
 W !,?3,"Resource Data Comments: "
 I $G(^SRF(SRTN,206.2))'="" S SRQ=0 S X=$G(^SRF(SRTN,206.2)) W:$L(X)<49 X,! I $L(X)>48 S Z=$L(X) D
 .I X'[" " W ?25,X Q
 .S I=0,LINE=1 F  S SRL=$S(LINE=1:48,1:80) D  Q:SRQ
 ..I $E(X,1,SRL)'[" " W X,! S SRQ=1 Q
 ..S J=SRL-I,Y=$E(X,J),I=I+1 I Y=" " W $E(X,1,J-1),!,?5 S X=$E(X,J+1,Z),Z=$L(X),I=0,LINE=LINE+1 I Z<SRL W X S SRQ=1 Q
 I $Y+7>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !!,"VI. Socioeconomic Data "
 N SREMP S SREMP=$P(SRA(208),"^",18) S SREMP=$S(SREMP=1:"EMPLOYED FULL TIME",SREMP=2:"EMPLOYED PART TIME",SREMP=3:"NOT EMPLOYED",SREMP=4:"SELF EMPLOYED",SREMP=5:"RETIRED",SREMP=6:"ACTIVE MILITARY DUTY",SREMP=9:"UNKNOWN",1:" ")
 W !,?4,"Employment Status Preoperatively: ",SREMP
 K SRA,SRAO
 ;S Y=$P($G(^SRF(SRTN,208)),"^",10),C=$P(^DD(130,417,0),"^",2) D Y^DIQ S X=$S(Y'="":Y,1:"NOT ENTERED")
 ;W !,?4,"Race/Ethnic: ",X
 ;D ^SROAPCA4
 W !!," *** End of report for "_SRANM_" assessment #"_SRTN_" ***"
 Q
