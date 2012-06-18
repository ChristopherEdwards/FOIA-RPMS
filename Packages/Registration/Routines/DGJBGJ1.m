DGJBGJ1 ;ALB/MAF - IRT BACKGROUND JOB (CONT.) - MAY 3 1993
 ;;5.3;Registration;**31,44,126**;Aug 13, 1993
MSG N DGJCNT,DGJDV,DGJDT,DGJCA
 S (DGJCNT,DGJDV,DGJDT,DGJCA)=0
 F  S DGJDV=$O(^TMP("VAS",$J,DGJDV)) Q:DGJDV']""  F  S DGJDT=$O(^TMP("VAS",$J,DGJDV,DGJDT)) Q:DGJDT']""  F  S DGJCA=$O(^TMP("VAS",$J,DGJDV,DGJDT,DGJCA)) Q:DGJCA']""  S DGJCNT=DGJCNT+1 S DGJMSG(DGJCNT,0)=^TMP("VAS",$J,DGJDV,DGJDT,DGJCA,0)
 I '$D(DGJMSG(1)) G Q
 ;quit it no text in message
 S XMSUB="PATIENTS DISCHARGED LESS THAN 48 HOURS"
 S XMTEXT="DGJMSG("
 S DGJB=+$P($G(^DG(43,1,"NOT")),"^",14)
 S XMY("G."_$P($G(^XMB(3.8,DGJB,0)),"^",1))="" ; pass mailgroup
 ; makes sure it gets sent to someone
 I '$D(XMY) S XMY(.5)=""
 ; make postmaster the sender so it will show up as new to DUZ
 S XMDUZ=.5
 D ^XMD:$D(XMY)
Q K DGSM,DGB,DGTEXT,XMR,DGII,XMY,XMTEXT,XMDUZ,XMSUB Q
