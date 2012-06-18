VENPCCQZ ; IHS/OIT/GIS - POST INSTALL & APPLICATION CONFIG OPTION ; [ 03/31/09   5:36 PM ]
 ;;2.6;PCC+;**1,3**;MAR 23, 2011
 ;
 ;
 ;
VPTED ; EP - UPDATE V PATIENT ED FILE
 N X,Y,Z
 I $L($T(^VENLINIT)) D
 . W !,"It looks like you need to update the V PATIENT ED file..."
 . W !,"When asked if you want to overwrite security codes, answer 'YES'"
 . W !,"When asked if everything is OK, answer 'YES'",!!
 . D ^VENLINIT
 . W !
 . Q
 Q
 ; 
VWC ; EP - UPDATE V WELL CHILD FILE"
 N X,Y,Z
 I $L($T(^VENLINIT)) D
 . W !,"It looks like you need to install the V WELL CHILD file..."
 . W !,"When asked if you want to overwrite security codes, answer 'YES'"
 . W !,"When asked if everything is OK, answer 'YES'"
 . D ^VENMINIT
 . W !
 . Q
 Q
 ; 
MP ; EP - SET MEASUREMENT PANELS CORRECTLY
 N TIEN,X,Y,Z,%,DA,DIC,DIE,DIK,MP,PS,PSM,ASQ,PIEN
 S TIEN=$O(^APCHSCTL("B","WELL CHILD EXAM",0)) I 'TIEN Q
 S PS=$O(^APCHSMPN("B","PEDIATRIC STD",0))
 S PSM=$O(^APCHSMPN("B","PEDIATRIC STD METRIC",0))
 S ASQ=$O(^APCHSMPN("B","ASQ DEVELOPMENT SCORES",0))
 S PIEN=0,Z=""
 F  S PIEN=$O(^APCHSCTL(TIEN,3,PIEN)) Q:'PIEN  D
 . S X=$G(^APCHSCTL(TIEN,3,PIEN,0)) I '$L(X) Q
 . S Y=$P(X,U,2)
 . I Y=PS S Z=Z_"PS^" Q
 . I Y=PSM S Z=Z_"PSM^" Q
 . I Y=ASQ S Z=Z_"ASQ" Q
 . ; KILL OF BAD PANEL
 . S DA(1)=TIEN,DIK="^APCHSCTL("_DA(1)_",3,",DA=PIEN
 . D ^DIK
 . Q
 S DA(1)=TIEN,DIC="^APCHSCTL("_DA(1)_",3,"
 S DIC(0)="L",DIC("P")=$P(^DD(9001015,4,0),U,2),DLAYGO=9001015.02
 I Z'["PS" D
 . S X=$O(^APCHSCTL(TIEN,3,9999),-1)+1
 . D ^DIC I Y=-1 Q
 . S $P(^APCHSCTL(TIEN,3,+Y,0),U,2)=PS
 . Q
 I Z'["ASQ" D
 . S X=$O(^APCHSCTL(TIEN,3,9999),-1)+1
 . D ^DIC I Y=-1 Q
 . S $P(^APCHSCTL(TIEN,3,+Y,0),U,2)=ASQ
 . Q
 W !?5,"The correct measurement panels have been assigned to this component"
 D ^XBFMK
 Q
 ; 
CMP(Z) ; EP - CHECK COMPONENTS OF WELL CHILD EXAM HEALTH SUMMARY
 N WIEN,MIEN,DIEN,TIEN,CIEN,X,Y,%
 S Z=0
 S TIEN=$O(^APCHSCTL("B","WELL CHILD EXAM",0)) I 'TIEN Q
 S WIEN=$O(^APCHSCMP("B","WELL CHILD EXAM",0))
 S MIEN=$O(^APCHSCMP("B","MEASUREMENT PANELS",0))
 S DIEN=$O(^APCHSCMP("B","DEMOGRAPHIC DATA",0))
 S %=$NA(^APCHSCTL(TIEN,1)),Z=$P($G(@%@(30,0)),U,2) I Z,Z'=WIEN,'$D(@%@("B",31)) D
 . K @%@(30,0) S @%@(31,0)=31_U_WIEN
 . K @%@("B",30) S @%@("B",31,31)=""
 . K @%@("C",Z) S @%@("C",WIEN,31)=""
 . Q
 S Y="",CIEN=0,Z=0
 F  S CIEN=$O(^APCHSCTL(TIEN,1,CIEN)) Q:'CIEN  D
 . S %=+$P($G(^APCHSCTL(TIEN,1,CIEN,0)),U,2)
 . I %=WIEN S Y=Y_"WCE^" Q
 . I %=MIEN S Y=Y_"MP^" Q
 . I %=DIEN S Y=Y_"DP^"
 . Q
 I Y'["WCE" W !?5,"The WELL CHILD EXAM component is missing" S Z=1 Q
 I Y'["MP" W !?5,"The MEASUREMENT PANEL component is missing" S Z=1 Q
 I Y'["DP" W !?5,"The DEMOGRAPHIC component is missing" S Z=1 Q
 W !?5,"All required components are present"
 Q
 ;
