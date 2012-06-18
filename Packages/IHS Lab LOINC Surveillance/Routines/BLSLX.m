BLSLX ; IHS/CMI/LAB - BLS export data ;  [ 02/20/2003  6:40 AM ]
 ;;5.2;LR;**1015**;NOV 18, 2002
 ;
 ;
EN(BLSX) ;EP - called from APCDALVR
 I '$G(BLSX) Q
 Q:'$$ADDON^BLRUTIL("LR*5.2*1015","BLSLX",DUZ(2))  ;REAL 
 I '$D(^AUPNVLAB(BLSX)) Q
 I $P($G(^AUPNVLAB(BLSX,11)),U,9)'="R" Q
 NEW BLSLOINC
 S BLSLOINC=$P($G(^AUPNVLAB(BLSX,11)),U,13)
 Q:BLSLOINC=""
 I '$D(^BLSELL(BLSLOINC)) Q  ;not a test cereplex wants
 I '$G(BLSRX) I $D(^BLSLX(BLSX,0)),$P(^BLSLX(BLSX,0),U,3)="" Q
 S ^BLSLX(BLSX,0)=BLSX_"^"_DT
 S ^BLSLX("AEXP",DT,BLSX)="",^BLSLX("B",BLSX,BLSX)=""
 L +^BLSLX(0):10
 S $P(^BLSLX(0),U,3)=BLSX,$P(^BLSLX(0),U,4)=$P(^BLSLX(0),U,4)+1
 L -^BLSLX(0)
 K BLSX
 Q
 ;
EXPORT ;EP - loop through BLSLX and export message
 I '$D(ZTQUEUED) W !,"Generating HL7 messages for export"
 S BLSDA=0 F  S BLSDA=$O(^BLSLX("AEXP",BLSDA)) Q:'BLSDA  D
 . S BLSIEN=0 F  S BLSIEN=$O(^BLSLX("AEXP",BLSDA,BLSIEN)) Q:'BLSIEN  D
 .. S BLSERR=$$R01SS^BHLEVENT(BLSIEN)
 .. Q:'INHF
 .. I '$D(ZTQUEUED) W "."
 .. S DIE="^BLSLX(",DA=BLSIEN,DR=".03////"_DT D ^DIE
 .. K DIE,DR
 S BLSDEST=$O(^INRHD("B","HL IHS LOINC",0))
 Q:'BLSDEST
 S BLSDIR=$P($G(^BLRSITE(DUZ(2),5)),U,3)
 ;S BLSXPD=$P($G(^BLRSITE(DUZ(2),5)),U,2)
 S BLSLLI=$P($G(^BLRSITE(DUZ(2),5)),U,5)
 S BLSLPI=$P($G(^BLRSITE(DUZ(2),5)),U,6)
 I BLSLLI]"" S BLSLL=$$DQ(BLSLLI)
 I BLSLPI]"" S BLSLP=$$DQ(BLSLPI)
 S BLSPASS=$G(BLSLL)_":"_$G(BLSLP)
 I BLSPASS=":" S BLSPASS=""
 S BLSFTP=$P($G(^BLRSITE(DUZ(2),5)),U)
 S BLSFNM="BLS"_$$FAC(DUZ(2))_$E($$DATE^INHUT($$NOW,1),1,14)_".HL7"
 I '$D(ZTQUEUED) D
 . W !!,"Now writing export file, this could take up to 5 minutes"
 H 300  ;for message generation to occur
 D HFSA^BHLU(BLSDEST,BLSDIR,BLSFNM)
 I '$D(ZTQUEUED) D
 . W !,"Export file "_BLSFNM_" in directory "_BLSDIR_" created"
 . W !,"Sending to IP Address "_BLSFTP
 D SENDFILE(BLSFNM,BLSDIR,BLSFTP,BLSPASS)
 I '$D(ZTQUEUED) D
 . W !,"File "_BLSFNM_" sent to "_BLSFTP
 D BUL(BLSFTP,BLSDIR,BLSFNM)
 Q
 ;
