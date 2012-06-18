BHSDM4 ;IHS/CIA/MGH - Health Summary for Diabetic Supplement ;06-Apr-2009 10:30;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2**;March 17, 2006
 ;===================================================================
 ;VA version of IHS components for supplemental summaries
 ;Taken from APCHS9B4
 ; IHS/TUCSON/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;  [ 05/10/04  6:07 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**3,5,6,7,8,10,11,12**;JUN 24, 1997
 ;Patch 1001 to bring up to patch 15
 ;Patch 2, code set versioning
 ;===================================================================
FRSTDMDX(P,F) ;EP return date of first dm dx
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 NEW X,E,BHSS,Y
 S Y="BHSS("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y) S Y=$P($G(BHSS(1)),U)
 Q $S(F="E":$$FMTE^XLFDT(Y),1:Y)
CMSFDX(P,F) ;EP - return date/dx of dm in register
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 ;NEW R S R=$O(^ACM(41.1,"B","IHS DIABETES",0)) I 'R Q ""
 NEW R,N,D,D1,Y,X,G S R=0,N="",D="" F  S N=$O(^ACM(41.1,"B",N)) Q:N=""!(D]"")  S R=0 F  S R=$O(^ACM(41.1,"B",N,R)) Q:R'=+R!(D]"")  I N["DIAB" D
 .S (G,X)=0,(D,Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X!(D]"")  I $P(^ACM(44,X,0),U,4)=R D
 ..S D=$P($G(^ACM(44,X,"SV")),U,2) I D]"" S D1=D,D=$S(F="E":$$FMTE^XLFDT(D),1:D)
 Q $G(D)
 ;
PLDMDOO(P,F) ;EP get first dm dx from case management
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 ..Q
 .Q
 S D=$O(D(0))
 I D="" Q D
 Q $S(F="E":$$FMTE^XLFDT(D),1:D)
DNKA(V) ;EP is this a DNKA visit?
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D=".0860" Q 1
 S N=$$PRIMPOV^APCLV(V,"N")
 I $E(D)="V",N["DNKA" Q 1
 I $E(D)="V",N["DID NOT KEEP APPOINTMENT" Q 1
 I $E(D)="V",N["DID NOT KEEP APPT" Q 1
 Q 0
REFR(V) ;
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D="367.89"!(D="367.9") Q 1
 Q 0
DFE(P,BHSSED) ;EP
 NEW BHSY,BHSV,%,LDFE S LDFE="",%=P_"^LAST EXAM DIABETIC FOOT EXAM",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LDFE=$P(BHSY(1),U)
 I $D(BHSY(1)),$P(BHSY(1),U)'<BHSSED S BHSX="Yes   "_$$FMTE^XLFDT($P(BHSY(1),U))_" (Diabetic Foot Exam, Complete)" Q BHSX
 ;now check any clinic 65 or prov 33/25
 K BHSY,BHSV
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BHSSED)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"BHSY(")
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(BHSY(%)) Q:%'=+%  S BHSV(9999999-$P(BHSY(%),U),$P(BHSY(%),U,5))=""
 N PROV,D,V,G S (D,V)=0,G="" F  S D=$O(BHSV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BHSV(D,V)) Q:V'=+V!(G)  S PROV=$$PRIMPROV^APCLV(V,"D") I (PROV=33!(PROV=25)),'$$DNKA(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Visit to Podiatrist)"
 S (D,V)=0,G="" F  S D=$O(BHSV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BHSV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I PROV=65!(PROV="B7"),'$$DNKA(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Visit to Podiatry Clinic)"
 S G=$$REFDF^BHSDM3(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0)),$G(LDFE))
 I G]"" Q G
 Q "No    "_$S($D(LDFE):$$FMTE^XLFDT(LDFE),1:"")
 ;
