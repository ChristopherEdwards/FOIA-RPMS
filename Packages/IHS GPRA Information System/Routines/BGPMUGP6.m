BGPMUGP6 ; IHS/MSC/MMT - Print MU EP measures NQF0004 ;20-Aug-2011 11:27;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Printed output reports for this measure
ALCDRUG ;EP
 D P1
 K ^TMP("BGPMU0004")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,DEN2,NUM2,NUMPCT,PC2,STRING1,STRING2,STRING3,SUMCT
 N PRD1,PRD4,PRN1,PRN4,POP
 K STRING1,STRING2,STRING3
 S SUMCT=0
 D NUM04("C",.STRING1)
 D NUM04("P",.STRING2)
 D NUM04("B",.STRING3)
 D SUMMARY1(.STRING1,.STRING2,.STRING3)
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 F POP=1:1:3 D
 .D P1SUBDEN(POP)
 .D P1SUBN1(POP)
 .D P1SUBN2(POP)
 I $D(BGPLIST(BGPIC)) D P2
 Q
P1SUBDEN(POP) ;display lines for denominator
 I $Y>(BGPIOSL-6) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !!,"Denominator "_POP_":"
 W !!,$P($T(P1TEXT+POP),";;",2),?33,$P(STRING1(POP),U,1),?44,$P(STRING2(POP),U,1),?64,$P(STRING3(POP),U,1)
 W !,"drug dependence"
 Q
P1SUBN1(POP) ;display numbers for NUM 1
 S PRD1=$P(STRING1(POP),U,5)-$P(STRING2(POP),U,5)
 S PRD4=$P(STRING1(POP),U,7)-$P(STRING2(POP),U,7)
 S PRN1=$P(STRING1(POP),U,5)-$P(STRING3(POP),U,5)
 S PRN4=$P(STRING1(POP),U,7)-$P(STRING3(POP),U,7)
 I $Y>(BGPIOSL-6) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !!,"Numerator 1"
 W !!,"# w/first treatment",?33,$P(STRING1(POP),U,2),?38,$J($P(STRING1(POP),U,5),5,1),?44,$P(STRING2(POP),U,2)
 W ?49,$J($P(STRING2(POP),U,5),5,1),?56,$J($FN(PRD1,",+",1),6),?64,$P(STRING3(POP),U,2),?68,$J($P(STRING3(POP),U,5),5,1),?74,$J($FN(PRN1,",+",1),6)
 W !,"# w/o first treatment",?33,$P(STRING1(POP),U,6),?38,$J($P(STRING1(POP),U,7),5,1),?44,$P(STRING2(POP),U,6)
 W ?49,$J($P(STRING2(POP),U,7),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3(POP),U,6),?68,$J($P(STRING3(POP),U,7),5,1),?74,$J($FN(PRN4,",+",1),6)
 Q
P1SUBN2(POP) ;display numbers for NUM 2
 S PRD1=$P(STRING1(POP),U,9)-$P(STRING2(POP),U,9)
 S PRD4=$P(STRING1(POP),U,11)-$P(STRING2(POP),U,11)
 S PRN1=$P(STRING1(POP),U,9)-$P(STRING3(POP),U,9)
 S PRN4=$P(STRING1(POP),U,11)-$P(STRING3(POP),U,11)
 I $Y>(BGPIOSL-8) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !!,"Numerator 2"
 W !!,"# w/2 treatments within",?33,$P(STRING1(POP),U,8),?38,$J($P(STRING1(POP),U,9),5,1),?44,$P(STRING2(POP),U,8)
 W ?49,$J($P(STRING2(POP),U,9),5,1),?56,$J($FN(PRD1,",+",1),6),?64,$P(STRING3(POP),U,8),?68,$J($P(STRING3(POP),U,9),5,1),?74,$J($FN(PRN1,",+",1),6)
 W !,"30 days"
 W !,"# w/o 2 treatments within",?33,$P(STRING1(POP),U,10),?38,$J($P(STRING1(POP),U,11),5,1),?44,$P(STRING2(POP),U,10)
 W ?49,$J($P(STRING2(POP),U,11),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3(POP),U,10),?68,$J($P(STRING3(POP),U,11),5,1),?74,$J($FN(PRN4,",+",1),6)
 W !,"30 days or no first treatment"
 Q
P1TEXT ;Text lines for output
 ;;Pts 13-17 w/alcohol or
 ;;Pts 18+ w/alcohol or
 ;;Pts 13+ w/alcohol or
NUM04(TF,ARRAY) ;Get the numbers for this measure
 N STRING,DENTOT,NUM1,NUM2,NOT1,NOT2,NUM1PCT,NOT1PCT,NUM2PCT,NOT2PCT,FINALDEN,I
 F I=1:1:3 S ARRAY(I)=$$NUMSUB(I)
 Q
