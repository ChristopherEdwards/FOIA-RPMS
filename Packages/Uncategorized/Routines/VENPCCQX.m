VENPCCQX ; IHS/OIT/GIS - POST INSTALL & APPLICATION CONFIG OPTION ; [ 03/05/09   4:34 PM ]
 ;;2.6;PCC+;**1,3**;MAR 23, 2011
 ;
 ;
 ;
CSCX N CNT D CSC(.CNT) I '$G(CNT) W !,"Enjoy the well child module..." ; POST INIT ENTRY POINT
 D PAUSE^VENPCCU
 Q
 ; 
CSC(CNT) ; EP - ENVIRONMENT CHECKER FOR VER 2.6
 N X,Y,Z,%,PCE,FILE,SUB,MEAS,DIEN,TOT,DA,DR,DIE,DIK,DDER,BIEN,MIEN,%Y,DLAYGO,IEN,PCE,A
 S CNT=0,Z=0
 W !,"Checking all the components of the Well Child Module...",!
 W !,"After each section, press the <RETURN> key when you see the '<>' symbol",!!!
RTN W !,"CHECKING WCM ROUTINES: "
 S X="^VENPCCQ,^VENPCCQ1,^VENPCCQA,^VENPCCQB,^VENPCCQC,^VENPCCQD,^VENPCCQY,^VENPCCQZ,"
 S X=X_"^VENPCCK,^VENPCCK1,^VENPCCKB,^VENPCCKX,^VENPCC1M,^VENKINIT,^VENLINIT,^VENMINIT"
 F PCE=1:1:$L(X,",") D
 . S Y=$P(X,",",PCE)
 . S %=$P(Y,U,2) I '$L(%) Q
 . X "I $L($T("_Y_"))"
 . I  W !?10,%,?20,"<- OK" Q
 . W !?10,"The routine ",%," is missing!"
 . S Z=1
 . Q
 W !
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required routines have been successfully installed"
 W ! I '$$WAIT G BAIL
 D XRT^VENPCCQZ
 W ! I '$$WAIT G BAIL
KB W !,"UPDATING KNOWLEDGEBASE"
 I $O(^VEN(7.12,999999),-1)>3000 W !?10,"Well child knowledgebase is installed" G KB1 ; KB IS UP TO DATE
 I '$L($T(^VENKINIT)) G VPTED^VENPCCQZ ; NEW PT ED FILE
 W !!,"When asked if you want to overwrite security codes, answer 'NO'"
 W !,"When asked if everything is OK, answer 'YES'",!!
CLEANUP ; FIRST CLEAN UP KB FILES, BUT LEAVE OLD KB ITEMS FROM VER 2.5
 I $D(^VEN(7.12,0)) S DIK="^VEN(7.12,",DA=0 F  S DA=$O(^VEN(7.12,DA)) Q:'DA  I +$G(^VEN(7.12,DA,0))>7 D ^DIK
 I $D(^VEN(7.11,0)) S DIK="^VEN(7.11,",DA=0 F  S DA=$O(^VEN(7.11,DA)) Q:'DA  D ^DIK
 I $D(^VEN(7.13,0)) S DIK="^VEN(7.13,",DA=0 F  S DA=$O(^VEN(7.13,DA)) Q:'DA  D ^DIK
 I $L($T(^VENKINIT)) D ^VENKINIT W ! ; RESTORE KB FILES AND CONTENT!
KB1 D DINFO^VENPCCQZ W ! ; CHECK/FIX KB POINTERS
 I '$$WAIT G BAIL
FILE W !,"CHECKING FILES: "
 S Z=0
 S X="9000010.161^9000010.46^90093.99^19707.11^19707.12^19707.13^19707.14,19707.4119"
 F PCE=1:1:$L(X,U) D
 . S Y=+$P(X,U,PCE)
 . S FILE=$P($G(^DIC(Y,0)),U)
 . I Y=19707.4119 S FILE="VEN EHP EF TEMPLATES"
 . I Y=9000010.161 S FILE="V PATIENT ED"
 . I $D(^DD(Y)) W !?10,"File: ",FILE,"  <- OK" Q
 . I Y=9000010.46,$L($T(^VENMINIT)) D VWC^VENPCCQZ Q  ; ADD V WELL CHILD FILE
 . I Y=9000010.161,$L($T(^VENLINIT)) D VPTED^VENPCCQZ Q  ; UPDATE V PATIENT ED
 . W !?10,"File: ",FILE,"  <- LATEST VERSION NOT FOUND!!!" S Z=1
 . Q
 W !
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required files have been successfully installed"
 W ! I '$$WAIT G BAIL
