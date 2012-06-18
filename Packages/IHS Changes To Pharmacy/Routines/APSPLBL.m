APSPLBL ;IHS/DSD/ENM - MOD VER OF PSOLBL/BHAM - SETS VAR TO PRINT LABEL ;16-Sep-2009 22:24;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1002,1003,1004,1006,1008**;Sep 23, 2004
 ; Modified - IHS/CIA/PLS - 12/23/03 - Line DQ1+11
 ;                          12/27/04 - Lines DQ1+1, C+3, C+7, STA+5, STA+17, STATCHK
 ;                          03/22/05 - Line DQ1+6
 ;            IHS/CIA/PLS - 03/01/06 - Line ORIG+1
 ;            IHS/MSC/PLS - 04/01/09 - Line DQ1+1
 ;                          06/15/09 - C EP - add logic from PSOLBL to handle suspense labels
DQ I $D(PSOIOS),PSOIOS]"" D DEVBAR^PSOBMST
 I $G(PSOBAR0)]"",$G(PSOBAR1)]"",$D(^PS(59,PSOSITE,1)) S PSOBARS=1
DQ1 ;EP
 ;IHS/MSC/PLS - 04/01/09 - Needed for suspense label generation
 N PSOTIME
 S PSOTIME=$$NOW^XLFDT()
 K APSPZZN  ; IHS/CIA/PLS - 12/27/04
 ; Summary labels will not be generated if laser labels are enabled.
 I $G(IOST(0)),$D(^%ZIS(2,IOST(0),55,"B","LL")),$$GET1^DIQ(9009033,PSOSITE,316,"I") D
 .D ^PSOLLLI
 .; Output signature label
 .; IHS/CIA/PLS - 03/22/05 - Additional parameters added
 .;D ENL^APSQSIGN($G(PPL),0,0,"TWO")
 .D ENL^APSQSIGN($G(PPL),0,0,"TWO",APSQSGLB,PSOSITE)
 E  D
 .D PARM,ENLBL^PSOBSET F PI=1:1 Q:$P(PPL,",",PI)=""  S RX=$P(PPL,",",PI) D C
 .;IHS/CIA/PLS - 8/23/05 - Signature labels for non-laser sites were not printing on the selected signature device.
 .;D EN^APSQSIGN(.ARRAY,$G(APSQSTOP,1),0,"TWO") ;IHS/OKCAO/POC 01/09/2001 ENTRY POINT FOR SIGNATURE LABEL,APSQSTOP DEFINED IN APSPNE4
 .D ENL^APSQSIGN($G(PPL),0,0,"TWO",APSQSGLB,PSOSITE,1)
 .;I $D(PSZK),PSZK,'(($G(PX)["B")!($G(PX)["S")) S L=PSZL+PSZE+PSZB*PSZK F I=1:1:L W ! ;IHS/DSD/ENM/POC 7/7/98  ADDED TO ALLOW NO SKIP BETWEEN  LBL & SUM IF SUM LBL PRINT
 ;
 D AUTOREL^APSPAUTO   ; IHS/CIA/PLS - 12/23/03
 ;
 K RXPI,PSORX,RXP,PSOIOS,XXX,TECH,COPAYVAR,PHYS,MFG,NURSE
 K STATE,SIDE,COPIES,EXDT,ISD,PSOINST,RXN,RXY,VADT,DEA,WARN,FDT
 K QTY,PATST,PDA,PS,PS1,PS2,PSL,PSNP,INRX,PSMPEX,XTYPE,SSNP,PNM
 K ADDR,PSODBQ,PSOTRAIL S ZTREQ="@"
 K RXRP
 Q
