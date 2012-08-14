SDM3 ;SF/GFT - MAKE APPOINTMENT ; [ 09/13/2001  2:32 PM ]
 ;;5.3;Scheduling;**32**;Aug 13, 1993
 ;IHS/ANMC/LJF 11/30/2000 changed $N to $O
 ;             12/13/2000 added master overbook access by clinic check
 ;
 ;S I=$P(SD,".",1),(S,ST)=$P(SL,U,7) I ST F D=I-.01:0 S D=$N(^SC(SC,"S",D)) Q:$P(D,".",1)-I  F %=0:0 S %=$N(^SC(SC,"S",D,1,%)) Q:%'>0  I $P(^(%,0),"^",9)'["C",$D(^("OB")) S ST=ST-1  ;IHS/ANMC/LJF 11/30/2000
 S I=$P(SD,".",1),(S,ST)=$P(SL,U,7) I ST F D=I-.01:0 S D=$O(^SC(SC,"S",D)) Q:$P(D,".",1)-I  F %=0:0 S %=$O(^SC(SC,"S",D,1,%)) Q:%'>0  I $P(^(%,0),"^",9)'["C",$D(^("OB")) S ST=ST-1  ;IHS/ANMC/LJF 11/30/2000 $N->$O
 ;I ST<1,'$D(^XUSEC("SDMOB",DUZ)) W !,*7,"ONLY "_S_" OVERBOOK"_$E("S",S>1)_" ALLOWED PER DAY!!",! G ^SDM1  ;IHS/ANMC/LJF 12/13/2000
 I ST<1,'$$MOVBKUSR^BSDU(DUZ,+SC) W !,*7,"ONLY "_S_" OVERBOOK"_$E("S",S>1)_" ALLOWED PER DAY!!",! G ^SDM1  ;IHS/ANMC/LJF 12/13/2000
 I ST<1 R !,"WILL EXCEED MAXIMUM ALLOWABLE OVERBOOKS, OK? YES// ",MXO:DTIME S:MXO="" MXO="Y" S MXO=$$UP^XLFSTR(MXO) G:MXO'["Y" ^SDM1 S S=^SC(SC,"ST",I,1),SM=9,MXOK="" G SC^SDM1
 S S=^SC(SC,"ST",I,1) G E^SDM1
ORDY S Y=SD D DTS^SDUTL S SODT=Y,(LAB,XRAY,EKG)="",SDWR=0
ORD R !,"ENTER TYPE AND TIME (I.E. 'LAB@8:30'): ",ORD:DTIME G:ORD=""!(ORD="^") END
 S ORD=$$UP^XLFSTR(ORD)
 I ORD'["LAB"&(ORD'["XRAY")&(ORD'["X-RAY")&(ORD'["EKG") W !,"ENTER EITHER 'LAB', 'XRAY', OR 'EKG' FOLLOWED BY THE '@' AND THE TIME" G ORD
 I '$F(ORD,"@") W !,"MUST ENTER THE '@' AFTER THE TYPE AND BEFORE THE TIME",*7 G ORD
 S SDDT=SODT_"@"_$P(ORD,"@",2),X=SDDT,%DT="XT" D ^%DT G:Y<0 ERR
 I $D(^DPT(DFN,"S",Y,0)),"I"[$P(^(0),U,2) S HSC=+^(0) W !,*7,"PATIENT ALREADY HAS APPOINTMENT AT THAT TIME IN ",$P(^SC(HSC,0),"^",1) G ORD
 S:ORD["LAB" LAB=Y S:ORD["EKG" EKG=Y S:ORD["XRAY"!(ORD["X-RAY") XRAY=Y S SDWR=1 W "  SCHEDULED" G ORD
ERR W !,"ENTER EITHER 'LAB', 'XRAY', OR 'EKG' FOLLOWED BY AN '@' AND THE TIME" G ORD
END I 'SDWR K SDWR,LAB,ORD,SDDT,SODT,XRAY,EKG D CLEAN Q
 F SDTY="LAB","XRAY","EKG" I @SDTY="" K @SDTY
 S SDIE=$S($D(LAB):LAB,$P(^DPT(DFN,"S",SD,0),U,3)]"":$P(^(0),U,3),1:"")_"^"_$S($D(XRAY):XRAY,$P(^DPT(DFN,"S",SD,0),U,4)]"":$P(^(0),U,4),1:"")_"^"_$S($D(EKG):EKG,$P(^DPT(DFN,"S",SD,0),U,5)]"":$P(^(0),U,5),1:""),$P(^DPT(DFN,"S",SD,0),"^",3,5)=SDIE
 K SDIE,SDWR,LAB,ORD,SDDT,SODT,XRAY,EKG,SDDISP
CLEAN K A,CKDATE,CNT,COV,DISBEG,ENDATE,FND,GOT,HNDATE,HSI,HSTM,HY,I,INC,INCM,J,K,LEN,MIN,NDATE,NS,NSTM,REM,SB,SD1,SDATE,SDCT,SDDIF,SDDOT,SDDT,SDHX,SDJ,SDLN,SDMAX,SDSOH,SI,SL,SM,SS,SSC,ST,SDSTRTDT,STARTDAY,STIME,STM,STR
 K WY,XX,Z Q
EN1 S SDDISP="" I $D(^DPT(DFN,.321)) F SDI=1:1:3 I $P(^DPT(DFN,.321),"^",SDI)["Y" S SDDISP=1 Q
 S DIV=1 I $S($D(^DIC(4,+$$SITE^VASITE,"DIV")):1,1:0),^("DIV")="Y",$P(^SC(SC,0),"^",15)]"" S DIV=$P(^(0),"^",15)
 ;I SDDISP W:'$D(SDAUTO) !,*7,"This appointment needs special survey dispositioning" S:'$D(^DPT("ASDPSD","B"," "_DIV,$P(SD,"."),DFN)) ^(DFN)=0 S:'$D(^DPT("ASDPSD","C"," "_DIV,SC,SD,DFN)) ^(DFN)=$S($P(SD,".")-DT:"",1:"E")
 I SDDISP S:'$D(^DPT("ASDPSD","B"," "_DIV,$P(SD,"."),DFN)) ^(DFN)=0 S:'$D(^DPT("ASDPSD","C"," "_DIV,SC,SD,DFN)) ^(DFN)=$S($P(SD,".")-DT:"",1:"E")
 K SDI,SDDISP,SDAUTO Q
EN1K Q:$S('$D(^DPT(X,.321)):1,^(.321)'["Y":1,1:0)
 S SDIV=1 I $S($D(^DIC(4,+$$SITE^VASITE,"DIV")):1,1:0),^("DIV")="Y",$P(^SC(DA(2),0),"^",15)]"" S SDIV=$P(^(0),"^",15)
 S SDDISP="" F I=1:1:3 I $P(^DPT(X,.321),"^",I)["Y" S SDDISP=1 Q
 Q:'SDDISP  S DFN=X,S=DA(1) S:$D(DIV) DIV1=DIV S DIV=SDIV K ^DPT("ASDPSD","C"," "_DIV,DA(2),DA(1),X) D CK1^SDM2 S:$D(DIV1) DIV=DIV1 Q