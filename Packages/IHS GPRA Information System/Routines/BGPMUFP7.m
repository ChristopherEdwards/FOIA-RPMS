BGPMUFP7 ; IHS/MSC/MMT - Print MU EP measures NQF0068 ;20-JUL-2011 11:27;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Printed output reports for this measure
IVDMED ;EP
 D P1
 K ^TMP("BGPMU0068")
 Q
P1 ;Write individual measure
 N X,Y,Z,DEN,NUM,PC1,PC2,STRING1,STRING2,STRING3,PRD,PRN
 S STRING1=$$D68("C")
 S STRING2=$$D68("P")
 S STRING3=$$D68("B")
 S PRD=$P(STRING1,U,3)-$P(STRING2,U,3)
 S PRN=$P(STRING1,U,3)-$P(STRING3,U,3)
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5)
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Pts 18+ w/PTCA, AMI, CABG",?33,($P(STRING1,U,1)+$P(STRING1,U,4)),?44,($P(STRING2,U,1)+$P(STRING2,U,4)),?64,($P(STRING3,U,1)+$P(STRING3,U,4))
 W !,"or IVD"
 I $Y>(BGPIOSL-5) D HEADER^BGPMUPH Q:BGPQUIT
 W !!,"# w/oral antiplatelet",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,3),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,3),5,1),?56,$J($FN(PRD,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,3),5,1),?74,$J($FN(PRN,",+",1),6)
 W !,"therapy or aspirin"
 W !,"# w/o oral antiplatelet",?33,($P(STRING1,U,1)-$P(STRING1,U,2)),?38,$J($P(STRING1,U,5),5,1),?44,($P(STRING2,U,1)-$P(STRING2,U,2)),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD1,",+",1),6)
 W ?64,($P(STRING3,U,1)-$P(STRING3,U,2)),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRN1,",+",1),6)
 W !,"therapy or aspirin"
 I $D(BGPLIST(BGPIC)) D P2
 D SUM68
 K X,Y,Z,DEN,NUM,PC1,STRING1,STRING2,STRING3,PRD,PRN
 Q
D68(TF) ;Get the numbers for this measure
 N DATA
 S DEN=+$G(^TMP("BGPMU0068",$J,TF,"DEN"))
 S NUM1=+$G(^TMP("BGPMU0068",$J,TF,"NUM"))
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM1/DEN),3)*100,PC2=$$ROUND^BGPMUA01(((DEN-NUM1)/DEN),3)*100
 S DATA=DEN_U_NUM1_U_PC1_U_""_U_PC2
 Q DATA
P2 ;Do the Details
 N PT,NODE,NAME,VST,COLON,FOL,BGPARR,LINE,PTCT
 D HEADERL^BGPMUPH
 S X="Patients 18+ and (a) who had at least 1 acute inpatient encounter with the" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EP 14-24 months prior to the reporting period end date AND who underwent" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="percutaneous transluminal coronary angioplasty (PTCA), acute myocardial" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="infarction (AMI), or coronary artery bypass graft (CABG); OR (b) who had least" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="1 acute inpatient or outpatient encounter with the EP within 2 years of the" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="reporting period end date with a diagnosis of ischemic vascular disease (IVD);" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="AND (c) who were prescribed oral antiplatelet therapy or aspirin" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="during the reporting period, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:)," D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="followed by patients who do meet the numerator criteria (M:)." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="PTCA=PTCA Procedure" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="AMI=AMI Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="CABG=CABG Procedure" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="IVD=IVD Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=Oral Antiplatelet Therapy or Aspirin" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-8) D HEADERL^BGPMUPH Q:BGPQUIT
 S X="" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S PTCT=0
 W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?64,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0068"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0068"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 W !!,"Total # of patients on list: "_PTCT
 K PT,NODE,NAME,VST,COLON,FOL
 Q
DATA(NODE) ;DISPLAY DATA
 N X,NAME,HRN,DEN,DEN1,DEN2,NUM1,NUM2,NUM3,AGE,DFN,LINE,COMM,SEX
 N NUMVALS,NUMDATES
 S (DEN1,DEN2,NUM1,NUM2,NUM3)=""
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S SEX=$P(^DPT(DFN,0),U,2)
 S DEN=$P(NODE,U,2),NUM=$P(NODE,U,3)
 S DEN1=$P(DEN,";",1),DEN2=$P(DEN,";",2)
 S:NUM'="" NUM1="MED "_$$DATE^BGPMUUTL(NUM)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?64,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?30,COMM,?43,SEX,?46,AGE,?50,DEN1,?64,$S($G(NUM1)="":"NM:",1:"M:"_NUM1)
 W:(DEN2'="") !,?50,DEN2
 K X,NAME,HRN,DEN,DEN1,DEN2,NUM1,NUM2,NUM3,AGE,DFN,LINE,COMM,SEX
 K NUMVALS,NUMDATES
 Q
XML68 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=PQRI number^""^Denominator Count^Numerator Count^Exclusion Count
 ;NOTE: the first pieces below are INCORRECT but no PQRI number is defined for this measure
 S BGPXML(1)="204"_U_""_U_+$G(^TMP("BGPMU0068",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0068",$J,"C","NUM"))
 K ^TMP("BGPMU0068",$J)
 Q
SUM68 ;Populate "BGPMU SUMMARY" for IVD Antithrombotic
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J,N
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0068"_U_"204"
 S N=1 ;only 1 numerator
 ;Setup summary page/iCare ^TMP global
 S CDEN1CT=+$G(^TMP("BGPMU0068",$J,"C","DEN"))                 ;current
 S CNUM1CT=+$G(^TMP("BGPMU0068",$J,"C","NUM"))
 S CMP=$S(CDEN1CT>0:$$ROUND^BGPMUA01(CNUM1CT/CDEN1CT,3)*100,1:0)
 S PDEN1CT=+$G(^TMP("BGPMU0068",$J,"P","DEN"))                 ;previous
 S PNUM1CT=+$G(^TMP("BGPMU0068",$J,"P","NUM"))
 S PMP=$S(PDEN1CT>0:$$ROUND^BGPMUA01(PNUM1CT/PDEN1CT,3)*100,1:0)
 S BDEN1CT=+$G(^TMP("BGPMU0068",$J,"B","DEN"))                 ;baseline
 S BNUM1CT=+$G(^TMP("BGPMU0068",$J,"B","NUM"))
 S BMP=$S(BDEN1CT>0:$$ROUND^BGPMUA01(BNUM1CT/BDEN1CT,3)*100,1:0)
 ;FIRST NUMERATOR
 S BGPDNCNT=BGPDNCNT+1
 S BGPSSTR="MU.EP.0068.1"_U_"18+ # w/oral antiplatelet therapy"_U_""_U_CDEN1CT_U_CNUM1CT_U_CMP_U_U_U_U
 ; 11 12 13 14
 S BGPSSTR=BGPSSTR_U_""_U_PDEN1CT_U_PNUM1CT_U_PMP
 ; 15 16 17 18
 S BGPSSTR=BGPSSTR_U_""_U_BDEN1CT_U_BNUM1CT_U_BMP
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,BGPDNCNT)=BGPSSTR
 Q
