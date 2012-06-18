APSPELRX ;IHS/MSC/PLS - Electronic Pharmacy Support ;05-May-2011 10:16;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1006,1008,1009,1011**;Sep 23, 2004;Build 17
EN(RX,PHARM) ;EP
 I $G(RX),$G(PHARM) D
 .I $$SS(RX,PHARM) D
 ..D BRDCAST(RX,PHARM)
 .E  I $$FX(PHARM) D
 ..D FAX(RX,PHARM)
 .D PEI(RX)
 Q
 ; Called by APSPELRX PSCRIPT RPC
 ; Returns prescription text
 ; Input: ORIFN: IEN to Order File
 ;        RXNUM: Prescription number (external)
 ; Output: Array of text
PSCRIPT(DATA,ORIFN,RXNUM) ;EP
 N RX,RX1
 S RX=$G(^OR(100,ORIFN,4))
 S RX1=$O(^PSRX("B",RXNUM,0))
 S DATA=$$TMPGBL^CIAVMRPC
 ;I RX'=RX1 S @DATA@(1)="Incorrect information passed."
 ;E  D
 D CAPTURE^CIAUHFS("D FAXRX^APSPELRX",DATA)
 Q
 ;
BRDCAST(RX,PHARM) ;EP
 N ORIFN,RRIEN
 S ORIFN=+$P($G(^PSRX(RX,"OR1")),U,2)
 S RRIEN=$$VALUE^ORCSAVE2(ORIFN,"SSRREQIEN")
 ; Check med class
 ; If III-V
 I $$DEACLS^APSPES2($$DEA^APSPES2($P($G(^PSRX(RX,0)),U,6)),"345") D  Q
 .D DENY^APSPES3(ORIFN,RX,"RP","A new prescription for a controlled substance is being faxed.",5)
 .D FAX(RX,PHARM)
 I RRIEN D
 .D ACCEPT^APSPES3(RX,ORIFN)
 E  D NEWRX^APSPES1(RX)
 Q
 ;
FAX(RX,PHARM) ;EP
 N FSRV,FFNUM,FCLNAM,FDT,FJOBNM,DATA,ARY
 S FSRV=$$GET^XPAR("ALL","APSP AUTO RX FAX SERVER PATH")
 Q:'$L(FSRV)
 S FFNUM=$$GET^XPAR("ALL","APSP AUTO RX FAXED FROM NUMBER")
 S FCLNAM=$$GET1^DIQ(9009033.9,PHARM,.01),FCLNAM=$TR(FCLNAM," ","_")
 S FCLNAM=$TR(FCLNAM,"\/:*?<>","")
 S FAXNUM=$$GET1^DIQ(9009033.9,PHARM,2.2)
 S FDT=$$NOW^XLFDT(),FDT=$P(FDT,".")_"Z"_$P(FDT,".",2)
 S FJOBNM=RX_"Z"_FDT
 D OPEN^%ZISH("APSPFAX",FSRV,FJOBNM_"+"_FCLNAM_"@"_FAXNUM_".TXT","A")
 Q:POP
 U IO
 D FAXRX
 D CLOSE^%ZISH("APSPFAX")
 S ARY("REASON")="X"
 S ARY("TYPE")="T"
 S ARY("COM")="Faxed to: "_FCLNAM_" @ "_FAXNUM
 S ARY("RX REF")=0
 D UPTLOG^APSPFNC2(.DATA,RX,0,.ARY)
 Q
 ; Write out prescription information