EYE(P,BHSSED) ;EP
 NEW BHSY,LDEE,%,BHSEX S BHSEX=0 S LDEE="",%=P_"^LAST EXAM DIABETIC EYE EXAM",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LDEE=$P(BHSY(1),U),BHSEX=+$P(BHSY(1),U,4)
 I $P($G(BHSY(1)),U)'<BHSSED S BHSX="Yes   "_$$FMTE^XLFDT($P(BHSY(1),U))_" (Diabetic Eye Exam)" Q BHSX
 K BHSY S BHSCPT=""
 NEW T,C,BHSCPT,BHSCPT1
 ;PATCH UPDATES
 F C=992250,92012,92014,92004,92002 S T=$O(^ICPT("B",C,0)) D
 .I T S BHSY=$O(^AUPNVCPT("AA",P,T,0)) I BHSY D
 ..S BHSY=9999999-BHSY
 ..I LDEE<BHSY S LDEE=BHSY,BHSEX=0,BHSCPT=T,BHSCPT1=C
 ;I LDEE,LDEE'<BHSSED Q "Yes   "_$$FMTE^XLFDT(LDEE)_" (CPT "_BHSCPT1_"-"_$E($P(^ICPT(BHSCPT,0),U,2),1,28)_")"
 I LDEE,LDEE'<BHSSED Q "Yes   "_$$FMTE^XLFDT(LDEE)_" (CPT "_BHSCPT1_"-"_$E($P($$CPT^ICPTCOD(BHSCPT,LDEE),U,3),1,28)_")"  ;code set versioning cmi/anch/maw 8/2
 ;END PATCH UPDATES
 ;now check any clinic 17 or 18
 K BHSY,BHSV
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BHSSED)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"BHSY(")
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(BHSY(%)) Q:%'=+%  S BHSV(9999999-$P(BHSY(%),U),$P(BHSY(%),U,5))=""
 N PROV,D,V,G
 S (D,V)=0,G="" F  S D=$O(BHSV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BHSV(D,V)) Q:V'=+V!(G)  S PROV=$$PRIMPROV^APCLV(V,"D") I (PROV=24!(PROV=79)!(PROV="08")),'$$DNKA(V),'$$REFR(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Ophthalmologist or Optometrist Visit)"
 S (D,V)=0,G="" F  S D=$O(BHSV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BHSV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I (PROV=17!(PROV=18)!(PROV=64)),'$$DNKA(V),'$$REFR(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Optometry or Ophthalmology Clinic)"
 S G=$$REFDF^BHSDM3(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0)),$G(LDFE))
 I G]"" Q G
 S %="No    "_$S($D(LDEE):$$FMTE^XLFDT(LDEE),1:"")
 I BHSEX S %=%_" (Diabetic Eye Exam) result: "_$P($$VAL^XBDIQ1(9000010.13,BHSEX,.04),"/",1)
 Q %
RECTAL(P,BHSSED) ;EP
 I $$AGE^AUPNPAT(P)<41 Q "N/A"
 NEW BHSY S %=P_"^LAST EXAM RECTAL",E=$$START1^APCLDF(%,"BHSY(")
 I '$D(BHSY) Q "No    <never recorded>"
 I $P(BHSY(1),U)'<BHSSED S BHSX="Yes   "_$$FMTE^XLFDT($P(BHSY(1),U)) Q BHSX
 Q "No    "_$$FMTE^XLFDT($P(BHSY(1),U))
PAP(P,BHSSED) ;EP
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 ;NEW BHSY S BHSY=$$HYSTER(BHSSDFN,DT) I BHSY]"" Q BHSY
 S LPAP=$$LASTPAP^APCHSMU(P)
 S G=$$REFDF^APCHS9B3(P,60,$O(^LAB(60,"B","PAP SMEAR",0)),$G(LPAP))
 I G]"" Q $G(LPAP)_"^"_G
 Q $G(LPAP)
OLDPAP ;
 NEW BHSY,%,LPAP,D,J,I,T,V
 S LPAP="",%=P_"^LAST LAB PAP SMEAR",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LPAP=$P(BHSY(1),U)
 NEW BHSY,BHSLT,%,LPAP S LPAP="",%=P_"^LAST LAB [BGP PAP SMEAR TAX",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) S LPAP=$P(BHSY(1),U)
 ;Patch 1001 get last pap smear via loinc code
 S BHSLT=$O(^ATXAX("B","BGP PAP LOINC CODES",0))
 I BHSLT D
 .S D=0,G="" F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D=""!(G]"")  D
 ..S T=0 F  S T=$O(^AUPNVLAB("AE",P,D,T)) Q:T=""!(G]"")  D
 ...S I=0 F  S I=$O(^AUPNVLAB("AE",P,D,T,I)) Q:I=""!(G]"")  D
 ....Q:'$D(^AUPNVLAB(I,0))
 ....S J=$P($G(^AUPNVLAB(I,11)),U,13)
 ....Q:J=""
 ....Q:'$$LOINC^APCHS9B2(J,BHSLT)
 ....S V=$P(^AUPNVLAB(I,0),U,3)
 ....S G=$P($P($G(^AUPNVSIT(V,0)),U),".")
 ....Q
 I G]"" D
 .Q:LPAP>G
 .S LPAP=G
 K BHSY S %=P_"^LAST DX V76.2",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LPAP>$P(BHSY(1),U)
 .S LPAP=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 91.46",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LPAP>$P(BHSY(1),U)
 .S LPAP=$P(BHSY(1),U)
 K BHSY NEW % F %=1:1 S T=$T(PAPCPTS+%^BHSMU) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S BHSY(1)=$O(^AUPNVCPT("AA",P,T,0)) I BHSY(1) S BHSY(1)=9999999-BHSY(1) D
 .Q:LPAP>$P(BHSY(1),U)
 .S LPAP=$P(BHSY(1),U)
 S T="PAP SMEAR",T=$O(^BWPN("B",T,0))
 I T S X=$$WH^BHSMU2(P,$$DOB^AUPNPAT(P),DT,T,3)
 I X]"" D
 .Q:LPAP>X
 .S LPAP=X
 S G=$$REFDF^BHSDM3(P,60,$O(^LAB(60,"B","PAP SMEAR",0)),$G(LPAP))
 I G]"" Q $G(LPAP)_"^"_G
 Q $G(LPAP)
