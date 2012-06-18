PSXRPPL ;BIR/WPB,BAB-Gathers data for the CMOP Transmission ;13 Mar 2002  10:31 AM
 ;;2.0;CMOP;**3,23,33,28,40,42,41**;11 Apr 97
 ; Reference to ^PS(52.5,  supported by DBIA #1978
 ; Reference to ^PSRX(     supported by DBIA #1977
 ; Reference to ^PSOHLSN1  supported by DBIA #2385
 ; Reference to ^PSORXL    supported by DBIA #1969
 ; Reference to ^PSOLSET   supported by DBIA #1973
 ; Reference to %ZIS(1     supported by DBIA #290
 ; Reference to %ZIS(2     supported by DBIA #2247
 ; Reference to ^PSSLOCK   supported by DBIA #2789
 ; Reference to ^XTMP("ORLK-" supported by DBIA #4001
 ; Reference to File #59   supported by DBIA #1976
 ;Called from PSXRSUS -Builds ^PSX(550.2,,15,"C" , and returns to PSXRSUS or PSXRTRAN
SDT K ^TMP($J,"PSX"),^TMP($J,"PSXDFN"),ZCNT,PSXBAT D:$D(XRTL) T0^%ZOSV
 S PSXTDIV=PSOSITE,PSXTYP=$S(+$G(PSXCS):"C",1:"N")
 S SDT=0 F  S SDT=$O(^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT)) S XDFN=0 Q:(SDT>PRTDT)!(SDT'>0)  D
 . F  S XDFN=$O(^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT,XDFN)) S REC=0 Q:(XDFN'>0)!(XDFN="")  D
 .. F  S REC=$O(^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT,XDFN,REC)) Q:(REC'>0)!(REC="")  D GETDATA D:$G(RXN) PSOUL^PSSLOCK(RXN),OERRLOCK(RXN)
 I $G(PSXBAT),'$G(PSXRTRAN) D CHKDFN ; PSXBAT created upon 1st transmittable RX being located
EXIT K SDT,DFN,REC,RXNUM,PSXOK,FILNUM,REF,PNAME,CNAME,DIE,DR,NDFN,%,CNT,COM,DTTM,FILL,JJ,PRTDT,PSXDIV,XDFN,NFLAG,CIND,XDFN
 K CHKDT,DAYS,DRUG,DRUGCHK,NM,OPDT,PHARCLK,PHY,PSTAT,PTRA,PTRB,QTY,REL,RXERR,RXF,SFN,PSXDGST,PSXMC,PSXMDT
 S:$D(XRT0) XRTN=$T(+0) D:$D(XRT0) T1^%ZOSV
 Q
GETDATA ;Screens rxs and builds data
 ;PSXOK=1:NOT CMOP DRUG OR DO NOT MAIL,2:TRADENAME,3:WINDOW,4:PRINTED,5:NOT SUSPENDED
 ;PSXOK=6:ALREADY RELEASED,7:DIFFERENT DIVISION,8:BAD DATA IN 52.5
 ;9:CS Mismatch,10:DEA 1 or 2
 I '$D(^PS(52.5,REC,0)) K ^PS(52.5,"AQ",SDT,XDFN,REC),^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT,XDFN,REC) Q
 I $P(^PS(52.5,REC,0),"^",7)="" K ^PS(52.5,"AQ",SDT,XDFN,REC),^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT,XDFN,REC) Q
 I ($P(^PS(52.5,REC,0),"^",3)'=XDFN) K ^PS(52.5,"AQ",SDT,XDFN,REC),^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT,XDFN,REC) Q
 N DFN S DFN=XDFN D DEM^VADPT
 I $G(VADM(6))'="" D DELETE K VADM Q
 S PSXOK=0,NFLAG=0
 S RXN=$P($G(^PS(52.5,REC,0)),"^",1) I RXN="" S PSXOK=8 Q
 D CHKDATA^PSXMISC1
SET Q:(PSXOK=7)!(PSXOK=8)!(PSXOK=9)
 S PNAME=$G(VADM(1))
 I ($G(PSXCSRX)=1)&($G(PSXCS)=1) S ^XTMP("PSXCS",PSOSITE,DT,RXN)=""
 I (PSXOK=0)&(PSXFLAG=1) S ^TMP($J,"PSXDFN",XDFN)="",NFLAG=4 D DQUE,RX550215 Q
 I (PSXOK=0)&(PSXFLAG=2) D RX550215 Q
 I (PSXOK>0)&(PSXOK<7)!(PSXOK=10) D DELETE Q
 Q
DELETE ;deletes the CMOP STATUS field in PS(52.5, reindex 'AC' x-ref
 L +^PS(52.5,REC):600 Q:'$T
 N DR,DIE,DA S DIE="^PS(52.5,",DA=REC,DR="3///@" D ^DIE
 S ^PS(52.5,"AC",$P(^PS(52.5,REC,0),"^",3),$P(^PS(52.5,REC,0),"^",2),REC)=""
 L -^PS(52.5,REC)
 Q
 ;the rest of the sub-routines go through the ^PSX(550.2,,15,"C"
 ;global and checks for RXs within the days ahead range and
 ;builds the ^PSX(550.2,PSXBAT,
CHKDFN ; use the patient 'C' index under RX multiple in file 550.2 to GET dfn to gather Patients' future RXs
 I '$D(^PSX(550.2,PSXBAT,15,"C")) Q
 S PSXPTNM="" F  S PSXPTNM=$O(^PSX(550.2,PSXBAT,15,"C",PSXPTNM)) Q:PSXPTNM=""  D
 .S XDFN=0 F  S XDFN=$O(^PSX(550.2,PSXBAT,"15","C",PSXPTNM,XDFN)) Q:(XDFN'>0)  D
 .. S SDT=PRTDT F  S SDT=$O(^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT)),NDFN=0 Q:(SDT>PSXDTRG)!(SDT="")  D
 ... F  S NDFN=$O(^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT,NDFN)),REC=0 Q:NDFN'>0  I NDFN=XDFN D
 .... F  S REC=$O(^PS(52.5,"CMP","Q",PSXTYP,PSXTDIV,SDT,NDFN,REC)) Q:REC'>0  D GETDATA D:$G(RXN) PSOUL^PSSLOCK(RXN),OERRLOCK(RXN)
 Q
BEGIN ;  Select print device
 I '$D(PSOPAR) D ^PSOLSET
 I $D(PSOLAP),($G(PSOLAP)'=ION) S PSLION=PSOLAP G PROFILE
 W ! S %ZIS("A")="PRINTER 'LABEL' DEVICE:  ",%ZIS("B")="",%ZIS="MQN" D ^%ZIS S PSLION=ION G:POP EXIT
 I $G(IOST)["C-" W !,"You must select a printer!",! G BEGIN
 F J=0,1 S @("PSOBAR"_J)="" I $D(^%ZIS(2,^%ZIS(1,IOS,"SUBTYPE"),"BAR"_J)) S @("PSOBAR"_J)=^("BAR"_J)
 S PSOBARS=PSOBAR1]""&(PSOBAR0]"")&$P(PSOPAR,"^",19)
 K PSOION,J D ^%ZISC I $D(IO("Q")) K IO("Q")
PROFILE I $D(PSOPROP),($G(PSOPROP)'=ION) Q
 I $P(PSOPAR,"^",8) S %ZIS="MNQ",%ZIS("A")="Select PROFILE PRINTER: " D ^%ZIS K %ZIS,IO("Q"),IOP G:POP EXIT S PSOPROP=ION D ^%ZISC
 I $G(PSOPROP)=ION W !,"You must select a printer!",! G PROFILE
 Q
PRT ; w auto error trapping
 D NOW^%DTC S DTTM=% K %
 S NM="" F  S NM=$O(^PSX(550.2,PSXBAT,15,"C",NM)) Q:NM=""  D DFN,PPL ;gather patient RXs, print patient RXs
 S DIK="^PSX(550.2,",DA=PSXBAT D ^DIK K PSXBAT
 K CHKDT,CIND,DAYS,DRUG,DRUGCHK,NFLAG,NM,ORD,PDT,PHARCLK,PHY,PSTAT,PTRA,PTRB,QTY,REL,RXERR,RXF,SFN,SIG,SITE,SUS,SUSPT
 Q
DFN S DFN=0,NFLAG=2
 F  S DFN=$O(^PSX(550.2,PSXBAT,15,"C",NM,DFN)),RXN=0 Q:(DFN="")!(DFN'>0)  D
 .F  S RXN=$O(^PSX(550.2,PSXBAT,15,"C",NM,DFN,RXN)),RXF="" Q:(RXN="")!(RXN'>0)  D
 ..F  S RXF=$O(^PSX(550.2,PSXBAT,15,"C",NM,DFN,RXN,RXF)) Q:RXF=""  D BLD
 Q
BLD ;
 S BATRXDA=$O(^PSX(550.2,PSXBAT,15,"B",RXN,0)) D NOW^%DTC S DTTM=%
 S REC=$P(^PSX(550.2,PSXBAT,15,BATRXDA,0),U,5),SUS=$O(^PS(52.5,"B",RXN,0))
 I SUS=REC,+SUS'=0 I 1 ;rx still valid in suspense
 E  D  Q  ;rx gone
 . N DA,DIK S DIK=550.2,DA(1)=PSXBAT,DA=BATRXDA
 . D ^DIK
 S PSOSU(DFN,SUS)=RXN,RXCNTR=$G(RXCNTR)+1,NFLAG=2
 S $P(^PSRX(RXN,0),U,15)=0,$P(^PSRX(RXN,"STA"),U,1)=0
 K % S COM="CMOP Suspense Label "_$S($G(^PS(52.5,SUS,"P"))=0:"Printed",$G(^PS(52.5,SUS,"P"))="":"Printed",1:"Reprinted")_$S($G(^PSRX(RXN,"TYPE"))>0:" (PARTIAL)",1:"")
 D EN^PSOHLSN1(RXN,"SC","ZU",COM)
 S DA=SUS D DQUE K DA
ACTLOG F JJ=0:0 S JJ=$O(^PSRX(RXN,"A",JJ)) Q:'JJ  S CNT=JJ
 S RFCNT=0 F RF=0:0 S RF=$O(^PSRX(RXN,1,RF)) Q:'RF  S RFCNT=RF
 S CNT=CNT+1,^PSRX(RXN,"A",0)="^52.3DA^"_CNT_"^"_CNT
LOCK L +^PSRX(RXN):600 G:'$T LOCK
 S ^PSRX(RXN,"A",CNT,0)=DTTM_"^S^"_DUZ_"^"_RFCNT_"^"_COM L -^PSRX(RXN)
 K CNT,COM,RFCNT,%,JJ,RF,Y,RXCNTR
 Q
PPL K PPL,PPL1 S ORD="" F  S ORD=$O(PSOSU(ORD)) Q:(ORD="")!(ORD'>0)  D PPL1
 Q
PPL1 ; print patient labels
 F SFN=0:0 S SFN=$O(PSOSU(ORD,SFN)) Q:'SFN  D
 . S:$L($G(PPL))<240 PPL=$P(PSOSU(ORD,SFN),"^")_","_$G(PPL)
 . S:$L($G(PPL))>239 PPL1=$P(PSOSU(ORD,SFN),"^")_","_$G(PPL1)
 . S DFN=$P(^PS(52.5,SFN,0),"^",3)
 S SUSPT=1,PSNP=$S($P(PSOPAR,"^",8):1,1:0) S:$D(PSOPROP) PFIO=PSOPROP
 D QLBL^PSORXL
 I $D(PPL1) S PSNP=0,PPL=PPL1 D QLBL^PSORXL
 K PPL,PPL1,PSOSU(ORD)
 Q
DQUE ;sets the CMOP indicator field, and printed field in 52.5
 L +^PS(52.5,REC):600 G:'$T DQUE
 I NFLAG=4 S DA=REC,DIE="^PS(52.5,",DR="3////L;4////"_DT D ^DIE K DIE,DA,DR L -^PS(52.5,REC) Q  ; the rest moved into PSXRTR
 S CIND=$S(NFLAG=1:"X",NFLAG=2:"P",NFLAG=3:"@",1:0)
 I $G(NFLAG)'=2 D
 .S DA=REC,DIE="^PS(52.5,",DR="3////"_CIND_";4////"_DT
 .D ^DIE K DIE,DA,DR
 .S ^PS(52.5,REC,"P")=1,^PS(52.5,"ADL",DT,REC)=""
 I $G(NFLAG)=2 D  ;print label cycle
 . S DA=REC,DIE="^PS(52.5,",DR="3////"_CIND_";4////"_DTTM_";5////"_DUZ_";7////"_RXCNTR
 . D ^DIE K DIE,DA,DR
 . S ^PS(52.5,REC,"P")=1,^PS(52.5,"ADL",$E($P(^PS(52.5,REC,0),"^",8),1,7),REC)=""
 L -^PS(52.5,REC)
 I $G(NFLAG)=2 D EN^PSOHLSN1(RXN,"SC","ZU","CMOP Suspense Label Printed")
 Q
RX550215 ; put RX into RX multiple TRANS 550.215 for PSXBAT
 I '$G(PSXBAT) D BATCH^PSXRSYU ; first time through create batch, & return PSXBAT
 K DD,DO,DIC,DA,DR,D0
 S:'$D(^PSX(550.2,PSXBAT,15,0)) ^PSX(550.2,PSXBAT,15,0)="^550.215P^^"
 S X=RXN,DA(1)=PSXBAT
 S DIC="^PSX(550.2,"_PSXBAT_",15,",DIC("DR")=".02////^S X=RXF;.03////^S X=DFN;.05////^S X=REC",DIC(0)="ZF"
 D FILE^DICN
 S PSXRXTDA=+Y ;RX DA within PSXBAT 'T'ransmission
 K DD,DO,DIC,DA,DR,D0
 Q
PRTERR ; auto error trap for prt cmop local
 S XXERR=$$EC^%ZOSV
 S PSXDIVNM=$$GET1^DIQ(59,PSOSITE,.01)
 ;save an image of the transient file 550.1 for 2 days
 D NOW^%DTC S DTTM=%
 S X=$$FMADD^XLFDT(DT,+2) S ^XTMP("PSXERR "_DTTM,0)=X_U_DT_U_"CMOP "_XXERR
 M ^XTMP("PSXERR "_DTTM,550.1)=^PSX(550.1)
 S XMSUB="CMOP Error "_PSXDIVNM_" "_$$GET1^DIQ(550.2,+$G(PSXBAT),.01)
 D GRP1^PSXNOTE
 ;S XMY(DUZ)=""
 S XMTEXT="TEXT("
 S TEXT(1,0)=$S($G(PSXCS):"",1:"NON-")_"CS CMOP Print Local encountered the following error. Please investigate"
 S TEXT(2,0)="Division:         "_PSXDIVNM
 S TEXT(3,0)="Type/Batch        "_$S($G(PSXCS):"CS",1:"NON-CS")_" / "_$$GET1^DIQ(550.2,$G(PSXBAT),.01)
 S TEXT(4,0)="Error:            "_XXERR
 S TEXT(5,0)="This batch has been set to closed."
 S TEXT(6,0)="Call NVS to investigate which prescriptions have been printed and which are yet to print."
 S TEXT(7,0)="A copy of file 550.1 can be found in ^XTMP(""PSXERR "_DTTM_""")"
 D ^%ZTER
 D ^XMD
 I $G(PSXBAT) D
 . N DA,DIE,DR S DIE="^PSX(550.2,",DA=PSXBAT,DR="1////4"
 . D ^DIE
 ;I $E(IOST)="C" F XX=1:1:5 W !,TEXT(XX,0)
 G UNWIND^%ZTER
 ;
OERRLOCK(RXN) ; set XTMP for OERR/CPRS order locking
 I $G(PSXBAT),$G(RXN),$G(PSXRXTDA) I 1
 E  Q
 I $P(^PSX(550.2,PSXBAT,15,PSXRXTDA,0),U,1)'=RXN Q
RXNSET ; set ^XTMP("ORLK-"_ORDER per IA 4001 needs RXN
 Q:'$G(RXN)
 N ORD,NOW,NOW1 S ORD=+$P($G(^PSRX(+$G(RXN),"OR1")),"^",2)
 Q:'ORD
 S NOW=$$NOW^XLFDT,NOW1=$$FMADD^XLFDT(NOW,1)
 S ^XTMP("ORLK-"_+ORD,0)=NOW1_U_NOW_"^CPRS/CMOP RX/Order Lock",^(1)=DUZ_U_$J
 Q
RXNCLEAR ; needs RXN
 Q:'$G(RXN)
 N ORD S ORD=+$P($G(^PSRX(+$G(RXN),"OR1")),"^",2) Q:'ORD
 I $D(^XTMP("ORLK-"_ORD,0)),^(0)["CPRS/CMOP" K ^XTMP("ORLK-"_ORD)
 Q
