BGOREP ; IHS/BAO/TMD - Manage REPRODUCTIVE FACTORS ;25-Aug-2009 12:42;MGH
 ;;1.1;BGO COMPONENTS;**1,3,5,6**;Mar 20, 2007
 ; Returns reproductive history as a single string
 ; Patch 5 updates the expanded history logic to prevent error on an empty element.
 ; Patch 6 updates to use new field formats for repro history
TIUSTR() ;EP
 N X
 Q:'$G(DFN) ""
 D GET(.X,DFN)
 Q X
 ; Get reproductive factors on patient
 ; Returned as a list of data elements
 ;  INP = Patient IEN [1] ^ Date Obtained (opt) [2] ^ Expand History (opt) [3]
 ; .RET =
 ;        "L" ^ LMP Date [2]
 ;        "C" ^ Contraception Method [2] ^ Contraception Begun [3]
 ;        "P" ^ How EDC Determined [2] ^ EDC Date [3] ^ Pregnant [4}
 ;        "R" ^ Gravida[2] ^ Date[3] ^ Multiple Births[4] ^ Date[5] ^ Full term[6] ^ Date[7] ^ Premature[8]
 ;            ^ Date[9] ^ Ectopics[10] ^ Date[11] ^ Living Children[12] ^ Date[13] ^ Spontaneous abortions[14] ^ Date[15]^Theraputic abortions[16]^Date[17]
GET(RET,INP) ;EP
 N DFN,REC,HX,LMP,BEG,REPC,CONT,DELDT,METHOD,DAT,FNUM,EXP,CNT,REP,PREG,STR
 N X,Y,Z,G,M,F,P,E,L,T,S,GD,MD,FD,PD,ED,LD,TD,SD,REPDT
 S RET=$$TMPGBL^BGOUTL
 S FNUM=$$FNUM
 S CNT=0
 S DFN=+INP
 Q:'DFN
 Q:'$D(^AUPNREP(DFN))
 S DAT=$P(INP,U,2)
 S EXP=$P(INP,U,3)
 S REC=$G(^AUPNREP(DFN,0))
 D GETDATA
 S CNT=CNT+1
 S @RET@(CNT)="L"_U_LMP
 S CNT=CNT+1
 S @RET@(CNT)="C"_U_CONT_U_BEG
 S CNT=CNT+1
 S @RET@(CNT)="P"_U_METHOD_U_DELDT_U_PREG
 S CNT=CNT+1
 I EXP=1 D
 . S STR="Total # of pregnancies="_G_U_GD_U_"Multiple Births="_M_U_MD_U_"Full Term="_F_U_FD_U_"Premature="_P_U_PD_U
 . S STR=STR_"Ectopic Pregnancies="_E_U_ED_U_"Living Children="_L_U_LD_U_"Spontaneous Abortions (Miscarriages)="_S_U_SD_U_"Induced Abortions="_T_U_TD
 . S @RET@(CNT)="R"_U_STR
 E  S @RET@(CNT)="R"_U_G_U_GD_U_M_U_MD_U_F_U_FD_U_P_U_PD_U_E_U_ED_U_L_U_LD_U_S_U_SD_U_T_U_TD
 ;I DAT,$P(REC,U,3)'=DAT S HX=""
