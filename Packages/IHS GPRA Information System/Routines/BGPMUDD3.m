BGPMUDD3 ; IHS/MSC/SAT - Delimited MU measure NQF0081 ;27-Apr-2011 13:15;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output for Prenatal HIV Screening 0014 (BGPMUD05)
D14ENT ;EP
 D P14B
 K ^TMP("BGPMU0014")
 Q
P14B ;Write individual measure
 N BGPPTYPE,X,Y,Z,DEN,NUM,PC,STRING1,STRING2,PRD,PRN,PRD1,PRN1
 S BGPPTYPE="D"
 S STRING1=$$014^BGPMUDP3("C")
 S STRING2=$$014^BGPMUDP3("P")
 S STRING3=$$014^BGPMUDP3("B")
 D SUM014
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YR"_U_"%"_U_"CHG FROM BASE %"
 D S^BGPMUDEL(X,1,1)
 S X="Pts D (Rh) neg, unsensitized w/live birth and prenatal encounter"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1)_U_U
 D S^BGPMUDEL(X,1,1)
 S X="# Excluded (Exc)"_U_$P(STRING1,U,4)_U_U_$P(STRING2,U,4)_U_U_U_$P(STRING3,U,4)
 D S^BGPMUDEL(X,1,1)
 S X="Pts D (Rh) neg, unsensitized w/live birth and prenatal encounter less Exc"_U_($P(STRING1,U,1)-$P(STRING1,U,4))_U_U_($P(STRING2,U,1)-$P(STRING2,U,4))_U_U_U_($P(STRING3,U,1)-$P(STRING3,U,4))
 D S^BGPMUDEL(X,1,1)
 S X="# w/anti-D immune globulin 26-30 weeks gestation"_U_$P(STRING1,U,2)_U_$P(STRING1,U,5)_U_$P(STRING2,U,2)_U_$P(STRING2,U,5)_U_$FN(PRD2,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,5)_U_$FN(PRD3,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o anti-D immune globulin 26-30 weeks gestation"_U_$P(STRING1,U,3)_U_$P(STRING1,U,6)_U_$P(STRING2,U,3)_U_$P(STRING2,U,6)_U_$FN(PRD4,",+",1)_U_$P(STRING3,U,3)_U_$P(STRING3,U,6)_U_$FN(PRD5,",+",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D TC14
 Q
TC14 ;Do the Details
 N PT,NODE,NAME,BP
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="D (Rh) negative, unsensitized patients, regardless of age, who gave birth" D S^BGPMUDEL(X,1,1)
 S X="during the reporting period who received anti-D immune globulin at" D S^BGPMUDEL(X,1,1)
 S X="26-30 weeks gestation." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed by patients who do meet the numerator criteria (M:).  Excluded patients are listed last." D S^BGPMUDEL(X,2,1)
 S X="The following are the abbreviations used in the denominator and numerator columns:" D S^BGPMUDEL(X,2,1)
 S X="DEL=Live birth delivery" D S^BGPMUDEL(X,1,1)
 S X="EN=Prenatal encounter" D S^BGPMUDEL(X,1,1)
 S X="MED=Anti-D immune globulin administered between 26 and 30 weeks gestation" D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&($D(^TMP("BGPMU0014",$J,"PAT","C","NOT"))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0014"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D014(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0014",$J,"PAT","C","NUM"))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0014"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D014(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0014",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0014"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D014(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
