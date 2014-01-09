GMRV1001 ;IHS/MSC/MGH - Patch support;06-Jun-2012 09:11;DU
 ;;5.0;GEN. MED. REC. - VITALS;**1001**;Mar 29, 1996;Build 9
 ;
ENV ;EP -
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="XU*8.0*1016"
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
 N I,NAME,IEN,VITAL,CAT,FDA,ERRR
 F I=1:1:4 D
 .S NAME="FETUS "_I
 .S IEN=$O(^GMRD(120.52,"B",NAME,""))
 .K ^GMRD(120.52,IEN,1)
 .S IENS="+1,"_IEN_","
 .S FDA(120.521,IENS,.01)="FT"
 .S FDA(120.521,IENS,.02)="SITE"
 .D UPDATE^DIE("E","FDA","IENS","ERRR(1)")
 .I $D(ERRR) D MES^XPDUTL("Error updating qualifier "_$P(^GMRD(120.52,IEN,0),U)"
 Q
