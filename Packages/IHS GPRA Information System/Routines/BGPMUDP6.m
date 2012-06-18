BGPMUDP6 ; IHS/MSC/SAT - MU EP measures NQF0105 ;07-SEP-2011 11:26;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Printed output reports for this measure
PAD ;EP
 D P1
 K ^TMP("BGPMU0105")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,NUM2,PC1,PC2,STRING1,STRING2,STRING3,SUMCT
 N PRD1,PRD2,PRD3,PRD4,PRN1,PRN2,PRN3,PRN4,PRN5,PRN6,PRD5,PRD6
 S SUMCT=0
 S STRING1=$$NUM105("C")
 S STRING2=$$NUM105("P")
 S STRING3=$$NUM105("B")
 D SUMMARY1(STRING1,STRING2,STRING3)
 ;Population
 S PRD11=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRD14=$P(STRING1,U,9)-$P(STRING2,U,9)
 S PRN11=$P(STRING1,U,5)-$P(STRING3,U,5)
 S PRN14=$P(STRING1,U,9)-$P(STRING3,U,9)
 S PRD21=$P(STRING1,U,14)-$P(STRING2,U,14)
 S PRD24=$P(STRING1,U,18)-$P(STRING2,U,18)
 S PRN21=$P(STRING1,U,14)-$P(STRING3,U,14)
 S PRN24=$P(STRING1,U,18)-$P(STRING3,U,18)
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !,"Pts 18+ w/major depression",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 ;
 W !!,"Numerator 1"
 W !,"# w/antidepressant med",?33,+$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,+$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD11,",+",1),6),?64,+$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRN11,",+",1),6)
 W !,"=> 84 days after diagnosis"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !,"# w/o antidepressant med",?33,+$P(STRING1,U,8),?38,$J($P(STRING1,U,9),5,1),?44,+$P(STRING2,U,8),?49,$J($P(STRING2,U,9),5,1),?56,$J($FN(PRD14,",+",1),6),?64,+$P(STRING3,U,8),?68,$J($P(STRING3,U,9),5,1),?74,$J($FN(PRN14,",+",1),6)
 W !,"=> 84 days after diagnosis"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 ;
 W !!,"Numerator 2"
 W !,"# w/antidepressant med",?33,+$P(STRING1,U,11),?38,$J($P(STRING1,U,14),5,1),?44,+$P(STRING2,U,11),?49,$J($P(STRING2,U,14),5,1),?56,$J($FN(PRD21,",+",1),6),?64,+$P(STRING3,U,11),?68,$J($P(STRING3,U,14),5,1),?74,$J($FN(PRN21,",+",1),6)
 W !,"=> 180 days after diagnosis"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 W !,"# w/o antidepressant med",?33,+$P(STRING1,U,17),?38,$J($P(STRING1,U,18),5,1),?44,+$P(STRING2,U,17),?49,$J($P(STRING2,U,18),5,1),?56,$J($FN(PRD24,",+",1),6),?64,+$P(STRING3,U,17),?68,$J($P(STRING3,U,18),5,1),?74,$J($FN(PRN24,",+",1),6)
 W !,"=> 180 days after diagnosis"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH,HDRBLK^BGPMUPH Q:BGPQUIT
 ;
 I $D(BGPLIST(BGPIC)) D P2
 ;
 Q
 ;
NUM105(TF) ;Get the numbers for this measure
 N ARRAY,DEN,NUM,EXC,NOT,PC1,PC11,PC2,PC14,PC21,PC13,NNUM
 S DEN1=+$G(^TMP("BGPMU0105",$J,TF,"DEN",1))
 S NUM1=+$G(^TMP("BGPMU0105",$J,TF,"NUM",1))
 S NUM2=+$G(^TMP("BGPMU0105",$J,TF,"NUM",2))
 S NOT1=+$G(^TMP("BGPMU0105",$J,TF,"NOT",1))
 S NOT2=+$G(^TMP("BGPMU0105",$J,TF,"NOT",2))
 ;NUM1
 S NNUMD1=DEN1
 I DEN1=0 S (PC1D1,PC11D1,PC13D1,PC14D1)=0
 I DEN1>0&(NNUMD1=0) D
 .S (PC1D1,PC11D1,PC14D1)=0
 .S PC13D1=0
 I DEN1>0&(NNUMD1>0) D
 .S PC1D1=$$ROUND^BGPMUA01((NUM1/NNUMD1),3)*100
 .S PC11D1=$$ROUND^BGPMUA01((NNUMD1/DEN1),3)*100
 .S PC13D1=0  ;$$ROUND^BGPMUA01((EXC1/DEN1),3)*100
 .S PC14D1=$$ROUND^BGPMUA01((NOT1/NNUMD1),3)*100
 ;NUM2
 S NNUMD2=DEN1
 I DEN1=0 S (PC1D2,PC11D2,PC13D2,PC14D2)=0
 I DEN1>0&(NNUMD2=0) D
 .S (PC1D2,PC11D2,PC14D2)=0
 .S PC13D2=0   ;$$ROUND^BGPMUA01((EXC2/DEN2),3)*100
 I DEN1>0&(NNUMD2>0) D
 .S PC1D2=$$ROUND^BGPMUA01((NUM2/NNUMD2),3)*100
 .S PC11D2=$$ROUND^BGPMUA01((NNUMD2/DEN1),3)*100
 .S PC13D2=0  ;$$ROUND^BGPMUA01((EXC2/DEN2),3)*100
 .S PC14D2=$$ROUND^BGPMUA01((NOT2/NNUMD2),3)*100
 ;         1        2         3         4        5         6        7        8       9       10  11    12     13
 S ARRAY=(+DEN1)_U_+NUM1_U_(+NNUMD1)_U_0_U_(+PC1D1)_U_PC11D1_U_PC13D1_U_+NOT1_U_+PC14D1
 ;                 10       11       12         13       14       15       16        17      18
 S ARRAY=ARRAY_U_(+DEN1)_U_+NUM2_U_(+NNUMD2)_U_0_U_(+PC1D2)_U_PC11D2_U_PC13D2_U_+NOT2_U_+PC14D2
 ;                 19       20       21         22       23       24       25        26      27
 ;S ARRAY=ARRAY_U_(+DEN3)_U_+NUM3_U_(+NNUMD3)_U_+EXC3_U_(+PC1D3)_U_PC11D3_U_PC13D3_U_+NOT3_U_+PC14D3
 Q ARRAY
 ;
