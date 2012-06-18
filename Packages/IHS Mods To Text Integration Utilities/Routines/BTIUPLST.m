BTIUPLST ; IHS/ITSC/LJF - Enter/edit personal document pick-list ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;IHS version of TIUPLST
 ;    -- changed intro text and how it is called
 ;    -- allowed user holding TIUZCMGR key to edit other users' lists
 ;    -- removed create another list if user already has one
 ;    -- changed input template so timestamp xref would be fired
 ;
MAIN ; Control branching
 N DA,TIUFPRIV,TIUDUZ
 S TIUFPRIV=1
 D INTROTXT
 D GETEDIT
 Q
INTROTXT ; Write Introductory Text for the Option
 D ^XBCLS
 D JUSTIFY^TIUU("--- Personal Document Lists ---","C")
 D MSG^BTIUU(" ",1,0,0)
 F I=1:1 S X=$P($T(HELP+I),";;",2) Q:X=""  D MSG^BTIUU(X,1,0,0)
 D MSG^BTIUU(" ",1,0,0)
 Q
 ;
HELP ;;
 ;;Use this option to maintain your personal list of frequently used;;
 ;;document titles.  You can enter up to 18 titles on your list.  In;;
 ;;the event you need to select a title not on your personal list,;;
 ;;that option will always be able to you.;;
 Q
GETEDIT ; Get record in picklist file, determine action
 N DIC,X,Y,CREATE,PROMPT
 S TIUDUZ=$$SETDUZ Q:TIUDUZ<1
 S X=$P(^VA(200,+$G(TIUDUZ),0),U)
 W !,"   Enter/edit Personal Document List for "
 W $$NAME^TIULS(X,"FIRST LAST")
 I +$O(^TIU(8925.98,"B",TIUDUZ,0))'>0 D  Q
 . S Y=+$$NEWLIST(X,1)
 . I +Y>0 S DA=+Y D EDIT
 I TIUDUZ=DUZ W !!,"You already have a Personal List...",!
 E  W !!,"This TIU user already has a Personal List...",!
 S PROMPT="You may (E)dit, or (D)elete the List: "
 S CREATE=$P($$READ^TIUU("SA^E:edit;D:delete",PROMPT,"EDIT"),U)
 I CREATE="" Q
 S Y=$O(^TIU(8925.98,"B",TIUDUZ,0))
 I CREATE="D" D DELETE(+Y) Q
 S DA=+Y D EDIT
 Q
NEWLIST(X,ASK) ; Create a new List for the user
 N ASKNEW,DIC,DLAYGO,Y S (DIC,DLAYGO)=8925.98,DIC(0)="ELMZ",ASKNEW=1
 I +$G(ASK) S ASKNEW=$$READ^TIUU("Y","Add a new Personal Document List","YES")
 I +ASKNEW'>0 S Y=-1 G NEWX
 S X=""""_X_"""",DIC(0)="LXZ",DIC("DR")=".02////38" D ^DIC
NEWX Q +$G(Y)
 ;
DELETE(DA) ; Call ^DIK to delete the list
 N DIK,YASURE,TIUNAME S YASURE=0
 S TIUNAME=$$UP^XLFSTR($$PNAME^TIULC1($P(^TIU(8925.98,+DA,0),U,2)))
 W !!,"You are about to delete your entry for CLASS "
 W TIUNAME,!
 S YASURE=$$READ^TIUU("Y","Are you SURE","NO")
 I +YASURE'>0 W !,"Nothing deleted...No harm done!" Q
 S DIK="^TIU(8925.98,"
 D ^DIK
 W !,TIUNAME," List DELETED."
 Q
EDIT ; Call ^DIE to edit the record
 N DIE,DR,TIUCLASS,TIUASK
 S DIE=8925.98
 ;S DR="[TIU ENTER/EDIT PERSONAL LIST]"  ;original VA
 S DR="[BTIU PERSONAL LIST EDIT]"        ;use IHS input template
 D ^DIE
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
SETDUZ() ; -- returns user to edit
 I '$D(^XUSEC("TIUZCMGR",DUZ)) Q DUZ
 NEW DIC,Y
 S DIC=200,DIC(0)="AEMQZ",DIC("A")="Select TIU User: " D ^DIC Q +Y