SMENU ; EP - ASSIGN BROKER OPTION AS A SECONDARY MENU FOR WCM USERS
 N %,%Y,DIC,DIE,DA,DR,X,Y,Z,DFN,BIEN,VIEN
 S VIEN=$O(^DIC(19,"B","VEN RPC",0)) I 'VIEN Q
 S BIEN=$O(^DIC(19,"B","BMXRPC",0)) I 'BIEN Q
 W !!,"Broker options can also be assigned to specific users who do not use"
 W !,"any of the primary menus listed above."
 W !,"Want to allow these special users to access WCM desktop components"
 S %=2 D YN^DICN I %'=1 Q
 S DIC("A")="Enter the name of a user that needs access privileges: "
SMORE S DIC=200,DIC(0)="AEQM"
 D ^DIC I Y=-1 D ^XBFMK Q
 S DFN=+Y
 I $D(^VA(200,DFN,203,"B",VIEN)),$D(^VA(200,DFN,203,"B",BIEN)) W !,"This user already has access" G SMORE
 W !,"Are you sure you want to allow access for this user"
 S %=1 D YN^DICN I %'=1 G SMLOOP
 S DA(1)=DFN,DIC="^VA(200,"_DA(1)_",203,",(DLAYGO,DIC("P"))=200.03,DIC(0)="L"
 F X=("`"_VIEN),("`"_BIEN) D ^DIC
 K DIC
 I Y=-1 W "Unable to assign access privileges to this user!!!"
 E  W !,"OK, secondary menu options have been assigned to provide access for this user.",!
 S DIC("A")="Enter another user that needs access privileges: "
SMLOOP G SMORE
 ; 
HOLD(KEY) ; EP - SECURITY KEY HOLDERS
 N DFN,NAME,%,Y,PRIV,KIEN,Z
 S PRIV=0,KIEN=$O(^DIC(19.1,"B",KEY,0)) I 'KIEN Q
 I DUZ(0)="@"!$D(^VA(200,DUZ,52,KIEN,0))!$D(^XUSEC("XUMGR",DUZ)) S PRIV=1 ; USER HAS KEY ALLOCATION PRIVELEGES
 I $O(^XUSEC(KEY,0)) D  G:PRIV HOLD1 Q
 . S DFN=0 W !?15,"Holders:"
 . F  S DFN=$O(^XUSEC(KEY,DFN)) Q:'DFN  S NAME=$P($G(^VA(200,DFN,0)),U) I $L(NAME) W !?20,NAME
 . Q
 W !?15,"Currently no users hold this key!"
 I 'PRIV Q
 W !?15,"Want to assign it to yourself"
 S %=1 D YN^DICN
 I %=1 S Y=$$ADDKEY(DUZ,KIEN,1)
HOLD1 W !!?2,"Want to assign ",KEY," to any other IT personnel or supervisors"
 S %=2 D YN^DICN
 I %'=1 Q
 S Y=$$ADDKEY(DUZ,KIEN) I Y=-1 Q
 G HOLD1 ; GET ANOTHER KEYHOLDER
 ; 
