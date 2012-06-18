DG53426N ;ALB/AEG - DG*5.3*426 POST INSTALL CONT. ;2-21-02
 ;;5.3;Registration;**426**;2-21-02
 ;
CAT2P ; Process those tests where the patient was in a 'REQUIRED' status but
 ; had a test on file previously that was Category C, patient declined
 ; to provide income information but did agree to pay the deductible.
 I $D(^TMP("P-REQ",$J)) D
 .N DFN,IEN,NODE0,I
 .S (DFN,IEN,I,NODE0)=""
 .S ^UTILITY($J,1)="The following 'REQUIRED' status Means Test records have"
 .S ^UTILITY($J,2)="been purged from your database.  These records were purged"
 .S ^UTILITY($J,3)="due to the patient having a Means Test previously on file"
 .S ^UTILITY($J,4)="with a status of Category C.  The Category C test on these"
 .S ^UTILITY($J,5)="persons is a result of the patient declining to provide"
 .S ^UTILITY($J,6)="income information but agreeing to pay the deductible charges."
 .S ^UTILITY($J,7)=" "
 .S ^UTILITY($J,8)=$$BLDSTR^DG53426M("PATIENT NAME","SSN","         ","PURGED TEST DATE")
 .S ^UTILITY($J,9)=$$BLDSTR^DG53426M("------------","---","         ","-------------")
 .F I=10:1 S DFN=$O(^TMP("P-REQ",$J,DFN)) Q:'DFN  D
 ..N DFN1,MTIEN1,TDATE,PID,PNAME,TDATE1
 ..S DFN1=$P($G(DFN),"~~",1),MTIEN1=$P($G(DFN),"~~",2)
 ..S NODE0=$G(^TMP("P-REQ",$J,DFN)),TDATE=$P(NODE0,U,1)
 ..S Y=TDATE X ^DD("DD") S TDATE1=Y
 ..S PNAME=$P($G(^DPT(DFN1,0)),U,1)
 ..S PID=$E($P($G(^DPT(DFN1,0)),U,9),1,3)_"-"_$E($P($G(^DPT(DFN1,0)),U,9),4,5)_"-"_$E($P($G(^DPT(DFN1,0)),U,9),6,9)
 ..S ^UTILITY($J,I)=$$BLDSTR^DG53426M(PNAME,PID,"   ",TDATE1)
 ..Q
 .Q
 I $D(^UTILITY($J)) D
 .N DIFROM,%,Y,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMTEXT="^UTILITY($J,",XMSUB="DG*5.3*426 POST INSTALL REPORT #3"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 K ^UTILITY($J),^TMP("P-REQ"),^TMP($J,"CAT 2")
 Q
NOCAT3 ; report no Cat Cs who declined to provide income info and who also
 ; refused AGREE TO PAY.
 I '$D(^TMP($J,"CAT 3")) D
 .S ^UTILITY($J,1)="No patients on file with a Means Test status of 'REQUIRED' who have"
 .S ^UTILITY($J,2)="a Category C test in which the patient declined to give income"
 .S ^UTILITY($J,3)="information and did NOT agree to pay deductible."
 .S ^UTILITY($J,4)=" "
 .N DIFROM,%,XMDUZ,XMTEXT,XMY,Y
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMSUB="DG*5.3*426 POST INSTALL REPORT #4",XMTEXT="^UTILITY($J,"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 .K ^UTILITY($J)
 Q
