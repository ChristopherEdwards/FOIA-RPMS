BPXRM202 ; IHS/MSC/MGH - Version 2.0 Patch 2 post routine. ;19-Aug-2013 16:59;DU
 ;;2.0;CLINICAL REMINDERS;**1002**;Feb 04, 2005;Build 15
 ;
ENV ;EP environment check
 N IN,INSTDA,STAT
 ;Check for the installation of Reminders 2.0
 S IN="CLINICAL REMINDERS 2.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install CLINICAL REMINDERS 2.0 before this patch" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"CLINICAL REMINDERS 2.0 must be completely installed before installing this patch." S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;Check for the installation of other patches
 S PATCH="PXRM*2.0*1001"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
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
 ;===============================================================
PRE ;EP pre-init
 Q
 ;===============================================================
POST ;Post-install
 D TERMS
 D DIALOG
 D INACT
 D CNAK
 Q
 ;================================================================
TERMS ;Resequence the reminder finding types prompts to use the new prompts
 N MSG,TYP,PARRAY
 D PROMPTS
 S TYP=$$FIND1^DIC(801.45,,,"IM",,,"MSG")
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find the Immunization FINDING TYPE"
 I '$D(MSG) D IMM
 Q
PROMPTS ;
 S PARRAY("PXRM LOT NUMBER")=$O(^PXRMD(801.41,"B","PXRM LOT NUMBER",""))
 S PARRAY("PXRM IMM SITE")=$O(^PXRMD(801.41,"B","PXRM IMM SITE",""))
 S PARRAY("PXRM VOLUME")=$O(^PXRMD(801.41,"B","PXRM VOLUME",""))
 S PARRAY("PXRM IMM VIS DATE")=$O(^PXRMD(801.41,"B","PXRM IMM VIS DATE",""))
 S PARRAY("PXRM SERIES")=$O(^PXRMD(801.41,"B","PXRM SERIES",""))
 S PARRAY("PXRM CONTRAINDICATED")=$O(^PXRMD(801.41,"B","PXRM CONTRAINDICATED",""))
 S PARRAY("PXRM REACTION")=$O(^PXRMD(801.41,"B","PXRM REACTION",""))
 S PARRAY("PXRM IMM ELIG")=$O(^PXRMD(801.41,"B","PXRM IMM ELIG",""))
 S PARRAY("PXRM ADMIN NOTES")=$O(^PXRMD(801.41,"B","PXRM ADMIN NOTES",""))
 Q
IMM ;Find the prompts for the Immunizations
 N STA,IENS
 S IENS=","_TYP_","
 S STA=$$FIND1^DIC(801.451,IENS,,"DONE AT ENCOUNTER",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 .W !!,"Unable to find DONE AT ENCOUNTER for Immunization FINDING TYPE"
 I '$D(MSG) D IMMGIV
 Q
IMMGIV ; Replace prompts for Immunization given at encounter
 N IENS,FDA,MSG
 D DELETE
 ;Add the lot number prompt
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM LOT NUMBER"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the Site prompt
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM SITE"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the Volume prompt
 S IENS="+3,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM VOLUME"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the Vis DATE prompt
 S IENS="+4,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM VIS DATE"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the elig prompt
 S IENS="+5,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM ELIG"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ; Add the series
 S IENS="+6,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SERIES"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the reaction prompt
 S IENS="+7,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM REACTION"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the contraindicated prompt
 S IENS="+8,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM CONTRAINDICATED"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the admin notes prompt
 S IENS="+9,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM ADMIN NOTES"))
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
 S IEN=$O(^PXRMD(801.41,"B","PXRM IMM ELIG",IEN)) Q:'+IEN  D
 .S GUI=$O(^PXRMD(801.42,"B","IMM_ELIG",GUI)) Q:'+GUI  D
 ..S IENS=IEN_","
 ..S FDA(801.41,IENS,46)=GUI
 ..D UPDATE^DIE("","FDA","IENS","MSG")
 ..I $D(MSG) D MSG2
 K FDA,IENS,MSG
 S IEN=0,GUI=0
 S IEN=$O(^PXRMD(801.41,"B","PXRM ADMIN NOTES",IEN)) Q:'+IEN  D
 .S GUI=$O(^PXRMD(801.42,"B","IMM_NTS",GUI)) Q:'+GUI  D
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
 Q
 ;
INACT ;Inactivate items
 N IEN,I,IENS
 F I="IHS-ANTICOAG CBC 2011","IHS-ANTICOAG OCCULT BLOOD 2011","IHS-ANTICOAG UA 2011","IHS-PPD 2012" D
 .S IEN="" S IEN=$O(^PXD(811.9,"B",I,IEN)) Q:IEN=""  D
 ..N FDA,ERR
 ..S IENS=IEN_","
 ..S FDA(811.9,IENS,1.6)=1
 ..D FILE^DIE("","FDA","ERR")
 Q
 ;===============================================================
CNAK ;Make sure all "NAK" characters are converted back to "^" in
 ;the Exchange File.
 N IEN,TEXT
 D BMES^XPDUTL("Clean up Exchange File entries")
 S IEN=0
 F  S IEN=+$O(^PXD(811.8,IEN)) Q:IEN=0  D
 . D POSTKIDS^PXRMEXU5(IEN)
 Q
 ;
 ;===============================================================
DELEI ;If the Exchange File entry already exists delete it.
 N ARRAY,IC,IND,LIST,LUVALUE,NUM
 S IC=0
 F  S IC=$O(ARRAY(IC)) Q:'IC  D
 .S LUVALUE(1)=ARRAY(IC,1)
 .D FIND^DIC(811.8,"","","U",.LUVALUE,"","","","","LIST")
 .I '$D(LIST) Q
 .S NUM=$P(LIST("DILIST",0),U,1)
 .I NUM'=0 D
 ..F IND=1:1:NUM D
 ... N DA,DIK
 ... S DIK="^PXD(811.8,"
 ... S DA=LIST("DILIST",2,IND)
 ... D ^DIK
 Q
 ;