C ;EP
 N RXP,RXPI,XXX,TECH,PHYS,MFG,STATE,SIDE,COPIES,EXDT,ISD,PSOINST,RXN,RXY,VADT
 N DRUG,DEA,WARN,FDT,QTY,PATST,PDA,PS,PS1,PS2,INRX,PSMPEX,XTYPE,SSNP,PNM,ADDR
 N X1,X2
 ; Signature and Summary labels will not be generated if laser labels are enabled.
 I $G(IOST(0)),$D(^%ZIS(2,IOST(0),55,"B","LL")),$$GET1^DIQ(9009033,PSOSITE,316,"I") G ^PSOLLLI
 ; IHS/CIA/PLS - 12/27/04 - Changed to extrinsic call for discontinued status check
 ;U IO S X=$S('$P(^PS(59,PSOSITE,1),"^",28):132,1:158) X ^%ZOSF("RM") Q:'$D(^PSRX(RX,0))  S:$G(RXY)']"" RXY=^PSRX(RX,0) I $P(RXY,"^",15)=12&('$G(RXP))!('$P(RXY,"^",2)) K RXY Q
 N RXSTA
 U IO S X=$S('$P(^PS(59,PSOSITE,1),"^",28):132,1:158) X ^%ZOSF("RM") Q:'$D(^PSRX(RX,0))
 S RXY=^PSRX(RX,0),RXSTA=$P(^PSRX(RX,"STA"),U)
 I $$STATCHK(RX)&('$G(RXP))!('$P(RXY,"^",2)) K RXY Q
 Q:(($$FILLDT^APSPFUNC(RX)>$$DT^XLFDT())&($$RXSTAT^APSPFUNC(RX)'=5))
 N REPRINT
 S:$G(PSOBLALL) PSOBLRX=RX
 I $G(PSODBQ) S RR=$O(^PS(52.5,"B",RX,0)) Q:'RR  I $G(^PS(52.5,RR,"P"))=1 Q
 I $G(RXRS(RX))!($G(PSOPULL)) S PSOSXQ=0 N DR,DA,DIE D  I $G(PSOSXQ) K RXP,REPRINT Q
 .S DA=$O(^PS(52.5,"B",RX,0)) Q:'DA
 .S A=$P($G(^PS(52.5,DA,0)),"^",7) I A="" Q
 .I A="Q" S DIE="^PS(52.5,",DR="3////P" D ^DIE Q
 .K RXRS(RX) S PSOSXQ=1
 ; IHS/CIA/PLS - 12/27/04 - Status field was moved
 ;I $P(RXY,"^",15)'=4 D:$G(PSOSUSPR) AREC^PSOSUTL D:$G(PSOPULL) AREC^PSOSUTL ;IHS/DSD/ENM 09/09/97
 I RXSTA'=4 D
 .D:$G(PSOPULL)!($G(RXRS(RX))) AREC1^PSOSUTL
 .D:$G(PSOSUSPR) AREC^PSOSUTL
 .D:$G(PSOSUREP) AREC^PSOSUSRP
 .I $G(PSXREP) D
 ..N X S X="PSXSRP" X ^%ZOSF("TEST") I $T D AREC^PSXSRP
 S PSOINST="000" I $D(^DD("SITE",1)),^(1)]"" S PSOINST=^(1)
 ;
 ;  IHS/BAO/DMH dmh made change for the sig node.  in 7.0 sig is in "SIG" node
 ;  2/28/2002   commented out the next line and added the one after
 ;S RXN=$P(RXY,"^"),ISD=$P(RXY,"^",13),RXF=0,DFN=+$P(RXY,"^",2),SIG=$P(RXY,"^",10),ISD=$E(ISD,4,5)_"/"_$E(ISD,6,7)_"/"_$E(ISD,2,3),ZY=0,LINE="" F J=1:1:28 S LINE=LINE_"_"
 S RXN=$P(RXY,"^"),ISD=$P(RXY,"^",13),RXF=0,DFN=+$P(RXY,"^",2),SIG=$P($G(^PSRX(RX,"SIG")),"^",1),ISD=$E(ISD,4,5)_"/"_$E(ISD,6,7)_"/"_$E(ISD,2,3),ZY=0,LINE="" F J=1:1:28 S LINE=LINE_"_"
 S:$D(RXRP(RX)) REPRINT=1 S:$D(RXPR(RX)) RXP=RXPR(RX)
 I $G(PSOSUREP)!($G(PSOEXREP)) S REPRINT=1 S:'$G(RXRP(RX)) RXRP(RX)=1
 ;
 ;   end of ihs modification  2/28/2002
 ;
 ;   dmh added a $G to the above "SIG" line... 6/19/2002
 ;   dmh added this next line to pull sig from other node if null
 ;       it gets set in "SIG1" node too.....  6/19/2002
 ;I SIG="" S SIG=$G(^PSRX(RX,"SIG1",1,0))
 ;
 S:$D(RXPR(RX)) RXP=RXPR(RX)  ; IHS/CIA/PLS - 03/02/04
 S FDT=$P(^PSRX(RX,2),"^",2),PS=$S($D(^PS(59,PSOSITE,0)):^(0),1:""),PS1=$S($D(^(1)):^(1),1:""),PSOSITE7=$P(^PS(59,PSOSITE,"IB"),"^")
 S PS2=$P(PS,"^")_"^"_$P(PS,"^",6) I $P(PSOSYS,"^",4),$D(^PS(59,+$P($G(PSOSYS),"^",4),0)) S PS=^PS(59,$P($G(PSOSYS),"^",4),0)
 ;OLD EXPIRATIOND DATE REMOVED 12.23.94
APSPM ; get Mfg data 12.23.94
 I $G(APSPLTYP)="P" G ZCP ; 2-16-95
 ;CHANGE NEXT LINES AROUND IHS/OKCAO/POC 8/18/2000
 ;S (APSP("LOT"),APSP("MANF"),APSP("MANXDT"))="" D LBL^APSPMAN
 S (APSP("LOT"),APSP("MANF"),APSP("MANXDT"))=""
 I $O(^PSRX(RX,1,"A"),-1) D  ;
 .N REF,NODE
 .S REF=$O(^PSRX(RX,1,"A"),-1)
 .S NODE=^PSRX(RX,1,REF,0)
 .S APSP("LOT")=$P(NODE,U,6),APSP("MANF")=$P(NODE,U,14),APSP("MANXDT")=$P(NODE,U,15)
 E  D  ;
 .N NODE
 .S NODE=^PSRX(RX,2)
 .S APSP("LOT")=$P(NODE,U,4),APSP("MANF")=$P(NODE,U,8),APSP("MANXDT")=$P(NODE,U,11)
 S APSPLOT=$E(APSP("LOT"),1,8),APSPMF=$E(APSP("MANF"),1,7),APSPDY=$E(APSP("MANXDT"),4,5)_"/"_$E(APSP("MANXDT"),2,3)
 ;END OF CHANGES IHS/OKCAO/POC 8/18/2000
ZCP S COPIES=$S($P($G(RXRP(RX)),"^",2):$P($G(RXRP(RX)),"^",2),$P(RXY,"^",18)]"":$P(RXY,"^",18),1:1)
 S:COPIES>99 COPIES=99
 I $O(^PSRX(RX,1,0)),'$G(RXP) S XTYPE=1 D REF G STA
 I $G(RXP) S XTYPE="P" D REF G STA
 S (APSPZ,APSPZZ)="" ; 4.19.94
ORIG ;S TECH=$P($G(^VA(200,+$P(^PSRX(RX,0),"^",16),0)),"^",2)
 S TECH=$$LBLINI(RX,"O"),QTY=$P(^PSRX(RX,0),"^",7)  ; IHS/CIA/PLS - 03/01/06
 S PHYS=$S($D(^VA(200,+$P(^PSRX(RX,0),"^",4),0)):$P(^(0),"^"),1:"UNKNOWN")
 D 6^VADPT,PID^VADPT
 ;
 S:PHYS'="UNKNOWN" APSPZ=+$P($G(^VA(200,+$P(^PSRX(RX,0),"^",4),"PS")),"^",5)
 S APSPZZ=$S('APSPZ:"UNK",1:$P($G(^DIC(7,APSPZ,0)),"^",2))
 S:PHYS'="UNKNOWN" PHYS=$P(PHYS,",",1)_","_$E($P(PHYS,",",2),1)_"."_" "_APSPZZ
 S:(PHYS'="UNKNOWN")&($P($G(^PSRX(RX,3)),"^",3)]"") APSPCOS=$P(^(3),"^",3),APSPCOSE=$$GET1^DIQ(52,RX_",",109),PHYS=$P(APSPCOSE,",",1)_"/"_PHYS ;AHH THE TRIALS AND TRIBULATIONS OF ADDING COSIGNERS TO SIG IHS/OKCAO/POC 3/1/2001 NOT YET
 D CUT ;IHS/OKCAO/POC 3/16/2001
 S DAYS=$P(^PSRX(RX,0),"^",8),MFG=$S($P(^(2),"^",8)]"":$P(^(2),"^",8),1:"________ "),LOT=$S($P(^(2),"^",4):$P(^(2),"^",4),1:"_________")
STA S STATE=$S($D(^DIC(5,+$P(PS,"^",8),0)):$P(^(0),"^",2),1:"UNKNOWN")
 S (DRUG,DEA,WARN)="" I $D(^PSDRUG(+$P(RXY,"^",6),0)) S DRUG=$P(^(0),"^"),DEA=$P(^(0),"^",3),WARN=$P(^(0),"^",8) I $D(^PSRX(RX,"TN")),^("TN")]"",^("TN")'?1." " S DRUG=^("TN")
 ;S SIDE=$S($G(SIDE)]"":SIDE,1:0) ;IHS/DSD/ENM 02/25/97
 S APS("DISP UNITS")="" S:$D(^PSDRUG(+$P(RXY,U,6),660)) APS("DISP UNITS")=$P(^(660),U,8)
 I $G(^PSRX(RX,"P",+$G(RXP),0))]"" S RXPI=RXP D
 .; IHS/CIA/PLS - 12/27/04 - Status field was moved
 .;S RXP=^PSRX(RX,"P",RXP,0),RXY=$P(RXP,"^")_"^"_$P(RXY,"^",2,6)_"^"_$P(RXP,"^",4)_"^"_$P(RXP,"^",10)_"^"_$P(RXY,"^",9,10)_"^"_$P(RXP,"^",2)_"^"_$P(RXY,"^",12,15)_"^"_$P(RXP,"^",7)_"^"_$P(RXY,"^",17,99),FDT=$P(RXP,"^")
 .S RXP=^PSRX(RX,"P",RXP,0),RXY=$P(RXP,"^")_"^"_$P(RXY,"^",2,6)_"^"_$P(RXP,"^",4)_"^"_$P(RXP,"^",10)_"^"_$P(RXY,"^",9,10)_"^"_$P(RXP,"^",2)_"^"_$P(RXY,"^",12,14)_"^"_$G(^PSRX(RX,"STA"))_"^"_$P(RXP,"^",7)_"^"_$P(RXY,"^",17,99),FDT=$P(RXP,"^")
 S MW=$P(RXY,"^",11) F I=0:0 S I=$O(^PSRX(RX,1,I)) Q:'I  S RXF=RXF+1 S:'$G(RXP) MW=$P(^PSRX(RX,1,I,0),"^",2) I +^PSRX(RX,1,I,0)'<FDT S FDT=+^(0)
 I MW="W",$G(^PSRX(RX,"MP"))]"" S PSMPEX=0 D
 .S PSMP=^PSRX(RX,"MP"),PSJ=0 F PSI=1:1 S PSMP(PSI)="",PSJ=PSJ+1 Q:PSMPEX  F PSJ=PSJ:1 S PSMP(PSI)=PSMP(PSI)_$P(PSMP," ",PSJ)_" " S:$P(PSMP," ",PSJ+1)="" PSMPEX=1 Q:PSMPEX!($L(PSMP(PSI))+$L($P(PSMP," ",PSJ+1))>30)
 .K PSMP(PSI)
 S X=$S($D(^PS(55,DFN,0)):^(0),1:""),PSCAP=$P(X,"^",2) S:MW="M" MW=$S(+$P(X,"^",3):"R",1:MW) S MW=$S(MW="M":"REGULAR",MW="R":"CERTIFIED",1:"WINDOW")
 S DATE=$E(FDT,1,7),REF=$P(RXY,"^",9)-RXF S:'$G(RXP) $P(^PSRX(RX,3),"^")=FDT S:REF<1 REF=0 S PSZRM="  MRx"_REF D ^APSPLBL2 S II=RX D ^PSORFL
 S PATST=^PS(53,$P(RXY,"^",3),0) S PRTFL=1 I REF=0 S:('$P(PATST,"^",5))!(DEA["A"&(DEA'["B"))!(DEA["W") PRTFL=0
 S VRPH=$P(^PSRX(RX,2),"^",10),PSCLN=+$P(RXY,"^",5),PSCLN=$S($D(^SC(PSCLN,0)):$P(^(0),"^",2),1:"UNKNOWN")
 S PATST=$P(PATST,"^",2),X1=DT,X2=$P(RXY,"^",8)-10 D C^%DTC:REF I $D(^PSRX(RX,2)),$P(^(2),"^",6),REF,X'<$P(^(2),"^",6) S REF=0,VRPH=$P(^(2),"^",10)
 ; IHS/CIA/PLS - 12/27/04 - Status field was moved
 ;I $P(^PSRX(RX,0),"^",15)>0,$P(^(0),"^",15)'=2,'$G(PSODBQ) G LBL
 I $G(^PSRX(RX,"STA"))>0,$G(^("STA"))'=2,'$G(PSODBQ) G LBL
LBL ;USE IHS LABEL RTN
 G ^APSPLBL1
REF F XXX=0:0 S XXX=$O(^PSRX(RX,XTYPE,XXX)) Q:+XXX'>0  D
 .;S TECH=$P($G(^VA(200,+$P(^PSRX(RX,XTYPE,XXX,0),"^",7),0)),"^",2)
 .S TECH=$$LBLINI(RX,$S(XTYPE:"R",1:"P"),XXX)
 .S QTY=$P(^PSRX(RX,XTYPE,XXX,0),"^",4),PHYS=$S($D(^VA(200,+$P(^PSRX(RX,XTYPE,XXX,0),"^",17),0)):$P(^(0),"^"),$D(^VA(200,+$P(^PSRX(RX,0),"^",4),0)):$P(^(0),"^"),1:"UNKNOWN") D 6^VADPT,PID^VADPT
 .S:PHYS'="UNKNOWN" APSPZ=+$P(^VA(200,+$P(^PSRX(RX,0),"^",4),"PS"),"^",5),APSPZZ=$P($G(^DIC(7,APSPZ,0)),"^",2)
 .S:PHYS'="UNKNOWN" PHYS=$P(PHYS,",",1)_","_$E($P(PHYS,",",2),1)_"."_" "_APSPZZ
 .S:(PHYS'="UNKNOWN")&($P($G(^PSRX(RX,3)),"^",3)]"") APSPCOS=$P(^(3),"^",3),APSPCOSE=$$GET1^DIQ(52,RX_",",109),PHYS=$P(APSPCOSE,",",1)_"/"_PHYS ;AHH THE TRIALS AND TRIBULATIONS OF ADDING COSIGNERS TO SIG IHS/OKCAO/POC 3/1/2001 NOT YET
 .D CUT ;IHS/OKCAO/POC 3/16/2001
 .S DAYS=$P(^PSRX(RX,XTYPE,XXX,0),"^",10),LOT=$S($P(^(0),"^",6):$P(^(0),"^",6),1:"UNKNOWN")
 .I XTYPE=1 S MFG=$S($P(^PSRX(RX,XTYPE,XXX,0),"^",14)]"":$P(^(0),"^",14),1:"UNKNOWN")
 .E  S MFG=$S($P($G(^PSRX(RX,2)),"^",8)]"":$P(^(2),"^",8),1:"UNKNOWN")
 Q
