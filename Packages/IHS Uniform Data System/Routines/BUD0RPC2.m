BUD0RPC2 ; IHS/CMI/LAB - UDS TABLE 6 11 Dec 2007 12:15 PM ;
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
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
 S A=$$AGE^BUD0UTL2(DFN,2,$$VD^APCLV(BUDV))
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
