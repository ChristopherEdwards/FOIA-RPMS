BGPMUUT2 ; IHS/MSC/MGH - MEANINGFUL USE UTILITIES 02 Jul 2008 2:07 PM ;01-Mar-2011 15:32;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
 ;
NPI(USR) ;Return the NPI for the selected Provider
 Q $S($D(^VA(200,USR,"NPI")):$P(^VA(200,USR,"NPI"),U),1:"UNKNOWN")
TIN(USR) ;Return the Tax ID number for selected Provider
 Q $S($D(^VA(200,USR,"TPB")):$P(^VA(200,USR,"TPB"),U,2),1:"UNKNOWN")
INITIALS(USR) ;Return the initials for selected Provider
 Q $S($D(^VA(200,USR,0)):$P(^VA(200,USR,0),U,2),1:"UNKNOWN")
LASTDX(DFN,BDATE,EDATE,TAX) ;EP
 I '$G(DFN) Q 0
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(DFN,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BGPTX5=$O(^ATXAX("B",TAX,0))  ;get taxonomy ien
 I BGPTX5="" Q 0  ;not a valid taxonomy
 S BGPDX4=0  ;return value
 S BGPDXBD=9999999-BDATE,BGPDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BGPDX1=BGPDXED-1 F  S BGPDX1=$O(^AUPNVPOV("AA",DFN,BGPDX1)) Q:BGPDX1=""!(BGPDX1>BGPDXBD)!(BGPDX4'=0)  D
 .S BGPDX2=0 F  S BGPDX2=$O(^AUPNVPOV("AA",DFN,BGPDX1,BGPDX2)) Q:BGPDX2'=+BGPDX2!(BGPDX4'=0)  D
 ..S BGPDX3=$P($G(^AUPNVPOV(BGPDX2,0)),U)
 ..Q:BGPDX3=""  ;bad xref
 ..Q:'$D(^ICD9(BGPDX3))
 ..Q:'$$ICD^ATXCHK(BGPDX3,BGPTX5,9)
 ..S BGPDX4=1_"^"_$P($$ICDDX^ICDCODE(BGPDX3),U,2)_"^"_(9999999-BGPDX1)_"^"_BGPDX3_"^"_BGPDX2
 Q BGPDX4
LASTDXI(P,T,BDATE,EDATE,SC) ;EP
 ; P  = DFN
 ; T  = Diagnosis Code
 ; SC = Cause of DX (see field 07 of V POV file)
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
LASTPRC(DFN,BDATE,EDATE,TAX) ;EP
 I '$G(DFN) Q 0
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V PROC
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPTX5)=""
 I $G(BDATE)="" S BDATE=$P(^DPT(DFN,0),U,3)  ;if no date then set to DOB
 I $G(EDATE)="" S EDATE=DT  ;if no end date then set to today
 S BGPTX5=$O(^ATXAX("B",TAX,0))  ;get taxonomy ien
 I BGPTX5="" Q ""  ;not a valid taxonomy
 S BGPDX4=0  ;return value
 S BGPDXBD=9999999-BDATE,BGPDXED=9999999-EDATE  ;get inverse date and begin at edate-1 and end when greater than begin date
 S BGPDX1=BGPDXED-1 F  S BGPDX1=$O(^AUPNVPRC("AA",DFN,BGPDX1)) Q:BGPDX1=""!(BGPDX1>BGPDXBD)!(+BGPDX4)  D
 .S BGPDX2=0 F  S BGPDX2=$O(^AUPNVPRC("AA",DFN,BGPDX1,BGPDX2)) Q:BGPDX2'=+BGPDX2!(+BGPDX4)  D
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
REFUSAL(P,F,I,B,E) ;EP  (PAT,FILE,ITEM,BDT,EDT) 
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 ;backup the begin date by 1 day to accomodate the > check below
 S B=$$FMADD^XLFDT(B,-1)
 NEW G,X,Y,%DT S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 Q G
