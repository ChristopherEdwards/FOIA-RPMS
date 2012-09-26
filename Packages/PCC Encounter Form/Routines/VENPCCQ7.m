VENPCCQ7 ; IHS/OIT/GIS - POSTINIT AND VALIDATION ROUTINE: VUECENTRIC COMPONENTS ; 
 ;;2.6;PCC+;**1,4**;APR 03, 2012;Build 24
 ;
 ;
VOR(IEN) ; EP - FILTER PCC+ COMPONENTS IN THE VUECENTRIC OBJECT REGISTRY FOR KIDS BUILD  ; USED ON SOURCE SERVER
 I $G(IEN),$D(^CIAVOBJ(19930.2,IEN,0))
 E  Q 0
 N X,Y,BIEN
 S BIEN=$O(^VEN(7.26,"B","PCC+ 2.6",0)) I 'BIEN Q 0
 S Y=$P(^CIAVOBJ(19930.2,IEN,0),U)
 I $O(^VEN(7.26,BIEN,1,"B",$E(Y,1,30),0)) Q 1
 Q 0
 ;
POSTINIT ; ------------------- EPs FOR POST INIT ------------------------
 ; 
KBM(START,END,ERR) ; EP - GIVEN START AND END IENs, ADD ITEMS TO VEN EHP KB ITEMS FILE FROM THE VEN EHP KB MASTER FILE ; TARGET SERVER
 S ERR=1
 I $D(^VEN(7.12)),$D(^VEN(7.17)),$D(START),$G(END)
 E  W !?5,"Knowledgebase file missing!  Post init terminated...",!!! Q
 N DIC,DIE,DIK,DA,DR,X,Y,Z,%,GBL
 S DIK="^VEN(7.12,",GBL=$NA(^VEN(7.12))
 I START S DA=START-1
 F  S DA=$O(^VEN(7.17,DA)) Q:'DA  Q:DA>END  D
 . I '(DA#50) W "."
 . K Z
 . I $D(@GBL@(DA,0)) D  ; REFRESH NODE BUT KEEP CURRENT ACTIVITY STATUS
 .. S Z=$P(@GBL@(DA,0),U,11)
 .. D ^DIK
 .. Q
 . M @GBL@(DA)=^VEN(7.17,DA)  ; COPY 1 ENTRY
 . I $D(Z) S $P(@GBL@(DA,0),U,11)=Z ; SAVE THE PREVIOUS ACTIVE STATUS - IF AVAILABLE
 . D IX^DIK ; SET X-REF FOR 1 ENTRY
 . Q
 S $P(^VEN(7.12,0),U,3,4)=END_U_END
 D ^XBFMK
 S ERR=0
 Q
 ;
CKVOBJ(BLD,OK) ; EP - CHECK REGISTERED VUECENTRIC OBJECTS ; TARGET SERVER
 S OK=0
 I $L($G(BLD))
 E  Q
 N A,B,C,D,DS,X,Y,Z,%,PCE,IEN,NM,GBL,IX,STG,DSTG,IXD,DIEN,BIEN,IXX,NAME,DNAME,DNM,TIEN,VGBL,VIEN
 S BIEN=$O(^VEN(7.26,"B",BLD,0)) I 'BIEN S OK=1 Q  ; BUILD NOT REGISTERED
 S GBL=$NA(^CIAVOBJ(19930.2)),VGBL=$NA(^VEN(7.26))
 S NM=""
 F  S NM=$O(@VGBL@(BIEN,1,"B",NM)) Q:NM=""  S VIEN=0 F  S VIEN=$O(@VGBL@(BIEN,1,"B",NM,VIEN)) Q:'VIEN  D  ; CHECK OBJECTS AND BUILD THE OBJECT IX ARRAY
 . ; S VIEN=$O(@VGBL@(BIEN,1,"B",NM,0)) I 'VIEN Q
 . S NAME=$P($G(@VGBL@(BIEN,1,VIEN,0)),U) I NAME="" Q
 . S IEN=0
 . F  S IEN=$O(@GBL@("B",NM,IEN)) Q:'IEN  I $P($G(@GBL@(IEN,0)),U)=NAME Q
 . I 'IEN D  Q
 .. I '$D(IXX(NM)) W !?5,"The VueCentric Object '"_NAME_" is missing" S IXX(NM)=""
 .. S OK=1
 .. Q
 . S IX(IEN)=NAME,DNM=""
 . F  S DNM=$O(@VGBL@(BIEN,1,VIEN,1,"B",DNM)) Q:DNM=""  S DIEN=0 F  S DIEN=$O(@VGBL@(BIEN,1,VIEN,1,"B",DNM,DIEN)) Q:'DIEN  D
 .. S DNAME=$P($G(@VGBL@(BIEN,1,VIEN,1,DIEN,0)),U) I DNAME="" Q
 .. S TIEN=0
 .. F  S TIEN=$O(@GBL@("B",DNM,TIEN)) Q:'TIEN  I $P($G(@GBL@(TIEN,0)),U)=DNAME Q
 .. I 'TIEN D  Q
 ... I '$D(IXX(DNM)) W !?5,"The VueCentric Object '"_NAME_" is missing" S IXX(DNM)=""
 ... S OK=1
 ... Q
 .. S IX(IEN,TIEN)=DNAME
 . Q
 S IEN=0
