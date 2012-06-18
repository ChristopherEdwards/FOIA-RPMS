GMR1002P ; IHS/MSC/MGH - PRE-INSTALL ROUTINE FOR GMRA PATCH 1002 ;03-May-2011 17:18;DU
 ;;4.0;Adverse Reaction Tracking;**1002**;Mar 29, 1996;Build 32
 ;
ENV ;EP; environment check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="GMRA*4.0*1001"
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
 ;
 ;Post init which will loop through the 120.82 file and inactivate
 ;any allergies that are not national.
 ;Following that, it will loop through the patient allergy file and
 ;change any local allergies into free text ones so that they
 ;can be cleaned up
POST N IEN,INACTIVE,NAT,NAME,AIEN,FDA
 K ^TMP("GMRA",$J)
 S IEN=0 F  S IEN=$O(^GMRD(120.82,IEN)) Q:'+IEN  D
 .S NAT=$P($G(^GMRD(120.82,IEN,0)),U,3)
 .I NAT="" D
 ..S ^TMP("GMRA",$J,$P(^GMRD(120.82,IEN,0),U,1))=""
 ..S AIEN="+1,"_IEN_","
 ..S FDA(120.8299,AIEN,.01)=$$NOW^XLFDT
 ..S FDA(120.8299,AIEN,.02)=0
 ..D UPDATE^DIE(,"FDA","DIEN","ERR")
 K FDA,ERR,DIEN
 D CHANGE
 Q
CHANGE ;Using the items that were found to not be national allergies
 N ITEM,GIEN,ALL,AIEN,FDA
 S ITEM="" F  S ITEM=$O(^TMP("GMRA",$J,ITEM)) Q:ITEM=""  D
 .S IEN="" F  S IEN=$O(^GMR(120.8,"C",ITEM,IEN)) Q:IEN=""  D
 ..S ALL=$P(^GMR(120.8,IEN,0),U,2)
 ..S AIEN=IEN_","
 ..S FDA(120.8,AIEN,1)="1;GMRD(120.82,"
 ..D UPDATE^DIE(,"FDA","DIEN","ERR")
 Q