ADDKEY(USER,KIEN,SELF) ; EP - ALLOCATE A KEY TO A USER
 N DIC,X,Y,%,DA,DR,DIE,TODAY,SCIEN
 I $G(SELF) S Y=DUZ G AK1
 S DIC=200,DIC(0)="AEQM",DIC("A")="Allocate this key to: "
 D ^DIC I Y=-1 Q Y
 S SCIEN=$O(^VA(200,+Y,51,"B",KIEN,0)) I SCIEN D  Q 1 ; THIS USER ALREADY HAS THE KEY
 . W !,"This user already holds this key!",!,"Want to de-allocate the key"
 . S %=2 D YN^DICN I %'=1 D ^XBFMK Q
 . S DA(1)=+Y,DA=SCIEN,DIK="^VA(200,"_DA(1)_",51,"
 . D ^DIK,^XBFMK W " (Key de-allocated)"
 . Q
AK1 S DA(1)=+Y,DIC="^VA(200,"_DA(1)_",51,",DIC("P")="200.051PA",DIC(0)="L",DLAYGO=200.051
 S X="`"_KIEN
 D ^DIC I Y=-1 Q Y
 S DIE=DIC,DR=".02////^S X=USER;.03////^S X=TODAY"
 L +^VA(200,DA(1)):1 I  D ^DIE L -^VA(200,DA(1))
 W " <- Allocated"
 D ^XBFMK
 Q 1
 ; 
MENU ; EP - VIEW/EDIT ASSOCIATIONS BETWEEN MENUS AND THE BROKER OPTION VEN RPC
 N BIEN,Y,TOT,Z,MIEN,X,%,DIC,DIE,DA,DR,%Y,XIEN
 W !!,"CHECKING BROKER OPTION LINKS"
 W !,"In order to access the WCM desktop components, certain broker options must"
 W !,"be linked to the PRIMARY MENU of clinic nurses and doctors who use the WCM."
 W !,"(One moment please...) "
 S BIEN=$O(^DIC(19,"B","VEN RPC",0)) I 'BIEN Q
 S XIEN=$O(^DIC(19,"B","BMXRPC",0)) I 'XIEN Q
 S Y=0 K TOT S TOT=0
 F  S Y=$O(^DIC(19,Y)) Q:'Y  I $D(^DIC(19,Y,10,"B",BIEN)) S TOT=TOT+1,TOT(TOT)=Y
 I '$D(TOT) W !,"The broker option 'VEN RPC' has not been linked to any user menu!" G MENU1
 W !!,"The broker option 'VEN RPC' is assigned to the following menu(s):"
 S TOT=0 F  S TOT=$O(TOT(TOT)) Q:'TOT  S Y=$G(TOT(TOT)) I Y D
 . S Z=$P($G(^DIC(19,Y,0)),U) I '$L(Z) Q
 . W !?5,TOT,". ",Z
 . Q
 I '$D(TOT(1)) W "  NONE!",!,"Want to assign VEN RPC to a menu"
 E  W !,"Want to make any changes to the 'VEN RPC' assignments"
 S %=2 D YN^DICN I %'=1 Q
 S DIC("A")="Enter the name of a host menu: "
MENU1 S DIC=19,DIC(0)="AEQM"
 W !! D ^DIC I Y=-1 Q
 S MIEN=+Y
 I $P($G(^DIC(19,MIEN,0)),U,4)'="M" D  G MENU1 ; OPTION TYPE MUST BE 'MENU'
 . W !,"VEN RPC must be associated with a menu option"
 . W !,$P(Y,U,2)," is not a menu option.  Try again"
 . Q
 I $D(^DIC(19,MIEN,10,"B",BIEN)) D  G MENU1 ; VEN RPC IS ALREADY ASSOCIATED WITH THIS MENU
 . W !,"VEN RPC is already associated with this option."
 . W !,"Want to remove VEN RPC from this menu"
 . S %=2 D YN^DICN I %'=1 Q
 . S (D0,DA(1))=MIEN,DIK="^DIC(19,"_DA(1)_",10,",DA=$O(^DIC(19,MIEN,10,"B",BIEN,0))
 . I DA D ^DIK W !,"VEN RPC has been removed from this menu"
 . Q
 S X=$O(^DIC(19,MIEN,10,0))+1,Y=$G(^DIC(19,MIEN,10,0)),Z=$NA(^DIC(19,MIEN,10))
 I '$L(Y) S @Z@(0)="^19.01PI^1^1"
 E  S %=$P(@Z@(0),U,3)+1,@Z@(0)="^19.01^"_%_U_%
 S @Z@(X,0)=BIEN_"^RPC",@Z@("B",BIEN,X)=""
 W !,"VEN RPC is now associated with this option"
 I $D(@Z@("B",XIEN)) G MENU1
 S %=$P(@Z@(0),U,3)+1,@Z@(0)="^19.01^"_%_U_%
 S X=$O(^DIC(19,MIEN,10,0))+1
 S @Z@(X,0)=XIEN_"^RPC",@Z@("B",XIEN,X)="" ; ALSO ADD BMXRPC
 G MENU1
 ; 
