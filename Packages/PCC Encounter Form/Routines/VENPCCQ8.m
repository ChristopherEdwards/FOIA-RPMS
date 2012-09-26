VENPCCQ8 ; IHS/OIT/GIS - BUILD VALIDATION ROUTINE ;  [ 03/05/09   4:34 PM ]
 ;;2.6;PCC+;**1,4,5**;APR 03, 2012;Build 24
 ;
 ;
 ; VALIDATE PCC+ GUI INSTALLATION ; CAN ONLY BE RUN AFTER FULL KIDS INSTALL HAS BEEN COMPLETED ; 
 ;
 ; 
CSC261 ; EP - VALIDATE PCC+ 2.6 PATCH 1: WCM GUI
 N %
 S %="PCC+*2.6*1" D VALIDATE(%)
 Q
 ; 
VALIDATE(BIEN,MODE,OK,ERR) ; EP - VALIDATE WCM CONTENT
 I $G(BIEN),$G(MODE)
 E  S ERR=1 Q
 N X,Y,Z,%,RTN,FIEN,RPC
 S OK=0,ERR=0
 ; 
RTN W !,"Checking required ROUTINES..."
 S RTN="",OK=0
 F  S RTN=$O(^XPD(9.6,BIEN,"KRN",9.8,"NM","B",RTN)) Q:RTN=""  D
 . X ("I $L($T(^"_RTN_"))")
 . E  W !?5,U,RTN," is missing!" S OK=1,ERR=1
 . Q
 I 'OK D
 . W "   < All ROUTINES installed"
 . I $L($T(^VENCS265)) D
 .. W !,"ROUTINE checksum verification..."
 .. D CSUM^VENCS265(.OK)
 .. I OK S ERR=1,OK=0 W !?5,"Integrity check violation!!" Q
 .. W "  < All ROUTINES passed"
 .. Q
 I $$STOP S OK=2 Q
 I MODE'=2 G FILE ; BYPASS DATA ENTRY RTN CHECK IF WCM USED IN EHR OR DEKTOP MODE
 ; 
FILE W !,"Checking required FILES..."
 S FIEN=0,OK=0
 F  S FIEN=$O(^XPD(9.6,BIEN,4,"B",FIEN)) Q:'FIEN  D
 . I $D(^DD(FIEN,0)) Q
 . W !?5,"File ",FIEN," is missing!"
 . S OK=1,ERR=1
 . Q
 I 'OK W "   < All FILES present"
 I $P($G(^VEN(7.14,5,0)),U,2)'=15.64 D  ; IHS/OIT/GIS  2/6/2012
 . I OK W !
 . W "   < The VEN EHP ASQ QUESTIONNAIRE file has not been updated!"
 . S OK=1,ERR=1
 . Q
 I $$STOP S OK=2 Q
 ; 
MEAS W !,"Checking MEASUREMENT TYPES..."
 D BADASQP ; CLEAN OUT CORRUPTED MEASUREMENT TYPE ASQP
 S OK=0
 S %="AFGLMPS"
 F I=1:1:$L(%) D  ; ASQ MEASUREMENT VERIFICATION AND VALIDATION TAG
 . S X=$E(%,I)
 . S Y=$O(^AUTTMSR("B",("ASQ"_X),0))
 . I 'Y S OK=1,ERR=1 W !?5,"Measurement type ASQ"_X_" is missing!" Q
 . I X="M" S ^AUTTMSR(Y,12)="I X'?1.2N K X" Q
 . S ^AUTTMSR(Y,12)="D ASQX^VENPCCQ"
 . Q
 I 'OK W "   < All MEASUREMENT TYPES present"
 I $$STOP S OK=2 Q
 ; 
KEY W !,"Checking SECURITY KEYS..."
 S KEY="",OK=0
 F  S KEY=$O(^XPD(9.6,BIEN,"KRN",19.1,"NM","B",KEY)) Q:KEY=""  D
 . I $O(^DIC(19.1,"B",KEY,0)) Q
 . W !?5,"The key ",KEY," is missing!"
 . S OK=1,ERR=1
 . Q
 I 'OK W "   < All KEYS present"
 E  S ERR=1
 I $$STOP S OK=2 Q
 ;
