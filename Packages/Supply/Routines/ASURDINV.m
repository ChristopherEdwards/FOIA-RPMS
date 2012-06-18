ASURDINV ; IHS/ITSC/LMH -DAILY UPDATE INV REPORTS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is used to print the daily update Invoice series of
 ;reports - R70, R71.  It is involked both by the Daily update option
 ;and by the Invoice series print option.  It involks routines
 ;^ASURD70P and ^ASURD71P.
 I '$D(IO) D HOME^%ZIS
 I '$D(DUZ(2)) W !,"Report must be run from Kernel option" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 S ASUK("PTR")="IRPT"
 S ZTRTN="PSER^ASURDINV",ZTDESC="SAMS INVOICE REPORTS"
 D O^ASUUZIS Q:$D(DTOUT)  Q:$D(DUOUT)  ;DFM P1 9/15/98
 I POP S IOP=$I D ^%ZIS Q
 I ASUK(ASUK("PTR"),"Q") Q
 S ASUK("PTRSEL")=1
PSER ;EP;FOR TASKMAN QUEUE OF PRINT
 D TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Invoice Reports Procedure Begun "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 D U^ASUUZIS
 D:$G(ASUP("TYP"))']"" SETCTRL^ASUCOSTS
 S ASUP("CKI")=+$G(ASUP("CKI"))
 I ASUP("CKI")=0 S ASUP("CKI")=1 D SETSI^ASUCOSTS
 I ASUP("CKI")=1 D ^ASURD70P S ASUP("CKI")=2 D SETSI^ASUCOSTS
 I ASUP("CKI")=2 D ^ASURD71P S ASUP("CKI")=3 D SETSI^ASUCOSTS
 I ASUP("CKI")=3 D
 .I $D(ASUV("R72 LAST DT")) D
 ..D REPRINT^ASURD72P S ASUP("CKI")=0 D SETSI^ASUCOSTS
 .E  D
 ..D ^ASURD72P S ASUP("CKI")=0 D SETSI^ASUCOSTS
 D TIME^ASUUDATE
 D C^ASUUZIS
 U IO(0)
 S ASURX="W !,""S.A.M.S. Invoice Reports Procedure Ended "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 I ASUP("CKI")=0 D
 .S ASUP("IVR")="Y",ASUP("CKP")=7 D SETSTAT^ASUCOSTS
 Q
