BGPMUGD6 ; IHS/MSC/MMT - MU EP measures NQF0004 ;20-Aug-2011 11:26;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output reports for this measure
ALCDRUG ;EP
 D P1
 K ^TMP("BGPMU0004")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,STRING1,STRING2,STRING3
 N PRD1,PRD4,PRN1,PRN4,POP
 D NUM04^BGPMUGP6("C",.STRING1)
 D NUM04^BGPMUGP6("P",.STRING2)
 D NUM04^BGPMUGP6("B",.STRING3)
 D SUMMARY1^BGPMUGP6(.STRING1,.STRING2,.STRING3)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 F POP=1:1:3 D
 .D P1SUBDEN(POP)
 .D P1SUBN1(POP)
 .D P1SUBN2(POP)
 I $D(BGPLIST(BGPIC)) D P2
 Q
P1SUBDEN(POP) ;display lines for denominator
 S X="Denominator "_POP_":"
 D S^BGPMUDEL(X,2,1)
 S X=$P($T(P1TEXT+POP),";;",2)_U_$P(STRING1(POP),U,1)_U_U_$P(STRING2(POP),U,1)_U_U_U_$P(STRING3(POP),U,1)
 D S^BGPMUDEL(X,2,1)
 Q
P1SUBN1(POP) ;display numbers for NUM 1
 S PRD1=$P(STRING1(POP),U,5)-$P(STRING2(POP),U,5)
 S PRD4=$P(STRING1(POP),U,7)-$P(STRING2(POP),U,7)
 S PRN1=$P(STRING1(POP),U,5)-$P(STRING3(POP),U,5)
 S PRN4=$P(STRING1(POP),U,7)-$P(STRING3(POP),U,7)
 S X="Numerator 1"
 D S^BGPMUDEL(X,2,1)
 S X="# w/first treatment"_U_$P(STRING1(POP),U,2)_U_$J($P(STRING1(POP),U,5),5,1)_U_$P(STRING2(POP),U,2)_U_$J($P(STRING2(POP),U,5),5,1)_U_$J($FN(PRD1,",+",1),6)_U_$P(STRING3(POP),U,2)_U_$J($P(STRING3(POP),U,5),5,1)_U_$J($FN(PRN1,",+",1),6)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o first treatment"_U_$P(STRING1(POP),U,6)_U_$J($P(STRING1(POP),U,7),5,1)_U_$P(STRING2(POP),U,6)_U_$J($P(STRING2(POP),U,7),5,1)_U_$J($FN(PRD4,",+",1),6)_U_$P(STRING3(POP),U,6)_U_$J($P(STRING3(POP),U,7),5,1)_U_$J($FN(PRN4,",+",1),6)
 D S^BGPMUDEL(X,1,1)
 Q
P1SUBN2(POP) ;display numbers for NUM 2
 S PRD1=$P(STRING1(POP),U,9)-$P(STRING2(POP),U,9)
 S PRD4=$P(STRING1(POP),U,11)-$P(STRING2(POP),U,11)
 S PRN1=$P(STRING1(POP),U,9)-$P(STRING3(POP),U,9)
 S PRN4=$P(STRING1(POP),U,11)-$P(STRING3(POP),U,11)
 S X="Numerator 2"
 D S^BGPMUDEL(X,2,1)
 S X="# w/2 treatments within 30 days"_U_$P(STRING1(POP),U,8)_U_$J($P(STRING1(POP),U,9),5,1)_U_$P(STRING2(POP),U,8)_U_$J($P(STRING2(POP),U,9),5,1)
 S X=X_U_$J($FN(PRD1,",+",1),6)_U_$P(STRING3(POP),U,8)_U_$J($P(STRING3(POP),U,9),5,1)_U_$J($FN(PRN1,",+",1),6)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o 2 treatments within 30 days or no first treatment"_U_$P(STRING1(POP),U,10)_U_$J($P(STRING1(POP),U,11),5,1)_U_$P(STRING2(POP),U,10)
 S X=X_U_$J($P(STRING2(POP),U,11),5,1)_U_$J($FN(PRD4,",+",1),6)_U_$P(STRING3(POP),U,10)_U_$J($P(STRING3(POP),U,11),5,1)_U_$J($FN(PRN4,",+",1),6)
 D S^BGPMUDEL(X,1,1)
 Q
P1TEXT ;Text lines for output
 ;;Pts 13-17 w/alcohol or drug dependence
 ;;Pts 18+ w/alcohol or drug dependence
 ;;Pts 13+ w/alcohol or drug dependence
 ;population
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT,BGPARR,LINE
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 13+ with a new episode of alcohol and other drug (AOD) dependence" D S^BGPMUDEL(X,1,1)
 S X="who initiate treatment through an inpatient AOD admission, outpatient visit," D S^BGPMUDEL(X,1,1)
 S X="intensive outpatient encounter, or partial hospitalization within 14 days of" D S^BGPMUDEL(X,1,1)
 S X="the diagnosis and who initiated treatment and who had two or more additional"  D S^BGPMUDEL(X,1,1)
 S X="services with an AOD diagnosis within 30 days of the initiation visit, if any."  D S^BGPMUDEL(X,1,1)
 S X="Patients who did not meet the numerator criteria are listed first (NM:)" D S^BGPMUDEL(X,2,1)
 S X="followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,2,1)
 S X="columns:" D S^BGPMUDEL(X,1,1)
 S X="ADX=Alcohol or Drug Dependence Diagnosis" D S^BGPMUDEL(X,1,1)
 S X="ADI=Alcohol, Drug Rehab and Detox Intervention" D S^BGPMUDEL(X,1,1)
 S X="DI=Detoxification Intervention" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="FT=First Treatment" D S^BGPMUDEL(X,1,1)
 S X="ST=Subsequent Treatment" D S^BGPMUDEL(X,1,1)
 F I=1,2 D
 .S X=$P($T(LISTNUM+I^BGPMUGP6),";;",2)
 .D S^BGPMUDEL(X,2,1)
 .F J=1,2 D
 ..S X=$P($T(LISTDEN+J^BGPMUGP6),";;",2)
 ..D S^BGPMUDEL(X,2,1)
 ..S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 ..D S^BGPMUDEL(X,2,1)
 ..D LISTSUB(J,I)
 Q
LISTSUB(POP,NUM) ;write out patient list for given population
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0004"","_$J_",""PAT"",""C"","_POP_",""NOT"","_NUM_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0004"","_$J_",""PAT"",""C"","_POP_",""NUM"","_NUM_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,NUM1,NUM2
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,30)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S COMM=$$GET1^DIQ(9000047,DFN,1118)
 S SEX=$P(^DPT(DFN,0),U,2)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_NUM D S^BGPMUDEL(X,1,1)
 Q
