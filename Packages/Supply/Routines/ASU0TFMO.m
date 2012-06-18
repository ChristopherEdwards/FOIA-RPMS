ASU0TFMO ; IHS/ITSC/LMH -OUTPUT TRANSFORM .01 KEYFIELD ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ; 
 ;This routine is the File Man Output transform for all SAMS transaction
 ;files.
 N Z
 S Z=$S($P(Y,".",3):$P(Y,".",3),1:1),Y=$P(Y,".")_"."_$P(Y,".",2),%DT="S"
 D DD^%DT S Z(0)=$G(^VA(200,Z,0)),Y=Y_" BY "_$S(Z(0)]"":$P(Z(0),U),1:Z)
 Q
HST ;EP;HISTORY
 Q
