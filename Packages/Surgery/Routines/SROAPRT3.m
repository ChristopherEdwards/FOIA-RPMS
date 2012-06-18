SROAPRT3 ;BIR/MAM - PRINT OPERATION INFO ; [ 04/20/00  1:12 PM ]
 ;;3.0; Surgery ;**38,47,63,81,88,95**;24 Jun 93
 K SRAO S (SRAO(7),SRAO(8))="",SRA("OP")=^SRF(SRTN,"OP")
 S SRAO(2)="^1" K SROPS S SROPER=$P(SRA("OP"),"^")
 S:$L(SROPER)<49 SROPS(1)=SROPER K M,MM,MMM I $L(SROPER)>48 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 S SRA(0)=^SRF(SRTN,0),X=$P(SRA(0),"^",4) S:X X=$P(^SRO(137.45,X,0),"^") S SRAO(2)=X_"^.04"
 W !,?29,"OPERATIVE INFORMATION",!!,$J("Surgical Specialty: ",39)_$P(SRAO(2),"^")
 W !!,$J("Principal Operation: ",39)_SROPS(1) I $D(SROPS(2)) W !,?40,SROPS(2) I $D(SROPS(3)) W !,?40,SROPS(3)
 S X=$P(^SRF(SRTN,"OP"),"^",2) I X S Y=$P($$CPT^ICPTCOD(X),"^",2) D SSPRIN^SROCPT S X=Y
 S SRAO(6)=X_"^27"
 W !,$J("Principal CPT Code: ",39)_$P(SRAO(6),"^")
 D ^SROAOTH
 S X=$P(SRA(200),"^",52),SRAO(9)=X_"^214",NYUK=$P(SRA(0),"^",10),NYUK=$S(NYUK="EM":"YES",1:"NO") S SRAO(10)=NYUK_"^.035"
 S Y=$P($G(^SRF(SRTN,"1.0")),"^",8),C=$P(^DD(130,1.09,0),"^",2) D:Y'="" Y^DIQ S SRAO(11)=Y_"^1.09"
 S NYUK=$P(SRA(200),"^",53) D YN S SRAO(12)=SHEMP_"^201"
 S Y=$P($G(^SRF(SRTN,1.1)),"^",3),C=$P(^DD(130,1.13,0),"^",2) D:Y'="" Y^DIQ S SRAO(13)=Y_"^1.13"
 D TECH^SROPRIN S SRAO(14)=SRTECH D TRAUMA S SRAO(14.1)=SRTRAUMA K SRTRAUMA
 S SRI=$P($G(^SRF(SRTN,.3)),"^",9) D  S SRAO(14.2)=SRI
 .I 'SRI S SRI="NOT ENTERED" Q
 .K DA,DIC,DIQ,SRY S DIC="^SRF(",DA=SRTN,DIQ="SRY",DIQ(0)="E",DR=901 D EN^DIQ1 S SRI=SRY(130,SRTN,901,"E") K DA,DIC,DIQ,DR,SRY
 S X=$P(SRA(200),"^",54),SRAO(15)=X_"^340"
 I $E(IOST)'="P" D PAGE^SROAPAS Q:SRSOUT  W !,?29,"OPERATIVE INFORMATION",!
 W !,$J("PGY of Primary Surgeon: ",39)_$P(SRAO(9),"^") W !,$J("Emergency Case (Y/N): ",39)_$P(SRAO(10),"^")
 S X=$P(SRA(0),"^",3),X=$S(X="J":"MAJOR",X="N":"MINOR",1:""),SRAO(12)=X_"^.03" W !,$J("Major or Minor: ",39)_$P(SRAO(12),"^")
 W !,$J("Wound Classification: ",39)_$P(SRAO(11),"^")
 W !,$J("ASA Classification: ",39)_$P(SRAO(13),"^"),!,$J("Anesthesia Technique: ",39)_$P(SRAO(14),"^")
 W !,$J("Airway Trauma: ",39)_$P(SRAO(14.1),"^"),!,$J("Airway Index: ",39)_$P(SRAO(14.2),"^")
 W !,$J("RBC Units Transfused: ",39)_$P(SRAO(15),"^")
 I $E(IOST)="P" W !!
 Q
YN S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
LOOP ; break procedures
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<49  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
TRAUMA ; trauma related to anesthesia airway management
 S SRTRAUMA="" S:SRT SRTRAUMA=$P(^SRF(SRTN,6,SRT,0),"^",14) I SRTRAUMA="" S SRTRAUMA="NOT ENTERED" Q
 S Y=SRTRAUMA,C=$P(^DD(130.06,12,0),"^",2) D Y^DIQ S SRTRAUMA=Y
 Q
OPTIMES ; print operation times
 K SRAO F I=1:1:7 S SRAO(I)=""
 W:$E(IOST)="P" ! W !,?24,"OPERATION DATE/TIMES INFORMATION"
 S X=$G(^SRF(SRTN,.2)),SRAO(1)=$P(X,"^",10),SRAO(2)=$P(X,"^",2),SRAO(3)=$P(X,"^",3),SRAO(4)=$P(X,"^",12),SRAO(5)=$P(X,"^"),SRAO(6)=$P(X,"^",4),SRAO(7)=$P($G(^SRF(SRTN,1.1)),"^",8)
 F SRI=1:1:7 S Y=SRAO(SRI) I Y X ^DD("DD") S X=$P(Y,"@")_"  "_$P(Y,"@",2),SRAO(SRI)=X
 W !!,$J("Date/Time Patient in OR: ",39)_SRAO(1),!,$J("Date/Time Operation Began: ",39)_SRAO(2),!,$J("Date/Time Operation Ended: ",39)_SRAO(3)
 W !,$J("Date/Time Patient Out of OR: ",39)_SRAO(4),!,$J("Anesthesia Care Start Date/Time: ",39)_SRAO(5),!,$J("Anesthesia Care End Date/Time: ",39)_SRAO(6),!,$J("PACU Discharge Date/Time: ",39)_SRAO(7)
 I $E(IOST)="P" W !
 Q
