BDGF2 ; IHS/ANMC/LJF - PAT INFO FUNCTION CALLS ;  [ 06/01/2004  4:15 PM ]
 ;;5.3;PIMS;**1001,1003,1004,1005,1007,1008,1009**;MAY 28, 2004
 ;IHS/ITSC/WAR 05/24/2004 PATCH 1001 Phoenix style terminla digit logic
 ;IHS/ITSC/LJF 05/13/2005 PATCH 1003 added EP; to CWAD, AGE & INS subroutines
 ;             06/10/2005 PATCH 1003 terminal digit calculation now parameter driven
 ;             06/16/2005 PATCH 1003 rewrote medicaid subroutine
 ;IHS/OIT/LJF  07/27/2005 PATCH 1004 rewrote medicaid subrtn again
 ;             11/04/2005 PATCH 1004 new HRCN subroutine added
 ;             12/29/2005 PATCH 1005 removed AGE subroutine - using official API now
 ;             04/14/2006 PATCH 1005 made HRCNF into a public entry point
 ;cmi/anch/maw 02/21/2007 PATCH 1007 item 1007.37 modified MCD and MCR not to print "exp" if no expiration date
 ;cmi/anch/maw 05/08/2008 PATCH 1009 requirement 22 and 31 added NEWINS subroutine
 ;
HRCN(PAT,SITE) ;EP; return chart number for patient at this site
 ;called by ADT ITEMS file
 I $G(PAT)="" Q ""  ;cmi/maw 6/12/2008 PATCH 1009 added for missing pat node in file 44 for appt
 Q $P($G(^AUPNPAT(PAT,41,SITE,0)),U,2)
 ;
HRCND(X) ;EP; add dashes to chart # passed as X
 ;called by ADT ITEMS file
 S X="00000"_X,X=$E(X,$L(X)-5,$L(X))
 S X=$E(X,1,2)_"-"_$E(X,3,4)_"-"_$E(X,5,6)
 Q X
 ;
HRCNT(X) ;EP; return terminal digit format of chart # passed as X
 ;IHS/ITSC/LJF 6/10/2005 PATCH 1003 rewritten to use terminal digit calculation parameter
 NEW STYLE S STYLE=$$GET1^DIQ(9009020.2,$$DIV^BSDU,.09,"I") I STYLE="" S STYLE="A"
 S X="00000"_X,X=$E(X,$L(X)-5,$L(X))
 I STYLE="A" S X=$E(X,5,6)_"-"_$E(X,3,4)_"-"_$E(X,1,2)
 E  S X=$E(X,5,6)_"-"_$E(X,1,2)_"-"_$E(X,3,4)
 Q X
 ;
 ;IHS/OIT/LJF 11/04/2005 PATCH 1004 new subroutine (called by DGPWBD for barcoding)
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 made into a PEP
HRCNF(PAT,SITE) ;PEP; return facility code and chart # with leading zeros
 NEW C,F
 S F=$$GET1^DIQ(9999999.06,+$G(SITE),.12),F=$$PAD(F,6)
 S C=$$HRCN(+$G(PAT),+$G(SITE)) S C="00000"_C,C=$E(C,$L(C)-5,$L(C))
 Q F_C
 ;
IEN(X) ;EP; return IEN for chart # passed in X
 NEW Y S Y=0
 F  S Y=$O(^AUPNPAT("D",X,Y)) Q:'Y  Q:$O(^AUPNPAT("D",X,Y,0))=$G(DUZ(2))
 Q +$G(Y)
 ;
NAMEPRT(DFN,CONVERT) ;EP; return printable name
 ;CONVERT=1 means convert to mixed case letters
 NEW VADM,X
 D DEM^VADPT
 S X=$P($P(VADM(1),",",2)," ")_" "_$P(VADM(1),",")
 I $G(CONVERT) X ^DD("FUNC",14,1)
 Q X
 ;
INSUR(PAT,DATE) ;EP; returns insurance info on DATE sent
 NEW INS,X
 S INS=""
 S X=$$MCR^AUPNPAT(PAT,DATE) I X=1 S INS="MCR/"
 S X=$$MCD^AUPNPAT(PAT,DATE) I X=1 S INS=INS_"MCD/"
 S X=$$RR^AUPNPAT(PAT,DATE) I X=1 S INS=INS_"RR/"  ;cmi/maw PATCH 1009 requirement 71
 S X=$$PI^AUPNPAT(PAT,DATE) I X=1 S INS=INS_"PVT/"
 I $L(INS)>3 S INS=$E(INS,1,$L(INS)-1)
 I INS="" S INS="IHS"
 Q $G(INS)
 ;
