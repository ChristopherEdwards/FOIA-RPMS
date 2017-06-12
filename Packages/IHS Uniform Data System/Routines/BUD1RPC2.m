BUD1RPC2 ; IHS/CMI/LAB - UDS TABLE 6 11 Dec 2007 12:15 PM ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
L27(BUDV) ;EP
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I A=9110 S G=A
 .Q
 I G]"" Q G
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z="D9110" S G=Z
 .Q
 Q G
L26B(BUDV) ;EP
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z=99408!(Z=99409) S G=Z
 .Q
 I G]"" Q G
 S X=0 F  S X=$O(^AUPNVPED("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$P($G(^AUPNVPED(X,0)),U)
 .Q:Z=""
 .Q:'$D(^AUTTEDT(Z,0))
 .S Z=$P(^AUTTEDT(Z,0),U,2)
 .I Z="AOD-INJ" S G=Z
 Q G
L26C(BUDV) ;EP
 ;I $$CLINIC^APCLV(BUDV,"C")=94 Q "CLINIC 94"
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z=99406!(Z=99407)!(Z="S9075") S G=Z
 .Q
 I G]"" Q G
 S X=0 F  S X=$O(^AUPNVPED("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$P($G(^AUPNVPED(X,0)),U)
 .Q:Z=""
 .Q:'$D(^AUTTEDT(Z,0))
 .S Z=$P(^AUTTEDT(Z,0),U,2)
 .I $P(Z,"-",1)="TO" S G=Z Q
 .I $P(Z,"-",2)="TO" S G=Z Q
 .I $P(Z,"-",2)="SHS" S G=Z Q
 I G]"" Q G
 S X=0 F  S X=$O(^AUPNVPOV("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.07,X,.01)
 .I Z="305.1" S G="305.1"
 Q G
L28(BUDV) ;EP
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I A="0150"!(A="0120")!(A="0140")!(A="0160")!(A="0170")!(A="0180")!(A="0145") S G=A
 .Q
 I G]"" Q G
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z="D0150"!(Z="D0120")!(Z="D0140")!(Z="D0160")!(Z="D0170")!(Z="D0180")!(Z="D0145") S G=Z
 .Q
 Q G
L29(BUDV) ;EP
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I A=1110!(A=1120) S G=A
 .Q
 I G]"" Q G
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z="D1110"!(Z="D1120") S G=Z
 .Q
 Q G
L30(BUDV) ;EP
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I A=1351 S G=A
 .Q
 I G]"" Q G
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z="D1351" S G=Z
 .Q
 Q G
L31(BUDV) ;EP
 S G=""
 ;I '$D(^AUPNVDEN("AD",BUDV)) G L31POV
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I A=1203!(A=1204)!(A=1206) S G=A
 .Q
 I G]"" Q G
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z="D1203"!(Z="D1204")!(Z="D1206") S G=Z
 .Q
 Q G
