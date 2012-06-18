ACDENVCK ;IHS/ADC/EDE/KML - ENVIRONMENT CHECK ROUTINE FOR V4.1; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 ;   kill off gbl left by v4.0 post-init
 K ^ACDTEMP ;  kills temp global  SAC EXEMPTION (2.3.2.3 killing of unsubscripted globals is prohibited)
 D ^XBKVAR
 S ACDQ=0
 W !!,"Beginning ENVIRONMENTAL CHECK routine."
 D DUZ ;                                   check DUZ values
 I ACDQ D STOP,EOJ Q  ;                    quit if not good DUZ values
 D VIRGIN ;                                check for virgin install
 I ACDQ D EOJ Q  ;                         quit if virgin install
 D FILE200 ;                               check file 6/200
 I ACDQ D STOP,EOJ Q  ;                    quit if 6/200 cnv bad
 D VERSION ;                               check current version
 I ACDQ D STOP,EOJ Q  ;                    quit if not v4.0/v4.1
 D SERVICE ;                               check for OTH service
 I ACDQ D STOP,EOJ Q  ;                    quit if no OTH
 D LOCATION ;                              check for SCHOOL
 I ACDQ D STOP,EOJ Q  ;                    quit if no SCHOOL
 D COMPONEN ;                              check for DROP IN CENTER
 I ACDQ D STOP,EOJ Q  ;                    quit if no DROP IN CENTER
 D PCCCHK ;                                check for PCC link
 W !!,"This initialization will delete all data from your CDMIS PROGRAM"
 W !,"file except the site name.  If you have data in that file that you"
 W !,"don't want to lose do not continue with this install."
 W !
 S DIR(0)="Y",DIR("A")="Do you want to continue with this install",DIR("B")="Y" K DA D ^DIR K DIR
 I 'Y D STOP,EOJ Q
 D EOJ
 Q
 ;
DUZ ; GET CORRECT DUZ VALUES
 S ACDQ=1
 I '$G(DUZ) D
 . W !!,"DUZ is not set.  I am going to do ^XUP.  You must enter your ACCESS Code but"
 . W !,"just press RETURN to the Select OPTION NAME: prompt.",!
 . D XUP
 . Q
 I '$G(DUZ) W !,"DUZ is still not set." Q
 I $G(DUZ(0))'["@" W !!,"You must have programmer access to run this install.",! Q
 S ACDQ=0
 Q
 ;
XUP ; DO ^XUP
 NEW ACDQ,DIFQ
 D ^XUP
 Q
 ;
VIRGIN ; CHECK FOR VIRGIN INSTALL
 S ACDQ=1
 K ^TMP("ACD",$J)
 S ^TMP("ACD",$J,"VIRGIN INSTALL")=""
 S Y=$O(^DIC(9.4,"C","ACD",0))
 I 'Y W !,"VIRGIN install.  No further checking necessary." Q
 K ^TMP("ACD",$J,"VIRGIN INSTALL")
 S ACDQ=0
 Q
 ;
VERSION ; CHECK FOR VERSION 4.0
 S Y=$O(^DIC(9.4,"C","ACD",0))
 Q:'Y  ;                            no package entry to check
 S ACDQ=1
 S ACDVER=^DIC(9.4,Y,"VERSION")
 I +ACDVER=4.1 D  Q
 . W !
 . S DIR(0)="Y",DIR("A")="You already have version 4.1.  Do you want to run this install again",DIR("B")="N" K DA D ^DIR K DIR
 . I Y S ACDQ=0 Q
 . W !!,"Terminating install.",!
 . Q
 I ACDVER<4 D  Q
 . W !!,"The current version is ",ACDVER
 . W !,"You must install version 4.0 before you upgrade to version 4.1"
 . W !!,"Terminating install.",!
 . Q
 I ACDVER'="4.0" D  Q
 . W !!,"The current version is ",ACDVER
 . W !,"You must install version 4.0 before you upgrade to version 4.1"
 . S DIR(0)="Y",DIR("A")="Do you want to run this install",DIR("B")="N" K DA D ^DIR K DIR
 . I Y S ACDQ=0 Q
 . W !!,"Terminating install.",!
 . Q
 S ACDQ=0
 Q
 ;
