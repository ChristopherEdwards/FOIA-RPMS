ABPAPCHD ;PROCESSED CLAIM REPORTS HEADER; [ 05/23/91  1:41 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
START S X=0,SITENAME=$P(^DIC(4,DUZ(2),0),"^",1)
NXTX S X=$O(ABPA("HD",X)) G:+X=0 MOVE
 S AU("MAX")=X G NXTX
MOVE F I=AU("MAX"):-1:1 S ABPA("HD",I+2)=ABPA("HD",I)
WRITE S ABPA("HD",1)=SITENAME_" - "_ABPATLE
 S $P(AU("LINE"),"-",$L(ABPA("HD",1))+1)=""
 S ABPA("HD",2)=AU("LINE"),AU("MAX")=AU("MAX")+2
 S XX="",$P(XX,"*",+IOM)=""
 D NOW^%DTC S Y=% X ^DD("DD") S RUNTM=$P(Y,"@",2)
 S RUNDT=+%I(1)_"/"_+%I(2)_"/"_+$E(+%I(3),2,3)_" AT "_RUNTM
 S ABPAPG=ABPAPG+1 S PG="PAGE: "_ABPAPG W @IOF
 W "RUN DATE: ",RUNDT S X="(Task #"_ZTNN_")"
 W ?((+IOM/2)-($L(X)/2)),X,?((+IOM-1)-($L(PG))),PG,!,XX
 F I=1:1:AU("MAX") D  W:I=AU("MAX") !,XX
 .W !,"*",?(+IOM/2)-(($L(ABPA("HD",I))/2)),ABPA("HD",I),?(+IOM-2),"*"
 I ABPA("RFMT")=1&('EOF) D
 .W !!,"PATIENT NAME",?36,"SSN",?52,"SUBSCRIBER NAME",?79,"DOS"
 .W ?87,"LOCATION OF SERVICE",?119,"CLAIM AMT"
 .W ! F I=1:1:(+IOM-1) W "="
 E  I 'EOF D
 .W !!?45,"Total",?57,"Total",!,"Insurance Company",?45,"Billed"
 .W ?57,"Payments",?70,"Write-off",! F I=1:1:(+IOM-1) W "="
 W ! K X,Y,I,AU("MAX"),SITENAME,XX,AU("LINE"),RUNDT,RUNTM,PG
 F I=3:1 Q:$D(ABPA("HD",I))=0  D  K ABPA("HD",I)
 .S ABPA("HD",(I-2))=ABPA("HD",I)
QUIT Q
