GMTS1005 ;IHS/MSC/MGH - GMTS Package Update Utility ;05-Oct-2012 10:05;DU
 ;;2.7;VA Health Summary;**1005**;APR 24, 1997;Build 12
 ;=================================================================
 ;
 ;
ENV ; EP Environment checker for EHR patch 11 updates
 N PATCH,X,Y
 S X=$$NOW^XLFDT
 S PATCH="GMTS*2.7*1004"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch number
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