OPT W !,"Checking OPTIONS..."
 S OPT="",OK=0
 F  S OPT=$O(^XPD(9.6,BIEN,"KRN",19,"NM","B",OPT)) Q:OPT=""  D
 . I $O(^DIC(19,"B",OPT,0)) Q
 . W !?5,"The option ",OPT," is missing!"
 . S OK=1,ERR=1
 . Q
 I MODE=2 G KEY
 S BOIEN=$O(^DIC(19,"B","VEN RPC",0))
 I 'BOIEN S ERR=1,OK=1,ERR=1 W !?5,"The broker option 'VEN RPC' is missing"
 I 'OK W "   < All OPTIONS present"
 I $$STOP S OK=2 Q
 ; 
RPC W !,"Checking REMOTE PROCEDURE CALLS..."
 N RIEN
 S RPC="",OK=0
 F  S RPC=$O(^XPD(9.6,BIEN,"KRN",8994,"NM","B",RPC)) Q:RPC=""  D
 . S RIEN=$O(^XWB(8994,"B",RPC,0))
 . I 'RIEN D  Q
 .. W !?5,"The RPC ",RPC," is missing!"
 .. S OK=1,ERR=1
 .. Q
 . I 'BOIEN  S OK=1 Q
 . I $O(^DIC(19,BOIEN,"RPC","B",RIEN,0)) Q
 . D BOR(BOIEN,RIEN,RPC,.OK) ; REGISTER THE RPC IN BROKER OPTION 'VEN RPC'
 . Q
 I 'OK,MODE=1 D CIABMX^VENPCCQ7(.OK) ; CHECK THE RPC FOR BMX 4.0
 I OK S ERR=1
 I 'OK W "   < All RPCs present and registered"
 I 'BOIEN W !?5,"Because broker option 'VEN RPC' is missing.  No RPCs can be registered."
 I $$STOP S OK=2 Q
 I MODE'=2 G CSCX
 ;
DIE W !,"Checking INPUT TEMPLATES: "
 S OK=0
 S X="APCD WC (ADD)^APCD WC (MOD)",Z=0
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . S %=$O(^DIE("B",Y,0))
 . I '% W !?5,"The input template ",Y," is missing!" S OK=1 Q
 . S Y=$NA(^DIE(%,"ROU"))
 . S @Y="^VENPCCQB" ; SET COMPLIED INPUT TEMPLATE NODE
 . Q
 I OK S OK=0,ERR=1
 E  W "  < All required INPUT TEMPLATES present"
 I $$STOP S OK=2 Q
 ; 
MN W !,"Checking DATA ENTRY MNEMONICS: "
 I '$O(^APCDTKW("B","WCE",0)) W !?10,"The data entry mnemonic 'WCE' is missing!" S ERR=1
 E  W "  < All required MNEMONICS present"
 I $$STOP S OK=2 Q
 Q
 ; 
CSCX ; FINISH UP
 I $G(ERR) W !!,"The Well Child GUI validation process detected at least one problem",! S X="Please take corrective action and reinstall this patch." G EXITMSG
 I $G(OK)=2 W !!,"The validation process was terminated prematurely!",!,"Please complete the validation at a later time"
 I '$G(OK),'$G(ERR)
 E  I $$STOP Q
SUCCESS S X="Congratulations!  The Well Child GUI module has been VALIDATED"
EXITMSG D BOX(X)
 Q
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
BMX(OK) N %,BIEN,X,Y,Z,STG
 S OK=0
 W !!,"Checking BMX.NET..."
 I '$L($T(^BMXEHR)) D  Q
 . W !!,"Uh oh!..."
 . W !,"The BMX.NET Broker package (Ver 3.0 or higher) has not been installed."
 . W !,"Well Child Module GUI installation aborted!!!"
 . W !,"Install the BMX.NET Broker package now, and then rerun this KIDS build"
 . S OK=1,ERR=1
 . Q
 I 'OK W "  < Broker installed"
BMXSCH W !,"Checking BMX SCHEMAS..."
 S OK=0
 I '$O(^BMXADO("B","VEN CF VISIT LIST",0)) S OK=1,ERR=1 W !?5,"The schema 'VEN CF VISIT LIST' is missing!!"
 E  W "   < All BMX SCHEMAS are present"
 Q
 ; 