DEP F  S IEN=$O(IX(IEN)) Q:'IEN  D  ; REBUILD THE SUBFILE WITH IEN FROM THE TARGET MACHINE
 . I '$O(IX(IEN,0)) Q  ; NO DEPENDENCIES
 . K @GBL@(IEN,9) ; FIRST CLEAN OUT THE SUBFILE
 . S DA(1)=IEN,DIC="^CIAVOBJ(19930.2,"_DA(1)_",9,",(DIC("P"),DLAYGO)=19930.221,DIC(0)="L"
 . S TIEN=0
 . F  S TIEN=$O(IX(IEN,TIEN)) Q:'TIEN  D
 .. S X="`"_TIEN
 .. D ^DIC
 .. I Y=-1 S OK=1 W !,"Dependency failure: ",IEN,",",TIEN
 .. Q
 . Q
 I OK W !?7,"Unable to enter all VueCentric Objects and dependencies",! Q
 Q
 ;
HOLD(KEYS,UTYPE) ; EP - ALLOCATE PACKAGE KEYS TO MANAGERS AND USERS ; TARGET SERVER
 I $L($G(KEYS)),$L($G(UTYPE))
 E  Q
 N DFN,NAME,X,%,Y,KIEN,KIENS,KEY,Z,STOP,PCE,PRIV,KEYFLAG,STOP,XSTOP
 S KEY=$P(KEYS,U),KIENS=""
 F PCE=1:1:$L(KEYS,U) D  I %="" Q
 . S %=$P(KEYS,U,PCE) I %="" Q
 . S X=$O(^DIC(19.1,"B",%,0)) I 'X W !?5,"The Security Key ",%," is missing!!!" S %="" Q
 . I $L(KIENS) S KIENS=KIENS_U
 . S KIENS=KIENS_X
 . Q
 S KIEN=+KIENS,PRIV=0,KEYFLAG=0,STOP=0
 I DUZ(0)'="@",'$D(^VA(200,DUZ,52,KIEN,0)),'$D(^XUSEC("XUMGR",DUZ)),'$D(XUSEC(KEY,DUZ)) ; CURRENT USER HAS KEY ALLOCATION PRIVELEGES
 I  W !?5,"You currently lack priveleges to distribute keys for this package!  Try again later...  " Q
LISTHLDR I $O(^XUSEC(KEY,0)) D  ; LIST ALL KEY HOLDERS
 . S KEYFLAG=1
 . S DFN=0 W !?5,"Holders:"
 . F  S DFN=$O(^XUSEC(KEY,DFN)) Q:'DFN  D
 .. S NAME=$P($G(^VA(200,DFN,0)),U)
 .. I $L(NAME) W !?20,NAME
 .. I DFN=DUZ S PRIV=1
 .. Q
 . Q
 I UTYPE="M" D  Q:XSTOP  G HOLD1
 . S XSTOP=1
 . I 'KEYFLAG D
 .. W !?5,"Currently no site managers or CACs hold the GUI management keys!"
 .. W !?5,"Want to assign them to yourself"
 .. S %=1 D YN^DICN
 .. I %'=1 W !?8,"You must own this key to proceed!  Try again later..." Q
 .. D ADDKEY(1,KIEN,.STOP) ; ASSIGN KEY TO PRIMARY MANAGER
 .. Q
 . W !!?2,"Want to assign the GUI Management Keys to IT personnel or CACs"
 . S %=2 D YN^DICN
 . I %=1 S XSTOP=0
 . Q
UKEY I 'KEYFLAG W !!,"Currently no users hold the ",KEY," key"
 W !!?2,"Want to assign this key to any other users"
 S %=2 D YN^DICN
 I %'=1 Q
HOLD1 S STOP=0
 F  D ADDKEY(0,KIENS,.STOP) I STOP Q  ; GET ANOTHER KEYHOLDER
 Q
 ; 
