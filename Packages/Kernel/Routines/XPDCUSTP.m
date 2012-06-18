XPDCUSTP ;SLC/STAFF-SITE TRACKING UPDATE ALL VERSIONS, PROCESS ;7/20/94  15:37 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;7.1;Kernel;**22,35**;Oct 25, 1993
 ;
 ; from XPDCUST
PAC N ANUM,DA,DATE,DIC,DIE,DR,NEWNM,NUM,PACKAGE,VERSION,XMDUZ,XMSUB,XMTEXT,XMY K ^TMP("XPDCUP",$J),^TMP("XPDCUS",$J)
 ;
 ; LOAD^XPDCUSTL returns ^TMP("XPDCUP",$J, which is used to find the
 ; version of packages.  The format for package names is:
 ; ^TMP("XPDCUP",$J,name) = version # ^ date installed ^ ^ routine names
 ; ^TMP("XPDCUP",$J,old name) =  ^ ^ ^ routine names ^ name
 D LOAD^XPDCUSTL
 ;
 ; Go thru names in the package file that are used in site tracking
 W !!,"Checking application version numbers and install dates.",!
 S PACKAGE="" F  S PACKAGE=$O(^DIC(9.4,"B",PACKAGE)) Q:PACKAGE=""  I $D(^TMP("XPDCUP",$J,PACKAGE)) D
 .;
 .; If this is an official name and no version number has been assigned,
 .; setup the version and date
 .I '$L($P(^TMP("XPDCUP",$J,PACKAGE),U,5)),'$L($P(^TMP("XPDCUP",$J,PACKAGE),U)) D  Q
 ..D VERSION^XPDCUSTU S ^TMP("XPDCUP",$J,PACKAGE)=VERSION_U_DATE
 ..W !,PACKAGE,"   ",VERSION
 ..I VERSION,DATE W "   ",$E(DATE,4,5),"/",$E(DATE,6,7),"/",$E(DATE,2,3)
 .;
 .; If this is an old name, setup the version and date for the new name
 .; and change the name of the package to the new name.
 .I $L($P(^TMP("XPDCUP",$J,PACKAGE),U,5)) D  Q
 ..S DA=+$O(^DIC(9.4,"B",PACKAGE,0)) I 'DA Q
 ..S NEWNM=$P(^TMP("XPDCUP",$J,PACKAGE),U,5)
 ..I $D(^DIC(9.4,"B",NEWNM)) Q
 ..D VERSION^XPDCUSTU S ^TMP("XPDCUP",$J,NEWNM)=VERSION_U_DATE
 ..L +^DIC(9.4,DA,0) S (DIC,DIE)=9.4,DR=".01///"_NEWNM D ^DIE L -^DIC(9.4,DA,0)
 ..W !,PACKAGE," changed to ",NEWNM,"   ",VERSION I VERSION,DATE W "   ",$E(DATE,4,5),"/",$E(DATE,6,7),"/",$E(DATE,2,3)
 ;
 ; Setup mail message for server
 S ^TMP("XPDCUS",$J,1,0)="ALL PACKAGE VERSIONS"
 S ^TMP("XPDCUS",$J,2,0)="SITE: "_SITE
 S ^TMP("XPDCUS",$J,3,0)="PERSON: "_PERSON
 S ^TMP("XPDCUS",$J,4,0)="PACKAGES:"
 S NUM=4
 S PACKAGE="" F  S PACKAGE=$O(^TMP("XPDCUP",$J,PACKAGE)) Q:PACKAGE=""  D
 .I '$L($P(^TMP("XPDCUP",$J,PACKAGE),U,5)) S NUM=NUM+1,^TMP("XPDCUS",$J,NUM,0)=PACKAGE_U_$P(^TMP("XPDCUP",$J,PACKAGE),U,1,3)
 S NUM=NUM+1
 S ^TMP("XPDCUS",$J,NUM,0)="AUTO INSTRUMENTS: "
 ;
 ; Send message to server
 S XMY(SERVER)="",XMDUZ=.5,XMTEXT="^TMP(""XPDCUS"",$J,",XMSUB="Site Tracking - "_SITE
 D ^XMD
 W !!,"A message to update site tracking is being sent to ",$P(SERVER,"@",2)
 W !,"ALL DONE",!
 Q
