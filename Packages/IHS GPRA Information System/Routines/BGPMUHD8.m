BGPMUHD8 ; IHS/MSC/JSM - MU EH  measure output routines;18-May-2011 11:24;DU
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 ; ED1^BGPMUHD8 = output routine for 0495 ED-1
 ; ED2^BGPMUHD8 = output routine for 0497 ED-2
 ;
 ; STK2^BGPMUHD1   = output routine for 0435 STK-2 Antithrombolytic Therapy at discharge
 ; STK3^BGPMUHD1   = output routine for 0436 STK-3 Anticoagulation Therapy at discharge
 ; STK4^BGPMUHD2   = output routine for 0437 STK-4 thrombolytic therapy within 3 hours
 ; STK5^BGPMUHD2   = output routine for 0438 STK-5 Antithrombolytic Therapy by end of day 2
 ; STK6^BGPMUHD3   = output routine for 0439 STK-6 Statin Medicine at Discharge
 ; STK8^BGPMUHD3   = output routine for 0440 STK-8 Educational Materials at discharge
 ; STK10^BGPMUHD4   = output routine for 0441 STK-10 Rehabilitation Service at discharge
 ;
 ; VTE1^BGPMUD5 = output routine for 0371 VTE-1 Prophylaxis within 24 hours
 ; VTE2^BGPMUD5 = output routine for 0372 VTE-2 Prophylaxis for ICU pts
 ; VTE3^BGPMUD6 = output routine for 0373 VTE-3 Anticoagulation overlap therapy
 ; VTE4^BGPMUD6 = output routine for 0374 VTE-4 Platelet monitoring for UFH
 ; VTE5^BGPMUD7 = output routine for 0375 VTE-5 VTE discharge instructions
 ; VTE6^BGPMUD7 = output routine for 0376 VTE-6 Potentially preventable VTE
 ;
ED1 ;EH  output routine for 0495 ED-1 (BGPMUH01)
 D P1
 K ^TMP("BGPMU0495")
 Q
P1 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N POP1,POP2,POP3,STRING1,STRING2,STRING3,PRP1,PRP2,PRP3,PRB1,PRB2,PRB3
 S STRING1=$$495("C")
 S STRING2=$$495("P")
 S STRING3=$$495("B")
 S PRP1=$P(STRING1,U,1)-$P(STRING2,U,1)
 S PRP2=$P(STRING1,U,2)-$P(STRING2,U,2)
 S PRP3=$P(STRING1,U,3)-$P(STRING2,U,3)
 S PRB1=$P(STRING1,U,1)-$P(STRING3,U,1)
 S PRB2=$P(STRING1,U,2)-$P(STRING3,U,2)
 S PRB3=$P(STRING1,U,3)-$P(STRING3,U,3)
 S X=U_"REPORT PERIOD"_U_""_U_"PREV YR PERIOD"_U_""_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_""_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,1,1)
 S X="Median Elpse Time (min)"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_PRP1_U_$P(STRING3,U,1)_U_U_PRB1 D S^BGPMUDEL(X,1,1)
 S X="BTW ED Arrival &" D S^BGPMUDEL(X,1,1)
 S X="ED Departure -" D S^BGPMUDEL(X,1,1)
 S X="All ED Pts Excl" D S^BGPMUDEL(X,1,1)
 S X="Pts w/Mental Disorder" D S^BGPMUDEL(X,1,1)
 S X="or Observation Status" D S^BGPMUDEL(X,1,1)
 S X="Median Elpsd Time (min)"_U_$P(STRING1,U,2)_U_U_$P(STRING2,U,2)_U_U_PRP2_U_$P(STRING3,U,2)_U_U_PRB2 D S^BGPMUDEL(X,1,1)
 S X="BTW ED Arrival &" D S^BGPMUDEL(X,1,1)
 S X="ED Departure -" D S^BGPMUDEL(X,1,1)
 S X="ED Observation Status" D S^BGPMUDEL(X,1,1)
 S X="Pts only" D S^BGPMUDEL(X,1,1)
 S X="Median Elpsd Time (min)"_U_$P(STRING1,U,3)_U_U_$P(STRING2,U,3)_U_U_PRP3_U_$P(STRING3,U,3)_U_U_PRB3 D S^BGPMUDEL(X,1,1)
 S X="BTW ED Arrival &" D S^BGPMUDEL(X,1,1)
 S X="ED Departure -" D S^BGPMUDEL(X,1,1)
 S X="ED Mental Disorder" D S^BGPMUDEL(X,1,1)
 S X="Pts only" D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D P1D
