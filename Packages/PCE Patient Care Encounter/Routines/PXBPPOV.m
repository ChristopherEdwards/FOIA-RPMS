PXBPPOV ;ISL/JVS - PROMPT POV ; 5/1/01 2:58pm
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**11,28,92**;Aug 12, 1996
 ;
 ; VARIABLE LIST
 ; SELINE= Line number of selected item
 ;
POV ;--DIAGNOSIS
 I $D(PXBNPOVL) D LOC^PXBCC(2,0) W IOUON,"Previous Entry:   ",$G(PXBNPOVL(1)) F I=1:1:10 W " "
 W IOUOFF
 N TIMED,EDATA,DIC,LINE,XFLAG,SELINE,PXBEDIS,FPL
 I '$D(^DISV(DUZ,"PXBPOV-3")) S ^DISV(DUZ,"PXBPOV-3")="   "
 I '$D(IOSC) D TERM^PXBCC
 S DOUBLEQQ=0
 S TIMED="I '$T!(DATA=""^"")"
 S DIC("S")="I $P($G(^ICD9(Y,0)),""^"",9)'=1!($P(^(0),""^"",11)'=""""&(IDATE<($P(^(0),""^"",11))))"
P ;--Second Entry point
 W IOSC K FPL
 ;---DYNAMIC HEADER---
 I '$D(CYCL) D
 .I PXBCNT=0,DOUBLEQQ=0 D LOC^PXBCC(1,10) W "...There are "_$G(PXBCNT)_" ICD CODES associated with this encounter."
 .I PXBCNT=1,DOUBLEQQ=0 D LOC^PXBCC(1,10) W "...There is "_$G(PXBCNT)_" ICD CODE associated with this encounter."
 .I PXBCNT>1,DOUBLEQQ=0 D LOC^PXBCC(1,10) W "...There are "_$G(PXBCNT)_" ICD CODES associated with this encounter."
 ;
 D LOC^PXBCC(15,0)
 I PXBCNT>10&('$G(DOUBLEQQ)) W !,"Enter '+' for next page, '-' for previous page."
 I '$D(^TMP("PXK",$J,"POV")) W !,"Enter Diagnosis : "_$G(PXBDPOV) W:$D(PXBDPOV) " //" W IOELEOL
 I $D(^TMP("PXK",$J,"POV")) W !,"Enter ",IOINHI,"NEXT",IOINLOW," Diagnosis : "_$G(PXBDPOV) W:$D(PXBDPOV) " //" W IOELEOL
 R DATA:DTIME S EDATA=DATA
P1 ;--Third entry point
 X TIMED I  S PXBUT=1,LEAVE=1,DATA="^" G POVX
 I DATA?1.N1"E".NAP S DATA=" "_DATA
 I DATA?24.N S (DATA,EDATA)=$E(DATA,1,24)
 I $L(DATA)>200 S (DATA,EDATA)=$E(DATA,1,199)
 D CASE^PXBUTL
 ;----SPACE BAR---
 I DATA=" ",$D(^DISV(DUZ,"PXBPOV-3")) S DATA=^DISV(DUZ,"PXBPOV-3") W DATA
 ;-----------------
 I DATA="^^" S PXBEXIT=0 G POVX
 ;---I Prompt can jump to others put symbols in here
 I DATA["^P" G POVX
 ;------PXBDPOV=DEFAULT POV---
 I DATA="",$D(PXBDPOV) S DATA=$P($G(PXBDPOV),"--",1)
 I DATA="",'$D(PXBDPOV) S PXBUT=1,PXBSPL="",LEAVE=1 G POVX
 ;
 I PXBCNT>10&((DATA="+")!(DATA="-")) D DPOV4^PXBDPOV(DATA) G P
 ;
M ;--------IF Multiple entries have been entered
 D ADDM^PXBPPOV1
 I $G(NF) G P1
 ;
 ;--------IF Multiple deleting of entries
 D DELM^PXBPPOV1
 I $G(NF) G P1
 ;
LI ;--------If picked a line number
 I (DATA>0)&(DATA<(PXBCNT+1))&($L(DATA)'>$L(PXBCNT)) S XFLAG=1 D REVPOV^PXBCC(DATA) S SELINE=DATA D
 .F I=1:1:$L(DATA) W IOCUB,IOECH
 .S PRISEC=$P($G(PXBSAM(DATA)),"^",4) S:PRISEC["PRI" FPRI=0
 .S DATA=$P($G(PXBSAM(DATA)),"^",1)
 I $D(XFLAG),XFLAG=1 S (Y,EDATA)=DATA G PFIN
LI1 ;
 ;--------If POV is already in the file
 I '$G(DOUBLEQQ),$D(PXBKY(DATA)) D
 .I PXBCNT>10 D DPOV4^PXBDPOV($O(PXBKY(DATA,0)))
 .K Q D TIMES^PXBUTL(DATA)
 .I Q=1 S LINE=$O(PXBKY(DATA,0)) S XFLAG=1 D REVPOV^PXBCC(LINE) S PRISEC=$P($G(PXBSAM(LINE)),"^",2) S:PRISEC["PRI" FPRI=0
 .I Q>1 S NLINE=0 F  S NLINE=$O(Q(NLINE)) Q:NLINE=""  D REVPOV^PXBCC(NLINE)
 I $D(Q),Q>1 D WHICH^PXBPWCH G LI
 I $D(XFLAG),XFLAG=1 S Y=DATA G PFIN
 ;
 ;--------Need to do a DIC lookup on data
 I DATA'="??" D:DATA="?" EN1^PXBHLP0("PXB","POV",1,"",1) G:DATA="^P" P1 I DATA="?" G P
 I DATA="??" S DOUBLEQQ=1 D EN1^PXBHLP0("PXB","POV","",1,2) S:$L(DATA,"^")>1 (Y,DATA,EDATA)=$P($P(DATA,"^",2),"--",1) G:Y>1 PFIN G:Y?1A1.NP PFIN I DATA<1 S DATA="^P" G P1
 ;
 ;--If a "?" is NOT entered during lookup
 S (VAL,Y)=$$DOUBLE1^PXBGPOV2(WHAT) I Y<1 S DATA="^P" G P1
 ;<-*92*-<  S (X,DATA,EDATA)=$P(VAL,"^",2),DIC=80,DIC(0)="MZ" D ^DIC
 S (DATA,EDATA)=$P(VAL,"^",2),X="`"_+$P(Y,"^",1) K Y S DIC=80,DIC(0)="MZ" D ^DIC  ;** PX*1.0*92    05/01/2001  make ^DIC selection "exact."
 ;
 ;--If Y is good and already in file...
 I '$G(DOUBLEQQ),$D(Y),$D(PXBKY($P(Y,"^",2))) D
 .S LINE=$O(PXBKY($P(Y,"^",2),0)) ;---D REVPOV^PXBCC(LINE)
 .S PRISEC=$P($G(PXBSAM(LINE)),"^",4) S:PRISEC["PRI" FPRI=0
 S POV=Y(0)
 ;
PFIN ;--Finish the DIAGNOSIS
 I $L(Y,"^")'>1 S X=Y,DIC=80,DIC(0)="IZM" D ^DIC
 I +Y<0 D HELP1^PXBUTL1("POV") G P
 S POV=Y(0)
 S PXBNPOV($P(POV,"^",1))=""
 S PXBNPOVL(1)=$P(POV,"^",1) S ^DISV(DUZ,"PXBPOV-3")=DATA
 I $D(PXBKY($P(Y(0),"^"))),$G(SELINE) S $P(REQI,"^",9)=$O(PXBSKY(SELINE,0))
 I $D(PXBKY($P(Y(0),"^"))),'$G(SELINE) S $P(REQI,"^",9)=$O(PXBSKY($O(PXBKY($P(Y(0),"^"),0)),0))
 I +Y>0 S PXBEDIS=$$EXTTEXT^PXUTL1(+Y,1,80,3)
 S $P(REQI,"^",5)=+Y,$P(REQI,"^",6)="S"
 S $P(REQE,"^",5)=$P(POV,"^",1)_" --"_$G(PXBEDIS),$P(REQE,"^",6)="SECONDARY"
POVX ;--EXIT AND CLEAN UP
 I $G(WHAT)="INTV",DATA="^" S PXBEXIT="^^"
 I '$D(REQE) S REQE=""
 I $P(REQE,"^",5)="" S $P(REQE,"^",5)="...No Diagnosis Selected..."
 Q
