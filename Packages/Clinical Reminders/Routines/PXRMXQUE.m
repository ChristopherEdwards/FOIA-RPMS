PXRMXQUE ; SLC/PJH - Reminder reports general queuing routine.;01/12/2002
 ;;1.5;CLINICAL REMINDERS;**6**;Jun 19, 2000
 ;
QUE(DESC,IODEV,ROUTINE,SAVE) ;Queue a task.
 ;
 N ZTSAVE,ZTRTN,ZTIO,ZTDESC
 D @SAVE
 S ZTDESC=DESC
 S ZTIO=IODEV
 S ZTRTN=ROUTINE
 D ^%ZTLOAD
 I $D(ZTSK)=0 W !!,DESC," cancelled"
 E  W !!,DESC," has been queued, task number ",ZTSK
 Q $G(ZTSK)
 ;
 ;=======================================================================
REQUE(DESC,ROUTINE,TASK) ;Reque a task.
 N ZTSAVE,ZTRTN,ZTIO,ZTDESC
 S ZTDESC=DESC
 S ZTRTN=ROUTINE
 S ZTSK=TASK
 D REQ^%ZTLOAD
 Q
