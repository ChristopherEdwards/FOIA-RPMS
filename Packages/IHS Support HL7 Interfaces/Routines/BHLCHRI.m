BHLCHRI ; cmi/anch/maw - BHL Read CHR data into ^INTHU ;
 ;;3.01;BHL IHS Interfaces with GIS;**10,14**;JUL 1, 2005
 ;
 ;
 ;this routine will grab a file from HFS and stuff it into the ^INTHU
 ;global for processing
 ;
MAIN ;-- this is the main routine driver
 N BHLY
 D ^%ZISC
 K ^TMP("BHLRL",$J)
 S BHLY=$$CHK^BHLBCK("OUTPUT CONTROLLER")
 D READ(DUZ(2))
 D EOJ
 Q
 ;
READ(BHLCHRI) ;-- read the file in
 ;cmi/maw we need to set up dynamic directory reads here
 N BHLFLG,BHLDIR,BHLFST,BHLFLST,BHLLST
 S BHLCHR=$O(^BCHSITE("B",BHLCHRI,0))
 I $G(BHLCHR)="" S BHLFLG=1
 I $G(BHLCHR)]"" D
 . S BHLDIR=$P($G(^BCHSITE(BHLCHR,0)),U,13)
 . I BHLDIR="" S BHLFLG=1 Q
 . S BHLFST=$P($G(^BCHSITE(BHLCHR,0)),U,14)
 . I BHLFST="" S BHLFLG=1 Q
 I $G(BHLFLG) D  Q
 . Q:$D(ZTQUEUED)
 . W !,"CHR Parameters not Defined in BCH SITE PARAMETER File"
 S BHLFST=BHLFST_"*"
 I '$D(ZTQUEUED) D
 . W !!,"Now reading in CHR file from directory "_BHLDIR
 S BHLFLST=$$LIST^%ZISH(BHLDIR,BHLFST,.BHLLST)
 ;D CR(.BHLLST,"") Q
 D LC(.BHLLST,"")
 Q
 ;
LC(BHLLST,RFLG) ;-- parse
 S BHLFDA=0 F  S BHLFDA=$O(BHLLST(BHLFDA)) Q:'BHLFDA  D
 . D ^%ZISC
 . S BHLFNM=$G(BHLLST(BHLFDA))
 . S Y=$$OPEN^%ZISH(BHLDIR,BHLFNM,"R")
 . I $G(Y),'$D(ZTQUEUED) W !,"Error Opening Device" Q
 . S CNTR=1
 . F I=1:1 U IO R BHLT:DTIME D  Q:BHLT=""
 .. Q:BHLT=""
 .. I $E($G(BHLT),1,3)="MSH",CNTR>1 D STUFF K ^TMP("BHLRL",$J) S CNTR=1
 .. S ^TMP("BHLRL",$J,CNTR)=$G(BHLT)
 .. S CNTR=CNTR+1
 . S BHLLMSG=$$LOG(BHLFNM,"R",DUZ)
 . D STUFF
 . D ^%ZISC
 . K ^TMP("BHLRL",$J)
 Q
 ;
CRLF(BHLLST,RFLG) ;-- parse by carriage return line feed
 S BHLFDA=0 F  S BHLFDA=$O(BHLLST(BHLFDA)) Q:'BHLFDA  D
 . D ^%ZISC
 . S BHLFNM=$G(BHLLST(BHLFDA))
 . S Y=$$OPEN^%ZISH(BHLDIR,BHLFNM,"R")
 . I $G(Y),'$D(ZTQUEUED) W !,"Error Opening Device" Q
 . S CNTR=1
 . F I=1:1 U IO R BHLT:DTIME D  Q:BHLT=""
 .. Q:BHLT=""
 .. S ^TMP("BHLRL",$J,CNTR)=$G(BHLT)
 .. S CNTR=CNTR+1
 . S BHLLMSG=$$LOG(BHLFNM,"R",DUZ)
 . D STUFF
 . D ^%ZISC
 . K ^TMP("BHLRL",$J)
 Q
 ;
