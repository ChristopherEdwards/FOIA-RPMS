GMRV1003 ;IHS/MSC/MGH - Patch support;02-Feb-2015 09:58;DU
 ;;5.0;GEN. MED. REC. - VITALS;**1003**;Mar 29, 1996;Build 12
 ;
ENV ;EP -
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="XU*8.0*1016"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="GMRV*5.0*1002"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="BJPC*2.0*10"
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
 N I,NAME,IEN,VITAL,CAT,FDA,ERRR,XUMF,AIEN
 S XUMF=1
 ;O2 qualifier
 S NAME="AMBIENT AIR"
 S IEN=$O(^GMRD(120.52,"B",NAME,""))
 Q:'IEN
 K ^GMRD(120.52,IEN,1)
 S AIEN="+1,"_IEN_","
 S FDA(120.521,AIEN,.01)="O2"
 S FDA(120.521,AIEN,.02)="METHOD"
 S IENS(1)=2
 D UPDATE^DIE("E","FDA","","ERRR(1)")
 I $D(ERRR) D MES^XPDUTL("Error updating qualifier "_$P(^GMRD(120.52,IEN,0),U))
 Q
