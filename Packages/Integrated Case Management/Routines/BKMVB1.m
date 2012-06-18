BKMVB1 ;PRXM/HC/JGH - User Management Utilities ; 25 May 2005  3:40 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;;all fileman variables are cleaned up by calling XBFMK
 ;
 Q  ; This routine must be invoked using a tag.
 ; 
ADSUSER(ACTION) ; EP - Add/edit/delete a user to the list of register users
 ; ACTION is set to A, E or D, respectively
 ;
 ; Variables:
 ;  HIVIEN = IEN of HMS System
 ;  USER = IEN of User in File #200 or HMS User record #.01 Field, File #90450.011
 ;  BKMUSER = IEN of HMS User in File #90450.011
 ;  OCCUP = Access Role of User in HMS System
 ;
 ; Check for the entering user's security to add/edit/delete HMS users
 ; Removed this check as key check is sufficient
 ; I '$$VALID^BKMIXX3(DUZ) D  Q
 ;. W !!,?5,"**You are not a valid HMS user. Please contact your IRM.**",! H 2
 ;. S EXIT=$$PAUSE^BKMIXX3()
 ;I DUZ(0)'="@"&('$D(^XUSEC("XUMGR",DUZ))) D  I KEYCHK=1 Q ; EEN TOOK OUT, MUST HAVE DELEGATION RIGHTS
 S KEYCHK=0,KEYIEN=""
 F KEY="BKMVZMENU","BKMVZED","BKMVZRD","BKMVZCFM" S KEYIEN=$O(^DIC(19.1,"B",KEY,"")) D
 . I '$D(^VA(200,DUZ,52,KEYIEN,0)) S KEYCHK=1
 I KEYCHK=1 D  Q
 . W !!,?5,"**You do not currently have access to edit HMS Users.**",!,?5,"**See your Site Manager or other IT staff for assistance.**",! H 2
 . S EXIT=$$PAUSE^BKMIXX3()
 ;
 NEW USER,OCCUP
 D @ACTION
 Q
 ;
ADSPRMP() ; Prompt to user to Add/Delete/Edit a user in the HIV management system
 K DIR
 S DIR(0)="SB^A:ADD;E:Edit;D:Delete"
 S DIR("A")="(A)dd, (E)dit or (D)elete Another User?"
 D ^DIR
 K DIR
 I $D(DTOUT)!$D(DUOUT) Q ""
 QUIT Y
 ;
GETUSER()   ;Select a User to Add to the HMS System
 K DIC,GETDFN,DTOUT,DUOUT,USER
 S DIC="^VA(200,",DIC(0)="AEQ"
 S DIC("A")="Select User Name: "
 D ^DIC
 I $D(DTOUT)!$D(DUOUT) Q 0
 I $G(Y)<1 Q 0
 S GETDFN=$P(Y,U,2),IEN=+Y
 Q:IEN'>0 0
 S USER=+Y
 K DIC,DUOUT,DTOUT
 QUIT 1
 ;
GETUSER2() ;Select a User to Edit/Delete from HMS System
 K DIC,GETDFN,DTOUT,DUOUT,USER
 S DIC="^BKM(90450,"_HIVIEN_",11,",DIC(0)="AEQ"
 S DIC("A")="Select User Name: "
 D ^DIC
 I $D(DTOUT)!$D(DUOUT) Q 0
 I $G(Y)<1 Q 0
 S BKMUSER=$P(Y,U,1)
 S USER=$P(Y,U,2)
 K DIC,DUOUT,DTOUT
 QUIT 1
 ;
GETOCCUP(Y) ;Prompt for Selecting an access role for User
 S DIR(0)="S^C:Case File Manager;E:Editor;R:Reader"  ;_$P(^DD(90450.011,.5,0),U,3)
 S DIR("A")="Access Role"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q 0
 QUIT 1
 ;
CREATE ;Create a New User Record in HMS System
 D ^XBFMK ; Kills off a lot of Fileman variables
 K BKMUSER
 I '$D(^BKM(90450,1,11,0)) S ^BKM(90450,1,11,0)="^90450.011P^^"
 S X=USER,DA(1)=HIVIEN
 S DIC(0)="L",DIC("DR")=".01////"
 S (DIC)="^BKM(90450,"_DA(1)_",11,",DLAYGO=90450.011
 D FILE^DICN
 I $P(Y,U,3)'=1 W !!,"User ",$$GET1^DIQ(200,USER,.01,"E")," was not added.",! Q
 S BKMUSER=$P(Y,U,1)
 D ^XBFMK K DIFILE,X
 QUIT
 ;
SETOCCUP ;Set access role for User in HMS System
 D ^XBFMK
 S DA(1)=HIVIEN,DA=BKMUSER
 S DR=".5////"_OCCUP
 S DIE="^BKM(90450,"_DA(1)_",11,"
 D ^DIE
 D ^XBFMK
 QUIT
 ;
