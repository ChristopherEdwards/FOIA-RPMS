BGPMUHP3 ; IHS/MSC/SAT - MU EH  measure output routines;02-Mar-2011 16:30;DU
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 ; ED1^BGPMUHP1 = output routine for 0495 ED-1;;;;;Build 33
 ; ED2^BGPMUHP1 = output routine for 0497 ED-2
 ;
 ; STK2^BGPMUHP2   = output routine for 0435 STK-2 Antithrombolytic Therapy at discharge
 ; STK3^BGPMUHP2   = output routine for 0436 STK-3 Anticoagulation Therapy at discharge
 ; STK4^BGPMUHP3   = output routine for 0437 STK-4 thrombolytic therapy within 3 hours
 ; STK5^BGPMUHP3   = output routine for 0438 STK-5 Antithrombolytic Therapy by end of day 2
 ; STK6^BGPMUHP4   = output routine for 0439 STK-6 Statin Medicine at Discharge
 ; STK8^BGPMUHP4   = output routine for 0440 STK-8 Educational Materials at discharge
 ; STK10^BGPMUHP5   = output routine for 0441 STK-10 Rehabilitation Service at discharge
 ;
 ; VTE1^BGPMUHP6 = output routine for 0371 VTE-1 Prophylaxis within 24 hours
 ; VTE2^BGPMUHP6 = output routine for 0372 VTE-2 Prophylaxis for ICU pts
 ; VTE3^BGPMUHP7 = output routine for 0373 VTE-3 Anticoagulation overlap therapy
 ; VTE4^BGPMUHP7 = output routine for 0374 VTE-4 Platelet monitoring for UFH
 ; VTE5^BGPMUHP8 = output routine for 0375 VTE-5 VTE discharge instructions
 ; VTE6^BGPMUHP8 = output routine for 0376 VTE-6 Potentially preventable VTE
 ;
STK4 ;EP  output routine for 0437 STK-4 (BGPMUH05)
 D P4
 K ^TMP("BGPMU0437")
 Q
P4 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,PC1,PC11,PC13,EXC1,NONUM,STRING1,STRING2,STRING3,PRD1,PRD2,PRD3,PRD4,PRD5,PRB1,PRB2
 S STRING1=$$437("C")
 S STRING2=$$437("P")
 S STRING3=$$437("B")
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)
 I $P(STRING3,U,1)'=0 S PRD6=$$ROUND^BGPMUA01(($P(STRING1,U,1)/$P(STRING3,U,1)),3)*100
 E  S PRD6=0
 D HEADER^BGPMUPH Q:BGPQUIT
 W !
 D HDRBLK^BGPMUPH
 W !,"# Discharges for Pts",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?65,$P(STRING3,U,1)
 W !,"w/ischemic stroke"
 W !,"w/arrival time within"
 W !,"2 hrs of last time"
 W !,"known well"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Discharges for Pts",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?65,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"w/ischemic stroke"
 W !,"w/arrival time within"
 W !,"2 hrs of last time"
 W !,"known well Less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/IV thrombolytic",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"therapy within 3 hours"
 W !,"of last time"
 W !,"known well"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o IV thrombolytic",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"therapy within 3 hours"
 W !,"of last time"
 W !,"known well"
 I $D(BGPLIST(BGPIC)) D P4D
 D SUM437^BGPMUHD2
 Q
