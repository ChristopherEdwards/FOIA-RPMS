BGPMUGP5 ; IHS/MSC/MMT - Print MU EP measures NQF0036 ;20-Aug-2011 11:27;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Printed output reports for this measure
ASTPHARM ;EP
 D P1
 K ^TMP("BGPMU0036")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,NUMPCT,PC2,EXC1,EXC2,STRING1,STRING2,STRING3,SUMCT
 N PRD1,PRD4,PRN1,PRN4
 K STRING1,STRING2,STRING3
 S SUMCT=0
 D NUM36("C",.STRING1)
 D NUM36("P",.STRING2)
 D NUM36("B",.STRING3)
 D SUMMARY1(.STRING1,.STRING2,.STRING3)
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 D P1SUB(1)
 D P1SUB(2)
 D P1SUB(3)
 I $D(BGPLIST(BGPIC)) D P2
 Q
P1SUB(POP) ;Population tabular output
 S PRD1=$P(STRING1(POP),U,5)-$P(STRING2(POP),U,5)
 S PRD4=$P(STRING1(POP),U,7)-$P(STRING2(POP),U,7)
 S PRN1=$P(STRING1(POP),U,5)-$P(STRING3(POP),U,5)
 S PRN4=$P(STRING1(POP),U,7)-$P(STRING3(POP),U,7)
 I $Y>(BGPIOSL-6) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !!,"Denominator ",POP
 W !!,$P($T(P1TEXT+POP),";;",2),?33,$P(STRING1(POP),U,1),?44,$P(STRING2(POP),U,1),?64,$P(STRING3(POP),U,1)
 W !,"indicative of asthma"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1(POP),U,4),?44,$P(STRING2(POP),U,4),?64,$P(STRING3(POP),U,4)
 I $Y>(BGPIOSL-4) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !,$P($T(P1TEXT+POP),";;",2),?33,$P(STRING1(POP),U,3),?44,$P(STRING2(POP),U,3),?64,$P(STRING3(POP),U,3)
 W !,"indicative of asthma less Exc"
 I $Y>(BGPIOSL-4) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !!,"# w/asthma medications",?33,$P(STRING1(POP),U,2),?38,$J($P(STRING1(POP),U,5),5,1),?44,$P(STRING2(POP),U,2)
 W ?49,$J($P(STRING2(POP),U,5),5,1),?56,$J($FN(PRD1,",+",1),6),?64,$P(STRING3(POP),U,2),?68,$J($P(STRING3(POP),U,5),5,1),?74,$J($FN(PRN1,",+",1),6)
 I $Y>(BGPIOSL-4) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !,"# w/o asthma medications",?33,$P(STRING1(POP),U,6),?38,$J($P(STRING1(POP),U,7),5,1),?44,$P(STRING2(POP),U,6)
 W ?49,$J($P(STRING2(POP),U,7),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3(POP),U,6),?68,$J($P(STRING3(POP),U,7),5,1),?74,$J($FN(PRN4,",+",1),6)
 Q
P1TEXT ;Text lines for output
 ;;Pts 5-11 w/asthma or meds
 ;;Pts 12-50 w/asthma or meds
 ;;Pts 5-50 w/asthma or meds
NUM36(TF,ARRAY) ;Get the numbers for this measure
 N STRING,DENTOT,NUM,EXC,NOT,NUMPCT,FINALDEN,NOTPCT,I
 F I=1:1:3 S ARRAY(I)=$$NUMSUB(I)
 Q
