VENPCCQ6 ; IHS/OIT/GIS - POSTINIT KIDS SUPPORT ROUTINE ;  [ 03/31/09   5:36 PM ]
 ;;2.6;PCC+;**1,4,5**;APR 03, 2012;Build 19
 ;
 ; 
POSTINIT ; POST INIT ROUTINE
 N MODE,OK,X,Y,Z,%,BUILD,ERR,BIEN,MP,MPIEN,DIC,DIE,DA,DR,DLAYGO,D0,V,KIEN,KEY,OPT,BOIEN
 S BUILD="PCC+*2.6*5"
 S OK=0,ERR=0
 W !!!?15,"*****  WCM POST-INITIALIZATION PROCEDURES  *****",!!
 W ?5,"Continuing installation of content",!!
KB ; ADD ANY MISSING ENTRIES TO THE KB
 D ^VEN8INIT ; REBUILD THE REFERENCE KNOWLEDGEBASE
 W !!,"Updating the Knowledgebase..."
 D KBM^VENPCCQ7(1,5170,.ERR) ; REBUILD THE KNOWLEDGEBASE RETAINING EXISTING SETTINGS FOR ACTIVE/INACTIVE STATUS
 I ERR D  Q  ; KB UPDATE FAILED
 . W !?5,"Knowledgebase installation failed.  Installation terminated"
 . S X="WCM installation failed.  Contact the OIT Help Desk for assistance"
 . D BOX(X)
 . Q
 W !?5,"Knowledgebase installed successfully!"
PE ; REFRESH PATIENT ED TOPICS
 W !!,"Updating the Patient Education topics..."
 D TOPIC^VENPCCKB ; UPDATE EDUCATION TOPIC FILE
 W "  < Content updated successfully!"
HS ; REFRESH HEALTH SUMMARY COMPONENTS
 S OK=0,MPIEN=""
 W !!,"Updating Health Summary Components..."
 D MP(.MPIEN) ; GET ASQ MEASUREMENT PANEL
 I 'MPIEN D  G HSX
 . W !?5,"Health Summary Measurement Panel 'ASQ DEVELOPMENT SCORES' is missing!"
 . S ERR=1,OK=0
 . Q
 D WCEC(.OK)
 I OK D  G HSX
 . W !?5,"The Health Summary Component 'WELL CHILD EXAM' is missing!"
 . S ERR=1,OK=0
 . Q
 D HST(.OK)
 I OK S OK=0,ERR=1 W !?5,"The Health Summart Type 'WELL CHILD EXAM' is missing!"
 E  W "  < All components have been installed"
HSX ; END HS UPDATE
GETMODE ; GET MODALITY
 D MODE(.MODE)
 I 'MODE,'$G(VFLAG) D  Q  ; IF MODE IS UNDEFINED, ABORT THE INSTALLATION
 . W !!,"The installation of the WCM has been terminated prematurely"
 . W !?5,"Please reinstall the build later..."
 . W !?5,"Press <Enter> to exit this option"
 . I $$STOP
 . Q
 I 'MODE,$G(VFLAG) D  Q  ; IF MODE IS UNDEFINED, ABORT VALIDATION
 . W !!,"The VALIDATION of the WCM has been terminated prematurely"
 . W !?5,"Press <Enter> to exit this option"
 . I $$STOP
 . Q
 ; 
 D INTRO
BUILD ; VERIFY CURRENT KIDS BUILD
 W !!,"Checking KIDS build '",BUILD,"'..."
 S BIEN=$O(^XPD(9.6,"B",BUILD,0))
 I 'BIEN W !,"Unable to locate the KIDS build for this package!  Validation terminated..." Q
 W "   < Validated"
 I $$STOP S OK=2 G CSCX
 I MODE=2 G VAL ; TRADITIONAL PCC+ MODE - NO NEED FOR CIA OBJECTS OR BMX BROKER
 ; 
CIAOBJ ; UPDATE THE VUECENTRIC REGISTERED OBJECTS FILE
 S OK=0
 W !,"Registering the Vucentric Objects..."
 I '$D(^CIAVOBJ(19930.2)) G BMX
 D CKVOBJ^VENPCCQ7("PCC+ 2.6",.OK)
 I 'OK W "  < All OBJECTS have been registered"
 I $$STOP S OK=2 G CSCX
 ; 
