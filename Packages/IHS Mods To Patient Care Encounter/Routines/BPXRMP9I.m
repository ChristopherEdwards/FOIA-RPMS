BPXRMP9I ;IHS/CIA/MGH - Patch 9 inits. ;15-Apr-2013 15:58;DU
 ;;1.5;CLINICAL REMINDERS;**1009**;Jun 19, 2000;Build 24
 ;
ENV ;EP environment check
 N IN,PATCH,INSTDA,STAT
 ;Check for the installation of the EHR
 S IN="EHR*1.1*10",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR PATCH 10 before this patch" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR PATCH 10 must be completely installed before installing this patch." S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="PXRM*1.5*1008"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="PIMS*5.3*1015"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="BRA*5.0*1003"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="LR*5.2*1031"
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
 ;===============================================================
PRE ;EP Pre-inits
 Q
 ;
 ;===============================================================
POST ;EP Post-inits
 D DELIXN^DDMOD(9000010.01,"ACR","K","","MSG")
 D DELIXN^DDMOD(9000010.08,"ACR","K","","MSG")
 D CVFILE^BPXRM09I
 D TERMS
 D DIALOG
 Q
TERMS ;Resequence the reminder finding types prompts to use the new prompts
 N MSG,TYP,PARRAY
 D PROMPTS
 S TYP=$$FIND1^DIC(801.45,,,"ST",,,"MSG")
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find the skin test FINDING TYPE"
 I '$D(MSG) D SKN
 Q
PROMPTS ;
 S PARRAY("PXRM COMMENT")=$O(^PXRMD(801.41,"B","PXRM COMMENT",""))
 S PARRAY("PXRM SKIN GIVEN")=$O(^PXRMD(801.41,"B","PXRM SKIN GIVEN",""))
 S PARRAY("PXRM SKIN READER")=$O(^PXRMD(801.41,"B","PXRM SKIN READER",""))
 S PARRAY("PXRM SKIN READ DATE")=$O(^PXRMD(801.41,"B","PXRM SKIN READ DATE",""))
 S PARRAY("PXRM READING")=$O(^PXRMD(801.41,"B","PXRM READING",""))
 S PARRAY("PXRM RESULT (SKIN TEST)")=$O(^PXRMD(801.41,"B","PXRM RESULT (SKIN TEST)",""))
 S PARRAY("PXRM SKIN VOLUME")=$O(^PXRMD(801.41,"B","PXRM SKIN VOLUME",""))
 S PARRAY("PXRM SKIN SITE")=$O(^PXRMD(801.41,"B","PXRM SKIN SITE",""))
 Q
SKN ;Find the prompts for the skin tests
 N STA,IENS
 S IENS=","_TYP_","
 S STA=$$FIND1^DIC(801.451,IENS,,"DONE AT ENCOUNTER",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 .W !!,"Unable to find DONE AT ENCOUNTER for skin test FINDING TYPE"
 I '$D(MSG) D SKGIV
 Q
SKGIV ; Replace prompts for skin test given at encounter
 N IENS,FDA,MSG
 D DELETE
 ;Add the skin test given date prompt
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SKIN GIVEN"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the Site prompt
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SKIN SITE"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the Volume prompt
 S IENS="+3,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SKIN VOLUME"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the result prompt
 S IENS="+4,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM RESULT (SKIN TEST)"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the reading prompt
 S IENS="+5,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM READING"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ; Add the read date prompt
 S IENS="+6,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SKIN READ DATE"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the reader's name prompt
 S IENS="+7,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SKIN READER"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the comment prompt
 S IENS="+8,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM COMMENT"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 Q
DELETE ;Delete the subnodes
 N PMT,DA,DIK
 S PMT=0 F  S PMT=$O(^PXRMD(801.45,TYP,1,STA,5,PMT)) Q:PMT=""  D
 .S DA(2)=TYP,DA(1)=STA,DA=PMT
 .S DIK="^PXRMD(801.45,"_TYP_",1,"_STA_",5,"
 .D ^DIK
 Q
MSG ;Print out the message
 W !!,"The following error message was returned:",!!
 S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 W !!,"Unable to add a prompt to FINDING NUMBER "_TYP_" Prompt may have to be added manually."
 N MSG
 Q
DIALOG ;Update the dialog prompt
 N IEN,GUI,FDA,IENS,MSG
 S IEN=0,GUI=0
 S IEN=$O(^PXRMD(801.41,"B","PXRM SKIN VOLUME",IEN)) Q:'+IEN  D
 .S GUI=$O(^PXRMD(801.42,"B","SK_VOL",GUI)) Q:'+GUI  D
 ..S IENS=IEN_","
 ..S FDA(801.41,IENS,46)=GUI
 ..D UPDATE^DIE("","FDA","IENS","MSG")
 ..I $D(MSG) D MSG2
 K FDA,IENS,MSG
 S IEN=0,GUI=0
 S IEN=$O(^PXRMD(801.41,"B","PXRM SKIN SITE",IEN)) Q:'+IEN  D
 .S GUI=$O(^PXRMD(801.42,"B","SK_SITE",GUI)) Q:'+GUI  D
 ..S IENS=IEN_","
 ..S FDA(801.41,IENS,46)=GUI
 ..D UPDATE^DIE("","FDA","IENS","MSG")
 ..I $D(MSG) D MSG2
 K FDA,IENS,MSG
 Q
MSG2 ;Print out the message
 W !!,"The following error message was returned:",!!
 S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 W !!,"Unable to add a GUI PROCESS to FINDING NUMBER "_IEN_" GUI process may have to be added manually."