BREAST(P,BHSSED) ;EP
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 NEW BHSY,% S %=P_"^LAST EXAM BREAST",E=$$START1^APCLDF(%,"BHSY(")
 I '$D(BHSY) Q "No    <never recorded>"
 I $P(BHSY(1),U)'<BHSSED S BHSX="Yes   "_$$FMTE^XLFDT($P(BHSY(1),U)) Q BHSX
 Q "No    "_$$FMTE^XLFDT($P(BHSY(1),U))
MAMMOG(P) ;EP
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 NEW LMAM,T S LMAM=""
 I $G(^AUTTSITE(1,0)),$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10)="353101" S LMAM=$$MAMMOG1(P)
 NEW BHSY,%,X,Y,V,G K BHSY
 S (X,Y,V)=0 F  S X=$O(^AUPNVRAD("AC",P,X)) Q:X'=+X  D
 .S V=$P(^AUPNVRAD(X,0),U,3),V=$P($P($G(^AUPNVSIT(V,0)),U),".")
 .S Y=$P(^AUPNVRAD(X,0),U),Y=$P($G(^RAMIS(71,Y,0)),U,9)
 .I Y=76092,V>LMAM S LMAM=V Q
 .I Y=76090,V>LMAM S LMAM=V Q
 .I Y=76091,V>LMAM S LMAM=V Q
 .I Y=77055,V>LMAM S LMAM=V Q
 .I Y=77056,V>LMAM S LMAM=V Q
 .I Y=77057,V>LMAM S LMAM=V Q
 .I Y=77058,V>LMAM S LMAM=V Q
 .I Y=77059,V>LMAM S LMAM=V Q
 .I Y="G0202",V>LMAM S LMAM=V Q
 .I Y="G0204",V>LMAM S LMAM=V Q
 .I Y="G0206",V>LMAM S LMAM=V Q
 K BHSY S %=P_"^LAST DX V76.11",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LMAM>$P(BHSY(1),U)
 .S LMAM=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST DX V76.12",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LMAM>$P(BHSY(1),U)
 .S LMAM=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 87.37",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LMAM>$P(BHSY(1),U)
 .S LMAM=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 87.36",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)) D
 .Q:LMAM>$P(BHSY(1),U)
 .S LMAM=$P(BHSY(1),U)
 S T=$O(^ATXAX("B","BGP CPT MAMMOGRAM",0))
 S X=$$CPT^APCHSMU2(P,$P(^DPT(P,0),U,3),DT,T,3)
 I X D
 .Q:LMAM>X
 .S LMAM=X
 ;if wh v3.0 get date for last mammogram
 I $$VERSION^XPDUTL("BW")>2 F X="MAMMOGRAM SCREENING","MAMMOGRAM DX UNILATERAL","MAMMOGRAM DX BILATERAL","MAMMOGRAM, UNSPECIFIED" D
 .S T=$O(^BWVPDT("B",X,0))
 .S V=$$WHAPI^BWVPAT1(P,T)
 .I $P(V,U)=0 S $P(V,U)=""
 .Q:LMAM>$P(V,U)
 .S LMAM=$P(V,U)
 ;now check wh package directly
 F X="MAMMOGRAM SCREENING","MAMMOGRAM DX UNILAT","MAMMOGRAM DX BILAT" D
 .S T=$O(^BWPN("B",X,0))
 .I T D
 ..S (G,V)=0 F  S V=$O(^BWPCD("C",P,V)) Q:V=""!(G)  D
 ...Q:'$D(^BWPCD(V,0))
 ...I $P(^BWPCD(V,0),U,4)'=T Q
 ...S D=$P(^BWPCD(V,0),U,12)
 ...Q:LMAM>D
 ...S LMAM=D
 .Q
 S G=""
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",76090,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",76091,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",76092,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77055,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77056,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77057,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77058,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",770591,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D","G0202",APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D","G0204",APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D","G0206",APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q $G(LMAM)_"^"_G
 Q $G(LMAM)
 ;