CR(BHLLST,RFLG) ;-- parse message by CR only
 S BHLFDA=0 F  S BHLFDA=$O(BHLLST(BHLFDA)) Q:'BHLFDA  D
 . D ^%ZISC
 . S BHLFNM=$G(BHLLST(BHLFDA))
 . S Y=$$OPEN^%ZISH(BHLDIR,BHLFNM,"R")
 . I $G(Y),'$D(ZTQUEUED) W !,"Error Opening Device" Q
 . F I=1:1 U IO R BHLT:DTIME D  Q:BHLT=""
 .. S CNTR=1
 .. Q:BHLT=""
 .. F J=1:1 D  Q:$P($G(BHLT),$C(10),J)=""
 ... Q:$P($G(BHLT),$C(10),J)=""
 ... I $E($P($G(BHLT),$C(10),J),1,3)="MSH",CNTR>1 D STUFF K ^TMP("BHLRL",$J) S CNTR=1
 ... S ^TMP("BHLRL",$J,CNTR)=$P($G(BHLT),$C(10),J)
 ... S CNTR=CNTR+1
 .. S BHLLMSG=$$LOG(BHLFNM,"R",DUZ)
 .. D STUFF
 .. D ^%ZISC
 .. K ^TMP("BHLRL",$J)
 Q
 ;
STUFF ;-- stuff the information into ^INTHU
 D NOW^%DTC S BHLDTM=$G(%)
 S BHLH=$H
 S BHLDEST=$O(^INRHD("B","HL IHS CHR R01 IN",0))
 S BHLSTAT="N"
 S BHLIO="I"
 S BHLPRIO=1
 K DD,DO
 S DIC="^INTHU(",DIC(0)="L",X=BHLDTM
 S DIC("DR")=".02////"_BHLDEST_";.03////"_BHLSTAT_";.1////"_BHLIO
 S DIC("DR")=DIC("DR")_";.16///"_BHLPRIO
 D FILE^DICN
 S BHLUIF=+Y
 S BHLLSMSG=$$LOGM(BHLFNM,BHLUIF)
 S BHLDA=0 F  S BHLDA=$O(^TMP("BHLRL",$J,BHLDA)) Q:'BHLDA  D
 . M ^INTHU(BHLUIF,3,BHLDA,0)=^TMP("BHLRL",$J,BHLDA)
 . S ^INTHU(BHLUIF,3,BHLDA,0)=^INTHU(BHLUIF,3,BHLDA,0)_"|CR|"
 ;TODO call the filer here and pass in UIF
 S ^INLHSCH(BHLPRIO,BHLH,BHLUIF)=""
 ;S ^INLHDEST(BHLDEST,0,$H,BHLUIF)=""
 Q
 ;
REDO(BHLRLI) ;EP - redo the import
 ;cmi/maw we need to set up dynamic directory reads here
 N BHLFLG,BHLDIR,BHLFST,BHLFLST,BHLLST
 S BHLCHR=$O(^BCHSITE("B",BHLCHRI,0))
 I $G(BHLCHR)="" S BHLFLG=1
 I $G(BHLCHR)]"" D
 . S BHLDIR=$P($G(^BCHSITE(BHLCHR,0)),U,13)
 . I BHLDIR="" S BHLFLG=1 Q
 . S BHLFST=$P($G(^BCHSITE(BHLCHR,0)),U,14)
 . I BHLFST="" S BHLFLG=1 Q
 I $G(BHLFLG) D  Q
 . Q:$D(ZTQUEUED)
 . W !,"CHR Parameters not Defined in BCH SITE PARAMETER File"
 S BHLFST=BHLFST_"*"
 S BHLFLST=$$LIST(BHLDIR,BHLFST)
 I BHLFLST<1 W !,"No Files in the directory, goodbye" Q
 S BHLLSDA=0 F  S BHLLSDA=$O(BHLLST(BHLLSDA)) Q:'BHLLSDA  D
 . W !,BHLLSDA_" - "_$G(BHLLST(BHLLSDA))
 S DIR(0)="L^1:"_BHLFLST,DIR("A")="Reimport which file(s) "
 D ^DIR
 Q:$D(DIRUT)
 S BHLFNMI=Y
 F BHLI=1:1:(BHLFLST+1)  S BHLFLI=$P(BHLFNMI,",",BHLI) Q:BHLFLI=""  D
 . S BHLFNM=$G(BHLLST(BHLFLI))
 . S BHLFILES(BHLFLI)=BHLFNM
 . I '$D(ZTQUEUED) D
 .. W !!,"Now reading in CHR file "_BHLFNM_" from directory "_BHLSDIR
 K BHLLST
 D CR(.BHLFILES,1),EOJ Q
 ;D CRLF(.BHLFILES,1),EOJ
 Q
 ;