GETDATA ;Get the data needed for the repro history
 S LMP=$P(REC,U,4)
 I DAT'="",$P(REC,U,5)'=DAT S LMP=""
 S LMP=$$FMTDATE^BGOUTL(LMP)
 S CONT=$$EXTERNAL^DILFD(FNUM,3,,$P(REC,U,6))
 S BEG=$P(REC,U,7)
 I DAT'="",$P(REC,U,8)'=DAT S CONT="",BEG=""
 S BEG=$$FMTDATE^BGOUTL(BEG)
 S METHOD=$$EXTERNAL^DILFD(FNUM,4.05,,$P(REC,U,10))
 S DELDT=$P(REC,U,9)
 I DAT'="",$P(REC,U,11)'=DAT S METHOD="",DELDT=""
 S DELDT=$$FMTDATE^BGOUTL(DELDT)
 S REP=$G(^AUPNREP(DFN,11))
 S PREG=$$EXTERNAL^DILFD(FNUM,1101,,$P(REP,U,1))
 D CHECK(REP)
 Q
 ; Add/edit reproductive factor
 ;  INP = Patient IEN [1] ^ LMP Date [2] ^ Contraceptive Method [3] ^ Contraception Begun [4] ^
 ;        EDC Date [5] ^ EDC Determined [6] ^ Gravida[7] ^ Date Updated [8], Multiple Births[9] ^ Date Updated [10] ^
 ;        Full term[11] ^ Date Updated [12] ^Premature[13] ^ Date Updated [14] ^Ectopics[15] ^ Date Updated [16] ^
 ;        Living Children[17] ^ Date Updated [18] ^ Spontaneous abortions[19] ^ Date Updated [20]^Theraputic abortions[21]^Date Updated[22] ^Currently pregnant [23]
SET(RET,INP) ;EP
 N DFN,FNUM,REPHX,LMP,FP,FPDATE,PREG,DELIVDT,DELMETH,FDA,IENS,NEW
 N EDC,EDCBY,GRAV,GRAVDT,MB,MBDT,FT,FTDT,PRE,PREDT,EC,ECDT,LC,LCDT,SA,SADT,TA,TADT
 S RET="",FNUM=$$FNUM
 S TODAY=$$DT^XLFDT
 S DFN=+INP
 I '$D(^DPT(DFN,0)) S RET=$$ERR^BGOUTL(1001) Q
 I $P(^DPT(DFN,0),U,2)'="F" S RET=$$ERR^BGOUTL(1052) Q
 S NEW='$D(^AUPNREP(DFN))
 S IENS=$S('NEW:DFN_",",1:"+1,")
 S FDA=$NA(FDA(FNUM,IENS))
 S LMP=$P(INP,U,2)
 S FP=$P(INP,U,3)
 S FPDATE=$P(INP,U,4)
 S EDC=$P(INP,U,5)
 S PREG=$P(INP,U,23)
 S EDCBY=$P(INP,U,6)
 S:NEW @FDA@(.01)="`"_DFN
 S @FDA@(1.1)=TODAY
 S:$L(LMP) @FDA@(2)=LMP,@FDA@(2.1)=TODAY
 S:$L(FP) @FDA@(3)=FP,@FDA@(3.1)=TODAY,@FDA@(3.05)="@"
 S:$L(FPDATE) @FDA@(3.05)=FPDATE
 S:$L(PREG) @FDA@(1101)=PREG
 I EDC D
 .S:$L(EDC) @FDA@(4)=EDC,@FDA@(4.1)=TODAY
 .S:$L(EDCBY) @FDA@(4.05)=EDCBY
 E  S @FDA@(4)="@",@FDA@(4.05)="@"
 S GRAV=$P(INP,U,7),GRAVDT=$P(INP,U,8)
 I GRAV'="" D
 .S:$L(GRAV) @FDA@(1103)=GRAV
 .I $L(GRAVDT) S @FDA@(1104)=GRAVDT
 .E  S @FDA@(1104)=TODAY
 S MB=$P(INP,U,9),MBDT=$P(INP,U,10)
 I MB'="" D
 .S:$L(MB) @FDA@(1105)=MB
 .I $L(MBDT) S @FDA@(1106)=MBDT
 .E  S @FDA@(1106)=TODAY
 S FT=$P(INP,U,11),FTDT=$P(INP,U,12)
 I FT'="" D
 .S:$L(FT) @FDA@(1107)=FT
 .I $L(FTDT) S @FDA@(1108)=FTDT
 .E  S @FDA@(1108)=TODAY
 S PRE=$P(INP,U,13),PREDT=$P(INP,U,14)
 I PRE'="" D
 .S:$L(PRE) @FDA@(1109)=PRE
 .I $L(PREDT) S @FDA@(1110)=PREDT
 .E  S @FDA@(1110)=TODAY
 S EC=$P(INP,U,15),ECDT=$P(INP,U,16)
 I EC'="" D
 .S:$L(EC) @FDA@(1111)=EC
 .I $L(ECDT) S @FDA@(1112)=ECDT
 .E  S @FDA@(1112)=TODAY
 S LC=$P(INP,U,17),LCDT=$P(INP,U,18)
 I LC'="" D
 .S:$L(LC) @FDA@(1113)=LC
 .I $L(LCDT) S @FDA@(1114)=LCDT
 .E  S @FDA@(1114)=TODAY
 S SA=$P(INP,U,19),SADT=$P(INP,U,20)
 I SA'="" D
 .S:$L(SA) @FDA@(1133)=SA
 .I $L(SADT) S @FDA@(1134)=SADT
 .E  S @FDA@(1134)=TODAY
 S TA=$P(INP,U,21),TADT=$P(INP,U,22)
 I TA'="" D
 .S:$L(TA) @FDA@(1131)=TA
 .I $L(TADT) S @FDA@(1132)=TADT
 .E  S @FDA@(1132)=TODAY
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 D:'RET EVT(DFN,'NEW)
 S:'RET RET=DFN
 Q
 ; Delete reproductive history
 ;  DFN = Patient IEN
