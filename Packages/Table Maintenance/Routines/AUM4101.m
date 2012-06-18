AUM4101 ;TASSC/MFD - SCB UPDATE 10/31/2003 [ 11/25/2003  12:43 PM ]
 ;;04.1;TABLE MAINTENANCE;**1**;OCT 31,2003
 ;
ENV ;----- ENVIRONMENT CHECK
 ;
 D ^XBKVAR
 D HOME^%ZIS
 ;
 K XPDQUIT
 ;
 D DUZ(.DUZ,.XPDQUIT)
 Q:$D(XPDQUIT)
 ;
 D HELLO(DUZ)
 ;
 ; Check for required versons and patches
 ;
 I $$VCHK("XU","8.0",2,"<")
 I $$VCHK("DI","21.0",2,"<")
 I $$VCHK("AUM","4.1",2,"'=")
 I $$VCHK("AUT","98.1",2,"'=")
 I $$PCHK("AUT","98.1",13,2,"<")
 Q:$D(XPDQUIT)
 ;
 D CKPKG(.XPDQUIT)    ;Check for dupes in package file
 ;
 D OK(.XPDQUIT)
 Q:$D(XPDQUIT)
 ;
 D HELP^XBHELP("INTROE","AUM4101")
 ;
 D XPZ
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(3,.XPDQUIT)
 ;
 Q
 ;
DUZ(DUZ,XPDQUIT)   ;
 ;----- CHECK FOR VALID DUZ
 ;
 I '$G(DUZ) D
 . W !,"DUZ UNDEFINED OR 0"
 . D SORRY(2,.XPDQUIT)
 I '$L($G(DUZ(0))) D
 . W !,"DUZ(0) UNDEFINED OR NULL"
 . D SORRY(2,.XPDQUIT)
 Q