BROKER ; EP - IF USING DESKTOP, CONFIGURE THE BROKER
 W !!,"The BMX Broker must be running continuously to enable the WCM desktop"
 W !?5,"You must start the BMX Broker each time the RPMS server is re-booted"
 W !?5,"The BMXNet Management menu has options to START and STOP the BMX Broker"
BMXMON W !!,"Checking BMX PORT MONITOR..." ; IF USING DESKTOP VERSION, LISTENER MUST BE REGISTERED AND STARTED
 I '$O(^BMXMON(0)) D  Q
 . W !!,"Currently, there are no ports assigned to the BMX MONITOR"
 . W !?5,"Please assign a port number for this namespace"
PORT . S DIR(0)="NO^1:63999:0",DIR("A")="Port number" KILL DA D ^DIR KILL DIR
 . I 'Y D  Q
 .. W !!,"The WCM will not be functional without an active BMX Monitor port"
 .. W !,"Use the EDIT option on the BMXNet Management menu to register a port"
 .. W !,"Use the STRT option on the BMXNet Management menu to activate a port"
 .. Q
 . Q
 S BIEN=0,STG=""
 F  S BIEN=$O(^BMXMON(BIEN)) Q:'BIEN  D
 . S Z=+$G(^BMXMON(BIEN,0)) I 'Z Q
 . I STG'="" S STG=STG_", "
 . S STG=STG_Z
 . Q
 I STG["," W !!,"The following ports have been assigned to BMX: ",!?5
 E  W !!,"The following port has been assigned to BMX: "
 W STG
 W !,"Use the STRT option on the BMXNet Management menu to activate a port"
 Q
 ; 
STOP() W !,"<>" ; EP - WAIT
 R %:DTIME
 I %?1."^" Q 1
 W $C(13),"             ",$C(13)
 Q 0
 ; 
SBMX ; EP - OPTION: VEN WCM START OR STOP BROKER
 N %,%Y,X,Y,Z,DIR,PORT
 S DIR(0)="NO^5000:99999:",DIR("A")="Enter BMX port",DIR("B")="9200"
 D ^DIR I Y'>1 Q
 S PORT=+Y
BSTART I $$SEMAPHOR^BMXMON(PORT,"LOCK") D  S %=$$STOP Q  ; START THE BROKER
 . S %=1
 . W !!,"Want to start the BMX broker listener now"
 . D YN^DICN I %'=1 Q
 . W !!
 . D STRT^BMXMON(PORT)
 . Q
BSTOP ; STOP THE BROKER
 W !!,"The BMX broker listener is currently running on port "_PORT,!," Want to stop it" ; STOP THE BROKER
 S %=1
 D YN^DICN I %'=1 Q
 W !!
 D STOP^BMXMON(PORT)
 I $$STOP
 Q
 ;
HDR ; EP - OPTION HEADER
 W !?10,"WCM GUI Management"
 W !,"----------------------------------------------------------",!!
 Q
 ; 
BOR(BOIEN,RIEN,RPC,OK) ; EP - REGISTER A WCM RPC IN THE BROKER OPTION VEN RPC
 I $G(BOIEN),$G(RIEN),$G(RPC)'=""
 E  Q
 N X,Y,Z,DIC,DIE,DA,DR,DLAYGO,%
 S DA(1)=BOIEN
 S DIC="^DIC(19,"_DA(1)_",""RPC"","
 S (DIC("P"),DLAYGO)=19.05
 S X="`"_RIEN,DIC(0)="LO"
 D ^DIC
 I Y=-1 W !?5,"RPC '",RPC,"' is not registered in broker option VEN RPC" S OK=1,ERR=1
 D ^XBFMK
 Q
 ; 
BADASQP ; EP - FIX SITES THAT HAD ALPHA VERSION OF 2.6 WITH CORRUPT ASQP
 N %
 N DIC,DIE,DA,DR,X,Y,Z,DLAYGO,TYPE,IEN,CODE
 S (DIC,DIE,DLAYGO)=9999999.07,DIC(0)="LO",DA="",IEN=""
 F  S DA=$O(^AUTTMSR("B","ASQP",DA)) Q:'DA  D
 . S TYPE=$P($G(^AUTTMSR(DA,0)),U,2) I TYPE="" Q
 . I TYPE="ASQ - PROBLEM SOLVING" S IEN=DA Q
 . I TYPE="ASQ PROBLEM SOLVING" D  Q  ; DEACTIVATE THE BAD MEASUREMENT
 .. S TYPE="ZSQ",CODE="00"
 .. S DR=".01////^S X=TYPE;.02////^S X=TYPE;.03////^S X=CODE;.04////^S X=1"
 .. L +^AUTTMSR(DA):1 I  D ^DIE L -^AUTTMSR(DA)
 .. Q
 . Q
 I IEN D ^XBFMK Q  ; THE GOOD MEASUREMENT IS ALREADY IN THERE SO QUIT
 ; NEED TO REGISTER THE GOOD MEASUREMENT
 S X="ASQP",TYPE="ASQ - PROBLEM SOLVING",CODE=64
 D ^DIC I Y=-1 Q
 S DA=+Y,DR=".02////^S X=TYPE;.03////^S X=CODE"
 L +^AUTTMSR(DA):1 I  D ^DIE L -^AUTTMSR(DA)
 D ^XBFMK
 Q
 ; 
BOPT(OK) ; EP - PLACE BROKER OPTION ON PRIMARY MENU OR ASSIGN IT TO INDIVIDUAL PROVIDER AS A SECONDARY MENU
 S OK=0
 N DIK,X,Y,Z,%,OIEN
 S OIEN=$O(^DIC(19,"B","VEN RPC",0))
 I 'OIEN W !!,"Unable to find VEN RPC in the OPTION file!",!! Q
 W !,"A user must have broker option VEN RPC to use the Well Child Module!!!"
 W !!?5,"1. Add VEN RPC option to the Primay Menu(s) of WCM users (recommended)"
 W !?5,"2. Assign VEN RPC to individual users as a seconday menu option"
 W !?5,"3. Quit"
 S DIR(0)="NO^1:3:",DIR("A")="Your choice" D ^DIR K DIR
 I Y=1 D BOPT1(OIEN,.OK) Q
 I Y=2 D BOPT2(OIEN,.OK)
 Q
 ; 
BOPT1(OIEN,OK) ; ADD VEN RPC TO PRIMARY MENU(S)
 N DIC,DA,X,Y,Z,%,MORE,RIEN,DA,DR,DLAYGO,PIEN,DO,GBL
 S MORE=0
LOOP1 I 'MORE S DIC("A")="Enter a primary menu assigned to WCM users: ",MORE=1
 E  S DIC("A")="Enter another primary menu assigned to WCM users: "
 S DIC="^DIC(19,",DIC(0)="AEQM"
 D ^DIC I Y=-1 D ^XBFMK Q
 K DIC("A"),DO,DO(2)
 S (D0,DA(1))=+Y,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LO",X="`"_OIEN,(DLAYGO,DIC("P"))=19.01
 D ^DIC I Y=-1 W !?5,"Unable to add VEN RPC to this primary menu" S OK=1 Q
 I $P(Y,U,3)="" W !?5,"VEN RPC has already been added to this menu",! G LOOP1
 S GBL=$NA(^DIC(19,DA(1),10,+Y))
 S $P(@GBL@(0),U,2)="WCM"
 W !?5,"ADDED",!
 G LOOP1
 ; 
BOPT2(OIEN,OK) ; ADD VEN RPC TO PRIMARY MENU(S)
 N DIC,DA,X,Y,Z,%,MORE,RIEN,DA,DR,DLAYGO,PIEN,DO,GBL
 S MORE=0
LOOP2 I 'MORE S DIC("A")="Enter a WCM user: ",MORE=1
 E  S DIC("A")="Enter another WCM user: "
 S DIC="^VA(200,",DIC(0)="AEQM"
 D ^DIC I Y=-1 D ^XBFMK Q
 K DIC("A"),DO,DO(2)
 S (D0,DA(1))=+Y,DIC="^VA(200,"_DA(1)_",203,",DIC(0)="LO",X="`"_OIEN,(DLAYGO,DIC("P"))=200.03
 D ^DIC I Y=-1 W !?5,"Unable to assign this secondary menu option to the user" S OK=1 Q
 I $P(Y,U,3)="" W !?5,"VEN RPC has already been assigned to the user",! G LOOP2
 S GBL=$NA(^DIC(19,DA(1),10,+Y))
 S $P(@GBL@(0),U,2)="VENR"
 W !?5,"VEN RPC has been assigned as a secondary menu to this user",!
 G LOOP2
 ; 