D014(NODE) ;GET DATA
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
SUM014 ;Populate "BGPMU SUMMARY" for Measure 0014
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J,N
 S J=$J
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",J,BGPIC)
 S ^TMP("BGPMU SUMMARY",J,BGPIC)="0014"_U_""
 S N=1 ;only 1 numerator
 ;Setup summary page/iCare ^TMP global
 S CDEN1CT=+$G(^TMP("BGPMU0014",J,"C","DEN"))                 ;current
 S CNUM1CT=+$G(^TMP("BGPMU0014",J,"C","NUM"))
 S CEXC1CT=+$G(^TMP("BGPMU0014",J,"C","EXC"))
 S CMP=$S((CDEN1CT-CEXC1CT)>0:$$ROUND^BGPMUA01(CNUM1CT/(CDEN1CT-CEXC1CT),3)*100,1:0)
 S PDEN1CT=+$G(^TMP("BGPMU0014",J,"P","DEN"))                 ;previous
 S PNUM1CT=+$G(^TMP("BGPMU0014",J,"P","NUM"))
 S PEXC1CT=+$G(^TMP("BGPMU0014",J,"P","EXC"))
 S PMP=$S((PDEN1CT-PEXC1CT)>0:$$ROUND^BGPMUA01(PNUM1CT/(PDEN1CT-PEXC1CT),3)*100,1:0)
 S BDEN1CT=+$G(^TMP("BGPMU0014",J,"B","DEN"))                 ;baseline
 S BNUM1CT=+$G(^TMP("BGPMU0014",J,"B","NUM"))
 S BEXC1CT=+$G(^TMP("BGPMU0014",J,"B","EXC"))
 S BMP=$S((BDEN1CT-BEXC1CT)>0:$$ROUND^BGPMUA01(BNUM1CT/(BDEN1CT-BEXC1CT),3)*100,1:0)
 S BGPDNCNT=BGPDNCNT+1
 S BGPSSTR="MU.EP.0014."_N_U_"# w/anti-D immune globulin"_U_CEXC1CT_U_CDEN1CT_U_CNUM1CT_U_CMP_U_U_U_U
 ; 11 12 13 14
 S BGPSSTR=BGPSSTR_U_PEXC1CT_U_PDEN1CT_U_PNUM1CT_U_PMP
 ; 15 16 17 18
 S BGPSSTR=BGPSSTR_U_BEXC1CT_U_BDEN1CT_U_BNUM1CT_U_BMP
 S ^TMP("BGPMU SUMMARY",J,BGPIC,BGPDNCNT)=BGPSSTR
 Q
 ;
 ;****************************
 ;
 ;Delimited output for Prenatal HIV Screening 0018 (BGPMUD06)
D18ENT ;EP
 D P18B
 K ^TMP("BGPMU0018")
 Q
P18B ;Write individual measure
 N BGPPTYPE,X,Y,Z,DEN,NUM,PC,STRING1,STRING2,PRD,PRN,PRD1,PRN1
 S BGPPTYPE="D"
 S STRING1=$$018^BGPMUDP3("C")
 S STRING2=$$018^BGPMUDP3("P")
 S STRING3=$$018^BGPMUDP3("B")
 D SUM018
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YR"_U_"%"_U_"CHG FROM BASE %"
 D S^BGPMUDEL(X,1,1)
 S X="Pts 18-85 w/HTN"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1)_U_U
 D S^BGPMUDEL(X,1,1)
 ;S X="# Excluded (Exc)"_U_$P(STRING1,U,4)_U_U_$P(STRING2,U,4)_U_U_U_$P(STRING3,U,4)
 ;D S^BGPMUDEL(X,1,1)
 ;S X="Pts 18-85 w/HTN Less Exc"_U_($P(STRING1,U,1)-$P(STRING1,U,4))_U_U_($P(STRING2,U,1)-$P(STRING2,U,4))_U_U_U_($P(STRING3,U,1)-$P(STRING3,U,4))
 ;D S^BGPMUDEL(X,1,1)
 S X="# w/lowest BP < 140/90"_U_$P(STRING1,U,2)_U_$P(STRING1,U,5)_U_$P(STRING2,U,2)_U_$P(STRING2,U,5)_U_$FN(PRD2,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,5)_U_$FN(PRD3,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o BP or lowest BP"_U_$P(STRING1,U,3)_U_$P(STRING1,U,6)_U_$P(STRING2,U,3)_U_$P(STRING2,U,6)_U_$FN(PRD4,",+",1)_U_$P(STRING3,U,3)_U_$P(STRING3,U,6)_U_$FN(PRD5,",+",1)
 D S^BGPMUDEL(X,1,1)
 S X="=> 140/90"
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D TC18
 Q
TC18 ;Do the Details
 N PT,NODE,NAME,BP
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Hypertensive patients 18-85 years of age with at least 1 encounter with the EP" D S^BGPMUDEL(X,1,1)
 S X="during the reporting period and whose lowest systolic BP reading was < 140 mmHg" D S^BGPMUDEL(X,1,1)
 S X="and lowest diastolic BP reading was < 90 mmHg during the most recent encounter" D S^BGPMUDEL(X,1,1)
 S X="with the EP during the reporting period, if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,2,1)
 S X="The following are the abbreviations used in the denominator and numerator columns:" D S^BGPMUDEL(X,2,1)
 S X="ICD=Hypertension Diagnosis" D S^BGPMUDEL(X,1,1)
 S X="EN=Prenatal encounter" D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&($D(^TMP("BGPMU0018",$J,"PAT","C","NOT",1))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0018"","_$J_",""PAT"",""C"",""NOT"","_1_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D018(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0018",$J,"PAT","C","NUM",1))) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0018"","_$J_",""PAT"",""C"",""NUM"","_1_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D018(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