DEL(RET,DFN) ;EP
 S RET=$$DELETE^BGOUTL("^AUPNREP(",DFN)
 D:'RET EVT(DFN,2)
 Q
 ; Fire file update events
 ;  IEN = File IEN ( = patient IEN)
 ;  OPR   = Operation (0 = add, 1 = edit, 2 = delete)
EVT(IEN,OPR) ;EP
 N DATA
 S DATA=IEN_U_$G(CIA("UID"))_U_OPR_U_IEN
 D BRDCAST^CIANBEVT("PCC."_IEN_".REP",DATA)
 Q
 ; Expand reproductive history
EXPHX(DFN) ;
 N REC,HX,LMP,BEG,REPC,CONT,DELDT,METHOD,FNUM,EXP,CNT,REP,PREG,STR
 N X,Y,Z,G,M,F,P,E,L,T,S,GD,MD,FD,PD,ED,LD,TD,SD,REPDT,X2,TRGSTR
 S TRGSTR=""
 Q:'DFN
 Q:'$D(^AUPNREP(DFN))
 S FNUM=$$FNUM
 S REC=$G(^AUPNREP(DFN,0))
 D GETDATA
 S STR="Total Preg="_G_";Multiple Births="_M_";Full Term="_F_";Premature="_P
 S STR=STR_";Ectopics="_E_";Living="_L_";SponAb="_S_";TxAb="_T
 S TRGSTR=STR
 Q TRGSTR
CHECK(REP) ;Get the different reproductive elements
 S REPDT=$P(REP,U,30)
 S REPDT=$$FMTDATE^BGOUTL(REPDT)
 S G=$P(REP,U,3),GD=$$FMTDATE^BGOUTL($P(REP,U,4))
 I G="" S G=0
 S M=$P(REP,U,5),MD=$$FMTDATE^BGOUTL($P(REP,U,6))
 S F=$P(REP,U,7),FD=$$FMTDATE^BGOUTL($P(REP,U,8))
 S P=$P(REP,U,9),PD=$$FMTDATE^BGOUTL($P(REP,U,10))
 S E=$P(REP,U,11),ED=$$FMTDATE^BGOUTL($P(REP,U,12))
 S L=$P(REP,U,13),LD=$$FMTDATE^BGOUTL($P(REP,U,14))
 S T=$P(REP,U,31),TD=$$FMTDATE^BGOUTL($P(REP,U,32))
 S S=$P(REP,U,33),SD=$$FMTDATE^BGOUTL($P(REP,U,34))
 Q
 ; Return file number
FNUM() Q 9000017
