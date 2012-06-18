AVAP2 ; DSD/GTH - AVA 93.2 PATCH 2, FILE SECURITY ; [ 10/21/93  3:34 PM ]
 ;;93.2;VA SUPPORT FILES;**2**;JUL 01, 1993
 ;
 W !!,"Resetting file protection for files 5 (STATE) and 16 (PERSON)"
 W !,"to pre-d93.2 values."
 D RPI
 E  W !,"LOCK UNAVAILABLE.  NOTIFY PROGRAMMER." Q
 W !!,"DONE."
 Q
 ;
RPI ;EP - Non-Interactive entry point for Remote Patch Installation.
 ;
 LOCK +^DIC(5,0,"RD"):60 E  G ABORT
 S ^DIC(5,0,"RD")="" LOCK -^DIC(5,0,"RD")
 ;
 LOCK +^DIC(16,0,"LAYGO"):60 E  G ABORT
 S ^DIC(16,0,"LAYGO")="#" LOCK -^DIC(16,0,"LAYGO")
 ;
 LOCK +^DIC(16,0,"WR"):60 E  G ABORT
 S ^DIC(16,0,"WR")="#" LOCK -^DIC(16,0,"WR")
 ;
 Q
 ;
 ;
ABORT D @^%ZOSF("ERRTN") I 0
 Q