NEWINS(P,A,T) ;-- make new insurance call here and then parse based on file number
 K BDGNINS,N,BDGRR
 N DATE,N
 I $G(A) S DATE=+$$GET1^DIQ(405,A,.01,"I")
 I '$G(DATE) S DATE=DT
 D GETELIG^AGAPIS(.BDGNINS,P,DATE,"E","",0)  ;cmi/maw 8/4/2008 changed category back to null from M only PATCH 1009
 Q:$G(T)=""
 N DA,PR,IN,FL
 S DA=0 F  S DA=$O(BDGNINS(DA)) Q:DA=""  D
 . S PR=0 F  S PR=$O(BDGNINS(DA,PR)) Q:'PR  D
 .. S IN=0 F  S IN=$O(BDGNINS(DA,PR,IN)) Q:'IN  D
 ... S FL=0 F  S FL=$O(BDGNINS(DA,PR,IN,FL)) Q:FL=""  D
 .... I T="MCR",FL'=9000003 D
 ..... I FL'=9000003.11 K BDGNINS(DA,PR) Q
 ..... S BDGCOV=1
 ..... S N="Medicare #"_$G(BDGNINS(DA,PR,IN,9000003,P_",",.03,"E"))_$G(BDGNINS(DA,PR,IN,9000003,P_",",.04,"E"))
 ..... N BIENS
 ..... S BIENS=0 F  S BIENS=$O(BDGNINS(DA,PR,IN,9000003.11,BIENS)) Q:BIENS=""  D
 ...... I $G(BDGNINS(DA,PR,IN,9000003.11,BIENS,.02,"E")) S N=N_" exp "_$G(BDGNINS(DA,PR,IN,9000003.11,BIENS,.02,"E"))
 .... I T="MCD",FL'=9000004 D
 ..... I FL'=9000004.11 K BDGNINS(DA,PR) Q
 ..... N BIEN
 ..... S BIEN=0 F  S BIEN=$O(BDGNINS(DA,PR,IN,9000004,BIEN)) Q:BIEN=""  D
 ...... S N=$S($G(BDGNINS(DA,PR,IN,9000004,BIEN,.11,"E"))]"":$E($G(BDGNINS(DA,PR,IN,9000004,BIEN,.11,"E")),1,15),1:"Medicaid")_" #"_$G(BDGNINS(DA,PR,IN,9000004,BIEN,.03,"E"))
 ..... S BDGCOV=1
 ..... N BIENS
 ..... S BIENS=0 F  S BIENS=$O(BDGNINS(DA,PR,IN,9000004.11,BIENS)) Q:BIENS=""  D
 ...... I $G(BDGNINS(DA,PR,IN,9000004.11,BIENS,.02,"E")) S N=N_" exp "_$G(BDGNINS(DA,PR,IN,9000004.11,BIENS,.02,"E"))
 .... I T="PI" D
 ..... I FL=9000003.1 K BDGNINS(DA,PR,IN,9000003.1) Q
 ..... I FL'=9000006.11,FL'=9000003.1 K BDGNINS(DA,PR) Q
 ..... N BIENS
 ..... S BDGCOV=1
 ..... S BIENS=0 F  S BIENS=$O(BDGNINS(DA,PR,IN,9000006.11,BIENS)) Q:BIENS=""  D
 ...... S BDGRR($P(BIENS,","))=$E($G(BDGNINS(DA,PR,IN,9000006.11,BIENS,.01,"E")),1,23)_" #"_$P($G(^AUPNPRVT(P,11,$P(BIENS,","),0)),U,2)
 ...... ;I $G(BDGNINS(DA,PR,IN,9000006.11,BIENS,.02,"E")) S N=N_" exp "_$G(BDGNINS(DA,PR,IN,9000006.11,BIENS,.02,"E"))
 ..... K BDGNINS(DA,PR)
 .... I T="RR" D
 ..... I FL'=9000005 K BDGNINS(DA,PR) Q
 ..... S N="Railroad #"_$G(BDGNINS(DA,PR,IN,9000005,P_",",.04,"E"))_$G(BDGNINS(DA,PR,IN,9000005,P_",",.03,"E"))
 ..... S BDGCOV=1
 ..... N BIENS
 ..... S BIENS=0 F  S BIENS=$O(BDGNINS(DA,PR,IN,9000005.11,BIENS)) Q:BIENS=""  D
 ...... I $G(BDGNINS(DA,PR,IN,9000005.11,BIENS,.02,"E")) S N=N_" exp "_$G(BDGNINS(DA,PR,IN,9000005.11,BIENS,.02,"E"))
 Q $G(N)
 ;
