BEHOVMIN ;MSC/IND/DKM - Installation Support ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**001002**;Mar 20, 2007
 ;=================================================================
PREINIT ;EP - Preinitialization
 Q
POSTINIT ;EP - Postinitialization
 N LP,CLS
 F LP=0:1 S CLS=$P($T(CANENTER+LP),";;",2) Q:'$L(CLS)  D
 .D ADD^XPAR("CLS."_CLS,"BEHOVM DATA ENTRY",,"YES")
 D ADD^XPAR("PKG","BEHOVM USE VMSR",,$G(DUZ("AG"))="I")
 D REGMENU^BEHUTIL("BEHOVM MAIN",,"VIT")
 Q
 ; List of user classes that can enter vitals by default
CANENTER ;;PROVIDER
 ;;NURSE
 ;;NURSE PRACTITIONER
 ;;NURSE LICENSED PRACTICAL
 ;;NURSING ASSISTANT
 ;;NURSING SUPERVISOR
 ;;NURSE CLINICAL SPECIALIST
 ;;
