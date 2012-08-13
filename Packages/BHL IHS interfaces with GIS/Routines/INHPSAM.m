INHPSAM ; FRW ; 18 Aug 1999 09:23:25; Interface Application control utility - main
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
TASKDEV(INPAR,INVERBOS) ; ask for device name and task to process the user action
 ;Input:
 ;   INPAR -  array of parameters
 ;   INVERBOS - verbose
 ;   INDISCRP - if set to one and user  action is show
 ;              it shows the dicrepancies report too
 N %ZIS,X,ZTDESC,ZTIO,ZTRTN,ZTSAVE
 ;Device handling & Tasking logic
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ" D ^%ZIS G:POP QUIT
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) S ZTDESC="Interface application Control utility",ZTIO=IOP,ZTRTN="PROC^INHPSAM(.INPAR)" D  G QUIT
 .F X="INPAR(","INVERBOS","INDISCRP" S ZTSAVE(X)=""
 .D ^%ZTLOAD
ENQUE ; Taskman entry point - Process user actions
 D PROC(.INPAR,INVERBOS)
 G QUIT
 ;
QUIT ;exit module
 D ^%ZISC K IO("Q"),IOP,POP
 Q
 ;---------------------------------------------------------
SHOWONLY ;Main entry point to show only process interfaces
 ;  this entry is called from a menu option
 N INSHOWME
 S INSHOWME=1
 D EN
 Q
 ;
EN ;Main entry point to interactively process interfaces
 N INPAR,INVERBOS
 D:'$G(DUZ) ENV^UTIL
 ;Get user parameters
 Q:'$$PARM(.INPAR)
 ;ask decvice  and task to Process user actions
 D TASKDEV(.INPAR,$G(INVERBOS))
 ;
 Q
 ;
SUMALL ;display summary of all production interfaces
 ;
 D:'$G(DUZ) ENV^UTIL
 D ALL(3)
 Q
 ;
SHOWALL ;show all production interfaces
 ;
 D:'$G(DUZ) ENV^UTIL
 D ALL(2)
 Q
 ;
ACTIV ;Activate all production interfaces
 ;
 D ALL(1)
 Q
 ;
DEACT ;Deactivate all production interfaces
 ;
 D ALL(0)
 Q
 ;
ALL(INST) ;Process all production interfaces
 ;
 N INVERBOS,X,INPAR
 ;S INVERBOS=1
 D APPLAR
 S INST=+$G(INST),INPAR("ACT")=INST,INPAR("REPL")=0
 F X="TRAC","AP","BB","BCC","CHCSII","CIW","CLIN","CRSPL","CRSPR","DINPACS","HIV","ITS","DMHRS","LSI","MDIS","MHC","NMIS","PDTS","PMN","PWS","TSC","TSCL" S INPAR("APSEL",X)=""
 D TASKDEV(.INPAR,$G(INVERBOS))
 ;
 Q
 ;
COMPSUM(INPAR) ;  compile and report the status of all interfaces
 ;Input:
 ;  INPAR - array of parameters for all interfaces
 ;
 N HDR,INPAGE,INTER,INPARFND,INMTF,INTIME
 S INPAGE=0
 S INMTF=$$GETMTF^INHPSA(),INTIME=$$CDATASC^%ZTFDT($H,1,1)
 S HDR(1)="INMTF,?(IOM-27),INTIME,"" PAGE:"",$J(INPAGE,4)"
 S HDR(2)="""Interface Status"""
 S HDR(3)="",$P(HDR(3),"-",IOM)="",HDR(3)=""""_HDR(3)_""",!"
 ;S HDR(1)="""Interface Status"",?(IOM-10),""PAGE:"",$J(INPAGE,4)"
 ;S HDR(2)="",$P(HDR(2),"-",IOM)="",HDR(2)=""""_HDR(2)_""",!"
 D HEADER^INHMG
 S INTER=""
 F  S INTER=$O(INPAR("APSEL",INTER)) Q:'$L(INTER)!$G(DUOUT)  D PROCSUM(INTER,.INPAR,.INPARFND)
 Q:$G(DUOUT)
 I $G(INPARFND) D
 .D T^INHMG1 W !
 .D T^INHMG1 W " *PARTIAL means that an interface has both active and inactive transactions."
 .D T^INHMG1 W "          This usually means that the transactions are used by multiple"
 .D T^INHMG1 W "          interfaces."
 Q
