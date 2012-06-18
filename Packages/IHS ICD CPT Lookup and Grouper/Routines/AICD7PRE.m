AICD7PRE ;IHS/OIT/CLS - Pre-install routine for AICD patch 7;10/25/2006
 ;;3.51;IHS ICD/CPT LOOKUP & GROUPER;**7**;May 30, 1991
 ;;
DEL1 ; Delete earlier AICD Package file entries
 N DA,DIK,AICD
 S DA=$O(^DIC(9.4,"B","AICD","")) I DA S AICD=$P(^DIC(9.4,DA,0),U) D DEL
 S DA=$O(^DIC(9.4,"B","IHS ICD LOOKUP SYSTEM","")) I DA S AICD=$P(^DIC(9.4,DA,0),U) D DEL
 ;
EN1 ; Check for previous patch
 I '$$PATCH("AICD*3.51*6") D SORRY Q
 Q
 ;
SORRY ; IHS/ITSC/CLS 04/16/2003
 S XPDQUIT=1  ;don't install this transport global and kill it from ^XTMP
 W !!?20,"Need AICD v 5.1, Patch 6"
 W *7,!,$$C^XBFUNC("Installation of AICD*3.51*7 has been aborted.")
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn  ;IHS/ITSC/CLS 05/11/2003
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 N %,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S %=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+%)
 ;
DEL S DIK="^DIC(9.4," W !,"Deleting old AICD Package file entry ",AICD,".",! D ^DIK
 Q
