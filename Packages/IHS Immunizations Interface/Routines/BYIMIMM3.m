BYIMIMM3 ;IHS/CIM/THL - IMMUNIZATION DATA INTERCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE INTERFACE;**2**;MAY 01, 2011
 ;;CONTINUATION OF BYIMIMM
 ;
 ;;PATCH 2
 ;;
 ;;  TEST     - ALLOW USER TO SPECIFY NUMBER OF TEST RECORDS
 ;;  LOC      - CHECK FOR 'OTHER' LOCATION MATCH
 ;;  VFC      - INTERPRET BEN CODE TO CORRECT V0X CODE
 ;;           - CHANGE INCLUSION OF LOCAL FIN CODE TO PARAMETER
 ;;  VFCD     - RE-INTERPRET VFC DATE
 ;;  VT       - RE-DO VISIT DATE CALCULATION
 ;
 ;-----
SELECT ;EP;
 F  D S1 Q:$D(BYIMQUIT)
 K BYIMQUIT
 Q
 ;-----
S1 NEW XREF,BYIMBEG,BYIMEND
 W @IOF
 W !!?20,"Select the FILE report option"
 W !
 K DIR
 S DIR(0)="SO^1:File Name;2:By Date range"
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT="" Q
 I Y=1 D FN S Y=1 I $D(BYIMQUIT) K BYIMQUIT Q
 I Y=2 D DR
 I $D(BYIMQUIT) K BYIMQUIT Q
ZIS ;SELECT DEVICE FOR DISPLAY
 S BYIMRTN="DISP^BYIMIMM3"
 D ZIS^BYIMXIS
 Q
 ;-----
FN ;SELECT FILE NAME TO DISPLAY
 N X,Y,Z
 K DIR
 S DIR(0)="FO^1:30"
 S DIR("A")="Select FILE NAME to display"
 W !
 D ^DIR
 K DIR
 I X="" S BYIMQUIT="" Q
 I '$O(^BYIMPARA("FILE",X,DUZ(2),0)) D  Q
 .W !!,"No file with this name - ",X," - on file."
 .H 4
 .S BYIMQUIT=""
 S BYIMBEG=X
 S XREF="FILE"
 Q
 ;-----
DR ;SELECT DATE RANGE FOR DISPLAY
 K DIR
 S DIR(0)="DO"
 S DIR("A")="Beginning Date FILE STATISTICS Report"
 S Y=DT
 X ^DD("DD")
 S DIR("B")=Y
 W !
 D ^DIR
 K DIR
 I 'Y D  Q
 .S BYIMQUIT=""
 .W !!,"To display FILE STATS by date range"
 .W !,"the Beginning Date must be selected."
 S BYIMBEG=Y
 K DIR
 S DIR(0)="DO"
 S DIR("A")="Ending Date FILE STATISTICS Report"
 S Y=DT
 X ^DD("DD")
 S DIR("B")=Y
 W !
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT="" Q
 S BYIMEND=Y
 S XREF="DATE"
 Q
 ;-----