SERVICE ; check for OTH service
 S ACDQ=1
 S Y=$O(^ACDSERV("C","OTH",0))
 I 'Y W !!,"There is no 'OTH' entry in your CDMIS SERVICE file." Q
 S ACDQ=0
 Q
 ;
LOCATION ; check for SCHOOL location
 S ACDQ=1
 S Y=$O(^ACDLOT("C",1,0))
 I 'Y W !!,"There is no 'SCHOOL' entry in your CDMIS LOCATION file." Q
 S ACDQ=0
 Q
 ;
COMPONEN ; check for DROP IN CENTER component
 S ACDQ=1
 S Y=$O(^ACDCOMP("B","DROP IN CENTER",0))
 I 'Y W !!,"There is no 'DROP IN CENTER' entry in your CDMIS COMPONENT file." Q
 S ACDQ=0
 Q
 ;
PCCCHK ; CHECK FOR PCC ENVIRONMENT
 D ^ACDPCCLC
 Q
 ;
STOP ; STOP THE INSTALL
 W !!,"Terminating this install.",!!
 K DIFQ
 Q
 ;
EOJ ;
 K ACDQ,ACDVER
 Q
 ;
 ;
FILE200 ; CHECK FOR FILES 6/200 CONVERSION
 ;
 ; This routine checks the environment for file 6 to 200
 ; conversion.
 ;
START2 ;
 D INIT2
 I ACDQ S:'ACDBAD ACDQ=0 Q
 D MAIN
 S ACDQ=$S(ACDBAD:1,1:0)
 K ACDBAD
 Q
 ;
INIT2 ; INITIALIZATION
 S (ACDBAD,ACDQ)=0
 I $D(^ACDCNV("B","1")) D  S ACDQ=1 Q  ;   quit if conversion done
 .  W !,"File 6 to file 200 conversion already done.",!
 .  Q
 S X="AVAPCHK"
 X ^%ZOSF("TEST")
 I '$T W !!,"^AVAPCHK routine missing!",! S (ACDBAD,ACDQ)=1 Q
 Q
 ;
MAIN ;
 D CHKPRV ;                     check file 3,6,16,200
 Q:ACDQ  ;                      quit if not ok
 D CHKACDF ;                    check ACD fields
 Q:ACDQ  ;                      quit if not ok
 Q
 ;
CHKPRV ; CHECK FILE 3, 6, 16, 200  
 S ACDQ=1
 W !!,"I am going to make sure your USER, PROVIDER, PERSON,",!," and NEW PERSON files are in sync. Please wait.",!
 D EN^AVAPCHK
 I '$D(^AVA("OK")) S ACDBAD=1 W !,"Files not in sync.  Do RESULTS^AVAPCHK to see errors and fix",!," before trying this install again.",! Q
 S ACDQ=0
 Q
 ;
CHKACDF ; CHECK CDMIS FIELDS  
 W !,"I am now going to make sure your CDMIS provider pointers",!," are all convertible. Please wait.",!
 D CHK70P7 ;          check file 9002170.7 (CDMIS PREVENTION)
 D CHK72 ;            check file 9002172 (CDMIS CLIENT SVCS)
 D CHK72P1 ;          check file 9002172.1 (CDMIS VISIT)
 D CHK72P7 ;          check file 9002172.7 (CDMIS CLIENT SVCS COPY SET)
 D CHK73P5 ;          check file 9002173.5 (CDMIS NTERVENTIONS)
 I ACDBAD W !,"Some provider pointers are not convertible.  Fix errors before",!,"  trying this install again.",!
 Q
 ;
CHK70P7 ; CHECK FILE 9002170.7
 W !,"Checking file 9002170.7",!
 NEW D0,D1,D2
 S D0=0
 F  S D0=$O(^ACDPD(D0)) Q:'D0  I $D(^ACDPD(D0,0)) D
 .  S Y=$P(^ACDPD(D0,0),U,5)
 .  I Y D CONVERT
 .  S D1=0
 .  F  S D1=$O(^ACDPD(D0,1,D1)) Q:'D1  I $D(^ACDPD(D0,1,D1,0)) D
 ..  S D2=0
 ..  F  S D2=$O(^ACDPD(D0,1,D1,"PRV",D2)) Q:'D2  I $D(^ACDPD(D0,1,D1,"PRV",D2,0)) D
 ...  S Y=$P(^ACDPD(D0,1,D1,"PRV",D2,0),U)
 ...  Q:'Y
 ...  D CONVERT
 ...  Q
 ..  Q
 .  Q
 Q
 ;