MEDREF(PAT,BDT,EDT,TAX) ;EP
 NEW G,X,Y,%DT,NDC,NDCCODE,REASON,NDCF
 ;S X=BDT,%DT="P" D ^%DT S BDT=Y
 ;S X=EDT,%DT="P" D ^%DT S EDT=Y
 S (ITEM,G)=0 F  S ITEM=$O(^AUPNPREF("AA",PAT,50,ITEM)) Q:'+ITEM!(G)  D
 .;See if this item is in the taxonomy
 .S NDC=$P($G(^PSDRUG(ITEM,2)),U,4)
 .Q:'NDC
 .;Setup the NDC code for a proper lookup in the taxonomy
 .S NDCCODE=$$RJ^XLFSTR($P(NDC,"-"),5,0)_$$RJ^XLFSTR($P(NDC,"-",2),4,0)_$$RJ^XLFSTR($P(NDC,"-",3),2,0)
 .;call the taxonomy lookup
 .S NDCF=$$MEDTAX^BGPMUUT3(DFN,NDCCODE,TAX)
 .I +NDCF D
 ..;Now check dates and reason
 ..S X=0 F  S X=$O(^AUPNPREF("AA",PAT,50,ITEM,X)) Q:X'=+X!(G)  D
 ...S Y=0 F  S Y=$O(^AUPNPREF("AA",PAT,50,ITEM,X,Y)) Q:Y'=+Y  D
 ....S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDT&(D'>EDT) D
 .....S REASON=$P(^AUPNPREF(Y,0),U,7)
 .....I REASON="R"!(REASON="N") S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
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
LABREF(P,BDATE,EDATE,LT,CT) ;EP - return date and reason for refusal of LAB (LOINC)
 ; P     = Patient IEN
 ; BDATE = begin date to search
 ; EDATE = end date to search
 ; LT    = Taxonomy name for LOINC check
 ; CT    = Taxonomy name for CPT check
 I '$G(P) Q ""
 I $G(LT)="" Q ""
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 NEW G,X,Y,Z,I
 S C=""
 S G=0
 S I=0 F  S I=$O(^AUPNPREF("AA",P,60,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,60,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,60,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<BDATE&(D'>EDATE) D
 ..S BGPH=0 F  S BGPH=$O(^LAB(60,I,1,BGPH)) Q:BGPH'>0  D
 ...S L=$P($G(^LAB(60,I,1,BGPH,95.3)),U,1)
 ...I L'="" I $$LOINCREF(L,LT) S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 ...Q:+G
 ...S C=$P($G(^LAB(60,I,1,BGPH,3)),U,1)
 ...I L'="" I $$ICD^ATXCHK(C,CT,1) S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)
 Q G
LOINCREF(C,T) ;check taxonomy T for LOINC code; passed in LOINC code might not have the check digit
 N TIEN
 S TIEN="" S TIEN=$O(^ATXAX("B",T,TIEN)) Q:'TIEN 0
 Q +$O(^ATXAX(TIEN,21,"B",$P(C,"-",1)_"-"))
 ;
LASTECOD(P,T,BDATE,EDATE) ;EP
 N BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPDX5,BGPDX6,BGPDX7,BGPDXBD,BGPDXED
 I '$G(P) Q ""
 ;RETURN BGPDX4=1 or 0^dx code^date found^IEN OF ICD CODE^IEN OF V POV
 S (BGPDX1,BGPDX2,BGPDX3,BGPDX4,BGPDX5,BGPDX6,BGPDX7)=""
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
REFTAX(PAT,FILE,TAX,BEG,END) ;EP - refused an item in a taxonomy
 I '$G(PAT) Q 0
 I '$G(FILE) Q 0
 I $G(TAX)="" Q 0
 I $G(BEG)="" Q 0
 I $G(END)="" Q 0
 NEW G,X,Y,%DT,T1,TIEN,T1PTR
 S X=BEG,%DT="P" D ^%DT S BEG=Y
 ;S X=END,%DT="P" D ^%DT S E=Y
 S TIEN=$O(^ATXAX("B",TAX,0))  ;get taxonomy ien
 S T1=0,G="" F  S T1=$O(^ATXAX(TIEN,21,"B",T1)) Q:T1=""!(G)  D
 .S T1PTR=$S(FILE=80:$P($$ICDDX^ICDCODE(T1),U),FILE=80.1:$P($$ICDOP^ICDCODE(T1),U),FILE=81:$P($$CPT^ICPTCOD(T1),U),1:X)
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",PAT,FILE,T1PTR,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNPREF("AA",PAT,FILE,T1PTR,X,Y)) Q:Y'=+Y  D
 ...S D=$P(^AUPNPREF(Y,0),U,3) I D'<BEG&(D'>END) D
 ....I $P(^AUPNPREF(Y,0),U,7)="R"!($P(^AUPNPREF(Y,0),U,7)="N") S G="1^"_D_"^"_$P(^AUPNPREF(Y,0),U,7)_"^"_T1
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
LOINC(DFN,BDATE,EDATE,TAX) ;Retuns IEN of Lab test if pt has this LOINC code
 N IEN,CODE,B,E,D,L,G,X,J
 S (CODE,B,E,D,L,G,X,J)=""
 S IEN=$O(^ATXAX("B",TAX,0))
 Q:'IEN
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",DFN,D)) Q:D'=+D!(D>B)!(G]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",DFN,D,L)) Q:L'=+L!(G]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",DFN,D,L,X)) Q:X'=+X!(G]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...I $$LOINC2(J,IEN) D
 ....S G=(9999999-D)_U_X Q
 Q G
 ;
LOINC2(A,B) ;EP
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) S CODE=% Q 1
 Q ""
 ;
