BPXRMP4I ;IHS/CIA/MGH - Patch 4 inits. ;25-Sep-2006 14:16;MGH
 ;;1.5;CLINICAL REMINDERS;**1004**;Jun 19, 2000
 ;
ENV ;EP environment check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="PXRM*1.5*1001"
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
 D FIELD
 D TERMS
 Q
 ;
FIELD ;Store the National reminder parameter fields
 N ANS,X1,X2,DA,DR,DIE
 S ANS="Y"
 S DIE=800,DA=1,DR="6////Y;13////Y" D ^DIE
 S X1="www.DOMAIN.NAME/cio/crs/index.asp",X2="Clinical Reporting System"
 S DIE="^PXRM(800,1,1,",DA(1)=1,DA=1,DR=".01///"_X1_";.02///"_X2
 D ^DIE
 Q
TERMS ;Resequence the reminder finding types prompts to use the new prompts
 N TYP,NAME,PARRAY
 D PROMPTS
 S TYP=$$FIND1^DIC(801.45,,,"ED",,,"MSG")
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""   W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find the education FINDING TYPE"
 I '$D(MSG) D EDUC
 N MSG
 S TYP=$$FIND1^DIC(801.45,,,"IM",,,"MSG")
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find the immunization FINDING TYPE"
 I '$D(MSG) D IMM
 N MSG
 S TYP=$$FIND1^DIC(801.45,,,"ST",,,"MSG")
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find the skin test FINDING TYPE"
 I '$D(MSG) D SKN
 Q
PROMPTS ;Get the IENs of the prompts needed for the edit
 S PARRAY("PXRM COMMENT")=$O(^PXRMD(801.41,"B","PXRM COMMENT",""))
 S PARRAY("PXRM IMM REFUSED")=$O(^PXRMD(801.41,"B","PXRM IMM REFUSED",""))
 S PARRAY("PXRM IMM SITE")=$O(^PXRMD(801.41,"B","PXRM IMM SITE",""))
 S PARRAY("PXRM PED LENGTH")=$O(^PXRMD(801.41,"B","PXRM PED LENGTH",""))
 S PARRAY("PXRM IMM VIS DATE")=$O(^PXRMD(801.41,"B","PXRM IMM VIS DATE",""))
 S PARRAY("PXRM LEVEL OF UNDERSTANDING")=$O(^PXRMD(801.41,"B","PXRM LEVEL OF UNDERSTANDING",""))
 S PARRAY("PXRM PED REFUSED")=$O(^PXRMD(801.41,"B","PXRM PED REFUSED",""))
 S PARRAY("PXRM SKIN GIVEN")=$O(^PXRMD(801.41,"B","PXRM SKIN GIVEN",""))
 S PARRAY("PXRM LOT NUMBER")=$O(^PXRMD(801.41,"B","PXRM LOT NUMBER",""))
 S PARRAY("PXRM VOLUME")=$O(^PXRMD(801.41,"B","PXRM VOLUME",""))
 S PARRAY("PXRM OUTSIDE LOCATION")=$O(^PXRMD(801.41,"B","PXRM OUTSIDE LOCATION",""))
 S PARRAY("PXRM VISIT DATE")=$O(^PXRMD(801.41,"B","PXRM VISIT DATE",""))
 S PARRAY("PXRM SKIN READER")=$O(^PXRMD(801.41,"B","PXRM SKIN READER",""))
 S PARRAY("PXRM SKIN READ DATE")=$O(^PXRMD(801.41,"B","PXRM SKIN READ DATE",""))
 S PARRAY("PXRM READING")=$O(^PXRMD(801.41,"B","PXRM READING",""))
 S PARRAY("PXRM RESULT (SKIN TEST)")=$O(^PXRMD(801.41,"B","PXRM RESULT (SKIN TEST)",""))
 Q
EDUC ;Find the prompts for the education topics
 N STA,IENS,MSG
 S IENS=","_TYP_","
 S STA=$$FIND1^DIC(801.451,IENS,,"DONE AT ENCOUNTER",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find DONE AT ENCOUNTER for education FINDING TYPE"
 I '$D(MSG) D EDPR
 S STA=$$FIND1^DIC(801.451,IENS,,"PATIENT REFUSED",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find PATIENT REFUSED for eduction FINDING TYPE"
 I '$D(MSG) D EDREF
 Q
EDPR ; Replace the prompts needed for education topics
 N PMT,IENS,FDA,MSG,DA,DIK
 D DELETE
 ;Add the prompt level of understanding
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM LEVEL OF UNDERSTANDING"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the prompt length of education
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM PED LENGTH"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the prompt education refused
 S IENS="+3,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM PED REFUSED"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the comment prompt
 S IENS="+4,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM COMMENT"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 N MSG
 Q
EDREF ;Replace the prompts for refusing patient education
 N IENS,FDA,MSG
 D DELETE
 ;Add the education refused prompt
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM PED REFUSED"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the comment prompt
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM COMMENT"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 Q
IMM ;Find the prompts for the immunizations
 N STA,IENS
 S IENS=","_TYP_","
 S STA=$$FIND1^DIC(801.451,IENS,,"DONE AT ENCOUNTER",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 .W !!,"Unable to find DONE AT ENCOUNTER for immunization FINDING TYPE"
 I '$D(MSG) D IMMGIV
 N MSG
 S STA=$$FIND1^DIC(801.451,IENS,,"PATIENT REFUSED",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find PATIENT REFUSED for immunization FINDING TYPE"
 I '$D(MSG) D IMMREF
 Q
IMMGIV ; Replace prompts for getting immunization at encounter
 N IENS,FDA,MSG
 D DELETE
 ;Add lot number prompt
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM LOT NUMBER"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add immunization site prompt
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM SITE"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add immunization volume prompt
 S IENS="+3,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM VOLUME"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the VIS date prompt
 S IENS="+4,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM VIS DATE"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the comment prompt
 S IENS="+5,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM COMMENT"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 Q
IMMREF ; Replace prompts for refusing immunization
 N IENS,FDA,MSG
 D DELETE
 ;Add the immunization refused prompt
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM REFUSED"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the comment prompt
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM COMMENT"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
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
 ;Add the result prompt
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM RESULT (SKIN TEST)"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the reading prompt
 S IENS="+3,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM READING"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ; Add the read date prompt
 S IENS="+4,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SKIN READ DATE"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the reader's name prompt
 S IENS="+5,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM SKIN READER"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the comment prompt
 S IENS="+6,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM COMMENT"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
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
