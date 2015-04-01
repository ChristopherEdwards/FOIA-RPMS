BUD8UTL1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 02 Jul 2008 2:07 PM ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
 ;
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
LASTDX(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BUDDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 S (BUDDX1,BUDDX2,BUDDX3,BUDDX4,BUDTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BUDTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BUDTX5="" Q ""  ;not a valid taxonomy
 S BUDDX4=""  ;return value
 S BUDDXBD=9999999-BDATE,BUDDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BUDDX1=BUDDXED-1 F  S BUDDX1=$O(^AUPNVPOV("AA",P,BUDDX1)) Q:BUDDX1=""!(BUDDX1>BUDDXBD)!(BUDDX4]"")  D
 .S BUDDX2=0 F  S BUDDX2=$O(^AUPNVPOV("AA",P,BUDDX1,BUDDX2)) Q:BUDDX2'=+BUDDX2!(BUDDX4]"")  D
 ..S BUDDX3=$P($G(^AUPNVPOV(BUDDX2,0)),U)
 ..Q:BUDDX3=""  ;bad xref
 ..Q:'$D(^ICD9(BUDDX3))
 ..Q:'$$ICD^ATXCHK(BUDDX3,BUDTX5,9)
 ..S BUDDX4=1_"^"_$P($$ICDDX^ICDCODE(BUDDX3),U,2)_"^"_(9999999-BUDDX1)_"^"_BUDDX3_"^"_BUDDX2
 ..Q
 .Q
 Q BUDDX4
LASTDXI(P,T,BDATE,EDATE,SC) ;EP
 I '$G(P) Q ""
 S SC=$G(SC)
 ;RETURN BUDDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 NEW BUDDX1,BUDDX2,BUDDX3,BUDDX5,BUDTX5,BUDDX4,BUDDXV
 S (BUDDX1,BUDDX2,BUDDX3,BUDDX4,BUDTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 ;S BUDTX5=$O(^ICD9("AB",T,0))  ;get taxonomy ien
 S BUDTX5=+$$CODEN^ICDCODE(T,80)
 I BUDTX5'>0 Q ""  ;not a valid code
 S BUDDX4=""  ;return value
 S BUDDXBD=9999999-BDATE,BUDDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BUDDX1=BUDDXED-1 F  S BUDDX1=$O(^AUPNVPOV("AA",P,BUDDX1)) Q:BUDDX1=""!(BUDDX1>BUDDXBD)!(BUDDX4]"")  D
 .S BUDDX2=0 F  S BUDDX2=$O(^AUPNVPOV("AA",P,BUDDX1,BUDDX2)) Q:BUDDX2'=+BUDDX2!(BUDDX4]"")  D
 ..S BUDDX3=$P($G(^AUPNVPOV(BUDDX2,0)),U)
 ..Q:BUDDX3=""  ;bad xref
 ..Q:BUDDX3'=BUDTX5
 ..S BUDDXV=$P(^AUPNVPOV(BUDDX2,0),U,3)
 ..I '$D(^AUPNVSIT(BUDDXV,0)) Q  ;no visit entry
 ..I SC]"",SC'[$P(^AUPNVSIT(BUDDXV,0),U,7)
 ..S BUDDX4=1_"^"_$P($$ICDDX^ICDCODE(BUDDX3),U,2)_"^"_(9999999-BUDDX1)_"^"_BUDDX3_"^"_BUDDX2
 ..Q
 .Q
 Q BUDDX4