COLD(DFN,BDATE,EDATE,TAX) ;Retuns IEN of Lab test if pt has this LOINC code
 N IEN,CODE,COLDTE,B,E,D,L,G,X,J
 S (CODE,B,E,D,L,G,X,J)=""
 S IEN=$O(^ATXAX("B",TAX,0))
 Q:'IEN
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",DFN,D)) Q:D'=+D!(D>B)!(G]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",DFN,D,L)) Q:L'=+L!(G]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",DFN,D,L,X)) Q:X'=+X!(G]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...S COLDTE=$P($G(^AUPNVLAB(X,12)),U,1)
 ...Q:COLDTE<BDATE!(COLDTE>EDATE)
 ...I $$LOINC2(J,IEN) D
 ....S G=(9999999-D)_U_X_U_$P($G(^AUPNVLAB(X,12)),U,1) Q
 Q G
 ;
GETIMMS(P,EDATE,C,BGPX,CPTLST) ;EP
 K BGPX
 NEW X,Y,I,Z,V
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVIMM(X,0))  ;happens
 .S Y=$P(^AUPNVIMM(X,0),U)
 .Q:'Y  ;happens too
 .S I=$P($G(^AUTTIMM(Y,0)),U,3)  ;get HL7/CVX code
 .F Z=1:1:$L(C,U) I I=$P(C,U,Z) S V=$P(^AUPNVIMM(X,0),U,3) I V S D=$P($P($G(^AUPNVSIT(V,0)),U),".") I D]"",D'>EDATE S BGPX(D)=Y_U_V
 .Q
 I $D(CPTLST) D GIMMCPT(P,EDATE,CPTLST,.BGPX)
 Q
GIMMCPT(P,EDATE,CPTLST,BGPX) ;
 N V,G,X,Y,Z
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Y=$P($$CPT^ICPTCOD(Y),U,2) I $$CPTCHK(CPTLST,Y) S BGPX(9999999-$P(ED,"."))=Y_U_V_U_1
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I $$CPTCHK(CPTLST,Y) S BGPX(9999999-$P(ED,"."))=Y_U_V_U_1
 Q
CPTCHK(CPTLST,Y) ;Check if variable Y is in CPTLST
 N I,FF
 S FF=0
 F I=1:1:$L(CPTLST,U) I $P(CPTLST,U,I)=Y S FF=1 Q
 Q FF
IMMREF(P,IMM,BD,ED) ;EP
 NEW X,Y,G,D,R
 I 'IMM Q ""
 S (X,G)=0,Y=$O(^AUTTIMM("C",IMM,0))
 I 'Y Q ""
 F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=G+1
 Q G
