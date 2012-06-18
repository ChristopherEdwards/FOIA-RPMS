DG53358N ;ALB/AEG - DG*5.3*358 MAIL MSG ;3-5-2001
 ;;5.3;Registration;**358**;3-5-2001
DOAR ; Process those records that are in a 'REQUIRED' status and the patient
 ; has a date of death on file.  Implemented in 2 distinct portions
 ;
 ; (1) If date of test is after the date of death these tests will be 
 ;     considered invalide and purged.
 ;
 ; (2) If date of test is on or before the date of death, these tests 
 ;     will be identified and reported to the user in a mailman message
 ;     as needing completion.
 ;
 ; Part I of Phase V Message generation
 I '$D(^TMP($J,"REQ")) D
 .S ^UTILITY($J,1)="No means test records found in a status of 'REQUIRED' where"
 .S ^UTILITY($J,2)="the date of the test is AFTER the date of death."
 I $D(^TMP($J,"REQ")) D
 .S ^UTILITY($J,1)="The following means tests were in a status of 'REQUIRED' and"
 .S ^UTILITY($J,2)="the test was entered AFTER the date of death.  These tests"
 .S ^UTILITY($J,3)="are considered to be invalid and have been purged."
 .S ^UTILITY($J,4)=" "
 .S ^UTILITY($J,5)=$$BLDSTR^DG53358M("PATIENT NAME","SSN","DATE OF DEATH","DATE OF TEST")
 .S ^UTILITY($J,6)=$$BLDSTR^DG53358M("------------","---","-------------","------------")
 .N DGDFN,DGMTI,P2,P3,P4,TDATE,TDATE1
 .N DGDOD,DOD,DOT,DOT1,I,LAST4,LST4,NM,NM1,P1,DGDFN1
 .S (DGDFN,DGMTI,DGDFN1)=""
 .F I=8:1 S DGDFN1=$O(^TMP($J,"REQ",DGDFN1)) Q:'+DGDFN1  D
 ..S DGDFN=$P($G(DGDFN1),"~~",1),DGMTI=$P($G(DGDFN1),"~~",2)
 ..S NM=$P($G(^DPT(DGDFN,0)),U,1),NM1=$E($G(NM),1,15)
 ..S LAST4=$E($P($G(^DPT(DGDFN,0)),U,9),6,9)
 ..S DOT=$P($G(^TMP($J,"REQ",DGDFN1)),U,1)
 ..S Y=DOT X ^DD("DD") S DOT1=Y
 ..S DOD=$P($G(^DPT(DGDFN,.35)),U),Y=$P($G(DOD),".",1)
 ..X ^DD("DD") S DGDOD=Y
 ..S P1=NM1,P2=LAST4,P3=DGDOD,P4=DOT1
 ..S ^UTILITY($J,I)=$$BLDSTR^DG53358M(P1,P2,P3,P4)
 ..Q
 .Q
 N DIFROM,%,Y
 N XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 D NOW^%DTC S Y=% D DD^%DT
 S XMSUB="DG*5.3*358 POST INSTALL - PHASE V (Part 1) "_Y
 S XMTEXT="^UTILITY($J,"
 D ^XMD
 D BMES^XPDUTL("     MAIL MESSAGE < #"_XMZ_" > sent.")
 K ^UTILITY($J),^TMP($J,"REQ")
 ; Part 2 of the email processing for this phase...
 ; once this is done....we're done !!!!
 I '$D(^TMP($J,"REQ-COMP")) D
 .S ^UTILITY($J,1)="No means test records found for expired patients that need"
 .S ^UTILITY($J,2)="to be completed."
 I $D(^TMP($J,"REQ-COMP")) D
 .S ^UTILITY($J,1)="The following means test records were found for expired"
 .S ^UTILITY($J,2)="patients and are in a status of 'REQUIRED'.  Please use the"
 .S ^UTILITY($J,3)="Complete a Required Means Test [DG MEANS TEST COMPLETE] option"
 .S ^UTILITY($J,4)="to complete these tests.  Thank you."
 .S ^UTILITY($J,5)=" "
 .S ^UTILITY($J,6)=$$BLDSTR^DG53358M("PATIENT NAME","SSN","TEST DATE","")
 .S ^UTILITY($J,7)=$$BLDSTR^DG53358M("------------","---","---------","")
 .N DGDFN,DGMTI,DGDFN1,TDATE,TDATE1,P1,P2,P3,P4
 .S (DGDFN,DGMTI,DGDFN1)=""
 .;F I=8:1 S DGDFN=$O(^TMP($J,"REQ-COMP",DGDFN)) Q:'+DGDFN  S DGMTI="" F  S DGMTI=$O(^TMP($J,"REQ-COMP",DGDFN,DGMTI)) Q:DGMTI=""  D
 .F I=8:1 S DGDFN1=$O(^TMP($J,"REQ-COMP",DGDFN1)) Q:'+DGDFN1  D
 ..S DGDFN=$P($G(DGDFN1),"~~",1),DGMTI=$P($G(DGDFN1),"~~",2)
 ..S NM=$P($G(^DPT(DGDFN,0)),U,1),NM1=$E($G(NM),1,15)
 ..S LST4=$E($P($G(^DPT(DGDFN,0)),U,9),6,9)
 ..S TDATE=$P($G(^TMP($J,"REQ-COMP",DGDFN1)),U,1),Y=TDATE
 ..X ^DD("DD") S TDATE1=Y
 ..S P1=NM1,P2=LST4,P3=TDATE1,P4=""
 ..S ^UTILITY($J,I)=$$BLDSTR^DG53358M(P1,P2,P3,P4)
 ..Q
 .Q
 N DIFROM,%,Y
 N XMDUZ,XMSUB,XMTEXT,XMY,XMZ
 S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^UTILITY($J,"
 D NOW^%DTC S Y=% D DD^%DT
 S XMSUB="DG*5.3*358 POST INSTALL - Phase V (part 2) "_Y
 D ^XMD
 D BMES^XPDUTL("     MAIL MESSAGE < #"_XMZ_"> sent.")
 K ^UTILITY($J),^TMP($J,"REQ-COMP")
 Q