MCR(PAT,ADM,EXP) ;EP; medicare coverage for patient (PAT) at admission (ADM)
 ; returns medicare # & suffix and optionally expiration date
 ; If EXP=1 returns expiration date
 ;called by ADT ITEMS file
 NEW IEN,X,N,DATE
 I ('PAT)!('ADM) Q ""
 S IEN=$O(^AUPNMCR("B",PAT,0)) I IEN="" Q ""               ;no coverage
 S DATE=+$$GET1^DIQ(405,ADM,.01,"I")                       ;admit date
 S X=0 F  S X=$O(^AUPNMCR(IEN,"11",X)) Q:'X  Q:$G(N)]""  D
 . Q:$P(^AUPNMCR(IEN,11,X,0),U)>DATE                 ;covrg not started
 . I $P($G(^AUPNMCR(IEN,11,X,0)),U,2)]"",$P(^(0),U,2)<DATE Q  ;stopped
 . S N=$$GET1^DIQ(9000003,IEN,.03)_$$GET1^DIQ(9000003,IEN,.04)
 . ;I $G(EXP) S N=N_" exp "_$$FMTE^XLFDT($P($G(^AUPNMCR(IEN,11,X,0)),U,2),2)  ;cmi/anch/maw 2/21/2007 orig line PATCH 1007 item 1007.37
 . I $G(EXP) S N=N_$S($P($G(^AUPNMCR(IEN,11,X,0)),U,2)]"":" exp "_$$FMTE^XLFDT($P($G(^AUPNMCR(IEN,11,X,0)),U,2),2),1:"")  ;cmi/anch/maw 2/21/2007 new line to not print exp if no expiration date PATCH 1007 item 1007.37
 I $G(N)="" Q ""
 S BDGCOV=1    ;patient has coverage
 Q "Medicare #"_$G(N)
 ;
 ;IHS/ITSC/LJF 6/16/2005 PATCH 1003 rewrote following subroutine
 ;IHS/OIT/LJF 7/27/2005 PATCH 1004 rewrote code for sites that do not store a MCD name
MCD(PAT,ADM,EXP) ;EP; medicaid coverage for patient PAT at admission ADM
 ; returns medicaid # if patient coverage on admit date
 ; EXP (optional), if set to 1, return expiration date
 ;called by ADT ITEMS file
 NEW IEN,IEN2,NUM,DATE,NAME
 S DATE=+$$GET1^DIQ(405,ADM,.01,"I")                           ;admit date
 I '$$MCD^AUPNPAT(PAT,DATE) Q ""                               ;no coverage
 S IEN=0 F  S IEN=$O(^AUPNMCD("B",PAT,IEN)) Q:'IEN  Q:$G(NUM)]""  D
 . S IEN2=0 F  S IEN2=$O(^AUPNMCD(IEN,"11",IEN2)) Q:'IEN2  Q:$G(NUM)]""  D
 . . Q:$P(^AUPNMCD(IEN,11,IEN2,0),U)>DATE                      ;covrg not started
 . . I $P(^AUPNMCD(IEN,11,IEN2,0),U,2)]"",$P(^(0),U,2)<DATE Q  ;covrg stoppd
 . . ;S NAME=$$GET1^DIQ(9000004,IEN,.11)                       ;plan name  cmi/maw 4/15/2008 orig line
 . . S NAME=$E($$GET1^DIQ(9000004,IEN,.11),1,15)                        ;plan name  cmi/maw 4/15/2008 modified line due to date being cut off
 . . S NUM=$$GET1^DIQ(9000004,IEN,.03)                         ;medicaid #
 . . ;I $G(EXP) S NUM=NUM_" exp "_$$FMTE^XLFDT($P($G(^AUPNMCD(IEN,11,IEN2,0)),U,2),2)  ;cmi/anch/maw 2/21/2007 orig line PATCH 1007 item 1007.37
 . . I $G(EXP) S NUM=NUM_$S($P($G(^AUPNMCD(IEN,11,IEN2,0)),U,2)]"":" exp "_$$FMTE^XLFDT($P($G(^AUPNMCD(IEN,11,IEN2,0)),U,2),2),1:"")  ;cmi/anch/maw 2/21/2007 new line to not print exp if not expiration date PATCH 1007 item 1007.37
 I $G(NUM)="" Q ""
 I $G(NAME)="" S NAME="Medicaid"
 S BDGCOV=1    ;patient has coverage
 Q NAME_" #"_$G(NUM)
 ;
