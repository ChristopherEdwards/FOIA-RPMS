ABMDUTL ; IHS/ASDST/DMJ - UTILITY FOR 3P BILLING PACKAGE ;     
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ; IHS/SD/SDR - v2.5 p9 - IM12408 - Added code for inactive CPTs to check visit date
 ; IHS/SD/SDR - v2.5 p9 - IM16660 - Coded for 4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p10 - IM20454 - Fix xref on .03 field
 ; IHS/SD/SDR - v2.5 p11 - IM23431 - Fix lookup of HCPCS codes
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added new call BDT for complete date, includ. seconds
 ;
SDT(X) ;EP - Y is set to the printable date ##/##/#### from X (fileman date)
 N Y
 S Y=$S(+X>0:$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700),1:"")
 Q Y
POSDT(X) ;EP - Y is set to the printable date ## ## #### from X (fileman date)
 N Y
 S Y=$$SDT(X)
 S Y=$TR(Y,"/"," ")
 Q Y
 ;
HDT(X) ;EP - Y is set to the printable date ##-##-#### from X (fileman date)
 N Y
 S Y=$S(+X>0:$E(X,4,5)_"-"_$E(X,6,7)_"-"_($E(X,1,3)+1700),1:"")
 Q Y
 ;
CDT(X) ;EP - Y= date/time ##/##/####@##:## from X (fm date) for display in claim editor
 N Y
 I '+X S Y="" Q Y
 S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)
 I '$P(X,".",2) Q Y
 S ABMTIME=$P(X,".",2)
 S ABMTIME=ABMTIME_"00"
 S Y=Y_"@"_$E(ABMTIME,1,2)_":"_$E(ABMTIME,3,4)
 Q Y
 ;start new code abm*2.6*6 5010
BDT(X) ;EP - Y= date/time ##/##/####@##:##:## from X (fm date) for display in claim editor
 N Y
 I '+X S Y="" Q Y
 S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)
 I '$P(X,".",2) Q Y
 S ABMTIME=$P(X,".",2)
 S ABMTIME=ABMTIME_"00"
 S Y=Y_"@"_$E(ABMTIME,1,2)_":"_$E(ABMTIME,3,4)_":"_$E(ABMTIME,5,6)
 Q Y
 ;end new code 5010
MDT(X) ;EP - printable date and time in menu header format
 N Y
 S ABM("DATE")=+$E(X,6,7)_"-"_$P($T(MTHS+1),";;",+$E(X,4,5)+1)_"-"_($E(X,1,3)+1700)
 S ABM("TIME")=$P(X,".",2) I ABM("TIME")'="" D
 .S ABM("TIME")="."_ABM("TIME")
 .S ABM("TIME")=$E(X,8,15)+.0000001
 .S ABM("AMPM")=$S(ABM("TIME")>.1159999:"PM",1:"AM")
 .I ABM("TIME")>.1259999 S ABM("TIME")=ABM("TIME")-.12
 .S ABM("TIME")=+$E(ABM("TIME"),2,3)_":"_$E(ABM("TIME"),4,5)_" "_ABM("AMPM")
 S X=ABM("DATE")_" "_ABM("TIME")
 K ABM("DATE"),ABM("TIME"),ABM("AMPM")
 Q X
Y2KDT(X) ;EP - date from fileman to Y2K format Y=MMDDCCYY
 N Y
 I X="" Q X
 S Y=$E(X,4,7)_($E(X,1,3)+1700)
 Q Y
Y2KD2(X) ;EP - date from fileman to Y2K format Y=CCYYMMDD
 N Y
 I X="" Q X
 S Y=($E(X,1,3)+1700)_$E(X,4,7)
 Q Y
MDY(X) ;EP - date from fileman to MMDDYY
 N Y
 I X="" Q X
 S Y=$E(X,4,7)_$E(X,2,3)
 Q Y
SDTO(X) ;EP - date from fileman to MM/DD/YY
 N Y
 I X="" Q X
 S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 Q Y