L31POV ;EP
 S G=""
 S V=0 F  S V=$O(^AUPNVPOV("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVPOV(V,0)),U)
 .Q:'A
 .S A=$P($$ICDDX^ICDCODE(A),U,2)
 .I A="V07.31" S G=A
 .Q
 Q G
L32(BUDV) ;EP
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I $E(A,1,2)=21!($E(A,1,2)=22)!($E(A,1,2)=23)!($E(A,1,2)=24)!($E(A,1,2)=25)!($E(A,1,2)=26)!($E(A,1,2)=27)!($E(A,1,2)=28)!($E(A,1,2)=29) S G=A
 .Q
 I G]"" Q G
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I $E(Z,1,3)="D21"!($E(Z,1,3)="D22")!($E(Z,1,3)="D23")!($E(Z,1,3)="D24")!($E(Z,1,3)="D25")!($E(Z,1,3)="D26")!($E(Z,1,3)="D27")!($E(Z,1,3)="D28")!($E(Z,1,3)="D29") S G=Z
 .Q
 Q G
L33(BUDV) ;EP
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I A=7111!(A=7140)!(A=7210)!(A=7220)!(A=7230)!(A=7240)!(A=7241)!(A=7250)!(A=7260)!(A=7261)!(A=7270)!(A=7272)!(A=7280) S G=A
 .Q
 I G]"" Q G
 S V=0,G="" F  S V=$O(^AUPNVCPT("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$$VAL^XBDIQ1(9000010.18,V,.01)
 .I A="D7111"!(A="D7140")!(A="D7210")!(A="D7220")!(A="D7230")!(A="D7240")!(A="D7241")!(A="D7250")!(A="D7260")!(A="D7261")!(A="D7270")!(A="D7272")!(A="D7280") S G=A
 .Q
 Q G
L34(BUDV) ;EP
 S V=0,G="" F  S V=$O(^AUPNVDEN("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$P($G(^AUPNVDEN(V,0)),U)
 .Q:'A
 .S A=$P($G(^AUTTADA(A,0)),U)
 .Q:A=""
 .I $E(A)=3!($E(A)=4)!($E(A)=5)!($E(A)=6)!($E(A)=8) S G=A
 .Q
 I G]"" Q G
 S V=0,G="" F  S V=$O(^AUPNVCPT("AD",BUDV,V)) Q:V'=+V!(G]"")  D
 .S A=$$VAL^XBDIQ1(9000010.18,V,.01)
 .I $E(A,1,2)="D3"!($E(A,1,2)="D4")!($E(A,1,2)="D5")!($E(A,1,2)="D6")!($E(A,1,2)="D8") S G=A
 .Q
 Q G
L26(BUDV) ;EP
 I $$AGE^AUPNPAT($P(^AUPNVSIT(BUDV,0),U,5),BUDCAD)>11 Q ""
 I $$CLINIC^APCLV(BUDV,"C")=24 Q "CLIN 24"
 I $$CLINIC^APCLV(BUDV,"C")=57 Q "CLIN 57"
 ;S X=0,G="" F  S X=$O(^AUPNVPOV("AD",BUDV,X)) Q:X'=+X!(G]"")  S R=$P(^AUPNVPOV(X,0),U),R=$P($$ICDDX^ICDCODE(R),U,2) I $E(R,1,3)="V20"!($E(R,1,3)="V29") S G="V POV: "_R
 ;I G]"" Q G
 S G="" I T S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$P(^AUPNVCPT(X,0),U),Z=$P($$CPT^ICPTCOD(Z),U,2)
 .I Z=99391!(Z=99392)!(Z=99393)!(Z=99381)!(Z=99382)!(Z=99383) S G=Z Q
 .;I Z=99431!(Z=99432)!(Z=99433) S G=Z Q
 .Q
 Q G
L26A(BUDV) ;EP
 ;age 9-72 months
 S G=""
 S A=$$AGE^BUD1UTL2(DFN,2,$$VD^APCLV(BUDV))
 I A<9 Q G
 I A>72 Q G
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z=83655 S G=Z
 .Q
 Q G
L26D(BUDV) ;EP
 S G=""
 S G="" S X=0 F  S X=$O(^AUPNVCPT("AD",BUDV,X)) Q:X'=+X!(G]"")  D
 .S Z=$$VAL^XBDIQ1(9000010.18,X,.01)
 .I Z=92002!(Z=92004)!(Z=92012)!(Z=92014) S G=Z
 .Q
 Q G
T4 ;EP
 D HI
 D INS
 D MIGRANT
 D HOMELESS
 D SCHOOL
 D VET
 Q
SHI(V,LV) ;
 S BUDT4V(V)=BUDT4V(V)+1
 S BUDT4V(6)=BUDT4V(6)+1
 I $G(BUDT4IPP) D
 .S ^XTMP("BUD1RPT1",BUDJ,BUDH,"T4IPPL",$G(V),$G(LV),BUDCOM,BUDSEX,BUDAGE,DFN)=$G(LV)
 Q
HI ;
 S (BUDNIH,BUDTHI,BUDTHIP)=""
 S BUDTHIP=$$VALI^XBDIQ1(9000001,DFN,8701)
 I BUDTHIP="" S BUDTHIP="Y"
 S BUDNIH=$$VAL^XBDIQ1(9000001,DFN,.35)
 I 'BUDNIH D SHI(5,"Unknown") Q  ;can't calculate, no number is household
 S BUDTHI=$$VAL^XBDIQ1(9000001,DFN,.36)
 I 'BUDTHI D SHI(5,"Unknown") Q
 I BUDTHIP="M" S BUDTHI=BUDTHI*12
 I BUDTHIP="W" S BUDTHI=BUDTHI*52
 I BUDTHIP="B" S BUDTHI=BUDTHI*26
 S X=$O(^BUDLIL("B",BUDNIH,0))
 S P="",T=""
 S S=$$VAL^XBDIQ1(9999999.06,BUDSITE,.16)
 I S]"" D  G N
 .I T="ALASKA" S P=3 Q
 .I T="HAWAII" S P=4 Q
 .S P=2
 S P=2
 ;
N ;
 S Y=$P(^BUDLIL(X,0),U,P)
 S Z=BUDTHI/Y
 S Z=Z*100
 I Z>200 D SHI(4,"Over 200%") Q
 I Z>150.9999999 D SHI(3,"151-200%") Q
 I Z>100.9999999 D SHI(2,"101-150%") Q
 D SHI(1,"100% and below")
 Q
INS ;EP
 S BUDHAS=0
 S BUDHAS=$$PI(DFN,$$VD^APCLV(BUDLASTV))
 I BUDHAS=1 D TINS(BUDAGE,11) Q
 S BUDHAS=$$MCR(DFN,$$VD^APCLV(BUDLASTV))
 I BUDHAS=1 D TINS(BUDAGE,9) Q
 ;S BUDHAS=$$OPI(DFN,$$VD^APCLV(BUDLASTV),"W")
 ;I BUDHAS=1 D TINS(BUDAGE,"10a") Q
 S BUDHAS=$$RR^AUPNPAT(DFN,$$VD^APCLV(BUDLASTV))
 I BUDHAS=1 D TINS(BUDAGE,"10a") Q
 S BUDHAS=$$OPI(DFN,$$VD^APCLV(BUDLASTV),"K")
 I BUDHAS=1 D TINS(BUDAGE,"10b") Q
 S BUDHAS=$$MCD(DFN,$$VD^APCLV(BUDLASTV))
 I BUDHAS=1 D TINS(BUDAGE,"8a") Q
 S BUDHAS=$$MCD(DFN,$$VD^APCLV(BUDLASTV),"K")
 I BUDHAS=1 D TINS(BUDAGE,"8b") Q
 D TINS(BUDAGE,7)
 Q
TINS(A,P) ;
 S $P(BUDT4V(P),U,$S(A<20:1,1:2))=$P(BUDT4V(P),U,$S(A<20:1,1:2))+1
 S $P(BUDT4V(12),U,$S(A<20:1,1:2))=$P(BUDT4V(12),U,$S(A<20:1,1:2))+1
 I P="8a"!(P="8b") S $P(BUDT4V(8),U,$S(A<20:1,1:2))=$P(BUDT4V(8),U,$S(A<20:1,1:2))+1
 I P="10a"!(P="10b") S $P(BUDT4V(10),U,$S(A<20:1,1:2))=$P(BUDT4V(10),U,$S(A<20:1,1:2))+1
 I $G(BUDT4PMI) D
 .I P=7 S T="None/Uninsured"
 .I P="8a" S T="Regular Medicaid (Title XIX)",P=8.1
 .I P="8b" S T="CHIP Medicaid",P=8.2
 .I P="9" S T="Medicare"
 .I P="10a" S T="Other Public Insurance Non-CHIP",P=10.1
 .I P="10b" S T="Other Public Insurance CHIP",P=10.2
 .I P="11" S T="Private Insurance"
 .S ^XTMP("BUD1RPT1",BUDJ,BUDH,"T4PMIS",$G(P),$G(T),BUDAGE,BUDCOM,BUDSEX,DFN)=""
 Q
 ;
MCD(P,D,T) ;EP - Is patient P medicaid eligible on date D.
 ; I = IEN.
 ; J = Node 11 IEN in ^AUPNMCD.
 I '$G(P) Q 0
 I '$G(D) Q 0
 S T=$G(T)
 NEW I,J,Y,Z,N
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G MCDX
 I $P(^DPT(P,0),U,19) G MCDX
 I '$D(^AUPNPAT(P,0)) G MCDX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCDX
 S I=0 F  S I=$O(^AUPNMCD("B",P,I)) Q:I'=+I  D
 .Q:'$D(^AUPNMCD(I,11))
 .S Z=$P(^AUPNMCD(I,0),U,2)
 .;get plan name/INSURER TYPE OF PLAN NAME
 .S N=$$VALI^XBDIQ1(9000004,I,.11)
 .I N S N=$$VALI^XBDIQ1(9999999.18,N,.21)
 .I T="K" Q:N'="K"
 .I T=""  Q:N="K"
 .S J=0 F  S J=$O(^AUPNMCD(I,11,J)) Q:J'=+J  D
 ..Q:J>D
 ..I $P(^AUPNMCD(I,11,J,0),U,2)]"",$P(^(0),U,2)<D Q
 ..S Y=1
 ..Q
 .Q
 ;
