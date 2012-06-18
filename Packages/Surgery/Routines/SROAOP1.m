SROAOP1 ;BIR/MAM - SET OPERATION INFO ; [ 04/20/00  12:48 PM ]
 ;;3.0; Surgery ;**38,47,63,81,88,95,97**;24 Jun 93
 K SRA,SRAO F I=0,200,"OP" S SRA(I)=$G(^SRF(SRTN,I))
 S SRDOC="Surgeon: "_$P(^VA(200,$P(^SRF(SRTN,.1),"^",4),0),"^"),(SRAO(4),SRAO(5))=""
 K SROPS S SROPER=$P(SRA("OP"),"^")
 S SRAO(2)="^26"
 S:$L(SROPER)<49 SROPS(1)=SROPER K M,MM,MMM I $L(SROPER)>48 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 S X=$P(SRA(0),"^",4) S:X X=$P(^SRO(137.45,X,0),"^",1) S SRAO(1)=X_"^.04"
 S X=$P(SRA(0),"^",3) S:X'="" X=$S(X="J":"MAJOR",1:"MINOR") S SRAO(13)=X_"^.03"
 S SRHDR(.5)=SRDOC,SRPAGE="PAGE: 1 OF 2" D HDR^SROAUTL
 W !," 1. Surgical Specialty: ",?34,$P(SRAO(1),"^"),!," 2. Principal Operation: ",?34,SROPS(1) I $D(SROPS(2)) W !,?34,SROPS(2) I $D(SROPS(3)) W !,?34,SROPS(3)
 S X=$P(^SRF(SRTN,"OP"),"^",2) I X S Y=$P($$CPT^ICPTCOD(X),"^",2) D SSPRIN^SROCPT S X=Y
 S SRAO(3)=X_"^27"
 W !," 3. Principal CPT Code: ",?34,$P(SRAO(3),"^")
 W !," 4. Other Procedures:" W:$O(^SRF(SRTN,13,0)) ?34,"***INFORMATION ENTERED***"
 W !," 5. Concurrent Procedure:" S CON=$P($G(^SRF(SRTN,"CON")),"^") I CON,'($P($G(^SRF(CON,30)),"^")!($P($G(^SRF(CON,31)),"^",8))) W ?34,"***INFORMATION ENTERED***"
 S X=$P(SRA(200),"^",52),SRAO(6)=X_"^214",NYUK=$P(SRA(0),"^",10) D EMERG S SRAO(7)=SHEMP_"^.035"
 S Y=$P($G(^SRF(SRTN,"1.0")),"^",8),C=$P(^DD(130,1.09,0),"^",2) D:Y'="" Y^DIQ S SRAO(8)=Y_"^1.09"
 S Y=$P($G(^SRF(SRTN,1.1)),"^",3),C=$P(^DD(130,1.13,0),"^",2) D:Y'="" Y^DIQ S SRAO(9)=Y_"^1.13"
 D TECH^SROPRIN S SRAO(10)=SRTECH
 S X=$P(SRA(200),"^",54),SRAO(11)=X_"^340" K SRA(.2)
 S X=$P($G(^SRF(SRTN,34)),"^",2) S:X X=$P(^ICD9(X,0),"^")_"   "_$P(^(0),"^",3) S SRAO(12)=X_"^66"
 W !," 6. PGY of Primary Surgeon:",?34,$P(SRAO(6),"^"),!," 7. Surgical Priority:",?34,$P(SRAO(7),"^"),!," 8. Wound Classification: ",?34,$P(SRAO(8),"^")
 W !," 9. ASA Classification:",?34,$P(SRAO(9),"^"),!,"10. Anesthesia Technique:",?34,$P(SRAO(10),"^")
 W !,"11. RBC Units Transfused:",?34,$P(SRAO(11),"^"),!,"12. Postop Diagnosis Code (ICD9):",?34,$P(SRAO(12),"^")
 W !,"13. Major or Minor:",?34,$P(SRAO(13),"^"),!! F LINE=1:1:80 W "-"
 Q
YN S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
LOOP ; break procedures
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<49  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
EMERG ; surgical priority
 I NYUK="" S SHEMP="" Q
 S Y=NYUK,C=$P(^DD(130,.035,0),"^",2) D Y^DIQ S SHEMP=Y
 Q
