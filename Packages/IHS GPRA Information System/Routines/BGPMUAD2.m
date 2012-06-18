BGPMUAD2 ; IHS/MSC/MGH - Print MU measure NQF0031,NQF0032,NQF0034 ;01-Mar-2011 15:41;MGH
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimeted output for these measures
COLON ;EP
 D P1
 ;I BGPMUDET="D" D P2
 K ^TMP("BGPMU0034")
 Q
P1 ;Write individual measure
 N X,Y,Z,DEN,NUM,PC1,STRING1,STRING2,STRING3,PRD,PRN,PRD1,PRD2,PRN1,PRN2
 S STRING1=$$0034("C")
 S STRING2=$$0034("P")
 S STRING3=$$0034("B")
 D SUM34^BGPMUAP2
 S PRD=$P(STRING1,U,4)-$P(STRING2,U,4)
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRD2=$P(STRING1,U,7)-$P(STRING2,U,7)
 S PRN=$P(STRING1,U,4)-$P(STRING3,U,4)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5)
 S PRN2=$P(STRING1,U,7)-$P(STRING3,U,7)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 50-70"_U_($P(STRING1,U,1)+$P(STRING1,U,6))_U_U_($P(STRING2,U,1)+$P(STRING2,U,6))_U_U_U_($P(STRING3,U,1)+$P(STRING3,U,6)) D S^BGPMUDEL(X,2,1)
 S X="# Excluded (Exc)"_U_$P(STRING1,U,6)_U_U_$P(STRING2,U,6)_U_U_U_$P(STRING3,U,6) D S^BGPMUDEL(X,1,1)
 S X="Pts 50-74 less Exc"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1) D S^BGPMUDEL(X,1,1)
 S X="# w/colon screen"_U_$P(STRING1,U,2)_U_$P(STRING1,U,4)_U_$P(STRING2,U,2)_U_$P(STRING2,U,4)_U_$FN(PRD,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,4)_U_$FN(PRN,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o colon screen"_U_$P(STRING1,U,3)_U_$P(STRING1,U,5)_U_$P(STRING2,U,3)_U_$P(STRING2,U,5)_U_$FN(PRD1,",+",1)_U_$P(STRING3,U,3)_U_$P(STRING3,U,5)_U_$FN(PRN1,",+",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D P2
 Q
0034(TF) ;Get the numbers for this measure
 N ARRAY,DEN,NUM,PC1,PC2,PC3,EXC
 S (ARRAY,PC1,PC2,PC3)=""
 S DEN=+$G(^TMP("BGPMU0034",$J,TF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0034",$J,TF,"NUM"))
 S EXC=+$G(^TMP("BGPMU0034",$J,TF,"EXC"))
 S NOT=+$G(^TMP("BGPMU0034",$J,TF,"NOT"))
 I DEN=0 S (PC1,PC2,PC3)=0
 I DEN>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM/DEN),3)*100
 .S PC2=$$ROUND^BGPMUA01((NOT/DEN),3)*100
 .S PC3=$$ROUND^BGPMUA01((EXC/DEN),3)*100
 S ARRAY=DEN_U_NUM_U_NOT_U_PC1_U_PC2_U_EXC_U_PC3
 Q ARRAY
P2 ;Do the Details
 N PT,NODE,NAME,VST,COLON,FOL,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT *****" D S^BGPMUDEL(X,2,1)
 S X="Patients 50-74 with at least 1 encounter with the EP within the last 2 years" D S^BGPMUDEL(X,2,1)
 S X="who have never had a total colectomy, with documented colorectal cancer screening," D S^BGPMUDEL(X,1,1)
 S X="if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:)," D S^BGPMUDEL(X,2,1)
 S X="followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,2,1)
 S X="columns: " D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0034"","_$J_",""PAT"",""C"",""DEN"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0034"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="A" D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0034"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;Print results of breast cancer screen
BREAST ;EP
 D B1
 ;I BGPMUDET="D" D B2
 K ^TMP("BGPMU0031")
 Q
B1 ;Write individual measure
 N X,Y,Z,DEN,NUM,PC,STRING1,STRING2,STRING3,PRD,PRN,PRD1,PRN1
 S STRING1=$$0031("C")
 S STRING2=$$0031("P")
 S STRING3=$$0031("B")
 D SUM31^BGPMUAP2
 S PRD=$P(STRING1,U,4)-$P(STRING2,U,4)
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRN=$P(STRING1,U,4)-$P(STRING3,U,4)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 41-68"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1) D S^BGPMUDEL(X,2,1)
 S X="# w/mammogram"_U_$P(STRING1,U,2)_U_$P(STRING1,U,4)_U_$P(STRING2,U,2)_U_$P(STRING2,U,4)_U_$FN(PRD,"+,",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,4)_U_$FN(PRN,"+,",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o mammogram"_U_$P(STRING1,U,3)_U_$P(STRING1,U,5)_U_$P(STRING2,U,3)_U_$P(STRING2,U,5)_U_$FN(PRD1,"+,",1)_U_$P(STRING3,U,3)_U_$P(STRING3,U,5)_U_$FN(PRN1,"+,",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D B2
 Q
0031(TF) ;Get the numbers for this measure
 N ARRAY,DEN,NUM,NNUM,PC1,PC2
 S DEN=+$G(^TMP("BGPMU0031",$J,TF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0031",$J,TF,"NUM"))
 S NOT=+$G(^TMP("BGPMU0031",$J,TF,"NOT"))
 S NNUM=DEN-NUM
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM/DEN),3)*100
 .S PC2=$$ROUND^BGPMUA01((NNUM/DEN),3)*100
 S ARRAY=DEN_U_NUM_U_NNUM_U_PC1_U_PC2
 Q ARRAY
B2 ;Do the Details
 N PT,NODE,NAME,VST,BREAST,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT *****"
 D S^BGPMUDEL(X,2,1)
 S X="Female patients 41-68 with at least 1 encounter with the EP within 2 years of"
 D S^BGPMUDEL(X,2,1)
 S X="the reporting period end date and who have never had a bilateral mastectomy or 2"
 D S^BGPMUDEL(X,1,1)
 S X="unilateral mastectomies, with documented mammogram, if any."
 D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed"
 D S^BGPMUDEL(X,2,1)
 S X="by patients who do meet the numerator criteria (M:)."
 D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator column:"
 D S^BGPMUDEL(X,2,1)
 S X="EN=Encounter"
 D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0031"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0031"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,DEN1,DEN2
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S DEN=$P(NODE,U,4)
 S NUM=$P(NODE,U,5)
 S COMM=$$GET1^DIQ(9000001,DFN,1118)
 S SEX=$P(^DPT(DFN,0),U,2)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_"EN:"_$P($$FMTE^XLFDT(DEN,2),".",1)_U_$S(NUM="":"NM: ",1:"M: "_$P(NUM,";",1)_" "_$P($$FMTE^XLFDT($P(NUM,";",2),2),".",1))
 D S^BGPMUDEL(X,1,1)
 Q
 ;Get results of cervical cancer screen
PAP ;EP
 D C1
 ;I BGPMUDET="D" D C2
 K ^TMP("BGPMU0032")
 Q
C1 ;Write individual measure
 N X,Y,Z,DEN,NUM,PC,STRING1,STRING2,STRING3,PRD,PRN,PRN1,PRD1
 S STRING1=$$0032("C")
 S STRING2=$$0032("P")
 S STRING3=$$0032("B")
 D SUM32^BGPMUAP2
 S PRD=$P(STRING1,U,4)-$P(STRING2,U,4)
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRN=$P(STRING1,U,4)-$P(STRING3,U,4)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 23-63:"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1) D S^BGPMUDEL(X,2,1)
 S X="# w/pap test"_U_$P(STRING1,U,2)_U_$P(STRING1,U,4)_U_$P(STRING2,U,2)_U_$P(STRING2,U,4)_U_$FN(PRD,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,4)_U_$FN(PRN,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o pap test"_U_$P(STRING1,U,3)_U_$P(STRING1,U,5)_U_$P(STRING2,U,3)_U_$P(STRING2,U,5)_U_$FN(PRD1,",+",1)_U_$P(STRING3,U,3)_U_$P(STRING3,U,5)_U_$FN(PRN1,",+",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D C2
 Q
0032(TF) ;Get the numbers for this measure
 N ARRAY,DEN,NUM,PC1,PC2,NNUM
 S DEN=+$G(^TMP("BGPMU0032",$J,TF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0032",$J,TF,"NUM"))
 S NNUM=DEN-NUM
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM/DEN),3)*100
 .S PC2=$$ROUND^BGPMUA01((NNUM/DEN),3)*100
 S ARRAY=DEN_U_NUM_U_NNUM_U_PC1_U_PC2
 Q ARRAY
C2 ;Do the Details
 N PT,NODE,NAME,VST,CERV,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT *****" D S^BGPMUDEL(X,2,1)
 S X="Female patients 23-63 with at least 1 encounter with the EP within the last" D S^BGPMUDEL(X,2,1)
 S X="2 years who have never had a hysterectomy, with documented pap test, if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:)," D S^BGPMUDEL(X,2,1)
 S X="followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,2,1)
 S X="columns: " D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0032"","_$J_",""PAT"",""C"",""DEN"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0032"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
XML0032 ;Ouptut the XML for the PAP smear logic
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count^Numerator Count
 N STRING
 S STRING=$$0032("C")
 S BGPXML(1)="NQF_0032"_U_U_+$P(STRING,U,1)_U_+$P(STRING,U,2)
 K ^TMP("BGPMU0032",$J)
 Q
XML0031 ;Output the XML for the Mammogram logic
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count
 N STRING
 S STRING=$$0031("C")
 S BGPXML(1)="112"_U_U_+$P(STRING,U,1)_U_+$P(STRING,U,2)
 K ^TMP("BGPMU0031",$J)
 Q
XML0034 ;Output the XML for the Colon Cancer logic
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exception
 N STRING
 S STRING=$$0034("C")
 S BGPXML(1)="113"_U_U_+$P(STRING,U,1)_U_+$P(STRING,U,2)_U_+$P(STRING,U,6) Q
 K ^TMP("BGPMU0034",$J)
 Q
