GMRA1004 ;IHS/MSC/PLS - Patch support;02-May-2012 11:52;DU
 ;;4.0;Adverse Reaction Tracking;**1004**;Mar 29, 1996;Build 20
 ;
ENV ;EP -
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="GMRA*4.0*1003"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
PRE ;EP -
 Q
POST ;EP -
 N ZTRTN,ZTDESC,TSK
 S ZTRTN="EN^GMRAZDSF",ZTDESC="Drug Class and Ingredients clean up"
 S TSK=$$QUEUE^CIAUTSK(ZTRTN,ZTDESC,"","","","","")
 D RESCH^XUTMOPT("GMRAZ FIX SUBFILES","T+1@0600","","24H","L")
 W !,"Cleanup has scheduled task number: "_TSK
 Q
