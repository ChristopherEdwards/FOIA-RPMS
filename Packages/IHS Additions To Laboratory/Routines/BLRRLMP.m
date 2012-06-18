BLRRLMP ; cmi/anch/maw - BLR Read Reference Lab into ^INTHU ;
 ;;5.2;LR;**1021**;Jul 27, 2006
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;
 ;this routine will grab a file from UNIX and stuff it into the ^INTHU
 ;global for processing
 ;
MAIN ;-- this is the main routine driver
 D ^%ZISC
 K ^TMP("BLRRL",$J)
 S BLRY=$$CHK^BHLBCK("OUTPUT CONTROLLER")
 D READ(DUZ(2))
 D EOJ
 Q
 ;
READ(BLRRLI) ;-- read the file in
 ;cmi/maw we need to set up dynamic directory reads here
 S BLRRL=$P($G(^BLRSITE(BLRRLI,"RL")),U)
 I $G(BLRRL)="" D  Q
 . Q:$D(ZTQUEUED)
 . W !,"Reference Lab not defined in BLR MASTER CONTROL File"
 S BLRRLNM=$P($G(^BLRRL(BLRRL,0)),U)
 S BLRDIR=$P($G(^BLRRL(BLRRL,0)),U,16)
 S BLRSDIR=$P($G(^BLRRL(BLRRL,0)),U,9)
 S BLROPS=$P($G(^AUTTSITE(1,0)),U,21)
 S BLRFST=$P($G(^BLRRL(BLRRL,0)),U,7)_"*"
 I '$D(ZTQUEUED) D
 . W !!,"Now reading in reference lab file from directory "_BLRDIR
 S BLRFLST=$$LIST^%ZISH(BLRDIR,BLRFST,.BLRLST)
 I $G(BLRRLNM)="LABCORP" D LC(.BLRLST,"") Q
 I $G(BLRRLNM)="UNILAB" D LC(.BLRLST,"") Q
 I $P($G(^BLRRL(BLRRL,0)),U,8) D CR(.BLRLST,"") Q
 D CRLF(.BLRLST,"")
 Q
 ;
