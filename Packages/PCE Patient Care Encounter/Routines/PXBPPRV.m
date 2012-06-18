PXBPPRV ;ISL/JVS,ESW - PROMPT PROVIDER ; 10/31/02 12:12pm
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**1,7,11,19,108**;Aug 12, 1996
 ;
 ; VARIABLE LIST
 ; SELINE= Line number of selected item
 ;
PRV ;--PROVIDER
 I $D(PXBNPRVL) W IOSC D LOC^PXBCC(2,0) W IOUON,"Previous Entry:   ",$G(PXBNPRVL(1)) F I=1:1:10 W " "
 I $D(PXBNPRVL) W IORC
 W IOUOFF
 N TIMED,EDATA,DIC,LINE,XFLAG,SELINE,UDATA,ECHO
 I '$D(^DISV(DUZ,"PXBPRV-4")) S ^DISV(DUZ,"PXBPRV-4")=" "
 I '$D(IOSC) D TERM^PXBCC
 S DOUBLEQQ=0
 S TIMED="I '$T!(DATA=""^"")"
P ;--Second Entry point
 W IOSC
 ;--DYNAMIC  HEADER--
 I '$D(CYCL) D
 .I PXBCNT=0,DOUBLEQQ=0,$G(WHAT)'["PRV" D LOC^PXBCC(1,10) W "...There are "_$G(PXBCNT)_" PROVIDER(S) associated with this encounter."
 .I PXBCNT=1,DOUBLEQQ=0,$G(WHAT)'["PRV" D LOC^PXBCC(1,10) W "...There is "_$G(PXBCNT)_" PROVIDER associated with this encounter."
 .I PXBCNT>1,DOUBLEQQ=0,$G(WHAT)'["PRV" D LOC^PXBCC(1,10) W "...There are "_$G(PXBCNT)_" PROVIDERS associated with this encounter."
 ;
 I $G(FROM)'="PL" D LOC^PXBCC(15,0)
 I $G(FROM)'["PRV" N PXBNPRVL
 I $D(FROM),FROM="PL" W IORC
 I $G(FROM)'="PL",PXBCNT>10&('$G(DOUBLEQQ)) W IOELEOL,!,"Enter '+' for next page, '-' for previous page."
 ;--Dynamic prompting for the provider--
 I '$D(^TMP("PXK",$J,"PRV")),'$D(FROM) W !,"Enter PROVIDER: " W IOELEOL
 I '$D(FROM),$D(^TMP("PXK",$J,"PRV")) W !,"Enter ",IOINHI,"NEXT",IOINLOW," PROVIDER: " W IOELEOL
 I $D(FROM),FROM="CPT",'$D(^TMP("PXK",$J,"PRV")) W IORC,!,"Enter PROVIDER associated with PROCEDURE: " W IOELEOL
 I $D(FROM),FROM="PRV" W !,"Enter PROVIDER: " W IOELEOL
 I $D(FROM),FROM="CPT",$D(^TMP("PXK",$J,"PRV")) W IORC,!,"Enter PROVIDER associated with PROCEDURES: " W IOELEOL
 I $D(FROM),FROM="PL"  W !,"Enter PROVIDER associated with PROBLEM: " W IOELEOL
 I $D(FROM),FROM="PL" S PXBDPRV="^"_$P($G(PRVDR("PRIMARY")),U) ;108
 I $D(PRVDR) S PXBDPRV="^"_$P(PRVDR("PRIMARY"),U) ;108
 I $D(FROM),FROM="CPT",$P(REQI,"^",1),$P(REQE,"^",1)'["..." S $P(PXBDPRV,"^",2)=$P(REQE,"^",1)
 W $P($G(PXBDPRV),"^",2) W:$D(PXBDPRV) " // ",IOELEOL
 ;
 R DATA:DTIME S (EDATA,ECHO)=DATA
