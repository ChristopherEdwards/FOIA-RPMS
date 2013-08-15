BGOREP ; IHS/BAO/TMD - Manage REPRODUCTIVE FACTORS ;15-Dec-2011 10:07;MGH
 ;;1.1;BGO COMPONENTS;**1,3,5,6,10**;Mar 20, 2007;Build 2
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
 ;        "L" [1] ^ LMP Date [2] ^ Date Changed [3]
 ;        "C" [1] ^ Contraception Method;Contraception Begun [2]^....(MULTIPLE)
 ;        "P" [1] ^ Pregnant [2] ^ Preg Provider [3] ^Date updated [4]
 ;        "R" [1] ^ Gravida[2] ^ Date[3] ^ Multiple Births[4] ^ Date[5] ^ Full term[6] ^ Date[7] ^ Premature[8]
 ;            ^ Date[9] ^ Ectopics[10] ^ Date[11] ^ Living Children[12] ^ Date[13] ^ Spontaneous abortions[14] ^ Date[15]^Theraputic abortions[16]^Date[17]
 ;        "B" [1] ^ Lactation Status [2] ^ Provider [3] ^ Date changed [4]
 ;        "M" [1] ^ Menarche Age [2] ^ Coitarche Age [3] ^ Menopause age [4]
 ;        "D" [1] ^ DES Daugher [2] ^ Date updated [3]
 ;        "E" [1] ^ EDD def [2]  ^ EDD Def  prov [3] ^ EDD Def Dt [4] ^ EDD Def Comment [5] ^ EDD LMP [6] ^ EDD LMP prov [7] ^ EDD LMP Date [8]^ EDD LMP Comment [9]
 ;                ^ EDD ult [10] ^EDD Ult Prov [11] ^EDD ult Date [12] ^ EDD Ult Comment [13]
 ;                ^ EDD Clin [14] ^ EDD Clin prov [15] ^ EDD Clin Date [16] ^EDD Clin Comment [17] ^ EDD unknown [18] ^EDD Unknown prov [19] ^EDD unknown date [20] ^ EDD unknown comment [21]
GET(RET,INP) ;EP
 N DFN,REC,HX,LMP,LMPDT,BEG,REPC,CONT,DELDT,METHOD,DAT,FNUM,EXP,CNT,REP,PREG,STR
 N X,Y,Z,G,M,F,P,E,L,T,S,GD,MD,FD,PD,ED,LD,TD,SD,REPDT,ARRAY
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
 S @RET@(CNT)="L"_U_LMP_U_LMPDT
 S CNT=CNT+1
 I EXP=1 D
 . S STR="Total # of pregnancies="_G_U_GD_U_"Multiple Births="_M_U_MD_U_"Full Term="_F_U_FD_U_"Premature="_P_U_PD_U
 . S STR=STR_"Ectopic Pregnancies="_E_U_ED_U_"Living Children="_L_U_LD_U_"Spontaneous Abortions (Miscarriages)="_S_U_SD_U_"Induced Abortions="_T_U_TD
 . S @RET@(CNT)="R"_U_STR
 E  S @RET@(CNT)="R"_U_G_U_GD_U_M_U_MD_U_F_U_FD_U_P_U_PD_U_E_U_ED_U_L_U_LD_U_S_U_SD_U_T_U_TD
 D LAC^BGOREP1(.RET,.CNT,DFN)   ;Get lactation data
 D CONT^BGOREP1(.RET,.CNT,DFN)   ;Get contraceptive data
 D MEN^BGOREP1(.RET,.CNT,DFN)   ;Get menstrual data
 D EDD^BGOREP1(.RET,.CNT,DFN)   ;Get EDD data
 ;I DAT,$P(REC,U,3)'=DAT S HX=""