PTED W !,"CHECKING PAITENT EDUCATION CODES: "
 D TOPIC^VENPCCKB
 W !,?5,"All required patient education codes have been successfully installed"
 W ! I '$$WAIT G BAIL
MSR W !,"CHECKING MEASUREMNT TYPES: "
 S X="ASQL^ASQG^ASQF^ASQP^ASQS^ASQM"
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . S %=+$O(^AUTTMSR("B",Y,0)) S MEAS=$P($G(^AUTTMSR(%,0)),U,2)
 . I '$L(MEAS) W !?10,"The measurement ",Y," is missing!" S Z=1 Q
 . W !?10,"Measurement: ",MEAS,"  <- OK" Q
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required measurement types have been successfully installed"
 W ! I '$$WAIT G BAIL
DIE W !,"CHECKING INPUT TEMPLATES: "
 S X="APCD WC (ADD)^APCD WC (MOD)",Z=0
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . S %=$O(^DIE("B",Y,0))
 . I '% W !?10,"The input template ",Y," is missing!" S Z=1 Q
 . W !?10,"Input template: ",Y,"  <- OK"
 . S Y=$NA(^DIE(%,"ROU"))
 . S @Y="^VENPCCQB" ; SET COMPLIED INPUT TEMPLATE NODE
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required input templates have been successfully installed"
 W ! I '$$WAIT G BAIL
MN W !,"CHECKING DATA ENTRY MNEMONICS: "
 S X="WCE"
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . I '$O(^APCDTKW("B",Y,0)) W !?10,"The data entry mnemonic ",Y," is missing!" S Z=1 Q
 . W !?10,"Data entry mnemonic: ",Y,"  <- OK" Q
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required data entry mnemonics have been successfully installed"
 W ! I '$$WAIT G BAIL
RPC W !,"CHECKING REMOTE PROCEDURE CALLS: "
 S X="VEN ASQ GET PATIENT ID^VEN ASQ GET DATA^VEN ASQ GET VISITS^VEN ASQ START TX^VEN ASQ FLUSH^BMX ADO SS"
 S X=X_U_"VEN KB EDIT PTED^VEN KB EDIT DEV^VEN KB EDIT AUT^VEN KB EDIT EXAM"
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . I '$O(^XWB(8994,"B",Y,0)) W !?10,"The RPC ",Y," is missing!" S Z=1 Q
 . W !?10,"RPC: ",Y,"  <- OK" Q
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required RPCs have been successfully installed"
 W ! I '$$WAIT G BAIL
OPT W !,"CHECKING OPTIONS: "
 S X="BMXRPC^VEN RPC^VEN WCM ACTIVATE DOMAIN^VEN WCM PLACE BROKER OPTION"
 S X=X_"^VEN WCM_MENU^VEN WCM START OR STOP BROKER"
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . I '$O(^DIC(19,"B",Y,0)) W !?10,"The Option ",Y," is missing!" S Z=1 Q
 . W !?10,"Option : ",Y,"  <- OK" Q
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required options have been successfully installed"
 W ! I '$$WAIT G BAIL
KEY W !,"CHECKING SECURITY KEYS FOR THE KNOWLEDGEBASE EDITOR: "
 S X="VENZKBEDIT"
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . I '$O(^DIC(19.1,"B",Y,0)) W !?10,"The Key ",Y," is missing!" S Z=1 Q
 . W !?10,"Key : ",Y,"  <- OK"
 . D HOLD^VENPCCQZ(Y) ; GET HOLDERS
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required security keys have been successfully installed"
 W ! I '$$WAIT G BAIL
HSMP W !,"CHECKING HEALTH SUMMARY MEASUREMENT PANEL: "
 S X="ASQ DEVELOPMENT SCORES"
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . I '$O(^APCHSMPN("B",Y,0)) W !?10,"The data measurement panel ",Y," is missing!" S Z=1 Q
 . W !?10,"Measurement panel: ",Y,"  <- OK" Q
 . Q
