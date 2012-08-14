BDMS9B3 ; IHS/CMI/LAB - women's health supplement ; 27 Jan 2011  6:56 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4**;JUN 14, 2007
 ;
BI() ;EP- check to see if using new imm package or not 1/5/1999 IHS/CMI/LAB
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
TD(P,BDMSED) ;EP
 NEW BDMY,X,E,B,%DT,Y,TDD
 S TDD=$$LASTTD(P)
 S X=$$FMADD^XLFDT(DT,-(10*365))
 I TDD>X Q "Yes  "_$$DATE^BDMS9B1(TDD)
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",9,0)),TDD,"TD VACCINE (CVX 9)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",1,0)),TDD,"TD VACCINE (CVX 1)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",20,0)),TDD,"TD VACCINE (CVX 20)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",22,0)),TDD,"TD VACCINE (CVX 22)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",28,0)),TDD,"TD VACCINE (CVX 28)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",35,0)),TDD,"TD VACCINE (CVX 35)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",50,0)),TDD,"TD VACCINE (CVX 50)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",106,0)),TDD,"TD VACCINE (CVX 106)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",107,0)),TDD,"TD VACCINE (CVX 107)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",110,0)),TDD,"TD VACCINE (CVX 110)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",113,0)),TDD,"TD VACCINE (CVX 113)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",115,0)),TDD,"TD VACCINE (CVX 115)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",120,0)),TDD,"TD VACCINE (CVX 120)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",130,0)),TDD,"TD VACCINE (CVX 130)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",132,0)),TDD,"TD VACCINE (CVX 132)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",138,0)),TDD,"TD VACCINE (CVX 138)")
 I G]"" Q G
 S G=$$REFDF(P,9999999.14,$O(^AUTTIMM("C",139,0)),TDD,"TD VACCINE (CVX 139)")
 I G]"" Q G
 S G="" F Z=1,9,20,22,28,35,50,106,107,110,113,115,120,130,132,138,139 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<TDD
 .S G=1_U_D
 I G Q "Refused "_$$DATE^BDMS9B1($P(D,U,2))_"CVX "_Z_" Immunization package"
 Q "No   "_$$DATE^BDMS9B1(TDD)
FLU(P) ;EP
 NEW BDMY,%,LFLU,E,T,X
 S LFLU=$$LASTFLU^BDMD113(P,"D")
 I LFLU="" G FLUR
FLU1 NEW D S D=$S($E(DT,4,5)>7:$E(DT,1,3)_"0801",1:$E(DT,1,3)-1_"0801")
 I LFLU'<D Q "Yes  "_$$DATE^BDMS9B1($P(LFLU,U))
FLUR ;
 S G=$$REFDF(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:15,1:12),0)),LFLU,"FLU VACCINE CVX 15")
 I G]"" Q G
 S G=$$REFDF(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:16,1:12),0)),LFLU,"FLU VACCINE CVX 16")
 I G]"" Q G
 S G=$$REFDF(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:88,1:12),0)),LFLU,"FLU VACCINE CVX 88")
 I G]"" Q G
 S G=$$REFDF(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:111,1:12),0)),LFLU,"FLU VACCINE CVX 111")
 I G]"" Q G
 S G=$$REFDF(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:135,1:12),0)),LFLU,"FLU VACCINE CVX 135")
 I G]"" Q G
 S G=$$REFDF(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:140,1:12),0)),LFLU,"FLU VACCINE CVX 140")
 I G]"" Q G
 S G=$$REFDF(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:141,1:12),0)),LFLU,"FLU VACCINE CVX 141")
 I G]"" Q G
 S G="" F Z=15,16,88,111,135,140,141 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<LFLU
 .S G=1_U_D
 I G Q "Refused "_$$DATE^BDMS9B1($P(D,U,2))_"CVX "_Z_" Immunization package"
 Q "No"
REFDF(P,F,I,D,TEXT) ;EP - dm item refused?
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 S TEXT=$G(TEXT)
 I $G(D)="" S D=""
 NEW X S X=$O(^AUPNPREF("AA",P,F,I,0))
 I 'X Q ""  ;none of this item was refused
 NEW Y S Y=9999999-X
 I D]"",Y>D Q "Refused "_$S(TEXT]"":TEXT,1:$E($$VAL^XBDIQ1(F,I,.01),1,30))_" on "_$$DATE^BDMS9B1(Y)
 I D]"",Y<D Q ""
 Q "Refused "_$S(TEXT]"":TEXT,1:$E($$VAL^XBDIQ1(F,I,.01),1,30))_" on "_$$DATE^BDMS9B1(Y)
DIETV(P) ;EP
 I '$G(P) Q ""
 ;get all dietician visits
 ;go through all visits in AA and get last to Prov 29 or 
 NEW D,V,G,X S (D,V,G)="" F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D'=+D!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:'$D(^AUPNVPOV("AD",V))
 ..Q:'$D(^AUPNVPRV("AD",V))
 ..Q:$$DNKA^BDMS9B4(V)
 ..Q:$$CLINIC^APCLV(V,"C")=52  ;chart review
 ..I $P(^AUPNVSIT(V,0),U,7)="C" Q  ;chart review
 ..I $$CLINIC^APCLV(V,"C")=67 S G=V Q
 ..S X=$$DIETP(V) ; is there a prov 07 or 29
 ..I X S G=V Q
 ..Q
 .Q
 I 'G Q ""
 Q $$DATE^BDMS9B1($P($P(^AUPNVSIT(G,0),U),"."))_"  "_$E($$PRIMPOV^APCLV(G,"N"),1,39)