GETDATA ;Get the data needed for the repro history
 S LMP=$P(REC,U,4)
 I DAT'="",$P(REC,U,5)'=DAT S LMP=""
 S LMP=$$FMTDATE^BGOUTL(LMP)
 S LMPDT=$P(REC,U,5)
 S LMPDT=$$FMTDATE^BGOUTL(LMPDT)
 S REC=$G(^AUPNREP(DFN,11))
 D CHECK(REC)
 Q
 ; Add/edit reproductive factor
 ;INP=dfn of patient
 ;DATA is an array
 ;DATA(1)=L [1] ^ LMP [2] ^ DATE updated [3]
 ;DATA(2)=R [1] ^ Gravida [2]^ Date Updated [3] ^Multiple Births [4] ^ Date Updated [5] ^Full term [6] ^ Date Updated [7] ^Premature [8]
 ;^ Date Updated [9] ^Ectopics [10] ^ Date Updated  [11] ^Living Children [12] ^ Date Updated [13] ^ Spontaneous abortions [14] ^ SA dt update[15]
 ;^ Induced abortions [16] ^ TA dt updated [17]
 ;DATA(3)=M [1] ^ Menarche age [2] ^Dte updated [3] ^coitarche age [4] ^date updated [5] ^menopause age [6] ^date updated [7] ^DES [8] ^Des updated [9]
 ;DATA(4)=E [1]^ PREGNANT [2]^ Dt updated [3] ^ Pregnant updated  prov [4]
 ;^EDD LMP [5] ^ EDD LMP DT [6] ^ EDD LMP Prov [7] ^ EDD LMP COMMENT [8]
 ;^EDD ult [9] ^EDD ul dte [10] ^EDD ult prov [11] ^ EDD ult comment [12]
 ;^EDD Clin [13] ^ EDD Clin dte [14] ^ EDD Clin Prov [15] ^ EDD clin Comment [16
 ;^EDD unknown [17] ^EDD Unk dte [18] ^ EDD unk prv [19] ^ EDD unk comment [20]
 ;^EDD Def [21] ^ EDD Def Dte [22] ^EDD Def prov [23] ^ EDD Def Comment [24]
 ;DATA(5)="B [1] ^lac status [2] ^dt updated [3] ^prov update [4]
SET(RET,INP,DATA) ;EP
 N DFN,FNUM,REPHX,LMP,TXT,FP,ARRAY,FPDATE,IDX,PREG,DELIVDT,DELMETH,FDA,IENS,NEW,EDDTX
 N EDC,EDCBY,GRAV,GRAVDT,MB,MBDT,FT,FTDT,PRE,PREDT,EC,ECDT,LC,LCDT,SA,SADT,TA,TADT
 N DEDD,DEDDP,DEDDT,TODAY,TYPE,PRV
 S PRV=$P($G(^VA(200,DUZ,0)),U,1)
 S RET="",FNUM=$$FNUM
 S TODAY=$$DT^XLFDT
 S DFN=+INP
 I '$D(^DPT(DFN,0)) S RET=$$ERR^BGOUTL(1001) Q
 I $P(^DPT(DFN,0),U,2)'="F" S RET=$$ERR^BGOUTL(1052) Q
 S NEW='$D(^AUPNREP(DFN))
 S IENS=$S('NEW:DFN_",",1:"+1,")
 S FDA=$NA(FDA(FNUM,IENS))
 S:NEW @FDA@(.01)="`"_DFN
 S @FDA@(1.1)=TODAY
 S (IDX,EDDTX)=""
 F  S IDX=$O(DATA(IDX)) Q:'IDX  D
 .S TYPE=$P(DATA(IDX),U,1)
 .S TXT=$G(DATA(IDX))
 .I TYPE="B" D LAC(TXT)
 .I TYPE="L" D LMP(TXT)
 .I TYPE="R" D REP(TXT)
 .I TYPE="M" D MEN(TXT)
 .I TYPE="E" D EDD(TXT)
 I NEW D
 .S RET=$$UPDATE^BGOUTL(.FDA,"E")
 E  D
 .D FILE^DIE("E","FDA","ERR")
 .I $D(ERR("DIERR")) S RET=ERR("DIERR")
 D:'RET EVT(DFN,'NEW)
 ;I 'RET D STORE(EDDTX)
 K ERR
 D STORE(EDDTX)
 S:'RET RET=DFN
 Q
LMP(TXT) ;Store LMP data
 N LMP,LMPUP
 S LMP=$P(TXT,U,2)
 S LMPUP=$P(TXT,U,4)
 I LMPUP="" S LMPUP=$$EXTERNAL^DILFD(TODAY)
 I LMP'="" D
 .S @FDA@(2)=LMP
 .S @FDA@(2.1)=LMPUP
 Q
LAC(TXT) ;Store lactation data
 N LAC,LACUP,LACPR
 S LAC=$P(TXT,U,2)
 S LACUP=$P(TXT,U,4)
 I LACUP="" S LACUP=$$EXTERNAL^DILFD(TODAY)
 S LACPR=$P(TXT,U,3)
 I LACPR="" S LACPR=PRV
 I $L(LAC) D
 .S @FDA@(2.01)=LAC
 .S:$L(LACPR) @FDA@(2.03)=LACPR
 .S:$L(LACUP) @FDA@(2.02)=LACUP
 Q
REP(INP) ;Store reproductive history data
 S GRAV=$P(INP,U,2),GRAVDT=$P(INP,U,3)
 I GRAV'="" D
 .S:$L(GRAV) @FDA@(1103)=GRAV
 .I $L(GRAVDT) S @FDA@(1104)=GRAVDT
 .E  S @FDA@(1104)=$$EXTERNAL^DILFD(TODAY)
 S MB=$P(INP,U,4),MBDT=$P(INP,U,5)
 I MB'="" D
 .S:$L(MB) @FDA@(1105)=MB
 .I $L(MBDT) S @FDA@(1106)=MBDT
 .E  S @FDA@(1106)=$$EXTERNAL^DILFD(TODAY)
 S FT=$P(INP,U,6),FTDT=$P(INP,U,7)
 I FT'="" D
 .S:$L(FT) @FDA@(1107)=FT
 .I $L(FTDT) S @FDA@(1108)=FTDT
 .E  S @FDA@(1108)=$$EXTERNAL^DILFD(TODAY)
 S PRE=$P(INP,U,8),PREDT=$P(INP,U,9)
 I PRE'="" D
 .S:$L(PRE) @FDA@(1109)=PRE
 .I $L(PREDT) S @FDA@(1110)=PREDT
 .E  S @FDA@(1110)=$$EXTERNAL^DILFD(TODAY)
 S EC=$P(INP,U,10),ECDT=$P(INP,U,11)
 I EC'="" D
 .S:$L(EC) @FDA@(1111)=EC
 .I $L(ECDT) S @FDA@(1112)=ECDT
 .E  S @FDA@(1112)=$$EXTERNAL^DILFD(TODAY)
 S LC=$P(INP,U,12),LCDT=$P(INP,U,13)
 I LC'="" D
 .S:$L(LC) @FDA@(1113)=LC
 .I $L(LCDT) S @FDA@(1114)=LCDT
 .E  S @FDA@(1114)=$$EXTERNAL^DILFD(TODAY)
 S SA=$P(INP,U,14),SADT=$P(INP,U,15)
 I SA'="" D
 .S:$L(SA) @FDA@(1133)=SA
 .I $L(SADT) S @FDA@(1134)=SADT
 .E  S @FDA@(1134)=$$EXTERNAL^DILFD(TODAY)
 S TA=$P(INP,U,16),TADT=$P(INP,U,17)
 I TA'="" D
 .S:$L(TA) @FDA@(1131)=TA
 .I $L(TADT) S @FDA@(1132)=TADT
 .E  S @FDA@(1132)=$$EXTERNAL^DILFD(TODAY)
 Q
MEN(TXT) ;Store menstrual history data
 N MAGE,CAGE,MENO,DES,MDT,CDT,MENODT,DESDT
 S MAGE=$P(TXT,U,2),MDT=$P(TXT,U,3)
 I MAGE="" S MAGE="@"
 S:$L(MAGE) @FDA@(1117)=MAGE
 I $L(MDT) S @FDA@(1118)=MDT
 E  S @FDA@(1118)=$$EXTERNAL^DILFD(TODAY)
 S CAGE=$P(TXT,U,4),CDT=$P(TXT,U,5)
 I CAGE="" S CAGE="@"
 S:$L(CAGE) @FDA@(1119)=CAGE
 I $L(CDT) S @FDA@(1120)=CDT
 E  S @FDA@(1120)=$$EXTERNAL^DILFD(TODAY)
 S MENO=$P(TXT,U,6),MENODT=$P(TXT,U,7)
 I MENO="" S MENO="@"
 S:$L(MENO) @FDA@(1121)=MENO
 I $L(MENODT) S @FDA@(1122)=MENODT
 E  S @FDA@(1122)=$$EXTERNAL^DILFD(TODAY)
 S DES=$P(TXT,U,8),DESDT=$P(TXT,U,9)
 I DES'="" D
 .S:$L(DES) @FDA@(1127)=DES
 .I $L(DESDT) S @FDA@(1128)=DESDT
 .E  S @FDA@(1128)=$$EXTERNAL^DILFD(TODAY)
 Q
EDD(TXT) ;Get EDD data string and save
 S EDDTX=TXT
 Q
STORE(TXT) ;Store EDD data string
 N EDD,EDDP,EDDT,PREG,PREGPR,PREGDT,FDA,IENS,FNUM,EDDCO
 K FDA
 Q:TXT=""
 S FNUM=$$FNUM
 S IENS=DFN_","
 S FDA=$NA(FDA(FNUM,IENS))
 S PREG=$P(TXT,U,2),PREGPR=$P(TXT,U,3),PREGDT=$P(TXT,U,4)  ;Pregnancy data
 S PREG=$$UPPER(PREG)
 I PREGPR="" S PREGPR=PRV
 I PREG'="" D
 .S:$L(PREG) @FDA@(1101)=PREG
 .S:$L(PREGPR) @FDA@(1135)=PREGPR
 .I $L(PREGDT) S @FDA@(1102)=PREGDT
 .E  S @FDA@(1102)=$$EXTERNAL^DILFD(TODAY)
 S EDD=$P(TXT,U,5),EDDP=$P(TXT,U,6),EDDT=$P(TXT,U,7),EDDCO=$P(TXT,U,8)  ;EDD by LMP data
 I EDDP="" S EDDP=PRV
 I PREG="NO" S (EDD,EDDP,EDDT,EDDCO)="@"
 I EDD'="" D
 .S:$L(EDD) @FDA@(1302)=EDD
 .S:$L(EDDP) @FDA@(1304)=EDDP
 .I $L(EDDT) S @FDA@(1303)=EDDT
 .E  S @FDA@(1303)=$$EXTERNAL^DILFD(TODAY)
 .I $L(EDDCO) S @FDA@(1401)=EDDCO
 D FILE^DIE("E","FDA","ERR")
 I $D(ERR("DIERR")) S RET=ERR("DIERR")
 K FDA,ERR
 S FDA=$NA(FDA(FNUM,IENS))
 S EDD=$P(TXT,U,9),EDDP=$P(TXT,U,10),EDDT=$P(TXT,U,11),EDDCO=$P(TXT,U,12)  ;EDD by ultrasound data
 I PREG="NO" S (EDD,EDDP,EDDT,EDDCO)="@"
 I EDDP="" S EDDP=PRV
 I EDD'="" D
 .S:$L(EDD) @FDA@(1305)=EDD
 .S:$L(EDDP) @FDA@(1307)=EDDP
 .I $L(EDDT) S @FDA@(1306)=EDDT
 .E  S @FDA@(1306)=$$EXTERNAL^DILFD(TODAY)
 .I $L(EDDCO) S @FDA@(1402)=EDDCO
 .D FILE^DIE("E","FDA","ERR")
 I $D(ERR("DIERR")) S RET=ERR("DIERR")
 K FDA,ERR
 S FDA=$NA(FDA(FNUM,IENS))
 S EDD=$P(TXT,U,13),EDDP=$P(TXT,U,14),EDDT=$P(TXT,U,15),EDDCO=$P(TXT,U,16) ;EDD by clinical parameters data
 I PREG="NO" S (EDD,EDDP,EDDT,EDDCO)="@"
 I EDDP="" S EDDP=PRV
 I EDD'="" D
 .S:$L(EDD) @FDA@(1308)=EDD
 .S:$L(EDDP) @FDA@(1310)=EDDP
 .I $L(EDDT) S @FDA@(1309)=EDDT
 .E  S @FDA@(1309)=$$EXTERNAL^DILFD(TODAY)
 .I $L(EDDCO) S @FDA@(1501)=EDDCO
 .D FILE^DIE("E","FDA","ERR")
 I $D(ERR("DIERR")) S RET=ERR("DIERR")
 K FDA,ERR
 S FDA=$NA(FDA(FNUM,IENS))
 S EDD=$P(TXT,U,17),EDDP=$P(TXT,U,18),EDDT=$P(TXT,U,19),EDDCO=$P(TXT,U,20) ;EDD by known method data
 I PREG="NO" S (EDD,EDDP,EDDT,EDDCO)="@"
 I EDDP="" S EDDP=PRV
 I EDD'="" D
 .S:$L(EDD) @FDA@(1314)=EDD
 .S:$L(EDDP) @FDA@(1316)=EDDP
 .I $L(EDDT) S @FDA@(1315)=EDDT
 .E  S @FDA@(1315)=$$EXTERNAL^DILFD(TODAY)
 .I $L(EDDCO) S @FDA@(1601)=EDDCO
 .D FILE^DIE("E","FDA","ERR")
 I $D(ERR("DIERR")) S RET=ERR("DIERR")
 S DEDD=$P(TXT,U,21),DEDDP=$P(TXT,U,22),DEDDT=$P(TXT,U,23),EDDCO=$P(TXT,U,24)
 K FDA,ERR
 S FDA=$NA(FDA(FNUM,IENS))
 I PREG="NO" S (DEDD,DEDDP,DEDDT,EDDCO)="@"
 I DEDDP="" S DEDDP=PRV
 I DEDD'="" D
 .S:$L(DEDD) @FDA@(1311)=DEDD
 .S:$L(DEDDP) @FDA@(1313)=DEDDP
 .I $L(DEDDT) S @FDA@(1312)=DEDDT
 .E  S @FDA@(1312)=$$EXTERNAL^DILFD(TODAY)
 .I $L(EDDCO) S @FDA@(1502)=EDDCO
 .D FILE^DIE("E","FDA","ERR")
 I $D(ERR("DIERR")) S RET=ERR("DIERR")
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
UPPER(X) ;Turn value to upper case
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ; Return file number
FNUM() Q 9000017
