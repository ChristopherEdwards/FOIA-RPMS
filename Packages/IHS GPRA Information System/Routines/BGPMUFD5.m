BGPMUFD5 ; IHS/MSC/MGH - MU EP measures NQF0075 ;02-Mar-2011 11:26;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output reports for this measure
IVDLDL ;EP
 D P1
 K ^TMP("BGPMU0075")
 Q
P1 ;Write individual measure
 N X,Y,Z,DEN,NUM,PC1,STRING1,STRING2,STRING3,PRD,PRD1,PRD2,PRD3,PRN,PRN1,PRN2,PRN3
 S STRING1=$$D75^BGPMUFP5("C")
 S STRING2=$$D75^BGPMUFP5("P")
 S STRING3=$$D75^BGPMUFP5("B")
 D SUM75^BGPMUFP5
 S PRD=$P(STRING1,U,3)-$P(STRING2,U,3)
 S PRN=$P(STRING1,U,3)-$P(STRING3,U,3)
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5)
 S PRD2=$P(STRING1,U,6)-$P(STRING2,U,6)
 S PRN2=$P(STRING1,U,6)-$P(STRING3,U,6)
 S PRD3=$P(STRING1,U,8)-$P(STRING2,U,8)
 S PRN3=$P(STRING1,U,8)-$P(STRING3,U,8)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG BASE %"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 18+ w/PTCA, AMI, CABG or IVD"_U_($P(STRING1,U,1)+$P(STRING1,U,4))_U_U_($P(STRING2,U,1)+$P(STRING2,U,4))_U_U_U_($P(STRING3,U,1)+$P(STRING3,U,4))
 D S^BGPMUDEL(X,2,1)
 S X="Numerator 1" D S^BGPMUDEL(X,2,1)
 S X="# w/LDL test result"_U_$P(STRING1,U,2)_U_$P(STRING1,U,3)_U_$P(STRING2,U,2)_U_$P(STRING2,U,3)_U_$FN(PRD,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,3)_U_$FN(PRN,",+",1)
 D S^BGPMUDEL(X,1,1)
 S X="# w/o LDL test result"_U_($P(STRING1,U,1)-$P(STRING1,U,2))_U_$P(STRING1,U,5)_U_($P(STRING2,U,1)-$P(STRING2,U,2))_U_$P(STRING2,U,5)_U_$FN(PRD1,",+",1)
 S X=X_U_($P(STRING3,U,1)-$P(STRING3,U,2))_U_$P(STRING3,U,5)_U_$FN(PRN1,",+",1)
 D S^BGPMUDEL(X,1,1)
 S X="Numerator 2" D S^BGPMUDEL(X,2,1)
 S X="w/LDL < 100mg/dL"_U_$P(STRING1,U,6)_U_$P(STRING1,U,7)_U_$P(STRING2,U,6)_U_$P(STRING2,U,7)_U_$FN(PRD2,",+",1)_U_$P(STRING3,U,6)_U_$P(STRING3,U,7)_U_$FN(PRN2,",+",1)
 D S^BGPMUDEL(X,1,1)
 S X="w/o LDL < 100mg/dL"_U_($P(STRING1,U,1)-$P(STRING1,U,6))_U_$P(STRING1,U,8)_U_($P(STRING2,U,1)-$P(STRING2,U,6))_U_$P(STRING2,U,8)_U_$FN(PRD3,",+",1)
 S X=X_U_($P(STRING3,U,1)-$P(STRING3,U,6))_U_$P(STRING3,U,8)_U_$FN(PRN3,",+",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D P2
 K X,Y,Z,DEN,NUM,PC1,STRING1,STRING2,STRING3,PRD,PRD1,PRD2,PRD3,PRN,PRN1,PRN2,PRN3
 Q
P2 ;Do the Details
 N PT,NODE,NAME,VST,COLON,FOL,BGPARR,LINE,PTCT,NOTMET
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 18+ and (a) who had at least 1 acute inpatient encounter with the" D S^BGPMUDEL(X,2,1)
 S X="EP 14-24 months prior to the reporting period end date AND who underwent" D S^BGPMUDEL(X,1,1)
 S X="percutaneous transluminal coronary angioplasty (PTCA), acute myocardial" D S^BGPMUDEL(X,1,1)
 S X="infarction (AMI), or coronary artery bypass graft (CABG); OR (b) who had least" D S^BGPMUDEL(X,1,1)
 S X="1 acute inpatient or outpatient encounter with the EP within 2 years of the" D S^BGPMUDEL(X,1,1)
 S X="reporting period end date with a diagnosis of ischemic vascular disease (IVD);" D S^BGPMUDEL(X,1,1)
 S X="AND (c) who had a complete lipid profile performed during the measurement year;" D S^BGPMUDEL(X,1,1)
 S X="AND (d) whose LDL=C was <100 mg/dL, if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:)," D S^BGPMUDEL(X,2,1)
 S X="followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator and numerator columns:" D S^BGPMUDEL(X,2,1)
 S X="PTCA=PTCA Procedure" D S^BGPMUDEL(X,1,1)
 S X="AMI=AMI Diagnosis" D S^BGPMUDEL(X,1,1)
 S X="CABG=CABG Procedure" D S^BGPMUDEL(X,1,1)
 S X="IVD=IVD Diagnosis" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="LDL=LDL Lab Test" D S^BGPMUDEL(X,1,1)
 S X="CHL=Cholesterol Lab Test" D S^BGPMUDEL(X,1,1)
 S X="HDL=High Density Lipoprotein Lab Test" D S^BGPMUDEL(X,1,1)
 S X="TRI=Triglycerides Test" D S^BGPMUDEL(X,1,1)
 S X="Numerator 1: Patients with LDL Test" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I $Y>(BGPIOSL-5) D HEADERL^BGPMUPH Q:BGPQUIT
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .S NOTMET=1
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0075"","_$J_",""PAT"",""C"",""NOT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .S NOTMET=0
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0075"","_$J_",""PAT"",""C"",""NUM"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 S X="Numerator 2: Patients with LDL Test Result < 100mg/dL" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I $Y>(BGPIOSL-5) D HEADERL^BGPMUPH Q:BGPQUIT
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .S NOTMET=1
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0075"","_$J_",""PAT"",""C"",""NOT"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .S NOTMET=0
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0075"","_$J_",""PAT"",""C"",""NUM"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 K PT,NODE,NAME,VST,COLON,FOL
 Q
DATA(NODE) ;DISPLAY DATA
 N X,NAME,HRN,DEN,NUM1,NUM2,NUM3,NUMVALS,NUMDATES,AGE,SEX,COMM,DFN
 S (DEN1,DEN2,NUM1,NUM2,NUM3)=""
 S DFN=$P(NODE,U,1)
 S NAME=$$GET1^DIQ(2,$P(NODE,U,1),.01)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$P(^DPT(DFN,0),U,2)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S DEN=$P(NODE,U,2),NUMDATES=$P(NODE,U,3),NUMVALS=$P(NODE,U,4)
 S:NUMVALS'="" NUM1=$P(NUMVALS,";",1)_" "_$$DATE^BGPMUUTL($P(NUMDATES,";",1))
 S:$P(NUMVALS,";",2)'="" NUM2=$P(NUMVALS,";",2)_" "_$$DATE^BGPMUUTL($P(NUMDATES,";",2))
 S:$P(NUMVALS,";",3)'="" NUM3=$P(NUMVALS,";",3)_" "_$$DATE^BGPMUUTL($P(NUMDATES,";",3))
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_$S(NOTMET:"NM:",1:"M:")_NUM1_$S(NUM2'="":";"_NUM2_";"_NUM3,1:"") D S^BGPMUDEL(X,1,1)
 K X,NAME,HRN,DEN,NUM1,NUM2,NUM3,NUMVALS,NUMDATES,AGE,DFN,COMM
 Q
