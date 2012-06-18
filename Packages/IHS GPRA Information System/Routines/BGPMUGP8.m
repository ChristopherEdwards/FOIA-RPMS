BGPMUGP8 ; IHS/MSC/MMT - Print MU EP measures NQF0088 ;20-JUL-2011 11:27;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Printed output reports for this measure
EDEMA ;EP
 D P1
 K ^TMP("BGPMU0088")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,PC1,PC2,EXC1,EXC2,STRING1,STRING2,STRING3,SUMCT
 N PRD1,PRD2,PRD3,PRD4,PRN1,PRN2,PRN3,PRN4,PRN5,PRN6,PRD5,PRD6
 S SUMCT=0
 S STRING1=$$NUM88("C")
 S STRING2=$$NUM88("P")
 S STRING3=$$NUM88("B")
 D SUMMARY1(STRING1,STRING2,STRING3)
 ;Population
 S PRD1=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRD2=$P(STRING1,U,6)-$P(STRING2,U,6)
 S PRD3=$P(STRING1,U,7)-$P(STRING2,U,7)
 S PRD4=$P(STRING1,U,9)-$P(STRING2,U,9)
 S PRN1=$P(STRING1,U,5)-$P(STRING3,U,5)
 S PRN2=$P(STRING1,U,6)-$P(STRING3,U,6)
 S PRN3=$P(STRING1,U,7)-$P(STRING3,U,7)
 S PRN4=$P(STRING1,U,9)-$P(STRING3,U,9)
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 I $Y>(BGPIOSL-7) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !,"Pts 18+ w/diabetic",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 W !,"retinopathy"
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?64,$P(STRING3,U,4)
 W !,"Pts 18+ w/diabetic",?33,$P(STRING1,U,3),?44,$P(STRING2,U,3),?64,$P(STRING3,U,3)
 W !,"retinopathy less Exc"
 I $Y>(BGPIOSL-5) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !!,"# w/macular or fundus exam",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD1,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRN1,",+",1),6)
 W !,"w/macular edema and severity"
 W !,"of retinopathy findings"
 I $Y>(BGPIOSL-6) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !!,"# w/o macular or fundus exam",?33,$P(STRING1,U,8),?38,$J($P(STRING1,U,9),5,1),?44,$P(STRING2,U,8),?49,$J($P(STRING2,U,9),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3,U,8),?68,$J($P(STRING3,U,9),5,1),?74,$J($FN(PRN4,",+",1),6)
 W !,"or w/exam but no macular edema"
 W !,"and/or no severity of"
 W !,"retinopathy findings"
 I $D(BGPLIST(BGPIC)) D P2
 ;
 Q
NUM88(TF) ;Get the numbers for this measure
 N ARRAY,DEN,NUM,EXC,NOT,PC1,PC11,PC2,PC13,NNUM,PC14
 S DEN=+$G(^TMP("BGPMU0088",$J,TF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0088",$J,TF,"NUM"))
 S NOT=+$G(^TMP("BGPMU0088",$J,TF,"NOT"))
 S EXC=+$G(^TMP("BGPMU0088",$J,TF,"EXC"))
 S NNUM=DEN-EXC
 I DEN=0 S (PC1,PC11,PC13,PC14)=0
 I DEN>0&(NNUM=0) D
 .S (PC1,PC11,PC14)=0
 .S PC13=$$ROUND^BGPMUA01((EXC/DEN),3)*100
 I DEN>0&(NNUM>0) D
 .S PC1=$$ROUND^BGPMUA01((NUM/NNUM),3)*100
 .S PC11=$$ROUND^BGPMUA01((NNUM/DEN),3)*100
 .S PC13=$$ROUND^BGPMUA01((EXC/DEN),3)*100
 .S PC14=$$ROUND^BGPMUA01((NOT/NNUM),3)*100
 S ARRAY=DEN_U_NUM_U_NNUM_U_EXC_U_PC1_U_PC11_U_PC13_U_NOT_U_PC14
 Q ARRAY
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT,BGPARR,LINE
 S PTCT=0
 D HEADERL^BGPMUPH
 S X="Patients 18+ who had at least 2 office & outpatient consultation," D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ophthalmological services, nursing facility, or domiciliary encounters with" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="the EP during the reporting period AND a diagnosis of diabetic retinopathy" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="AND who had a macular or fundus exam performed which included documentation of" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="the level of severity of retinopathy and the presence or absence of macular" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="edema during 1 or more the encounters with the EP during the reporting" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="period, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who did not meet the numerator criteria are listed first (NM:)" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="followed by patients who do meet the numerator criteria (M:).  Excluded patients" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="are listed last."  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="RET=Diabetic Retinopathy Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EXAM=Macular or Fundus Exam" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ME=Macular Edema Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="LOS=Diabetic Retinopathy Level of Severity" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X=""  D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-5) D HEADERL^BGPMUPH Q:BGPQUIT
 W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0088"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0088"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="A" D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0088"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 W !!,"Total # of patients on list: "_PTCT
 Q
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,NUM1,NUM2,NUM3,DEN1,DEN2,DEN3,LINE
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S DEN=$P(NODE,U,2)
 S DEN1=$P(DEN,";",1),DEN2=$P(DEN,";",2),DEN3=$P(DEN,";",3)
 S NUM=$P(NODE,U,3)
 S NUM1=$P(NUM,";",1),NUM2=$P(NUM,";",2),NUM3=$P(NUM,";",3)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S SEX=$P(^DPT(DFN,0),U,2)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?30,COMM,?43,SEX,?46,AGE,?50,DEN1,?65,NUM1
 I DEN2'=""!(NUM2'="") D
 .W !,?50,DEN2,?65,NUM2
 I DEN3'=""!(NUM3'="") D
 .W !,?50,DEN3,?65,NUM3
 Q
SUMMARY1(STRING1,STRING2,STRING3) ;Summmary setup
 N DESC,DESC2,LINE
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0088^18"
 S DESC="18+ w/macular or fundus exam"
 S LINE=""
 S LINE="MU.EP.0088.1"_U_DESC_U_$P(STRING1,U,4)_U_$P(STRING1,U,1)_U_$P(STRING1,U,2)_U_$P(STRING1,U,5)_U_U_U_U_U
 S LINE=LINE_$P(STRING2,U,4)_U_$P(STRING2,U,1)_U_$P(STRING2,U,2)_U_$P(STRING2,U,5)_U_$P(STRING3,U,4)_U_$P(STRING3,U,1)_U_$P(STRING3,U,2)_U_$P(STRING3,U,5)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,1)=LINE
 Q
XML88 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=PQRI number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="18"_U_""_U_+$G(^TMP("BGPMU0088",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0088",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0088",$J,"C","EXC"))
 K ^TMP("BGPMU0088",$J)
 Q
