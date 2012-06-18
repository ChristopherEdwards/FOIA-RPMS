APCHSMU2 ; IHS/CMI/LAB - utilities for hmr ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;cmi/anch/maw 8/28/2007 code set versioning in CPT
 ;
WH(P,BDATE,EDATE,T,F) ;EP
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through procedures in a date range for this patient, check proc type
 NEW D,X,Y,G,V
 S (G,V)=0 F  S V=$O(^BWPCD("C",P,V)) Q:V=""!(G)  D
 .Q:'$D(^BWPCD(V,0))
 .I $P(^BWPCD(V,0),U,4)'=T Q
 .S D=$P(^BWPCD(V,0),U,12)
 .Q:D<BDATE
 .Q:D>EDATE
 .S G=V
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S D=$P(^BWPCD(G,0),U,12) Q D
 I F=4 S D=$P(^BWPCD(G,0),U,12) Q $$FMTE^XLFDT(D)
 Q ""
 ;
CPT(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
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
 I F=4 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 ;cmi/anch/maw 8/28/2007 mods for code set versioning
 N APCHSVDT
 ;I F=5 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^ICPT($P(^AUPNVCPT(G,0),U),0),U)
 I F=5 S V=$P(^AUPNVCPT(G,0),U,3) I V S APCHSVDT=$P(+V,".") Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVCPT(G,0),U),APCHSVDT),U,2)
 ;cmi/anch/maw 8/28/2007 end of mods
 Q ""
