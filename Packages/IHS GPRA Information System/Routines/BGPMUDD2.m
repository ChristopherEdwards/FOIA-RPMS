BGPMUDD2 ; IHS/MSC/SAT - Delimited MU measure NQF0081 ;27-Apr-2011 13:15;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output for Heart Failure 0081 (BGPMUD03)
HF ;EP
 D P1B
 K ^TMP("BGPMU0081")
 Q
P1B ;Write individual measure
 N BGPPTYPE,X,Y,Z,DEN,NUM,PC,STRING1,STRING2,PRD,PRN,PRD1,PRN1
 S BGPPTYPE="D"
 S STRING1=$$081^BGPMUDP2("C")
 S STRING2=$$081^BGPMUDP2("P")
 S STRING3=$$081^BGPMUDP2("B")
 D SUM081
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YR"_U_"%"_U_"CHG FROM BASE %"
 D S^BGPMUDEL(X,1,1)
 S X="Pts 18+ w/heart failure"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1)_U_U
 D S^BGPMUDEL(X,1,1)
 S X="and LVEF < 40%"
 D S^BGPMUDEL(X,1,1)
 S X="# Excluded (Exc)"_U_$P(STRING1,U,4)_U_U_$P(STRING2,U,4)_U_U_U_$P(STRING3,U,4)
 D S^BGPMUDEL(X,1,1)
 S X="Pts 18+ w/heart failure"_U_($P(STRING1,U,1)-$P(STRING1,U,4))_U_U_($P(STRING2,U,1)-$P(STRING2,U,4))_U_U_U_($P(STRING3,U,1)-$P(STRING3,U,4))
 D S^BGPMUDEL(X,1,1)
 S X="and LVEF < 40% less Exc"
 D S^BGPMUDEL(X,1,1)
 S X="# w/ACE inhibitor or ARB"_U_$P(STRING1,U,2)_U_$P(STRING1,U,5)_U_$P(STRING2,U,2)_U_$P(STRING2,U,5)_U_$FN(PRD2,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,5)_U_$FN(PRD3,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o ACE inhibitor or ARB"_U_$P(STRING1,U,3)_U_$P(STRING1,U,6)_U_$P(STRING2,U,3)_U_$P(STRING2,U,6)_U_$FN(PRD4,",+",1)_U_$P(STRING3,U,3)_U_$P(STRING3,U,6)_U_$FN(PRD5,",+",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D TC
 Q
TC ;Do the Details
 N PT,NODE,NAME,BP
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 18+ with at least 1 inpatient discharge encounter OR at least" D S^BGPMUDEL(X,2,1)
 S X="2 outpatient OR at least 2 nursing facility encounters with the EP during the" D S^BGPMUDEL(X,1,1)
 S X="reporting period AND a diagnosis of heart failure during or before any of these" D S^BGPMUDEL(X,1,1)
 S X="encounters AND a Left Ventricular Ejection Fraction (LVEF) < 40% before any of" D S^BGPMUDEL(X,1,1)
 S X="these encounters during the reporting period AND who were prescribed ACE" D S^BGPMUDEL(X,1,1)
 S X="inhibitors or ARB medications during the reporting period, if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed by patients who do meet the numerator criteria (M:).  Excluded patients are listed last." D S^BGPMUDEL(X,2,1)
 S X="The following are the abbreviations used in the denominator and numerator columns:" D S^BGPMUDEL(X,2,1)
 S X="HF=Heart Failure diagnosis" D S^BGPMUDEL(X,1,1)
 S X="LVEF= Left Ventricular Ejection Fraction (LVEF) < 40%" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="MED=ACE Inhibitor or ARB Medication" D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&($D(^TMP("BGPMU0081",$J,"PAT","C","NOT"))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0081"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D081(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0081",$J,"PAT","C","NUM"))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0081"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D081(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0081",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0081"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC081(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
