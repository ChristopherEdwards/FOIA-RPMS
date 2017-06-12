GMRC1005 ; IHS/CIA/MGH - PRE-INSTALL ROUTINE FOR GMRC PATCH 1005 ;19-Nov-2014 17:06;mgh
 ;;3.0;CONSULT/REQUEST TRACKING;**1005**;NOV 04, 2004;Build 2
 ;
ENV ;EP; environmen check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;
 S PATCH="GMRC*3.0*1004"
 I '$$PATCH(PATCH) D  Q
 .W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
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
 ;
PRE ;EP; beginning of pre install code
 Q
 ;
POST ;EP; beginning of post install code
 Q
