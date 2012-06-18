BGPMUDD6 ; IHS/MSC/SAT - MU EP measures NQF0105 ;07-SEP-2011 11:26;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output reports for this measure
DAD ;EP
 D P1
 K ^TMP("BGPMU0105")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,PC1,PC2,EXC1,EXC2,STRING1,STRING2,STRING3
 N PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,PRD7,PRD8,PRN1,PRN2,PRN3,PRN4,PRN5,PRN6,PRN7,PRN8
 S STRING1=$$NUM105^BGPMUDP6("C")
 S STRING2=$$NUM105^BGPMUDP6("P")
 S STRING3=$$NUM105^BGPMUDP6("B")
 D SUMMARY1^BGPMUDP6(STRING1,STRING2,STRING3)
 ;population
 S PRD11=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRD14=$P(STRING1,U,9)-$P(STRING2,U,9)
 S PRN11=$P(STRING1,U,5)-$P(STRING3,U,5)
 S PRN14=$P(STRING1,U,9)-$P(STRING3,U,9)
 S PRD21=$P(STRING1,U,14)-$P(STRING2,U,14)
 S PRD24=$P(STRING1,U,18)-$P(STRING2,U,18)
 S PRN21=$P(STRING1,U,14)-$P(STRING3,U,14)
 S PRN24=$P(STRING1,U,18)-$P(STRING3,U,18)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 ;
 S X="Pts 18+ w/major depression"_U_+$P(STRING1,U,1)_U_U_+$P(STRING2,U,1)_U_U_U_+$P(STRING3,U,1)
 D S^BGPMUDEL(X,2,1)
 ;
 S X="Numerator 1:"
 D S^BGPMUDEL(X,2,1)
 S X="# w/antidepressant med"_U_+$P(STRING1,U,2)_U_$J($P(STRING1,U,5),5,1)_U_+$P(STRING2,U,2)_U_$J($P(STRING2,U,5),5,1)_U_$FN(PRD11,",+",1)_U_+$P(STRING3,U,2)_U_$J($P(STRING3,U,5),5,1)_U_$FN(PRN11,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="=> 84 days after diagnosis"
 D S^BGPMUDEL(X,1,1)
 S X="# w/o antidepressant med"_U_+$P(STRING1,U,8)_U_$J($P(STRING1,U,9),5,1)_U_+$P(STRING2,U,8)_U_$J($P(STRING2,U,9),5,1)_U_$FN(PRD14,",+",1)_U_+$P(STRING3,U,8)_U_$J($P(STRING3,U,9),5,1)_U_$FN(PRN14,",+",1)
 D S^BGPMUDEL(X,1,1)
 S X="=> 84 days after diagnosis"
 D S^BGPMUDEL(X,1,1)
 ;
 S X="Numerator 2:"
 D S^BGPMUDEL(X,2,1)
 S X="# w/antidepressant med"_U_+$P(STRING1,U,11)_U_$J($P(STRING1,U,14),5,1)_U_+$P(STRING2,U,11)_U_$J($P(STRING2,U,14),5,1)_U_$FN(PRD21,",+",1)_U_+$P(STRING3,U,11)_U_$J($P(STRING3,U,14),5,1)_U_$FN(PRN21,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="=> 180 days after diagnosis"
 D S^BGPMUDEL(X,1,1)
 S X="# w/o antidepressant med"_U_+$P(STRING1,U,17)_U_$J($P(STRING1,U,18),5,1)_U_+$P(STRING2,U,17)_U_$J($P(STRING2,U,18),5,1)_U_$FN(PRD24,",+",1)_U_+$P(STRING3,U,17)_U_$J($P(STRING3,U,18),5,1)_U_$FN(PRN24,",+",1)
 D S^BGPMUDEL(X,1,1)
 S X="=> 180 days after diagnosis"
 D S^BGPMUDEL(X,1,1)
 ;
 I $D(BGPLIST(BGPIC)) D P2
 Q
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 18+ with a FIRST primary diagnosis of major depression during at least" D S^BGPMUDEL(X,1,1)
 S X="1 ED, outpatient BH or outpatient BH req POS encounter with the EP between <=245" D S^BGPMUDEL(X,1,1)
 S X="days before the reporting period start date and => 245 days before the reporting" D S^BGPMUDEL(X,1,1)
 S X="period end date OR a secondary diagnosis of major depression during at least" D S^BGPMUDEL(X,1,1)
 S X="2 ED, outpatient BH or outpatient BH req POS encounters with the EP during this" D S^BGPMUDEL(X,1,1)
 S X="time period, OR a secondary diagnosis of major depression during an acute or" D S^BGPMUDEL(X,1,1)
 S X="non-acute inpatient encounter with the EP during this time period, AND who were" D S^BGPMUDEL(X,1,1)
 S X="prescribed antidepressant medication and who remained on antidepressant" D S^BGPMUDEL(X,1,1)
 S X="medication, if any." D S^BGPMUDEL(X,1,1)
 ;
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D S^BGPMUDEL(X,2,1)
 S X="by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 ;
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,1,1)
 S X="columns:" D S^BGPMUDEL(X,1,1)
 S X="DEP=Major Depression Diagnosis" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="MED=Antidepressant Medication" D S^BGPMUDEL(X,1,1)
 ;
 S PTCT=0
 S X="Numerator 1: Patients with antidepressant medication => 84 days after diagnosis" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NOT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NUM"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 ;
 S PTCT=0
 S X="Numerator 2: Patients with antidepressant medication => 180 days after diagnosis" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NOT"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NUM"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,LINE
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S SEX=$P(^DPT(DFN,0),U,2)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_$P(DEN,";",1)_U_NUM
 D S^BGPMUDEL(X,1,1)
 F BGPI=2:1:$L(DEN,";") D
 .S X=U_U_U_U_U_$P(DEN,";",BGPI)
 .D S^BGPMUDEL(X,1,1)
 Q
