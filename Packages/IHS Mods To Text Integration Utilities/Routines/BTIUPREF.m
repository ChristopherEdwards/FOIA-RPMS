BTIUPREF ; IHS/ITSC/LJF - Enter/edit personal preferences ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;Copy of ^TIUPREF
 ;   -- joined 2 VA menu options into one by adding MENU code below
 ;   -- only those with TIUZPPR key can edit other people's preferences
 ;   -- modified DR string in EDIT
 ;   -- removed code to say for which notes user needs cosignature (done other places)
 ;
MENU ; ask user which option to run
 S Y=$$READ^TIUU("SO^1:Personal Preferences;2:Document List Management")
 Q:Y<1  I +Y=2 D ^BTIUPLST Q
 ;
MAIN ; Control branching
 NEW DA,TIUDUZ
 S DA=+$$GETREC
 I +DA'>0 Q
 D EDIT(DA)
 Q
GETREC() ; Get record in picklist file
 S TIUDUZ=$$SETDUZ I TIUDUZ<1 Q TIUDUZ
 N DIC,DLAYGO,X,Y,ASKNEW
 S (DIC,DLAYGO)=8926,DIC(0)="ELMZQ"
 S X=$P(^VA(200,+$G(TIUDUZ),0),U)
 W !,"   Enter/edit Personal Preferences for ",X
 D ^DIC
 Q +$G(Y)
EDIT(DA) ; Call ^DIE to edit the record
 N DIE,DR,TIUCLASS
 S DIE=8926,TIUREQCS=$$REQCOS^TIUPREF(DA)
 S DR=".02:.08;.1;.11;I +TIUREQCS'>0 S Y=""@1"";.09;@1;1"
 S DR(2,8926.01)=".01;.02;.03" D ^DIE
 Q
 ;
SETDUZ() ; -- returns user to edit
 I '$D(^XUSEC("TIUZPPR",DUZ)) Q DUZ
 S DIC=200,DIC(0)="AQMEZ",DIC("A")="Select TIU User: " D ^DIC Q +Y