LASTPRC(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BUDDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 S (BUDDX1,BUDDX2,BUDDX3,BUDDX4,BUDTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BUDTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BUDTX5="" Q ""  ;not a valid taxonomy
 S BUDDX4=""  ;return value
 S BUDDXBD=9999999-BDATE,BUDDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BUDDX1=BUDDXED-1 F  S BUDDX1=$O(^AUPNVPRC("AA",P,BUDDX1)) Q:BUDDX1=""!(BUDDX1>BUDDXBD)!(BUDDX4]"")  D
 .S BUDDX2=0 F  S BUDDX2=$O(^AUPNVPRC("AA",P,BUDDX1,BUDDX2)) Q:BUDDX2'=+BUDDX2!(BUDDX4]"")  D
 ..S BUDDX3=$P($G(^AUPNVPRC(BUDDX2,0)),U)
 ..Q:BUDDX3=""  ;bad xref
 ..Q:'$$ICD^ATXCHK(BUDDX3,BUDTX5,0)
 ..S BUDDX4=1_"^"_$P($$ICDOP^ICDCODE(BUDDX3),U,2)_"^"_(9999999-BUDDX1)_"^"_BUDDX3_"^"_BUDDX2
 ..Q
 .Q
 Q BUDDX4
 ;
LASTPRCI(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BUDDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 S (BUDDX1,BUDDX2,BUDDX3,BUDDX4,BUDTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 ;S BUDTX5=$O(^ICD0("AB",T,0))  ;get ICD PROC ien
 S BUDTX5=+$$CODEN^ICDCODE(T,80.1)
 I BUDTX5'>0 Q ""  ;not a valid PROC
 S BUDDX4=""  ;return value
 S BUDDXBD=9999999-BDATE,BUDDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BUDDX1=BUDDXED-1 F  S BUDDX1=$O(^AUPNVPRC("AA",P,BUDDX1)) Q:BUDDX1=""!(BUDDX1>BUDDXBD)!(BUDDX4]"")  D
 .S BUDDX2=0 F  S BUDDX2=$O(^AUPNVPRC("AA",P,BUDDX1,BUDDX2)) Q:BUDDX2'=+BUDDX2!(BUDDX4]"")  D
 ..S BUDDX3=$P($G(^AUPNVPRC(BUDDX2,0)),U)
 ..Q:BUDDX3=""  ;bad xref
 ..Q:BUDTX5'=BUDDX3
 ..S BUDDX4=1_"^"_$P($$ICDOP^ICDCODE(BUDDX3),U,2)_"^"_(9999999-BUDDX1)_"^"_BUDDX3_"^"_BUDDX2
 ..Q
 .Q
 Q BUDDX4
FIRSTPRC(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BUDDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 S (BUDDX1,BUDDX2,BUDDX3,BUDDX4,BUDTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BUDTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BUDTX5="" Q ""  ;not a valid taxonomy
 S BUDDX4=""  ;return value
 S BUDX=0 F  S BUDX=$O(^AUPNVPRC("AC",P,BUDX)) Q:BUDX'=+BUDX!(BUDDX4]"")  D
 .S BUDDX3=$P($G(^AUPNVPRC(BUDX,0)),U)
 .Q:BUDDX3=""  ;BAD XREF
 .Q:'$$ICD^ATXCHK(BUDDX3,BUDTX5,0)
 .S D=$P(^AUPNVPRC(BUDX,0),U,3)
 .Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .Q:D<BDATE
 .Q:D>EDATE
 .S BUDDX4=1_"^"_$P($$ICDOP^ICDCODE(BUDDX3),U,2)_"^"_D_"^"_BUDDX3_"^"_BUDX
 .Q
 Q BUDDX4
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
 I BUDVALUE="" Q 0
 I BUDINDT="E",BUDVALUE]"",BUDAGEB>64 Q 1
 I BUDINDT="E",BUDVALUE]"",BUDAGEB<65 Q 0
 I BUDVALUE]"" Q 1
 Q 0
I12() ;EP
 I BUDINDT="D",BUDD4 Q 1
 I BUDINDT="D",'BUDD4 Q 0
 I BUDINDT="E",(BUDD3+BUDD7) Q 1
 I BUDINDT="E",'(BUDD3+BUDD7) Q 0
 I (BUDD1+BUDD2+BUDD3+BUDD4+BUDD5+BUDD6+BUDD7) Q 1
 Q 0
I13() ;EP
 I BUDINDT="D",BUDD2 Q 1
 I BUDINDT="D",'BUDD2 Q 0
 I BUDINDT="E",(BUDD3+BUDD1) Q 1
 I BUDINDT="E",'(BUDD3+BUDD1) Q 0
 I (BUDD1+BUDD2+BUDD3) Q 1
 Q 0
IA() ;EP
 ;TESTING ONLY
 NEW X
 S X=BUDN1
 I BUDINDT="D",BUDD7,'X Q 1
 I BUDINDT="D",BUDD7,X Q 0   ;XXXX CHANGE TO Q 0 AFTER TESTING
 I BUDINDT="D",'BUDD7 Q 0
 I BUDINDT="C",BUDD8,'X Q 1
 I BUDINDT="C",BUDD8,X Q 0  ;XXXX CHANGE TO Q 0
 I BUDINDT="C",'BUDD8 Q 0
 I BUDINDT="S" I (BUDD1+BUDD2+BUDD3+BUDD4+BUDD5+BUDD6+BUDD7+BUDD8) Q $S(X:0,1:1)  ;LORI **** CHANGE x:1 TO x:0 AFTER TESTING
 Q 0
I17() ;EP
 I 'BUDD1 Q 0
 I BUDINDT="W" Q $S(BUDSEX="F":1,1:0)
 Q 1
I25() ;EP
 I BUDINDT="D" Q BUDDMD2
 I 'BUDD1 Q 0
 I BUDINDT="W" Q $S(BUDSEX="F":1,1:0)
 Q 1
LASTECOD(P,T,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 ;RETURN BUDDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 S (BUDDX1,BUDDX2,BUDDX3,BUDDX4,BUDTX5,BUDDX6,BUDDX7)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(P,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BUDTX5=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I BUDTX5="" Q ""  ;not a valid taxonomy
 S BUDDX4=""  ;return value
 S BUDDXBD=9999999-BDATE,BUDDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BUDDX1=BUDDXED-1 F  S BUDDX1=$O(^AUPNVPOV("AA",P,BUDDX1)) Q:BUDDX1=""!(BUDDX1>BUDDXBD)!(BUDDX4]"")  D
 .S BUDDX2=0 F  S BUDDX2=$O(^AUPNVPOV("AA",P,BUDDX1,BUDDX2)) Q:BUDDX2'=+BUDDX2!(BUDDX4]"")  D
 ..F BUDDX6=9,18,19 S BUDDX3=$P($G(^AUPNVPOV(BUDDX2,0)),U,BUDDX6)  D
 ...Q:BUDDX3=""  ;no ecode
 ...I $$ICD^ATXCHK(BUDDX3,BUDTX5,9) S BUDDX4=1_"^"_$P($$ICDDX^ICDCODE(BUDDX3),U,2)_"^"_(9999999-BUDDX1)_"^"_BUDDX3_"^"_BUDDX2
 ..Q
 .Q
 Q BUDDX4
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
