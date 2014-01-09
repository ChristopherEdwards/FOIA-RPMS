BPXRMP8I ;IHS/CIA/MGH - Patch 8 inits. ;12-Jan-2012 13:17;DU
 ;;1.5;CLINICAL REMINDERS;**1008**;Jun 19, 2000;Build 25
 ;
ENV ;EP environment check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="PXRM*1.5*1007"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="BJPC*2.0*7"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="BI*8.4*2"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 N IN,PATCH,INSTDA,STAT
 ;Check for the installation of the ICARE
 S IN="ICARE MANAGEMENT SYSTEM 2.1",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the ICARE 2.1 before this patch" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"ICARE 2.1 must be completely installed before installing this patch." S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 S IN="EHR*1.1*8",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR patch 8 before installing patch TIU patch 1009" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR patch 8 must be completely installed before installing TIU patch 1009" S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
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
 D DELEI^BPXRMP8D  ;delete old entries in exchange file
 Q
 ;
 ;===============================================================
POST ;EP Post-inits
 F I=1:1:200 D POSTKIDS^PXRMEXU5(I)
 D TERMS
 N X1,X2,DIE,DA,DR
 S X1="http://www.ihs.gov/cio/crs/",X2="Clinical Reporting System"
 S DIE="^PXRM(800,1,1,",DA(1)=1,DA=1,DR=".01///"_X1_";.02///"_X2
 D ^DIE
 Q
 ;
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
 S TYP=$$FIND1^DIC(801.45,,,"AS",,,"MSG")
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find the asthma FINDING TYPE"
 I '$D(MSG) D ASM
 Q
PROMPTS ;Get the IENs of the prompts needed for the edit
 S PARRAY("PXRM COMMENT")=$O(^PXRMD(801.41,"B","PXRM COMMENT",""))
 S PARRAY("PXRM IMM SITE")=$O(^PXRMD(801.41,"B","PXRM IMM SITE",""))
 S PARRAY("PXRM PED LENGTH")=$O(^PXRMD(801.41,"B","PXRM PED LENGTH",""))
 S PARRAY("PXRM PED READY TO LEARN")=$O(^PXRMD(801.41,"B","PXRM PED READY TO LEARN",""))
 S PARRAY("PXRM IMM VIS DATE")=$O(^PXRMD(801.41,"B","PXRM IMM VIS DATE",""))
 S PARRAY("PXRM LEVEL OF UNDERSTANDING")=$O(^PXRMD(801.41,"B","PXRM LEVEL OF UNDERSTANDING",""))
 S PARRAY("PXRM LOT NUMBER")=$O(^PXRMD(801.41,"B","PXRM LOT NUMBER",""))
 S PARRAY("PXRM VOLUME")=$O(^PXRMD(801.41,"B","PXRM VOLUME",""))
 S PARRAY("PXRM OUTSIDE LOCATION")=$O(^PXRMD(801.41,"B","PXRM OUTSIDE LOCATION",""))
 S PARRAY("PXRM VISIT DATE")=$O(^PXRMD(801.41,"B","PXRM VISIT DATE",""))
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
 ;Add the prompt for readiness to learn
 S IENS="+3,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM PED READY TO LEARN"))
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
ASM ;Find the prompts for the asthma
 N STA,IENS,MSG
 S IENS=","_TYP_","
 S STA=$$FIND1^DIC(801.451,IENS,,"DONE AT ENCOUNTER",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 . W !!,"Unable to find DONE AT ENCOUNTER for asthma FINDING TYPE"
 I '$D(MSG) D ASPR
 Q
ASPR ;Replace the prompts for refusing patient education
 N IENS,FDA,MSG
 D DELETE
 ;Add the comment prompt
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM COMMENT"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 Q
IMM ;Find the prompts for the immunizations
 Q
 N STA,IENS
 S IENS=","_TYP_","
 S STA=$$FIND1^DIC(801.451,IENS,,"DONE ELSEWHERE (HISTORICAL)",,,.MSG)
 I $D(MSG) D  Q
 . W !!,"The following error message was returned:",!!
 . S MSG="" F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  W MSG("DIERR",1,"TEXT",MSG),!
 .W !!,"Unable to find DONE ELSEWHERE for immunization FINDING TYPE"
 I '$D(MSG) D IMMGIV
 Q
IMMGIV ; Replace prompts for getting immunization at encounter
 N IENS,FDA,MSG
 D DELETE
 ;Add Date prompt
 S IENS="+1,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM VISIT DATE"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add location prompt
 S IENS="+2,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM OUTSIDE LOCATION"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add lot number prompt
 S IENS="+3,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM LOT NUMBER"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add immunization site prompt
 S IENS="+4,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM SITE"))
 S FDA(801.4515,IENS,1)=1
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the VIS date prompt
 S IENS="+5,"_STA_","_TYP_","
 S FDA(801.4515,IENS,.01)=$G(PARRAY("PXRM IMM VIS DATE"))
 S FDA(801.4515,IENS,5)=1
 D UPDATE^DIE("","FDA","IENS","MSG")
 I $D(MSG) D MSG
 ;Add the comment prompt
 S IENS="+6,"_STA_","_TYP_","
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