D018(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P(NODE,U,2),";",1,2)
 S NUM=$P($P(NODE,U,2),";",3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_$P(DEN,";",1)_U_$P(NUM,"*",1)
 D S^BGPMUDEL(X,1,1)
 S X=U_U_U_U_U_$P(DEN,";",2)_$S($P(NUM,"*",2)'="":U_$P(NUM,"*",2),1:"")
 D S^BGPMUDEL(X,1,1)
 F BGPI=3:1:$L(NUM,"*") S X=U_U_U_U_U_U_$P(NUM,"*",BGPI) D S^BGPMUDEL(X,1,1)
 Q
 ;
SUM018 ;Populate "BGPMU SUMMARY" for Controlling High Blood Pressure Measure 0018
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J,N
 S J=$J
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",J,BGPIC)
 S ^TMP("BGPMU SUMMARY",J,BGPIC)="0018"_U_""
 S N=1 ;only 1 numerator
 ;Setup summary page/iCare ^TMP global
 S CDEN1CT=+$G(^TMP("BGPMU0018",J,"C","DEN",N))                 ;current
 S CNUM1CT=+$G(^TMP("BGPMU0018",J,"C","NUM",N))
 S CMP=$S(CDEN1CT>0:$$ROUND^BGPMUA01(CNUM1CT/CDEN1CT,3)*100,1:0)
 S PDEN1CT=+$G(^TMP("BGPMU0018",J,"P","DEN",N))                 ;previous
 S PNUM1CT=+$G(^TMP("BGPMU0018",J,"P","NUM",N))
 S PMP=$S(PDEN1CT>0:$$ROUND^BGPMUA01(PNUM1CT/PDEN1CT,3)*100,1:0)
 S BDEN1CT=+$G(^TMP("BGPMU0018",J,"B","DEN",N))                 ;baseline
 S BNUM1CT=+$G(^TMP("BGPMU0018",J,"B","NUM",N))
 S BMP=$S(BDEN1CT>0:$$ROUND^BGPMUA01(BNUM1CT/BDEN1CT,3)*100,1:0)
 S BGPDNCNT=BGPDNCNT+1
 S BGPSSTR="MU.EP.0018."_N_U_"18-85 # w/lowest BP < 140/90"_U_0_U_CDEN1CT_U_CNUM1CT_U_CMP_U_U_U_U
 ; 11 12 13 14
 S BGPSSTR=BGPSSTR_U_""_U_PDEN1CT_U_PNUM1CT_U_PMP
 ; 15 16 17 18
 S BGPSSTR=BGPSSTR_U_""_U_BDEN1CT_U_BNUM1CT_U_BMP
 S ^TMP("BGPMU SUMMARY",J,BGPIC,BGPDNCNT)=BGPSSTR
 Q
