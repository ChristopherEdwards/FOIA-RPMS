BGP8UTL1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ; 02 Jul 2008  2:07 PM
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
LASTDX(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BGPTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BGPTX5="" Q ""  ;not a valid taxonomy
 S BGPDX4=""  ;return value
 S BGPDXBD=9999999-BDATE,BGPDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BGPDX1=BGPDXED-1 F  S BGPDX1=$O(^AUPNVPOV("AA",P,BGPDX1)) Q:BGPDX1=""!(BGPDX1>BGPDXBD)!(BGPDX4]"")  D
 .S BGPDX2=0 F  S BGPDX2=$O(^AUPNVPOV("AA",P,BGPDX1,BGPDX2)) Q:BGPDX2'=+BGPDX2!(BGPDX4]"")  D
 ..S BGPDX3=$P($G(^AUPNVPOV(BGPDX2,0)),U)
 ..Q:BGPDX3=""  ;bad xref
 ..Q:'$D(^ICD9(BGPDX3))
 ..Q:'$$ICD^ATXCHK(BGPDX3,BGPTX5,9)
 ..S BGPDX4=1_"^"_$P($$ICDDX^ICDCODE(BGPDX3),U,2)_"^"_(9999999-BGPDX1)_"^"_BGPDX3_"^"_BGPDX2
 ..Q
 .Q
 Q BGPDX4
LASTDXI(P,T,BDATE,EDATE,SC) ;EP
 I '$G(P) Q ""
 S SC=$G(SC)
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 NEW BGPDX1,BGPDX2,BGPDX3,BGPDX5,BGPTX5,BGPDX4,BGPDXV
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 ;S BGPTX5=$O(^ICD9("AB",T,0))  ;get taxonomy ien
 S BGPTX5=+$$CODEN^ICDCODE(T,80)
 I BGPTX5'>0 Q ""  ;not a valid code
 S BGPDX4=""  ;return value
 S BGPDXBD=9999999-BDATE,BGPDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BGPDX1=BGPDXED-1 F  S BGPDX1=$O(^AUPNVPOV("AA",P,BGPDX1)) Q:BGPDX1=""!(BGPDX1>BGPDXBD)!(BGPDX4]"")  D
 .S BGPDX2=0 F  S BGPDX2=$O(^AUPNVPOV("AA",P,BGPDX1,BGPDX2)) Q:BGPDX2'=+BGPDX2!(BGPDX4]"")  D
 ..S BGPDX3=$P($G(^AUPNVPOV(BGPDX2,0)),U)
 ..Q:BGPDX3=""  ;bad xref
 ..Q:BGPDX3'=BGPTX5
 ..S BGPDXV=$P(^AUPNVPOV(BGPDX2,0),U,3)
 ..I '$D(^AUPNVSIT(BGPDXV,0)) Q  ;no visit entry
 ..I SC]"",SC'[$P(^AUPNVSIT(BGPDXV,0),U,7)
 ..S BGPDX4=1_"^"_$P($$ICDDX^ICDCODE(BGPDX3),U,2)_"^"_(9999999-BGPDX1)_"^"_BGPDX3_"^"_BGPDX2
 ..Q
 .Q
 Q BGPDX4
LASTPRC(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BGPTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BGPTX5="" Q ""  ;not a valid taxonomy
 S BGPDX4=""  ;return value
 S BGPDXBD=9999999-BDATE,BGPDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BGPDX1=BGPDXED-1 F  S BGPDX1=$O(^AUPNVPRC("AA",P,BGPDX1)) Q:BGPDX1=""!(BGPDX1>BGPDXBD)!(BGPDX4]"")  D
 .S BGPDX2=0 F  S BGPDX2=$O(^AUPNVPRC("AA",P,BGPDX1,BGPDX2)) Q:BGPDX2'=+BGPDX2!(BGPDX4]"")  D
 ..S BGPDX3=$P($G(^AUPNVPRC(BGPDX2,0)),U)
 ..Q:BGPDX3=""  ;bad xref
 ..Q:'$$ICD^ATXCHK(BGPDX3,BGPTX5,0)
 ..S BGPDX4=1_"^"_$P($$ICDOP^ICDCODE(BGPDX3),U,2)_"^"_(9999999-BGPDX1)_"^"_BGPDX3_"^"_BGPDX2
 ..Q
 .Q
 Q BGPDX4
 ;
LASTPRCI(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 ;S BGPTX5=$O(^ICD0("AB",T,0))  ;get ICD PROC ien
 S BGPTX5=+$$CODEN^ICDCODE(T,80.1)
 I BGPTX5'>0 Q ""  ;not a valid PROC
 S BGPDX4=""  ;return value
 S BGPDXBD=9999999-BDATE,BGPDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BGPDX1=BGPDXED-1 F  S BGPDX1=$O(^AUPNVPRC("AA",P,BGPDX1)) Q:BGPDX1=""!(BGPDX1>BGPDXBD)!(BGPDX4]"")  D
 .S BGPDX2=0 F  S BGPDX2=$O(^AUPNVPRC("AA",P,BGPDX1,BGPDX2)) Q:BGPDX2'=+BGPDX2!(BGPDX4]"")  D
 ..S BGPDX3=$P($G(^AUPNVPRC(BGPDX2,0)),U)
 ..Q:BGPDX3=""  ;bad xref
 ..Q:BGPTX5'=BGPDX3
 ..S BGPDX4=1_"^"_$P($$ICDOP^ICDCODE(BGPDX3),U,2)_"^"_(9999999-BGPDX1)_"^"_BGPDX3_"^"_BGPDX2
 ..Q
 .Q
 Q BGPDX4