DIETP(V) ;are any providers an 07 or 29
 I '$G(V) Q ""
 NEW X,Y,Z,H
 S H="",Z=0 F  S Z=$O(^AUPNVPRV("AD",V,Z)) Q:Z'=+Z!(H)  D
 .S Y=$P(^AUPNVPRV(Z,0),U) ;provider ien
 .I $P(^DD(9000010.06,.01,0),U,2)[200 S Y=$$PROVCLSC^XBFUNC1(Y) I Y=29!(Y="07") S H=1 Q
 .I $P(^DD(9000010.06,.01,0),U,2)[6 S Y=$P($G(^DIC(6,Y,0)),U,4) I Y S Y=$P($G(^DIC(7,Y,9999999)),U,1) I Y="07"!(Y=29) S H=1
 .Q
 Q H
LASTTD(BDMPDFN,BDMBD,BDMED,BDMFORM) ;PEP - date of last TD
 ;  Return the last recorded TD:
 ;   - V Immunization: 1, 9, 20, 22, 28, 35, 50, 106, 107, 110, 112, 113, 115
 ;   - V CPT [APCH TD CPTS]
 ;
 ;  Input:
 ;   BDMPDFN - Patient DFN
 ;   BDMBD - beginning date to begin search for value - if blank, default is DOB
 ;   BDMED - ending date of search - if blank, default is DT
 ;   BDMFORM -  BDMFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If BDMFORM is blank or BDMFORM is D returns internal fileman date if one found otherwise returns null
 ;   If BDMFORM is A returns the string:
 ;     date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(BDMPDFN)="" Q ""
 I $G(BDMBD)="" S BDMBD=$$DOB^AUPNPAT(BDMPDFN)
 I $G(BDMED)="" S BDMED=DT
 I $G(BDMFORM)="" S BDMFORM="D"
 NEW BDMLAST,BDMVAL,BDMX,R,X,Y,V,E,T,G,BDMY,BDMF
 S BDMLAST=""
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"1","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"9","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"20","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"22","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"28","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"35","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"50","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"106","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"107","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"110","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"112","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"113","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"115","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"120","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"130","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"132","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"138","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"139","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTCPTT^APCLAPIU(BDMPDFN,$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"APCH TD CPTS","A")
 D E
 I BDMFORM="D" Q $P(BDMLAST,U)
 Q BDMLAST
 ;
E ;
 I $P(BDMVAL,U,1)>$P(BDMLAST,U,1) S BDMLAST=BDMVAL
 Q
 ;
TOBACCO ;EP
 K BDMTOB,BDMTOBS,BDMTOBC,BDMTOBD
 S BDMTOBD=""
 D TOBACCO0
 S X=$P(BDMTOBS,U,2)
 S Y=$P(BDMTOBC,U,2)
 S BDMTOBD=X I Y>BDMTOBD S BDMTOBD=Y   ;date of latest hf
 D TOBACCO1 ;check Problem file for tobacco use
 S X=$P(BDMTOBS,U,2)
 S Y=$P(BDMTOBC,U,2)
 S BDMTOBD=X I Y>BDMTOBD S BDMTOBD=Y
 D TOBACCO2 ;check POVs for tobacco use
 I $D(BDMTOBS)!($D(BDMTOBC)) Q
 S BDMTOBS="UNDOCUMENTED"
 Q
TOBACCO0 ;check for tobacco documented in health factors
 S BDMTOBS="",BDMTOBC=""  ;SMOKING AND CHEWING
 S X=$$LASTHF^BDMSMU(BDMSDFN,"TOBACCO (SMOKING)","X")
 S BDMTOBS=X
 S X=$$LASTHF^BDMSMU(BDMSDFN,"TOBACCO (SMOKELESS - CHEWING/DIP)","X")
 S BDMTOBC=X
 I BDMTOBC]""!(BDMTOBS]"") Q  ;have new patch 5 factors
 S X=$$LASTHF^BDMSMU(BDMSDFN,"TOBACCO","B")
 S BDMTOBS=X
 Q