BMX ; CHECK BMX 4.0
 S OK=0 D BMX^VENPCCQ8(.OK) I OK S ERR=1
 I $$STOP S OK=2 G CSCX
 ;
VAL ; EP - VALIDATE THE WCM
 S OK=0
 D VALIDATE^VENPCCQ8(BIEN,MODE,.OK,.ERR)
 I $G(OK)=2 G CSCX
CFG ; EP - CONFIGURE THE WCM
 W !,"Now we are ready to CONFIGURE the Well Child Module..."
 I $$STOP S OK=2 G CSCX
 ; 
BOPT ; CHECK VEN RPC BROKER OPTION PLACEMENT
 S OK=0
 W !!,"Assign the broker option VEN RPC to end users..."
 D BOPT^VENPCCQ8(.OK)
 I OK S ERR=1,OK=0
 I $$STOP S OK=2 G CSCX
 ; 
KEYS ; ASSIGN KEYS TO USERS
AKEY W !!,"Assign the key VENZMGUI to selected IT personnel and supervisors..."
 D HOLD^VENPCCQ7("VENZMGUI^VENZDESKTOP^VENZKBEDIT","M")
DESKTOP W !!,"Assign user privileges for the WCM Desktop GUI components..."
 D HOLD^VENPCCQ7("VENZDESKTOP","U")
KBP W !!,"Assign user privileges for the WCM Knowledgebase Management components..."
 D HOLD^VENPCCQ7("VENZKBEDIT","U")
 ; 
BROKER I MODE=3 D  I OK=2!($G(ERR)) G CSCX
 . D BROKER^VENPCCQ8 ; CONFIGURE BMX BROKER LISTENER
 . I $$STOP S OK=2
 . Q
 ; 
DOM W ! D ACT^VENPCCQ7 ; MAKE SURE THAT THE CURRENT SET OF KB DOMAINS IS ACTIVE
 I $$STOP S OK=2 G CSCX
 ; 
MO ; INSTALL GUI MANAGEMENT OPTIONS
 S OK=0
 W !!,"Configuring the GUI management menu option (VEN_GUIMENU)..." ; ASSIGN GUI MANAGERS OPTION
 S Z=$O(^DIC(19,"B","VEN WCM_MENU",999999999),-1)
 I 'Z W !?5,"VEN WCM_MENU has not been installed!!" S OK=1,ERR=1 G CSCX
 S Y=$O(^DIC(19,"B","VEN WCM START OR STOP BROKER",999999999),-1)
 I Y,$D(^DIC(19,Z,10,"B",Y)) W "  < Done!" G MO1 ; IT'S ALREADY CONFIGURED
 D MM(.OK,Z) I OK S ERR=1 W !?5,"Option configuration failed!" S ERR=1 G CSCX
 W !,"The WCM GUI managers menu (VEN WCM_MENU) has been configured"
 W !?5,"It is available to all users that hold the VENZMGUI key."
 W !?5,"If you have not already done so, place this option on a "
 W !?5,"convenient site manager's menu; e.g.,AKMOEVE"
 I $$STOP S OK=2 G CSCX
MO1 I MODE'=1 G CSCX
 ; 
PATH ; GET THE PATH TO DLLS ON THE EHR SERVER
 G CSCX ; PATH INSTRUCTIONS NOT NEEDED IN PATCH 5.  NO DLLS IN THIS PATCH
 ; 
 W ! D PATH^VENPCCQ7(.PATH)
 I PATH="" G CSCX
 W !!,"After the KIDS installation has been successfully completed, you will"
 W !,"run 'ven_0260.01t_WcmEhr_Setup.exe' to load the WCM dlls on the EHR"
 W !,"server.  During this process you will be asked to enter the PATH to the"
 W !,"folder where the dlls are stored.  Use the following path:"
 W !!?10,PATH,!!
 I $$STOP S OK=2 G CSCX
 ; 
CSCX ; FINISH UP
 I $G(ERR) W !!,"The Well Child GUI validation process detected at least one problem",! S X="Please take corrective action and reinstall this patch." G EXITMSG
 I $G(OK)=2 W !!,"The validation process was terminated prematurely!" S X="Please complete the validation at a later time" G EXITMSG
