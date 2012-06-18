ASU0TFMI ; IHS/ITSC/LMH -INPUT TRANSFORM .01 KEYFIELD ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ; 
 ;This routine is the File Man Input transform for all SAMS transaction
 ;files.
 N Z
 S X=$G(X)
 Q:X?1N.N.1".".1N.N.1"."1N.N
 Q:X?1N.N.1".".1N.N
 S Z=X,X=$P(X,"BY"),%DT="XPTS"
 D ^%DT
 I Y<0 S X="" G EXIT
 S X=Y
 S Z(0)="."_$P(X,".",2)
 S Z(0)=Z(0)+.0000001
 S $P(X,".",2)=$E(Z(0),2,7)
 S $P(X,".",3)=$J
 S:Z["J#" X=X_"."_$P(Z,"J#",2)
EXIT ;
 Q
HST ;EP;HISTORY
 Q
