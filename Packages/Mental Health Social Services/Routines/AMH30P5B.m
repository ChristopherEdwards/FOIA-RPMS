AMH30P5B ; IHS/BJI/GRL - Routine to create bulletin [ 10/05/04  1:09 PM ]
 ;;3.0;IHS BEHAVIORAL HEALTH;**5**;JAN 27, 2003
 ;;Borrowed from ACHSP1, ACHSP1A
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting AMHKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"AMHBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""AMHBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_AMHKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"AMHBUL"),AMHKEY
 Q
 ;
WRITEMSG ;
 S AMHIEN=$O(^AMHPATCH("AA",3,5,0))
 I AMHIEN="" Q
 S AMHX=0,AMHC=0 F  S AMHX=$O(^AMHPATCH(AMHIEN,11,AMHX)) Q:AMHX'=+AMHX  S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)=^AMHPATCH(AMHIEN,11,AMHX,0)
 Q
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,AMHKEY="AMHZMENU"
 F  S CTR=$O(^XUSEC(AMHKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
