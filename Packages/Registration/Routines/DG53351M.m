DG53351M ;ALB/JAN - DG*5.3*351 POST-INSTALL MAINMAN MSG; 6/26/01
 ;;5.3;Registration;**351**;JUNE 26, 2001
 ;
 ; This routine will be run as part of the post-install for patch DG*5.3*351
 ;
 ; A mail message will be sent to the user when the post-install is completed.
 ;
MAIL ;
 ; Send a mailman message to user with results
 N DIFROM,%
 N XMDUZ,XMSUB,XMTEXT,XMY,Y
 K ^TMP("DG53351")
 S XMDUZ="REGISTRATION PACKAGE",XMY(DUZ)="",XMY(.5)=""
 S XMSUB="DG*5.3*351 POST-INSTALL - Update CURRENT ENROLLMENT STATUS"
 S XMTEXT="^TMP(""DG53351"",$J,"
 D NOW^%DTC S Y=% D DD^%DT
 ;
 I $G(^XTMP("DG-DTC",1))=0 D
 .S ^TMP("DG53351",$J,1)="No records were updated between the ENROLLMENT STATUS field (#.04)"
 .S ^TMP("DG53351",$J,2)="of the PATIENT ENROLLMENT file (#27.11) and the cross reference"
 .S ^TMP("DG53351",$J,3)="""AENRC"" of the PATIENT file (#2)."
 I $G(^XTMP("DG-DTC",1))>0 D
 .S ^TMP("DG53351",$J,1)="The following patients had the cross reference ""AENRC"" of the"
 .S ^TMP("DG53351",$J,2)="PATIENT file (#2) updated."
 .S ^TMP("DG53351",$J,3)=""
 .S ^TMP("DG53351",$J,4)=$$BLDSTR("PATIENT NAME","SSN","OLD ENROLLMENT STATUS")
 .S ^TMP("DG53351",$J,5)=$$BLDSTR("------------","---","---------------------")
 .S ^TMP("DG53351",$J,6)=""
 .; add patients from temp global to the mail message
 .N ST,PAT,TMPNODE,PATNAME,PATSSN,ENRST,I,LINE,TEXT
 .S (ST,PAT)=""
 .F I=7:1 S PAT=$O(^XTMP("DG-AENRC",PAT)) Q:PAT=""  F  S ST=$O(^XTMP("DG-AENRC",PAT,ST)) Q:ST=""  D
 ..S TMPNODE=$G(^XTMP("DG-AENRC",PAT,ST)),LINE=I
 ..S PATNAME=$P(TMPNODE,U,1),PATSSN=$P(TMPNODE,U,2),ENRST=$P(TMPNODE,U,3)
 ..S ^TMP("DG53351",$J,LINE)=$$BLDSTR(PATNAME,PATSSN,ENRST)
 ..Q
 .S LINE=$G(LINE)+1,^TMP("DG53351",$J,LINE)=""
 .S TEXT="Number of records updated"
 .S LINE=$G(LINE)+1,^TMP("DG53351",$J,LINE)=TEXT
 .S LINE=$G(LINE)+1,^TMP("DG53351",$J,LINE)=$$REPEAT^XLFSTR("=",$L(TEXT))
 .S LINE=$G(LINE)+1,^TMP("DG53351",$J,LINE)=+$G(^XTMP("DG-DTC",1))
 ;
MAIL1 ; send mail message to user
 D ^XMD
 D BMES^XPDUTL("     MAIL MESSAGE < #"_XMZ_" > sent.")
 K ^TMP("DG53351",$J)
 Q
BLDSTR(P1,P2,P3) ; build a string from input
 N S1,S2,S3
 S S1=$E(P1,1,25) I $L(S1)'>24 D
 .S S1=S1_$J("",(24-$L(S1)))
 S S2=P2
 S S3=$E(P3,1,25) I $L(S3)'>24 D
 .S S3=S3_$J("",(24-$L(S3)))
 Q S1_$J("",5)_S2_$J("",5)_S3
