BGPMUDP3 ; IHS/MSC/SAT - MU EH  measure output routines;14-JUN-2011 16:30;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
 ;This routine does the printed output of 0014 Prenatal Anti-D Immune Globulin (BGPMUD05)
P14ENT ;EP  output routine for 0014 Prenatal Anti-D Immune Globulin
 D P14
 K ^TMP("BGPMU0014")
 Q
P14 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,EXC1,PC1,PC11,PC13,NONUM,STRING1,STRING2,STRING3,PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,X
 S STRING1=$$014("C")
 S STRING2=$$014("P")
 S STRING3=$$014("B")
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year (line 1)
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 D HEADER^BGPMUPH Q:BGPQUIT
 W !
 D HDRBLK^BGPMUPH
 W !,"Pts D (Rh) neg, unsensitized",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 W !,"w/live birth and prenatal"
 W !,"encounter"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?64,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Pts D (Rh) neg, unsensitized",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?64,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"w/live birth and prenatal"
 W !,"encounter less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/anti-D immune globulin",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"26-30 weeks gestation"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o anti-D immune globulin",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"26-30 weeks gestation"
 I $D(BGPLIST(BGPIC)) D P14D
 D SUM014^BGPMUDD3
 Q
014(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN1=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"DEN"))
 S NUM1=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"NUM"))
 S NONUM=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"NOT"))
 S EXC1=+$G(^TMP("BGPMU0014",$J,BGPMUTF,"EXC"))
 I DEN1=0 S (PC1,PC11,PC13)=0
 I DEN1>0 D
 .I DEN1-EXC1=0 S (PC1,PC11,PC13)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM1/(DEN1-EXC1)),3)*100
 ..S PC11=$$ROUND^BGPMUA01((NONUM/(DEN1-EXC1)),3)*100
 .S PC13=$$ROUND^BGPMUA01((EXC1/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_EXC1_U_PC1_U_PC11_U_PC13_U_""
 Q ARRAY
P14D ;Do the Details
 N PT,PTCNT,NODE,NAME,VST,BMI,FOL,X
 N BGPARR
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="D (Rh) negative, unsensitized patients, regardless of age, who gave birth" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="during the reporting period who received anti-D immune globulin at" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="26-30 weeks gestation." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="DEL=Live birth delivery" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=Prenatal encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=Anti-D immune globulin administered between 26 and 30 weeks gestation" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?52,"DENOMINATOR",?65,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0014",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0014"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D014(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0014",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0014"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D014(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0014",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0014"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D014(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
D014(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN,DEN1,DEN2
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
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?52,"DENOMINATOR",?65,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?52,DEN1,?65,NUM
 W:DEN2'="" !,?52,DEN2
 Q
XML014 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_014"_U_""_U_+$G(^TMP("BGPMU0014",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0014",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0014",$J,"C","EXC"))
 K ^TMP("BGPMU0018",$J)
 Q
 ;*********************
 ;
 ;This routine does the printed output of 0018 Control High Blood Pressure (BGPMUD06)
P18ENT ;EP  output routine for 0018 Prenatal Anti-D Immune Globulin
 D P18
 K ^TMP("BGPMU0018")
 Q
P18 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,EXC1,PC1,PC11,PC13,NONUM,STRING1,STRING2,STRING3,PRD1,PRD2,PRD3,PRD4,PRD5,PRD6,X
 S STRING1=$$018("C")
 S STRING2=$$018("P")
 S STRING3=$$018("B")
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year (line 1)
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year
 D HEADER^BGPMUPH Q:BGPQUIT
 W !
 D HDRBLK^BGPMUPH
 W !,"Pts 18-85 w/HTN",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 ;W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 ;I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 ;W !,"Pts 18-85 w/HTN Less Exc",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?65,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !
 ;I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/lowest BP < 140/90",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o BP or lowest BP",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?64,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"=> 140/90"
 I $D(BGPLIST(BGPIC)) D P18D
 D SUM018^BGPMUDD3
 Q
018(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN1=+$G(^TMP("BGPMU0018",$J,BGPMUTF,"DEN",1))
 S NUM1=+$G(^TMP("BGPMU0018",$J,BGPMUTF,"NUM",1))
 S NONUM=+$G(^TMP("BGPMU0018",$J,BGPMUTF,"NOT",1))
 S EXC1=+$G(^TMP("BGPMU0018",$J,BGPMUTF,"EXC",1))
 I DEN1=0 S (PC1,PC11,PC13)=0
 I DEN1>0 D
 .I DEN1-EXC1=0 S (PC1,PC11,PC13)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM1/(DEN1-EXC1)),3)*100
 ..S PC11=$$ROUND^BGPMUA01((NONUM/(DEN1-EXC1)),3)*100
 .S PC13=$$ROUND^BGPMUA01((EXC1/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_EXC1_U_PC1_U_PC11_U_PC13_U_""
 Q ARRAY
P18D ;Do the Details
 N PT,PTCNT,NODE,NAME,VST,BMI,FOL,X
 N BGPARR
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Hypertensive patients 18-85 years of age with at least 1 encounter with the EP" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="during the reporting period and whose lowest systolic BP reading was < 140 mmHg" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="and lowest diastolic BP reading was < 90 mmHg during the most recent encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="with the EP during the reporting period, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:)." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ICD=Hypertension Diagnosis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="EN=ENCOUNTER" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 ;W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?67,"NUMERATOR"
 W !!,"PATIENT NAME",?23,"HRN",?31,"COMMUNITY",?41,"SEX",?45,"AGE",?49,"DENOMINATOR",?62,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0018",$J,"PAT","C","NOT",1)) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0018"","_$J_",""PAT"",""C"",""NOT"","_1_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D018(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0018",$J,"PAT","C","NUM",1))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0018"","_$J_",""PAT"",""C"",""NUM"","_1_")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D018(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
D018(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P(NODE,U,2),";",1,2)
 S NUM=$P($P(NODE,U,2),";",3)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?31,"COMMUNITY",?41,"SEX",?45,"AGE",?49,"DENOMINATOR",?62,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?31,COMM,?41,SEX,?45,AGE,?49,$P(DEN,";",1),?62,$P(NUM,"*",1)
 W !,?49,$P(DEN,";",2),?62,$S($P(NUM,"*",2)'="":$P(NUM,"*",2),1:"")
 F BGPI=3:1:$L(NUM,"*") W !,?62,$P(NUM,"*",BGPI)
 Q
 ;
XML018 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_018"_U_""_U_+$G(^TMP("BGPMU0018",$J,"C","DEN",1))_U_+$G(^TMP("BGPMU0018",$J,"C","NUM",1))_U_+$G(^TMP("BGPMU0018",$J,"C","EXC",1))
 K ^TMP("BGPMU0018",$J)
 Q
