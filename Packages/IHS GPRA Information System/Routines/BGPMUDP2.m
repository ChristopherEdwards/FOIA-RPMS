BGPMUDP2 ; IHS/MSC/SAT - MU EH  measure output routines;02-Mar-2011 16:30;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
 ;This routine does the printed output of 0081 Heart Failure (BGPMUD03)
HF ;EP  output routine for 0081 Heart Failure
 D P2
 K ^TMP("BGPMU0081")
 Q
P2 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,EXC1,PC1,PC11,PC13,NONUM,STRING1,STRING2,STRING3,PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,X
 S STRING1=$$081("C")
 S STRING2=$$081("P")
 S STRING3=$$081("B")
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year (line 1)
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 D HEADER^BGPMUPH Q:BGPQUIT
 W !
 D HDRBLK^BGPMUPH
 W !,"Pts 18+ w/heart failure",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 W !,"and LVEF < 40%"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?64,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Pts 18+ w/heart failure",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?64,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"and LVEF < 40% less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/ACE inhibitor or ARB",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o ACE inhibitor or ARB",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 I $D(BGPLIST(BGPIC)) D P2D
 D SUM081^BGPMUDD2
 Q
081(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN1=+$G(^TMP("BGPMU0081",$J,BGPMUTF,"DEN"))
 S NUM1=+$G(^TMP("BGPMU0081",$J,BGPMUTF,"NUM"))
 S NONUM=+$G(^TMP("BGPMU0081",$J,BGPMUTF,"NOT"))
 S EXC1=+$G(^TMP("BGPMU0081",$J,BGPMUTF,"EXC"))
 I DEN1=0 S (PC1,PC11,PC13)=0
 I DEN1>0 D
 .I DEN1-EXC1=0 S (PC1,PC11,PC13)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM1/(DEN1-EXC1)),3)*100
 ..S PC11=$$ROUND^BGPMUA01((NONUM/(DEN1-EXC1)),3)*100
 ..S PC13=$$ROUND^BGPMUA01((EXC1/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_EXC1_U_PC1_U_PC11_U_PC13_U_""
 Q ARRAY
P2D ;Do the Details
 N PT,PTCNT,NODE,NAME,VST,BMI,FOL,X
 N BGPARR
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Patients 18+ with at least 1 inpatient discharge encounter OR at least" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="2 outpatient OR at least 2 nursing facility encounters with the EP during the" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="reporting period AND a diagnosis of heart failure during or before any of these" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="encounters AND a Left Ventricular Ejection Fraction (LVEF) < 40% before any of" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="these encounters during the reporting period AND who were prescribed ACE" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="inhibitors or ARB medications during the reporting period, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="HF=Heart Failure diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="LVEF= Left Ventricular Ejection Fraction (LVEF) < 40%" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=ACE Inhibitor or ARB Medication" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0081",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0081"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D081(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0081",$J,"PAT","C","NUM"))) D
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
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
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
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,$P(DEN,";",1),?69,NUM
 F BGPI=2:1:4 I $P(DEN,";",BGPI)'="" W !,?53,$P(DEN,";",BGPI)
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
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,$P(DEN,";",1),?69,"Excluded"
 F BGPI=2:1:4 I $P(DEN,";",BGPI)'="" W !,?53,$P(DEN,";",BGPI)
 Q
 ;
XML081 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="5"_U_""_U_+$G(^TMP("BGPMU0081",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0081",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0081",$J,"C","EXC"))
 K ^TMP("BGPMU0081",$J)
 Q
 ;
 ;*******************************
 ;
  ;This routine does the printed output of 0012 Prenatal HIV Screening (BGPMUD04)
PENTRY ;EP  output routine for 0012 Prenatal HIV Screening
 D P12
 K ^TMP("BGPMU0012")
 Q
P12 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,EXC1,PC1,PC11,PC13,NONUM,STRING1,STRING2,STRING3,PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,X
 S STRING1=$$012("C")
 S STRING2=$$012("P")
 S STRING3=$$012("B")
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year (line 1)
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 D HEADER^BGPMUPH Q:BGPQUIT
 ;W !
 D HDRBLK^BGPMUPH
 W !,"Pts w/live birth and",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 W !,"prenatal encounter"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?64,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Pts w/live birth and",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?64,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"prenatal encounter less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/HIV screening",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o HIV screening",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 I $D(BGPLIST(BGPIC)) D P12D
 D SUM012^BGPMUDD2
 Q
012(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN1=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"DEN"))
 S NUM1=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"NUM"))
 S NONUM=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"NOT"))
 S EXC1=+$G(^TMP("BGPMU0012",$J,BGPMUTF,"EXC"))
 I DEN1=0 S (PC1,PC11,PC13)=0
 I DEN1>0 D
 .I DEN1-EXC1=0 S (PC1,PC11,PC13)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM1/(DEN1-EXC1)),3)*100
 ..S PC11=$$ROUND^BGPMUA01((NONUM/(DEN1-EXC1)),3)*100
 .S PC13=$$ROUND^BGPMUA01((EXC1/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_EXC1_U_PC1_U_PC11_U_PC13_U_""
 Q ARRAY
P12D ;Do the Details
 N PT,PTCNT,NODE,NAME,VST,BMI,FOL,X
 N BGPARR
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Patients, regardless of age, who gave birth during the reporting period who were" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="screened for HIV infection during the first or second prenatal encounter," D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="DEL=Live birth delivery" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Prenatal Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="HIV=HIV Screening" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?66,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0012",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0012"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D012(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0012",$J,"PAT","C","NUM"))) D
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
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
D012(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,DEN1,DEN2,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P(NODE,U,2),DEN1=$P(DEN,";"),DEN2=$P(DEN,";",2)
 S NUM=$P(NODE,U,3)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?66,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,DEN1,?66,NUM
 W:DEN2'="" !,?53,DEN2
 Q
 ;
XML012 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_012"_U_""_U_+$G(^TMP("BGPMU0012",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0012",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0012",$J,"C","EXC"))
 K ^TMP("BGPMU0012",$J)
 Q