ADDKEY(SELF,KIENS,STOP) ; EP - ALLOCATE KEY
 N DIC,X,%,DA,DR,DIE,TODAY,SCIEN,KIEN,USER
 I SELF S USER=DUZ G AK1 ; SELF-ASSIGNMENT
 S DIC=200,DIC(0)="AEQM",DIC("A")="Allocate this key to: "
 D ^DIC I Y=-1 S STOP=1 Q
 S USER=+Y
 S SCIEN=$O(^VA(200,+Y,51,"B",+KIENS,0))
 I SCIEN D  Q  ; THIS USER ALREADY HAS THE KEY
 . W !,"This user already holds this key!",!,"Want to de-allocate the key"
 . S %=2 D YN^DICN I %'=1 D ^XBFMK Q
 . S DA(1)=+Y,DA=SCIEN,DIK="^VA(200,"_DA(1)_",51,"
 . D ^DIK,^XBFMK
 . W "  <- Key de-allocated"
 . Q
AK1 ; GIVE ALL OTHER KEYS TO THE RECIPIENT
 S DA(1)=USER,DIC="^VA(200,"_DA(1)_",51,",DIC("P")="200.051PA",DIC(0)="L",DLAYGO=200.051
 F PCE=1:1:$L(KIENS,U) S KIEN=$P(KIENS,U,PCE) I KIEN D
 . S X="`"_KIEN
 . D ^DIC I Y=-1 Q
 . S DA=+Y,DIE=DIC,DR=".02////^S X=USER;.03////^S X=TODAY"
 . L +^VA(200,DA(1)):1 I  D ^DIE L -^VA(200,DA(1))
 . Q
 W " <- Key allocated"
ABP ; ASSIGN BMX BROKER PRIVELEGES TO THE RECIPIENT
 N OPT,GBL,IEN,DIC,DIE,DA,DR,DLAYGO,MN,D0
 S OPT=$O(^DIC(19,"B","VEN RPC",0)) I 'OPT Q
 I $O(^VA(200,USER,203,"B",OPT,0)) Q  ; ITS ALREADY IN THERE
 S (D0,DA(1))=USER,DIC="^VA(200,"_DA(1)_",203,",DIC(0)="LO"
 S (DIC("P"),DLAYGO)=200.03
 S X="`"_OPT
 D ^DIC I Y=-1 Q
 S DA=+Y,DIE=DIC,DR="2////^S X=MN",MN="WRPC"
 L +^VA(200,USER,203,DA):1  I  D ^DIE L -^VA(200,USER,203,DA)
 D ^XBFMK
 Q
 ;
UMO(MIEN,GMIEN) ; EP - ADD VEN_GUIMGR OPTION TO A MENU
 I $G(MIEN)
 E  Q
 N GBL,IEN,DIC,DIE,DA,DR,DLAYGO,MN,D0
 I $O(^DIC(19,MIEN,10,"B",GMIEN,0)) Q  ; ITS ALREADY IN THERE
 S (D0,DA(1))=MIEN,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LO"
 S (DIC("P"),DLAYGO)=19.01
 S X="`"_GMIEN
 D ^DIC I Y=-1 Q
 S DA=+Y,DIE=DIC,DR="2////^S X=MN",MN="MPG"
 L +^DIC(19,MIEN,10,DA):1  I  D ^DIE L -^DIC(19,MIEN,10,DA)
 D ^XBFMK
 Q
 ; 
CIABMX(OK) ; EP - IF NECESSARY, ADD THE RPC CIABMX TO THE CIAV VUECENTRIC OPTION
 N OIEN,RIEN,X,Y,Z,%,DIC,DLAYGO
 S RIEN=$O(^XWB(8994,"B","CIABMX",0))
 I 'RIEN W !?5,"The RPC 'CIABMX' is missing",! S OK=1 Q
 S OIEN=$O(^DIC(19,"B","CIAV VUECENTRIC",0))
 I 'OIEN W !?5,"The Option 'CIAV VUECENTRIC' is missing",! S OK=1 Q
 S DA(1)=OIEN,DIC="^DIC(19,"_DA(1)_",""RPC"",",(DLAYGO,DIC("P"))=19.05,DIC(0)="L"
 S X="`"_RIEN
 D ^DIC
 I Y=-1 W !?5,"The RPC CIABMX is not registered in broker option CIAV VUECENTRIC" S OK=1 Q
 Q
 ; 
PATH(PATH) ; ALERT THE USER OF THE PATH TO THE WCM DLLS
 N PIEN,X,Y,Z,%
 S PATH=""
 S PIEN=$O(^XTV(8989.51,"B","CIAVM DEFAULT SOURCE",0)) I 'PIEN Q
 S X=0
 F  Q:$L(PATH)  S X=$O(^XTV(8989.5,X)) Q:'X  D
 . S %=$P($G(^XTV(8989.5,X,0)),U,2)
 . I %'=PIEN Q
 . S PATH=$G(^XTV(8989.5,X,1))
 . Q
 Q
 ; 