HELLO(DUZ)         ;
 ;----- DISPLAY GREETING
 ;
 N X
 S X=$P($G(^VA(200,DUZ,0)),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 Q
CKPKG(XPDQUIT)     ;
 ;----- CHECK PACKAGE FILE FOR DUPLICATE ENTRY
 ;
 N D,DIC,X,Y
 S X="AUM"
 S DIC="^DIC(9.4,"
 S DIC(0)=""
 S D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUM")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You have more than one entry in the",IOM)
 . W !,$$CJ^XLFSTR("PACKAGE file with an ""AUM"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . S XPDQUIT=2
 Q
XPZ ;----- SET XPDDIQ ARRAY TO KEEP KIDS FROM ASKING DISABLE AND CPU
 ;      MOVE QUESTIONS
 I $G(XPDENV)=1 D
 . S (XPDDIQ("XPZ1"))=0
 . S (XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","AUM4101")
 Q
OK(XPDQUIT)        ;
 ;----- ISSUE OK MESSAGE
 ;
 I $D(XPDQUIT) D  Q
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding",IOM),!!,*7,*7,*7
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK",IOM)
 Q
SORRY(X,XPDQUIT)   ;
 K DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(AUMPRE,AUMVER,AUMQUIT,AUMCOMP)    ;
 ;----- CHECK VERSIONS NEEDED
 ;  
 N AUMV
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 W !,$$CJ^XLFSTR("Need "_$S(AUMCOMP="<":"at least ",1:"")_AUMPRE_" v "_AUMVER_"....."_AUMPRE_" v "_AUMV_" Present",IOM)
 I @(+AUMV_AUMCOMP_AUMVER) D SORRY(AUMQUIT) Q 0
 Q 1
 ;
PCHK(AUMPRE,AUMVER,AUMPAT,AUMQUIT,AUMCOMP)     ;    
 ;----- CHECK PATCHES NEEDED
 N AUMV,AUMX
 S AUMV=AUMPRE_"*"_AUMVER_"*"_AUMPAT
 S AUMX=$$PATCH^XPDUTL(AUMV)
 W !,$$CJ^XLFSTR("Need "_$S(AUMCOMP="<":"at least ",1:"")_AUMV_"....."_$S(AUMX:" Present",1:" NOT Present"),IOM)
 I 'AUMX D SORRY(AUMQUIT) Q 0
 Q 1
 ;
POST ;EP -- POST INSTALL FROM KIDS
 ;
 I ^DD(9999999.03,.01,1,1,1)["1,40)," D BINDEX
 K ^TMP("AUM4101",$J)
 D AUDS
 D START^AUM41011
 D AUDR
 D MAIL
 ;D QUE   ;this deletes the routines from this update
 Q
MAIL ;----- SEND EMAIL
 ;
 K ^TMP("AUM4101",$J)
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 D MES^XPDUTL("BEGIN Delivering MailMan message to select users...")
 D RSLT^AUM41011(" --- AUM v 4.1, Patch 1, has been installed ---")
 F %=1:1 D RSLT^AUM41011($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT^AUM41011(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""AUM4101"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE","AGZBILL","ABMDZ TABLE MAINTENANCE","APCCZMGR" D SINGLE(%)
 D ^XMD
 K ^TMP("AUM4101",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users...")
 Q
 ;
QUE ;----- QUEUE ROUTINE DELETION     
 ;
 N X,Y,ZTDESC,ZTDTH,ZTIO,ZTPRI,ZTREQ,ZTRTN,ZTSK
 I $D(ZTQUEUED) S ZTREQ="@"
 Q:'$L($T(+1^AUMDELR))
 S ZTRTN="DEL^AUMDELR(""AUM4101"")"
 S ZTDESC="Delete routines in the 'AUM4101' namespace"
 S ZTDTH=$$HADD^XLFDT($H,0,0,30,0)
 S ZTIO=""
 S ZTPRI=1
 D ^%ZTLOAD
 I '$D(ZTSK) D  Q
 . D BMES^XPDUTL("Q to TaskMan to delete routines in background failed (?)")
 D BMES^XPDUTL("NOTE: The routines in this update will be deleted in the background")
 D BMES^XPDUTL("30 minutes from now by Task #"_ZTSK)
 Q
SINGLE(K) ;
 ;----- GET HOLDERS OF A SINGLE KEY K, PUT IN XMY ARRAY
 ;
 N Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
AUDS ;----- SAVE CURRENT SETTINGS AND SET DATA AUDITING 'ON'
 ;
 ; NOTE:
 ; Data auditing at the file level is indicated by a lower case "a"
 ; in the 2nd piece of the 0th node of the global.
 ; Data auditing at the field level is indicated by a lower case "a"
 ; in the 2nd piece of the 0th node of the field definition in ^DD(.
 ;
 S ^XTMP("AUM4101",0)=$$FMADD^XLFDT(DT,56)_"^"_DT_"^"_"**ADD DATE** STANDARD TABLE UPDATES"
 N G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S P=$P(@(G_"0)"),"^",2)
 . I '$D(^XTMP("AUM4101",G)) S ^XTMP("AUM4101",G)=P
 . S:'(P["a") $P(@(G_"0)"),"^",2)=P_"a"
 . D AUDF(+P)
 Q
AUDF(F) ;----- PROCESS ALL FIELDS FOR FILE 4, INCLUDING SUB-FILES
 ;
 N D,P
 S D=0
 F  S D=$O(^DD(F,D)) Q:'D  D
 . I $P(^DD(F,D,0),U,2) D AUDF(+$P(^(0),U,2)) Q
 . S P=$P(^DD(F,D,0),U,2),G="^DD("_F_","_D_","
 . I '$D(^XTMP("AUM4101",G)) S ^XTMP("AUM4101",G)=P
 . I '$D(^XTMP("AUM4101",G,"AUDIT")) S ^XTMP("AUM4101",G,"AUDIT")=$G(@(G_"""AUDIT"")"))
 . S:'(P["a") $P(@(G_"0)"),"^",2)=P_"a"
 . S ^DD(F,D,"AUDIT")="y"
 Q
AUDR ;----- RESTORE THE FILE DATA AUDIT VALUES TO THEIR ORIGINAL VALUES
 ;
 N G,P
 S G=0
 F  S G=$O(^XTMP("AUM4101",G)) Q:'$L(G)  D
 . S $P(@(G_"0)"),"^",2)=^XTMP("AUM4101",G)
 . Q:'(G["^DD(")
 . S (@(G_"""AUDIT"")"))=^XTMP("AUM4101",G,"AUDIT")
 . K:@(G_"""AUDIT"")")="" @(G_"""AUDIT"")")
 Q
AUD ;----- THESE ARE FILES TO BE DATA AUDITED FOR THIS PATCH ONLY
 ;;^AUTTEXAM(
 ;;^AUTTTRI(
 ;;^AUTTEDPF(
 ;;^AUTTAREA(
 ;;^AUTTCOM(
 ;;^AUTTCTY(
 ;;^AUTTHF(
 ;;^AUTTLOC(
 ;;^AUTTMSR(
 ;;^AUTTSU(
 ;;^DIC(7,
 ;;^DIC(40.7,
 ;;END
 Q
AUDPRT ;----- PRINT FROM AUDIT FILE
 ;
 N BY,DIC,FLDS,X,Y
 Q:$D(ZTQUEUED)
 W !,"*** Print from the AUDIT file."
 S DIC=1
 S DIC("A")="Select the file from which you want to print the data AUDIT: "
 S DIC(0)="A"
 D ^DIC
 Q:+Y<1
 S DIC="^DIA("_+Y_","
 S FLDS="[CAPTIONED]"
 S BY=.02
 D EN1^DIP
 Q
INTROE ;----- INTRO TEXT DURING KIDS ENVIRONMENT CHECK
 ;;This distribution:
 ;;(1) Implements SCB mods for the past several months
 ;;(2) New entry into EXAM file- INT PARTNER VIOLENCE SCREEN
 ;;(3) New entries into HEALTH FACTORS
 ;;(4) New PROVIDER CLASS added - PHARMACY TECHNICIAN
 ;;(5) Several new entries to the CLINIC STOP file
 ;;###
 ;
INTROI ;----- INTRO TEXT DURING KIDS INSTALL
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message and the entry in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
 ;
GREET ;;EP - TO ADD TO MAIL MESSAGE
 ;;  
 ;;Greetings.
 ;;  
 ;;Standard tables on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Requests for modifications or additions to RPMS standard tables,
 ;;whether they are or are not contained in the IHS Standard Code
 ;;Book (SCB), can be submitted to your Area Information System
 ;;Coordinator (ISC).
 ;;  
 ;;Sections of the IHS Standard Code Book (SCB) can be viewed, printed,
 ;;and extracted from the NPIRS Intranet website at url:
 ;;  http://dpsntweb1.hqw.DOMAIN.NAME/ciweb/main.html
 ;;  
 ;;Questions about this patch, which is a product of the RPMS DBA
 ;;can be directed to the Help Desk,
 ;;".  Please
 ;;refer to patch "AUM*4.1*1".
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
BINDEX ;
 K ^AUTTTRI("B")
 S ^DD(9999999.03,.01,1,1,1)="S ^AUTTTRI(""B"",$E(X,1,30),DA)="""""
 S ^DD(9999999.03,.01,1,1,2)="K ^AUTTTRI(""B"",$E(X,1,30),DA)"
 S DIK="^AUTTTRI(",DIK(1)=".01^B" D ENALL^DIK
 Q