437(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN1=+$G(^TMP("BGPMU0437",$J,BGPMUTF,"DEN"))
 S NUM1=+$G(^TMP("BGPMU0437",$J,BGPMUTF,"NUM"))
 S NONUM=+$G(^TMP("BGPMU0437",$J,BGPMUTF,"NOT"))
 S EXC1=+$G(^TMP("BGPMU0437",$J,BGPMUTF,"EXC"))
 I DEN1=0 S (PC1,PC11,PC13)=0
 I DEN1>0 D
 .I DEN1-EXC1=0 S (PC1,PC11,PC13)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM1/(DEN1-EXC1)),3)*100
 ..S PC11=$$ROUND^BGPMUA01((NONUM/(DEN1-EXC1)),3)*100
 .S PC13=$$ROUND^BGPMUA01((EXC1/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_EXC1_U_PC1_U_PC11_U_PC13_U_""
 Q ARRAY
P4D ;Do the Details
 N PT,NODE,NAME,PTCT,VST,BMI,FOL,X
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Acute ischemic stroke patients who arrive at this hospital within 2 hours of "
 S X=X_"time last known well and for whom IV t-PA was initiated at this hospital "
 S X=X_"within 3 hours of time last known well, if any."
 D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed by patients who do meet the numerator criteria (M:). Excluded patients are listed last." D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator columns:" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="ISC=Inpatient w/diagnosis of ischemic stroke whose time of arrival is within 2 hrs of last known well time" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0437",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0437"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D437(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0437",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0437"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D437(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0437",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0437"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC437(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
D438(NODE) ;GET DATA
 D D437(NODE)
 Q
D437(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P($P(NODE,U,2),";",1),":",1)
 S NUM=$P(NODE,U,3)
 I $Y>(BGPIOSL-2) D
 .D HEADER^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"ISC "_$$FMTE^XLFDT(DEN,2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),?69,$S(NUM'="":"M:"_$$FMTE^XLFDT($P(NUM,".",1),2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),1:"NM:")
 F BGPI=2:1:$L($P(NODE,U,2),";") D
 .I $Y>(BGPIOSL-2) D
 ..D HEADER^BGPMUPH Q:BGPQUIT
 ..W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 ..S LINE="",$P(LINE,"-",79)="" W !,LINE
 .S DATA=$P($P(NODE,U,2),";",BGPI)
 .W !,?53,"ISC "_$$FMTE^XLFDT($P(DATA,":",1),2)_$S($L($P(NODE,"U",2),";")>BGPI:";",1:""),?69,$S($P(DATA,":",2)'="":"M:"_$$FMTE^XLFDT($P($P(DATA,":",2),".",1),2)_$S($L($P(NODE,"U",2),";")>BGPI:";",1:""),1:"NM:")
 Q
DEXC438(NODE) ;GET DATA
 D DEXC437(NODE)
 Q
DEXC437(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P($P(NODE,U,2),";",1),":",1)
 S NUM=$P(NODE,U,3)
 I $Y>(BGPIOSL-2) D
 .D HEADER^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"Excluded"
 Q
 ;
 ;This routine does the printed output of 0438 STK-5 (BGPMUH06)
STK5 ;EP  output routine for 0438 STK-5
 D P5
 K ^TMP("BGPMU0438")
 Q
P5 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,PC1,PC11,PC13,NONUM,EXC1,STRING1,STRING2,STRING3,PRD1,PRD2,PRD3,PRD4,PRD5,X
 S STRING1=$$438("C")
 S STRING2=$$438("P")
 S STRING3=$$438("B")
 S PRD1=$P(STRING1,U,1)-$P(STRING2,U,1)  ;change from prev year Pts w/ Ischemic Stroke (line 1)
 S PRD2=$P(STRING1,U,5)-$P(STRING2,U,5)  ;% change from prev year # w/ antithrombolytic therapy ...
 S PRD3=$P(STRING1,U,5)-$P(STRING3,U,5)  ;% change from base year # w/ antithrombolytic therapy ...
 S PRD4=$P(STRING1,U,6)-$P(STRING2,U,6)  ;% change from prev year # w/ antithrombolytic therapy ...
 S PRD5=$P(STRING1,U,6)-$P(STRING3,U,6)  ;% change from prev year # w/ antithrombolytic therapy ...
 I $P(STRING3,U,1)'=0 S PRD6=$$ROUND^BGPMUA01(($P(STRING1,U,1)/$P(STRING3,U,1)),3)*100
 E  S PRD6=0
 D HEADER^BGPMUPH Q:BGPQUIT
 W !
 D HDRBLK^BGPMUPH
 W !,"# Discharges for Pts",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?65,$P(STRING3,U,1)
 W !,"w/ischemic stroke"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Discharges for Pts",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?65,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"w/ischemic stroke Less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/antithrombolytic",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"therapy by end day 2"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o antithrombolytic",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"therapy by end day 2"
 I $D(BGPLIST(BGPIC)) D P5D
 D SUM438^BGPMUHD2
 Q
438(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN1=+$G(^TMP("BGPMU0438",$J,BGPMUTF,"DEN"))
 S NUM1=+$G(^TMP("BGPMU0438",$J,BGPMUTF,"NUM"))
 S NONUM=+$G(^TMP("BGPMU0438",$J,BGPMUTF,"NOT"))
 S EXC1=+$G(^TMP("BGPMU0438",$J,BGPMUTF,"EXC"))
 I DEN1=0 S (PC1,PC11,PC13)=0
 I DEN1>0 D
 .I DEN1-EXC1=0 S (PC1,PC11,PC13)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM1/(DEN1-EXC1)),3)*100
 ..S PC11=$$ROUND^BGPMUA01((NONUM/(DEN1-EXC1)),3)*100
 .S PC13=$$ROUND^BGPMUA01((EXC1/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_EXC1_U_PC1_U_PC11_U_PC13_U_""
 Q ARRAY
P5D ;Do the Details
 N PT,NODE,NAME,PTCT,VST,BMI,FOL,X
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Ischemic stroke patients administered antithrombolytic therapy by the end of" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="hospital day 2, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ISC=Inpatient w/diagnosis of ischemic stroke" D W^BGPMUPP(X,0,2,BGPPTYPE)
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0438",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0438"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D438(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0438",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0438"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D438(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0438",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0438"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC438(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
XML437 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_437"_U_""_U_+$G(^TMP("BGPMU0437",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0437",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0437",$J,"C","EXC"))
 K ^TMP("BGPMU0437",$J)
 Q
XML438 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_438"_U_""_U_+$G(^TMP("BGPMU0438",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0438",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0438",$J,"C","EXC"))
 K ^TMP("BGPMU0438",$J)