ASSIGNKS ;Assigns Security Keys by access role
 ; Variable:
 ;  KEY = Name of Security Key in File #19.1
 ;
 NEW KEY,ADD
 I OCCUP="R" D  ; U Reader
 . F KEY="BKMVZRD","BKMVZMENU" S ADD=$$ADDKEY(KEY)
 ELSE  I OCCUP="E" D  ; A Editor 
 . F KEY="BKMVZED","BKMVZRD","BKMVZMENU" S ADD=$$ADDKEY(KEY)
 ELSE  I OCCUP="C" D  ; S Case File Manager
 . F KEY="BKMVZCFM","BKMVZED","BKMVZRD","BKMVZMENU" S ADD=$$ADDKEY(KEY)
 QUIT
 ;
ADDKEY(KEY) ;Add Security Keys for User in File #200
 ; Variables:
 ;  KEYIEN = IEN of Security Key in File #19.1
 ;  KEY = Name of Security Key in File #19.1
 ;
 NEW KEYIEN
 D ^XBFMK ; Kills off a lot of Fileman variables
 S KEYIEN=$O(^DIC(19.1,"B",KEY,""))
 I KEYIEN="" Q 0
 I '$D(^VA(200,USER,51,0)) S ^VA(200,USER,51,0)="^200.051PA^^"
 I $D(^VA(200,USER,51,"B",KEYIEN)) Q 0  ; They already have the key
 S X=KEYIEN,DA(1)=USER,DINUM=KEYIEN
 S DIC(0)="L",DIC("DR")=".01///"
 S DIC="^VA(200,"_DA(1)_",51,",DLAYGO=200.051
 D FILE^DICN
 ; If User is a Case File Manager, also give delegation of HMS keys
 I OCCUP="C" D
 . D ^XBFMK
 . I '$D(^VA(200,USER,52,0)) S ^VA(200,USER,52,0)="^200.052PA^^"
 . I $D(^VA(200,USER,52,"B",KEYIEN)) Q
 . S X=KEYIEN,DA(1)=USER,DINUM=KEYIEN
 . S DIC(0)="L",DIC("DR")=".01///"
 . S DIC="^VA(200,"_DA(1)_",52,",DLAYGO=200.052
 . D FILE^DICN
 D ^XBFMK
 QUIT 1
 ;
DELUSER ;Delete User from HMS System
 D ^XBFMK ; Kills off a lot of Fileman variables
 S DA(1)=HIVIEN,DA=BKMUSER,DIK="^BKM(90450,"_DA(1)_",11,"
 D ^DIK
 D ^XBFMK
 QUIT
 ;
