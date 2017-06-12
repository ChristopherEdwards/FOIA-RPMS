GMRV1002 ;IHS/MSC/MGH - Patch support;26-Jul-2013 11:11;DU
 ;;5.0;GEN. MED. REC. - VITALS;**1002**;Mar 29, 1996;Build 5
 ;
ENV ;EP -
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="XU*8.0*1016"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="GMRV*5.0*1001"
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
 ;stroke qualifiers
 F I="BASELINE","24HRS POST ONSET OF SYMPTOMS","2 HRS POST THROMBOLYTIC","7-10 DAYS","3 MONTHS","DISCHARGE/TRANSFER","PLUS/MINUS 20 MINUTES" D
 .S NAME=I
 .S IEN=$O(^GMRD(120.52,"B",NAME,""))
 .Q:'IEN
 .K ^GMRD(120.52,IEN,1)
 .S IENS="+1,"_IEN_","
 .S FDA(120.521,IENS,.01)="NSST"
 .S FDA(120.521,IENS,.02)="STROKE"
 .D UPDATE^DIE("E","FDA","IENS","ERRR(1)")
 .I $D(ERRR) D MES^XPDUTL("Error updating qualifier "_$P(^GMRD(120.52,IEN,0),U))
 K FDA,IENS,ERRR
 ;left and right locations
 F I="LEFT","RIGHT" D
 .S NAME=I
 .S IEN=$O(^GMRD(120.52,"B",NAME,""))
 .Q:'IEN
 .K ^GMRD(120.52,IEN,2)
 .S AIEN="+1,"_IEN_","
 .S FDA(120.521,AIEN,.01)="CDR"
 .S FDA(120.521,AIEN,.02)="SITE"
 .S IENS(1)=2
 .D UPDATE^DIE("E","FDA","","ERRR(1)")
 .I $D(ERRR) D MES^XPDUTL("Error updating qualifier "_$P(^GMRD(120.52,IEN,0),U))
 ;temp qualifier
 S NAME="TEMPORAL"
 .S IEN=$O(^GMRD(120.52,"B",NAME,""))
 .Q:'IEN
 .K ^GMRD(120.52,IEN,1)
 .S AIEN="+1,"_IEN_","
 .S FDA(120.521,AIEN,.01)="TMP"
 .S FDA(120.521,AIEN,.02)="LOCATION"
 .S IENS(1)=2
 .D UPDATE^DIE("E","FDA","","ERRR(1)")
 .I $D(ERRR) D MES^XPDUTL("Error updating qualifier "_$P(^GMRD(120.52,IEN,0),U))
 Q
