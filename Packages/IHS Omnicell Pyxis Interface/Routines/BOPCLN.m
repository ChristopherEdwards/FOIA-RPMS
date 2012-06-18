BOPCLN ;IHS/ILC/ALG/CIA/PLS - Clean Up Files in 90355.1;15-Jul-2005 08:44;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;;Jul 26, 2005
 Q
R ; entry point to clean up file 90355.1 of old query responses
 S U="^",COUNTER=0,COUNT=0
R1 S COUNTER=$O(^BOP(90355.1,"AS",0,COUNTER)) I 'COUNTER G DONE
 S B=$G(^BOP(90355.1,COUNTER,0)),C=$G(^BOP(90355.1,COUNTER,1))
 I B'="" D KILL
 G R1
 ;
KILL ; remove entry
 I $P(B,U,2)'="Q03" Q  ;  only clean up old response to queries
 S X=$P(B,U) I X]"" K ^BOP(90355.1,"B",X,COUNTER)
 S X=$P(B,U,3) I X]"" K ^BOP(90355.1,"AD",X,COUNTER)
 S X=$P(C,U,1) I X]"" K ^BOP(90355.1,"ADFN",X,COUNTER)
 S X=$P(C,U,3) I X]"" S F=$P(X,",",1),G=$P(X,",",2,999) I F'=""&(G'="") K ^BOP(90355.1,"ANAME",F,G,COUNTER)
 K ^BOP(90355.1,COUNTER)
 K ^BOP(90355.1,"AS",0,COUNTER)
 S COUNT=COUNT+1
 Q
 ;
DONE W !,"TOTAL 'Q03' ENTRIES REMOVED: ",COUNT
 Q
 ;
EOR ;BOPCLN - Clean Up Files in 90355.1