PROCSUM(INTER,INPAR,INPARFND) ; process and report the status of one interface only
 ;Input:
 ;  INTER - interface application identifier
 ;  INPAR - array of parameters for all interfaces
 ;  INPARFND - if set it means that this interface has both active
 ;             and inactive transactions (PARTIAL)
 ;
 N INDAT,INREC,ACTIVE,INACTIVE,STAT,DA,DIC,X,Y,INNAME
 S (ACTIVE,INACTIVE)=0
 I '$$CREDAT^INHPSA(.INDAT) D T^INHMG1 W "ERROR: "_INTER_" Unable to create data array" Q
 S INREC=0
 F  S INREC=$O(INDAT(INTER,4004,INREC)) Q:'INREC  D
 .S (INNAME,X)=$P(INDAT(INTER,4004,INREC),U)
 .S DIC=4004,DIC(0)="",Y=$$DIC^INHPSA(DIC,X,"",DIC(0)),DA=+Y
 .I INNAME'=$P(Y,U,2) D T^INHMG1 W "ERROR: Wanted background process ",INNAME," but found ",$P(Y,U,2)," (",+Y,")." Q 0
 .I DA<0 D T^INHMG1 W "ERROR:  Background Process: ",INNAME," not found."
 .I $P($G(^INTHPC(DA,0)),U,2) S ACTIVE=1
 .E  S INACTIVE=1
 ;
 S INREC=0
 F  S INREC=$O(INDAT(INTER,4000,INREC)) Q:'INREC  D
 .I $P(INDAT(INTER,4000,INREC),U,2) Q    ; do not include this transaction if suppress deactivation flag is set
 .S (INNAME,X)=$P(INDAT(INTER,4000,INREC),U)
 .S DIC=4000,DIC(0)="",Y=$$DIC^INHPSA(DIC,X,"",DIC(0)),DA=+Y
 .I DA<0 D T^INHMG1 W "ERROR:  Transaction Type: ",INNAME," not found. But found ",$P(Y,U,2)," (",+Y,")." Q
 .I INNAME'=$P(Y,U,2) D T^INHMG1 W "ERROR: Wanted transaction type ",INNAME
 .I $P($G(^INRHT(DA,0)),U,5) S ACTIVE=1
 .E  S INACTIVE=1
 ;
 S STAT=""
 I ACTIVE,'INACTIVE S STAT="ACTIVE"
 I 'ACTIVE,INACTIVE S STAT="INACTIVE"
 I ACTIVE,INACTIVE S STAT="PARTIAL",INPARFND=1
 D T^INHMG1 Q:$G(DUOUT)  W STAT,?11,INTER,?20,$P(INPAR("APPL",INTER),U)
 Q
 ;
PROC(INPAR,INVERBOS) ;Process selected actions
 ;Input:
 ;   INPAR -  array of parameters
 ;   INVERBOS - verbose
 ;   INDISCRP - if set to one and user  action is show
 ;              it shows the dicrepancies report too
 ;
 N DUOUT
 I INPAR("ACT")=3 D COMPSUM(.INPAR) Q
 N INPAGE,ININT,INNOOUT
 I INPAR("ACT")<2 S INNOOUT=1   ;do not let user to abort if activating or deactivating
 ;Run control routine for interface(s) selected
 S INPAGE=0
 S ININT="" F  S ININT=$O(INPAR("APSEL",ININT)) Q:'$L(ININT)!$G(DUOUT)  D
 .  ;?? Preprocess to verify that application will load correctly
 .  ;
 .  ;Run application program
 .  S %=$$PROCINT^INHPSA(ININT,.INPAR)
 ;
 Q
 ;