FAXRX ;EP
 ;TODO - ADD NOTE FOR CLASS III-V IF ORDER CONTAINS SSREFREQ
 N DFN,PDIV,RX0,RX2,RX3,PDIV0,PSZIP,DASH
 N PNM,ADDR,VA,DEASCH,HLOC,INST
 N DRUG,DRUGNM,TRDNM,SIGNER
 N VANUM,DEA,DXCODE,ORIFN
 S RX0=^PSRX(RX,0)
 S RX2=^PSRX(RX,2)
 S RX3=^PSRX(RX,3)
 ;
 S DRUG=$P(RX0,U,6)
 S DRUGNM=$$GET1^DIQ(50,DRUG,.01)
 S TRDNM=$$GETDTNM(DRUG)
 S DEASCH=$$GET1^DIQ(50,DRUG,3)
 ;
 S PDIV=$P(RX2,U,9)
 S PDIV0=^PS(59,PDIV,0)
 S PDIVZIP=$P(PDIV0,U,5)
 ;
 S DFN=$P(RX0,U,2)
 S PNM=$$GET1^DIQ(2,DFN,.01)
 D PID^VADPT
 D PTADD(DFN,.ADDR)
 S HLOC=$P(RX0,U,5)
 S INST=+$$GET1^DIQ(44,HLOC,3)
 S:'INST INST=DUZ(2)
 ;
 S SIGNER=+$P($G(^OR(100,+$P($G(^PSRX(RX,"OR1")),U,2),8,1,0)),U,5)
 S DEA=$$GET1^DIQ(200,SIGNER,53.2,"I")  ;DEA #
 S VANUM=$$GET1^DIQ(200,SIGNER,53.3,"I") ; VA #
 S DXCODE=$$GET1^DIQ(52,RX,9999999.22)
 S ORIFN=+$P($G(^PSRX(RX,"OR1")),U,2)
 ;
 S $P(DASH,"-",63)="-"
 ; Output Address
 ; Pharmacy Division Mailing Info
 ;W $P(PDIV0,U)
 ;W !,$P(PDIV0,U,7)_","_$$GET1^DIQ(5,$P(PDIV0,U,8),1)_"  "_$S(PDIVZIP["-":PDIVZIP,1:$E(PDIVZIP,1,5)_$S($E(PDIVZIP,6,9)]"":"-"_$E(PDIVZIP,6,9),1:""))
 ;W !,$P(PDIV0,U,3)_"-"_$P(PDIV0,U,4)
 ; Institution Mailing Info
 W $$GET1^DIQ(4,INST,.01)
 W !,$$GET1^DIQ(4,INST,1.01)  ;Street Address 1
 W !,$$GET1^DIQ(4,INST,1.03)_", "_$$GET1^DIQ(4,INST,.02)_"  "_$$GET1^DIQ(4,INST,1.04)
 W !,$$GET1^DIQ(9999999.06,INST,.13)
 W !!,DASH,!
 ; Output Patient Info
 W !,"Rx for: "_PNM_"  "_VA("PID")_"     DOB:"_$$UP^XLFSTR($$FMTE^XLFDT($$GET1^DIQ(2,DFN,.03,"I")))  ;Patch 1009
 W !,?8,ADDR(1)
 W !,?8,ADDR(2)
 W:$L(ADDR(3)) !,?8,ADDR(3)
 W !,?8,ADDR(33)
 W !,DASH,!
 W !,DRUGNM
 W:$L(TRDNM) !,"Also known as: "_TRDNM ; todo - make parameter or field to control display
 W !!,"Pharmacy may choose strength(s) of drug to meet requirements of directions."
 W !
 D SIG(RX)
 W !!,"   Dispense: ",$P(RX0,U,7)_"  "_$P($G(^PSDRUG(DRUG,660)),U,8)
 W "      Pharmacy to adjust qty for # of days."
 W !,"Days Supply: ",$P(RX0,U,8)
 W !,"  Refill(s): ",$P(RX0,U,9)
 W !," Issue Date: ",$$GET1^DIQ(52,RX,1)
 W !,"  Indicator: ",$$GET1^DIQ(52,RX,9999999.21)_$S($L(DXCODE):"  ("_DXCODE_")",1:"")
 ;W !,?8,"DOB: ",$$UP^XLFSTR($$FMTE^XLFDT($$GET1^DIQ(2,DFN,.03,"I")))  ;Patch 1009
 W !
 D PRC(RX)
 W !
 W !,"Signed: /ES/"_$$GET1^DIQ(200,SIGNER,.01)_"   "_VANUM_$S(+DEASCH&(DEASCH<6):"   "_DEA,1:"")  ;DEA PRINTS FOR SCH 1-5
 W:$$SUBS(RX) !!,"DISPENSE AS WRITTEN"
 I $$DEACLS^APSPES2($$DEA^APSPES2($P(RX0,U,6)),"345") D
 .Q:'$$VALUE^ORCSAVE2(+$P($G(^PSRX(RX,"OR1")),U,2),"SSRREQIEN")  ; Must be in response to a refill request
 .W !,"NOTE: This schedule III-V prescription is being faxed."
 ;
 W:$L($G(FFNUM)) !!,"Faxed from: ",FFNUM," ON ",$$FMTE^XLFDT($$NOW^XLFDT)
 Q
