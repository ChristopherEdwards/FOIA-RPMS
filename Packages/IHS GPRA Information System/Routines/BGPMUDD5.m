BGPMUDD5 ; IHS/MSC/SAT - MU EP measures NQF0033 ;29-AUG-2011 11:26;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output reports for this measure
DCHL ;EP
 D P1
 K ^TMP("BGPMU0033")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,PC1,PC2,EXC1,EXC2,STRING1,STRING2,STRING3
 N PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,PRD7,PRD8,PRN1,PRN2,PRN3,PRN4,PRN5,PRN6,PRN7,PRN8
 S STRING1=$$NUM33^BGPMUDP5("C")
 S STRING2=$$NUM33^BGPMUDP5("P")
 S STRING3=$$NUM33^BGPMUDP5("B")
 D SUMMARY1^BGPMUDP5(STRING1,STRING2,STRING3)
 ;population
 S PRD11=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRD14=$P(STRING1,U,9)-$P(STRING2,U,9)
 S PRN11=$P(STRING1,U,5)-$P(STRING3,U,5)
 S PRN14=$P(STRING1,U,9)-$P(STRING3,U,9)
 S PRD21=$P(STRING1,U,14)-$P(STRING2,U,14)
 S PRD24=$P(STRING1,U,18)-$P(STRING2,U,18)
 S PRN21=$P(STRING1,U,14)-$P(STRING3,U,14)
 S PRN24=$P(STRING1,U,18)-$P(STRING3,U,18)
 S PRD31=$P(STRING1,U,23)-$P(STRING2,U,23)
 S PRD34=$P(STRING1,U,27)-$P(STRING2,U,27)
 S PRN31=$P(STRING1,U,23)-$P(STRING3,U,23)
 S PRN34=$P(STRING1,U,27)-$P(STRING3,U,27)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 ;
 S X="Denominator 1:"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 15-24 sexually active"_U_+$P(STRING1,U,1)_U_U_+$P(STRING2,U,1)_U_U_U_+$P(STRING3,U,1) D S^BGPMUDEL(X,2,1)
 S X="females" D S^BGPMUDEL(X,1,1)
 S X="# Excluded (Exc)"_U_+$P(STRING1,U,4)_U_U_+$P(STRING2,U,4)_U_U_U_+$P(STRING3,U,4)
 D S^BGPMUDEL(X,1,1)
 S X="Pts 15-24 sexually active"_U_+$P(STRING1,U,3)_U_U_+$P(STRING2,U,3)_U_U_U_+$P(STRING3,U,3)
 D S^BGPMUDEL(X,1,1)
 S X="females less Exc"
 D S^BGPMUDEL(X,1,1)
 S X="# w/chlamydia screening"_U_+$P(STRING1,U,2)_U_$J($P(STRING1,U,5),5,1)_U_+$P(STRING2,U,2)_U_$J($P(STRING2,U,5),5,1)_U_$FN(PRD11,",+",1)_U_+$P(STRING3,U,2)_U_$J($P(STRING3,U,5),5,1)_U_$FN(PRN11,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o chlamydia screening"_U_+$P(STRING1,U,8)_U_$J($P(STRING1,U,9),5,1)_U_+$P(STRING2,U,8)_U_$J($P(STRING2,U,9),5,1)_U_$FN(PRD14,",+",1)_U_+$P(STRING3,U,8)_U_$J($P(STRING3,U,9),5,1)_U_$FN(PRN14,",+",1)
 D S^BGPMUDEL(X,1,1)
 ;
 S X="Denominator 2:"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 15-19 sexually active"_U_+$P(STRING1,U,10)_U_U_+$P(STRING2,U,10)_U_U_U_+$P(STRING3,U,10) D S^BGPMUDEL(X,2,1)
 S X="females" D S^BGPMUDEL(X,1,1)
 S X="# Excluded (Exc)"_U_+$P(STRING1,U,13)_U_U_+$P(STRING2,U,13)_U_U_U_+$P(STRING3,U,13)
 D S^BGPMUDEL(X,1,1)
 S X="Pts 15-19 sexually active"_U_+$P(STRING1,U,12)_U_U_+$P(STRING2,U,12)_U_U_U_+$P(STRING3,U,12)
 D S^BGPMUDEL(X,1,1)
 S X="females less Exc"
 D S^BGPMUDEL(X,1,1)
 S X="# w/chlamydia screening"_U_+$P(STRING1,U,11)_U_$J($P(STRING1,U,14),5,1)_U_+$P(STRING2,U,11)_U_$J($P(STRING2,U,14),5,1)_U_$FN(PRD21,",+",1)_U_+$P(STRING3,U,11)_U_$J($P(STRING3,U,14),5,1)_U_$FN(PRN21,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o chlamydia screening"_U_+$P(STRING1,U,17)_U_$J($P(STRING1,U,18),5,1)_U_+$P(STRING2,U,17)_U_$J($P(STRING2,U,18),5,1)_U_$FN(PRD24,",+",1)_U_+$P(STRING3,U,17)_U_$J($P(STRING3,U,18),5,1)_U_$FN(PRN24,",+",1)
 D S^BGPMUDEL(X,1,1)
 ;
 S X="Denominator 3:"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 15-24 sexually active"_U_+$P(STRING1,U,19)_U_U_+$P(STRING2,U,19)_U_U_U_+$P(STRING3,U,19) D S^BGPMUDEL(X,2,1)
 S X="females" D S^BGPMUDEL(X,1,1)
 S X="# Excluded (Exc)"_U_+$P(STRING1,U,22)_U_U_+$P(STRING2,U,22)_U_U_U_+$P(STRING3,U,22)
 D S^BGPMUDEL(X,1,1)
 S X="Pts 15-24 sexually active"_U_+$P(STRING1,U,21)_U_U_+$P(STRING2,U,21)_U_U_U_+$P(STRING3,U,21)
 D S^BGPMUDEL(X,1,1)
 S X="females less Exc"
 D S^BGPMUDEL(X,1,1)
 S X="# w/chlamydia screening"_U_+$P(STRING1,U,20)_U_$J($P(STRING1,U,23),5,1)_U_+$P(STRING2,U,20)_U_$J($P(STRING2,U,23),5,1)_U_$FN(PRD31,",+",1)_U_+$P(STRING3,U,20)_U_$J($P(STRING3,U,23),5,1)_U_$FN(PRN31,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o chlamydia screening"_U_+$P(STRING1,U,26)_U_$J($P(STRING1,U,27),5,1)_U_+$P(STRING2,U,26)_U_$J($P(STRING2,U,27),5,1)_U_$FN(PRD34,",+",1)_U_+$P(STRING3,U,26)_U_$J($P(STRING3,U,27),5,1)_U_$FN(PRN34,",+",1)
 D S^BGPMUDEL(X,1,1)
 ;
 I $D(BGPLIST(BGPIC)) D P2
 Q
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 15-24 years of age with at least 1 encounter with the EP within 1 year" D S^BGPMUDEL(X,1,1)
 S X="of the reporting period end date, who have been identified as sexually active or" D S^BGPMUDEL(X,1,1)
 S X="pregnant on or before the reporting period end date AND who had at least" D S^BGPMUDEL(X,1,1)
 S X="1 chlamydia screening during the reporting period, if any." D S^BGPMUDEL(X,1,1)
 ;
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D S^BGPMUDEL(X,2,1)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D S^BGPMUDEL(X,1,1)
 S X="listed last." D S^BGPMUDEL(X,1,1)
 ;
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,2,1)
 S X="columns:" D S^BGPMUDEL(X,1,1)
 S X="PROC=Procedure Indicative of a Sexually Active Woman" D S^BGPMUDEL(X,1,1)
 S X="LABP=Laboratory Test for Pregnancy" D S^BGPMUDEL(X,1,1)
 S X="PREG=Pregnancy Encounter" D S^BGPMUDEL(X,1,1)
 S X="LAB=Laboratory Test Indicative of a Sexually Active Woman" D S^BGPMUDEL(X,1,1)
 S X="DX=Diagnosis Indicative of a Sexually Active Woman" D S^BGPMUDEL(X,1,1)
 S X="MED=Contraceptive Medication" D S^BGPMUDEL(X,1,1)
 S X="IUD=Use of IUD Device" D S^BGPMUDEL(X,1,1)
 S X="ALR=Allergy to IUD Device" D S^BGPMUDEL(X,1,1)
 S X="EDU=Contraceptive Use Education" D S^BGPMUDEL(X,1,1)
 S X="RF=Reproductive Factor" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="CHL=Chlamydia screening" D S^BGPMUDEL(X,1,1)
 ;
 S PTCT=0
 S X="Patients 15-19" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0033"","_$J_",""PAT"",""C"",""NOT"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0033"","_$J_",""PAT"",""C"",""NUM"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="A" D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0033"","_$J_",""PAT"",""C"",""EXC"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 ;
 S PTCT=0
 S X="Patients 20-24" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0033"","_$J_",""PAT"",""C"",""NOT"",3)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0033"","_$J_",""PAT"",""C"",""NUM"",3)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="A" D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0033"","_$J_",""PAT"",""C"",""EXC"",3)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,NUM1,NUM2,DEN1,DEN2,DEN3,LINE
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
