BGPMUDD4 ; IHS/MSC/SAT - Delimited MU measure NQF0027 ;27-Apr-2011 13:15;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output for Prenatal HIV Screening 0027 (BGPMUD07)
D27ENT ;EP
 D P27B
 K ^TMP("BGPMU0027")
 Q
P27B ;Write individual measure
 N BGPPTYPE,X,Y,Z,DEN,NUM,PC,STRING1,STRING2,PRD,PRN,PRD1,PRN1
 S BGPPTYPE="D"
 S STRING1=$$027^BGPMUDP4("C")
 S STRING2=$$027^BGPMUDP4("P")
 S STRING3=$$027^BGPMUDP4("B")
 D SUM027
 ;S PRD11=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year (line 1)
 S PRD12=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD13=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD14=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD15=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 ;S PRD21=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year (line 1)
 S PRD22=$P(STRING1,U,11)-$P(STRING2,U,11)  ;% change from prev year
 S PRD23=$P(STRING1,U,11)-$P(STRING3,U,11)  ;% change from base year
 S PRD24=$P(STRING1,U,12)-$P(STRING2,U,12)  ;% change from prev year
 S PRD25=$P(STRING1,U,12)-$P(STRING3,U,12)  ;% change from prev year
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YR"_U_"%"_U_"CHG FROM BASE %"
 D S^BGPMUDEL(X,1,1)
 S X="Pts 18+"_U_$P(STRING1,U,1)_U_$P(STRING2,U,1)_U_$P(STRING3,U,1)
 D S^BGPMUDEL(X,1,1)
 S X="Numerator 1"
 D S^BGPMUDEL(X,2,1)
 S X="# w/tobacco use"_U_$P(STRING1,U,2)_U_$J($P(STRING1,U,5),5,1)_U_$P(STRING2,U,2)_U_$J($P(STRING2,U,5),5,1)_U_$J($FN(PRD12,",+",1),6)_U_$P(STRING3,U,2)_U_$J($P(STRING3,U,5),5,1)_U_$J($FN(PRD13,",+",1),6)
 D S^BGPMUDEL(X,1,1)
 S X="# w/o tobacco use"_U_$P(STRING1,U,3)_U_$J($P(STRING1,U,6),5,1)_U_$P(STRING2,U,3)_U_$J($P(STRING2,U,6),5,1)_U_$J($FN(PRD14,",+",1),6)_U_$P(STRING3,U,3)_U_$J($P(STRING3,U,6),5,1)_U_$J($FN(PRD15,",+",1),6)
 D S^BGPMUDEL(X,1,1)
 S X="Numerator 2"
 D S^BGPMUDEL(X,2,1)
 S X="# w/tobacco use and cessation counseling"_U_$P(STRING1,U,8)_U_$J($P(STRING1,U,11),5,1)_U_$P(STRING2,U,8)_U_$J($P(STRING2,U,11),5,1)
 S X=X_U_$J($FN(PRD22,",+",1),6)_U_$P(STRING3,U,8)_U_$J($P(STRING3,U,11),5,1)_U_$J($FN(PRD23,",+",1),6)
 D S^BGPMUDEL(X,1,1)
 S X="# w/o tobacco use or w/tobacco use and no cessation counseling"_U_$P(STRING1,U,9)_U_$J($P(STRING1,U,12),5,1)_U_$P(STRING2,U,9)
 S X=X_U_$J($P(STRING2,U,12),5,1)_U_$J($FN(PRD24,",+",1),6)_U_$P(STRING3,U,9)_U_$J($P(STRING3,U,12),5,1)_U_$J($FN(PRD25,",+",1),6)
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D TC27
 Q
