APSPRT2 ; IHS/DSD/ENM - PRINT PREPACK LABELS ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 D ZIS
 D PRINT
 D EOJ
 Q
 ;
ZIS ;
 S IOP=APSPRT("IO") D ^%ZIS U IO
 Q
 ;
PRINT ;
START S APSP("COPIES")=APSP("COPIES")-1 F I=1:1:APSP(17) W !
 S APSPZZL=4
 S APSPZLA=APSP(16)-APSPZZL
 W !,?APSP(21),$E(APSP("LINE1"),1,APSP(22))
SIG ;
 G CON:APSPZLA<APSPGC F APSPDR=1:1:APSPZLA D SIG1
 G NEXT
CON S (APSPDR,APSPF)=0
C1 F I=1:1:APSP(16)-2 S APSPDR=APSPDR+1 D SIG1 Q:'$D(APSPGY(APSPDR+1))
 I '$D(APSPGY(APSPDR+1))&(I>APSPZLA) F II=1:1:(APSP(16)-2-I) W !
 I '$D(APSPGY(APSPDR+1)) G NEXT:APSPF&(I'>APSPZLA) ;IHS/BAO/JCM 2/3/89
 W !,?APSP(21),"****  CONTINUED  ****" S APSPF=1
 F I=1:1:APSP(18)+APSP(17) W !
 W !,?APSP(21),"****  CONTINUED  ****" S APSPZM=$S(APSPZLA-(APSPGC-APSPDR)'<0:APSPZLA-(APSPGC-APSPDR),1:0) F I=1:1:APSPZM W !
 G C1:APSPDR<APSPGC
NEXT ;
 W !,?APSP(21),APSP("DRUG")
 I '$D(APSP("QTYFLG")) W ?(APSP(21)+APSP(22)-$L(APSP("QTY"))),APSP("QTY")
 W !,?APSP(21),APSP("CNTL#")
 W ?(APSP(21)+APSP(22)-$L(APSPRT("EXPDATE"))),APSPRT("EXPDATE")
 W !,?APSP(21),$E(APSP("LINE2"),1,APSP(22))
 F I=1:1:APSP(18) W !
 I APSP("COPIES")>0 G START
 F I=1:1:(APSP(19)*(APSP(16)+APSP(17)+APSP(18))) W !
 Q
 ;
SIG1 S X=$S($D(APSPGY(APSPDR)):APSPGY(APSPDR),1:"") W !,?APSP(21),X
 Q
 ;
EOJ ;
 D ^%ZISC
 K APSPDR,APSPF,APSPGC,APSPGY,APSPZLA,APSPZM,APSPZZL,I,II,IOP,X
 K APSP("DRUG"),APSPRT("EXPDATE"),APSP("COPIES"),APSP("CNTL#")
 K I,IOP
 Q