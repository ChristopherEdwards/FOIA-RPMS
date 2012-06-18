ABPAAGS2 ;PRINT AGED CLAIM SUMMARY; [ 05/17/91  4:53 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!?5,"<<< NOT AN ENTRY POINT - ACCESS DENIED >>>" G END
 ;--------------------------------------------------------------------
INIT ;PROCEDURE TO INITIALIZE TEMPORARY LOCAL VARIABLES
 K ABPA("HD")
 S FRDT=+$E(BDT,4,5)_"/"_+$E(BDT,6,7)_"/"_+$E(BDT,2,3)
 S TODT=+$E(EDT,4,5)_"/"_+$E(EDT,6,7)_"/"_+$E(EDT,2,3)
 S ABPA("HD",1)=ABPATLE,ABPA("HD",2)="AGED CLAIMS SUMMARY LISTING"
 S ABPA("HD",3)="Claims submitted between "_FRDT_" and "_TODT
 S (ABPAPG,P1T,P2T,P3T,P4T)=0,ZTNN=ZTSK,ZTSK=ZTN
 D ^ABPAPRT S IOP=IO_";80" D ^%ZIS K IOP
 I $D(A("PRINT",10)) W @A("PRINT",10) ; Set for standard print.
 Q
 ;--------------------------------------------------------------------
GETDATA ;PROCEDURE TO GET COMPILED DATA FROM THE %ZTSK NODE
 S P=0 F I=0:0 D  Q:P=""
 .S P=$O(^%ZTSK(ZTSK,"INSURER",P)) Q:P=""
 .S INSURER=$P(P,"/.:"),ZIP=$P(P,"/.:",2)
 .S (R,P1,P2,P3,P4)=0 F J=0:0 D  Q:+R<1
 ..S R=$O(^%ZTSK(ZTSK,"INSURER",P,R)) Q:+R<1
 ..Q:$D(^%ZTSK(ZTSK,"AGING",R))'=1
 ..S DATA=^%ZTSK(ZTSK,"AGING",R) F K=1:1:4 D
 ...S @("P"_K)=@("P"_K)+$P(DATA,"^",K)
 ...S @("P"_K_"T")=@("P"_K_"T")+$P(DATA,"^",K)
 .I $Y>57 D ^ABPAACHD
 .W !,INSURER I ($L(INSURER)+$L(ZIP)+3)<40 W " (",ZIP,")"
 .W ?40,$J($P(DATA,"^"),9,2),?50,$J($P(DATA,"^",2),9,2)
 .W ?60,$J($P(DATA,"^",3),9,2),?70,$J($P(DATA,"^",4),9,2)
 .I ($L(INSURER)+$L(ZIP)+3)>39 W !?5,"(",ZIP,")"
 W !?40,"---------",?50,"---------",?60,"---------",?70,"---------"
 W !,?56,".",?76,".",!
 W "*** Report Totals ***",?37,"$" S X=P1T D COMMA^%DTC W X,?56,"."
 W ?58 S X=P3T D COMMA^%DTC W X,?76,"."
 W !?56,".",?76,".",!?48 S X=P2T D COMMA^%DTC W X
 W ?68 S X=P4T D COMMA^%DTC W X,@IOF X ^%ZIS("C")
 Q
 ;---------------------------------------------------------------------
END ;PROCEDURE TO KILL ALL TEMPORARY LOCAL VARIABLES
 K X,Y,ABPA("HD"),I,J,ABPAPG,K,L,R,RR,RRR,RRRRDOS,AGE,AMT,ZTN,P,ABPAPG
 K ITOT,GTOT,OHRN,RTMP,FRDT,TODT,P1,P2,P3,P4,P1T,P2T,P3T,P4T,ZTNN
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - CALLED BY TASK MANAGER
 D INIT
 D ^ABPAACHD
 D GETDATA
 D END
 Q