D081(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_NUM
 D S^BGPMUDEL(X,1,1)
 Q
DEXC081(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_"Excluded"
 D S^BGPMUDEL(X,1,1)
 Q
 ;
SUM081 ;Populate "BGPMU SUMMARY" for Measure 0081
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J
 S J=$J
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",J,BGPIC)
 S ^TMP("BGPMU SUMMARY",J,BGPIC)="0081"_U_"5"
 ;Setup summary page/iCare ^TMP global
 S CDEN1CT=+$G(^TMP("BGPMU0081",J,"C","DEN"))                 ;current
 S CNUM1CT=+$G(^TMP("BGPMU0081",J,"C","NUM"))
 S CEXC1CT=+$G(^TMP("BGPMU0081",J,"C","EXC"))
 S CMP=$S((CDEN1CT-CEXC1CT)>0:$$ROUND^BGPMUA01(CNUM1CT/(CDEN1CT-CEXC1CT),3)*100,1:0)
 S PDEN1CT=+$G(^TMP("BGPMU0081",J,"P","DEN"))                 ;previous
 S PNUM1CT=+$G(^TMP("BGPMU0081",J,"P","NUM"))
 S PEXC1CT=+$G(^TMP("BGPMU0081",J,"P","EXC"))
 S PMP=$S((PDEN1CT-PEXC1CT)>0:$$ROUND^BGPMUA01(PNUM1CT/(PDEN1CT-PEXC1CT),3)*100,1:0)
 S BDEN1CT=+$G(^TMP("BGPMU0081",J,"B","DEN"))                 ;baseline
 S BNUM1CT=+$G(^TMP("BGPMU0081",J,"B","NUM"))
 S BEXC1CT=+$G(^TMP("BGPMU0081",J,"B","EXC"))
 S BMP=$S((BDEN1CT-BEXC1CT)>0:$$ROUND^BGPMUA01(BNUM1CT/(BDEN1CT-BEXC1CT),3)*100,1:0)
 S BGPDNCNT=BGPDNCNT+1
 S BGPSSTR="MU.EP.0081."_1_U_"# w/ACE inhibitor or ARB"_U_CEXC1CT_U_CDEN1CT_U_CNUM1CT_U_CMP_U_U_U_U
 ; 11 12 13 14
 S BGPSSTR=BGPSSTR_U_""_U_PDEN1CT_U_PNUM1CT_U_PMP
 ; 15 16 17 18
 S BGPSSTR=BGPSSTR_U_""_U_BDEN1CT_U_BNUM1CT_U_BMP
 S ^TMP("BGPMU SUMMARY",J,BGPIC,BGPDNCNT)=BGPSSTR
 Q
 ;
XML0081 ;XML output for Measure 0081
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count
 N STRING
 S STRING=$$081^BGPMUDP2("C")
 S BGPXML(1)="NQF_0081"_U_U_+$P(STRING,U,1)_U_+$P(STRING,U,2)_U_$P(STRING,U,4)
 K ^TMP("BGPMU0081",$J)
 Q
 ;
 ;*****************
 ;
 ;Delimited output for Prenatal HIV Screening 0012 (BGPMUD04)
DENTRY ;EP
 D P12B
 K ^TMP("BGPMU0012")
 Q
P12B ;Write individual measure
 N BGPPTYPE,X,Y,Z,DEN,NUM,PC,STRING1,STRING2,PRD,PRN,PRD1,PRN1
 S BGPPTYPE="D"
 S STRING1=$$012^BGPMUDP2("C")
 S STRING2=$$012^BGPMUDP2("P")
 S STRING3=$$012^BGPMUDP2("B")
 D SUM012
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YR"_U_"%"_U_"CHG FROM BASE %"
 D S^BGPMUDEL(X,1,1)
 S X="Pts w/live birth and prenatal encounter"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1)_U_U
 D S^BGPMUDEL(X,1,1)
 S X="# Excluded (Exc)"_U_$P(STRING1,U,4)_U_U_$P(STRING2,U,4)_U_U_U_$P(STRING3,U,4)
 D S^BGPMUDEL(X,1,1)
 S X="Pts w/live birth and prenatal encounter Less Exc"_U_($P(STRING1,U,1)-$P(STRING1,U,4))_U_U_($P(STRING2,U,1)-$P(STRING2,U,4))_U_U_U_($P(STRING3,U,1)-$P(STRING3,U,4))
 D S^BGPMUDEL(X,1,1)
 S X="# w/HIV screening"_U_$P(STRING1,U,2)_U_$P(STRING1,U,5)_U_$P(STRING2,U,2)_U_$P(STRING2,U,5)_U_$FN(PRD2,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,5)_U_$FN(PRD3,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o HIV screening"_U_$P(STRING1,U,3)_U_$P(STRING1,U,6)_U_$P(STRING2,U,3)_U_$P(STRING2,U,6)_U_$FN(PRD4,",+",1)_U_$P(STRING3,U,3)_U_$P(STRING3,U,6)_U_$FN(PRD5,",+",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D TC12
 Q
TC12 ;Do the Details
 N PT,NODE,NAME,BP
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients, regardless of age, who gave birth during the reporting period who were" D S^BGPMUDEL(X,1,1)
 S X="screened for HIV infection during the first or second prenatal encounter, if any" D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed by patients who do meet the numerator criteria (M:).  Excluded patients are listed last." D S^BGPMUDEL(X,2,1)
 S X="The following are the abbreviations used in the denominator column:" D S^BGPMUDEL(X,2,1)
 S X="DEL=Live birth delivery" D S^BGPMUDEL(X,1,1)
 S X="EN=Prenatal Encounter" D S^BGPMUDEL(X,1,1)
 S X="HIV=HIV Screening" D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&($D(^TMP("BGPMU0012",$J,"PAT","C","NOT"))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0012"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D012(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0012",$J,"PAT","C","NUM"))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0012"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D012(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0012",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0012"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D012(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
D012(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_NUM
 D S^BGPMUDEL(X,1,1)
 Q
 ;
SUM012 ;Populate "BGPMU SUMMARY" for Prenatal HIV Screening Measure 0012
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J
 S J=$J
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",J,BGPIC)
 S ^TMP("BGPMU SUMMARY",J,BGPIC)="0012"_U_""
 ;Setup summary page/iCare ^TMP global
 S CDEN1CT=+$G(^TMP("BGPMU0012",J,"C","DEN"))                 ;current
 S CNUM1CT=+$G(^TMP("BGPMU0012",J,"C","NUM"))
 S CEXC1CT=+$G(^TMP("BGPMU0012",J,"C","EXC"))
 S CMP=$S((CDEN1CT-CEXC1CT)>0:$$ROUND^BGPMUA01(CNUM1CT/(CDEN1CT-CEXC1CT),3)*100,1:0)
 S PDEN1CT=+$G(^TMP("BGPMU0012",J,"P","DEN"))                 ;previous
 S PNUM1CT=+$G(^TMP("BGPMU0012",J,"P","NUM"))
 S PEXC1CT=+$G(^TMP("BGPMU0012",J,"P","EXC"))
 S PMP=$S((PDEN1CT-PEXC1CT)>0:$$ROUND^BGPMUA01(PNUM1CT/(PDEN1CT-PEXC1CT),3)*100,1:0)
 S BDEN1CT=+$G(^TMP("BGPMU0012",J,"B","DEN"))                 ;baseline
 S BNUM1CT=+$G(^TMP("BGPMU0012",J,"B","NUM"))
 S BEXC1CT=+$G(^TMP("BGPMU0012",J,"B","EXC"))
 S BMP=$S((BDEN1CT-BEXC1CT)>0:$$ROUND^BGPMUA01(BNUM1CT/(BDEN1CT-BEXC1CT),3)*100,1:0)
 S BGPDNCNT=BGPDNCNT+1
 S BGPSSTR="MU.EP.0012.1"_U_"# w/HIV screening"_U_CEXC1CT_U_CDEN1CT_U_CNUM1CT_U_CMP_U_U_U_U
 ; 11 12 13 14
 S BGPSSTR=BGPSSTR_U_PEXC1CT_U_PDEN1CT_U_PNUM1CT_U_PMP
 ; 15 16 17 18
 S BGPSSTR=BGPSSTR_U_BEXC1CT_U_BDEN1CT_U_BNUM1CT_U_BMP
 S ^TMP("BGPMU SUMMARY",J,BGPIC,BGPDNCNT)=BGPSSTR
 Q
 ;
XML0012 ;XML output for Prenatal HIV Screening Measure 0012
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count
 N STRING
 S STRING=$$012^BGPMUDP2("C")
 S BGPXML(1)="NQF_0012"_U_U_+$P(STRING,U,1)_U_+$P(STRING,U,2)_U_$P(STRING,U,4)
 K ^TMP("BGPMU0012",$J)
 Q