LC(BLRLST,RFLG) ;-- parse specifically for labcorp
 S BLRFDA=0 F  S BLRFDA=$O(BLRLST(BLRFDA)) Q:'BLRFDA  D
 . D ^%ZISC
 . S BLRFNM=$G(BLRLST(BLRFDA))
 . Q:BLRFNM["ord"  ;testing
 . S Y=$$OPEN^%ZISH(BLRDIR,BLRFNM,"R")
 . I $G(Y),'$D(ZTQUEUED) W !,"Error Opening Device" Q
 . S CNTR=1
 . F I=1:1 U IO R BLRT:DTIME D  Q:BLRT=""
 .. Q:BLRT=""
 .. I $E($G(BLRT),1,3)="MSH",CNTR>1 D STUFF K ^TMP("BLRRL",$J) S CNTR=1
 .. S ^TMP("BLRRL",$J,CNTR)=$G(BLRT)
 .. S CNTR=CNTR+1
 . S BLRLMSG=$$LOG^BLRRLU(BLRFNM,"R",DUZ)
 . D STUFF
 . D ^%ZISC
 . I '$G(RFLG) D
 .. W:'$D(ZTQUEUED) !,"Now backing up read in file",!
 .. D MOVE(BLRDIR,BLRFNM,BLROPS,BLRSDIR)
 . K ^TMP("BLRRL",$J)
 Q
 ;
CRLF(BLRLST,RFLG) ;-- parse by carriage return line feed
 S BLRFDA=0 F  S BLRFDA=$O(BLRLST(BLRFDA)) Q:'BLRFDA  D
 . D ^%ZISC
 . S BLRFNM=$G(BLRLST(BLRFDA))
 . Q:BLRFNM["ord"  ;testing
 . S Y=$$OPEN^%ZISH(BLRDIR,BLRFNM,"R")
 . I $G(Y),'$D(ZTQUEUED) W !,"Error Opening Device" Q
 . S CNTR=1
 . F I=1:1 U IO R BLRT:DTIME D  Q:BLRT=""
 .. Q:BLRT=""
 .. S ^TMP("BLRRL",$J,CNTR)=$G(BLRT)
 .. S CNTR=CNTR+1
 . S BLRLMSG=$$LOG^BLRRLU(BLRFNM,"R",DUZ)
 . D STUFF
 . D ^%ZISC
 . I '$G(RFLG) D
 .. W:'$D(ZTQUEUED) !,"Now backing up read in file",!
 .. D MOVE(BLRDIR,BLRFNM,BLROPS,BLRSDIR)
 . K ^TMP("BLRRL",$J)
 Q
 ;
CR(BLRLST,RFLG) ;-- parse message by CR only
 S BLRFDA=0 F  S BLRFDA=$O(BLRLST(BLRFDA)) Q:'BLRFDA  D
 . D ^%ZISC
 . S BLRFNM=$G(BLRLST(BLRFDA))
 . Q:BLRFNM["ord"  ;testing
 . S Y=$$OPEN^%ZISH(BLRDIR,BLRFNM,"R")
 . I $G(Y),'$D(ZTQUEUED) W !,"Error Opening Device" Q
 . F I=1:1 U IO R BLRT:DTIME D  Q:BLRT=""
 .. S CNTR=1
 .. Q:BLRT=""
 .. F J=1:1 D  Q:$P($G(BLRT),$C(10),J)=""
 ... Q:$P($G(BLRT),$C(10),J)=""
 ... I $E($P($G(BLRT),$C(10),J),1,3)="MSH",CNTR>1 D STUFF K ^TMP("BLRRL",$J) S CNTR=1
 ... S ^TMP("BLRRL",$J,CNTR)=$P($G(BLRT),$C(10),J)
 ... S CNTR=CNTR+1
 .. S BLRLMSG=$$LOG^BLRRLU(BLRFNM,"R",DUZ)
 .. D STUFF
 .. D ^%ZISC
 .. I '$G(RFLG) D
 ... W:'$D(ZTQUEUED) !,"Now backing up read in file",!
 ... D MOVE(BLRDIR,BLRFNM,BLROPS,BLRSDIR)
 .. K ^TMP("BLRRL",$J)
 Q
 ;
STUFF ;-- stuff the information into ^INTHU
 D NOW^%DTC S BLRDTM=$G(%)
 S BLRH=$H
 S BLRDEST=$O(^INRHD("B","HL IHS LAB R01 "_BLRRLNM_" IN",0))
 S BLRSTAT="N"
 S BLRIO="I"
 S BLRPRIO=1
 K DD,DO
 S DIC="^INTHU(",DIC(0)="L",X=BLRDTM
 S DIC("DR")=".02////"_BLRDEST_";.03////"_BLRSTAT_";.1////"_BLRIO
 S DIC("DR")=DIC("DR")_";.16///"_BLRPRIO
 D FILE^DICN
 S BLRUIF=+Y
 S BLRLSMSG=$$LOGM^BLRRLU(BLRFNM,BLRUIF)
 S BLRDA=0 F  S BLRDA=$O(^TMP("BLRRL",$J,BLRDA)) Q:'BLRDA  D
 . M ^INTHU(BLRUIF,3,BLRDA,0)=^TMP("BLRRL",$J,BLRDA)
 . S ^INTHU(BLRUIF,3,BLRDA,0)=^INTHU(BLRUIF,3,BLRDA,0)_"|CR|"
 S ^INLHSCH(BLRPRIO,BLRH,BLRUIF)=""
 ;S ^INLHDEST(BLRDEST,0,$H,BLRUIF)=""
 Q
 ;
REDO(BLRRLI) ; EP -- redo the import
 ;cmi/maw we need to set up dynamic directory reads here
 S BLRRL=$P($G(^BLRSITE(BLRRLI,"RL")),U)
 I $G(BLRRL)="" D  Q
 . Q:$D(ZTQUEUED)
 . W !,"Reference Lab not defined in BLR MASTER CONTROL File"
 S BLRRLNM=$P($G(^BLRRL(BLRRL,0)),U)
 S BLRDIR=$P($G(^BLRRL(BLRRL,0)),U,2)
 S BLRSDIR=$P($G(^BLRRL(BLRRL,0)),U,9)
 S BLROPS=$P($G(^AUTTSITE(1,0)),U,21)
 S BLRFST=$P($G(^BLRRL(BLRRL,0)),U,7)_"*"
 S BLRFLST=$$LIST(BLRSDIR,BLRFST)
 I BLRFLST<1 W !,"No Files in the directory, goodbye" Q
 S BLRLSDA=0 F  S BLRLSDA=$O(BLRLST(BLRLSDA)) Q:'BLRLSDA  D
 . W !,BLRLSDA_" - "_$G(BLRLST(BLRLSDA))
 S DIR(0)="L^1:"_BLRFLST,DIR("A")="Reimport which file(s) "
 D ^DIR
 Q:$D(DIRUT)
 S BLRFNMI=Y
 F BLRI=1:1:(BLRFLST+1)  S BLRFLI=$P(BLRFNMI,",",BLRI) Q:BLRFLI=""  D
 . S BLRFNM=$G(BLRLST(BLRFLI))
 . S BLRFILES(BLRFLI)=BLRFNM
 . I '$D(ZTQUEUED) D
 .. W !!,"Now reading in reference lab file "_BLRFNM_" from directory "_BLRSDIR
 K BLRLST
 I $P($G(^BLRRL(BLRRL,0)),U,8) D CR(.BLRFILES,1),EOJ Q
 D CRLF(.BLRFILES,1),EOJ
 Q
 ;
MOVE(DIR,FN,OPS,SDIR) ;-- move files to storage directory
 S BLRMVMSG=$$MV^%ZISH(DIR,FN,SDIR,FN)  ;maw new 4/16/03
 ;cmi/maw original code below
 ;I '$G(OPS) S OPS=1
 ;I OPS=1 D  Q
 ;S X=$$TERMINAL^%HOSTCMD("mv "_DIR_FN_" "_SDIR)
 ;S X=$ZOS(3,DIR_FN,SDIR_FN)
 Q
 ;
LIST(DIR,LST) ;-- get a list of files in the directory
 S Y=$$LIST^%ZISH(DIR,LST,.BLRLST)
 Q $O(BLRLST(""),-1)
 ;
EOJ ;-- kill variables and quit
 D EN^XBVK("BLR")
 K ^BLRRL($J)
 Q
 ;