PARM(INPAR) ;Obtain user parameters
 ;OUTPUT:
 ;   INPAR - array of parameters (pbr)
 ;        ("APPL", x ) = interface application data
 ;                       name ^
 ;                          x = interface application identifier
 ;                          => MDIS, CLIN, MHC, AP, BB
 ;                          => CIW, TEST, PROTO
 ;        ("APCO" , x ) =  interface name ^ control routine
 ;        ("APSEL", x ) = interface application selected
 ;        ("REPL")   =  replicate ( 1 - yes ; 0 - no (def) )
 ;        ("ACT")    =  action ( 1- activate ; 0 - deactivate
 ;                               2 - show)
 ;
 ;
 ;Create array of interface applications and control parameters
 D APPLAR
 ;Select an interface
 Q:'$$INTSEL(.INPAR) 0
 ;How created (replicated or parent) - default to parent - DEFER
 S INPAR("REPL")=0
 ;---I $G(XQO)'="" S INPAR("ACT")=2 Q 1     ;if this program was entered from a menu then this is a show action only
 I $G(INSHOWME) S INPAR("ACT")=2 Q 1     ;if this is a show only,  do not ask for activate or deactivate
 ;Select an action (activate or deactivate)
 W !! S %=$$SOC^UTIL("Select Action: ;;;1,30","","SHOW^ACTIVATE^DEACTIVATE",0)
 Q:'$L(%)!(%[U) 0 S INPAR("ACT")=$S($E(%,U,4)["DEAC":0,$E(%,U,4)["ACTI":1,1:2)
 I INPAR("ACT")=2 Q 1    ; this is a show action
 ;Ask if OK to continue
 W !!,"WARNING: Modifying the status of interfaces can have dramatic effects."
 W ! Q:'$$YN^UTSRD("Are you sure you wish to continue ;0") 0
 W ! Q:'$$YN^UTSRD("Are you absolutely positive you wish to continue ;0") 0
 ;
 Q 1
 ;
INTSEL(INPAR) ;Select an interface
 ;
 N DAT,%
 W !
 S %="",DAT=""
 F  S %=$O(INPAR("APPL",%)) Q:'$L(%)  W !,?3,%,?13,$P(INPAR("APPL",%),U) S DAT=DAT_U_%
 S DAT=$E(DAT,2,999)
 W !!
 S %=$$SOC^UTIL("Select Interface Application: ;;;1,8","",DAT,0)
 Q:'$L(%)!(%[U) 0
 S INPAR("APSEL",%)=""
 ;
 Q 1
 ;
APPLAR ;Create array of interface applications
 ;
 K INPAR N L,L2,NA
 F LC=1:1 S L=$P($T(DATA+LC),";;",2,99) Q:'$L(L)  D
 .  ;S L2=$P($T(DATA+(LC+1)),";;",2,99),NA=$P(L,U,2)
 .  S NA=$P(L,U,2),L2="Q"
 .  ;Quit if no routine or no identifier
 .  Q:'$L(L2)!'$L(NA)
 .  S INPAR("APPL",NA)=L
 .  S INPAR("APCO",NA)=L2
 ;action - activate (def)
 S INPAR("ACT")=1
 ;Replicate or Parent - default to parent/child
 S INPAR("REPL")=0
 Q
 ;
DATACOM ;Description of DATA tag
 ;;  format -  ;; interface application name ^  appl indentifier
DATA ;Data
 ;;Anatomic Pathology^AP
 ;;DBSS^BB
 ;;Breast Care Clinic^BCC
 ;;CHCS II^CHCSII
 ;;Clinical Integrated Workstation^CIW
 ;;Clinicomp^CLIN
 ;;CRSP Local^CRSPL
 ;;CRSP Regional^CRSPR
 ;;DINPACS^DINPACS
 ;;HIV Viromed/HIV ABTS Receiver Phase 2^HIV
 ;;Immunization Tracking System EuroCHCS/DEERS^ITS
 ;;DMHRS^DMHRS
 ;;Lab System Interface^LSI
 ;;MDIS^MDIS
 ;;MHCMIS (CEIS)^MHC
 ;;Nutrition Management Interface System^NMIS
 ;;Pacmednet^PMN
 ;;Pharmacy Data Transaction Service^PDTS
 ;;Provider WorkStation^PWS
 ;;TRACES^TRAC
 ;;TRICARE Support Contractor^TSC
 ;;TRICARE Support Contractor Loader^TSCL
 ;;
 ;;Test Functionality^TEST
 ;;Prototype Functionality^PROTO
 ;;