MOVE(DIR,FN,OPS,SDIR) ;-- move files to storage directory
 S BHLMVMSG=$$MV^%ZISH(DIR,FN,SDIR,FN)  ;maw new 4/16/03
 ;cmi/maw original code below
 ;I '$G(OPS) S OPS=1
 ;I OPS=1 D  Q
 ;S X=$$TERMINAL^%HOSTCMD("mv "_DIR_FN_" "_SDIR)
 ;S X=$ZOS(3,DIR_FN,SDIR_FN)
 Q
 ;
LIST(DIR,LST) ;-- get a list of files in the directory
 S Y=$$LIST^%ZISH(DIR,LST,.BHLLST)
 Q $O(BHLLST(""),-1)
 ;
EOJ ;-- kill variables and quit
 D EN^XBVK("BHL")
 K ^BHLRL($J)
 Q
 ;
LOG(FNM,TYP,USER)  ;EP - log the entry
 I $O(^BCHLOG("B",FNM,0)) D  Q BHLLGI
 . S BHLLGI=$O(^BCHLOG("B",FNM,0))
 . S DIE="^BCHLOG(",DA=BHLLGI,DR=".03////"_$$NOW_";.04////"_USER
 . D ^DIE
 . K DIE
 . Q
 K DD,DO,DIC
 S DIC="^BCHLOG(",DIC(0)="L"
 S DIC("DR")=".02////"_$$NOW_";.04////"_USER
 S X=FNM
 D FILE^DICN
 K DIC
 Q +Y
 ;
LOGM(FNM,ENT)       ;-- log the entry in the universal interface file
 S BHLLGI=$O(^BCHLOG("B",FNM,0))
 I 'BHLLGI Q ""
 I $G(ENT),'$O(ENT("")) D  Q BHLLLGI
 . K DD,DO,DIC
 . S DA(1)=BHLLGI
 . S DIC="^BCHLOG("_DA(1)_",1,",X=$G(ENT),DIC(0)="L"
 . S DIC("P")=$P(^DD(90002.99,1,0),U,2)  ;TODO fix with correct fnumber
 . D FILE^DICN
 . S BHLLLGI=+Y
 S BHLLDA=0 F  S BHLLDA=$O(ENT(BHLLDA)) Q:'BHLLDA  D
 . K DD,DO,DIC
 . S DA(1)=BHLLGI
 . S DIC="^BCHLOG("_DA(1)_",1,",X=BHLLDA,DIC(0)="L"
 . S DIC("P")=$P(^DD(90002.99,1,0),U,2)  ;TODO fix with correct fnumber
 . D FILE^DICN
 . S BHLLLGI=+Y
 Q $G(BHLLLGI)
 ;
NOW() ;-- get now
 D NOW^%DTC
 Q %
 ;
SITE ;EP - setup the site parameters in BHL HL7 PARAMETER file
 N BHLRL
 W !,"Now setting up CHR HL7 lab parameters.."
 S DIC="^BCHSITE(",DIC(0)="AEMQZ"
 S DIC("A")="Setup Parameters for which Site: "
 D ^DIC
 S BHLRL=+Y
 Q:'BHLRL
 S DIE=DIC,DA=BHLRL,DR=".13:.14"
 D ^DIE
 K DIE,DR,DIC,DA
 S BHLMSG=$O(^INTHL7M("B","HL IHS CHR R01 IN",0))
 Q:'BHLMSG
 W !!,"Now activating CHR Interface.."
 D COMPILE^BHLU(BHLMSG)
 Q
 ;