CAT3 ; report on those patients who are currently in a REQUIRED status but
 ; have a CAT C test on file in which they declined to give income info
 ; & did NOT agree to pay deductible.
 I $D(^TMP($J,"CAT 3")) D
 .N DFN,IEN,NODE0
 .S (DFN,IEN,NODE0)=""
 .S ^UTILITY($J,1)="The following patients have a current Means Test status of 'REQUIRED'."
 .S ^UTILITY($J,2)="The veteran declined to provide income information AND did"
 .S ^UTILITY($J,3)="NOT agree to pay the deductible on a previous test.  Please update"
 .S ^UTILITY($J,4)="the 'REQUIRED' status test(s)."
 .S ^UTILITY($J,5)=" "
 .S ^UTILITY($J,6)=$$BLDSTR^DG53426M("PATIENT NAME","SSN","         ","**TEST DATE**")
 .S ^UTILITY($J,7)=$$BLDSTR^DG53426M("------------","---","         ","-------------")
 .N PID,PNAME,LST,DGMTDT,DGMTDT1
 .F I=8:1 S DFN=$O(^TMP($J,"CAT 3",DFN)) Q:'DFN  D
 ..S PNAME=$P($G(^DPT(DFN,0)),U,1)
 ..S PID=$E($P($G(^DPT(DFN,0)),U,9),1,3)_"-"_$E($P($G(^DPT(DFN,0)),U,9),4,5)_"-"_$E($P($G(^DPT(DFN,0)),U,9),6,9)
 ..S LST=$$LST^DGMTU(DFN),DGMTDT=$P(LST,U,2)
 ..S Y=DGMTDT X ^DD("DD") S DGMTDT1=Y
 ..S ^UTILITY($J,I)=$$BLDSTR^DG53426M(PNAME,PID,"   ",DGMTDT1)
 ..Q
 .Q
 I $D(^UTILITY($J)) D
 .N DIFROM,%,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMTEXT="^UTILITY($J,",XMSUB="DG*5.3*426 POST INSTALL REPORT #4"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 .K ^UTILITY($J),^TMP($J,"CAT 3")
 Q
CAT4 ;
 I $D(^TMP($J,"CAT 4")) D
 .N DFN,IEN,NODE0
 .S (DFN,IEN,NODE0)=""
 .S ^UTILITY($J,1)="The following patients have a current Means Test status of 'REQUIRED'."
 .S ^UTILITY($J,2)="The below patient(s) previously had a Means Test in which they did"
 .S ^UTILITY($J,3)="provide income information but did NOT agree to pay the deductible."
 .S ^UTILITY($J,4)="Please update these records."
 .S ^UTILITY($J,5)=" "
 .S ^UTILITY($J,6)=$$BLDSTR^DG53426M("PATIENT NAME","SSN","         ","**TEST DATE**")
 .S ^UTILITY($J,7)=$$BLDSTR^DG53426M("------------","---","         ","-------------")
 .N PID,PNAME,LST,DGMTDT,DGMTDT1
 .F I=8:1 S DFN=$O(^TMP($J,"CAT 4",DFN)) Q:'DFN  D
 ..S PNAME=$P($G(^DPT(DFN,0)),U,1)
 ..S PID=$E($P($G(^DPT(DFN,0)),U,9),1,3)_"-"_$E($P($G(^DPT(DFN,0)),U,9),4,5)_"-"_$E($P($G(^DPT(DFN,0)),U,9),6,9)
 ..S LST=$$LST^DGMTU(DFN),DGMTDT=$P(LST,U,2)
 ..S Y=DGMTDT X ^DD("DD") S DGMTDT1=Y
 ..S ^UTILITY($J,I)=$$BLDSTR^DG53426M(PNAME,PID,"     ",DGMTDT1)
 ..Q
 .Q
 I $D(^UTILITY($J)) D
 .N DIFROM,%,XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMTEXT="^UTILITY($J,",XMSUB="DG*5.3*426 POST INSTALL REPORT #5"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 .K ^UTILITY($J),^TMP($J,"CAT 4")
 Q
NOCAT4 ;
 I '$D(^TMP($J,"CAT 4")) D
 .S ^UTILITY($J,1)="No patients currently in a Means Test 'REQUIRED' status who"
 .S ^UTILITY($J,2)="previously had a Category C test in which income information"
 .S ^UTILITY($J,3)="was provided but patient did NOT agree to pay deductible."
 .N DIFROM,%,XMDUZ,XMTEXT,XMY,Y
 .S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 .S XMSUB="DG*5.3*426 POST INSTALL REPORT #5",XMTEXT="^UTILITY($J,"
 .D ^XMD
 .D MM^DG53426U(XMZ)
 .K ^UTILITY($J)
 Q