SUM495 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0495^^1"
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,1)=U_"Median for Pts w/o Mental/Obser"_U_U_$P(STRING1,U,1)_U_$P(STRING2,U,1)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,2)=U_"Median for Pts w/Observation Sts"_U_U_$P(STRING1,U,2)_U_$P(STRING2,U,2)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,3)=U_"Median for Pts w/Mental Disorder"_U_U_$P(STRING1,U,3)_U_$P(STRING2,U,3)
 Q
495(TF) ;Get the numbers for this measure
 N ARRAY
 S POP1=$G(^TMP("BGPMU0495",$J,TF,"POP",1))
 S POP2=$G(^TMP("BGPMU0495",$J,TF,"POP",2))
 S POP3=$G(^TMP("BGPMU0495",$J,TF,"POP",3))
 S ARRAY=+POP1_U_+POP2_U_+POP3_U_+$P(POP1,U,2)_U_+$P(POP2,U,2)_U_+$P(POP3,U,2)
 Q ARRAY
P1D ;Do the Details
 N POP,PT,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,1,1)
 S X="Elapsed times are stratified as follows: A) All ED patients excluding patients with mental disorders or "
 S X=X_"placed into observation status, B) ED patients placed into observation status, and C) ED patients with "
 S X=X_"a mental disorder." D S^BGPMUDEL(X,2,1)
 S X="The following are the abbreviations used in the denominator and numerator columns:" D S^BGPMUDEL(X,2,1)
 S X="N/A=Not Applicable - No Denominators for this Measure" D S^BGPMUDEL(X,1,1)
 S X="ED=ED Patient, Excl Mental Disorder & Observation Status" D S^BGPMUDEL(X,1,1)
 S X="MD=ED Mental Disorder Patient" D S^BGPMUDEL(X,1,1)
 S X="OS=ED Observation Status Patient" D S^BGPMUDEL(X,1,1)
 S X="A) All ED patients excluding patients with mental disorders or placed into observation status"
 D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,1,1)
 S POP=1,PTCT=0,BGPMUTF="C"
 S PT=0 F  S PT=$O(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 S X="Total # of ED visits on list: "_PTCT D S^BGPMUDEL(X,2,1)
 S PTCT=0
 S X="B) ED patients placed into observation status" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S POP=2
 S PT=0 F  S PT=$O(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 S X="Total # of ED visits on list: "_PTCT D S^BGPMUDEL(X,2,1)
 S PTCT=0
 S X="C) ED patients with a mental disorder" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S POP=3
 S PT=0 F  S PT=$O(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 S X="Total # of ED visits on list: "_PTCT D S^BGPMUDEL(X,1,1)
 Q
 ;
ED2 ;EH  output routine for 0497 ED-2 (BGPMUH01)
 D P2
 K ^TMP("BGPMU0497")
 Q
P2 ;Write individual measure
 N X,Y,Z,LIST1,LIST2,LIST3
 N POP1,POP2,POP3,STRING1,STRING2,STRING3,PRP1,PRP2,PRP3,PRB1,PRB2,PRB3
 S STRING1=$$497("C")
 S STRING2=$$497("P")
 S STRING3=$$497("B")
 S PRP1=$P(STRING1,U,1)-$P(STRING2,U,1)
 S PRP2=$P(STRING1,U,2)-$P(STRING2,U,2)
 S PRP3=$P(STRING1,U,3)-$P(STRING2,U,3)
 S PRB1=$P(STRING1,U,1)-$P(STRING3,U,1)
 S PRB2=$P(STRING1,U,2)-$P(STRING3,U,2)
 S PRB3=$P(STRING1,U,3)-$P(STRING3,U,3)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE" D S^BGPMUDEL(X,1,1)
 S X="Median Elpsd Time (min)"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_PRP1_U_$P(STRING3,U,1)_U_U_PRB1 D S^BGPMUDEL(X,1,1)
 S X="BTW ED Admit Decision" D S^BGPMUDEL(X,1,1)
 S X="& ED Departure -" D S^BGPMUDEL(X,1,1)
 S X="All ED Pts Excl Pts" D S^BGPMUDEL(X,1,1)
 S X="w/Mental Disorder or" D S^BGPMUDEL(X,1,1)
 S X="Observation Status" D S^BGPMUDEL(X,1,1)
 S X="Median Elpsd Time (min)"_U_$P(STRING1,U,2)_U_U_$P(STRING2,U,2)_U_U_PRP2_U_$P(STRING3,U,2)_U_U_PRB2 D S^BGPMUDEL(X,1,1)
 S X="BTW ED Admit Decision" D S^BGPMUDEL(X,1,1)
 S X="& ED Departure -" D S^BGPMUDEL(X,1,1)
 S X="ED Observation Status" D S^BGPMUDEL(X,1,1)
 S X="Pts only" D S^BGPMUDEL(X,1,1)
 S X="Median Elpsd Time (min)"_U_$P(STRING1,U,3)_U_U_$P(STRING2,U,3)_U_U_PRP3_U_$P(STRING3,U,3)_U_U_PRB3 D S^BGPMUDEL(X,1,1)
 S X="BTW ED Admit Decision" D S^BGPMUDEL(X,1,1)
 S X="& ED Departure -" D S^BGPMUDEL(X,1,1)
 S X="ED Mental Disorder" D S^BGPMUDEL(X,1,1)
 S X="Pts only" D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D P2D
SUM497 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0497^^1"
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,1)=U_"Median for Pts w/o Mental/Obser"_U_U_$P(STRING1,U,1)_U_$P(STRING2,U,1)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,2)=U_"Median for Pts w/Observation Sts"_U_U_$P(STRING1,U,2)_U_$P(STRING2,U,2)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,3)=U_"Median for Pts w/Mental Disorder"_U_U_$P(STRING1,U,3)_U_$P(STRING2,U,3)
 Q