MCDX ;
 Q Y
PI(P,D) ;EP - Is patient P private insurance eligible on date D. 1= yes, 0=no.
 ; I = IEN
 ; Y = 1:yes, 0:no
 ; X = Pointer to INSURER file.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y,X
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G PIX
 I $P(^DPT(P,0),U,19) G PIX
 I '$D(^AUPNPAT(P,0)) G PIX
 I '$D(^AUPNPRVT(P,11)) G PIX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G PIX
 S I=0
 F  S I=$O(^AUPNPRVT(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNPRVT(P,11,I,0),U)=""
 . S X=$P(^AUPNPRVT(P,11,I,0),U) Q:X=""
 . Q:$P(^AUTNINS(X,0),U)["AHCCCS"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="M"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="D"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="R"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="N"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="I"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="K"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="MD"
 . Q:$P($G(^AUTNINS(X,2)),U,1)="MH"
 . Q:$P(^AUPNPRVT(P,11,I,0),U,6)>D
 . I $P(^AUPNPRVT(P,11,I,0),U,7)]"",$P(^(0),U,7)<D Q
 . S Y=1
 .Q
PIX ;
 Q Y
OPI(P,D,T) ;EP - Is patient P private insurance eligible on date D. 1= yes, 0=no.
 ; I = IEN
 ; Y = 1:yes, 0:no
 ; X = Pointer to INSURER file.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y,X
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G OPIX
 I $P(^DPT(P,0),U,19) G OPIX
 I '$D(^AUPNPAT(P,0)) G OPIX
 I '$D(^AUPNPRVT(P,11)) G RR
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G RR
 S I=0
 F  S I=$O(^AUPNPRVT(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNPRVT(P,11,I,0),U)=""
 . S X=$P(^AUPNPRVT(P,11,I,0),U) Q:X=""
 . Q:$P($G(^AUTNINS(X,2)),U,1)'=T
 . Q:$P(^AUPNPRVT(P,11,I,0),U,6)>D
 . I $P(^AUPNPRVT(P,11,I,0),U,7)]"",$P(^(0),U,7)<D Q
 . S Y=1
 .Q
 I Y Q Y
RR ;NOW CHECK RAILROAD RETIREMENT
 ;S Y=$$RR^AUPNPAT(P,D)
OPIX ;
 Q Y
MCR(P,D) ;EP - Is patient P medicare eligible on date D.  1 = yes, 0 = no.
 ; I = IEN in ^AUPNMCR multiple.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G MCRX
 I $P(^DPT(P,0),U,19) G MCRX
 I '$D(^AUPNPAT(P,0)) G MCRX
 I '$D(^AUPNMCR(P,11)) G MCRX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCRX
 S I=0
 F  S I=$O(^AUPNMCR(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNMCR(P,11,I,0),U)>D
 . I $P(^AUPNMCR(P,11,I,0),U,2)]"",$P(^(0),U,2)<D Q
 . S Y=1
 .Q
MCRX ;
 I Y Q Y
 ;now check Private insurance for MD, MH, R, M
 I '$D(^AUPNPRVT(P,11)) G MCRPIX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCRPIX
 S I=0,G=0
 F  S I=$O(^AUPNPRVT(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNPRVT(P,11,I,0),U)=""
 . S X=$P(^AUPNPRVT(P,11,I,0),U) Q:X=""
 . I $P($G(^AUTNINS(X,2)),U,1)="M" S G=1
 . I $P($G(^AUTNINS(X,2)),U,1)="R" S G=1
 . I $P($G(^AUTNINS(X,2)),U,1)="MD" S G=1
 . I $P($G(^AUTNINS(X,2)),U,1)="MH" S G=1
 . I 'G Q
 . Q:$P(^AUPNPRVT(P,11,I,0),U,6)>D
 . I $P(^AUPNPRVT(P,11,I,0),U,7)]"",$P(^(0),U,7)<D Q
 . S Y=1
 .Q
MCRPIX ;
 Q Y
MIGRANT ;
 S M=$$MIG(DFN,$$VD^APCLV(BUDLASTV))
 Q:M=""
 I $P(M,U,1)="M" S BUDT4V(14)=BUDT4V(14)+1,BUDT4V(16)=BUDT4V(16)+1 D
 .Q:'$G(BUDT4CHA)
 .S T="Migrant" S ^XTMP("BUD1RPT1",BUDJ,BUDH,"T4CHAR",14,T,BUDCOM,BUDSEX,BUDAGE,DFN)=""
 I $P(M,U,1)="S" S BUDT4V(15)=BUDT4V(15)+1,BUDT4V(16)=BUDT4V(16)+1 D
 .Q:'$G(BUDT4CHA)
 .S T="Seasonal"
 .S ^XTMP("BUD1RPT1",BUDJ,BUDH,"T4CHAR",15,T,BUDCOM,BUDSEX,BUDAGE,DFN)=""
 Q
HOMELESS ;
 S H=$$HOMEL(DFN,$$VD^APCLV(BUDLASTV))
 I H="" Q
 I $P(H,U,1)="H" S BUDT4V(17)=BUDT4V(17)+1,BUDT4V(23)=BUDT4V(23)+1,T="Homeless (Type: Homeless Shelter)",L=17
 I $P(H,U,1)="T" S BUDT4V(18)=BUDT4V(18)+1,BUDT4V(23)=BUDT4V(23)+1,T="Homeless (Type: Transitional)",L=18
 I $P(H,U,1)="D" S BUDT4V(19)=BUDT4V(19)+1,BUDT4V(23)=BUDT4V(23)+1,T="Homeless (Type: Doubling Up)",L=19
 I $P(H,U,1)="S" S BUDT4V(20)=BUDT4V(20)+1,BUDT4V(23)=BUDT4V(23)+1,T="Homeless (Type: Street)",L=20
 I $P(H,U,1)="O" S BUDT4V(21)=BUDT4V(21)+1,BUDT4V(23)=BUDT4V(23)+1,T="Homeless (Type: Other)",L=21
 I $P(H,U,1)="U" S BUDT4V(22)=BUDT4V(22)+1,BUDT4V(23)=BUDT4V(23)+1,T="Homeless (Type: Unknown)",L=22
 S ^XTMP("BUD1RPT1",BUDJ,BUDH,"T4CHAR",L,T,BUDCOM,BUDSEX,BUDAGE,DFN)=""
 Q
VET ;
 S V=$$VALI^XBDIQ1(2,DFN,1901)
 I V="Y" S T="Veteran" S BUDT4V(25)=BUDT4V(25)+1,^XTMP("BUD1RPT1",BUDJ,BUDH,"T4CHAR",25,T,BUDCOM,BUDSEX,BUDAGE,DFN)=""
 Q
SCHOOL ;IF ALL VISITS ARE CLINIC SCHOOL??
 ;if any visit from 356a is clinic school set to yes
 NEW X,V,Y,S
 S S=""
 S X=0 F  S X=$O(^TMP($J,"VISITS356A",X)) Q:X'=+X  I $$CLINIC^APCLV(X,"C")=22 S S=1
 Q:S=""
 S BUDT4V(24)=$G(BUDT4V(24))+1
 S ^XTMP("BUD1RPT1",BUDJ,BUDH,"T4CHAR",24,"School Based Patient",BUDCOM,BUDSEX,BUDAGE,DFN)=""
 Q
MIG(P,D) ;EP
 ;GET LAST VALUE WITH A YES BEFORE END OF TIME PERIOD
 I '$O(^AUPNPAT(P,84,0)) Q ""
 NEW X,Y,Z,L
 S L=""
 S X=0 F  S X=$O(^AUPNPAT(P,84,"B",X)) Q:X'=+X  D
 .Q:X>D  ;AFTER LAST VISIT
 .S Y=0 F  S Y=$O(^AUPNPAT(P,84,"B",X,Y)) Q:Y'=+Y  D
 ..I $P($G(^AUPNPAT(P,84,Y,0)),U,2)="" Q
 ..;I $P($G(^AUPNPAT(P,84,Y,0)),U,3)="" Q
 ..S L=Y
 I L="" Q ""
 I $P(^AUPNPAT(P,84,L,0),U,2)="N" Q ""
 Q $S($P(^AUPNPAT(P,84,L,0),U,3)]"":$P(^AUPNPAT(P,84,L,0),U,3),1:"S")_"^"_$P(^AUPNPAT(P,84,L,0),U,1)
HOMEL(P,D) ;EP
 ;GET LAST VALUE WITH A YES BEFORE END OF TIME PERIOD
 I '$O(^AUPNPAT(P,85,0)) Q ""
 NEW X,Y,Z,L
 S L=""
 S X=0 F  S X=$O(^AUPNPAT(P,85,"B",X)) Q:X'=+X  D
 .Q:X>D  ;AFTER LAST VISIT
 .S Y=0 F  S Y=$O(^AUPNPAT(P,85,"B",X,Y)) Q:Y'=+Y  D
 ..I $P($G(^AUPNPAT(P,85,Y,0)),U,2)="" Q
 ..S L=Y
 I L="" Q ""
 I $P(^AUPNPAT(P,85,L,0),U,2)="N" Q ""
 Q $S($P(^AUPNPAT(P,85,L,0),U,3)]"":$P(^AUPNPAT(P,85,L,0),U,3),1:"U")_"^"_$P(^AUPNPAT(P,85,L,0),U,1)