EN01 I $D(PSOIOS),PSOIOS]"" F J=0,1 I $D(^%ZIS(2,^%ZIS(1,PSOIOS,"SUBTYPE"),"BAR"_J)) S @("PSOBAR"_J)=^("BAR"_J)
 I $G(PSOBAR0)]"",$G(PSOBAR1)]"",$D(^PS(59,PSOSITE,1)) S PSOBARS=1
 D PARM
 F PI=1:1 Q:$P(PPL,",",PI)=""  S RX=$P(PPL,",",PI) D C
 Q
PARM ;EP
 ;SET LBL WTH/LN/MAR & GET DATA FROM FILE #9009033
 I '$D(%APSITE),$D(^APSPCTRL(PSOSITE,0)) S %APSITE=^(0)
 S X=$S($D(^APSPCTRL(PSOSITE,0)):^(0),1:""),PSZW=$P(X,U,4),PSZL=$P(X,U,5),PSZB=$P(X,U,6),PSZE=$P(X,U,7),PSZK=$P(X,U,9),PSZTAB=$P(X,U,10) ;IHS/DSD/ENM 08/01/96
 Q
 ;
CUT ;CUT DOWN THE PHYSICIAN VARIABLE IF NEED BE--PHYS IHS/OKCAO/POC 3/16/2001
 ;NOTE LENGTH SHOULD NOT BE OVER 17
 Q:$L(PHYS)<18  ;NOT OVER 17 SO QUIT
 N EXTRA S EXTRA=$L(PHYS)-17 ;NEED FOUR SPACES AT END FOR APSPZZ AND /
 N ODD S ODD=EXTRA#2 ;ODD OR EVEN ODD=1 EVEN=0
 I PHYS["/" D
 .S EXTRA=EXTRA\2
 .N EXTRA1 S EXTRA1=EXTRA
 .S:ODD EXTRA1=EXTRA1+1 ;ODD OR EVEN ODD=1 EVEN=0
 .N PHYS1 S PHYS1=$F(PHYS,"/")-1 ;PHYS1 IS WHERE THE / IS
 .N NAME1 S NAME1=$E(PHYS,1,PHYS1-EXTRA1-1) ;-1 ONE GET RID OF /
 .N EXTRA2 S EXTRA2=EXTRA
 .N PHYS2 S PHYS2=$F(PHYS,".")-1
 .N NAME2 S NAME2=$E(PHYS,PHYS1+1,PHYS2-EXTRA2)
 .N LEN S LEN=$L(NAME2) I $E(NAME2,LEN)="," S NAME2=$E(NAME2,1,LEN-1)
 .S PHYS=NAME1_"/"_NAME2_" "_APSPZZ ;APSPZZ IS PROVIDER DISCIPLINE FROM APSPLBL
 E  D
 .N EXTRA1 S EXTRA1=EXTRA
 .N PHYS1 S PHYS1=$F(PHYS,".")-1
 .N NAME1 S NAME1=$E(PHYS,1,PHYS1-EXTRA1)
 .S PHYS=NAME1_" "_APSPZZ
 Q
 ; Return True(1) if Status is Discontinued or Deleted
STATCHK(RX) ; EP
 N STA
 S RX=$G(RX,0)
 Q:'RX 0
 S STA=$G(^PSRX(RX,"STA"))
 Q $S(STA>11&(STA<16):1,1:0)
 ; Return initials for display on label
 ; Input: RXN - Prescription IEN
 ;        TYPE - P=Partial; R=Refill; O=Original
 ;        IEN - Represents the partial or refill node
LBLINI(RXN,TYPE,IEN) ;
 N TECH,NODE
 I $L($G(TYPE)),"RP"[$G(TYPE) D  ; Refill/Partial
 .S NODE=$G(^PSRX(RXN,$S(TYPE="P":"P",1:1),+$G(IEN),0))
 .S TECH=$P(NODE,U,5)  ;pharmacist
 .S:'TECH TECH=$P(NODE,U,7)  ; clerk
 E  D
 .S TECH=$P($G(^PSRX(RXN,2)),U,3)    ;pharmacist
 .S:'TECH TECH=$P($G(^PSRX(RXN,"OR1")),U,5)  ;finishing person
 .S:'TECH TECH=$P($G(^PSRX(RXN,0)),U,16)   ;entered by
 Q $$USRINI^APSPLBL1(TECH)