497(TF) ;Get the numbers for this measure
 N ARRAY
 S POP1=$G(^TMP("BGPMU0497",$J,TF,"POP",1))
 S POP2=$G(^TMP("BGPMU0497",$J,TF,"POP",2))
 S POP3=$G(^TMP("BGPMU0497",$J,TF,"POP",3))
 S ARRAY=+$P(POP1,U,1)_U_+$P(POP2,U,1)_U_+$P(POP3,U,1)_U_+$P(POP1,U,2)_U_+$P(POP2,U,2)_U_+$P(POP3,U,2)
 Q ARRAY
P2D ;Do the Details
 N POP,PT,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,1,1)
 S X="Elapsed times are stratified as follows: A) All ED patients excluding patients with mental disorders "
 S X=X_"or placed into observation status, B) ED patients placed into observation status, and C) ED patients "
 S X=X_"with a mental disorder." D S^BGPMUDEL(X,2,1)
 S X="The following are the abbreviations used in the denominator and numerator columns:" D S^BGPMUDEL(X,2,1)
 S X="N/A=Not Applicable - No Denominators for this Measure" D S^BGPMUDEL(X,1,1)
 S X="ED=ED Patient, Excl Mental Disorder & Observation Status" D S^BGPMUDEL(X,1,1)
 S X="MD=ED Mental Disorder Patient" D S^BGPMUDEL(X,1,1)
 S X="OS=ED Observation Status Patient" D S^BGPMUDEL(X,1,1)
 S X="A) All ED patients excluding patients with mental disorders or placed into observation status"
 D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S POP=1,PTCT=0,BGPMUTF="C"
 S PT=0 F  S PT=$O(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 S X="Total # of ED visits on list: "_PTCT D S^BGPMUDEL(X,2,1)
 S PTCT=0
 S X="B) ED patients placed into observation status" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S POP=2
 S PT=0 F  S PT=$O(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 S X="Total # of ED visits on list: "_PTCT D S^BGPMUDEL(X,2,1)
 S PTCT=0
 S X="C) ED patients with a mental disorder" D S^BGPMUDEL(X,2,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 D S^BGPMUDEL(X,2,1)
 S POP=3
 S PT=0 F  S PT=$O(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 S X="Total # of ED visits on list: "_PTCT D S^BGPMUDEL(X,2,1) S X=""
 Q
 ;
DATA(NODE) ;GET DATA
 N NAME,HRN,AGE,SEX,DFN,DEN,NUM,COMM
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,DFN,.01),1,30)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$P($G(^DPT(DFN,0)),U,2)
 S DEN="N/A",NUM=$P(NODE,U,2)
 S COMM=$$GET1^DIQ(9000001,DFN,1118)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_NUM D S^BGPMUDEL(X,1,1)
 Q
 ;
XML495 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0495_1"_U_""_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",1)),U,2)_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",1)),U,1)
 S BGPXML(2)="NQF_0495_2"_U_""_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",2)),U,2)_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",2)),U,1)
 S BGPXML(3)="NQF_0495_3"_U_""_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",3)),U,2)_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",3)),U,1)
 K ^TMP("BGPMU0495",$J)
 Q
XML497 ;Populate the MSCXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0497_1"_U_""_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",1)),U,2)_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",1)),U,1)
 S BGPXML(2)="NQF_0497_2"_U_""_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",2)),U,2)_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",2)),U,1)
 S BGPXML(3)="NQF_0497_3"_U_""_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",3)),U,2)_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",3)),U,1)
 K ^TMP("BGPMU0497",$J)
 Q