RR(PAT,ADM,EXP) ;EP; railroad retirment coverage for patient at admission
 ; If EXP=1 returns expiration date
 ;called by ADT ITEMS file
 NEW IEN,X,N,DATE
 S IEN=$O(^AUPNRRE("B",PAT,0)) I IEN="" Q ""    ;no coverage
 S DATE=+$$GET1^DIQ(405,ADM,.01,"I")                       ;admit date
 S X=0 F  S X=$O(^AUPNRRE(IEN,"11",X)) Q:'X  Q:$G(N)]""  D
 . Q:$P(^AUPNRRE(IEN,11,X,0),U)>DATE                 ;covrg not started
 . I $P(^AUPNRRE(IEN,11,X,0),U,2)]"",$P(^(0),U,2)<DATE Q  ;covrg stoppd
 . S N=$$GET1^DIQ(9000005,IEN,.03)_$$GET1^DIQ(9000005,IEN,.04)
 . I $G(EXP) S N=N_$S($P($G(^AUPNRRE(IEN,11,X,0)),U,2)]"":" exp "_$$FMTE^XLFDT($P($G(^AUPNRRE(IEN,11,X,0)),U,2),2),1:"")
 I $G(N)="" Q ""
 S BDGCOV=1
 Q "Railroad #"_$G(N)
 ;
INS(PAT,ADM,BDGRR) ;EP; -- private insurance for patient
 ; Returns BDGRR array
 NEW IEN,X,N,DATE,NAME
 K BDGRR S IEN=$O(^AUPNPRVT("B",PAT,0)) I 'IEN Q       ;no insurance
 S DATE=+$$GET1^DIQ(405,ADM,.01,"I")                       ;admit date
 S X=0 F  S X=$O(^AUPNPRVT(IEN,"11",X)) Q:'X  D
 . Q:$P(^AUPNPRVT(IEN,11,X,0),U,6)>DATE              ;covrg not started
 . I $P(^AUPNPRVT(IEN,11,X,0),U,7)]"",$P(^(0),U,7)<DATE Q  ;covrg stoppd
 . S N=$P(^AUPNPRVT(IEN,"11",X,0),U,2)
 . ;S NAME=$$GET1^DIQ(9999999.18,+^AUPNPRVT(IEN,11,X,0),.01)  ;cmi/maw 4/15/2008 orig line
 . S NAME=$E($$GET1^DIQ(9999999.18,+^AUPNPRVT(IEN,11,X,0),.01),1,23)  ;cmi/maw 4/15/2008 modified for name length on a sheet
 . S BDGRR(X)=NAME_"  #"_N                      ;policy name & #
 I '$D(BDGRR) Q
 S BDGCOV=1    ;patient has coverage
 Q
 ;
STATUS(PAT) ;PEP; returns patient's current status
 NEW X
 I $$DEAD(PAT) Q "Patient Died on "_$$GET1^DIQ(2,PAT,.351)
 ;
 ;IHS/ITSC/WAR 5/5/03 P67 mod to handle trucated displayed field
 ;I $D(^DPT(PAT,.1)) D  Q "Patient currently an "_X_" on "_^DPT(PAT,.1)_Y
 I $D(^DPT(PAT,.1)) D  Q "Pt currently an "_X_" on "_^DPT(PAT,.1)_Y
 . I $$GET1^DIQ(2,PAT,.103)["OBSERVATION" S X="Observation Patient"
 . E  S X="Inpatient"
 . S Y=$$GET1^DIQ(2,PAT,401.3) I Y]"" S Y=" ("_Y_")"
 ;
 I $O(^ADGIC(DFN,"D",0)) Q "Active Incomplete Chart"
 I $O(^ADGDSI(DFN,"DT",0)) Q "Active Day Surgery Incomplete Chart"
 ;
 S X=$O(^ADGDS(DFN,"DS",DT)) I X\1=DT Q "Active Day Surgery Patient"
 NEW DATE,X S DATE=9999999-DT,X=DATE-.0001
 S X=$O(^SRF("AIHS3",DFN,X))
 I X\1=DATE Q "Day Surgery/Same Day Admit Patient"
 ;
 Q "Outpatient"
 ;
