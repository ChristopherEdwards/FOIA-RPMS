BTIUP13 ; IHS/CIA/MGH - ENV CHECK FOR PATCH 1013;24-Mar-2015 15:19;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1013**;SEPT 04, 2005;Build 33
 ;
ENV ;EP environment check
 N PATCH,IN,STAT,INSTDA
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1012"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 S PATCH="BJPC*2.0*10"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 S PATCH="ATX*5.1*11"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
PRE ;EP; beginning of pret install code
 Q
POST ;EP; beginning of post install code
 N DTOUT,DUOUT,TIU,TIUFPRIV,TIUIEN,TIUMSG,TIUPRNT,TIUTMP S TIUFPRIV=1
 I $$LOOKUP(8930,"CLINICAL COORDINATOR","X")<0 W !!,"Installation Error:  CLASS OWNER cannot be defined." S XPDABORT=1 G EXIT
 I $$LOOKUP(8925.1,"RESCINDED ADVANCE DIRECTIVE","X")>0 W !!,"RESCINDED ADVANCE DIRECTIVE already exists." G EXIT
 F  D  Q:TIUPRNT>0!($D(XPDABORT))
 . W ! S TIUPRNT=$$LOOKUP(8925.1,,"AEQ","I $P(^(0),U,4)=""DC""","Select TIU DOCUMENT CLASS name for the new title RESCINDED ADVANCE DIRECTIVE:  ")
 . I $D(DTOUT) W !!,"Installation Aborted due to TIMEOUT." S XPDABORT=1 Q
 . I $D(DUOUT) W !!,"Installation Aborted by USER." S XPDABORT=1 Q
 . I TIUPRNT<0 W !!,"Installation Error:  Invalid Selection",!
 . I  W !,"A DOCUMENT CLASS must be entered or '^' to abort." Q
 . W ! I '$$READ^TIUU("Y","Is this correct","YES") S TIUPRNT=0
 I +$G(TIUPRNT)'>0 G EXIT
 S TIU(8925.1,"+1,",.01)="RESCINDED ADVANCE DIRECTIVE"
 S TIU(8925.1,"+1,",.02)=""
 S TIU(8925.1,"+1,",.03)="RESCINDED ADVANCE DIRECTIVE"
 S TIU(8925.1,"+1,",.04)="DOC"
 S TIU(8925.1,"+1,",.05)=""
 S TIU(8925.1,"+1,",.06)=$$LOOKUP(8930,"CLINICAL COORDINATOR")
 S TIU(8925.1,"+1,",.07)=13
 S TIU(8925.1,"+1,",3.02)=1
 S TIU(8925.1,"+1,",99)=$H
 W !!,"Creating RESCINDED ADVANCE DIRECTIVE title..."
 D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
 I $D(TIUMSG) D  S XPDABORT=1 G EXIT
 . W !!,"The following error message was returned:",!
 . S TIUMSG="" F  S TIUMSG=$O(TIUMSG("DIERR",1,"TEXT",TIUMSG)) Q:TIUMSG=""  W !,TIUMSG("DIERR",1,"TEXT",TIUMSG)
 W "DONE."
 S TIU(8925.14,"+2,"_TIUPRNT_",",.01)=TIUIEN(1)
 S TIU(8925.14,"+2,"_TIUPRNT_",",4)="Recinded Advance Directive"
 W !!,"Adding "_$P(^TIU(8925.1,TIUPRNT,0),U)_" as parent..."
 D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
 I $D(TIUMSG) D  S XPDABORT=1 G EXIT
 . W !!,"The following error message was returned:",!
 . S TIUMSG="" F  S TIUMSG=$O(TIUMSG("DIERR",1,"TEXT",TIUMSG)) Q:TIUMSG=""  W !,TIUMSG("DIERR",1,"TEXT",TIUMSG)
 W "DONE.",!
 S TIUIEN(TIUIEN(1))=TIUIEN(1)
 S TIU(8925.1,TIUIEN(1)_",",3)="TIUTMP"
 I $D(TIUMSG) D  S XPDABORT=1 G EXIT
 . W !!,"The following error message was returned:",!
 . S TIUMSG="" F  S TIUMSG=$O(TIUMSG("DIERR",1,"TEXT",TIUMSG)) Q:TIUMSG=""  W !,TIUMSG("DIERR",1,"TEXT",TIUMSG)
 W "DONE.",!
 W !,"*** The RESCINDED ADVANCE DIRECTIVE***"
 W !,"*** title must be activated before use.     ***"
EXIT D
 .N DIR,X,Y S DIR(0)="E" W ! D ^DIR
 Q
REM ;
 N TIUTMP
 S TIUTMP=$$LOOKUP(8925.1,"RESCINDED ADVANCE DIRECTIVE")
 I TIUTMP>0 S $P(^TIU(8925.1,TIUTMP,0),U,13)=0
 Q
LOOKUP(FILE,NAME,TYPE,SCREEN,PROMPT) ;
 ; file = file # to perform lookup on
 ; [name]   = for instance lookups - required if type is missing
 ; [type]   = for inquiries to file (eg: "AEQ") - required if name is missing
 ; [screen] = screen for lookup/inquiries
 ; [prompt] = replace default prompt
 ;
 N DIC,X,Y S DIC=$G(FILE),DIC("S")=$G(SCREEN),X=$G(NAME)
 I $D(TYPE) S DIC(0)=TYPE
 I $D(PROMPT) S DIC("A")=PROMPT
 D ^DIC
 Q +Y
 Q
 ;