DELKEYS ;Delete all HMS System Security Keys from User
 ; Variable:
 ;  KEY = Name of Security Key in File #19.1
 ;  
 ;NEW KEYIEN,KEY
 ;S KEYIEN=""
 ;F  S KEYIEN=$O(^VA(200,USER,51,"B",KEYIEN)) Q:KEYIEN=""  D
 ;. S KEY=$$GET1^DIQ(19.1,KEYIEN,.01,"E")
 ;. I $E(KEY,1,5)="BKMVZ" D
 ;. . D ^XBFMK
 ;. . S DA(1)=USER,DA=KEYIEN,DIK="^VA(200,"_DA(1)_",51,"
 ;. . D ^DIK
 NEW KEY,DIK,KEYIEN,VAIEN,DA ; Changed 9/20/05 ALA
 S KEY="BKMVZ",DA(1)=USER,DIK="^VA(200,"_DA(1)_",51,"
 F  S KEY=$O(^DIC(19.1,"B",KEY)) Q:KEY=""!($E(KEY,1,5)'="BKMVZ")  D
 . S KEYIEN=$O(^DIC(19.1,"B",KEY,""))
 . S VAIEN=$O(^VA(200,USER,51,"B",KEYIEN,""))
 . Q:VAIEN=""
 . S DA(1)=USER,DA=VAIEN
 . D ^DIK
 . K DA
 ;
 ; Check and delete any HMS Delegation Keys from User
 ;S KEYIEN=""
 ;F  S KEYIEN=$O(^VA(200,USER,52,"B",KEYIEN)) Q:KEYIEN=""  D
 ;. S KEY=$$GET1^DIQ(19.1,KEYIEN,.01,"E")
 ;. I $E(KEY,1,5)="BKMVZ" D
 ;. . D ^XBFMK
 ;. . S DA(1)=USER,DA=KEYIEN,DIK="^VA(200,"_DA(1)_",52,"
 ;. . D ^DIK
 NEW KEY,DIK,KEYIEN,VAIEN,DA ; Changed 9/20/05 ALA
 S KEY="BKMVZ",DA(1)=USER,DIK="^VA(200,"_DA(1)_",51,"
 F  S KEY=$O(^DIC(19.1,"B",KEY)) Q:KEY=""!($E(KEY,1,5)'="BKMVZ")  D
 . S KEYIEN=$O(^DIC(19.1,"B",KEY,""))
 . S VAIEN=$O(^VA(200,USER,52,"B",KEYIEN,""))
 . Q:VAIEN=""
 . S DA(1)=USER,DA=VAIEN
 . D ^DIK
 . K DA
 QUIT
 ;
A ;Add a User
 I '$$GETUSER Q
 I $D(^BKM(90450,HIVIEN,11,"B",USER)) D  Q
 . W !!,$$GET1^DIQ(200,USER,.01,"E")," is already an HMS user.",!
 S DIR(0)="YA"
 S DIR("A")="Add "_$$GET1^DIQ(200,USER,.01,"E")_" as an HMS user? (Y/N) "
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!(Y=0) Q
 I '$$GETOCCUP(.OCCUP) Q
 D CREATE
 I '$D(USER) Q
 D SETOCCUP
 D ASSIGNKS
 I $D(^BKM(90450,HIVIEN,11,"B",USER)) D  Q
 . S BKMUSER=$O(^BKM(90450,HIVIEN,11,"B",USER,""))
 . W !!,"The user ",$$GET1^DIQ(90450.011,BKMUSER_","_HIVIEN,.01,"E")," was added with an access role of ",$$GET1^DIQ(90450.011,BKMUSER_","_HIVIEN,.5,"E"),".",! H 2
 Q
 ;
D ;Delete a User
 I '$$GETUSER2 Q
 S DIR(0)="YA"
 S DIR("A")="Delete "_$$GET1^DIQ(200,USER,.01,"E")_" as an HMS user? (Y/N) "
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!(Y=0) Q
 D DELUSER
 D DELKEYS
 I $D(^BKM(90450,HIVIEN,11,"B",USER)) D  Q
 . W !!,"User "_$$GET1^DIQ(200,USER,.01,"E")_" was not deleted.",! H 2 Q
 W !!,"User "_$$GET1^DIQ(200,USER,.01,"E")_" was deleted.",! H 2
 Q
 ;
E ;Edit a User
 I '$$GETUSER2 Q
 I '$$GETOCCUP(.OCCUP) Q
 D SETOCCUP
 D DELKEYS
 D ASSIGNKS
 I $D(^BKM(90450,HIVIEN,11,"B",USER)) D  Q
 . S BKMUSER=$O(^BKM(90450,HIVIEN,11,"B",USER,""))
 . W !!,"The user ",$$GET1^DIQ(90450.011,BKMUSER_","_HIVIEN,.01,"E")," was updated with an access role of ",$$GET1^DIQ(90450.011,BKMUSER_","_HIVIEN,.5,"E"),".",! H 2
 Q
 ;
CFM ;EP - Called from USR^BKM1POST
 ;  Add a Case File Manager as part of post-installation process
 ;  this initializes one person who will then set up all other HMS users
 NEW TEXT,HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 ;S TEXT(1)="  Select the User who will be initialized as the HMS Case File Manager."
 ;S TEXT(2)="  This is the user who will set up all the other HMS users through the"
 ;S TEXT(3)="  User Account Setup [BKMV USER MAINTENANCE] option."
 ;D EN^DDIOL(.TEXT)
CU ;
 I '$G(XPDQUES("POS1 CFM")) Q
 ;I '$$GETUSER D EN^DDIOL("You must select a user.  It is required.") G CU
 S USER=$G(XPDQUES("POS1 CFM"))
 I $D(^BKM(90450,HIVIEN,11,"B",USER)) D  Q
 . D BMES^XPDUTL($$GET1^DIQ(200,USER,.01,"E")_" is already an HMS user.")
 ;S DIR(0)="YA"
 ;S DIR("A")="Add "_$$GET1^DIQ(200,USER,.01,"E")_" as an HMS user? (Y/N) "
 ;D ^DIR
 ;I $D(DTOUT)!$D(DUOUT)!(Y=0) G CU
 S OCCUP="C"
 D CREATE
 D SETOCCUP
 D ASSIGNKS
 I $D(^BKM(90450,HIVIEN,11,"B",USER)) D  Q
 . S BKMUSER=$O(^BKM(90450,HIVIEN,11,"B",USER,""))
 . W !!,"The user ",$$GET1^DIQ(90450.011,BKMUSER_","_HIVIEN,.01,"E")," was added with an access role of ",$$GET1^DIQ(90450.011,BKMUSER_","_HIVIEN,.5,"E"),".",! H 2
 Q