NUMSUB(POP) ;pull numbers out of temp global
 S DENTOT=+$G(^TMP("BGPMU0004",$J,TF,POP,"DEN"))
 S NUM1=+$G(^TMP("BGPMU0004",$J,TF,POP,"NUM",1))
 S NOT1=+$G(^TMP("BGPMU0004",$J,TF,POP,"NOT",1))
 S NUM2=+$G(^TMP("BGPMU0004",$J,TF,POP,"NUM",2))
 S NOT2=+$G(^TMP("BGPMU0004",$J,TF,POP,"NOT",2))
 S FINALDEN=DENTOT
 I DENTOT=0 S (NUM1PCT,NOT1PCT,NUM2PCT,NOT2PCT)=0
 I DENTOT>0&(FINALDEN=0) D
 .S (NUM1PCT,NOT1PCT,NUM2PCT,NOT2PCT)=0
 I DENTOT>0&(FINALDEN>0) D
 .S NUM1PCT=$$ROUND^BGPMUA01((NUM1/FINALDEN),3)*100
 .S NOT1PCT=$$ROUND^BGPMUA01((NOT1/FINALDEN),3)*100
 .S NUM2PCT=$$ROUND^BGPMUA01((NUM2/FINALDEN),3)*100
 .S NOT2PCT=$$ROUND^BGPMUA01((NOT2/FINALDEN),3)*100
 ;           1      2         3       4    5         6       7        8       9        10     11
 S STRING=DENTOT_U_NUM1_U_FINALDEN_U_""_U_NUM1PCT_U_NOT1_U_NOT1PCT_U_NUM2_U_NUM2PCT_U_NOT2_U_NOT2PCT
 Q STRING
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT,BGPARR,LINE,I,J
 D HEADERL^BGPMUPH
 S X="Patients 13+ with a new episode of alcohol and other drug (AOD) dependence" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="who initiate treatment through an inpatient AOD admission, outpatient visit," D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="intensive outpatient encounter, or partial hospitalization within 14 days of" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="the diagnosis and who initiated treatment and who had two or more additional"  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="services with an AOD diagnosis within 30 days of the initiation visit, if any."  D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who did not meet the numerator criteria are listed first (NM:)" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="followed by patients who do meet the numerator criteria (M:)." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADX=Alcohol or Drug Dependence Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADI=Alcohol, Drug Rehab and Detox Intervention" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="DI=Detoxification Intervention" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="FT=First Treatment" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ST=Subsequent Treatment" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S LINE="",$P(LINE,"-",81)=""
 F I=1,2 D
 .I $Y>(BGPIOSL-11) D HEADERL^BGPMUPH Q:BGPQUIT
 .W !!,$P($T(LISTNUM+I),";;",2)
 .F J=1,2 D
 ..W !!,$P($T(LISTDEN+J),";;",2)
 ..W !!,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 ..W !,LINE
 ..D LISTSUB(J,I)
 Q
LISTSUB(POP,NUM) ;write out patient list for given population
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0004"","_$J_",""PAT"",""C"","_POP_",""NOT"","_NUM_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0004"","_$J_",""PAT"",""C"","_POP_",""NUM"","_NUM_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 W !!,"Total # of patients on list: "_PTCT
 Q
LISTDEN ;Denominator line text
 ;;Patients 13-17
 ;;Patients 18+
LISTNUM ;Numerator line text
 ;;Numerator 1: First Treatment
 ;;Numerator 2: Two subsequent treatments within 30 days
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,NUM1,DEN1,LINE,I,DENLEN,NUMLEN,MAXLEN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S DEN=$P(NODE,U,2)
 S DEN1=$P(DEN,";",1)
 S NUM=$P(NODE,U,3)
 S NUM1=$P(NUM,";",1)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S SEX=$P(^DPT(DFN,0),U,2)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?30,COMM,?43,SEX,?46,AGE,?50,DEN1,?65,NUM1
 S DENLEN=$L(DEN,";"),NUMLEN=$L(NUM,";")
 S MAXLEN=$S(DENLEN>NUMLEN:DENLEN,1:NUMLEN)
 I MAXLEN>1 F I=2:1:MAXLEN W !,?50,$P(DEN,";",I),?67,$P(NUM,";",I)
 Q
