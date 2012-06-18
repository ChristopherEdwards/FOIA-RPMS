AUPN99P7 ;IHS/CMI/LAB,GTH,EFG,SDR - AUPN 99.1 PATCH 7 ; [ 05/09/2003  7:58 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**7,9,10**;JUN 13, 2003
 ;
 ; IHS/ASDST/GTH AUPN*99.1*7 02/15/2002
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW AUPNQUIT
 S AUPNQUIT=0
 I '$$VCHK("AUPN","99.1",2) S AUPNQUIT=2
 I '$$VCHK("DI","21.0",2) S AUPNQUIT=2
 I '$$VCHK("XU","8.0",2) S AUPNQUIT=2
 S X=$$VERSION^XPDUTL("AUT")
 W !,$$CJ^XLFSTR("Need at least AUT 98.1.....AUT "_X_" Present",IOM)
 I X<98.1,+X'=1.1 S AUPNQUIT=2
 I '$$INSTALLD("AUT*98.1*7") S AUPNQUIT=2
 ;
 NEW DA,DIC
 S X="AUPN",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUPN")) D  Q
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUPN"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 . D SORRY(2)
 . I $$DIR^XBDIR("E")
 .Q
 W !,$$CJ^XLFSTR("No 'AUPN' dups in PACKAGE file",IOM)
 ;
 I AUPNQUIT D SORRY(AUPNQUIT) Q
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 .Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(AUPNPRE,AUPNVER,AUPNQUIT) ; Check versions needed.
 ;  
 NEW AUPNV
 S AUPNV=$$VERSION^XPDUTL(AUPNPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUPNPRE_" v "_AUPNVER_"....."_AUPNPRE_" v "_AUPNV_" Present",IOM)
 I AUPNV<AUPNVER W *7,!,$$CJ^XLFSTR("Sorry....",IOM) Q 0
 Q 1
 ;
PRE ;EP - From KIDS.
 D BMES^XPDUTL("Beginning Pre-install routine (PRE^AUPN99P7).")
 I '$$INSTALLD("AUPN*99.1*6") D  I 1
 . D BMES^XPDUTL("AUPN*99.1*6 NOT installed.  Deleting dd fields .")
 . NEW DIK
 . S DIK="^DD(9000010.24,",DA=.01,DA(1)=9000010.24 D ^DIK
 . S DIK="^DD(9000010.24,",DA=.04,DA(1)=9000010.24 D ^DIK
 . S DIK="^DD(9000010.34,",DA=.01,DA(1)=9000010.34 D ^DIK
 .Q
 E  D BMES^XPDUTL("AUPN*99.1*6 is installed.  No dd fields deleted.")
 ;
 D BMES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Beginning post-install routine (POST^AUPN99P7).")
 ;
 D QUERPT
 ;
 I '$$INSTALLD("AUPN*99.1*5") D  I 1
 . D BMES^XPDUTL("AUPN*99.1*5 not installed."),MES^XPDUTL("  Indexing AE x-ref on Medicaid Eligible...")
 . D POST^AUPN99P5
 . D MES^XPDUTL("X-ref complete.")
 .Q
 E  D BMES^XPDUTL("AUPN*99.1*5 is installed.  No action necessary.")
 ;
 D MAIL
 ;
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
MAIL ; Send install mail message.
 D BMES^XPDUTL("Delivering AUPN*99.1*7 install message to select users...")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUPN99P7MS",$J)
 S ^TMP("AUPN99P7MS",$J,1)=" --- AUPN v 99.1, Patch 7, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AUPN99P7MS",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUPN99P7MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","APCDZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AUPN99P7MS",$J)
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
INSTALLD(AUPNSTAL) ;EP - Determine if patch AUPNSTAL was installed, where
 ; AUPNSTAL is the name of the INSTALL.  E.g "AG*6.0*10".
 ;
 NEW AUPNY,DIC,X,Y
 S X=$P(AUPNSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(AUPNSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AUPNSTAL,"*",3)
 D ^DIC
 S AUPNY=Y
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AUPNSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q $S(AUPNY<1:0,1:1)
 ;
QUERPT ;
 D BMES^XPDUTL("Q'ing one-time report on begin/end dates in Insurance Eligible files...")
 ;
 S ZTRTN="ELIGDATS^AUPN99P7",ZTDESC="Insurance Eligibility Dates.",ZTDTH=$H,ZTIO="",ZTSAVE("DUZ")=""
 D ^%ZTLOAD
 I '$D(ZTSK) D BMES^XPDUTL("ERROR**:  Q to TaskMan failed (?).") Q
 D BMES^XPDUTL("Q'd to Task '"_ZTSK_"'.")
 Q
 ;
ELIGDATS ;EP - From TaskMan or Programmer mode.
 ; One-time report on Insurance Eligibility records whose Ending date
 ; preceeds the begin date.
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUPN991P7",$J)
 D DATES
 S XMSUB="Insurance Eligibility Dates.",XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""AUPN991P7"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROGMODE","AGZMENU","ABMDZ ELIGIBILITY EDIT" D SINGLE(%)
 NEW DIFROM
 D ^XMD
 KILL ^TMP("AUPN991P7",$J)
 I $D(ZTQUEUED) S ZTREQ="@" Q
 W !,"The results are in your MailMan 'IN' basket."
 Q
 ;
DATES ;
 ;;This is a one time report, released in patch AUPN*99.1*7.
 ;;  
 ;;However, if you need to rerun the report, D QUERPT^AUPN99P7,
 ;;is the command from programmer mode.
 ;;  
 ;;You are receiving this message b/c of the particular security
 ;;keys that you hold.  If you are not an appropriate person at
 ;;your facility to correct any coverages that are listed, below,
 ;;please ensure the appropriate person receives this report.
 ;;  
 ;;This report lists Insurance elgibility coverages whose coverage
 ;;dates include an ending date that -PRECEEDS- the begin date.
 ;;Coverages with dates in that condition will result in the
 ;;associated beginning date not being found by any Third Party
 ;;Billing application.
 ;;  
 ;;Insurance coverages in this condition were found during routine
 ;;analysis of the 9.5 million insurance eligibility records received
 ;;during the NPIRS reload of 2001.  That analysis indicated about
 ;;12,000 (1/10th of 1 percent) of the records had an ending date
 ;;that preceeded the begin date.
 ;;  
 ;;Patch AUPN*99.1*7 will prevent this condition from being entered
 ;;for MEDICARE, MEDICAID, and RAILROAD insurance elgibiltiy dates
 ;;by placing a check on the ending date during data entry.  However,
 ;;PRIVATE INSURANCE is more complicated in its computation, and an
 ;;associated patch will be released thru Patient Registration (AG).
 ;;  
 ;;end
 ;
 F %=1:1 S X=$P($T(DATES+%),";",3) Q:X="end"  D RSLT(X)
 D HDR,MCR,HDR,MCD,HDR,RRE,HDR,PVT
 Q
 ;
HDR ;
 D RSLT("-------------------------------------------------------------")
 D RSLT(""),RSLT("")
 D RSLT("TYPE        BEGIN DATE    END DATE      TYPE    ASUFAC/HRN")
 D RSLT("-------------------------------------------------------------")
 Q
 ;
MCR ;
 NEW A,D,I,P
 F P=0:0 S P=$O(^AUPNMCR(P)) Q:'P  D
 . F I=0:0 S I=$O(^AUPNMCR(P,11,I)) Q:'I  D
 .. Q:'$P(^AUPNMCR(P,11,I,0),U,2)  S D=^(0)
 .. Q:'($P(D,U,2)<$P(D,U,1))
 .. S A=$$ASU(P),D=$$FMTE(D)
 .. D RSLT("MEDICARE    "_$P(D,U,1)_"  "_$P(D,U,2)_"  "_$$LJ^XLFSTR($P(D,U,3),8)_$P(A,U))
 .. F %=2:1 Q:'$L($P(A,U,%))  D RSLT($J("",48)_$P(A,U,%))
 ..Q
 .Q
 Q
 ;
MCD ;
 NEW A,I,J,Y,P
 F P=0:0 S P=$O(^AUPNMCD(P)) Q:'P  D
 . F I=0:0 S I=$O(^AUPNMCD(P,11,I)) Q:'I  D
 .. Q:'$P(^AUPNMCD(P,11,I,0),U,2)  S D=^(0)
 .. Q:'($P(D,U,2)<$P(D,U,1))
 .. S A=$$ASU($P(^AUPNMCD(P,0),U)),D=$$FMTE(D)
 .. D RSLT("MEDICAID    "_$P(D,U,1)_"  "_$P(D,U,2)_"  "_$$LJ^XLFSTR($P(D,U,3),8)_$P(A,U))
 .. F %=2:1 Q:'$L($P(A,U,%))  D RSLT($J("",48)_$P(A,U,%))
 ..Q
 .Q
 Q
 ;
RRE ;
 NEW A,I,P
 F P=0:0 S P=$O(^AUPNRRE(P)) Q:'P  D
 . F I=0:0 S I=$O(^AUPNRRE(P,11,I)) Q:'I  D
 .. Q:'$P(^AUPNRRE(P,11,I,0),U,2)  S D=^(0)
 .. Q:'($P(D,U,2)<$P(D,U,1))
 .. S A=$$ASU(P),D=$$FMTE(D)
 .. D RSLT("RAILROAD    "_$P(D,U,1)_"  "_$P(D,U,2)_"  "_$$LJ^XLFSTR($P(D,U,3),8)_$P(A,U))
 .. F %=2:1 Q:'$L($P(A,U,%))  D RSLT($J("",48)_$P(A,U,%))
 ..Q
 .Q
 Q
 ;
PVT ;
 NEW A,I,J,Y,P
 F P=0:0 S P=$O(^AUPNPRVT(P)) Q:'P  D
 . F I=0:0 S I=$O(^AUPNPRVT(P,11,I)) Q:'I  D
 .. Q:'$P(^AUPNPRVT(P,11,I,0),U,7)  S D=^(0)
 .. Q:'($P(D,U,7)<$P(D,U,6))
 .. S A=$$ASU($P(^AUPNPRVT(P,0),U)),D=$P(D,U,6)_U_$P(D,U,7)_U_$P(D,U,3),D=$$FMTE(D)
 .. D RSLT("PRIVATE     "_$P(D,U,1)_"  "_$P(D,U,2)_"          "_$P(A,U))
 .. F %=2:1 Q:'$L($P(A,U,%))  D RSLT($J("",48)_$P(A,U,%))
 ..Q
 .Q
 Q
 ;
ASU(P) ;
 NEW I,X
 S X=""
 F I=0:0 S I=$O(^AUPNPAT(P,41,I)) Q:'I  S X=X_$P(^AUTTLOC(I,0),U,10)_"/"_$J($P(^AUPNPAT(P,41,I,0),U,2),6)_U
 Q X
 ;
RSLT(%) S ^(0)=$G(^TMP("AUPN991P7",$J,0))+1,^(^(0))=%
 Q
 ;
FMTE(D) ;
 NEW A,I,J,Y,P,X
 Q $$FMTE^XLFDT($P(D,U))_U_$$FMTE^XLFDT($P(D,U,2))_U_$P(D,U,3)
 ;