BUL(FTP,DIR,FNM)   ;-- send a bulletin indicating file send
 S XMB="BLS EXPORT FILE SENT"
 S XMB(1)=FNM
 S XMB(2)=DIR
 S XMB(3)=FTP
 D ^XMB
 K XMB
 Q
 ;
RESEND ;EP -- resend a file
 S BLSDIR=$P($G(^BLRSITE(DUZ(2),5)),U,3)
 S BLSFLST=$$LIST(BLSDIR)
 I BLSFLST<1 W !,"No Files in the directory, goodbye" Q
 S BLSLSDA=0 F  S BLSLSDA=$O(BLSFILES(BLSLSDA)) Q:'BLSLSDA  D
 . W !,BLSLSDA_" - "_$G(BLSFILES(BLSLSDA))
 S DIR(0)="L^1:"_BLSFLST,DIR("A")="Resend which file(s) "
 D ^DIR
 Q:$D(DIRUT)
 S BLSFNMI=Y
 F BLSI=1:1:BLSFLST  S BLSFLI=$P(BLSFNMI,",",BLSI) Q:BLSFLI=""  D
 . S BLSFNM=$G(BLSFILES(BLSFLI))
 . ;S BLSXPD=$P($G(^BLRSITE(DUZ(2),5)),U,2)
 . S BLSFTP=$P($G(^BLRSITE(DUZ(2),5)),U)
 . S BLSLLI=$P($G(^BLRSITE(DUZ(2),5)),U,5)
 . S BLSLPI=$P($G(^BLRSITE(DUZ(2),5)),U,6)
 . I BLSLLI]"" S BLSLL=$$DQ(BLSLLI)
 . I BLSLPI]"" S BLSLP=$$DQ(BLSLPI)
 . S BLSPASS=$G(BLSLL)_":"_$G(BLSLP)
 . I BLSPASS=":" S BLSPASS=""
 . W !,"Sending export file "_BLSFNM_" in directory "_BLSDIR
 . W !,"Sending to IP Address "_BLSFTP
 . D SENDFILE(BLSFNM,BLSDIR,BLSFTP,BLSPASS)
 . W !,"File "_BLSFNM_" sent to "_BLSFTP
 . D BUL(BLSFTP,BLSDIR,BLSFNM)
 Q
 ;
CLEANUP ;EP -- cleanup files older than parameter days
 S BLSDIR=$P($G(^BLRSITE(DUZ(2),5)),U,3)
 S BLSDAYS=$P($G(^BLRSITE(DUZ(2),5)),U,4)
 I 'BLSDAYS S BLSDAYS=30
 S BLST=$$BLST(DT,BLSDAYS)
 S BLSTE=$$FMTE^XLFDT(BLST)
 S BLSCDA=0
 W !,"Now cleaning up export log file entries older than "_BLSTE
 F  S BLSCDA=$O(^BLSLX("ADXP",BLSCDA)) Q:'BLSCDA!(BLSCDA>BLST)  D
 . S BLSCIEN=0
 . F  S BLSCIEN=$O(^BLSLX("ADXP",BLSCDA,BLSCIEN)) Q:'BLSCIEN  D
 .. W "."
 .. S DIK="^BLSLX(",DA=BLSCIEN D ^DIK
 W !!,"Now cleaning up host files older than "_BLSTE
 S BLSFLST=$$LIST(BLSDIR)
 Q:'$O(BLSFILES(""))
 S BLSFDA=0 F  S BLSFDA=$O(BLSFILES(BLSFDA)) Q:'BLSFDA  D
 . S BLSFNM=$G(BLSFILES(BLSFDA))
 . S BLSFDT=$$HDATE^INHUT($E(BLSFNM,10,17))
 . Q:'+$G(BLSFDT)
 . Q:BLSFDT>BLST
 . W !,"Removing export file "_BLSFNM_" in directory "_BLSDIR
 . ;S BLSOS=$P($G(^AUTTSITE(1,0)),U,21)
 . ;I BLSOS=1 S X=$$TERMINAL^%HOSTCMD("rm "_BLSDIR_BLSFNM)
 . ;I BLSOS=2 S X=$ZOS(2,BLSDIR_BLSFNM)
 . ;W !,"File "_BLSFNM_" removed"
 .;BEGIN MOD
 .S X=$$DEL^%ZISH(BLSDIR,BLSFNM)  ;IHS/ITSC/TPF 1/27/2003 REMOVE VENDOR SPECIFIC CODE ABOVE ; X=0 IF SUCCESSFUL
 .I 'X W !,"File "_BLSFNM_" removed"
 .;END MOD
 Q
 ;