SUMMARY1(STRING1,STRING2,STRING3) ;Summmary setup
 N DESC,LINE
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0004^"
 S DESC="13-17 # w/first treatment"
 S LINE="MU.EP.0004.1"_U_DESC_U_$P(STRING1(1),U,4)_U_$P(STRING1(1),U,1)_U_$P(STRING1(1),U,2)_U_$P(STRING1(1),U,5)_U_U_U_U_U
 S LINE=LINE_$P(STRING2(1),U,4)_U_$P(STRING2(1),U,1)_U_$P(STRING2(1),U,2)_U_$P(STRING2(1),U,5)_U_$P(STRING3(1),U,4)_U_$P(STRING3(1),U,1)_U_$P(STRING3(1),U,2)_U_$P(STRING3(1),U,5)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,1)=LINE
 ;
 S DESC="13-17 # w/2 treatments w/i 30 days"
 S LINE="MU.EP.0004.1"_U_DESC_U_$P(STRING1(1),U,4)_U_$P(STRING1(1),U,1)_U_$P(STRING1(1),U,8)_U_$P(STRING1(1),U,9)_U_U_U_U_U
 S LINE=LINE_$P(STRING2(1),U,4)_U_$P(STRING2(1),U,1)_U_$P(STRING2(1),U,8)_U_$P(STRING2(1),U,9)_U_$P(STRING3(1),U,4)_U_$P(STRING3(1),U,1)_U_$P(STRING3(1),U,8)_U_$P(STRING3(1),U,9)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,2)=LINE
 ;
 S DESC="18+ # w/first treatment"
 S LINE="MU.EP.0004.1"_U_DESC_U_$P(STRING1(2),U,4)_U_$P(STRING1(2),U,1)_U_$P(STRING1(2),U,2)_U_$P(STRING1(2),U,5)_U_U_U_U_U
 S LINE=LINE_$P(STRING2(2),U,4)_U_$P(STRING2(2),U,1)_U_$P(STRING2(2),U,2)_U_$P(STRING2(2),U,5)_U_$P(STRING3(2),U,4)_U_$P(STRING3(2),U,1)_U_$P(STRING3(2),U,2)_U_$P(STRING3(2),U,5)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,3)=LINE
 ;
 S DESC="18+ # w/2 treatments w/i 30 days"
 S LINE="MU.EP.0004.1"_U_DESC_U_$P(STRING1(2),U,4)_U_$P(STRING1(2),U,1)_U_$P(STRING1(2),U,8)_U_$P(STRING1(2),U,9)_U_U_U_U_U
 S LINE=LINE_$P(STRING2(2),U,4)_U_$P(STRING2(2),U,1)_U_$P(STRING2(2),U,8)_U_$P(STRING2(2),U,9)_U_$P(STRING3(2),U,4)_U_$P(STRING3(2),U,1)_U_$P(STRING3(2),U,8)_U_$P(STRING3(2),U,9)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,4)=LINE
 ;
 S DESC="13+ # w/first treatment"
 S LINE="MU.EP.0004.1"_U_DESC_U_$P(STRING1(3),U,4)_U_$P(STRING1(3),U,1)_U_$P(STRING1(3),U,2)_U_$P(STRING1(3),U,5)_U_U_U_U_U
 S LINE=LINE_$P(STRING2(3),U,4)_U_$P(STRING2(3),U,1)_U_$P(STRING2(3),U,2)_U_$P(STRING2(3),U,5)_U_$P(STRING3(3),U,4)_U_$P(STRING3(3),U,1)_U_$P(STRING3(3),U,2)_U_$P(STRING3(3),U,5)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,5)=LINE
 ;
 S DESC="13+ # w/2 treatments w/i 30 days"
 S LINE="MU.EP.0004.1"_U_DESC_U_$P(STRING1(3),U,4)_U_$P(STRING1(3),U,1)_U_$P(STRING1(3),U,8)_U_$P(STRING1(3),U,9)_U_U_U_U_U
 S LINE=LINE_$P(STRING2(3),U,4)_U_$P(STRING2(3),U,1)_U_$P(STRING2(3),U,8)_U_$P(STRING2(3),U,9)_U_$P(STRING3(3),U,4)_U_$P(STRING3(3),U,1)_U_$P(STRING3(3),U,8)_U_$P(STRING3(3),U,9)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,6)=LINE
 Q
XML04 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=PQRI number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF0004.1"_U_""_U_+$G(^TMP("BGPMU0004",$J,"C",3,"DEN"))_U_+$G(^TMP("BGPMU0004",$J,"C",3,"NUM",1))
 S BGPXML(2)="NQF0004.2"_U_""_U_+$G(^TMP("BGPMU0004",$J,"C",3,"DEN"))_U_+$G(^TMP("BGPMU0004",$J,"C",3,"NUM",2))
 K ^TMP("BGPMU0004",$J)
 Q
