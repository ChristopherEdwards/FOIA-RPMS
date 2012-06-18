ORY182 ;SLC/DAN Delete incorrect allergy orders ;5/20/03  15:44
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**182**;Dec 17, 1997
 ;
 ;DBIA SECTION
 ;10141 - XPDUTL
 ;10070 - XMD
 ;10061 - VADPT
 ;10063 - %ZTLOAD
 ;10013 - DIK
 ;2056  - DIQ
 ;10067 - XMA21
 ;10060 - Access to file 200
 ;10103 - XLFDT
 ;
POST ;Search for problems, produce report, fix problems
 N ZTRTN,ZTIO,ZTDESC,ZTDTH,ZTSAVE,ZTSK
 D BMES^XPDUTL("Starting allergy order clean-up in background...")
 S ZTRTN="EN^ORY182",ZTIO="",ZTDESC="Allergy order clean up",ZTDTH=$H,ZTSAVE("DUZ")="" D ^%ZTLOAD
 Q
 ;
EN ;Start here
 N ORI,ORCNT
 K ^TMP("ORALDAT",$J)
 S ORCNT=0
 S ORI=$$GETIEN(2980101) F  S ORI=$O(^OR(100,ORI)) Q:'+ORI  D
 .I '$D(^OR(100,ORI,0)) D ERR Q  ;Record missing 0 nodes.
 .Q:$$NMSP^ORCD($P(^OR(100,ORI,0),U,14))'="GMRA"  ;Stop if not an allergy order
 .Q:$P(^OR(100,ORI,3),U,3)'=11  ;Stop if order doesn't have "unreleased" status
 .Q:'('$D(^OR(100,ORI,4.5,"ID","TYPE"))&($D(^OR(100,ORI,4.5,"ID","OBSERVED"))))  ;Stop if responses multiple doesn't match what we're looking for
 .D STORE,FIX
 D MAIL
 K ^TMP("ORALDAT",$J)
 Q
 ;
STORE ;Store information regarding order for mail message
 N NAME,SSN,DFN,TEXT,VADM
 S DFN=+$P(^OR(100,ORI,0),U,2)
 D DEM^VADPT
 S SSN=$E(+VADM(2),6,9)
 S NAME=VADM(1)
 S TEXT=$G(^OR(100,ORI,8,1,.1,1,0))
 S ORCNT=ORCNT+1
 S ^TMP("ORALDAT",$J,ORCNT)=NAME_U_SSN_U_$$GET1^DIQ(100,ORI,3,"E")_U_$$GET1^DIQ(100,ORI,4,"E")_U_TEXT
 Q
 ;
FIX ;Delete the erroneous entry in file 100
 N DA,DIK
 S DA=ORI,DIK="^OR(100," D ^DIK ;*poof*
 Q
 ;
MAIL ;Send mail message to initiator detailing results
 N XMSUB,XMTEXT,XMDUZ,XMY,XMZ,XMMG,ORTXT,ORJ,ORK,LINE,DIFROM
 S XMDUZ="Allergy order clean up"
 I $D(^XTMP("ORY182","XMY")) M XMY=^XTMP("ORY182","XMY") K ^XTMP("ORY182")
 I '$D(XMY) S XMY(.5)="" S:$G(DUZ) XMY(DUZ)=""
 S ORTXT(1)="The allergy order clean up process has finished.",ORTXT(2)="",ORK=3
 I ORCNT=0&('$D(^TMP("ORALDAT",$J,"ERR"))) S ORTXT(3)="No problems found.  No additional review is required."
 I ORCNT'=0 D
 .S ORTXT(3)="Following is information regarding orders that were deleted."
 .S ORTXT(4)="Please review any findings to make sure the patient's"
 .S ORTXT(5)="allergy information is correct.  Information shown here was NOT transmitted"
 .S ORTXT(6)="to the allergy package and may not have been correctly reported."
 .S ORTXT(7)="",ORTXT(8)="Information below is patient name, last 4, who entered, date",ORTXT(9)="entered, and order text.",ORTXT(10)=""
 .S ORK=11
 .F ORJ=1:1:ORCNT D
 ..S LINE=^TMP("ORALDAT",$J,ORJ)
 ..S ORTXT(ORK)=$P(LINE,U)_"  "_$P(LINE,U,2)_"  "_$P(LINE,U,3)_"  "_$P(LINE,U,4),ORK=ORK+1
 ..S ORTXT(ORK)=$P(LINE,U,5),ORK=ORK+1,ORTXT(ORK)="",ORK=ORK+1
 I $D(^TMP("ORALDAT",$J,"ERR")) D
 .S ORTXT(ORK)="The following internal entry numbers from file 100 are missing",ORK=ORK+1,ORTXT(ORK)="zero nodes.  You need to review each entry and take corrective action.",ORK=ORK+1,ORTXT(ORK)="Log a NOIS if you need assistance."
 .S ORK=ORK+1,ORTXT(ORK)=""
 .S ORK=ORK+1,ORJ=0 F  S ORJ=$O(^TMP("ORALDAT",$J,"ERR",ORJ)) Q:'+ORJ  S ORTXT(ORK)=ORJ,ORK=ORK+1
 S XMTEXT="ORTXT(",XMSUB="Patch OR*3*182 allergy order report"
 D ^XMD
 Q
 ;
PRE ;Obtain names to send mail message to
 N XMDUZ,XMDUN,XMY,ORTXT,DIFROM
 Q:$D(ZTQUEUED)  ;Quit if being queued, can't ask for recipients
 I +$G(DUZ)=0 D MES^XPDUTL("You must set your DUZ before installing this patch.  Installation aborted!") S XPDABORT=1 Q
 S ORTXT(1)="This patch produces a report of patients with potential allergy order"
 S ORTXT(2)="problems.  Patient charts must be reviewed to be certain that allergy"
 S ORTXT(3)="information is correct.  Please identify recipients for this report."
 S ORTXT(4)=""
 D BMES^XPDUTL(.ORTXT)
 S XMDUZ=$G(DUZ)
 S XMDUN=$$GET1^DIQ(200,$G(DUZ),.01)
 D DEST^XMA21
 I $D(XMOUT) D BMES^XPDUTL("The report will still run and will be sent to you for distribution.") Q  ;quit if user doesn't identify any recipients
 S ^XTMP("ORY182",0)=$$FMADD^XLFDT($$DT^XLFDT,30) ;auto-deletion in 30 days
 M ^XTMP("ORY182","XMY")=XMY ;Move recipient list into XTMP for later use
 Q
 ;
GETIEN(STDT) ;Find first IEN associated with given start date
 N DONE,IEN
 S (DONE,IEN)=0
 F  S STDT=$O(^OR(100,"AF",STDT)) Q:'+STDT!(DONE)  D
 .S IEN=0 F  S IEN=$O(^OR(100,"AF",STDT,IEN)) Q:'+IEN  I $O(^(IEN,0))=1 S DONE=1 Q  ;Find first ORDER that is a new order
 Q IEN
 ;
ERR ;Record missing 0 node errors
 S ^TMP("ORALDAT",$J,"ERR",ORI)=""
 Q
