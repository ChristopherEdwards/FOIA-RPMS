DG272PT2 ;ALB/SEK DG*5.3*272 POST-INSTALL TO CLOSE IVM CASES ; 02/03/00
 ;;5.3;Registration;**272**;Aug 13, 1993
 ;
 ;This routine will be run as part of the post-install for patch
 ;DG*5.3*272
 ;
 ;This routine will use the "AYR" cross-reference to loop through the
 ;IVM PATIENT file (#301.5) for income years 1992-1996 to find and
 ;close all open cases.
 ;
 ;The following fields in the IVM PATIENT file will be updated:
 ;.03  - TRANSMISSION STATUS  - 1 for transmitted
 ;.04  - STOP FLAG            - 1 for stop
 ;1.01 - CLOSURE REASON       - 5 for "OLD CASE NO ACTION"
 ;1.02 - CLOSURE SOURCE       - 2 for DHCP
 ;1.03 - CLOSURE DATE/TIME    - current date/time
 ;
 ;A mail message will be sent to the HEC and the user
 ;when the post-install is complete.
 ;
POST ;entry point for post-install, setting up checkpoints
 N %
 S %=$$NEWCP^XPDUTL("DGDATE","",2910000)
 S %=$$NEWCP^XPDUTL("DGDFN","",0)
 Q
 ;
EN ; begin processing
 ;
 ;go through IVM PATIENT file (#301.5) finding patients
 ;with open cases for income years 1992-1996. 
 ;
 N DATA,DGDATE,DGDFN
 ;
 ;get value from checkpoints, previous run
 I $D(XPDNM) S DGDATE=+$$PARCP^XPDUTL("DGDATE")
 I $G(DGDATE)="" S DGDATE=2910000
 I $D(XPDNM) S DGDFN=+$$PARCP^XPDUTL("DGDFN")
 I $G(DGDFN)="" S DGDFN=0
 ;
 D BMES^XPDUTL("Beginning case closing process "_$$FMTE^XLFDT($$NOW^XLFDT))
 D SETUP
 D SEARCH
 D MAIL
 I $D(XPDNM) S %=$$COMCP^XPDUTL("DGDATE")
 D MES^XPDUTL(" >>closing process completed "_$$FMTE^XLFDT($$NOW^XLFDT))
 Q
 ;
 ;
SETUP ;setup data array for closing cases
 N %
 S DATA(.03)=1
 S DATA(.04)=1
 S DATA(1.01)=5
 S DATA(1.02)=2
 D NOW^%DTC S DATA(1.03)=%
 Q
 ;
SEARCH ; Search for open cases
 N %,DGIEN,ERROR
 F  S DGDATE=$O(^IVM(301.5,"AYR",DGDATE)) Q:('DGDATE!(DGDATE>2960000))  D
 .S:'$D(DGDFN) DGDFN=0
 .F  S DGDFN=$O(^IVM(301.5,"AYR",DGDATE,DGDFN)) D  Q:'DGDFN
 ..I 'DGDFN D  Q
 ...I $D(XPDNM) S %=$$UPCP^XPDUTL("DGDATE",DGDATE)
 ..;
 ..S DGIEN=$O(^IVM(301.5,"AYR",DGDATE,DGDFN,0)) Q:'DGIEN
 ..;
 ..; - quit if case closed
 ..Q:+$G(^IVM(301.5,DGIEN,1))
 ..;
 ..;close case
 ..I '$$UPD^DGENDBS(301.5,DGIEN,.DATA,.ERROR) D  G UPCP
 ...D ERRS^DG272PT1(301.5,DGIEN,.ERROR)
 ...Q
 ..;add to counter - number of cases closed by income year
 ..S $P(^XTMP("DGMTPCT",$E(DGDATE,1,3)),"^",2)=$P($G(^XTMP("DGMTPCT",$E(DGDATE,1,3))),"^",2)+1
 ..;
UPCP ..I $D(XPDNM) S %=$$UPCP^XPDUTL("DGDFN",DGDFN)
 ..Q
 .Q
SEARCHQ Q
 ;
 ;
MAIL ; Send a mailman msg to user/HEC with results
 N DIFROM,%
 N IVMCX,IVMDATA,IVMDATA1,IVMDATA2,IVMFILE,IVMFLD,IVMIENX,IVMIY,IVMNODE,IVMTEXT,IVMX
 N X,XMDUZ,XMSUB,XMTEXT,XMY,Y
 K ^TMP("DG272PT",$J)
 S XMSUB="Purge of IVM verified Means Tests and closing of IVM CASES"
 S XMDUZ="IVM/HEC PACKAGE",XMY("HARBIN,LYNNE@IVM.VA.GOV")="",XMY(DUZ)="",XMY(.5)="",XMY("PERREAULT,JEAN@IVM.VA.GOV")=""
 S XMY("PICKELSIMER,HENRY@IVM.VA.GOV")="",XMY("STEFFEY,KIM@IVM.VA.GOV")=""
 S XMY("ARMOUR,EDDIE@IVM.VA.GOV")="",XMY("WHITFIELD,VENIS@IVM.VA.GOV")=""
 S XMTEXT="^TMP(""DG272PT"",$J,"
 S IVMCX=$$SITE^VASITE
 D NOW^%DTC S Y=% D DD^%DT
 S ^TMP("DG272PT",$J,1)="Purge of IVM verified Means Tests and closing of IVM CASES"
 S ^TMP("DG272PT",$J,2)="  "
 S ^TMP("DG272PT",$J,3)="Facility Name:         "_$P(IVMCX,"^",2)_"         "_Y
 S ^TMP("DG272PT",$J,4)="Station Number:        "_$P(IVMCX,"^",3)
 S ^TMP("DG272PT",$J,5)="  "
 S IVMTEXT="Income year"
 S IVMTEXT=$$BLDSTR^DG272PT1("# of IVM MT purged",IVMTEXT,20,18)
 S IVMTEXT=$$BLDSTR^DG272PT1("# of cases closed",IVMTEXT,40,17)
 S ^TMP("DG272PT",$J,6)=IVMTEXT
 S IVMTEXT=$$REPEAT^XLFSTR("=",$L(IVMTEXT))
 S ^TMP("DG272PT",$J,7)=IVMTEXT
 S IVMIY=0,IVMNODE=7
 F  S IVMIY=$O(^XTMP("DGMTPCT",IVMIY)) Q:'IVMIY  D
 .S IVMDATA=^XTMP("DGMTPCT",IVMIY)
 .S IVMTEXT=IVMIY+1700
 .S IVMDATA1=$J(+$P(IVMDATA,U),6)
 .S IVMDATA2=$J(+$P(IVMDATA,U,2),6)
 .S IVMTEXT=$$BLDSTR^DG272PT1(IVMDATA1,IVMTEXT,20,$L(IVMDATA1))
 .S IVMTEXT=$$BLDSTR^DG272PT1(IVMDATA2,IVMTEXT,40,$L(IVMDATA2))
 .S IVMNODE=IVMNODE+1
 .S ^TMP("DG272PT",$J,IVMNODE)=IVMTEXT
 F I=1:1:2 S IVMNODE=IVMNODE+1,^TMP("DG272PT",$J,IVMNODE)=" "
 ;
 ; add error reports to the mail message...
 I $O(^XTMP("DGMTPERR",0))'="" D
 .S IVMNODE=IVMNODE+1
 .S ^TMP("DG272PT",$J,IVMNODE)="Some records were not edited due to filing errors:"
 .S IVMNODE=IVMNODE+1
 .S ^TMP("DG272PT",$J,IVMNODE)=" "
 .S IVMTEXT="File #"
 .S IVMTEXT=$$BLDSTR^DG272PT1("Record #",IVMTEXT,12,8)
 .S IVMTEXT=$$BLDSTR^DG272PT1("Field #",IVMTEXT,22,7)
 .S IVMTEXT=$$BLDSTR^DG272PT1("Error Message",IVMTEXT,30,13)
 .S IVMNODE=IVMNODE+1
 .S ^TMP("DG272PT",$J,IVMNODE)=IVMTEXT
 .K IVMTEXT
 .S IVMFILE=0
 .F  S IVMFILE=$O(^XTMP("DGMTPERR",IVMFILE)) Q:'IVMFILE  D
 ..S IVMTEXT=IVMFILE
 ..S IVMIENX=0
 ..F  S IVMIENX=$O(^XTMP("DGMTPERR",IVMFILE,IVMIENX)) Q:'IVMIENX  D
 ...S IVMFLD=0
 ...F  S IVMFLD=$O(^XTMP("DGMTPERR",IVMFILE,IVMIENX,IVMFLD)) Q:'IVMFLD  D
 ....S IVMX=0
 ....F  S IVMX=$O(^XTMP("DGMTPERR",IVMFILE,IVMIENX,IVMFLD,IVMX)) Q:'IVMX  D
 .....S IVMDATA=^XTMP("DGMTPERR",IVMFILE,IVMIENX,IVMFLD,IVMX)
 .....S IVMTEXT=$$BLDSTR^DG272PT1(IVMIENX,IVMTEXT,12,$L(IVMIENX))
 .....S IVMTEXT=$$BLDSTR^DG272PT1(IVMFLD,IVMTEXT,22,$L(IVMFLD))
 .....S IVMTEXT=$$BLDSTR^DG272PT1(IVMDATA,IVMTEXT,30,$L(IVMDATA))
 .....S IVMNODE=IVMNODE+1
 .....S ^TMP("DG272PT",$J,IVMNODE)=IVMTEXT
 .....K IVMDATA
 ....K IVMX
 ...K IVMFLD
 ..K IVMIENX
 .K IVMFILE,IVMTEXT
 ;
MAIL1 D ^XMD
 K ^TMP("DG272PT",$J)
 Q