LASTDX(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN APCHDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 NEW APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5,APCHDXBD,APCHDXED
 S (APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S APCHTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I APCHTX5="" Q ""  ;not a valid taxonomy
 S APCHDX4=""  ;return value
 S APCHDXBD=9999999-BDATE,APCHDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S APCHDX1=APCHDXED-1 F  S APCHDX1=$O(^AUPNVPOV("AA",P,APCHDX1)) Q:APCHDX1=""!(APCHDX1>APCHDXBD)!(APCHDX4]"")  D
 .S APCHDX2=0 F  S APCHDX2=$O(^AUPNVPOV("AA",P,APCHDX1,APCHDX2)) Q:APCHDX2'=+APCHDX2!(APCHDX4]"")  D
 ..S APCHDX3=$P($G(^AUPNVPOV(APCHDX2,0)),U)
 ..Q:APCHDX3=""  ;bad xref
 ..Q:'$D(^ICD9(APCHDX3))
 ..Q:'$$ICD^ATXCHK(APCHDX3,APCHTX5,9)
 ..S APCHDX4=1_"^"_$P($$ICDDX^ICDCODE(APCHDX3,,,1),U,2)_"^"_(9999999-APCHDX1)_"^"_APCHDX3_"^"_APCHDX2
 ..Q
 .Q
 Q APCHDX4
LASTDXI(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN APCHDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 NEW APCHDX1,APCHDX2,APCHDX3,APCHDX5,APCHTX5,APCHDXBD,APCHDXED
 S (APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S APCHTX5=+$$CODEN^ICDCODE(T,80)
 I APCHTX5=""!(APCHTX5=-1) Q ""  ;not a CODE
 S APCHDX4=""  ;return value
 S APCHDXBD=9999999-BDATE,APCHDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S APCHDX1=APCHDXED-1 F  S APCHDX1=$O(^AUPNVPOV("AA",P,APCHDX1)) Q:APCHDX1=""!(APCHDX1>APCHDXBD)!(APCHDX4]"")  D
 .S APCHDX2=0 F  S APCHDX2=$O(^AUPNVPOV("AA",P,APCHDX1,APCHDX2)) Q:APCHDX2'=+APCHDX2!(APCHDX4]"")  D
 ..S APCHDX3=$P($G(^AUPNVPOV(APCHDX2,0)),U)
 ..Q:APCHDX3=""  ;bad xref
 ..Q:APCHDX3'=APCHTX5
 ..S APCHDX4=1_"^"_$P($$ICDDX^ICDCODE(APCHDX3,,,1),U,2)_"^"_(9999999-APCHDX1)_"^"_APCHDX3_"^"_APCHDX2
 ..Q
 .Q
 Q APCHDX4
LASTPRC(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN APCHDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 NEW APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5,APCHDXBD,APCHDXED
 S (APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S APCHTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I APCHTX5="" Q ""  ;not a valid taxonomy
 S APCHDX4=""  ;return value
 S APCHDXBD=9999999-BDATE,APCHDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S APCHDX1=APCHDXED-1 F  S APCHDX1=$O(^AUPNVPRC("AA",P,APCHDX1)) Q:APCHDX1=""!(APCHDX1>APCHDXBD)!(APCHDX4]"")  D
 .S APCHDX2=0 F  S APCHDX2=$O(^AUPNVPRC("AA",P,APCHDX1,APCHDX2)) Q:APCHDX2'=+APCHDX2!(APCHDX4]"")  D
 ..S APCHDX3=$P($G(^AUPNVPRC(APCHDX2,0)),U)
 ..Q:APCHDX3=""  ;bad xref
 ..Q:'$$ICD^ATXCHK(APCHDX3,APCHTX5,0)
 ..S APCHDX4=1_"^"_$P($$ICDOP^ICDCODE(APCHDX3),U,2)_"^"_(9999999-APCHDX1)_"^"_APCHDX3_"^"_APCHDX2
 ..Q
 .Q
 Q APCHDX4
 ;
LASTPRCI(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN APCHDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 NEW APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5,APCHDXBD,APCHDXED
 S (APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S APCHTX5=+$$CODEN^ICDCODE(T,80.1)
 I APCHTX5=""!(APCHTX5=-1) Q ""  ;not a valid PROC
 S APCHDX4=""  ;return value
 S APCHDXBD=9999999-BDATE,APCHDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S APCHDX1=APCHDXED-1 F  S APCHDX1=$O(^AUPNVPRC("AA",P,APCHDX1)) Q:APCHDX1=""!(APCHDX1>APCHDXBD)!(APCHDX4]"")  D
 .S APCHDX2=0 F  S APCHDX2=$O(^AUPNVPRC("AA",P,APCHDX1,APCHDX2)) Q:APCHDX2'=+APCHDX2!(APCHDX4]"")  D
 ..S APCHDX3=$P($G(^AUPNVPRC(APCHDX2,0)),U)
 ..Q:APCHDX3=""  ;bad xref
 ..Q:APCHTX5'=APCHDX3
 ..S APCHDX4=1_"^"_$P($$ICDOP^ICDCODE(APCHDX3),U,2)_"^"_(9999999-APCHDX1)_"^"_APCHDX3_"^"_APCHDX2
 ..Q
 .Q
 Q APCHDX4
CPTI(P,BDATE,EDATE,CPTI) ;EP - did patient have this cpt (ien) in date range
 I '$G(P) Q ""
 I $G(CPTI)="" Q ""
 I $G(BDATE)="" Q ""
 I $G(EDATE)="" Q ""
 I '$D(^ICPT(CPTI)) Q ""  ;not a valid cpt ien
 I '$D(^AUPNVCPT("AA",P)) Q ""  ;no cpts for this patient
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE-1,BD=9999999-BDATE,G=""
 F  S ED=$O(^AUPNVCPT("AA",P,CPTI,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  S G="1"_"^"_(9999999-ED)
 Q G
 ;
LASTCPTI(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN APCHDX4=1 or 0^CPT code^date found^IEN OF CPT CODE^IEN OF V CPT
 NEW APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5,APCHDXBD,APCHDXED
 S (APCHDX1,APCHDX2,APCHDX3,APCHDX4,APCHTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S APCHTX5=+$$CODEN^ICPTCOD(T)
 I APCHTX5="" Q ""  ;not a valid CPT
 S APCHDX4=""  ;return value
 S APCHDXBD=9999999-BDATE,APCHDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S APCHDX1=APCHDXED-1 F  S APCHDX1=$O(^AUPNVCPT("AA",P,APCHTX5,APCHDX1)) Q:APCHDX1=""!(APCHDX1>APCHDXBD)!(APCHDX4]"")  D
 .S APCHDX2=0 F  S APCHDX2=$O(^AUPNVCPT("AA",P,APCHTX5,APCHDX1,APCHDX2)) Q:APCHDX2'=+APCHDX2!(APCHDX4]"")  D
 ..S APCHDX3=$P($G(^AUPNVCPT(APCHDX2,0)),U)
 ..Q:APCHDX3=""  ;bad xref
 ..Q:APCHTX5'=APCHDX3
 ..S APCHDX4=1_"^"_$P($$CPT^ICPTCOD(APCHDX3),U,2)_"^"_(9999999-APCHDX1)_"^"_APCHDX3_"^"_APCHDX2
 ..Q
 .Q
 Q APCHDX4
CPTREFT(P,BDATE,EDATE,T) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,81,I)) Q:I=""!($P(G,U)]"")  D
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X!($P(G,U)]"")  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..Q:'$$ICD^ATXCHK(I,T,1)
 ..S G=$$TYPEREF^APCHSMU(Y)_$E($$VAL^XBDIQ1(81,I,$$FFD^APCHSMU(81)),1,(44-$L($$TYPEREF^APCHSMU(Y))))_"^on "_$$FMTE^XLFDT(D)_"^"_D
 .Q
 Q G
RADREF(P,BDATE,EDATE,T) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I,C
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,71,I)) Q:I=""!($P(G,U)]"")  D
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,71,I,X)) Q:X'=+X!($P(G,U)]"")  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,71,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..S C=$P($G(^RAMIS(71,I,0)),U,9) Q:C=""
 ..Q:'$$ICD^ATXCHK(C,T,1)
 ..S N=$P(^AUPNPREF(Y,0),U,7)
 ..S G=$$TYPEREF^APCHSMU(Y)_$E($$VAL^XBDIQ1(81,C,$$FFD^APCHSMU(81)),1,(44-$L($$TYPEREF^APCHSMU(Y))))_"^on "_$$FMTE^XLFDT(D)_"^"_D
 .Q
 Q G
 ;
LASTTD(P) ;EP
 I '$G(P) Q ""
 Q $$LASTTD^APCLAPI4(P)
