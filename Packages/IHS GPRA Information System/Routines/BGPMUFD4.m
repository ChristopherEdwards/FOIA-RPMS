BGPMUFD4 ; IHS/MSC/MGH - MU EP measures NQF0043 ;02-Mar-2011 11:26;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output reports for this measure
PNEUMO ;EP
 D P1
 K ^TMP("BGPMU0043")
 Q
P1 ;Write individual measure
 N X,Y,Z,DEN,NUM,PC1,STRING1,STRING2,STRING3,PRD,PRN
 S STRING1=$$0043("C")
 S STRING2=$$0043("P")
 S STRING3=$$0043("B")
 D SUM43^BGPMUFP4
 S PRD=$P(STRING1,U,3)-$P(STRING2,U,3)
 S PRN=$P(STRING1,U,3)-$P(STRING3,U,3)
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG BASE %"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 65+"_U_($P(STRING1,U,1)+$P(STRING1,U,4))_U_U_($P(STRING2,U,1)+$P(STRING2,U,4))_U_U_U_($P(STRING3,U,1)+$P(STRING3,U,4))
 D S^BGPMUDEL(X,2,1)
 S X="# w/pneumococcal vaccine"_U_$P(STRING1,U,2)_U_$P(STRING1,U,3)_U_$P(STRING2,U,2)_U_$P(STRING2,U,3)_U_$FN(PRD,",+",1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,3)_U_$FN(PRN,",+",1)
 D S^BGPMUDEL(X,2,1)
 S X="# w/o pneumococcal vaccine"_U_($P(STRING1,U,1)-$P(STRING1,U,2))_U_$P(STRING1,U,5)_U_($P(STRING2,U,1)-$P(STRING2,U,2))_U_$P(STRING2,U,5)_U_$FN(PRD1,",+",1)
 S X=X_U_($P(STRING3,U,1)-$P(STRING3,U,2))_U_$P(STRING3,U,5)_U_$FN(PRN1,",+",1)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D P2
 K X,Y,Z,DEN,NUM,PC1,STRING1,STRING2,STRING3,PRD,PRN
 Q
0043(TF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0043",$J,TF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0043",$J,TF,"NUM"))
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 S PC1=$$ROUND^BGPMUA01((NUM/DEN),3)*100,PC2=$$ROUND^BGPMUA01(((DEN-NUM)/DEN),3)*100
 S ARRAY=DEN_U_NUM_U_PC1_U_""_U_PC2
 Q ARRAY
P2 ;Do the Details
 N PT,NODE,NAME,VST,COLON,FOL,BGPARR,LINE,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 65 years of age and older with at least 1 outpatient encounter with the " D S^BGPMUDEL(X,2,1)
 S X="EP within 1 year of the reporting period end date who received a pneumococcal" D S^BGPMUDEL(X,1,1)
 S X="vaccine during the reporting period, if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:)," D S^BGPMUDEL(X,2,1)
 S X="followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator column:" D S^BGPMUDEL(X,2,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S PTCT=0
 I $Y>(BGPIOSL-5) D HEADERL^BGPMUPH Q:BGPQUIT
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0043"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0043"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 K PT,NODE,NAME,VST,COLON,FOL
 Q
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$$GET1^DIQ(2,$P(NODE,U,1),.01)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S DEN=$P(NODE,U,2),NUM=$P(NODE,U,3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_$S($G(NUM)="":"NM:",1:"M:"_NUM) D S^BGPMUDEL(X,1,1)
 K NAME,HRN,DEN,NUM,AGE,DFN
 Q
