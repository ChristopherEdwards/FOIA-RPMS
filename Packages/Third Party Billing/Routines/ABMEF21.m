ABMEF21 ; IHS/ASDST/DMJ - Electronic 837 version 4010 Institutional ;      
 ;;2.6;IHS Third Party Billing System;**2,3,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM15585 - code to check if patient changes, not just subscriber
 ; IHS/SD/SDR -abm*2.6*2 - 5PMS100005 - function call to populate EXPORT NUMBER RE-EXPORT multiple
 ;
START ;
 ;START HERE
 S ABMPXMIT=ABMP("XMIT")
 I '$D(ABMP("INS")) D
 .S ABMP("INS")=$P(^ABMDTXST(DUZ(2),ABMPXMIT,0),"^",4)
 .I 'ABMP("INS") D
 ..S DIC="^AUTNINS("
 ..S DIC(0)="AEMQ"
 ..D ^DIC
 ..Q:Y<0
 ..S ABMP("INS")=+Y
 I 'ABMP("INS") D  Q
 .W !,"Insurer NOT identified.",!
 .D EOP^ABMDUTL(1)
 S ABMPINS=ABMP("INS")
 S ABMP("ITYPE")=$P($G(^AUTNINS(ABMP("INS"),2)),U)
 S ABMPITYP=ABMP("ITYPE")
 ;start old code abm*2.6*8
 ;D OPEN
 ;I $G(POP) W !,"File could not be created/opened.",! Q
 ;S DIE="^ABMDTXST(DUZ(2),"
 ;S DA=ABMPXMIT
 ;S DR=".14///"_ABMFN
 ;D ^DIE
 ;D LOOP
 ;I '$G(ABMSTOT) D
 ;.W !,"No Bills in Batch.",!
 ;I $G(ABMSTOT) D
 ;.D ^ABME8L11
 ;D END
 ;end old code start new code
 I ($G(ABMER("CNT"))=1) D  Q:$G(POP)
 .D OPEN
 .I $G(POP) W !,"File could not be created/opened.",! Q
 Q:$G(POP)  ;abm*2.6*8
 S DIE="^ABMDTXST(DUZ(2),"
 S DA=ABMPXMIT
 S DR=".14///"_ABMFN
 D ^DIE
 D LOOP
 I '$G(ABMSTOT) D
 .W !,"No Bills in Batch.",!
 I $G(ABMSTOT) D
 .D ^ABME5L11
 I (ABMER("CNT")=ABMER("LAST")) D END
 ;end new code
 Q
 ;
LOOP ;loop through bills
 K ABMR,ABMRT,ABMREC
 S ABMOSBR=0
 S ABMASBR=0
 S (ABMNPDFN,ABMOPDFN)=0
 F  S ABMASBR=$O(^ABMDTXST(DUZ(2),ABMPXMIT,2,"ASBR",ABMASBR)) Q:'ABMASBR  D
 .S ABMBILL=0
 .S ABMOPDFN=0
 .F  S ABMBILL=$O(^ABMDTXST(DUZ(2),ABMPXMIT,2,"ASBR",ABMASBR,ABMBILL)) Q:'ABMBILL  D
 ..D CLAIM
 Q
CLAIM ;one claim
 K ABMP
 S ABMP("INS")=ABMPINS
 S ABMP("ITYPE")=ABMPITYP
 S ABMP("BDFN")=ABMBILL
 Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))
 Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",4)="X"
 ;D BILLSTAT^ABMDREEX(DUZ(2),ABMP("BDFN"),ABMPXMIT,"O",$P($G(^ABMDTXST(DUZ(2),ABMPXMIT,1)),U,6))  ;abm*2.6*2 5PMS10005  ;abm*2.6*3 NOHEAT
 D BILLSTAT^ABMDREEX(DUZ(2),ABMP("BDFN"),ABMPXMIT,"O",ABMGCN)  ;abm*2.6*2 5PMS10005  ;abm*2.6*3 NOHEAT
 D SET^ABMUTLP(ABMP("BDFN"))
 I 'ABMOSBR D
 .;U 0 W !,"Submission # ",$P($G(^ABMDTXST(DUZ(2),ABMPXMIT,1)),"^",6)  ;abm*2.6*3 5PMS10005#2
 .U 0 W !,"Submission # ",$P($G(^ABMDTXST(DUZ(2),ABMPXMIT,3,$O(^ABMDTXST(DUZ(2),ABMPXMIT,3,"B",ABMXMTDT,0)),0)),"^",2)  ;abm*2.6*3 5PMS10005#2
 .U 0 W !,"Writing bills to file.",!
 .D ^ABME8L1
 .D ^ABME8L2
 S ABMNPDFN=$P(ABMB0,U,5)
 D SBR
 I ABMOSBR'=ABMASBR D
 .D SBR
 I ABMNPDFN'=ABMOPDFN D
 .D PTCHG^ABME8L3
 S ABMP("PNUM")=$$PNUM^ABMUTLP(ABMBILL)
 D ^ABME8L5
 D ^ABME8L6
 D ^ABME8L7
 D ^ABME8L8
 D ^ABME8L10
 W "."
 Q