MPF S X="5|M^10|L^20|G^30|F^40|P^50|S" ; CONFIRM MEASUREMNT PANEL FIELDS
 F PCE=1:1:6 D
 . S %=$P(X,U,PCE),Y=+%,A="ASQ"_$P(%,"|",2)
 . S DA=$O(^APCHSMPN("B","ASQ DEVELOPMENT SCORES",0)) I 'DA Q
 . S %=$NA(^APCHSMPN(DA,1))
 . S DA=$O(^AUTTMSR("B",A,0)) I 'DA Q
 . S $P(@%@(Y,0),U,2)=DA
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"All required measurement panels have been successfully installed"
 W ! I '$$WAIT G BAIL
WCE W !,"CHECKING HEALTH SUMMARY WELL CHILD EXAM COMPONENT: "
 S X="WELL CHILD EXAM"
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . I '$O(^APCHSCMP("B",Y,0)) D  ; IF KIDS FAILS
 .. S DIC="^APCHSCMP(",DIC(0)="L",X="WELL CHILD EXAM" D ^DIC I Y=-1 Q
 .. S DIE=DIC,DA=+Y,DR="1////^S X=TAG;2///NO",TAG="WCE;APCHS6B"
 .. L +^APCHSCMP(DA):1 I  D ^DIE L -^APCHSCMP(DA)
 .. Q
 . I '$O(^APCHSCMP("B",Y,0)) W !?10,"The health summary component ",Y," is missing!" S Z=1 Q
 . W !?10,"Health summary component: ",Y,"  <- OK" Q
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,?5,"The required components have been successfully installed"
 W ! I '$$WAIT G BAIL
HS W !,"CHECKING WELL CHILD HEALTH SUMARY TYPE: "
 S Y="WELL CHILD EXAM"
 I '$O(^APCHSCTL("B",Y,0)) W !?10,"The health summary type ",Y," is missing!" S CNT=CNT+1 G MCK
 W !?10,"Health summary type: ",Y,"  <- OK"
 W !,?5,"The required health summary types have been successfully installed"
HSCMP S Z=0 D CMP^VENPCCQZ(.Z) I Z S Z=0,CNT=CNT+1 ; CHECK HS 
 D MP^VENPCCQZ ; MAKE SURE CORRECT MEASUREMENT PANELS ARE ASSIGNED TO THIS HEALTH SUMMARY TYPE
 W ! I '$$WAIT G BAIL
BOC W !!,"CHECKING BROKER OPTION CONTENT"
 S X="VEN ASQ GET PATIENT ID^VEN ASQ GET DATA^VEN ASQ GET VISITS^VEN ASQ START TX^VEN ASQ FLUSH^BMX ADO SS"
 S X=X_U_"VEN KB EDIT PTED^VEN KB EDIT DEV^VEN KB EDIT AUT^VEN KB EDIT EXAM"
 S IEN=$O(^DIC(19,"B","VEN RPC",0)) I 'IEN W !,"The broker option VEN RPC is missing" G HSMP
 F PCE=1:1:$L(X,U) D
 . S Y=$P(X,U,PCE)
 . S %=$O(^XWB(8994,"B",Y,0))
 . I '% W !?10,"RPC '",Y,"' has not been assigned to broker option VEN RPC" S Z=1 Q
 . Q
 I Z S Z=0,CNT=CNT+1
 E  W !,"All required RPCs have been assigned to broker option VEN RPC"
 W ! I '$$WAIT G BAIL
MCK D MENU^VENPCCQZ ; ASSIGN BROKER OPTIONS TO EXISTING MENUS
 D SMENU^VENPCCQZ ; ASSIGN THE BROKER OPTION TO INDIVIDUAL USERS AS A SECONDARY MENU
 W ! I '$$WAIT G BAIL
 D ACT
 D OCX
FIN D ^XBFMK
 I 'CNT W !!,"All required RPMS components are present and accounted for!" Q
 W !!?20,"****  WARNING   ****",!!,"One or more critical RPMS components is missing from the Well Child Module"
 W !,"You may need to reinstall the system.  Please check with the OIT help desk"
 Q
 ;