RFILE ;EP - remove files from hfs
 S BLSDIR=$P($G(^BLRSITE(DUZ(2),5)),U,3)
 S BLSFLST=$$LIST(BLSDIR)
 I BLSFLST<1 W !,"No Files in the directory, goodbye" Q
 S BLSLSDA=0 F  S BLSLSDA=$O(BLSFILES(BLSLSDA)) Q:'BLSLSDA  D
 . W !,BLSLSDA_" - "_$G(BLSFILES(BLSLSDA))
 S DIR(0)="L^1:"_BLSFLST,DIR("A")="Remove which file(s) "
 D ^DIR
 Q:$D(DIRUT)
 S BLSFNMI=Y
 F BLSI=1:1:BLSFLST  S BLSFLI=$P(BLSFNMI,",",BLSI) Q:BLSFLI=""  D
 . S BLSFNM=$G(BLSFILES(BLSFLI))
 . ;S BLSXPD=$P($G(^BLRSITE(DUZ(2),5)),U,2)
 . S BLSFTP=$P($G(^BLRSITE(DUZ(2),5)),U)
 . W !,"Removing export file "_BLSFNM_" in directory "_BLSDIR
 . ;S BLSOS=$P($G(^AUTTSITE(1,0)),U,21)
 . ;I BLSOS=1 S X=$$TERMINAL^%HOSTCMD(BLSDIR_BLSFNM)
 . ;I BLSOS=2 S X=$ZOS(2,BLSDIR_BLSFNM)
 . ;W !,"File "_BLSFNM_" removed"
 .;BEGIN MOD
 .S X=$$DEL^%ZISH(BLSDIR,BLSFNM)  ;IHS/ITSC/TPF 1/27/2003 REMOVE VENDOR SPECIFIC CODE ABOVE; X=0 IF SUCCESSFUL
 .I 'X W !,"File "_BLSFNM_" removed"
 .;END MOD
 Q
 ;
SENDFILE(FNM,SDIR,IP,PASS) ;-- this will trigger a send via the sendto command, sendto.pl must exist
 S BLSOPS=$P($G(^AUTTSITE(1,0)),U,21)
 ;I PASS["anonymous" D  Q
 ;. S BLSSEND="sendto -i"_$S(BHLOPS=1:" ",1:" -a ")_IP_" "_SDIR_FNM
 ;. S X=$$JOBWAIT^%HOSTCMD(BLSSEND)
 ;S BLSSEND="sendto1 -u  -l "_PASS_$S(BLSOPS=1:" ",1:" -a ")_IP_" "_SDIR_FNM
 ;S X=$$JOBWAIT^%HOSTCMD(BLSSEND)
 S RESULT=$$SEND^%ZISH(SDIR,FNM,IP)  ;CHANGE REQUIRED BY SAC REQUIREMENTS IHS/ITSC/TPF 02/10/03 RESULT=0 IF SUCCESSFUL
 ;
 Q
 ;
BLST(DATE,DAYS)    ;-- find cleanup date
 S X1=DATE,X2=-(DAYS)
 D C^%DTC
 Q X
 ;
NOW() ;-- return now in fm dt
 D NOW^%DTC
 Q %
 ;
LIST(DIR) ;-- get a list of files in the directory
 S Y=$$LIST^%ZISH(DIR,"BLS*",.BLSFILES)
 Q $O(BLSFILES(""),-1)
 ;
FAC(LOC) ;-- return the asufac code
 Q $P($G(^AUTTLOC(LOC,0)),U,10)
 ;
DQ(DEQ) ;-- decrypt the password
 N X,X1,X2
 S (X1,X2)=5,X=DEQ
 D DE^XUSHSHP
 Q X
 ;
