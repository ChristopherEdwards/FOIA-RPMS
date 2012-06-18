DG53426M ;ALB/AEG - DG*5.3*426 POST INSTALLATION ; 2-21-02
 ;;5.3;Registration;**426**;2-21-02
 ;
CAT1A ; Generate mail message if no records exist to be cleaned up.
 I '$D(^TMP($J,"CAT 1a")) D
 .S ^UTILITY($J,1)="No patients on file with a Means Test status of 'REQUIRED' who have"
 .S ^UTILITY($J,2)="a previous test in either a Cat C or PENDING ADJUDICATION status,"
 .S ^UTILITY($J,3)="Agreed to pay deductible field is 'YES', and the date of test"
 .S ^UTILITY($J,4)="is after 10/5/1999.  No action required or taken."
 .N DIFROM,%,XMDUZ,XMSUB,XMTEXT,XMY,Y
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMTEXT="^UTILITY($J,",XMSUB="DG*5.3*426 POST INSTALL REPORT #1"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 .K ^UTILITY($J)
 Q
CAT1AP ; Purged Record Report.
 N DFN,IEN,NODE0,I
 S (DFN,IEN,NODE0)=""
 I $D(^TMP("P-REQ",$J)) D
 .S ^UTILITY($J,1)="The following 'REQUIRED' status Means Test records have"
 .S ^UTILITY($J,2)="been purged from your database.  These records were purged"
 .S ^UTILITY($J,3)="due to the patient having a Means Test meeting the criteria"
 .S ^UTILITY($J,4)="introduced in patch DG*5.3*326.  The criteria are as follows:"
 .S ^UTILITY($J,5)=" "
 .S ^UTILITY($J,6)="  1 - Means Test status is Category C or Pending Adjudication."
 .S ^UTILITY($J,7)="  2 - The date of the test is on or after 10/6/1999."
 .S ^UTILITY($J,8)="  3 - Agreed to Pay deductible field value is 'YES'."
 .S ^UTILITY($J,9)=" "
 .S ^UTILITY($J,10)=$$BLDSTR("PATIENT NAME","SSN","         ","PURGED TEST DATE")
 .S ^UTILITY($J,11)=$$BLDSTR("------------","---","         ","-------------")
 .F I=12:1 S DFN=$O(^TMP("P-REQ",$J,DFN)) Q:'DFN  D
 ..N DFN1,MTIEN1,TDATE,PID,PNAME,TDATE1
 ..S DFN1=$P($G(DFN),"~~",1),MTIEN1=$P($G(DFN),"~~",2)
 ..S NODE0=$G(^TMP("P-REQ",$J,DFN)),TDATE=$P(NODE0,U,1)
 ..S Y=TDATE X ^DD("DD") S TDATE1=Y
 ..S PNAME=$P($G(^DPT(DFN1,0)),U,1)
 ..S PID=$E($P($G(^DPT(DFN1,0)),U,9),1,3)_"-"_$E($P($G(^DPT(DFN1,0)),U,9),4,5)_"-"_$E($P($G(^DPT(DFN1,0)),U,9),6,9)
 ..S ^UTILITY($J,I)=$$BLDSTR(PNAME,PID,"   ",TDATE1)
 .Q
 I $D(^UTILITY($J)) D
 .N DIFROM,%,Y,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMTEXT="^UTILITY($J,",XMSUB="DG*5.3*426 POST INSTALL REPORT #1"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 K ^UTILITY($J),^TMP("P-REQ"),^TMP($J,"CAT 1a")
 Q
 ;
CAT1B ; Report to site that no required status tests on file requiring action.
 I '$D(^TMP($J,"CAT 1b")) D
 .S ^UTILITY($J,1)="No patients on file with a Means Test status of 'REQUIRED' who do not"
 .S ^UTILITY($J,2)="meet the search criteria of patch DG*5.3*426."
 .N DIFROM,%,XMDUZ,XMSUB,XMTEXT,XMY,Y
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMTEXT="^UTILITY($J,",XMSUB="DG*5.3*426 POST INSTALL REPORT #2"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 .K ^UTILITY($J)
 Q
CAT1BR ; Report to the site any record in a 'REQUIRED' status needing
 ; action.
 I $D(^TMP($J,"CAT 1b")) D
 .N DFN,IEN,NODE0
 .S (DFN,IEN,NODE0)=""
 .S ^UTILITY($J,1)="The following Means Tests in your database are in a 'REQUIRED'"
 .S ^UTILITY($J,2)="status.  The historical records do not meet the criteria for"
 .S ^UTILITY($J,3)="cleanup by patch DG*5.3*426.  Please update these records."
 .S ^UTILITY($J,4)=" "
 .S ^UTILITY($J,5)=$$BLDSTR("PATIENT NAME","SSN","         ","**TEST DATE**")
 .S ^UTILITY($J,6)=$$BLDSTR("------------","---","         ","-------------")
 .N PID,PNAME,LST,DGMTDT,DGMTDT1
 .F I=7:1 S DFN=$O(^TMP($J,"CAT 1b",DFN)) Q:'DFN  D
 ..S PNAME=$P($G(^DPT(DFN,0)),U,1)
 ..S PID=$E($P($G(^DPT(DFN,0)),U,9),1,3)_"-"_$E($P($G(^DPT(DFN,0)),U,9),4,5)_"-"_$E($P($G(^DPT(DFN,0)),U,9),6,9)
 ..S LST=$$LST^DGMTU(DFN),DGMTDT=$P(LST,U,2)
 ..S Y=DGMTDT X ^DD("DD") S DGMTDT1=Y
 ..S ^UTILITY($J,I)=$$BLDSTR(PNAME,PID,"   ",DGMTDT1)
 ..Q
 .Q
 I $D(^UTILITY($J)) D
 .N DIFROM,%,Y,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMTEXT="^UTILITY($J,",XMSUB="DG*5.3*426 POST INSTALL REPORT #2"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 K ^UTILITY($J),^TMP($J,"CAT 1b")
 Q
NOCAT2 ; report no cat Cs who declined to give income info but agree to pay
 I '$D(^TMP($J,"CAT 2")) D
 .S ^UTILITY($J,1)="No patients on file with a Means Test status of 'REQUIRED' who have"
 .S ^UTILITY($J,2)="a Category C status test in which the patient declined to give"
 .S ^UTILITY($J,3)="income information but agreed to pay the deductible."
 .N DIFROM,%,XMDUZ,XMSUB,XMTEXT,XMY,Y
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMSUB="DG*5.3*426 POST INSTALL REPORT #3",XMTEXT="^UTILITY($J,"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 .K ^UTILITY($J)
 Q
 ;
BLDSTR(P1,P2,P3,P4) ; Build a string from input
 N S1,S2,S3,S4
 S S1=$E(P1,1,15) I $L(S1)'>14 D
 .S S1=S1_$J("",(15-$L(S1)))
 S S2=P2
 S S3=P3
 S S4=P4
 Q S1_$J("",5)_S2_$J("",5)_S3_$J("",5)_S4_$J("",5)
