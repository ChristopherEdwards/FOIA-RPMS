BGPMUHP6 ; IHS/MSC/JSM - MU EH  measure output routines;02-Mar-2011 16:29;DU
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
VTE1 ;EH  output routine for 0371 VTE-1 (BGPMUH10)
 D P1
 K ^TMP("BGPMU0371")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN,NUM,NONUM,EXC,STRING1,STRING2,STRING3,PC1,PC2,PRD1,PRD2,PRB1,PRB2
 S STRING1=$$371("C")
 S STRING2=$$371("P")
 S STRING3=$$371("B")
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
 W !,"# Inpatient discharges",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?65,$P(STRING3,U,1)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Inpatient discharges",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?65,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"Less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/received VTE",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"prophylaxis"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o received VTE",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 W !,"prophylaxis"
 I $D(BGPLIST(BGPIC)) D P1D
 D SUM371^BGPMUHD5
 Q
371(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0371",$J,BGPMUTF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0371",$J,BGPMUTF,"NUM"))
 S EXC=+$G(^TMP("BGPMU0371",$J,BGPMUTF,"EXC"))
 S NONUM=+$G(^TMP("BGPMU0371",$J,BGPMUTF,"NOT"))
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .I DEN-EXC=0 S (PC1,PC2)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM/(DEN-EXC)),3)*100
 ..S PC2=$$ROUND^BGPMUA01((NONUM/(DEN-EXC)),3)*100
 S ARRAY=DEN_U_NUM_U_NONUM_U_EXC_U_PC1_U_PC2
 Q ARRAY
P1D ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="This measure assesses the number of patients who received VTE prophylaxis or" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="have documentation why no VTE prophylaxis was given the day of or the day after" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="hospital admission or surgery end date for surgeries that start the day of or" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="the day after hospital admission, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADM=Inpatient Admission" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="NMI=Not Medical Indicated" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="REF=Refusals" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=Medication Date" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0371",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0371"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D371(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0371",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0371"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D371(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0371",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0371"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC371(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
D372(NODE) ;GET DATA
 D D371(NODE)
 Q
D371(NODE) ;GET DATA
 N BGPI,DATA,NAME,HRN,DEN,NUM,AGE,DFN,CODE
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,23)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 S DEN=$P($P($P(NODE,U,2),";",1),":",1)
 S NUM=$P(NODE,U,3)
 S CODE=$P(NODE,U,4)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"ADM: "_$$FMTE^XLFDT(DEN,2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),?69,$S(NUM'="":"M:"_CODE_" "_$$FMTE^XLFDT($P(NUM,".",1),2)_$S($L($P(NODE,"U",2),";")>1:";",1:""),1:"NM:")
 Q
DEXC372(NODE) ;GET DATA
 D DEXC371(NODE)
 Q
DEXC371(NODE) ;GET DATA
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
 .W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?48,AGE,?53,"Excluded"
 Q
 ;
VTE2 ;EH  output routine for 0372 VTE-2 (BGPMUH11)
 D P2
 K ^TMP("BGPMU0372")
 Q
P2 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N DEN,NUM,NONUM,EXC,STRING1,STRING2,STRING3,PC1,PC2,PRD1,PRD2,PRB1,PRB2
 S STRING1=$$372("C")
 S STRING2=$$372("P")
 S STRING3=$$372("B")
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
 W !,"# Inpatient discharges",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?65,$P(STRING3,U,1)
 W !,"w/ICU LOS => 1 day"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Excluded (Exc)",?33,$P(STRING1,U,4),?44,$P(STRING2,U,4),?65,$P(STRING3,U,4)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# Inpatient discharges",?33,$P(STRING1,U,1)-$P(STRING1,U,4),?44,$P(STRING2,U,1)-$P(STRING2,U,4),?65,$P(STRING3,U,1)-$P(STRING3,U,4)
 W !,"w/ICU LOS => 1 day"
 W !,"Less Exc"
 W !
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/received VTE",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,5),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,5),5,1),?56,$J($FN(PRD2,",+",1),6),?65,$P(STRING3,U,2),?68,$J($P(STRING3,U,5),5,1),?74,$J($FN(PRD3,",+",1),6)
 W !,"Prophylaxis"
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o VTE prophylaxis",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,6),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,6),5,1),?56,$J($FN(PRD4,",+",1),6),?65,$P(STRING3,U,3),?68,$J($P(STRING3,U,6),5,1),?74,$J($FN(PRD5,",+",1),6)
 I $D(BGPLIST(BGPIC)) D P2D
 D SUM372^BGPMUHD5
 Q
372(BGPMUTF) ;Get the numbers for this measure
 N ARRAY
 S DEN=+$G(^TMP("BGPMU0372",$J,BGPMUTF,"DEN"))
 S NUM=+$G(^TMP("BGPMU0372",$J,BGPMUTF,"NUM"))
 S EXC=+$G(^TMP("BGPMU0372",$J,BGPMUTF,"EXC"))
 S NONUM=+$G(^TMP("BGPMU0372",$J,BGPMUTF,"NOT"))
 I DEN=0 S (PC1,PC2)=0
 I DEN>0 D
 .I DEN-EXC=0 S (PC1,PC2)=0
 .E  D
 ..S PC1=$$ROUND^BGPMUA01((NUM/(DEN-EXC)),3)*100
 ..S PC2=$$ROUND^BGPMUA01((NONUM/(DEN-EXC)),3)*100
 S ARRAY=DEN_U_NUM_U_NONUM_U_EXC_U_PC1_U_PC2
 Q ARRAY
P2D ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="This measure assesses the number of patients who received VTE prophylaxis or" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="have documentation why no VTE prophylaxis was given the day of or the day after" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="the initial admission (or transfer) to the Intensive Care Unit (ICU) or surgery" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="end date for surgeries that start the day of or the day after ICU admission" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="(or transfer), if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:).  Excluded patients are" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="listed last." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator and numerator" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="columns:" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="ADM=Inpatient Admission" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="MED=Medication Date" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="REF=Refusals" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="NMI=Not Medically Indicated" D W^BGPMUPP(X,0,1,BGPPTYPE)
 I $Y>(BGPIOSL-2) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?44,"SEX",?48,"AGE",?53,"DENOMINATOR",?69,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S PTCT=0
 I (BGPLIST="A")!(BGPLIST="D")&$D(^TMP("BGPMU0372",$J,"PAT","C","NOT")) D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0372"","_$J_",""PAT"",""C"",""NOT"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D372(NODE)
 I (BGPLIST="A")!(BGPLIST="N")&($D(^TMP("BGPMU0372",$J,"PAT","C","NUM"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0372"","_$J_",""PAT"",""C"",""NUM"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D D372(NODE)
 ;Excluded patients
 I BGPLIST="A"&($D(^TMP("BGPMU0372",$J,"PAT","C","EXC"))) D
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0372"","_$J_",""PAT"",""C"",""EXC"")")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DEXC372(NODE)
 S X="Total # of patients on list: "_PTCT D W^BGPMUPP(X,0,2,BGPPTYPE)
 Q
 ;
XML371 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0371"_U_""_U_+$G(^TMP("BGPMU0371",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0371",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0371",$J,"C","EXC"))
 K ^TMP("BGPMU0371",$J)
 Q
XML372 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0372"_U_""_U_+$G(^TMP("BGPMU0372",$J,"C","DEN"))_U_+$G(^TMP("BGPMU0372",$J,"C","NUM"))_U_+$G(^TMP("BGPMU0372",$J,"C","EXC"))
 K ^TMP("BGPMU0372",$J)
 Q
