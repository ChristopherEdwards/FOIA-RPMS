BGPMUHP7 ; IHS/MSC/JSM - MU EH  measure output routines;02-Mar-2011 16:06;MGH
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
VTE3 ;EH  output routine for 0373 VTE-3 (BGPMUH12)
 D P3
 K ^TMP("BGPMU0373")
 Q
P3 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN,NUM,NONUM,EXC,STRING1,STRING2,STRING3,PC1,PC2,PRD1,PRD2,PRB1,PRB2
 S STRING1=$$373("C")
 S STRING2=$$373("P")
 S STRING3=$$373("B")
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
 W !,"# w/overlap therapy",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"at discharge"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o overlap therapy",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"at discharge"
 I $D(BGPLIST(BGPIC)) D P3D
 D SUM373^BGPMUHD6
 Q
373(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0373",$J,BGPMUTF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0373",$J,BGPMUTF,"NUM"))
 S EXC=+$G(^TMP("BGPMU0373",$J,BGPMUTF,"EXC"))
 S NONUM=+$G(^TMP("BGPMU0374",$J,BGPMUTF,"NOT"))
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .I DEN-EXC=0 S (PC1,PC2)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM/(DEN-EXC)),3)*100
 ..S PC2=$$ROUND^BGPMUA01((NONUM/(DEN-EXC)),3)*100
 S ARRAY=DEN_U_NUM_U_NONUM_U_EXC_U_PC1_U_PC2
 Q ARRAY
P3D ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="This measure assesses the number of patients diagnosed with confirmed VTE who" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="received an overlap of parenteral (intravenous [IV] or subcutaneous [subcu])" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="anticoagulation and warfarin therapy.  For patients who received less than" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="5 days of overlap therapy, they must be discharged on both medications." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Overlap therapy must be administered for at least 5 days with an international" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="normalized ratio (INR) >= 2 prior to discontinuation of the parenteral" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="anticoagulation therapy or the patient must be discharged on both medications," D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADM=Admit date for Inpatient w/ confirmed VTE who received warfarin" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="OVLP DAYS=Number of inpt overlap days" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="INR=Last result value prior to discharge" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="RX=Discharged on overlap therapy" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0373",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0373"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D373(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0373",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0373"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D373(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0373",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0373"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC373(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
D373(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN,CNT,DD,INR,INRDT
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P($P(NODE,U,2),";",1),":",1)
 S CNT=$P(NODE,U,3),INR=$P(NODE,U,4),INRDT=$P(NODE,U,5)
 S DD=$P(NODE,U,6)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"ADM "_$$FMTE^XLFDT(DEN,2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),?69,$S(CNT'="":"M:OVLP DAYS: "_CNT,1:"NM:")
 I INR'="" W ";",!,?69,"INR: "_INR_" "_INRDT
 I DD'="" W ";",!,?69,"RX:"_$$FMTE^XLFDT($P(DD,".",1),2)
 Q
DEXC373(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P($P(NODE,U,2),";",1),":",1)
 S NUM=$P($P($P(NODE,U,2),";",1),":",2)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"Excluded"
 Q
 ;
VTE4 ;EH  output routine for 0374 VTE-4 (BGPMUH13)
 D P4
 K ^TMP("BGPMU0374")
 Q
P4 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN,NUM,NONUM,EXC,STRING1,STRING2,STRING3,PC1,PC2,PRD1,PRD2,PRB1,PRB2
 S STRING1=$$374("C")
 S STRING2=$$374("P")
 S STRING3=$$374("B")
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
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Discharges for Pts",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?65,$P(STRING3,U,1)
 W !,"w/confirmed VTE"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Discharges for Pts",?33,($P(STRING1,U,1)-$P(STRING1,U,4)),?44,($P(STRING2,U,1)-$P(STRING2,U,4)),?65,($P(STRING3,U,1)-$P(STRING3,U,4))
 W !,"w/confirmed VTE Less Exc"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !
 W !,"# w/IV UFH therapy",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"& platelet count"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o IV UFH therapy",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"& platelet count"
 I $D(BGPLIST(BGPIC)) D P4D
 D SUM374^BGPMUHD6
 Q
374(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0374",$J,BGPMUTF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0374",$J,BGPMUTF,"NUM"))
 S EXC=+$G(^TMP("BGPMU0374",$J,BGPMUTF,"EXC"))
 S NONUM=+$G(^TMP("BGPMU0374",$J,BGPMUTF,"NOT"))
 I DEN=0 S (PC2,PC1)=0
 I DEN>0 D
 .I DEN-EXC=0 S (PC2,PC1)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM/(DEN-EXC)),3)*100
 ..S PC2=$$ROUND^BGPMUA01((NONUM/(DEN-EXC)),3)*100
 S ARRAY=DEN_U_NUM_U_NONUM_U_EXC_U_PC1_U_PC2
 Q ARRAY
P4D ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="This measure assesses the number of patients diagnosed with confirmed VTE who" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="received intravenous (IV) unfractionated heparin (UFH) therapy dosages AND had" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="their platelet counts monitored using defined parameters such as a nomogram or" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="protocol, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:). Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADM=Admit date for Inpatient w/confirmed VTE receiving IV UFH therapy" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=Start date of IV UFH therapy " D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="LAB#=Date of Platelet Count Laboratory Test" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-3) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?66,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0374",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0374"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D374(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0374",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0374"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D374(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0374",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0374"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC374(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
D374(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUMDATA,AGE,DFN,I
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P($P(NODE,U,2),";",1),":",1)
 S NUMDATA=$P(NODE,U,5)  ;$P(UFHIP,U,2)_";"_PLATE1_";"_PLATE2_";"_PLATE3
 S LINES=BGPIOSL-$S(NUMDATA="":2,1:5)
 I $Y>LINES D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?66,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"ADM "_$$FMTE^XLFDT(DEN,2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),?66,$S(NUMDATA'="":"M:MED "_$$FMTE^XLFDT($P(NUMDATA,";",1),2)_$S($P(NUMDATA,";")>1:";",1:""),1:"NM:")
 ;if pt is in NUM, they should have three lab dates to display:
 I NUMDATA'="" F I=1:1:3 D
 .W !,?68,"LAB"_I_" "_$$FMTE^XLFDT($P(NUMDATA,";",(I+1)),2)_$S(I<3:";",1:"")
 Q
DEXC374(NODE)  ;GET DATA
 D DEXC373(NODE)
 Q
XML373 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0373"_U_""_U_+$G(^TMP("BGPMU0373",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0373",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0373",$J,"C","EXC"))
 K ^TMP("BGPMU0373",$J)
 Q
XML374 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0374"_U_""_U_+$G(^TMP("BGPMU0374",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0374",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0374",$J,"C","EXC"))
 K ^TMP("BGPMU0374",$J)
 Q