HDTO(X) ;EP - old HDT entry point, date from fileman to MM-DD-YY
 N Y
 I X="" Q X
 S Y=$E(X,4,5)_"-"_$E(X,6,7)_"-"_$E(X,2,3)
 Q Y
MTHS ;MONTHS
 ;;JAN;;FEB;;MAR;;APR;;MAY;;JUN;;JUL;;AUG;;SEP;;OCT;;NOV;;DEC
HRN(X) ;EP - Y is set to the printable HRN
 ;     for patient ABMP("PDFN") at location ABMP("LDFN")
 N Y
 S Y=$S('$G(ABMP("PDFN")):"[no PAT]",'$G(ABMP("LDFN")):"[no LOC]",$D(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)):"[HRN:"_$P(^(0),U,2)_"]",1:"[no HRN]")
 Q Y
 ;
CSZ(X) ;EP - Y is set to the printable City, State ZIP CODE
 ; X incoming variable must = CITY^ST^ZIP
 N Y
 S Y=$S($G(X)="":"no address",$P(X,U)="":"no city",'$P(X,U,2):"no state",$P($G(^DIC(5,$P(X,U,2),0)),U,2)="":"invalid state",'$P(X,U,3):"no zip",1:$P(X,U)_", "_$P(^(0),U,2)_"  "_$P(X,U,3))
 Q Y
TM(X,Y) ;EP - FIGURE TOTAL MINUTES GIVEN FM DATE/TIMES IN X AND Y
 I X="" Q X
 I Y="" S X="" Q X
 D H^%DTC S ABM(1,1)=%H,ABM(1,2)=%T
 S X=Y D H^%DTC S ABM(2,1)=%H,ABM(2,2)=%T
 S ABM("D")=ABM(2,1)-ABM(1,1)*24*60*60
 S ABM("T")=ABM(2,2)-ABM(1,2)
 S ABM("TS")=ABM("D")+ABM("T")
 S X=ABM("TS")\60
 Q X
PAT(X) ;EP - DISPLAY PATIENT HEADER WITH IDENTIFIERS - X=DFN
 Q:'$D(^DPT(+X,0))
 S $P(ABM("="),"=",80)=""
 W $$EN^ABMVDF("IOF")
 W !,$$EN^ABMVDF("RVN"),"PATIENT:",$$EN^ABMVDF("RVF"),"  "
 S ABM("P0")=^DPT(X,0)
 W $P(ABM("P0"),U),"     ",$P(ABM("P0"),"^",2)
 S ABM("DOB")=$P(ABM("P0"),"^",3) W "  ",$E(ABM("DOB"),4,5),"/",$E(ABM("DOB"),6,7),"/",($E(ABM("DOB"),1,3)+1700)
 S ABM("SSN")=$P(ABM("P0"),"^",9)
 W "  ",$E(ABM("SSN"),1,3),"-",$E(ABM("SSN"),4,5),"-",$E(ABM("SSN"),6,9)
 W "  ","HRN: ",$P($G(^AUPNPAT(X,41,DUZ(2),0)),"^",2)
 W !,ABM("=")
 Q
FLAT(X,Y,Z)          ;EP - DETERMINE FLAT RATE
 ;X=INSURER, Y=VISIT TYPE, Z=DATE
 S N=Z+.5
 S ABMDT=$O(^ABMNINS(DUZ(2),X,1,Y,11,"B",N),-1)
 I 'ABMDT S X=0 K ABMDT Q X
 S ABMDA=$O(^ABMNINS(DUZ(2),X,1,Y,11,"B",ABMDT,0))
 S ABMZERO=$G(^ABMNINS(DUZ(2),X,1,Y,11,ABMDA,0))
 S X=$P(ABMZERO,"^",2)
 I $P(ABMZERO,"^",3),$P(ABMZERO,"^",3)<Z S X=0
 K ABMZERO,ABMDT,ABMDA
 Q X
