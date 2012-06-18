TIUPS155 ; SLC/CAM - Amended consult note clean up ;2/26/03
 ;;1.0;TEXT INTEGRATION UTILITIES;**155**;Jun 20,1997 
 ; 
 ; Disassociates the retracted consult note from the consult
 ; Links the amended note to the consult
 ; This routine should only need to be run once. It can be deleted after 
 ; it has successfully completed.
 ; DBIA 10035  ^DPT(  .01    NAME   0;1  Direct Global Read 
 ; DBIA 3576   TIU use of GMRCTIU
 ; DBIA 3162 POINT TO REQUEST/CONSULTATION (#123) FILE
 ; 
PRINT ; -- Device Selection
 ;
 S %ZIS="Q" D ^%ZIS I POP K POP G PRT
 I $D(IO("Q")) K IO("Q") D  Q
 . S ZTRTN="LINK^TIUPS155"
 . S ZTDESC="TIU*1*155 - PRINT CLEAN-UP RESULTS"
 . D ^%ZTLOAD W !,$S($D(ZTSK):"Request queued",1:"Request Cancelled!")
 . K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,%ZIS
 . D HOME^%ZIS
 U IO D LINK,^%ZISC
PRT Q
 ;
LINK ; Updates the GMR global with the amended consult note. Stores in XTMP global
 ; Rollsback retracted note from ^GMR(123 node 50
 N TIUDA,TIUDA2,STATUS,GMRCSTAT,TIUAUTH,FLAG
 N CNSERV,TIUPT,TIUPT1,TIUCNT,CNSLT,TIUY,TIUODA
 ;    Variables
 ;  TIUPT = Patient DFN
 ;  TIUPT1 = Patient name
 ;  CNSERV = To consult service
 ;  TIUDA = IEN of note in TIU "G" cross ref
 ;  TIUDA2 = IEN of note in GMR "B" cross ref of 50 node
 ;  TIUODA = IEN  of retracted note
 I $D(ZTQUEUED) S ZTREQ="@"
 S U="^"
 S TIUCNT=0,CNSLT=""
 D HDR
 F  S CNSLT=$O(^TIU(8925,"G",CNSLT)) Q:CNSLT=""  I CNSLT["GMR" D
 .S TIUDA=0
 .F  S TIUDA=$O(^TIU(8925,"G",CNSLT,TIUDA)) Q:TIUDA=""  D
 ..S STATUS=$P($G(^TIU(8925,TIUDA,0)),U,5) I STATUS=8 D
 ...S TIUY=+$$ISA^TIULX(+$G(^TIU(8925,TIUDA,0)),+$$CLASS^TIUCNSLT)
 ...I TIUY=1 D
 ....S TIUDA2=0
 ....S FLAG="NO" F  S TIUDA2=$O(^GMR(123,+CNSLT,50,"B",TIUDA2)) Q:TIUDA2=""  I +TIUDA2=TIUDA S FLAG="YES" Q
 ....I FLAG="NO" D
 .....S TIUCNT=TIUCNT+1
 .....S TIUODA=$P($G(^TIU(8925,TIUDA,14)),U,6)
 .....S TIUPT=$P($G(^TIU(8925,TIUDA,0)),U,2)
 .....S TIUPT1=$P($G(^DPT(TIUPT,0)),U) I $L(TIUPT1)<25 S TIUPT1=$$ADDSP(TIUPT1)
 .....S CNSERV=$$GET1^DIQ(123,+CNSLT,1) I $L(CNSERV)<25 S CNSERV=$$ADDSP(CNSERV)
 .....S ^XTMP("TIUP155",$J,TIUCNT)=$E(TIUPT1,1,25)_"   Consult No. "_+CNSLT
 .....S GMRCSTAT=$S(STATUS>6:"COMPLETED",1:"INCOMPLETE")
 .....S TIUAUTH=$P($G(^TIU(8925,TIUDA,12)),U,2)
 .....D ROLLBACK^TIUCNSLT(TIUODA)
 .....D GET^GMRCTIU(+CNSLT,TIUDA,GMRCSTAT,TIUAUTH)
 .....W !,$E(TIUPT1,1,20),?22,$E(CNSERV,1,20),?45,+CNSLT
 W !
 I TIUCNT'>0 W !,"There are no records to print."
 D MAIL
 W !
 Q
ADDSP(TIUY) ; Add space to name for display.
 ;
 N SPC,LEN,ADSP,CNT
 S SPC=" ",LEN=$L(TIUY),ADSP=25-LEN
 F CNT=1:1:ADSP S TIUY=TIUY_SPC
 Q TIUY
MAIL ; Send mail message
 ;
 N XMSUB,XMTEXT,XMY,XMTXT,XMDUZ
 S XMSUB="TIU*1*155 Amended Note - Consult Clean up Report",XMDUZ="Patch TIU*1*155"
 I '$D(^XTMP("TIUP155")) S XMTXT(1)="",XMTXT(2)="",XMTXT(3)="There are no records to print.",XMTEXT="XMTXT("
 I $D(^XTMP("TIUP155")) S XMTEXT="^XTMP(""TIUP155"",$J,"
 S:$G(DUZ) XMY(DUZ)=""
 S XMY("G.PATIENT SAFETY NOTIFICATIONS")=""
 D ^XMD
 Q
HDR ;  --Header for report--
 ;
 W !,?2,"TIU*1.0*155 Amended Note - Consult Clean Up Report"
 W !!,"The following consult(s) have been updated to display and print amended"
 W !,"notes on the Consult Tab."
 W !!,"Patient",?22,"Consult Request",?45,"Consult No.",!
 Q