P2 ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,PTCT,BGPARR,LINE
 D HEADERL^BGPMUPH
 S X="Patients 18+ with a FIRST primary diagnosis of major depression during at least" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="1 ED, outpatient BH or outpatient BH req POS encounter with the EP between <=245" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="days before the reporting period start date and => 245 days before the reporting" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="period end date OR a secondary diagnosis of major depression during at least" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="2 ED, outpatient BH or outpatient BH req POS encounters with the EP during this" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="time period, OR a secondary diagnosis of major depression during an acute or" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="non-acute inpatient encounter with the EP during this time period, AND who were" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="prescribed antidepressant medication and who remained on antidepressant" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="medication, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:)." D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="DEP=Major Depression Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=Antidepressant Medication" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 S PTCT=0
 I $Y>(BGPIOSL-5) D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Numerator 1: Patients with antidepressant medication => 84 days after diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 W !!,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NOT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NUM"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 W !!,"Total # of patients on list: "_PTCT
 S X="" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 S PTCT=0
 I $Y>(BGPIOSL-5) D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Numerator 2: Patients with antidepressant medication => 180 days after diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 W !!,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NOT"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0105"","_$J_",""PAT"",""C"",""NUM"",2)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 W !!,"Total # of patients on list: "_PTCT
 Q
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM,LINE
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S SEX=$P(^DPT(DFN,0),U,2)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?65,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?30,COMM,?43,SEX,?46,AGE,?50,$P(DEN,";",1),?65,NUM
 F BGPI=2:1:$L(DEN,";") D
 .W !,?50,$P(DEN,";",BGPI)
 Q
SUMMARY1(STRING1,STRING2,STRING3,CT) ;Summmary setup
 N DESC,DESC2,LINE
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0105^9"
 S DESC1="# w/Rx => 84 days after Dx"
 S DESC2="# w/Rx => 180 days after Dx"
 S LINE=""
 ;
 S LINE="MU.EP.0105.1"_U_DESC1_U_+$P(STRING1,U,4)_U_+$P(STRING1,U,1)_U_+$P(STRING1,U,2)_U_+$P(STRING1,U,5)_U_U_U_U_U
 S LINE=LINE_+$P(STRING2,U,4)_U_+$P(STRING2,U,1)_U_+$P(STRING2,U,2)_U_+$P(STRING2,U,5)_U_+$P(STRING3,U,4)_U_+$P(STRING3,U,1)_U_+$P(STRING3,U,2)_U_+$P(STRING3,U,5)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,1)=LINE
 ;
 S LINE="MU.EP.0105.1"_U_DESC2_U_+$P(STRING1,U,13)_U_+$P(STRING1,U,10)_U_+$P(STRING1,U,11)_U_+$P(STRING1,U,14)_U_U_U_U_U
 S LINE=LINE_+$P(STRING2,U,13)_U_+$P(STRING2,U,10)_U_+$P(STRING2,U,11)_U_+$P(STRING2,U,14)_U_+$P(STRING3,U,13)_U_+$P(STRING3,U,10)_U_+$P(STRING3,U,11)_U_+$P(STRING3,U,14)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,2)=LINE
 ;
 Q
XML105 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=PQRI number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="9"_U_""_U_+$G(^TMP("BGPMU0105",$J,"C","DEN",1))_U_+$G(^TMP("BGPMU0105",$J,"C","NUM",1))_U
 S BGPXML(2)="9"_U_""_U_+$G(^TMP("BGPMU0105",$J,"C","DEN",2))_U_+$G(^TMP("BGPMU0105",$J,"C","NUM",2))_U
 K ^TMP("BGPMU0105",$J)
 Q
TEST ;
 S U="^"
 D PAD
 S BGPIC="A"
 S BGPLIST(BGPIC)=1
 Q
