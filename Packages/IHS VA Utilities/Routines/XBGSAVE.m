XBGSAVE ; IHS/ADC/GTH - GENERIC GLOBAL SAVE FOR TRANSMISSION GLOBALS ; [ 07/21/2005  4:13 PM ]
 ;;3.0;IHS/VA UTILITIES;**9,10,11**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; XBGL = name of global (mandatory, all others optional)
 ;
 ; XBCON= if defined, stops if first-level subscript is non-cannonic
 ; XBDT = date of save, in FM format, default NOW
 ; XBE  = ending first-level numeric subscript
 ; XBFLT= 1, saves as flat file
 ; XBFN = output file name, default "<ns><asufac>.<JulianDate>"
 ; XBF  = beginning first-level numeric subscript, seed for $ORDER
 ; XBIO = output device number
 ; XBMED= media to which to save global (user asked, if not exist)
 ; XBNAR= description displayed to user, if user asks for help
 ; XBPAR= CR parameter (DSM only)
 ; XBQ  = Y/N, to place file in uucp q, default "Y"
 ; XBQTO= 'sendto' destination, default AO sysid in RPMS SITE file
 ; XBTLE= comment for dump header (facility name is concatenated)
 ; XBUF = directory, default no longer provided - will kick out error
 ;        if XBUF undefined and no directory found in files
 ;        9999999.39 or 8989.3
 ; XBS1 = zish send paramaters file entry
 ;
SETUP ;
 I '$D(^%ZOSF("OS")) S XBFLG(1)="The ^%ZOSF(""OS"") node does not exist",XBFLG=-1 G EOJ
 ; I '(^%ZOSF("OS")["MSM"),'(^%ZOSF("OS")["DSM") S XBFLG(1)="Operating system is not 'MSM' or 'DSM'",XBFLG=-1 G EOJ ; IHS/SET/GTH XB*3*9 10/29/2002
 I '(^%ZOSF("OS")["MSM"),'(^%ZOSF("OS")["OpenM") S XBFLG(1)="Operating system is not 'MSM' or 'Cache'",XBFLG=-1 G EOJ ; IHS/SET/GTH XB*3*9 10/29/2002
 I '$G(DUZ(2)) S XBFLG(1)="Facility Number 'DUZ(2)' is not defined",XBFLG=-1 G EOJ
 I '$D(XBGL) S XBFLG(1)="The variable 'XBGL' must contain the name of the global you wish to save." S XBFLG=-1 G EOJ
 KILL XBFLG,XBGLL
 S:'$D(DTIME) DTIME=300
CHECK ;
 S X=XBGL
 I $L(X,"(")>1,$P(X,"(",2)="" S X=$P(X,"(")
 S:$E(X,$L(X))="," X=$E(X,1,($L(X)-1))
 I $L(XBGL,"(")>1,$E(XBGL,$L(XBGL))'="," S XBGL=XBGL_","
 I $L(X,"(")>1,$E(X,$L(X))'=")" S X=X_")"
 S:$L(X,"(")=1 XBGL=X_"("
 S XBGLL=U_X
CKGLOB ;
 I '$D(@XBGLL) S XBFLG(1)="Transaction File does not exist",XBFLG=-1 G EOJ
 ;S:'$D(XBUF) XBUF="/usr/spool/uucppublic"
 I $G(XBUF)="" S XBUF=$P($G(^AUTTSITE(1,1)),"^",2)
 I XBUF="" S XBUF=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 I XBUF="" D  G EOJ
 .S XBFLG(1)="Export Directory NOT Specified"
 .S XBFLG=-1
 I "/\"[$E(XBUF,$L(XBUF)) D
 .S XBUF=$E(XBUF,1,($L(XBUF)-1))
 I '$D(DT) D DT^DICRW
 S X2=$E(DT,1,3)_"0101",X1=DT
 D ^%DTC
 S XBCARTNO=X+1,XBDT=$S($D(XBDT):$$FMTE^XLFDT(XBDT),1:$$HTE^XLFDT($H))
 S:$E(XBGL)'=U XBGL=U_XBGL
 S XBNAR=$G(XBNAR),XBTLE=$G(XBTLE)_" "_$P(^DIC(4,DUZ(2),0),U)
 I $D(XBMED) S XBMED=$$UP^XLFSTR($E(XBMED))
 S XBQ=$E($G(XBQ)_"Y")
 I XBQ="Y" S XBQTO=$G(XBQTO) I XBQTO="" S XBQTO=$P(^AUTTSITE(1,0),U,14) I XBQTO="" S XBQ="N"
 S XBF=$G(XBF),XBE=$G(XBE)
 I XBF="" S XBF=""""""
 I ^%ZOSF("OS")["DSM" G SETUPDSM
SETUPMSM ;
 S:'$D(XBIO) XBIO=51
 I $D(XBMED),'("CDFT"[XBMED) S XBFLG(1)="Media Type '"_XBMED_"' is incorrect",XBFLG=-1 G EOJ
 D ^ZIBGSVEM
 I $G(XBS1)'="" D
 .S XBFLG=$$SENDTO1^ZISHMSMU(XBS1,XBPAFN)
 .S XBFLG(1)=$P(XBFLG,"^",2)
 .S XBFLG=+XBFLG
 .Q:$D(ZTQUEUED)
 .W:XBFLG=0 !!,"File was sent successfully"
 .W:'(XBFLG=0) !!,"File was **NOT** sent successfully"
 G EOJ
 ;
SETUPDSM ;
 I '$D(XBIO) S XBIO=47
 I $D(XBMED),'("CT"[XBMED) S XBFLG(1)="Media Type '"_XBMED_"' is incorrect",XBFLG=-1 G EOJ
 D ^ZIBGSVED
EOJ ;
 S:'$D(XBFLG) XBFLG=0
 KILL %DT,X,XBCON,XBFN,XBGL,XBGLL,XBCARTNO,X1,X2,XBNAR,XBTLE,XBIO,XBPAR,XBDT,XBE,XBF,XBMED,XBUF,XBQ,XBQTO,XBFLT,XBSUFAC,Y
 Q
 ;
