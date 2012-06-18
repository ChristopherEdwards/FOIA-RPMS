DGENUPL3 ;ALB/CJM,ISA/KWP,AEG - PROCESS INCOMING (Z11 EVENT TYPE) HL7 MESSAGES ; 04/23/2001
 ;;5.3;REGISTRATION;**147,230,232,377,404**;Aug 13,1993
 ;
 ;
ADDMSG(MSGS,MESSAGE,TOHEC) ;
 ;Description: Used to add a message to an array of messages to be sent.
 ;
 ;Input:
 ;  MSGS - the array to store the message (pass by reference)
 ;  MESSAGE - the message to store
 ;  TOHEC - a flag, if set to 1 it means that HEC should also receive notification
 ;
 ;Output: none
 ;
 I MESSAGE["DATE OF DEATH" Q
 S MSGS(0)=($G(MSGS(0))+1)
 S MSGS(MSGS(0))=MESSAGE
 I ($G(TOHEC)=1) S MSGS("HEC")=1
 Q
 ;
 ;
NOTIFY(DGPAT,MSGS) ;
 ;Description: This is used to send a message to the local mail group
 ;defined by the MAS Parameter ELIGIBILITY UPLOAD MAIL GROUP.The
 ;notification is to be used when specific problems or conditions
 ;regarding the upload of the enrollment or eligibility data.
 ;
 ;Input: 
 ;  OLDPAT -used if the DGPAT elements have not been built
 ;  DGPAT - patient array (pass by reference)
 ;  MSGS - the an array of messages that should be included in the
 ;         notification (pass by reference). If MSGS("HEC")=1
 ;         it means that HEC should also receive notification.
 ;
 ;Output:   none
 ;
 N TEXT,XMDUZ,XMTEXT,XMSUB,XMSTRIP,XMROU,XMY,XMZ,XMDF,COUNT
 N HEADER,NSC,POW,TMPSTR,MAILGRP,ELIG
 ;
 ;if there are no alerts, then quit
 Q:'$G(MSGS(0))
 ;
 ;Get reason for alert.  If there is more than one reason decide which 
 ;reason to display.  'NON-SERVICE' alerts have a higher priority than
 ;other alerts and are therefore displayed before other alerts in the 
 ;subject line, followed by 'POW' alerts in priority.
 S (ELIG,NSC,POW)=0
 S COUNT=0 F  S COUNT=$O(MSGS(COUNT)) Q:'COUNT!NSC  D
 .I MSGS(COUNT)["PREVIOUSLY ELIGIBLE" S ELIG=1 Q
 .I MSGS(COUNT)["NON-SERVICE" S NSC=1 Q
 .I MSGS(COUNT)["POW" S POW=1
 .S HEADER=MSGS(COUNT)
 .Q
 D
 .I ELIG S HEADER="Ineligibility Alert: " Q
 .I NSC S HEADER="NSC Alert: " Q
 .I POW&'NSC S HEADER="POW Alert: " Q
 .Q
 ;
 S XMDF=""
 S (XMDUN,XMDUZ)="Registration Enrollment Module"
 ;Phase II Re-Enrollment
 ;DGPAT("SSN") is built by the parser.  DGPAT("NAME"),DGPAT("SEX"),DGPAT("DOB")(are merged into DGPAT from OLDPAT.
 ;The checks below are to setup the DGPAT elements from OLDPAT if NOTIFY is called before the merge. 
 I '$D(DGPAT("NAME")) S DGPAT("NAME")=$G(OLDPAT("NAME"))
 I '$D(DGPAT("SEX")) S DGPAT("SEX")=$G(OLDPAT("SEX"))
 I '$D(DGPAT("DOB")) S DGPAT("DOB")=$G(OLDPAT("DOB"))
 S TMPSTR=" ("_$E(DGPAT("NAME"),1,1)
 S TMPSTR=TMPSTR_$E(DGPAT("SSN"),$L(DGPAT("SSN"))-3,1000)_")"
 S XMSUB=$E(HEADER,1,30)_$E(DGPAT("NAME"),1,25)_TMPSTR
 ;
 ; send msg to local mail group specified in IVM SITE PARAMETER file
 S MAILGRP=+$P($G(^IVM(301.9,1,0)),"^",9)
 S MAILGRP=$$EXTERNAL^DILFD(301.9,.09,"F",MAILGRP)
 I MAILGRP]"" S XMY("G."_MAILGRP)=""
 ;
 ; if flag is set, send msg to remote mail group specified in
 ; the IVM SITE PARAMETER file
 I $G(MSGS("HEC"))=1 D
 .S MAILGRP=$P($G(^IVM(301.9,1,0)),"^",10)
 .S MAILGRP=$$EXTERNAL^DILFD(301.9,.10,"F",MAILGRP)
 .I MAILGRP]"" S XMY("G."_MAILGRP)=""
 ;
 ;
 S XMTEXT="TEXT("
 S TEXT(1)="The enrollment/eligibility upload produced the following alerts:"
 S TEXT(2)="  "
 S TEXT(3)="Patient Name   :     "_DGPAT("NAME")
 S TEXT(4)="SSN            :     "_DGPAT("SSN")
 S TEXT(5)="DOB            :     "_$$EXTERNAL^DILFD(2,$$FIELD^DGENPTA1("DOB"),"F",DGPAT("DOB"))
 S TEXT(6)="SEX            :     "_$$EXTERNAL^DILFD(2,$$FIELD^DGENPTA1("SEX"),"F",DGPAT("SEX"))
 S TEXT(7)=" "
 ;
 S TEXT(8)=" ** Alerts **"
 S TEXT(9)=" "
 S COUNT=0 F  S COUNT=$O(MSGS(COUNT)) Q:'COUNT  S TEXT(10+COUNT)=COUNT_") "_MSGS(COUNT)
 ;
 D ^XMD
 Q
 ;
BEGUPLD(DFN) ;
 ;Description: Sets a lock used to determine if an eligibility/enrollment
 ;upload is in progress. 
 ;
 ;Input:
 ;   DFN - ien, Patient record
 ;
 ;Output:
 ;  Function value - returns 1 if the lock was obtained, 0 otherwise.
 ;
 Q:'$G(DFN) 1
 L +^DGEN("ELIGIBILITY UPLOAD",DFN):3
 Q $T
 ;
ENDUPLD(DFN) ;
 ;Description: Releases the lock obtained by calling $$BEGUPLD(DFN)
 ;
 Q:'$G(DFN)
 L -^DGEN("ELIGIBILITY UPLOAD",DFN)
 Q
 ;
CKUPLOAD(DFN) ;
 ;Description: Checks if an upload is in progress.  If so, it pauses
 ;until it is completed.
 ;The enrollment/eligibility upload can take a while to accomplish.
 ;If the lock is not obtained initially, it is assumed that the upload
 ;is in progress, and a message is displayed to the user.
 ;
 ;Input: DFN
 ;Output: none
 ;
 N I
 I '$$BEGUPLD(DFN) D
 .W !!,"Upload of patient enrollment/eligibility data is in progress ..."
 .D UNLOCK^DGENPTA1(DFN)
 .F I=1:1:50 Q:$$BEGUPLD(DFN)  W "."
 .W !,"Upload of patient enrollment/eligibility data is completed.",!
 D ENDUPLD(DFN)
 Q