FIRSTPRC(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BGPTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BGPTX5="" Q ""  ;not a valid taxonomy
 S BGPDX4=""  ;return value
 S BGPX=0 F  S BGPX=$O(^AUPNVPRC("AC",P,BGPX)) Q:BGPX'=+BGPX!(BGPDX4]"")  D
 .S BGPDX3=$P($G(^AUPNVPRC(BGPX,0)),U)
 .Q:BGPDX3=""  ;BAD XREF
 .Q:'$$ICD^ATXCHK(BGPDX3,BGPTX5,0)
 .S D=$P(^AUPNVPRC(BGPX,0),U,3)
 .Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .Q:D<BDATE
 .Q:D>EDATE
 .S BGPDX4=1_"^"_$P($$ICDOP^ICDCODE(BGPDX3),U,2)_"^"_D_"^"_BGPDX3_"^"_BGPX
 .Q
 Q BGPDX4
NMIREF(P,F,I,B,E) ;EP
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW G,X,Y,%DT S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  D
 .S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  D
 ..Q:$P(^AUPNPREF(Y,0),U,7)'="N"
 ..S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 Q G
REFUSAL(P,F,I,B,E) ;EP
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW G,X,Y,%DT S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 Q G
RADREF(P,BDATE,EDATE,T) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,71,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,71,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,71,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..S C=$P($G(^RAMIS(71,I,0)),U,9) Q:C=""
 ..Q:'$$ICD^ATXCHK(C,T,1)
 ..S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 .Q
 Q G
I1() ;EP
 I BGPVALUE="" Q 0
 I BGPINDT="E",BGPVALUE]"",BGPAGEB>64 Q 1
 I BGPINDT="E",BGPVALUE]"",BGPAGEB<65 Q 0
 I BGPVALUE]"" Q 1
 Q 0
I12() ;EP
 I BGPINDT="D",BGPD4 Q 1
 I BGPINDT="D",'BGPD4 Q 0
 I BGPINDT="E",(BGPD3+BGPD7) Q 1
 I BGPINDT="E",'(BGPD3+BGPD7) Q 0
 I (BGPD1+BGPD2+BGPD3+BGPD4+BGPD5+BGPD6+BGPD7) Q 1
 Q 0
I13() ;EP
 I BGPINDT="D",BGPD2 Q 1
 I BGPINDT="D",'BGPD2 Q 0
 I BGPINDT="E",(BGPD3+BGPD1) Q 1
 I BGPINDT="E",'(BGPD3+BGPD1) Q 0
 I (BGPD1+BGPD2+BGPD3) Q 1
 Q 0
IA() ;EP
 ;TESTING ONLY
 NEW X
 S X=BGPN1
 I BGPINDT="D",BGPD7,'X Q 1
 I BGPINDT="D",BGPD7,X Q 0   ;XXXX CHANGE TO Q 0 AFTER TESTING
 I BGPINDT="D",'BGPD7 Q 0
 I BGPINDT="C",BGPD8,'X Q 1
 I BGPINDT="C",BGPD8,X Q 0  ;XXXX CHANGE TO Q 0
 I BGPINDT="C",'BGPD8 Q 0
 I BGPINDT="S" I (BGPD1+BGPD2+BGPD3+BGPD4+BGPD5+BGPD6+BGPD7+BGPD8) Q $S(X:0,1:1)  ;LORI **** CHANGE x:1 TO x:0 AFTER TESTING
 Q 0
I17() ;EP
 I 'BGPD1 Q 0
 I BGPINDT="W" Q $S(BGPSEX="F":1,1:0)
 Q 1
I25() ;EP
 I BGPINDT="D" Q BGPDMD2
 I 'BGPD1 Q 0
 I BGPINDT="W" Q $S(BGPSEX="F":1,1:0)
 Q 1
LASTECOD(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5,BGPDX6,BGPDX7)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BGPTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BGPTX5="" Q ""  ;not a valid taxonomy
 S BGPDX4=""  ;return value
 S BGPDXBD=9999999-BDATE,BGPDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BGPDX1=BGPDXED-1 F  S BGPDX1=$O(^AUPNVPOV("AA",P,BGPDX1)) Q:BGPDX1=""!(BGPDX1>BGPDXBD)!(BGPDX4]"")  D
 .S BGPDX2=0 F  S BGPDX2=$O(^AUPNVPOV("AA",P,BGPDX1,BGPDX2)) Q:BGPDX2'=+BGPDX2!(BGPDX4]"")  D
 ..F BGPDX6=9,18,19 S BGPDX3=$P($G(^AUPNVPOV(BGPDX2,0)),U,BGPDX6)  D
 ...Q:BGPDX3=""  ;no ecode
 ...I $$ICD^ATXCHK(BGPDX3,BGPTX5,9) S BGPDX4=1_"^"_$P($$ICDDX^ICDCODE(BGPDX3),U,2)_"^"_(9999999-BGPDX1)_"^"_BGPDX3_"^"_BGPDX2
 ..Q
 .Q
 Q BGPDX4
REFTAX(P,F,T,B,E) ;EP - refused an item in a taxonomy
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(T) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW G,X,Y,%DT,T1 S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S T1=0,G="" F  S T1=$O(^ATXAX(T,21,"B",T1)) Q:T1=""!(G)  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,T1,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,T1,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 Q G
CPTREFT(P,BDATE,EDATE,T) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,81,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..Q:'$$ICD^ATXCHK(I,T,1)
 ..S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 .Q
 Q G
PRCREFT(P,BDATE,EDATE,T) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,80.1,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,80.1,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,80.1,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..Q:'$$ICD^ATXCHK(I,T,0)
 ..S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 .Q
 Q G
