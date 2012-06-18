XPDCUST ;SLC/STAFF-SITE TRACKING UPDATE ALL VERSIONS ;7/20/94  15:34 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003
 ;;7.1;Kernel;**22,35**;Oct 25, 1993
 ;
ALL ;
 W !,"This routine is used to check the package file (9.4) for the current"
 W !,"versions of software installed at your site.  This information will"
 W !,"be used to update the site tracking file on FORUM.  Package names will also"
 W !,"be checked to make sure they conform to the official package name assigned"
 W !,"to the software.  If needed, the name in the package file will be changed."
 W !,"This routine should only be used in your production account."
 W !!,"The data collected will be sent to FORUM automatically via MailMan."
 W !,"A message with the changes made to site tracking will be sent back via MailMan."
 ;
 N DIC,DIR,PERSON,SERVER,SITE,X,Y K DIC,DIR
 I $G(^XMB("NETNAME"))'[".VA.GOV" W !,"This routine should only be used by a VA site." Q
 X ^%ZOSF("UCI") I Y'=^%ZOSF("PROD") W !,"This routine must be run in a production account." Q
 S SERVER="S.A5CSTS@FORUM.VA.GOV",SITE=^XMB("NETNAME")
 W !!,"Enter the person who will receive this message at ",SITE,"."
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Select Person: ",DIC("B")=$S('$D(DUZ):"",1:$P($G(^VA(200,DUZ,0)),U)) D ^DIC K DIC Q:Y<0  S PERSON=$P(Y,U,2)
 S DIR(0)="YAM",DIR("A")="Proceed to collect data for site tracking? ",DIR("B")="YES" D ^DIR K DIR Q:Y'=1
 D ^XPDCUSTP
 Q
TASK ; this entry point is no longer used
 Q
