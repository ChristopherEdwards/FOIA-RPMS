DGENEGT1 ;ALB/KCL,ISA/KWP,LBD - Enrollment Group Threshold API's ; 04/24/03 1:30pm
 ;;5.3;Registration;**232,417,454,491,513**;Aug 13, 1993
 ;
 ;
NOTIFY(DGEGT,OLDEGT) ;
 ; Description: This is used to send a message to local mail group.
 ; The notification is used to communicate changes in the Enrollment
 ; Group Threshold (EGT) setting to users at the local site.
 ;
 ;  Input:
 ;    DGEGT - the new Enrollment Group Threshold array, passed by reference
 ;   OLDEGT - the previous Enrollment Group Threshold array, passed by reference
 ;
 ; Output: None
 ;
 N TEXT,XMDUN,XMDUZ,XMTEXT,XMROU,XMSTRIP,XMSUB,XMY,XMZ,OLDPRI
 ;
 ; init subject and sender
 S XMSUB="Enrollment Group Threshold (EGT) Changed"
 S (XMDUN,XMDUZ)="Registration Enrollment Module"
 ;
 ; recipient
 S XMY("G.DGEN EGT UPDATES")=""
 ;
 ; get old EGT priority
 S OLDPRI=$G(OLDEGT("PRIORITY"))
 ;
 S XMTEXT="TEXT("
 S TEXT(1)="The Secretary of the VA has officially changed the enrollment priority"
 S TEXT(2)="grouping of veterans who shall receive care.  This change may place"
 S TEXT(3)="veterans under your facilities care into a 'Not Enrolled' category."
 S TEXT(4)=""
 S TEXT(5)=""
 S TEXT(6)="           Prior EGT Priority:  "_$S($G(OLDPRI):$$EXTERNAL^DILFD(27.16,.02,"F",OLDPRI),1:"N/A")_$S($G(OLDEGT("SUBGRP")):$$EXTERNAL^DILFD(27.16,.03,"F",OLDEGT("SUBGRP")),1:"")
 S TEXT(7)=""
 S TEXT(8)=""
 S TEXT(9)="  New Enrollment Group Threshold (EGT) Settings:"
 S TEXT(10)=""
 S TEXT(11)="                 EGT Priority:  "_$$EXTERNAL^DILFD(27.16,.02,"F",DGEGT("PRIORITY"))_$S($G(DGEGT("SUBGRP")):$$EXTERNAL^DILFD(27.16,.03,"F",DGEGT("SUBGRP")),1:"")
 S TEXT(12)="                     EGT Type:  "_$$EXTERNAL^DILFD(27.16,.04,"F",DGEGT("TYPE"))
 S TEXT(13)="           EGT Effective Date:  "_$$EXTERNAL^DILFD(27.16,.01,"F",DGEGT("EFFDATE"))
 ;
 ; mailman deliverey
 D ^XMD
 ;
 Q
 ;
 ;