CWAD(PAT) ;EP; -- returns cwad initials for patient PAT;IHS/ITSC/LJF PATCH 1003
 NEW X,DFN,GMRPCWAD
 S X="GMRPNOR1" X ^%ZOSF("TEST") I '$T Q "       "
 S X=$$CWAD^GMRPNOR1(+PAT) I '$L(X) Q "       "
 S X="<"_X_">",X=$E(X_"       ",1,7)
 Q X
 ;
DEAD(PAT) ;EP; returns 1 if patient has died
 Q $S($G(^DPT(PAT,.35)):1,1:0)
 ;
DOD(PAT) ;EP; returns patient's date of death
 Q $$GET1^DIQ(2,PAT,.351)
 ;
LASTREG(PAT) ;EP; returns date of last Registration update
 Q $$GET1^DIQ(9000001,PAT,.03)
 ;
COMMCOD(PAT) ;EP; returns formatted current community code
 ;called by ADT ITEMS file
 I '$G(PAT) Q ""
 NEW X
 S X=$$GET1^DIQ(9999999.05,+$$GET1^DIQ(9000001,PAT,1117,"I"),.08)
 ;IHS/ITSC/WAR 6/1/2004 PATCH #1001 correct the order of display
 ;Q $S(X="":"",1:$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,7))
 Q $S(X="":"",1:$E(X,5,7)_"-"_$E(X,3,4)_"-"_$E(X,1,2))
 ;
TRBCOD(PAT) ;EP; returns tribe and code
 ;called by ADT ITEMS file
 I '$G(PAT) Q ""
 NEW X,Y
 S X=$E($$GET1^DIQ(9000001,PAT,1108),1,3)   ;1st 3 letters of tribe
 S Y=$$GET1^DIQ(9999999.03,+$$GET1^DIQ(9000001,PAT,1108,"I"),.02)
 Q X_Y
 ;
ADDRS(PAT) ;EP; returns single line patient address
 ;called by ADT ITEMS file
 I '$G(PAT) Q ""
 NEW X
 I '$D(^DPT(PAT,.11)) Q ""
 S X=$$GET1^DIQ(2,DFN,.111)_" "_$$GET1^DIQ(2,DFN,.114)
 S X=X_", "_$$GET1^DIQ(5,+$$GET1^DIQ(2,DFN,.115,"I"),1)   ;state abbrev
 S X=X_" "_$$GET1^DIQ(2,DFN,.116)
 Q X
 ;
NOKADD(PAT) ;EP; returns single line address for patient's next of kin
 ;called by ADT ITEMS file
 I '$G(PAT) Q ""
 NEW X
 I '$D(^DPT(PAT,.21)) Q ""
 S X=$$GET1^DIQ(2,DFN,.213)_" "_$$GET1^DIQ(2,DFN,.216)
 S X=X_", "_$$GET1^DIQ(5,+$$GET1^DIQ(2,DFN,.217,"I"),1)   ;state abbrev
 S X=X_" "_$$GET1^DIQ(2,DFN,.218)
 Q X
 ;
ECADD(PAT) ;EP; returns single line address for patient's emergency contact
 ;called by ADT ITEMS file
 I '$G(PAT) Q ""
 NEW X
 I '$D(^DPT(PAT,.33)) Q ""
 S X=$$GET1^DIQ(2,DFN,.333)_" "_$$GET1^DIQ(2,DFN,.336)
 S X=X_", "_$$GET1^DIQ(5,+$$GET1^DIQ(2,DFN,.337,"I"),1)   ;state abbrev
 S X=X_" "_$$GET1^DIQ(2,DFN,.338)
 Q X
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