CHK72 ; CHECK FILE 9002172 
 W !,"Checking file 9002172",!
 NEW D0,D1
 S D0=0
 F  S D0=$O(^ACDCS(D0)) Q:'D0  I $D(^ACDCS(D0,0)) D
 .  S D1=0
 .  F  S D1=$O(^ACDCS(D0,1,D1)) Q:'D1  I $D(^ACDCS(D0,1,D1,0)) D
 ..  S Y=$P(^ACDCS(D0,1,D1,0),U)
 ..  Q:'Y
 ..  D CONVERT
 ..  Q
 .  Q
 Q
 ;
CHK72P1 ; CHECK FILE 9002172.1
 W !,"Checking file 9002172.1",!
 S D0=0
 F  S D0=$O(^ACDVIS(D0)) Q:'D0  I $D(^ACDVIS(D0,0)) D
 .  S Y=$P(^ACDVIS(D0,0),U,3)
 .  Q:'Y
 .  D CONVERT
 .  Q
 Q
 ;
CHK72P7 ; CHECK FILE 9002172.7
 W !,"Checking file 9002172.7",!
 NEW D0,D1,D2
 S D0=0
 F  S D0=$O(^ACDCSCS(D0)) Q:'D0  I $D(^ACDCSCS(D0,0)) D
 .  S D1=0
 .  F  S D1=$O(^ACDCSCS(D0,11,D1)) Q:'D1  I $D(^ACDCSCS(D0,11,D1,0)) D
 ..  S D2=0
 ..  F  S D2=$O(^ACDCSCS(D0,11,D1,11,D2)) Q:'D2  I $D(^ACDCSCS(D0,11,D1,11,D2,0)) D
 ...  S Y=$P(^ACDCSCS(D0,11,D1,11,D2,0),U)
 ...  Q:'Y
 ...  D CONVERT
 ...  Q
 ..  Q
 .  Q
 Q
 ;
CHK73P5 ; CHECK FILE 9002173.5
 W !,"Checking file 9002173.5",!
 NEW D0,D1
 S D0=0
 F  S D0=$O(^ACDINTV(D0)) Q:'D0  I $D(^ACDINTV(D0,0)) D
 .  S D1=0
 .  F  S D1=$O(^ACDINTV(D0,2,D1)) Q:'D1  I $D(^ACDINTV(D0,2,D1,0)) D
 ..  S Y=$P(^ACDINTV(D0,2,D1,0),U)
 ..  Q:'Y
 ..  D CONVERT
 ..  Q
 .  Q
 Q
 ;
CONVERT ; CONVERT FILE 6 POINTER TO FILE 200 POINTER
 NEW E,M,ACDZR,X
 S ACDZR=$$LGR^%ZOSV  ;                save file entry
 D CONVERT2 ;                          see if ptr converts
 I E D  Q  ;                           write error and exit
 .  W ACDZR,!,"  "_$P($T(CONVERR+E),";;",2),!,"  "_M,!
 .  S ACDBAD=1
 .  Q
 Q
 ;
CONVERR ; ERROR DESCRIPTIONS
 ;;Dangling pointer to file 6
 ;;File 6 pointer not in file 16
 ;;No A3 node in file 16
 ;;A3 pointer null or not numeric
 ;;No entry in file 200 for A3 pointer
 ;
CONVERT2 ;
 S E=0
 S M="File 6 ptr="_Y
 I '$D(^DIC(6,Y,0)) S E=1 Q  ;         dangling 6 ptr
 I '$D(^DIC(16,Y,0)) S E=2 Q  ;        6 ptr not in 16
 I '$D(^DIC(16,Y,"A3")) S E=3 Q  ;     no A3 node in 16
 S X=^DIC(16,Y,"A3")
 I 'X S E=4 Q  ;                       A3 ptr null or not numeric
 S M=M_", A3 ptr="_X
 I '$D(^VA(200,X,0)) S E=5 Q  ;        no 200 entry for A3 ptr
 Q
