BGOBMSR ; IHS/BAO/TMD - Manage BIRTH MEAS ;16-May-2007 11:08;DKM
 ;;1.1;BGO COMPONENTS;**1,3**;Mar 20, 2007
 ;---------------------------------------------
 ; Return birth measurement entries for patient
 ;  DFN = Patient IEN
 ; .RET = Birth Weight Lbs [1] ^ Birth Weight Oz [2] ^ Birth Weight Kg [3] ^
 ;        Birth Weight Gms [4] ^ Apgar 1m [5] ^ Apgar 5m [6] ^ Gest Age Wks [7] ^
 ;        Delivery Type [8] ^ Complications [9] ^ Birth Order [10] ^ Formula Started [11]
 ;        Breast Stopped [12] ^ Solids Started [13] ^ Mother Name | IEN [14]
GET(RET,DFN) ;EP
 N VAL,FLDS,FLD,IENS,FNUM,I,X,Y
 S RET=""
 Q:'$D(^AUPNBMSR(DFN,0))
 S FLDS=".02;.03;.18;.09;.04;.05;.06;.07;.08;.11;.12;.14;.16;.21"
 S IENS=DFN_",",FNUM=$$FNUM,RET=""
 D GETS^DIQ(FNUM,IENS,FLDS,"IE","VAL")
 F I=1:1:$L(FLDS,";") D
 .S FLD=$P(FLDS,";",I)
 .S X=$G(VAL(FNUM,IENS,FLD,"E")),Y=$G(VAL(FNUM,IENS,FLD,"I"))
 .S:X'=Y X=X_"|"_Y
 .S:$L(X) $P(RET,U,I)=X
 Q
 ; Set birth measurements
 ;  INP = Patient IEN [1] ^ Weight [2] ^ Order [3] ^ Formula [4] ^ Breast [5] ^
 ;        Solids [6] ^ Mother [7]
 ; .RET = -1 if error; null otherwise
SET(RET,INP) ;EP
 N DFN,IENS,FDA,MOTHER
 S RET=""
 S DFN=+INP
 I '$D(^DPT(DFN,0)) S RET=$$ERR^BGOUTL(1001) Q
 S MOTHER=$P(INP,U,7)
 S:MOTHER MOTHER="`"_MOTHER
 S IENS=$S($D(^AUPNBMSR(DFN,0)):DFN_",",1:"+1,")
 S FDA=$NA(FDA($$FNUM,IENS))
 S:$E(IENS)="+" @FDA@(.01)="`"_DFN
 S @FDA@(.19)=$TR($P(INP,U,2),"-kg"," KG")
 S @FDA@(.11)=$P(INP,U,3)
 S @FDA@(.12)=$P(INP,U,4)
 S @FDA@(.14)=$P(INP,U,5)
 S @FDA@(.16)=$P(INP,U,6)
 S @FDA@(.21)=MOTHER
 S RET=$$UPDATE^BGOUTL(.FDA,"E@")
 D:'RET EVT(DFN,$E(IENS)'="+")
 Q
 ; Delete birth measurements
 ;  DFN = Patient IEN
DEL(RET,DFN) ;EP
 S RET=$$DELETE^BGOUTL("^AUPNBMSR(",DFN)
 D:'RET EVT(DFN,2)
 Q
 ; Broadcast an update event
EVT(DFN,OPR) ;
 N DATA
 S DATA=DFN_U_$G(CIA("UID"))_U_OPR_U_DFN
 D:DFN BRDCAST^CIANBEVT("PCC."_DFN_".BMSR",DATA)
 Q
 ; Return File #
FNUM() Q 9000024