DISP ;EP;TO DISPLAY FILE STATS REPORT
 K BYIMQUIT
 N JJ,XX,YY,ZZ,XXX
 S JJ=0
 D HDR
 S XX=BYIMBEG
 S:'XX XX=$E(XX,1,$L(XX)-1)
 S:XX XX=XX-1
 F  S XX=$O(^BYIMPARA(XREF,XX)) Q:XX=""!($S(BYIMBEG:XX>BYIMEND,1:XX'[BYIMBEG))!$D(BYIMQUIT)  D
 .S YY=0
 .F  S YY=$O(^BYIMPARA(XREF,XX,DUZ(2),YY)) Q:'YY!$D(BYIMQUIT)  D D1
 I '$D(ZTQUEUED) W !! D PAUSE^BYIMIMM
 Q
 ;-----
HDR ;DISPLAY HEADER
 S JJ=JJ+6
 W @IOF
 W !!,"File Status Report",?40,"Report Date: "
 W $E(DT,4,5),"/",$E(DT,6,7),"/",$E(DT,1,3)+1700
 W !!,?20,"IMP/EXP",?40,"Pat-",?48,"Imuni-",?56,"NO Pat",?64,"New",?72,"Imms"
 W !,"File",?20,"Date",?32,"Type",?40,"ients",?48,"zations",?56,"Match",?64,"Imms",?72,"Added"
 W !,"------------------",?20,"----------",?32,"------",?40,"------",?48,"------",?56,"------",?64,"------",?72,"------"
 Q
 ;-----
D1 ;GET FILE INFO
 S X=^BYIMPARA(DUZ(2),2,YY,0)
 S Y=$P(X,U)
 S DATE=$P(X,U,2)
 S DATE=$E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_($E(DATE,1,3)+1700)
 S $E(Y,21)=DATE
 S MODE=$P(X,U,3)
 S MODE=$S(MODE="E":"EXPORT",MODE="I":"IMPORT",1:"")
 S $E(Y,33)=MODE
 S $E(Y,41)=$J($P(X,U,4),5)
 S $E(Y,49)=$J($P(X,U,5),5)
 S $E(Y,57)=$J($P(X,U,6),5)
 S $E(Y,65)=$J($P(X,U,7),5)
 S $E(Y,73)=$J($P(X,U,8),5)
 W !,Y
 S JJ=JJ+1
 I '$D(ZTQUEUED),JJ#IOSL=0 D
 .W !!
 .D PAUSE^BYIMIMM
 .I X[U S BYIMQUIT="" Q
 .D HDR
 Q
 ;-----
OL(INDA) ;EP;TO SET OUTSIDE LOCATION
 S VDA=$P($G(^AUPNVIMM(INDA,0)),U,3)
 S OL=$P($G(^AUPNVSIT(+VDA,21)),U)
 Q:OL]"" OL
 S OL=$P($G(^AUPNVSIT(VDA,0)),U,6)
 S OL=$P($G(^DIC(4,+OL,0)),U)
 Q OL
 ;-----
HX1(X) ;EP;TO RETURN HX CODE
 N VIS,V0,TYPE,CB,MFI
 D VINFO
 Q:CB=.5!$L(MFI) "02"
 Q:TYPE="E" "01"
 Q "00"
 ;-----
HX2(X) ;EP;TO RETURN HX CODE
 N VIS,V0,TYPE,CB,MFI
 D VINFO
 Q:CB=.5!$G(MFI) "HISTORICAL INFORMATION - OTHER PROVIDER"
 Q:TYPE="E"!'VIS "HISTORICAL INFORMATION - SOURCE UNSPECIFIED"
 Q "NEW IMMUNIZATION RECORD"
 ;-----
VINFO ;GET VISIT INFOR
 S VIS=+$P($G(^AUPNVIMM(+$G(X),0)),U,3)
 S V0=$G(^AUPNVSIT(VIS,0))
 S TYPE=$P(V0,U,7)
 S CB=$P(V0,U,23)
 S MFI=$P($G(^AUPNVSIT(VIS,11)),U,13)
 Q
 ;-----
VFC(INDA) ;EP;TO RETURN THE VFC CODE
 N X,Y,Z
 ;PATCH 2
 ;S X=$P($G(^AUPNVIMM(+$G(INDA(9000010.11,1)),0)),U,11)
 ;S:'X X=$P($G(^AUPNPAT(INDA,11)),U,11)
 ;S:'X X=1
 S VSIT=+$G(INDA("9000010","1"))
 S X=$O(^AUPNVIMM("AC",INDA,9999999999),-1)
 I 'VSIT,X S VSIT=$P($G(^AUPNVIMM(X,0)),U,3)
 S X=$P($G(^AUPNVIMM(+X,0)),U,14)
 I 'X,$P($G(^AUPNPAT(INDA,11)),U,11)=1 S X=4
 E  S X=1
 S:'X X=4
 ;PATCH 2
 ;S X="V0"_X_U_$$VFCD(VSIT)_"~"_$$VT(INDA)
 S X="V0"_X_U_$$VFCD(VSIT)
 I $P($G(^BYIMPARA(DUZ(2),0)),U,9) S X=X_"~"_$$VT(INDA)
 Q X
 ;-----
VFCD(VSIT) ;EP;TO RETURN THE VFC DATE
 N X,Y,Z
 S X=""
 S:VSIT X=$P($P($G(^AUPNVSIT(VSIT,0)),U),".")
 ;PATCH 2
 ;S:'VSIT X=$P($G(^AUPNPAT(+$G(INDA),11)),U,11)
 S:'X X=$P($G(^DPT(+INDA,0)),U,3)
 S:'X X=DT
 S X=X+17000000
 Q X
 ;-----
VT(INDA) ;EP;TO RETURN LAST VISIT TYPE
 ;PATCH 2
 N X,Y,Z
 S X=+$O(^AUPNVSIT("AC",INDA,9999999999),-1)
 Q:'X ""
 S Y=$P($G(^AUPNVSIT(X,0)),".")+17000000
 Q:Y=17000000 ""
 S X=$P($G(^AUPNVSIT(X,0)),U,3)
 S X=$S(X="I":1,X="C":2,X="T":4,X="O":5,X=6:6,X="V":7,X="P":8,X="U":9,1:"")
 Q:X="" ""
 ;S Y="IHS0"_X_U_($P(^AUPNVSIT(VSIT,0),".")+17000000)
 S Y="IHS0"_X_U_Y
 Q Y
 ;-----
RACE(INDA) ;EP;TO RETURN RACE
 N X
 I '$G(INDA) Q "^UNKNOWN^HL70005"
 S X=$P($G(^DPT(INDA,0)),U,6)
 S:X X=$P($G(^DIC(10,X,0)),U,3)_U_$P($G(^DIC(10,X,0)),U)
 S:X=""!(X=U) X=$P($G(^AUPNPAT(INDA,11)),U,11)
 S:X=1 X="1002-5^AMERICAN INDIAN OR ALASKA NATIVE"
 S:$P(X,U,2)="" X="^UNKNOWN"
 Q (X_"^HL70005")
 ;-----
ETH(DFN)  ;EP;TO RETURN ETHNICITY
 N X,Y,Z
 S Z=""
 I '$G(DFN)!'$O(^DPT(+$G(DFN),.06,0)) Q Z
 S X=0
 F  S X=$O(^DPT(DFN,.06,X)) Q:'X  D
 .S Y=$P($G(^DIC(10.2,X,0)),U,3)_U_$P($G(^DIC(10.2,X,0)),U)
 .Q:Y=U
 .S Y=Y_"^HL70006"
 .S Z=$S(Z]"":(Z_"~"),1:"")_Y
 Q Z
 ;-----
RT ;EP;FOR REAL TIME QUERIES
 K ^TMP($J,"BYIM RT")
 N DFN
 W @IOF
 W !!?10,"Real Time Queries"
 K DIR
 S DIR(0)="SO^1:Query for Vaccination Record (VXQ);2:Unsolicited Vaccine Record Update (VXU)"
 S DIR("A")="Select the action type"
 D ^DIR
 K DIR
 Q:'Y
 S RT=$S(Y=1:"VXQ",1:"VXU")
 D PAT
 Q:'$G(DFN)
 D SEND
 Q
 ;-----
PAT ;
 W !!,"Select patient(s) to send to the State Immunization Registry"
 F  D P1 Q:$D(BYIMQUIT)
 K BYIMQUIT
 Q
P1 ;SELECT MULTIPE PATIENTS
 K DIC
 S DIC=9000001
 S DIC("A")="Select "_$S($D(^TMP($J,"BYIM RT")):"another ",1:"")_"patient: "
 S DIC(0)="AEQM"
 W !
 D ^DIC
 I Y<1 S BYIMQUIT="" Q
 S ^TMP($J,"BYIM RT",+Y)=""
 Q
 ;-----
SEND ;SEND RT QUERY
 W !!,$S(RT="VXQ":"A 'Query for Vaccination Record (VXQ)'",1:"An 'Unsolicited Vaccine Record Update (VXU)'")," will be sent for:"
 S DFN=0
 F  S DFN=$O(^TMP($J,"BYIM RT",DFN)) Q:'DFN  D
 .W !," *** ",$P(^DPT(DFN,0),U)," *** "
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Do you want to proceed"
 S DIR("B")="YES"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
 F  S DFN=$O(^TMP($J,"BYIM RT",DFN)) Q:'DFN  D
 .D:RT="VXQ" VXQ(DFN)
 .D:RT="VXU" VXU(DFN)
 .K ^TMP($J,"BYIM RT",DFN)
 K ^TMP($J,"BYIM RT")
 Q
 ;-----
VXQ(DFN) ;EP;TO SEND VXQ MESSAGE
 Q
 ;-----
VXU(DFN) ;EP;TO SEND VXU MESSAGE
 Q
 ;-----
TEST ;EP;CREATE & SEND TEST MESSAGES
 W @IOF
 W !!?10,"TEST export option"
 W !!?10,"An export file will be created for patients"
 W !?10,"18 years of age or under."
 W !!
 K DIR
 S DIR(0)="NO^10:999"
 S DIR("A",1)="Enter the number of patients"
 S DIR("A")="to include in the test export"
 S DIR("B")="10"
 D ^DIR
 K DIR
 Q:'Y
 S BYIMTEST=Y
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Proceed with test export of "_BYIMTEST_" patients"
 S DIR("B")="NO"
 W !!
 D ^DIR
 K DIR
 Q:'Y
 K ^BYIMTMP($J,"BYIM EXP")
 N XX,X,Y,Z,DOB,DFN,VIS,J
 S J=0
 S XX=$P(^AUPNVIMM(0),U,3)-$R(1000)
 F  S XX=$O(^AUPNVIMM(XX),-1) Q:'XX!(J>BYIMTEST)  S X=^(XX,0) D
 .S DFN=$P(X,U,2)
 .S VIS=$P(X,U,3)
 .Q:$D(^BYIMTMP($J,"BYIM EXP",DFN))
 .S DOB=$P(^DPT(DFN,0),U,3)
 .Q:DOB<(DT-180000)
 .S ^BYIMTMP($J,"BYIM EXP",DFN,VIS)=""
 .S J=J+1
 S MSGCNT=BYIMTEST+1
 S CHILD="Children"
 S YEARS=19
 S XX=$P($H,",",2)
 D DEX^BYIMIMM
 Q
 ;-----
IZV04 ;IMMUNIZATION DATA EXCHANGE
 S BHLDEST="D DEST^INHUSEN"
 S INDEST("VXUV04")="HL IHS IZV04 IN"
 X BHLDEST
 Q
 ;-----
LOC ;EP;TO CHECK LOC. OF ENCOUNTER VERSUS OUTSIDE LOCATION
 ;PATCH 2
 N BYIMUDA,BYIMVDA,BYIMLDA,BYIMLODA
 S BYIMUDA=$O(^VA(200,"B","USER,IMMUNIZATION INTERFACE",0))
 Q:'BYIMUDA
 S BYIMVDA=0
 F  S BYIMVDA=$O(^AUPNVIMM("AD",BYIMVDA)) Q:'BYIMVDA  D
 .S X=$G(^AUPNVSIT(BYIMVDA,0))
 .Q:$P(X,U,23)'=BYIMUDA&($P(X,U,27)'=BYIMUDA)
 .S BYIMLDA=$P($G(^AUPNVSIT(BYIMVDA,0)),U,6)
 .Q:$P($G(^DIC(4,+BYIMLDA,0)),U)'="OTHER"
 .S BYIMLODA=$P($G(^AUPNVSIT(BYIMVDA,21)),U)
 .Q:BYIMLODA=""
 .S X=BYIMLODA
 .X ^%ZOSF("UPPERCASE")
 .S BYIMLODA=Y
 .Q:BYIMLODA["OTHER"
 .S BYIMLODA=$O(^DIC(4,"B",BYIMLODA,0))
 .Q:'BYIMLODA
 .S DR=".06////"_BYIMLODA
 .S DIE="^AUPNVSIT("
 .S DA=BYIMVDA
 .D ^DIE
 .I $E($G(IOST),1,2)="C-" W "."
 Q
 ;-----
PROT(INDA) ;EP;TO DETERMINE PROTECTION FLAG
 Q:'INDA ""
 N X
 S X=$P($G(^BIP(+$G(INDA),2)),U),X=$S(X=1:"Y",X=0:"N",1:"")
 Q X
 ;-----