NUMSUB(POP) ;pull numbers out of temp global
 S DENTOT=+$G(^TMP("BGPMU0036",$J,TF,POP,"DEN"))
 S NUM=+$G(^TMP("BGPMU0036",$J,TF,POP,"NUM"))
 S NOT=+$G(^TMP("BGPMU0036",$J,TF,POP,"NOT"))
 S EXC=+$G(^TMP("BGPMU0036",$J,TF,POP,"EXC"))
 S FINALDEN=DENTOT-EXC
 I DENTOT=0 S (NUMPCT,NOTPCT)=0
 I DENTOT>0&(FINALDEN=0) D
 .S (NUMPCT,NOTPCT)=0
 I DENTOT>0&(FINALDEN>0) D
 .S NUMPCT=$$ROUND^BGPMUA01((NUM/FINALDEN),3)*100
 .S NOTPCT=$$ROUND^BGPMUA01((NOT/FINALDEN),3)*100
 S STRING=DENTOT_U_NUM_U_FINALDEN_U_EXC_U_NUMPCT_U_NOT_U_NOTPCT
 Q STRING
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT,BGPARR,LINE
 D HEADERL^BGPMUPH
 S X="Patients 5-50 years of age with one of the following during the reporting" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="period or within 1 year before the beginning of the reporting period: (a) at" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="least 1 ED or acute inpatient encounter with the EP and a diagnosis of asthma," D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="(b) at least 4 outpatient encounters with the EP AND a diagnosis of asthma AND"  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="at least 2 counts asthma medication prescribed by the EP, (c) at least 4 counts"  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="of asthma medication prescribed by the EP, or (d) at least 4 counts of "  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="leukotriebe inhibitors prescribed by the EP and a diagnosis of asthma, if any."  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who did not meet the numerator criteria are listed first (NM:)" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="followed by patients who do meet the numerator criteria (M:).  Excluded patients" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="are listed last."  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="AST=Asthma Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=Asthma Medication" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-5) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"Patients 5-11"
 W !!,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 D LISTSUB(1)
 W !!,"Patients 12-50"
 W !!,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 D LISTSUB(2)
 Q
LISTSUB(POP) ;write out patient list for given population
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0036"","_$J_",""PAT"",""C"","_POP_",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0036"","_$J_",""PAT"",""C"","_POP_",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="A" D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0036"","_$J_",""PAT"",""C"","_POP_",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 W !!,"Total # of patients on list: "_PTCT
 Q
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,NUM1,NUM2,DEN1,DEN2,DEN3,LINE,I,DENLEN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S DEN=$P(NODE,U,2)
 S DEN1=$P(DEN,";",1)
 S NUM=$P(NODE,U,3)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S SEX=$P(^DPT(DFN,0),U,2)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?30,COMM,?43,SEX,?46,AGE,?50,DEN1,?65,NUM
 S DENLEN=$L(DEN,";")
 I DENLEN>1 F I=2:1:DENLEN W !,?50,$P(DEN,";",I)
 Q
SUMMARY1(STRING1,STRING2,STRING3,CT) ;Summmary setup
 N DESC,LINE
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0036^"
 S DESC="5-11 # w/asthma medications"
 D SUMSUB(1,DESC)
 S DESC="12-50 # w/asthma medications"
 D SUMSUB(2,DESC)
 S DESC="5-50 # w/asthma medications"
 D SUMSUB(3,DESC)
 Q
SUMSUB(POP,DESC) ;create array entry for summary line
 S LINE=""
 S LINE="MU.EP.0036.1"_U_DESC_U_$P(STRING1(POP),U,4)_U_$P(STRING1(POP),U,1)_U_$P(STRING1(POP),U,2)_U_$P(STRING1(POP),U,5)_U_U_U_U_U
 S LINE=LINE_$P(STRING2(POP),U,4)_U_$P(STRING2(POP),U,1)_U_$P(STRING2(POP),U,2)_U_$P(STRING2(POP),U,5)_U_$P(STRING3(POP),U,4)_U_$P(STRING3(POP),U,1)_U_$P(STRING3(POP),U,2)_U_$P(STRING3(POP),U,5)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,POP)=LINE
 Q
XML36 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=PQRI number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF0036"_U_""_U_+$G(^TMP("BGPMU0036",$J,"C",3,"DEN"))_U_+$G(^TMP("BGPMU0036",$J,"C",3,"NUM"))_U_+$G(^TMP("BGPMU0036",$J,"C",3,"EXC"))
 K ^TMP("BGPMU0036",$J)
 Q
