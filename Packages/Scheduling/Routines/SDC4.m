SDC4 ;ALB/MJK - Check Range for CO'ed Appts; 28 JUN 1993 [ 02/10/2005  4:06 PM ]
 ;;5.3;Scheduling;**1002**;Aug 13, 1993
 ;
COED(SDCL,SDBEG,SDEND,SDMSG) ; -- scan appts for those co'ed
 N SDDA,SDATE,SD0,SDC,SDESC
 S SDESC=0,SDATE=SDBEG-.0000001
 F  S SDATE=$O(^SC(SDCL,"S",SDATE)) Q:'SDATE!(SDATE>SDEND)  D
 .S SDDA=0 F  S SDDA=$O(^SC(SDCL,"S",SDATE,1,SDDA)) Q:'SDDA  S SD0=^(SDDA,0),SDC=$G(^("C")) D
 ..I $P(SD0,U,9)="C" Q
 ..;IHS/ITSC/WAR 1/27/2005 PATCH #1002 Can't Cancel CL w/a CKD-IN Pt
 ..; Added next line and code to line tag MES (see below) 
 ..I $P(SDC,U,1),'$P(SDC,U,3) S SDESC=-1  ;CK-IN, BUT NOT CKD-OUT YET
 ..I $P(SDC,U,3) S SDESC=1
 I SDESC,SDMSG D MES
 Q SDESC
 ;
MES ; -- write warning to user
 ;IHS/ITSC/WAR 1/27/2005 PATCH #1002 Added If/Else and addt'l msg
 ;  Original code only had 6 lines of code which follow: 
 ;W *7
 ;W !?5,"At least one appointment has been checked out in the time"
 ;W !?5,"period selected."
 ;W !!?5,"As a result, to avoid the loss of workload credit, you are"
 ;W !?5,"not allowed to cancel availability for this time period."
 ;W ! 
 I SDESC=-1 D
 .N X S X="IOBON;IOBOFF"
 .D ENDR^%ZISS
 .W *7
 .W !!?5,"It appears that there is a patient checked in, but not yet"
 .W !?5,"checked out for the "
 .W $S(SDEND[".2359":"DAY ",1:"TIME RANGE ")
 .W "you have selected."
 .W IOBON
 .W !!?5,"     Action must be taken to CK-OUT the patient"
 .W !?5,"       before this process can be completed."
 .W IOBOFF
 .;D KILL^%ZISS  ;Removes only variables defined with ENDR^%ZISS
 E  D
 .W *7
 .W !?5,"At least one appointment has been checked out in the time"
 .W !?5,"period selected."
 .W !!?5,"As a result, to avoid the loss of workload credit, you are"
 .W !?5,"not allowed to cancel availability for this time period."
 W !
 ;IHS/ITSC/WAR 1/27/2005 PATCH #1002 End of changes.
 Q