NXNM(X) ;EP - GET NEXT CLAIM NUMBER
 I '$D(^ABMDCLM(0)) D
 .S ^ABMDCLM(0)=0
 .N I S I=0 F  S I=$O(^ABMDCLM(I)) Q:'I  D
 ..Q:$P(^ABMDCLM(I,0),"^",3)'>^ABMDCLM(0)
 ..S ^ABMDCLM(0)=$P(^ABMDCLM(I,0),"^",3)
 L +^ABMDCLM(0):30 I '$T S X="" Q X
 F  D  Q:'$D(^ABMDCLM(DUZ(2),X))
 .S X=^ABMDCLM(0)+1
 .S ^ABMDCLM(0)=X
 L -^ABMDCLM(0)
 Q X
EOP(X) ;EP - end of page
 ;X=0, 1, or 2
 Q:$G(IOT)'["TRM"
 Q:$E($G(IOST))'="C"
 Q:$D(IO("S"))
 Q:$D(ZTQUEUED)
 F  W ! Q:$Y+4>IOSL
 Q:X=2
 S DIR(0)="E"
 S:X=1 DIR("A")="Enter RETURN to continue"
 D ^DIR
 K DIR
 Q
SETI03 ;EP Set logic for ACTIVE x-ref of .03 field of 13 multiple of claim
 Q:X'="I"
 S $P(^ABMDCLM(DUZ(2),DA(1),0),U,8)=$S($P($G(^ABMDCLM(DUZ(2),DA(1),13,DA,0)),U,11)'="":$P($G(^ABMDCLM(DUZ(2),DA(1),13,DA,0)),U,11),1:+^ABMDCLM(DUZ(2),DA(1),13,DA,0))
 Q
KILLI03 ;EP Kill logic for ACTIVE x-ref of ,03 field or 13 multiple of claim
 Q
UPRV(X,Y)          ;EP unbillable providers
 ;x=claim ien
 ;y=coverage ien
 I '$G(X) Q 0
 I '$G(Y) Q 0
 I '$O(^ABMDCLM(DUZ(2),X,41,0)) Q 0
 S Z=1
 N I,ABMPRV,ABMCLAS
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),X,41,I)) Q:'I  D
 .S ABMPRV=$P(^ABMDCLM(DUZ(2),X,41,I,0),U)
 .S ABMCLAS=$P($G(^VA(200,+ABMPRV,"PS")),"^",5)
 .Q:$P($G(^AUTTPIC(+Y,15,+ABMCLAS,0)),"^",2)="U"
 .S Z=0
 Q Z
CHKCPT(Y) ; check CPT for valid date, inactive flag
 NEW A,I,D
 NEW ABMY
 NEW X  ;CSV-c
 S ABMY=$S(+$G(Y)=0:$O(^ICPT("B",Y,0)),1:Y)
 Q:+$G(ABMY)=0 0
 S:'$G(ABMP("VDT")) ABMP("VDT")=DT  ;default for dt
 I $P($$CPT^ABMCVAPI(ABMY,ABMP("VDT")),U,7)=0 Q 0  ;CSV-c
 S X=$$IHSCPT^ABMCVAPI(ABMY,ABMP("VDT"))  ;CSV-c
 S A=$P(X,U,7),I=$P(X,U,8)  ;CSV-c
 ;A is date added, I is date inactivated/deleted
 I $G(ABMP("VDT")),(I]""),(ABMP("VDT")>I) Q 0  ;have date, date after inactive date
 I '$G(ABMP("VDT")),($P($$CPT^ABMCVAPI(ABMY,ABMP("VDT")),U,7)) Q 0  ;CSV-c
 Q 1
GETREV(X) ;PEP - get rev code and format for claim editor display
 S ABMRVCD="****"
 I X="" Q ABMRVCD
 I $D(^AUTTREVN(X,0)) D  Q ABMRVCD
 .S ABMRVCD=$S($L($P($G(^AUTTREVN(X,0)),U))=3:"0"_$P($G(^AUTTREVN(X,0)),U),1:$P($G(^AUTTREVN(X,0)),U))
 Q ABMRVCD