P1 ;--Third entry point
 X TIMED I  S PXBUT=1 S:DATA="^" LEAVE=1 G PRVX
 I DATA?1.N1"E".NAP S DATA=" "_DATA
 I $L(DATA)>200 S (DATA,EDATA)=$E(DATA,1,199)
 I DATA?24.N S (DATA,EDATA)=$E(DATA,1,24)
 D CASE^PXBUTL
 ;---SPACE BAR
 I DATA=" ",$D(^DISV(DUZ,"PXBPRV-4")) S (DATA,EDATA)=^DISV(DUZ,"PXBPRV-4") W DATA
 ;-----------
 I DATA="^^" S PXBEXIT=0 G PRVX
 ;---I Prompt can jump to others put symbols in here
 I DATA["^P" G PRVX
 I DATA["^I" G PRVX
 ;
 I DATA="",$D(PXBDPRV) S DATA=$P($G(PXBDPRV),"^",2) I DATA="" S PXBUT=1 G PRVX
 I DATA="",'$D(PXBDPRV) S PXBUT=1 G PRVX
 ;
 I PXBCNT>10&((DATA="+")!(DATA="-")) D DPRV4^PXBDPRV(DATA) W IORC D WIN17^PXBCC(PXBCNT) G P
 ;
M ;--IF Multiple entries have been entered
 ;--CAN'T DO!!!!
 ;--IF Multiple deleting of entries
 D DELM^PXBPPRV1
 I $G(NF) G P1
 ;
LI ;--If picked a line number
 I (DATA>0)&(DATA<(PXBCNT+1))&($L(DATA)'>$L(PXBCNT)) S XFLAG=1 D REVPRV^PXBCC(DATA) S SELINE=DATA D
 .I $G(FROM)["PL" Q
 .I $G(FROM)["CPT"  K SELINE S DATA="NOT VALID" Q
 .F I=1:1:$L(DATA) W IOCUB,IOECH
 .S PRISEC=$P($G(PXBSAM(DATA)),"^",2) S:PRISEC["PRI" FPRI=0
 .S DATA=$P($G(PXBSAM(DATA)),"^",1)
 I $D(XFLAG),XFLAG=1 S Y=DATA G PFIN
 ;
 ;--If PRV is already in the file
 I DATA="" S PXBUT=1 G PRVX
 I '$G(DOUBLEQQ),$D(PXBKY(DATA)) D
 .I PXBCNT>10 D DPRV4^PXBDPRV($O(PXBKY(DATA,0)))
 .K Q D TIMES^PXBUTL(DATA)
 .I Q=1 S LINE=$O(PXBKY(DATA,0)) S XFLAG=1 D:$G(FROM)'="PL" REVPRV^PXBCC(LINE) S PRISEC=$P($G(PXBSAM(LINE)),"^",2) I $P(PXBSAM(LINE),"^",2)["PRI" S FPRI=0
 .I Q>1 S NLINE=0 F  S NLINE=$O(Q(NLINE)) Q:NLINE=""  D REVPRV^PXBCC(NLINE)
 I $D(Q),Q>1 D WHICH^PXBPWCH G LI
 I $D(XFLAG),XFLAG=1 S Y=DATA G PFIN
 ;--Need to do a DIC lookup on data
 ;
 K FIRST
 I DATA'="??" D:DATA="?" EN1^PXBHLP0("PXB","PRV",1,"",1) G:DATA="^P" P I DATA="?" G P
 I DATA="??" S DOUBLEQQ=1 D EN1^PXBHLP0("PXB","PRV","",1,2) S:DATA="P" UDATA="^P" S:$L(DATA,"^")>1 (Y,DATA,EDATA)=$P(DATA,"^",2) S:$G(UDATA)="" UDATA="^P" S:UDATA="^P" (DATA,EDATA,Y)=UDATA G:UDATA="^P" P1 G PFIN
 ;
 ;--If a "?" is NOT entered during lookup
 S FROM="PRV",(VAL,Y)=$$DOUBLE1^PXBGPRV2(FROM) I Y<1 S DATA="^P",DOUBLEQQ=1 G P1
 ;S (X,DATA,EDATA)=$P(VAL,"^",2),DIC="^VA(200,",DIC(0)="MZ" D ^DIC
 S X="`"_+Y,(DATA,EDATA)=$P(VAL,"^",2),DIC="^VA(200,",DIC(0)="MZ" D ^DIC
 I Y=-1 S PXBUT=1 G PRVX
 ;
 ;--If Y is good and already in file...
 ;I '$G(DOUBLEQQ),$D(Y),$D(PXBKY($P(Y,"^",2))) D
 I '$G(DOUBLEQQ),($P($G(Y),"^",2)]""),$D(PXBKY($P(Y,"^",2))) D
 .S LINE=$O(PXBKY($P(Y,"^",2),0))
 .S PRISEC=$P($G(PXBSAM(LINE)),"^",2) S:PRISEC["PRI" FPRI=0
 S PRV=Y(0)
 ;
PFIN ;--Finish the Provider
 I $L(Y,"^")'>1,$G(SELINE) S X="`"_$P(^AUPNVPRV($O(PXBSKY(SELINE,0)),0),"^",1),DIC="^VA(200,",DIC(0)="MZ" D ^DIC
 I $L(Y,"^")'>1,'$G(SELINE) S X=Y,DIC="^VA(200,",DIC(0)="MZ" D ^DIC
 I +Y<0 D HELP^PXBUTL0("PRVM") W IOCUU G P
 S PRV=Y(0)
 S PXBNPRV($P(PRV,"^",1))=""
 S PXBNPRVL(1)=$P(PRV,"^",1) S ^DISV(DUZ,"PXBPRV-4")=$P(PRV,"^",1)
 I $D(PXBKY($P(Y(0),"^"))),$G(SELINE) S $P(REQI,"^",7)=$O(PXBSKY(SELINE,0)),$P(REQI,"^",2)=$P($G(PXBSAM(SELINE)),"^",2)
 I $D(PXBKY($P(Y(0),"^"))),'$G(SELINE) S $P(REQI,"^",7)=$O(PXBSKY($O(PXBKY($P(Y(0),"^"),0)),0)) S PAT=$P(Y(0),"^",1),ITEM=$O(PXBKY(PAT,0)),$P(REQI,"^",2)=$E($P($G(PXBKY(PAT,ITEM)),"^",2),1),$P(REQE,"^",2)=$P($G(PXBKY(PAT,ITEM)),"^",2)
 S $P(REQI,"^",1)=+Y
 I $P(REQI,"^",2)']"" S $P(REQI,"^",2)="S",$P(REQE,"^",2)="SECONDARY"
 S $P(REQE,"^",1)=$P(PRV,"^",1)
 I '$D(REQI) S REQI=""
 ;---IF INACTIVE ISSUE A WARNING
 I DATA]"" D ACTIVE^PXBPPRV1
PRVX ;--EXIT AND CLEAN UP
 I $G(WHAT)="INTV",DATA="^" S PXBEXIT="^^"
 I '$D(REQI) S REQI=""
 I '$D(REQE) S REQE=""
 I $P(REQE,"^",1)="" S $P(REQE,"^",1)="...No Provider Selected..."
 I FROM="PRV",$L(EDATA)<40 D
 .F I=1:1:$L(ECHO) W IOCUB,IOELEOL
 .F I=1:1:$L(ECHO) W IOCUF
 .I $P(REQE,"^",1)'["...No" W $P(REQE,"^",1)
 Q
