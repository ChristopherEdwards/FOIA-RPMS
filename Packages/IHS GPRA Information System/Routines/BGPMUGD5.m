BGPMUGD5 ; IHS/MSC/MMT - MU EP measures NQF0036 ;20-Aug-2011 11:26;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output reports for this measure
ASTPHARM ;EP
 D P1
 K ^TMP("BGPMU0036")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,EXC1,EXC2,STRING1,STRING2,STRING3
 N PRD1,PRD4,PRN1,PRN4
 D NUM36^BGPMUGP5("C",.STRING1)
 D NUM36^BGPMUGP5("P",.STRING2)
 D NUM36^BGPMUGP5("B",.STRING3)
 D SUMMARY1^BGPMUGP5(.STRING1,.STRING2,.STRING3)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 D P1SUB(1)
 D P1SUB(2)
 D P1SUB(3)
 I $D(BGPLIST(BGPIC)) D P2
 Q
P1SUB(POP) ;Population tabular output
 S PRD1=$P(STRING1(POP),U,5)-$P(STRING2(POP),U,5)
 S PRD4=$P(STRING1(POP),U,7)-$P(STRING2(POP),U,7)
 S PRN1=$P(STRING1(POP),U,5)-$P(STRING3(POP),U,5)
 S PRN4=$P(STRING1(POP),U,7)-$P(STRING3(POP),U,7)
 S X="Denominator "_POP
 D S^BGPMUDEL(X,2,1)
 S X=$P($T(P1TEXT+POP),";;",2)_U_$P(STRING1(POP),U,1)_U_U_$P(STRING2(POP),U,1)_U_U_U_$P(STRING3(POP),U,1)
 D S^BGPMUDEL(X,2,1)
 S X="# Excluded (Exc)"_U_$P(STRING1(POP),U,4)_U_U_$P(STRING2(POP),U,4)_U_U_U_$P(STRING3(POP),U,4)
 D S^BGPMUDEL(X,1,1)
 S X=$P($T(P1TEXTE+POP),";;",2)_U_$P(STRING1(POP),U,3)_U_U_$P(STRING2(POP),U,3)_U_U_U_$P(STRING3(POP),U,3)
 D S^BGPMUDEL(X,1,1)
 S X="# w/asthma medications"_U_$P(STRING1(POP),U,2)_U_$J($P(STRING1(POP),U,5),5,1)_U_$P(STRING2(POP),U,2)_U_$J($P(STRING2(POP),U,5),5,1)_U_$J($FN(PRD1,",+",1),6)_U_$P(STRING3(POP),U,2)_U_$J($P(STRING3(POP),U,5),5,1)_U_$J($FN(PRN1,",+",1),6)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o asthma medications"_U_$P(STRING1(POP),U,6)_U_$J($P(STRING1(POP),U,7),5,1)_U_$P(STRING2(POP),U,6)_U_$J($P(STRING2(POP),U,7),5,1)_U_$J($FN(PRD4,",+",1),6)_U_$P(STRING3(POP),U,6)_U_$J($P(STRING3(POP),U,7),5,1)_U_$J($FN(PRN4,",+",1),6)
 D S^BGPMUDEL(X,1,1)
 Q
P1TEXT ;Text lines for output
 ;;Pts 5-11 w/asthma or meds indicative of asthma
 ;;Pts 12-50 w/asthma or meds indicative of asthma
 ;;Pts 5-50 w/asthma or meds indicative of asthma
P1TEXTE ;Text lines for output LESS exclusions
 ;;Pts 5-11 w/asthma or meds indicative of asthma less Exc
 ;;Pts 12-50 w/asthma or meds indicative of asthma less Exc
 ;;Pts 5-50 w/asthma or meds indicative of asthma less Exc
 ;population
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT,BGPARR,LINE
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 5-50 years of age with one of the following during the reporting" D S^BGPMUDEL(X,1,1)
 S X="period or within 1 year before the beginning of the reporting period: (a) at" D S^BGPMUDEL(X,1,1)
 S X="least 1 ED or acute inpatient encounter with the EP and a diagnosis of asthma," D S^BGPMUDEL(X,1,1)
 S X="(b) at least 4 outpatient encounters with the EP AND a diagnosis of asthma AND"  D S^BGPMUDEL(X,1,1)
 S X="at least 2 counts asthma medication prescribed by the EP, (c) at least 4 counts"  D S^BGPMUDEL(X,1,1)
 S X="of asthma medication prescribed by the EP, or (d) at least 4 counts of "  D S^BGPMUDEL(X,1,1)
 S X="leukotriebe inhibitors prescribed by the EP and a diagnosis of asthma, if any."  D S^BGPMUDEL(X,1,1)
 S X="Patients who did not meet the numerator criteria are listed first (NM:)" D S^BGPMUDEL(X,2,1)
 S X="followed by patients who do meet the numerator criteria (M:).  Excluded patients" D S^BGPMUDEL(X,1,1)
 S X="are listed last."  D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,2,1)
 S X="columns:" D S^BGPMUDEL(X,1,1)
 S X="AST=Asthma Diagnosis" D S^BGPMUDEL(X,1,1)
 S X="MED=Asthma Medication" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="Patients 5-11"
 D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 D LISTSUB(1)
 S X="Patients 12-50"
 D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 D LISTSUB(2)
 Q
LISTSUB(POP) ;write out patient list for given population
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0036"","_$J_",""PAT"",""C"","_POP_",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0036"","_$J_",""PAT"",""C"","_POP_",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="A" D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0036"","_$J_",""PAT"",""C"","_POP_",""EXC"")")
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