DINFO ; EP - CHECK/FIX KB DOMAIN POINTERS
 N MNIEN,DIEN,STG,X,Y,%,TYPE,NAME,GBL,TXT
 S MNIEN=$O(^APCDTKW("B","OCM",0)) I 'MNIEN Q
 S GBL=$NA(^VEN(7.13)),(NAME,TXT)="OB NATL"
 F  S NAME=$O(@GBL@("B",NAME)) Q:NAME'[TXT  D
 . S DIEN=$O(@GBL@("B",NAME,0))
 . I '$D(@GBL@(DIEN,0)) Q
 . S $P(@GBL@(DIEN,0),U,3)=MNIEN
 . S $P(@GBL@(DIEN,0),U,4)=$S(NAME[" PP AG ":"OBAG",NAME[" PP EXAM ":"OBEX",NAME[" NATL EXAM ":"OBEX",NAME[" NATL AG ":"OBAG",1:"")
 . Q
 W !?10,"Knowledgebase domain definitions have been verified"
 Q
 ; 
ACT ; EP - MANAGE WCM DOMIANS: MAKE THEM ACTIVE OR INCATIVE
 N %,%Y,DIR,DIC,DIE,DA,DR,X,Y,Z,%,DIEN,TOT
 W !!,"Checking Knowledgebase domains... ",!
 K TOT D ACTL
 S %=2 W !!,"Want to change the status of any of these elements"
 D YN^DICN I %'=1 Q
 S DIR("A")="Which element"
ACT1 S DIR(0)="NO^1:"_TOT_":0"
 D ^DIR I 'Y Q
 S DA=$G(TOT(Y)) I 'DA Q
 S DIE="^VEN(7.13,",DR=".07Is this domain active?"
 L +^VEN(7.13,DA):1 I  D ^DIE L -^VEN(7.13,DA)
 D ACTL
 S DIR("A")="Another element" W !! G ACT1
 ; 
ACTL ; EP - SHOW IF DOMAIN IS ACTIVE
 S DIEN=0,TOT=0
 F  S DIEN=$O(^VEN(7.13,DIEN)) Q:'DIEN  D
 . S X=$G(^VEN(7.13,DIEN,0))
 . S Y=$P(X,U) I Y'["WELL CHILD" Q
 . S Z=$P(X,U,7),TOT=TOT+1,TOT(TOT)=DIEN
 . W !?5,TOT,". ",Y," <-",$S(Z'=1:"IN",1:""),"ACTIVE"
 . Q
 Q
 ; 
XRT ; EP - MAKE SURE EXTERNAL ROUTINES ARE PRESENT
 Q
 W !!,"CHECKING REQUIRED ROUTINES OUTSIDE OF THE WCM PACKAGE..."
 I '$L($T(WCE^APCHS6B)) W !?5,"The routine APCHS6B is missing!"
 E  W !?5,"^APCHS6B",?15,"<- OK"
 I '$L($T(DATA^VENPCCQB)) W !?5,"The routine VENPCCQB is missing!"
 E  W !?5,"^VENPCCQB",?15,"<- OK"
 I '$L($T(VWC^VENPCCQC)) W !?5,"The routine VENPCCQB is missing!"
 E  W !?5,"^VENPCCQB",?15,"<- OK"
 I '$L($T(EXAM^VENPCCQD)) W !?5,"The routine VENPCCQD is missing!"
 E  W !?5,"^VENPCCQD",?15,"<- OK"
 I '$L($T(SS^BMXADO)) W !?5,"The Broker routines (BMX*) are missing!"
 E  W !?5,"The Broker routines (BMX*) are loaded"
 Q
 ;