TC27 ;Do the Details
 N PT,NODE,NAME,BP
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 S X="Patients 18 years of age and older with at least 1 encounter with the EP within" D S^BGPMUDEL(X,2,1)
 S X="2 years of the reporting period end date, who have been identified as tobacco" D S^BGPMUDEL(X,1,1)
 S X="users within 1 year before or during the reporting period and who received" D S^BGPMUDEL(X,1,1)
 S X="advice to quit smoking or tobacco use or whose EP recommended or discussed" D S^BGPMUDEL(X,1,1)
 S X="smoking or tobacco use cessation medications, methods or strategies within" D S^BGPMUDEL(X,1,1)
 S X="1 year of the reporting period end date, if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D S^BGPMUDEL(X,2,1)
 S X="by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator and numerator" D S^BGPMUDEL(X,2,1)
 S X="columns:" D S^BGPMUDEL(X,1,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="HF=Tobacco User Health Factor" D S^BGPMUDEL(X,1,1)
 ;
 S X="Numerator 1: Tobacco users"
 D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S LINE="",$P(LINE,"-",81)="" S X=LINE
 D S^BGPMUDEL(X,1,1)
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0027",$J,"PAT","C","NOT",1)) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0027"","_$J_",""PAT"",""C"",""NOT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D027(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0027",$J,"PAT","C","NUM",1))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0027"","_$J_",""PAT"",""C"",""NUM"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D027(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 S X="Numerator 2: Tobacco users who received tobacco use cessation counseling"
 D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S LINE="",$P(LINE,"-",81)="" S X=LINE
 D S^BGPMUDEL(X,1,1)
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0027",$J,"PAT","C","NOT",2)) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0027"","_$J_",""PAT"",""C"",""NOT"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D027(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0027",$J,"PAT","C","NUM",2))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0027"","_$J_",""PAT"",""C"",""NUM"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D027(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
D027(NODE) ;GET DATA
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
SUM027 ;Populate "BGPMU SUMMARY" for Measure 0027
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J,N
 S J=$J
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",J,BGPIC)
 S ^TMP("BGPMU SUMMARY",J,BGPIC)="0027"_U_"115"
 F N=1:1:2 D
 .;Setup summary page/iCare ^TMP global
 .S CDEN(N)=+$G(^TMP("BGPMU0027",J,"C","DEN",1))                 ;current
 .S CNUM(N)=+$G(^TMP("BGPMU0027",J,"C","NUM",N))
 .S CMP(N)=$S(CDEN(N)>0:$$ROUND^BGPMUA01(CNUM(N)/CDEN(N),3)*100,1:0)
 .S PDEN(N)=+$G(^TMP("BGPMU0027",J,"P","DEN",1))                 ;previous
 .S PNUM(N)=+$G(^TMP("BGPMU0027",J,"P","NUM",N))
 .S PMP(N)=$S(PDEN(N)>0:$$ROUND^BGPMUA01(PNUM(N)/PDEN(N),3)*100,1:0)
 .S BDEN(N)=+$G(^TMP("BGPMU0027",J,"B","DEN",1))                 ;baseline
 .S BNUM(N)=+$G(^TMP("BGPMU0027",J,"B","NUM",N))
 .S BMP(N)=$S(BDEN(N)>0:$$ROUND^BGPMUA01(BNUM(N)/BDEN(N),3)*100,1:0)
 ;
 S BGPDNCNT=BGPDNCNT+1
 F N=1:1:2 D
 .S BGPSSTR="MU.EP.0027."_N_U_$S(N=1:"18+ # w/tobacco use",N=2:"18+ # w/tobacco use and counseling",1:"")_U_0_U_CDEN(N)_U_CNUM(N)_U_CMP(N)_U_U_U_U
 .; 11 12 13 14
 .S BGPSSTR=BGPSSTR_U_0_U_PDEN(N)_U_PNUM(N)_U_PMP(N)
 .; 15 16 17 18
 .S BGPSSTR=BGPSSTR_U_0_U_BDEN(N)_U_BNUM(N)_U_BMP(N)
 .S ^TMP("BGPMU SUMMARY",J,BGPIC,N)=BGPSSTR
 ;
 Q
