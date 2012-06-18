SROAOTH ;BIR/MAM - PRINT OTHER PROCEDURES ; [ 10/04/99  12:14 PM ]
 ;;3.0; Surgery ;**34,88,97**;24 Jun 93
 W ! S (CNT,OTH)=0 F  S OTH=$O(^SRF(SRTN,13,OTH)) Q:'OTH  S CNT=CNT+1,OPER=$P(^SRF(SRTN,13,OTH,0),"^"),CPT=$P($G(^SRF(SRTN,13,OTH,2)),"^") D LIST
 K OTH,CPT,CNT,OPER,SROPS S SROPS(1)=""
 S CPT="",CON=$P($G(^SRF(SRTN,"CON")),"^") I CON,($P($G(^SRF(CON,30)),"^")!($P($G(^SRF(CON,31)),"^",8))) S CON=""
 I CON S SROPER=$P(^SRF(CON,"OP"),"^"),CPT=$P(^("OP"),"^",2) D
 .K SROPS,MM,MMM S:$L(SROPER)<49 SROPS(1)=SROPER I $L(SROPER)>48 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 .I CPT S Y=$P($$CPT^ICPTCOD(CPT),"^",2) D CON
 .S:CPT="" CPT="MISSING"
 W !!,$J("Concurrent Procedure: ",39)_SROPS(1) I $D(SROPS(2)) W !,?39,SROPS(2) I $D(SROPS(3)) W !,?39,SROPS(3)
 W !,$J("CPT Code: ",39)_CPT
 Q
CON ; get CPT modifiers for concurrent procedure
 N SRTN S SRTN=CON D SSPRIN^SROCPT S CPT=Y
 Q
LIST I CPT S Y=$P($$CPT^ICPTCOD(CPT),"^",2),SRDA=OTH D SSOTH^SROCPT S CPT=Y
 S:CPT="" CPT="MISSING"
 W !,$J("Other Procedure ("_CNT_"): ",39)_OPER,!,$J("CPT Code: ",39)_CPT
 Q
LOOP ; break procedures
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<49  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
