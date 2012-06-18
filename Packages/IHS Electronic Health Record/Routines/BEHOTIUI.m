BEHOTIUI ;MSC/IND/DKM - TIU inits;21-Nov-2007 11:56;DKM
 ;;1.1;BEH COMPONENTS;**015002**;Sep 18, 2007
 ;=================================================================
 ; Pre-init
PRE Q
 ; Post-init
POST N CCIEN,STIEN
 D REGMENU^BEHUTIL("BEHOTI MAIN",,"TIU")
 D REGMENU^BEHUTIL("BTIU MENU1",,"CLN","BEHOTI MAIN")
 D REGMENU^BEHUTIL("BTIU MENU2",,"HIS","BEHOTI MAIN")
 S CCIEN=$$FIND1^DIC(8930,,"X","CLINICAL COORDINATOR")
 S STIEN=$$FIND1^DIC(8925.6,,"X","ACTIVE")
 I $$NEWDEF("ANNOTATIONS","DC","PROGRESS NOTES"),$$NEWDEF("ANNOTATION","DOC","ANNOTATIONS")
 Q
 ; Create document definition if does not exist
NEWDEF(NAME,TYPE,PARENT) ;
 N IEN,FDA
 S PARENT=$$FIND1^DIC(8925.1,,"X",PARENT)
 S IEN=$$FIND1^DIC(8925.1,,"X",NAME)
 I 'IEN D
 .S FDA=$NA(FDA(8925.1,"+1,"))
 .S @FDA@(.01)=NAME
 .S @FDA@(.03)=NAME
 .S @FDA@(.04)=TYPE
 .S @FDA@(.06)=CCIEN
 .S @FDA@(.07)=STIEN
 .S @FDA@(3.02)=1
 .S @FDA@(99)=$H
 .S IEN=$$UPDATE("The following error occurred while trying to create document definition "_NAME_":")
 I IEN,PARENT,'$D(^TIU(8925.1,PARENT,10,"B",IEN)) D
 .S FDA=$NA(FDA(8925.14,"+1,"_PARENT_","))
 .S @FDA@(.01)=IEN
 .S @FDA@(2)="ANN"
 .I $$UPDATE("The following error occurred while trying to set the parent for document definition "_NAME_":")
 Q IEN
UPDATE(ERR) ;
 N IEN,MSG
 D UPDATE^DIE("","FDA","IEN","MSG")
 I $D(MSG("DIERR")) D
 .D BMES^XPDUTL(ERR)
 .S MSG=""
 .F  S MSG=$O(MSG("DIERR",1,"TEXT",MSG)) Q:MSG=""  D MES^XPDUTL(MSG("DIERR",1,"TEXT",MSG))
 .S IEN=0
 E  S IEN=IEN(1)
 K FDA
 Q IEN
