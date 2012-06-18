BGPMUHP8 ; IHS/MSC/JSM - MU EH  measure output routines;02-Mar-2011 16:32;MGH
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 ; ED1^BGPMUHP1 = output routine for 0495 ED-1;;;;;Build 33
 ; ED2^BGPMUHP1 = output routine for 0497 ED-2
 ;
 ; STK2^BGPMUHP2   = output routine for 0375 STK-2 Antithrombolytic Therapy at discharge
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
VTE5 ;EH  output routine for 0375 VTE-5 (BGPMUH14)
 D P5
 K ^TMP("BGPMU0375")
 Q
P5 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN,NUM,NONUM,EXC,STRING1,STRING2,STRING3,PC1,PC2,PRD1,PRD2,PRB1,PRB2
 S STRING1=$$375("C")
 S STRING2=$$375("P")
 S STRING3=$$375("B")
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
 W !,"w/confirmed VTE"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Discharges for Pts",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?65,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"w/confirmed VTE Less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/documentation",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"(discharge instruction"
 W !,"or educational material)"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o documentation",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"(discharge instruction"
 W !,"or educational material)"
 I $D(BGPLIST(BGPIC)) D P5D
 D SUM375^BGPMUHD7
 Q
375(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0375",$J,BGPMUTF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0375",$J,BGPMUTF,"NUM"))
 S EXC=+$G(^TMP("BGPMU0375",$J,BGPMUTF,"EXC"))
 S NONUM=+$G(^TMP("BGPMU0375",$J,BGPMUTF,"NOT"))
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .I DEN-EXC=0 D  S (PC1,PC2)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM/(DEN-EXC)),3)*100
 ..S PC2=$$ROUND^BGPMUA01((NONUM/(DEN-EXC)),3)*100
 S ARRAY=DEN_U_NUM_U_NONUM_U_EXC_U_PC1_U_PC2
 Q ARRAY
P5D ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="This measure assesses the number of patients diagnosed with confirmed VTE that" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="are discharged to home, to home with home health or home hospice on warfarin with" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="written discharge instructions that address all four criteria: compliance issues," D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="dietary advice, follow-up monitoring and information about the potential for" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="adverse drug reactions/interactions, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADM=Admit Date for Inpatient w/confirmed VTE discharged on warfarin therapy" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="PED=Date education material given" D W^BGPMUPP(X,0,1,BGPPTYPE)
 ;
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0375",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0375"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D375(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0375",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0375"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D375(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0375",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0375"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC375(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
D376(NODE) ;get data
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
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"ADM "_$$FMTE^XLFDT(DEN,2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),?69,$S(NUM'="":"M:"_"TST "_$$FMTE^XLFDT($P(NUM,".",1),2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),1:"NM:")
 Q
D375(NODE) ;get data
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
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"ADM "_$$FMTE^XLFDT(DEN,2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),?69,$S(NUM'="":"M:"_"PED "_$$FMTE^XLFDT($P(NUM,".",1),2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),1:"NM:")
 Q
DEXC376(NODE) ;GET DATA
 D DEXC375(NODE)
 Q
DEXC375(NODE) ;GET DATA
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
VTE6 ;EH  output routine for 0376 VTE-6 (BGPMUH15)
 D P6
 K ^TMP("BGPMU0376")
 Q
P6 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN,NUM,NONUM,EXC,STRING1,STRING2,STRING3,PC1,PC2,PRD1,PRD2,PRB1,PRB2
 S STRING1=$$376("C")
 S STRING2=$$376("P")
 S STRING3=$$376("B")
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
 W !,"w/confirmed VTE"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Discharges for Pts",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?65,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"w/confirmed VTE Less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o VTE prophylaxis",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"prior to the VTE"
 W !,"diagnostic test date"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/VTE prophylaxis",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"prior to the VTE"
 W !,"diagnostic test date"
 I $D(BGPLIST(BGPIC)) D P6D
 D SUM376^BGPMUHD7
 Q
376(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0376",$J,BGPMUTF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0376",$J,BGPMUTF,"NUM"))
 S EXC=+$G(^TMP("BGPMU0376",$J,BGPMUTF,"EXC"))
 S NONUM=+$G(^TMP("BGPMU0376",$J,BGPMUTF,"NOT"))
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .I DEN-EXC=0 S (PC1,PC2)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM/(DEN-EXC)),3)*100
 ..S PC2=$$ROUND^BGPMUA01((NONUM/(DEN-EXC)),3)*100
 S ARRAY=DEN_U_NUM_U_NONUM_U_EXC_U_PC1_U_PC2
 Q ARRAY
P6D ;Do the details
 N PT,NODE,NAME,VST,BMI,FOL,X
 N BGPARR
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="This measure assesses the number of patients diagnosed with confirmed VTE during" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="hospitalization (not present on arrival) who did not receive VTE prophylaxis" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="between hospital admission and the day before the VTE diagnostic testing order" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="date, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:). Excluded patients are listed" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADM=Admit Date for Inpatient who developed confirmed VTE during hospitalization" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="TST=Date of VTE diagnostic test" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0376",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0376"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D376(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0376",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0376"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D376(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0376",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0376"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC376(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
XML375 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0375"_U_""_U_+$G(^TMP("BGPMU0375",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0375",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0375",$J,"C","EXC"))
 K ^TMP("BGPMU0375",$J)
 Q
XML376 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0376"_U_""_U_+$G(^TMP("BGPMU0376",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0376",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0376",$J,"C","EXC"))
 K ^TMP("BGPMU0376",$J)
 Q
