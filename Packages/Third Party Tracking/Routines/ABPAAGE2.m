ABPAAGE2 ;PRINT DETAILED OPEN ITEMS; [ 05/20/91  9:11 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!?5,"<<< NOT AN ENTRY POINT - ACCESS DENIED >>>" G END
 ;--------------------------------------------------------------------
INIT ;PROCEDURE TO INITIALIZE TEMPORARY LOCAL VARIABLES
 K ABPA("HD") S FRDT=+$E(BDT,4,5)_"/"_+$E(BDT,6,7)_"/"_+$E(BDT,2,3)
 S TODT=+$E(EDT,4,5)_"/"_+$E(EDT,6,7)_"/"_+$E(EDT,2,3)
 S ABPA("HD",4)="Claims submitted between "_FRDT_" and "_TODT
 S (ABPAPG,GCNT,GTOT)=0,ZTNN=ZTSK,ZTSK=ZTN
 D ^ABPAPRT I $D(A("PRINT",16))=1 W @(A("PRINT",16))
 Q
 ;--------------------------------------------------------------------
GETDATA ;PROCEDURE TO GET COMPILED DATA FROM THE %ZTSK NODE
 S P=0 F I=0:0 D  Q:P=""
 .S P=$O(^%ZTSK(ZTSK,"INSURER",P)) Q:P=""
 .S R=0 F M=0:0 D  Q:+R=0
 ..S R=$O(^%ZTSK(ZTSK,"INSURER",P,R)) Q:+R=0
 ..Q:$D(^%ZTSK(ZTSK,"AGING",R))'=10  S ABPA("HD",1)=P
 ..Q:+$D(^AUTNINS(R,0))'=1  S DATA=^(0)
 ..F J=2:1:5 S ABPA("I"_J)=$P(DATA,"^",J)
 ..I $D(^DIC(5,ABPA("I4"),0))=1 S ABPA("I4")=$P(^(0),"^",2)
 ..S ABPA("HD",2)=ABPA("I2"),ABPA("HD",3)=ABPA("I3")_", "_ABPA("I4")
 ..S ABPA("HD",3)=ABPA("HD",3)_"  "_ABPA("I5")
 ..D ^ABPAACHD S (RR,ICNT,ITOT,NEW)=0 F J=0:0 D  Q:RR=""
 ...S RR=$O(^%ZTSK(ZTSK,"AGING",R,RR))
 ...I RR="" D  Q
 ....W !?77,"--------",?119,"---------",!?77,$J(ICNT,8)
 ....S GCNT=GCNT+ICNT W ?118,"$",$J(ITOT,9,2) I $Y>57 D ^ABPAACHD
 ...S NEW=1,RRR=0 F K=0:0 D  Q:RRR=""
 ....S RRR=$O(^%ZTSK(ZTSK,"AGING",R,RR,RRR)) Q:RRR=""
 ....S RRRR=0 F L=0:0 D  Q:+RRRR=0
 .....S RRRR=$O(^%ZTSK(ZTSK,"AGING",R,RR,RRR,RRRR)) Q:+RRRR=0
 .....S DATA=^%ZTSK(ZTSK,"AGING",R,RR,RRR,RRRR),ICNT=ICNT+1
 .....S SSN=$P(DATA,"^"),PNO=$P(DATA,"^",2),DOS=$P(DATA,"^",3)
 .....S DOS=+$E(DOS,4,5)_"/"_+$E(DOS,6,7)_"/"_+$E(DOS,2,3)
 .....S FAC=$P(DATA,"^",4),AMT=$P(DATA,"^",5)
 .....S ITOT=ITOT+AMT,GTOT=GTOT+AMT
 .....I NEW W !!,RRR,?32,SSN,?45,$J(PNO,30) S NEW=0
 .....W:$X>77 ! W ?77,$J(DOS,8),?87,FAC,?119,$J(AMT,9,2)
 .....I $Y>57 D
 ......D ^ABPAACHD S RTMP=RRRR
 ......S RTMP=$O(^%ZTSK(ZTSK,"AGING",R,RR,RRR,RTMP)) I +RTMP>0 D
 .......W !,RRR,?32,SSN,?45,$J(PNO,30)
 K ABPA("HD"),ABPA("RTYP") S ABPA("HD",1)="OPEN ITEMS SUMMARY"
 S ABPA("RTYP")="" D ^ABPAACHD S X=GTOT D COMMA^%DTC S GTOT=X
 W !!!!! S X="Summary for "_$P(^DIC(4,DUZ(2),0),"^")_": "
 S X=X_GCNT_" claims for $"_GTOT W ?(131-$L(X)),X
 W @IOF I $D(A("PRINT",10))=1 W @(A("PRINT",10))
 X ^%ZIS("C")
 Q
 ;---------------------------------------------------------------------
END ;PROCEDURE TO KILL ALL TEMPORARY LOCAL VARIABLES
 K X,Y,ABPA("HD"),I,J,ABPAPG,K,L,R,RR,RRR,RRRRDOS,AGE,AMT,ZTN,P
 K ITOT,GTOT,OHRN,RTMP,FRDT,TODT,GCNT,ICNT
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - CALLED BY TASK MANAGER
 D INIT,GETDATA,END
 Q