MAMMOG1(P) ;for radiology 4.5+ or until qman can handle taxonomies for radiology procedures
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 ;
 ;IHS/ANMC/LJF 8/26/99 new code to look for all mammograms no matter
 ;    how they are spelled in file 71 - for Rad version 4.5+
 NEW BHSMAM,CODE,COUNT,IEN,X
 S CODE=$O(^DIC(40.7,"C",72,0)) I 'CODE Q "No    <never recorded>"
 S IEN=0 F  S IEN=$O(^RAMIS(71,IEN)) Q:'IEN  D
 . Q:$G(^RAMIS(71,IEN,"I"))  ;inactive
 . Q:'$D(^RAMIS(71,IEN,"STOP","B",CODE))  ;no mamm stop code
 . S COUNT=$G(COUNT)+1,BHSMAM(COUNT)=$P(^RAMIS(71,IEN,0),U)
 ;
 ; -- use data fetcher to find mammogram dates
 NEW BHSY,BHSSAV,BHSX,BHSNAM
 S (BHSSAV,BHSX)=0 F  S BHSX=$O(BHSMAM(BHSX)) Q:'BHSX  D
 . S %=P_"^LAST RAD "_BHSMAM(BHSX),E=$$START1^APCLDF(%,"BHSY(")
 . ; save latest date and procedure name
 . I $G(BHSY(1)),$P(BHSY(1),U)>BHSSAV S BHSSAV=$P(BHSY(1),U),BHSNAM=BHSMAM(BHSX)
 ;
 ; -- return results
 I BHSSAV'=0 Q BHSSAV
 ;IHS/ANMC/LJF 8/26/99 end of new code
 ;
 Q ""
 ;
HYSTER(P,EDATE) ;EP
 ;code set versioning
 I '$G(P) Q ""
 N C,F,G,S,T
 N BHSVDT
 ;S F=0,S="" F  S F=$O(^AUPNVPRC("AC",P,F)) Q:F'=+F!(S)  S C=$P(^ICD0(+^AUPNVPRC(F,0),0),U) D
 S F=0,S="" F  S F=$O(^AUPNVPRC("AC",P,F)) Q:F'=+F!(S)  S BHSVDT=$P(+^AUPNVSIT($P(^AUPNVPRC(F,0),U,3),0),"."),C=$P($$ICDOP^ICDCODE(+^AUPNVPRC(F,0),BHSVDT),U,2) D
 .;cmi/anch/maw 8/27/2007 end of mods
 .S G=0 S:(C=68.4)!(C=68.5)!(C=68.6)!(C=68.7)!(C=68.9) G=C
 .Q:G=0
 .S D=$P(^AUPNVPRC(F,0),U,6) I D="" S D=$P($P(^AUPNVSIT($P(^AUPNVPRC(F,0),U,3),0),U),".")
 .;I D>EDATE Q
 .S S=1
 I S]"" Q "Pt had Hysterectomy on "_$$FMTE^XLFDT(D,2)_" procedure: "_G
 S T="HYSTERECTOMY",T=$O(^BWPN("B",T,0))
 I T D  I X]"" Q "Hysterectomy documented in Women's Health: "_$$FMTE^XLFDT(X,2)
 .S X=$$WH^BHSMU2(P,$$DOB^AUPNPAT(P),EDATE,T,3)
 S T=$O(^ATXAX("B","BGP HYSTERECTOMY CPTS",0))
 I T D  I X]"" Q "Pt had Hysterectomy on "_$$FMTE^XLFDT($P(X,U),2)_" CPT: "_$P(X,U,2)
 .S X=$$CPT^BHSMU2(P,$P(^DPT(P,0),U,3),EDATE,T,5)
 Q ""