SS(RXIEN,PIEN) ;EP
 Q:'$G(RXIEN)!'$G(PIEN) 0
 N ND7,SVCL,SDT,EDT,NOW,SPI
 S SPI=$$SPI^APSPES1(+$$GET1^DIQ(52,RXIEN,4,"I"))
 S NOW=$$NOW^XLFDT
 S ND7=$G(^APSPOPHM(PIEN,7))
 S SVCL=$P($G(^APSPOPHM(PIEN,0)),U,5)  ;Service Level
 S SDT=$P(ND7,U)
 S EDT=$P(ND7,U,2)
 Q $L(SPI)&(SVCL#2)&(NOW>SDT)&(NOW<EDT)
 ; Called by DC^ORWDXA when unreleased order is discontinued (denied)
 ; Input: ORID - ^OR(100 ien
DC(ORID) ; EP -
 ; Send denial HL7 message
 D DENY^APSPES3(ORID)
 Q
 ; Return fax number or flag indicating a fax number is present
FX(PIEN,FLG) ;EP
 Q:'$G(PIEN) 0
 N FNUM
 S FNUM=$$GET1^DIQ(9009033.9,PIEN,2.2)
 Q $S($G(FLG):FNUM,1:''FNUM)
 ; Return Trade Name Synonym for given drug (if defined)
GETDTNM(DIEN) ;EP
 N LP,FLG,RET
 S LP=0,RET=""
 S FLG=0
 F  S LP=$O(^PSDRUG(DIEN,1,LP)) Q:'LP!(FLG)  D
 .S:$P(^PSDRUG(DIEN,1,LP,0),U,3)=0 RET=$P(^(0),U),FLG=1
 Q RET
 ; Output Provider Comments
PRC(RX) ;EP
 K ^UTILITY($J,"W")
 N DIWL,DIWR,DIWF,LP,X
 S DIWL=0,DIWR=48,DIWF=""
 S LP=0 F  S LP=$O(^PSRX(RX,"PRC",LP)) Q:'LP  D
 .I $D(^(LP,0)) S X=^(0) D ^DIWP
 I $D(^UTILITY($J,"W")) D
 .W "MD Comments:"
 .S LP=0 F  S LP=$O(^UTILITY($J,"W",DIWL,LP)) Q:'LP  W ?13,^(LP,0),!
 K ^UTILITY($J,"W")
 Q
 ; Output SIG
SIG(RX) ;EP
 N LP
 S LP=0 F  S LP=$O(^PSRX(RX,"SIG1",LP)) Q:'LP  D
 .W !,^PSRX(RX,"SIG1",LP,0)
 Q
 ; Collect patient address information
PTADD(DFN,ARY) ;EP
 N VADM,VAEL,VAERR,VAPA
 D 6^VADPT
 S ARY(1)=VAPA(1)
 S ARY(2)=VAPA(2),ARY(3)=VAPA(3),ARY(4)=""
 I VAPA(2)'="",VAPA(3)="" S ARY(2)=VAPA(2),ARY(3)=ARY(4),ARY(4)=""
 I VAPA(2)="",VAPA(3)'="" S ARY(2)=VAPA(3),ARY(3)=VAPA(4),ARY(4)=""
 S ARY(33)=$G(VAPA(4))_", "_$P($G(VAPA(5)),"^",2)_"  "_$S($G(VAPA(11))]"":$P($G(VAPA(11)),"^",2),1:$G(VAPA(6)))
 Q
 ; Check Substitution Flag
SUBS(RX) ;EP -
 N VAL
 S VAL=$$GET1^DIQ(52,RX,9999999.25,"I")
 Q $S((VAL=1)!(VAL=7):1,1:0)
 ; Populate the Pharmacy External Interface File
PEI(RX) ; EP
 N FDA,ERR,IENS
 Q:'$G(RX)
 S IENS="+1,"
 S FDA(52.51,IENS,.01)=RX
 S FDA(52.51,IENS,2)=$P(^PSRX(RX,0),U,2)  ; Patient
 S FDA(52.51,IENS,3)=$$NOW^XLFDT()
 S FDA(52.51,IENS,4)=$P(^PSRX(RX,0),U,4)  ; Provider
 S FDA(52.51,IENS,8)="F"
 S FDA(52.51,IENS,9)=0
 S FDA(52.51,IENS,13)="E-PRESCRIBING MESSAGE"
 S FDA(52.51,IENS,14)=2
 D UPDATE^DIE(,"FDA",,"ERR")
 Q