OCX ; EP - REGISTER FORM IN THE OCX COMPONENT FILE - REQUIRED FOR ALL VERSIONS OF MEASUREMENT PLOTTING
 N DIC,DLAYGO,DA,X,Y
 S X=$O(^VEN(7.41,"B","WELL CHILD EXAM (NATL)",0)) I 'X Q
 S DA(1)=$O(^VEN(7.62,"B","PEDS GROWTH CHART",0)) I 'DA(1) Q
 S DIC="^VEN(7.62,"_DA(1)_",6,",DIC(0)="L"
 S (DLAYGO,DIC("P"))=19707.626,X="`"_X
 D ^DIC
 Q
 ; 
MENU ; EP - ASSIGN BROKER OPTIONS TO EXISTING MENUS
 D MENU^VENPCCQZ
 Q
 ; 
CONVERT ; EP - CONVERT OLD WELL CHILD FORMS
 W !!,"Checking all of your well child templates to see if they use",!,"the new knowledgebase format..."
 N TIEN,X,Y,Z,%,DIC,DIE,DA,DR,CIEN,DOM,DIEN,TMPL
 S TIEN=0,CIEN=$O(^VEN(7.11,"B","WELL CHILD NUTRITION",0))
 F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  I '$O(^VEN(7.41,TIEN,19,0)),$D(^VEN(7.41,TIEN,16,"B",CIEN)) D
 . S TMPL=$P($G(^VEN(7.41,TIEN,0)),U) I '$L(TMPL) Q
 . W !?5,"OK to convert ",TMPL," to new format"
 . S %=1 D YN^DICN
 . I %'=1 Q
 . S DA(1)=TIEN,DIC="^VEN(7.41,"_DA(1)_",19,"
 . S DIC("P")=$P(^DD(19707.41,19,0),U,2),DLAYGO=+DIC("P"),DIC(0)="L"
 . S DOM="WELL CHILD NATL"
 . F  S DOM=$O(^VEN(7.13,"B",DOM)) Q:DOM'["WELL CHILD NATL"  D
 .. S DIEN=$O(^VEN(7.13,"B",DOM,0)) I 'DIEN Q
 .. S X="`"_DIEN
 .. D ^DIC I Y=-1 Q
 .. S %=$S(DOM[" DEV ":10,DOM[" AG ":20,DOM[" NUTR ":30,DOM[" EXAM ":40,1:"")
 .. I % S $P(^VEN(7.41,TIEN,19,+Y,0),U,2)=% ; ORDER
 .. Q
 . W " <- OK"
 . Q
 D ^XBFMK
 Q
 ; 
ACT ; EP - ACTIVATE A DOMAIN
 D ACT^VENPCCQZ
 Q
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
BAIL ; EP - ABORT THE SESSION
 W !!,"Comprehensive check of the well baby module has been prematurely terminated!"
 W !,"Please try again later..."
 Q
 ; 
WAIT() ; EP-WAIT STATE
 N %
 W "<>"
W1 R %:$G(DTIME,300) E  Q 0
 W $C(13),?79,$C(13)
 I %?1."^" Q 0
 I %?1."?" W "Press the <ENTER> key to keep scrolling or '^' to quit <>" G W1
 Q 1
 ; 
BRK ; EP - START/STOP THE BROKER
 N %,%Y
 W !!,"Want to start the WCM broker now" ; START THE BROKER
 S %=1
 D YN^DICN I %'=1 Q
 D STRT^BMXMON(10501)
BRK1 ; STOP THE BROKER
 W !!,"The broker is currently running.  Want to stop it" ; STOP THE BROKER
 S %=1
 D YN^DICN I %'=1 Q
 D STOP^BMXMON
 Q
 ; 
CIA(DA,OUT) ; EP - SCREEN CIA OBJECTS FOR KIDS BUILD
 S OUT=""
 I $D(DA)
 E  Q
 N X,Y,Z,%
 S X=$P($G(^CIAVOBJ(19930.2,DA,0)),U) I X="" Q
 S Y=$E(X,1,8)
 I Y="FILE:BMX" S OUT=1 Q
 I Y="FILE:IND" S OUT=1 Q
 I Y="FILE:INF" S OUT=1 Q
 I Y="FILE:ITE" S OUT=1 Q
 I Y="IHS.WCM." S OUT=1 Q
 Q
 ; 