DISPLAY() ;
 ; Description: Display Enrollment Group Threshold (EGT) settings.
 ;
 ;  Input: None
 ;
 ; Output: None
 ;
 N DGEGT
 ;
 W !
 I '$$GET^DGENEGT($$FINDCUR^DGENEGT(),.DGEGT) W !,"Enrollment Group Threshold (EGT) settings not found."
 E  D
 .W !,?3,"Enrollment Group Threshold (EGT) Settings"
 .W !,?3,"========================================="
 .W !
 .W !?5,"Date Entered",?25,": ",$S('$G(DGEGT("ENTERED")):"-none-",1:$$EXTERNAL^DILFD(27.16,.01,"F",DGEGT("ENTERED")))
 .W !?5,"EGT Priority",?25,": ",$S('$G(DGEGT("PRIORITY")):"-none-",1:$$EXTERNAL^DILFD(27.16,.02,"F",DGEGT("PRIORITY")))_$S($G(DGEGT("SUBGRP"))="":"",1:$$EXTERNAL^DILFD(27.16,.03,"F",DGEGT("SUBGRP")))
 .W !?5,"EGT Type",?25,": ",$S($G(DGEGT("TYPE"))="":"-none-",1:$$EXTERNAL^DILFD(27.16,.04,"F",DGEGT("TYPE")))
 .W !?5,"EGT Effective Date",?25,": ",$S('$G(DGEGT("EFFDATE")):"-none-",1:$$EXTERNAL^DILFD(27.16,.05,"F",DGEGT("EFFDATE")))
 ;
 Q
 ;
ABOVE(DPTDFN,ENRPRI,ENRGRP,EGTPRI,EGTGRP,EGTFLG) ;
 ; Description: This function will determine if the enrollment is above
 ; the threshold.
 ;
 ;Input:
 ; DPTDFN - Patient File IEN
 ; ENRPRI - Enrollment Priority
 ; ENRGRP - Enrollment Sub-Group
 ; EGTPRI - EGT Priority (optional) - not used
 ; EGTGRP - EGT Sub-Group (optional) - not used
 ; EGTFLG - Flag to bypass additional EGT type 2 check (optional)
 ;          It is used by $$ABOVE2 to prevent re-entering the
 ;          sub-priority API ($$SUBPRI^DGENELA4)
 ; Output:
 ; Returns 1 if above 0 below. 
 ;
 I $G(ENRGRP)="" S ENRGRP=""
 I $G(ENRPRI)="" S ENRPRI=""
 N ABOVE,EGT,TODAY,X
 I '$$GET^DGENEGT($$FINDCUR^DGENEGT(),.EGT) Q 1
 D NOW^%DTC S TODAY=X
 I TODAY<EGT("EFFDATE") Q 1
 ;
 ;EGT type 2 - Stop New Enrollments
 ; or EGT type 4 - Enrollment Decision (ESP DG*5.3*491)
 I EGT("TYPE")=2!(EGT("TYPE")=4) D  Q ABOVE
 .S ABOVE=0
 .;do check for priorities 7 and 8
 .I ENRPRI>6&(ENRPRI=EGT("PRIORITY")) D  Q
 ..I ENRGRP'>EGT("SUBGRP") S ABOVE=1
 ..Q:$G(EGTFLG)
 ..I EGT("TYPE")=4,ENRPRI=EGT("PRIORITY"),ENRGRP'=$$SUBPRI^DGENELA4(DPTDFN,ENRPRI,ENRGRP) S ABOVE=0 Q
 ..I ENRGRP=EGT("SUBGRP"),ENRGRP'=$$SUBPRI^DGENELA4(DPTDFN,ENRPRI,ENRGRP) S ABOVE=0
 .I ENRPRI'>EGT("PRIORITY") S ABOVE=1 Q
 ;
 ;EGT types 1 & 3
 ;do check for priorities 7 and 8
 I ENRPRI>6&(ENRPRI=EGT("PRIORITY")) S ABOVE=0 D  Q ABOVE
 .I ENRGRP'>(EGT("SUBGRP")) S ABOVE=1
 I ENRPRI'>(EGT("PRIORITY")) Q 1
 Q 0
 ;
ABOVE2(DPTDFN,ENRDT,PRIORITY,SUBGRP) ;
 ;
 ; Input: DPTDFN    - Patient File IEN
 ;        ENRDT     - enrollment effective date
 ;        PRIORITY  - enrollment priority
 ;        SUBGRP    - enrollment sub-priority (internal numeric value)
 ;
 ; Output: 1 or 0 for above or below EGT threshold
 ;
 N ABOVE,TODAY,X,EGT
 S ABOVE=1
 S:'$G(SUBGRP) SUBGRP=""
 S:'$G(PRIORITY) PRIORITY=""
 S:'$G(ENRDT) ENRDT=""
 D NOW^%DTC S TODAY=X
 Q:'$$GET^DGENEGT($$FINDCUR^DGENEGT(),.EGT) 1
 Q:'$G(EGT("EFFDATE")) 1
 Q:TODAY<EGT("EFFDATE") 1
 Q:EGT("TYPE")#2 $$ABOVE(DPTDFN,PRIORITY,SUBGRP,"","",1)  ;If EGT type 1 or 3
 I '$$ABOVE(DPTDFN,PRIORITY,SUBGRP,"","",1) Q 0
 I PRIORITY=EGT("PRIORITY"),ENRDT,ENRDT'<EGT("EFFDATE") D
 .I EGT("TYPE")=4 S ABOVE=0 Q
 .I SUBGRP=EGT("SUBGRP") S ABOVE=0
 Q ABOVE
