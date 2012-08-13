INHPSAL ;KN ; 11 Jul 96 00:44; MFN Loader Activates Software Application Control Utility - Main
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
EN ;Main entry point to interactively process interfaces
 D:'$G(DUZ) ENV^UTIL Q:'$G(DUZ)
 ;Get user parameters
 Q:'$$PARM(.INPAR)
 ;Process user actions
 D PROC(.INPAR)
 ;
 Q
 ;
PROC(INPAR) ;Process selected actions
 ;
 ;Run control routine for interface(s) selected
 S ININT="" F  S ININT=$O(INPAR("APSEL",ININT)) Q:'$L(ININT)  D
 .  ;Run application program
 .  S %=$$PROCINT^INHPSAL1(ININT,.INPAR)
 ;
 Q
 ;
PARM(INPAR) ;Obtain user parameters
 ;OUTPUT:
 ;   INPAR - array of parameters (pbr)
 ;        ("APPL", x ) = interface application data
 ;                       name ^
 ;                          x = inteface application identifier
 ;                          => MDIS, CLIN, MHC, AP, BB 
 ;                          => CIW, TEST, PROTO
 ;        ("APCO" , x ) =  interface name ^ control routine
 ;        ("APSEL", x ) = interface application selected
 ;        ("DESTSEL", x ) = destination selected
 ;        ("DEST", x ) = destination data
 ;    
 ;
 ;Create array of interface applications and control parameters
 D APPLAR
 ;Select an interface
 Q:'$$INTSEL^INHPSAM(.INPAR) 0
 ;Ask for specific destination
 Q:'$$DESTSEL(.INPAR) 0
 ;Ask if OK to continue
 W !!,"WARNING: The MFN Loader can have dramatic effects."
 W ! Q:'$$YN^UTSRD("Are you sure you wish to continue ;0") 0
 W ! Q:'$$YN^UTSRD("Are you absolutely positive you wish to continue ;0") 0
 ;
 Q 1
 ;
DESTSEL(INPAR) ;Select a destination
 ;
 N INEX
 W !!,"Select a destination: ",!
 ;INEX = external system name that user selects, ex AP, BB, TSC
 S INEX=$O(INPAR("APSEL",0))
 ;get the destination string for ext sys name, ex: if BB get HL BLOOD BAN
 S (XYZ)=$P($T(@INEX+1),";;",2,99)
 ;set up and call DIC
 S DIC="^INRHD(",DIC(0)="AEQZ"
 S DIC("S")="I $P(^(0),U)[XYZ"
 D ^DIC
 ;quit if look up fails
 Q:Y=-1 0
 ;+Y contains the ien number.
 S INPAR("DESTIEN")=+Y
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
 Q
 ;
DATACOM ;Description of DATA tag
 ;;  format -  ;; interface application name ^  appl indentifier
DATA ;Data
 ;;Anatomic Pathology^AP
 ;;DBSS^BB
 ;;Clinical Integrated Workstation^CIW
 ;;TRICARE Support Contractor^TSC
 ;;
AP ;;DESTINATION: ANATOMIC PATHOLOGY
 ;;ANATOMIC PATHOLOGY
 ;
BB ;;       DESTINATION: HL BLOOD BANK
 ;;HL DBS
 ;
CIW ;;     DESTINATION: HL CIW - OUT
 ;;HL CIW
 ;
TSC ;;     DESTINATION: HL TSC
 ;;HL TSC
 ;
