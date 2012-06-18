BHLMT50 ; cmi/sitka/maw - BHL Master Table Update (Drug) User Interface ;  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will ask the user which file and entry to pass a
 ;table update to another system
 ;
MAIN ;-- this is the main routine driver
 K INA
 S INA("MFI")="^^^50^DRUG^99IHS"
 D ENT Q:$D(DUOUT)!$D(DTOUT)
 Q:Y<0
 D UPD Q:$D(DIRUT)
 S X="BHL PASS DRUG MASTER TABLE UPDATE",DIC=101 D EN^XQOR
 Q
 ;
ENT ;-- get the entry in the file
 S DIC=50,DIC(0)="AEMQZ",DIC("A")="Pass which drug: "
 D ^DIC
 Q:$D(DUOUT)!$D(DTOUT)
 Q:Y<0
 S (INDA,BHLENT)=+Y
 S BHLNDC=$$VAL^XBDIQ1(50,BHLENT,31)
 S BHLGEN=$$VAL^XBDIQ1(50,BHLENT,.01)
 S INA("PRIMKEY")=BHLNDC_U_BHLGEN_U_"NDC"
 Q
 ;
UPD ;-- ask update type
 S DIR(0)="S^MDL:Delete Record;MUP:Update Record;MDC:Deactivate Record"
 D ^DIR
 Q:$D(DIRUT)
 S INA("DORLE")=Y
 Q
 ;
EOJ ;-- end of job
 K BHLNDC,BHLGEN
 Q
 ;
TRG(BHLENT)          ;get the information for a triggered routine
 S INA("MFI")="^^^50^DRUG^99IHS"
 S BHLNDC=$$VAL^XBDIQ1(50,BHLENT,31)
 S BHLGEN=$$VAL^XBDIQ1(50,BHLENT,.01)
 S INA("PRIMKEY")=BHLNDC_U_BHLGEN_U_"NDC"
 S INA("DORLE")="MUP"
 Q
 ;