DEVEL ; ---------------  DEVELOPER UTILITIES  -------------------
 ;
POF ; POPULATE THE VEN OBJECTS FILE
 N X,Y,Z,%,DIC,DIE,DA,DR,DLAYGO,NM,DNM,IEN,DIEN,BIEN,XIEN
 W !!!,"Enter the VueCentric objects included in this build...",!!
 S DIC("A")="Enter build: ",(DIC,DLAYGO)=19707.26,DIC(0)="AEQL"
 D ^DIC I Y=-1 Q
 S BIEN=+Y
LOOP S DIC("A")="VueCentric object: ",DIC=19930.2,DIC(0)="AEQM"
 D ^DIC I Y=-1 G POP
 S IEN=+Y,OBJ=$P(Y,U,2),DA=0
 F  S DA=$O(^VEN(7.26,BIEN,1,"B",$E(OBJ,1,30),DA)) Q:'DA  I $P($G(^VEN(7.26,BIEN,1,DA,0)),U)=OBJ D  G LOOP
 . W !?3,OBJ," is already in the build",!?3,"Want to remove it"
 . S %="" D YN^DICN
 . I %'=1 Q
 . S DA(1)=BIEN,DIK="^VEN(7.26,"_DA(1)_",1,"
 . D ^DIK
 . Q
 S ARR(IEN)=OBJ
 S DIEN=0
 F  S DIEN=$O(^CIAVOBJ(19930.2,IEN,9,"B",DIEN)) Q:'DIEN  D
 . S DNM=$P($G(^CIAVOBJ(19930.2,DIEN,0)),U) I DNM="" Q
 . S ARR(IEN,DIEN)=DNM
 . Q
 W !! G LOOP
POP I '$O(ARR(0)) Q
 S IEN=0
 F  S IEN=$O(ARR(IEN)) Q:'IEN  D
 . S DA(1)=BIEN,(DIC("P"),DLAYGO)=19707.261,DIC(0)="LO",DIC="^VEN(7.26,"_DA(1)_",1,"
 . S X=ARR(IEN)
 . D ^DIC I Y=-1 Q
 . S XIEN=+Y,DA(2)=BIEN,DA(1)=XIEN
 . S DIC="^VEN(7.26,"_DA(2)_",1,"_DA(1)_",1,",(DIC("P"),DLAYGO)=19707.2611,DIC(0)="LO"
 . S DIEN=0
 . F  S DIEN=$O(ARR(IEN,DIEN)) Q:'DIEN  D
 .. S X=ARR(IEN,DIEN)
 .. D ^DIC
 .. Q
 . Q
 Q
 ;
AUTODFRM ; AUTOMATE DIFROM SO NO USER INTERVENTION IS NECESSARY
 S DIR(0)="F^5:9",DIR("A")="Enter name of any routine in the DIFROM"
 D ^DIR
 I Y?1"^" Q
 I $E(Y)=U S Y=$E(Y,2,99)
 S %=$E(Y,$L(Y)-3) I %'="I" W "  ??",!! G AUTODFRM
 S ROOT=$E(Y,1,$L(Y)-4),DELGBL=""
 W !,"Want to delete the data global before running DIFROM"
 S %=2 D YN^DICN
 I %=1 D  I Y=-1 Q
 . S DIC("A")="Delete global from what file: "
 . S DIC=1,DIC(0)="AEQM"
 . D ^DIC I Y=-1 Q
 . S %="" W !,"Are you sure you want to delete it"
 . D YN^DICN
 . I %'=1 Q
 . S Z=^DIC(+Y,0,"GL")
 . S Z=$E(Z,1,$L(Z)-1)
 . S DELGBL=" S %="""_Z_")"" K @%"
 . Q
 X ("S %=$T(ASK^"_ROOT_"INI1)")
 I %="" W !?5,"Can't find the routine ",ROOT,"INI1... Request terminated!" Q
 I %["S DSEC=1" W !?5,"Already modified... Request terminated!" Q
 S Z=$C($A("Z"))
 S LINE="ASK S DSEC=1"_DELGBL
 S RT=ROOT_"INI1"
 S X="ZL "_RT_" ZR ASK+1 ZR ASK ZI LINE ZS "_RT_" ZL VENPCCQ7"
MD X X
 X ("S %=$T(ASK^"_ROOT_"INI1)")
 W !?5
 I %["S DSEC=1" W "DIFROM modified successfully!" Q
 W "Unable to modify DIFROM"
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
