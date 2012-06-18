RA5IPST ;HIRMFO/GJC - Post-init Driver patch five ;10/20/98  08:04
VERSION ;;5.0;Radiology/Nuclear Medicine;**5**;Mar 16, 1998
 ;
 S RAIPST=$$NEWCP^XPDUTL("PST1","EN1^RA5IPST")
 ; Post-init for patch five.  Set ^DD(71,0,"ID","WRITE")
 ; (remove the WRITE command from the data dictionary)
 ; before: ^DD(71,0,"ID","WRITE") = W ?54,$$PRCCPT^RADD1()
 ; after : ^DD(71,0,"ID","WRITE") = D EN^DDIOL($$PRCCPT^RADD1(),"","?54")
 ;
EN1 ; Entry point for "ID","WRITE" node cleanup
 Q:'$D(XPDNM)  ; no-op, only run during KIDS install
 S ^DD(71,0,"ID","WRITE")="D EN^DDIOL($$PRCCPT^RADD1(),"""",""?54"")"
 ; Note: This is part of DBIA: 2642
 K RAIPST
 Q