SUCCESS S X="Congratulations!  The Well Child Module is CONFIGURED and ready for use"
EXITMSG D BOX(X)
 I $$STOP
 D ^XBFMK
 Q
 ;
MM(OK,MIEN) ; EP - WCM MANAGER'S MENU
 S OK=0
 I $G(MIEN)
 E  Q
 N X,Y,Z,%,DIC,DIE,DA,DR,DLAYGO,OPT,OARR,OIEN,ORD,TAG,CNT,REF,D0
 S OPT="",CNT=0
OARR F  S OPT=$O(^XPD(9.6,BIEN,"KRN",19,"NM","B",OPT)) Q:OPT=""  D  ;  BUILD ARRAY OF MENU ITEMS
 . I OPT'["VEN WCM " Q  ; BYPASS PRIMARY MENU
 . S OIEN=$O(^DIC(19,"B",OPT,99999999),-1) I 'OIEN S OK=1 Q
 . S TAG=$S(OPT["ACTIVATE":"AD",OPT["CHECK UP":"CKUP",OPT["PLACE":"PB",OPT["START":"SSB",1:"")
 . I TAG="" W !,OPT S OK=1 Q
 . S CNT=CNT+1
 . S OARR(CNT)=OIEN_U_TAG_U_(CNT*10)
 . Q
ARR I OK G MMX
 S REF=$NA(^DIC(19,MIEN,10)) K @REF ; CLEAN OUT THE MENU ITEMS, THEN REBUILD
 S DA(1)=MIEN,DIC="^DIC(19,"_DA(1)_",10,",(DLAYGO,DIC("P"))=19.01,DIC(0)="LO",CNT=0
 S DIE=DIC,DR="2////^S X=TAG;3////^S X=ORD"
 F  S CNT=$O(OARR(CNT)) Q:'CNT  D
 . S X="`"_(+OARR(CNT)),D0=DA(1)
 . D ^DIC I Y=-1 S OK=1 Q
 . S DA=+Y,TAG=$P(OARR(CNT),U,2),ORD=$P(OARR(CNT),U,3)
 . L +^DIC(19,MIEN,10):1 I  D ^DIE L -^DIC(19,MIEN,10)
 . Q
MMX D ^XBFMK
 Q
 ; 
STOP() W !,"<>" ; EP - WAIT
 R %:DTIME
 I %?1."^" Q 1
 W $C(13),"             ",$C(13)
 Q 0
 ; 
MGRKEY ; EP - OPTION: VEN GUI VALIDATOR
 W !!,"Assign the key VENZMGUI to selected IT personnel and supervisors..."
 D HOLD^VENPCCQ7("VENZMGUI^VENZDESKTOP^VENZKBEDIT","M")
 I $$STOP
 Q
 ; 
DESKKEY ; EP - OPTION: VEN GUI KB MANAGER
 W !!,"Assign user privileges for the WCM Desktop GUI components..."
 D HOLD^VENPCCQ7("VENZDESKTOP","U")
 I $$STOP
 Q
 ; 
KBKEY ; EP - OPTION: VEN GUI DESKTOP KEY
 W !!,"Assign user privileges for the WCM Knowledgebase Management components..."
 D HOLD^VENPCCQ7("VENZKBEDIT","U")
 I $$STOP
 Q
 ;
MSR ; EP - CHECK MEASUREMENTS
 ; FIX ISSUE WITH CIHA CORRUPT DEFINITION OF ASQP
 N %
 N DIC,DIE,DA,DR,X,Y,Z,DLAYGO,TYPE,IEN,CODE
 S (DIC,DIE,DLAYGO)=9999999.07,DIC(0)="LO",DA="",IEN=""
 F  S DA=$O(^AUTTMSR("B","ASQP",DA)) Q:'DA  D
 . S TYPE=$P($G(^AUTTMSR(DA,0)),U,2) I TYPE="" Q
 . I TYPE="ASQ - PROBLEM SOLVING" S IEN=DA Q
 . I TYPE="ASQ PROBLEM SOLVING" D  Q  ; FIX SITES THAT HAD ALPHA VERSION OF 2.6
 .. S TYPE="ZSQ",CODE="00"
 .. S DR=".01////^S X=TYPE;.02////^S X=TYPE;.03////^S X=CODE;.04////^S X=1"
 .. L +^AUTTMSR(DA):1 I  D ^DIE L -^AUTTMSR(DA)
 .. Q
 . Q
 I IEN D ^XBFMK Q
 S X="ASQP",TYPE="ASQ - PROBLEM SOLVING",CODE=64
 D ^DIC I Y=-1 Q
 S DA=+Y,DR=".02////^S X=TYPE;.03////^S X=CODE"
 L +^AUTTMSR(DA):1 I  D ^DIE L -^AUTTMSR(DA)
 D ^XBFMK
 Q
 ;
PRE ; PRE INSTALL
 W !!,"Refreshing the VEN EHP KIDS SUPPORT file",!! ; IHS/OIT/GIS  2/6/2012
 N DIK,DA S DA=0,DIK="^VEN(7.26,"
 F  S DA=$O(^VEN(7.26,DA)) Q:'DA  D ^DIK ; REFRESH KIDS SUPPORT FILE
 ; 
 W !!,"Refreshing the VEN EHP ASQ QUESTIONNAIRE file",!!
 S DIK="^VEN(7.14,",DA=0 ; IHS/OIT/GIS  2/6/2012
 F  S DA=$O(^VEN(7.14,DA)) Q:'DA  D ^DIK ; REFRESH THE VEN EHP ASQ QUESTIONNAIRE FILE TO FORCE ENTRY OF NEW CUTOFF SCORES
 ; 
 ; Check if alpha site installed as version 2.65 and fix
 I $$VERSION^XPDUTL("VEN")=2.65 D
 . NEW I
 . S I=$O(^DIC(9.4,"C","VEN",0)) S:I'>0 I=$O(^DIC(9.4,"B","VEN",0))
 . S VENUPD(9.4,I_",",13)=2.6
 . D FILE^DIE("","VENUPD")
 . K VENUPD
 ;
 ; For alpha sites that might have mispellings
 NEW TEXT,IEN
 F TEXT="IHS.WCM.EHR.ASQ.ASQCOMPONENT","IHS.WCM.EHR.PATIENTED.PATIENTEDCOMPONENT" D
 . S IEN=$$FIND1^DIC(19930.2,"","B",TEXT,"","","ERROR")
 . I IEN=0 Q
 . S VENUPD(19930.2,IEN_",",1)="@"
 I $D(VENUPD) D FILE^DIE("","VENUPD")
 K VENUPD
 Q
 ; 
CSC265 ; EP - OPTION: VEN WCM MODULE CHECK UP
 ; VALIDATE PCC+ 2.6 PATCH 5: WCM GUI
 N MODE,OK,X,Y,Z,%,BUILD,ERR,BIEN,MP,MPIEN,DIC,DIE,DA,DR,DLAYGO,D0,V,KIEN,VFLAG,KEY,OPT,BOIEN
 S BUILD="PCC+*2.6*5",VFLAG=1
 S OK=0,ERR=0
 W !!!?10,"*****  WCM VALIDATION AND CONFIGURATION PROCEDURES  *****",!!
 G GETMODE
 ; 
BOX(X) ; EP - HIGHLIGHT TEXT INSIDE A * BOX
 I $G(X)="" Q
 I $L(X)>73 Q
 N Y,Z,%
 S %=$L(X)+1
 S Y="",$P(Y," ",%)="",Z="",$P(Z,"*",%+6)=""
 S X="*  "_X_"  *",Y="*  "_Y_"  *"
 W !!!,Z,!,Y,!,X,!,Y,!,Z,!!
 Q
 ;
MODE(MODE) ; SELECT MODALITY AT THIS SITE
 N DIE,DA,X,Y,Z,%
 S MODE=""
 W !!,"At this site, how will WCM be deployed:"
 W !?4,"1. Using the EHR"
 W !?4,"2. Using traditional PCC+ paper forms"
 W !?4,"3. Using the freestanding, Windows desktop version of the WCM"
 S DIR(0)="N^1:3:0",DIR("A")="Deployment mode",DIR("B")="1" KILL DA D ^DIR K DIR
 S MODE=Y
 Q
 ;
INTRO ; EP - MSG TO START THE VALIDATION AND CONFIG PROCESS
 S X="The basic content of the WCM has been installed"
 I '$G(VFLAG) D BOX(X)
 W !!,"Now we will VALIDATE the Well Child Module..."
 W !?2,"When you see the <> prompt, press <Enter> to continue or '^' to stop"
 W !?2,"Please follow this process to the end"
 W !?2,"If you terminate prematurely, you will need to repeat the KIDS install"
 W !!
 Q
 ;
MP(MPIEN) ; MEASUREMENT PANEL
 N X,Y,Z,%,MP
 S ERR="",MPIEN=""
 S MP="ASQ DEVELOPMENT SCORES"
 S MPIEN=$O(^APCHSMPN("B",MP,0))
 Q
 ;
WCEC(ERR) ; WELL CHILD EXAM COMPONENT
 S ERR=""
 N X,Y,Z,%,DIC,DIE,DA,DR,DLAYGO,TAG
 S X="WELL CHILD EXAM",DIC="^APCHSCMP(",DIC(0)="LO",DLAYGO=9001016
 D ^DIC I Y=-1 S ERR=1 Q
 S DIE=DIC,DA=+Y,DR="1////^S X=TAG;2///NO"
 S TAG="WCE;VENPCCQA"
 L +^APCHSCMP(DA):1 I  D ^DIE L -^APCHSCMP(DA)
 Q
HST(OK) ; BUILD 'WELL CHILD EXAM' HEALTH SUMMARY TYPE
 S OK=0
 N X,Y,Z,%,DIC,DA,DR,DLAYGO,CIEN,CMP,PND,STG,CDA,MO,TL,MPIEN,MDA,PCE,MP
 I $O(^APCHSCTL("B","WELL CHILD EXAM",0)) Q  ; ITS ALREADY IN THERE
 S DIC="^APCHSCTL(",DIC(0)="LO",X="WELL CHILD EXAM",DLAYGO=9001015
 D ^DIC I Y=-1 S OK=1 Q
 S DA=+Y,DIE=DIC,DR="3////^S X=PND",PND="Y"
 L +^APCHSCTL(DA):1 I  D ^DIE L -^APCHSCTL(DA)
HCMP S STG="DEMOGRAPHIC DATA^MEASUREMENT PANELS (OUTPATIENT^WELL CHILD EXAM" ; ADD COMPONENTS
 F PCE=1,2,3 S CMP=$P(STG,U,PCE),CIEN(PCE)=$O(^APCHSCMP("B",CMP,0))
 S DA(1)=DA,DIC="^APCHSCTL("_DA(1)_",1,",(DLAYGO,DIC("P"))=9001015.01,DIC(0)="LO"
 F Z=1,2,3 I $G(CIEN(Z)) S X=Z*10 D ^DIC I Y'=-1 S CDA(+Y)=CIEN(Z)
 S DIE=DIC,DA=0,MO=5,TL="2Y"
 F  S DA=$O(CDA(DA)) Q:'DA  D
 . S CIEN=CDA(DA)
 . S DR="1////^S X=CIEN"
 . I DA=20 S DR=DR_";2////^S X=MO;3////^S X=TL"
 . L +^APCHSCTL(DA(1),1):1 I  D ^DIE L -^APCHSCTL(DA(1),1)
 . Q
HMP S STG="PEDIATRIC STD^ASQ DEVELOPMENT SCORES" ; ADD MEASUREMENT PANELS
 F PCE=1,2 S MP=$P(STG,U,PCE),MDA(PCE)=$O(^APCHSMPN("B",MP,0))
 S DIC="^APCHSCTL("_DA(1)_",3,",(DLAYGO,DIC("P"))=9001015.02,DIC(0)="LO"
 F X=1,2 I $G(MDA(X)) D ^DIC I Y=-1 K MDA(X)
 S DIE=DIC,DR="1////^S X=MPIEN",DA=0
 F  S DA=$O(MDA(DA)) Q:'DA  D
 . S MPIEN=MDA(DA) I 'MPIEN Q
 . L +^APCHSCTL(DA(1),3):1 I  D ^DIE L -^APCHSCTL(DA(1),3)
 . Q
 D ^XBFMK
 Q
 ; 
