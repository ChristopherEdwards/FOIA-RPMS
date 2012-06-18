DG53461U ;ALB/AEG - DG*5.3*461 POST INSTALL UTILS ;7-3-02
 ;;5.3;Registration;**461**;Aug 13, 1993
 ;
MESS ; Setup initial message array for users
 S MESS(1)="This post-installation will search the CD STATUS PROCECURES subfile (#.397)"
 S MESS(2)="of the PATIENT file (#2) to find those patients who have duplicate procedure"
 S MESS(3)="codes associated with the same extremity. The duplicate entries will be purged"
 S MESS(4)="from the CD STATUS PROCEDURES subfile (#.397).  A report will be generated"
 S MESS(5)="via mailman to identify the patient and the data values of the duplicate"
 S MESS(6)="procedures and associated extremities purged from the database."
 S MESS(7)=" "
 Q
M1 ; Send mail message if no duplicate data to be cleaned up by the patch.
 ;
 S ^TMP($J,1)="No duplicate CD procedure codes found in your database."
 N DIFROM,%,XMDUZ,XMSUB,XMTEXT,XMY,Y
 S XMSUB="DG*5.3*461 POST INSTALL REPORT"
 S XMY(DUZ)="",XMY(.5)="",XMDUZ="REGISTRATION PACKAGE"
 S XMTEXT="^TMP($J,"
 D ^XMD
 D BMES^XPDUTL("Post-Install Message <"_XMZ_"> sent.")
 K ^TMP($J)
 Q
 ;
M2 ; Setup mail message to report patient data/procedure data of purged 
 ; data to users.
 I '$D(^UTILITY($J,"DUP")) Q
 S ^TMP($J,1)="The following patients had duplicate CD procedures in the CD STATUS PROCEDURES"
 S ^TMP($J,2)="subfile (#.397) of the PATIENT file (#2).  The duplicate procedures have been"
 S ^TMP($J,3)="purged from your database."
 S ^TMP($J,4)=" "
 S ^TMP($J,5)=$$BLDSTR("PATIENT NAME","LAST 4","CD PROCEDURE","EXTREMITY")
 S ^TMP($J,6)=$$BLDSTR("------------","------","------------","---------")
 N NAME,SSN,PROC,EXT,AJ,DFN,PCODE,COUNTER,N1
 S NAME="",COUNTER=6,N1=""
 F AJ=7:1 S NAME=$O(^UTILITY($J,"DUP",NAME)) Q:NAME=""  S DFN=0 F  S DFN=$O(^UTILITY($J,"DUP",NAME,DFN)) Q:'+DFN  D
 .S SSN=$E($P($G(^DPT(DFN,0)),U,9),6,9)
 .S N1=NAME
 .S PCODE="" F  S PCODE=$O(^UTILITY($J,"DUP",NAME,DFN,PCODE)) Q:PCODE=""  S COUNTER=COUNTER+1  D
 ..S PROC=$P($G(PCODE),"^",1)
 ..S PROC=$G(^DGEN(27.17,PROC,0)),PROC=$P($P($G(PROC),U,3),";",1)
 ..S EXT=$P($G(PCODE),U,2)
 ..I $G(^TMP($J,COUNTER-1))[NAME S (N1,SSN)=""
 ..S ^TMP($J,COUNTER)=$$BLDSTR(N1,SSN,PROC,EXT)
 ..Q
 .Q
 N DIFROM,%,XMDUZ,XMSUB,XMTEXT,XMY,Y
 S XMSUB="DG*5.3*461 POST INSTALL REPORT"
 S XMY(DUZ)="",XMY(.5)="",XMDUZ="REGISTRATION PACKAGE"
 S XMTEXT="^TMP($J,"
 D ^XMD
 D BMES^XPDUTL("Post-Install Message <"_XMZ_"> sent.")
 K ^TMP($J),^UTILITY($J)
 Q
M3 ; Report any errors to user if duplicate CD STATUS PROCEDURE could not
 ; be purged from the system.
 N DFN,ERR,NAME,SSN,AK
 S ^TMP($J,1)="The following patients have duplicate CD Procedure codes which could not"
 S ^TMP($J,2)="be purged from the database due to errors.  Please review this list"
 S ^TMP($J,3)="and make corrections to the patient's Catastrophic disability as"
 S ^TMP($J,4)="necessary."
 S ^TMP($J,5)=""
 S ^TMP($J,6)=$$BLDSTR("PATIENT NAME","LAST 4","ERROR","")
 S ^TMP($J,7)=$$BLDSTR("------------","------","-----","")
 N ERR,DFN,SSN
 S DFN=""
 F AK=8:1 S DFN=$O(^TMP("ERROR",$J,DFN)) Q:'+DFN  D
 .S NAME=$E($P($G(^DPT(DFN,0)),U,1),1,20)
 .S SSN=$E($P($G(^DPT(DFN,0)),U,9),6,9)
 .S ERR="" F  S ERR=$O(^TMP("ERROR",$J,DFN,ERR)) Q:ERR=""  D
 ..S ^TMP($J,AK)=$$BLDSTR(NAME,SSN,ERR,"")
 ..Q
 .Q
 N DIFROM,%,XMDUZ,XMTEXT,XMY,Y
 S XMSUB="DG*5.3*461 POST INSTALL ERROR REPORT"
 S XMY(DUZ)="",XMY(.5)="",XMDUZ="REGISTRATION PACKAGE"
 S XMTEXT="^TMP($J,"
 D ^XMD
 D BMES^XPDUTL("Post-Install Message <"_XMZ_"> sent.")
 K ^TMP($J),^UTILITY($J),^TMP("ERROR",$J)
 Q
BLDSTR(P1,P2,P3,P4) ; Build a string from input
 N S1,S2,S3,S4
 S S1=$E(P1,1,20) I $L(S1)'>19 D
 .S S1=S1_$J("",(20-$L(S1)))
 S S2=P2 I $L(S2)'>6 D
 .S S2=S2_$J("",(7-$L(S2)))
 S S3=P3 I $L(S3)'>11 D
 .S S3=S3_$J("",(12-$L(S3)))
 S S4=P4
 Q S1_$J("",3)_S2_$J("",5)_S3_$J("",5)_S4