TOBACCO1 ;check problem file for tobacco use
 NEW X,Y,Z,T
 S T=$O(^ATXAX("B","DM AUDIT SMOKING RELATED DXS",0))
 I 'T Q
 S X=0
 F  S X=$O(^AUPNPROB("AC",BDMSDFN,X)) Q:X'=+X  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P($G(^AUPNPROB(X,0)),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"  ;HAS TO BE ACTIVE
 .Q:$P($G(^AUPNPROB(X,2)),U,1)  ;DELETED
 .Q:$P(^AUPNPROB(X,0),U,3)<BDMTOBD
 .Q:$P(^AUPNPROB(X,0),U,3)=BDMTOBD
 .S Z=$P(^AUPNPROB(X,0),U,1)
 .Q:'$$ICD^ATXCHK(Z,T,9)
 .I $P($$ICDDX^ICDCODE(Z,,,1),U,2)=305.13 S BDMTOBS="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV(+$P(^AUPNPROB(X,0),U,5),0),U),1,30)_U_$P(^AUPNPROB(X,0),U,3) Q  ;cmi/anch/maw 8/27/2007 code set versioning
 .S BDMTOBS="YES, USES TOBACCO - "_$E($P(^AUTNPOV(+$P(^AUPNPROB(X,0),U,5),0),U),1,30)_"  Problem List: "_$$VAL^XBDIQ1(9000011,X,.01)_U_$P(^AUPNPROB(X,0),U,3)
 Q
TOBACCO2 ;check pov file for TOBACCO USE DOC
 K BDM S BDMX=BDMSDFN_"^LAST DX [DM AUDIT SMOKING RELATED DXS" S E=$$START1^APCLDF(BDMX,"BDM(") Q:E  I $D(BDM(1)) D
 . Q:$P(BDM(1),U,1)<BDMTOBD
 . Q:$P(BDM(1),U,1)=BDMTOBD
 . I $P(BDM(1),U,2)=305.13 S BDMTOBS="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV(+$P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30)_U_$P(BDM(1),U) Q
 . S BDMTOBS="YES, USES TOBACCO"_" - "_$E($P(^AUTNPOV(+$P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30)_"  POV: "_$$VAL^XBDIQ1(9000010.07,+$P(BDM(1),U,4),.01)_"  "_$$DATE^BDMS9B1($P(BDM(1),U))_U_$P(BDM(1),U)
 .Q
 Q
 ;
CHEST(P) ;EP - get date of last chest xray from V RAD or V CPT
 ;FIX ALL RAD LOOKUPS TO LOOP THROUGH GLOBAL
 I $G(P)="" Q ""
 NEW X,Y,Z,G,LCHEST,T,D
 S LCHEST=""
 S (X,Y,V)=0 F  S X=$O(^AUPNVRAD("AC",P,X)) Q:X'=+X  D
 .S V=$P(^AUPNVRAD(X,0),U,3),V=$P($P($G(^AUPNVSIT(V,0)),U),".")
 .S Y=$P(^AUPNVRAD(X,0),U),Y=$P($G(^RAMIS(71,Y,0)),U,9)
 .I Y>71009&(Y<71036),V>LCHEST S LCHEST=V Q
 S T=71009 F  S T=$O(^ICPT("B",T)) Q:T>71035  S X=0 F  S X=$O(^ICPT("B",T,X)) Q:X'=+X  D
 .S D=$O(^AUPNVCPT("AA",P,X,0)) I D S D=9999999-D
 .I D,D>LCHEST S LCHEST=D
 K BDMY S %=P_"^LAST PROCEDURE 87.44",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)),$P(BDMY(1),U)>LCHEST S LCHEST=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 87.39",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)),$P(BDMY(1),U)>LCHEST S LCHEST=$P(BDMY(1),U)
 Q $S(LCHEST]"":$$DATE^BDMS9B1(LCHEST),1:"")
EKG(P) ;EP
 NEW BDMY,%,LEKG S LEKG="",%=P_"^LAST DIAGNOSTIC ECG SUMMARY",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY) S LEKG=$P(BDMY(1),U)_U_$$VAL^XBDIQ1(9000010.21,+$P(BDMY(1),U,4),.04)
 K BDMY S %=P_"^LAST PROCEDURE 89.50",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 89.51",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 89.52",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 89.53",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST DX 794.31",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)) D
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 ;check CPT 
 S T=$O(^ATXAX("B","DM AUDIT EKG CPTS",0))
 K BDMY I T S BDMY(1)=$$CPT(P,,,T,3) D
 .I BDMY(1)="" K BDMY Q
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 K BDMY I T S BDMY(1)=$$RAD(P,,,T,3) D
 .I BDMY(1)="" K BDMY Q
 .Q:LEKG>$P(BDMY(1),U)
 .S LEKG=$P(BDMY(1),U)
 ;
 ;
 Q $$DATE^BDMS9B1(LEKG)_U_$P(LEKG,U,2)
 ;
CPT(P,BDATE,EDATE,T,F) ;
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $$DATE^BDMS9B1($P($P($G(^AUPNVSIT(V,0)),U),"."))
 Q ""
RAD(P,BDATE,EDATE,T,F) ;return if a v rad entry in date range
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" S EDATE=DT
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVRAD("AD",V))
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X!(G)  D
 ...Q:'$D(^AUPNVRAD(X,0))
 ...S Y=$P(^AUPNVRAD(X,0),U) Q:'Y  Q:'$D(^RAMIS(71,Y,0))
 ...S Y=$P($G(^RAMIS(71,Y,0)),U,9) Q:'Y
 ...Q:'$$ICD^ATXCHK(Y,T,1)
 ...S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $$DATE^BDMS9B1($P($P($G(^AUPNVSIT(V,0)),U),"."))
 Q ""