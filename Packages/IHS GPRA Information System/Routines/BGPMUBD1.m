BGPMUBD1 ; IHS/MSC/MGH - Print MI measure NQF0002 ;26-Aug-2011 16:31;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimeted output
 ;Pharyngitis on antibiotics with laboratory test
PHAR ;EP
 D P1
 K ^TMP("BGPMU0002")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,PC1,PC2,EXC1,EXC2,STRING1,STRING2,STRING3
 N PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,PRD7,PRD8,PRN1,PRN2,PRN3,PRN4,PRN5,PRN6,PRN7,PRN8
 S STRING1=$$NUM02("C")
 S STRING2=$$NUM02("P")
 S STRING3=$$NUM02("B")
 D SUMMARY1^BGPMUBP1(STRING1,STRING2,STRING3)
 ;First population
 S PRD=$P(STRING1,U,4)-$P(STRING2,U,4) S PRD=$FN(PRD,",+",1)
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5) S PRD1=$FN(PRD1,",+",1)
 S PRN=$P(STRING1,U,4)-$P(STRING3,U,4) S PRN=$FN(PRN,",+",1)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5) S PRN1=$FN(PRN1,",+",1)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 2-18 w/pharyngitis"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1) D S^BGPMUDEL(X,1,1)
 S X="and antibiotics Rx" D S^BGPMUDEL(X,1,1)
 S X="# w/streptococcus test"_U_$P(STRING1,U,2)_U_$J($P(STRING1,U,4),5,1)_U_$P(STRING2,U,2)_U_$J($P(STRING2,U,4),5,1)_U_PRD_U_$P(STRING3,U,2)_U_$J($P(STRING3,U,4),5,1)_U_PRN
 D S^BGPMUDEL(X,2,1)
 S X="# w/o streptococcus test"_U_$P(STRING1,U,3)_U_$J($P(STRING1,U,5),5,1)_U_$P(STRING2,U,3)_U_$J($P(STRING2,U,5),5,1)_U_PRD1_U_$P(STRING3,U,3)_U_$J($P(STRING3,U,5),5,1)_U_PRN1
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D P2
 Q
NUM02(TF) ;Get the numbers for this measure
 N ARRAY,DEN,NUM,EXC,NOT,PC1,PC11,PC2,PC13,NNUM,PC14
 N ARRAY,DEN,NUM,PC1,NNUM,PC2
 S DEN=+$G(^TMP("BGPMU0002",$J,TF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0002",$J,TF,"NUM"))
 S NOT=+$G(^TMP("BGPMU0002",$J,TF,"NOT"))
 S NNUM=DEN-NUM
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM/DEN),3)*100
 .S PC2=$$ROUND^BGPMUA01((NNUM/DEN),3)*100
 S ARRAY=DEN_U_NUM_U_NNUM_U_PC1_U_PC2
 Q ARRAY
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT
 S PTCT=0
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 2-18 with at least 1 ED or outpatient encounter with the EP during the" D S^BGPMUDEL(X,1,1)
 S X="reporting period AND who were diagnosed with pharyngitis AND who were prescribed" D S^BGPMUDEL(X,1,1)
 S X="an antibiotic <= 3 days after the encounter AND who received a group A" D S^BGPMUDEL(X,1,1)
 S X="streptococcus (strep) test <= 3 days before or after the antibiotic was" D S^BGPMUDEL(X,1,1)
 S X="prescribed by the EP, if any." D S^BGPMUDEL(X,1,1)
 S X="" D S^BGPMUDEL(X,1,1)
 S X="Patients who did not meet the numerator criteria are listed first (NM:)," D S^BGPMUDEL(X,1,1)
 S X="followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="" D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,1,1)
 S X="columns:" D S^BGPMUDEL(X,1,1)
 S X="PHA=Pharyngitis Diagnosis" D S^BGPMUDEL(X,1,1)
 S X="MED=Pharyngitis Antibiotic Medication" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="LAB=Streptococcus Test" D S^BGPMUDEL(X,1,1)
 S X="CPT=Streptococcus Code" D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0002"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0002"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM1,NUM2,AGE,DFN,SEX,COMM
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,30)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S COMM=$$GET1^DIQ(9000001,DFN,1118)
 S SEX=$P(^DPT(DFN,0),U,2)
 S DEN=$P(NODE,U,2),NUM=$P(NODE,U,3)
 S NUM1=$P(NUM,";",1),NUM2=$$DATE^BGPMUAP3($P($P(NUM,";",2),".",1))
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_NUM1_" "_NUM2 D S^BGPMUDEL(X,1,1)
 Q
XML0002 ;XML output for pharyngitis on antibiotics with strep test
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count^exclusion number
 N STRING,TOTN,TOTD,TOTE
 S STRING=$$NUM02("C")
 S TOTD=$P(STRING,U,1)
 S TOTN=$P(STRING,U,2)
 ;S TOTE=$P(STRING,U,3)
 S BGPXML(1)="66"_U_U_+TOTD_U_+TOTN
 K ^TMP("BGPMU0002",$J)
 Q
