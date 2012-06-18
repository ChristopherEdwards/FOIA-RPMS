DGENL2 ;ALB/RMO - Patient Enrollment - Build List Area Cont.;16 JUN 1997 ; 10/12/01 3:58pm
 ;;5.3;Registration;**121,147,232,306,417**;Aug 13,1993
 ;
HIS(DGARY,DFN,DGENRIEN,DGLINE,DGCNT) ;Enrollment history 
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGENRIEN Enrollment IEN
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N DGENR,DGNUM,DGPRIEN,DGSTART
 ;
 S DGSTART=DGLINE ;starting line number
 S DGNUM=0 ;selection number
 D SET^DGENL1(DGARY,DGLINE,"Enrollment History",31,IORVON,IORVOFF,,,,.DGCNT)
 ;
 ;Enrollment date, status, priority, date/time entered
 S DGLINE=DGLINE+1
 D SET^DGENL1(DGARY,DGLINE," Effective Date     Status              Priority    Date/Time Entered",5,,,,,,.DGCNT)
 S DGLINE=DGLINE+1
 D SET^DGENL1(DGARY,DGLINE,"===============================================================================",1,,,,,,.DGCNT)
 S DGPRIEN=DGENRIEN
 F  S DGPRIEN=$$FINDPRI^DGENA(DGPRIEN) Q:'DGPRIEN  D
 . I $$GET^DGENA(DGPRIEN,.DGENR) D
 . . S DGNUM=DGNUM+1
 . . S DGLINE=DGLINE+1
 . . D SET^DGENL1(DGARY,DGLINE,DGNUM,1,,,"EH",DGNUM,DGPRIEN,.DGCNT)
 . . D SET^DGENL1(DGARY,DGLINE,$S($G(DGENR("EFFDATE")):$$EXT^DGENU("EFFDATE",DGENR("EFFDATE")),1:""),5,,,,,,.DGCNT)
 . . D SET^DGENL1(DGARY,DGLINE,$S($G(DGENR("STATUS")):$E($$EXT^DGENU("STATUS",DGENR("STATUS")),1,19),1:""),25,,,,,,.DGCNT)
 . . D SET^DGENL1(DGARY,DGLINE,$S($G(DGENR("PRIORITY")):DGENR("PRIORITY")_$$EXTERNAL^DILFD(27.11,.12,"F",$G(DGENR("SUBGRP"))),1:""),45,,,,,,.DGCNT)
 . . D SET^DGENL1(DGARY,DGLINE,$S($G(DGENR("DATETIME")):$$EXT^DGENU("DATETIME",DGENR("DATETIME")),1:""),57,,,,,,.DGCNT)
 Q
