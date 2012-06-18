BGPMUDP4 ; IHS/MSC/SAT - MU EH  measure output routines;12-JUL-2011 16:30;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
 ;This routine does the printed output of 0014 Prenatal Anti-D Immune Globulin (BGPMUD05)
P27ENT ;EP  output routine for 0027 Prenatal Anti-D Immune Globulin
 D P27
 K ^TMP("BGPMU0027")
 Q
P27 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN,NUM1,EXC1,PC1,PC11,PC13,NONUM,STRING1,STRING2,STRING3,PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,X
 S STRING1=$$027("C")
 S STRING2=$$027("P")
 S STRING3=$$027("B")
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
 D HEADER^BGPMUPH Q:BGPQUIT
 ;W !
 D HDRBLK^BGPMUPH
 W !!,"Pts 18+",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !
 W !,"Numerator 1"
 W !,"# w/tobacco use",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD12,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD13,",+",1),6)
 W !,"# w/o tobacco use",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD14,",+",1),6),?64,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD15,",+",1),6)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !
 W !,"Numerator 2"
 W !,"# w/tobacco use and",?33,$P(STRING1,U,8),?38,$J($P(STRING1,U,11),5,1),?44,$P(STRING2,U,8),?49,$J($P(STRING2,U,11),5,1),?56,$J($FN(PRD22,",+",1),6),?64,$P(STRING3,U,8),?68,$J($P(STRING3,U,11),5,1),?74,$J($FN(PRD23,",+",1),6)
 W !,"cessation counseling"
 W !,"# w/o tobacco use or",?33,$P(STRING1,U,9),?38,$J($P(STRING1,U,12),5,1),?44,$P(STRING2,U,9),?49,$J($P(STRING2,U,12),5,1),?56,$J($FN(PRD24,",+",1),6),?64,$P(STRING3,U,9),?68,$J($P(STRING3,U,12),5,1),?74,$J($FN(PRD25,",+",1),6)
 W !,"w/tobacco use and no"
 W !,"cessation counseling"
 I $D(BGPLIST(BGPIC)) D P27D
 D SUM027^BGPMUDD4
 Q
027(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0027",$J,BGPMUTF,"DEN",1))
 S NUM1=+$G(^TMP("BGPMU0027",$J,BGPMUTF,"NUM",1))
 S NONUM1=+$G(^TMP("BGPMU0027",$J,BGPMUTF,"NOT",1))
 S NUM2=+$G(^TMP("BGPMU0027",$J,BGPMUTF,"NUM",2))
 S NONUM2=+$G(^TMP("BGPMU0027",$J,BGPMUTF,"NOT",2))
 I DEN=0 S (PC1,PC11)=0,(PC2,PC21)=0
 I DEN>0 D
 .I DEN=0 S (PC1,PC11)=0,(PC2,PC21)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM1/DEN),3)*100
 ..S PC11=$$ROUND^BGPMUA01((NONUM1/DEN),3)*100
 ..S PC2=$$ROUND^BGPMUA01((NUM2/DEN),3)*100
 ..S PC21=$$ROUND^BGPMUA01((NONUM2/DEN),3)*100
 ;        1     2       3      4     5     6     7    8       9       10  11    12     13
 S ARRAY=DEN_U_NUM1_U_NONUM1_U_""_U_PC1_U_PC11_U_0_U_NUM2_U_NONUM2_U_""_U_PC2_U_PC21_U_0
 Q ARRAY
P27D ;Do the Details
 N PT,PTCNT,NODE,NAME,VST,BMI,FOL,X
 N BGPARR
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Patients 18 years of age and older with at least 1 encounter with the EP within" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="2 years of the reporting period end date, who have been identified as tobacco" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="users within 1 year before or during the reporting period and who received" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="advice to quit smoking or tobacco use or whose EP recommended or discussed" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="smoking or tobacco use cessation medications, methods or strategies within" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="1 year of the reporting period end date, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:)." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="HF=Tobacco User Health Factor" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"Numerator 1: Tobacco users"
 W !!,"PATIENT NAME",?23,"HRN",?31,"COMMUNITY",?41,"SEX",?45,"AGE",?50,"DENOMINATOR",?63,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
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
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 W !!,"Numerator 2: Tobacco users who received tobacco use cessation counseling"
 W !!,"PATIENT NAME",?23,"HRN",?31,"COMMUNITY",?41,"SEX",?45,"AGE",?50,"DENOMINATOR",?63,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
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
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
D027(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,21)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?31,"COMMUNITY",?41,"SEX",?45,"AGE",?50,"DENOMINATOR",?63,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?31,COMM,?41,SEX,?45,AGE,?50,$P(DEN,";",1),?63,$P(NUM,";",1)
 I ($P(DEN,";",2)'="")!($P(NUM,";",2)'="") W !,?50,$S($P(DEN,";",2)'="":$P(DEN,";",2),1:""),?63,$S($P(NUM,";",2)'="":$P(NUM,";",2),1:"")
 I ($P(DEN,";",3)'="")!($P(NUM,";",3)'="") W !,?50,$S($P(DEN,";",3)'="":$P(DEN,";",3),1:""),?63,$S($P(NUM,";",3)'="":$P(NUM,";",3),1:"")
 Q
 ;
XML027 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="115"_U_""_U_+$G(^TMP("BGPMU0027",$J,"C","DEN",1))_U_+$G(^TMP("BGPMU0027",$J,"C","NUM",1))
 S BGPXML(2)="115"_U_""_U_+$G(^TMP("BGPMU0027",$J,"C","DEN",1))_U_+$G(^TMP("BGPMU0027",$J,"C","NUM",2))
 K ^TMP("BGPMU0027",$J)
 Q
 ;
 ;*********************
 ;