SBR ;new subscriber
 S ABMSFILE=$P(ABMASBR,"-",1)
 S ABMSIEN=$P(ABMASBR,"-",2)
 S ABMCHILD=0
 N I
 S I=0
 F  S I=$O(^ABMDTXST(DUZ(2),ABMPXMIT,2,"ASBR",ABMASBR,I)) Q:'I  D
 .Q:+^ABMDTXST(DUZ(2),ABMPXMIT,2,"ASBR",ABMASBR,I)=18
 .Q:ABMBILL'=I
 .S ABMCHILD=1
 S ABMP("PNUM")=$$PNUM^ABMUTLP(ABMBILL)
 D ^ABME8L3
 S ABMOSBR=ABMASBR
 S ABMOPDFN=ABMP("PDFN")
 Q
END ;end of file
 D ^%ZISC
 W !!,"Finished.",!!
 K ABME,ABM,ABMEF,ABMREC,ABMR,ABMRV,ABMFN,ABMLF,ABMLNUM,ABMPATH,ABMHL
 Q
 ;
OPEN ;
 ; OPEN FILE
 ;start old code abm*2.6*8
 ;S DIR(0)="9002274.5,.47"
 ;S DIR("A")="Enter Path"
 ;S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 ;D ^DIR K DIR
 ;I Y["^" S POP=1 Q
 ;S ABMPATH=Y
 ;end old code start new code
 D ^XBFMK
 I ($G(ABMER("CNT"))=1) D
 .S DIR(0)="9002274.5,.47"
 .S DIR("A")="Enter Path"
 .S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 .D ^DIR K DIR
 .I $G(Y)["^" S POP=1 Q
 S ABMPATH=$S($G(Y)="":ABMPATH,1:Y)
 ;end new code
 S ABMRCID=$P(^AUTNINS(ABMP("INS"),0),"^",8)
 I $L(ABMRCID)<5 D
 .S ABMRCID=$E("00000",1,5-$L(ABMRCID))_ABMRCID
 S ABMJDT=$$JDT^XBFUNC(DT)
 S ABMLF=$G(^ABMNINS("ALF",ABMP("INS")))
 S:$P(ABMLF,".",2)'=ABMJDT ABMLF=""
 S ABMLNUM=+$E($P(ABMLF,".",1),7,8)
 S ABMLNUM=ABMLNUM+1
 I ABMLNUM<10 S ABMLNUM="0"_ABMLNUM
 S ABMFN="E"_ABMRCID_ABMLNUM_"."_ABMJDT
 ;start old code abm*2.6*8
 ;S DIR(0)="F",DIR("A")="Enter File Name: ",DIR("B")=ABMFN
 ;D ^DIR K DIR
 ;I Y["^" S POP=1 Q
 ;S ABMFN=Y
 ;S POP=0
 ;D OPEN^%ZISH("EMCFILE",ABMPATH,ABMFN,"W")
 ;end old code start new code
 S POP=0
 I ($G(ABMER("CNT"))=1) D
 .S DIR(0)="F",DIR("A")="Enter File Name: ",DIR("B")=ABMFN
 .D ^DIR K DIR
 .I Y["^" S POP=1 Q
 .S ABMFN=Y
 .D OPEN^%ZISH("EMCFILE",ABMPATH,ABMFN,"W")
 ;end new code
 S:'POP ^ABMNINS("ALF",ABMP("INS"))=ABMFN
 Q
SEND ;EP - send file
 S ABMFILE=ABMPATH_ABMFN
 U IO(0)
 W !,"Sending ",ABMFILE
 S ABMSND=$$SENDTO1^%ZISH(ABMSPAR,ABMFILE)
 I ABMSND W !,$P(ABMSND,"^",2)
 Q
