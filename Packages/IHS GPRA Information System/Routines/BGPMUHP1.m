BGPMUHP1 ; IHS/MSC/JSM - MU EH  measure output routines;13-May-2011 16:13;MGH
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 ; ED1^BGPMUHP1 = output routine for 0495 ED-1
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
 ; VTE1^BGPMUP6 = output routine for 0371 VTE-1 Prophylaxis within 24 hours
 ; VTE2^BGPMUP6 = output routine for 0372 VTE-2 Prophylaxis for ICU pts
 ; VTE3^BGPMUP7 = output routine for 0373 VTE-3 Anticoagulation overlap therapy
 ; VTE4^BGPMUP7 = output routine for 0374 VTE-4 Platelet monitoring for UFH
 ; VTE5^BGPMUP8 = output routine for 0375 VTE-5 VTE discharge instructions
 ; VTE6^BGPMUP8 = output routine for 0376 VTE-6 Potentially preventable VTE
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
 ;I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 W !,"Median Elpsd Time (min)",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?56,PRP1,?65,$P(STRING3,U,1),?72,PRB1
 W !,"BTW ED Arrival &"
 W !,"ED Departure -"
 W !,"All ED Pts Excl"
 W !,"Pts w/Mental Disorder"
 W !,"or Observation Status"
 W !
 I $Y>(BGPIOSL-5) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Median Elpsd Time (min)",?33,$P(STRING1,U,2),?44,$P(STRING2,U,2),?56,PRP2,?65,$P(STRING3,U,2),?72,PRB2
 W !,"BTW ED Arrival &"
 W !,"ED Departure -"
 W !,"ED Observation Status"
 W !,"Pts only"
 W !
 I $Y>(BGPIOSL-5) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Median Elpsd Time (min)",?33,$P(STRING1,U,3),?44,$P(STRING2,U,3),?56,PRP3,?65,$P(STRING3,U,3),?72,PRB3
 W !,"BTW ED Arrival &"
 W !,"ED Departure -"
 W !,"ED Mental Disorder"
 W !,"Pts only"
 I $D(BGPLIST(BGPIC)) D P1D
 D SUM495^BGPMUHD8
 Q
495(TF) ;Get the numbers for this measure
 N ARRAY
 S POP1=+$G(^TMP("BGPMU0495",$J,TF,"POP",1))
 S POP2=+$G(^TMP("BGPMU0495",$J,TF,"POP",2))
 S POP3=+$G(^TMP("BGPMU0495",$J,TF,"POP",3))
 S ARRAY=POP1_U_POP2_U_POP3
 Q ARRAY
P1D ;Do the Details
 N POP,PT,PTCT
 D HEADERL^BGPMUPH
 W !!,"Elapsed times are stratified as follows: A) All ED patients excluding patients"
 W !,"with mental disorders or placed into observation status, B) ED patients placed"
 W !,"into observation status, and C) ED patients with a mental disorder."
 W !!,"The following are the abbreviations used in the denominator and numerator"
 W !,"columns:"
 W !,"N/A=Not Applicable - No Denominators for this Measure"
 W !,"ED=ED Patient, Excl Mental Disorder & Observation Status"
 W !,"MD=ED Mental Disorder Patient"
 W !,"OS=ED Observation Status Patient"
 I $Y>(BGPIOSL-7) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"A) All ED patients excluding patients with mental disorders or placed into"
 W !,"observation status"
 ;Patients not Mental health or Observation
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?43,"SEX",?47,"AGE",?51,"DENOMINATOR",?64,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S POP=1,PTCT=0,BGPMUTF="C"
 S PT=0 F  S PT=$O(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 W !!,"Total # of ED visits on list: "_PTCT
 S PTCT=0
 ;"Observation Pts seen in ER"
 I $Y>(BGPIOSL-7) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"B) ED patients placed into observation status"
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?43,"SEX",?47,"AGE",?51,"DENOMINATOR",?64,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S POP=2
 S PT=0 F  S PT=$O(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 W !!,"Total # of ED visits on list: "_PTCT
 S PTCT=0
 ;Mental health patients seen in ER"
 I $Y>(BGPIOSL-7) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"C) ED patients with a mental disorder"
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?43,"SEX",?47,"AGE",?51,"DENOMINATOR",?64,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S POP=3
 S PT=0 F  S PT=$O(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0495",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 W !!,"Total # of ED visits on list: "_PTCT
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
 ;I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 W !,"Median Elpsd Time (min)",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?56,PRP1,?65,$P(STRING3,U,1),?72,PRB1
 W !,"BTW ED Admit Decision"
 W !,"& ED Departure -"
 W !,"All ED Pts Excl Pts"
 W !,"w/Mental Disorder or"
 W !,"Observation Status"
 W !
 I $Y>(BGPIOSL-5) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Median Elpsd Time (min)",?33,$P(STRING1,U,2),?44,$P(STRING2,U,2),?56,PRP2,?65,$P(STRING3,U,2),?72,PRB2
 W !,"BTW ED Admit Decision"
 W !,"& ED Departure -"
 W !,"ED Observation Status"
 W !,"Pts only"
 W !
 I $Y>(BGPIOSL-5) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"Median Elpsd Time (min)",?33,$P(STRING1,U,3),?44,$P(STRING2,U,3),?56,PRP3,?65,$P(STRING3,U,3),?72,PRB3
 W !,"BTW ED Admit Decision"
 W !,"& ED Departure -"
 W !,"ED Mental Disorder"
 W !,"Pts only"
 I $D(BGPLIST(BGPIC)) D P2D
 D SUM497^BGPMUHD8
 Q
497(TF) ;Get the numbers for this measure
 N ARRAY
 S POP1=+$G(^TMP("BGPMU0497",$J,TF,"POP",1))
 S POP2=+$G(^TMP("BGPMU0497",$J,TF,"POP",2))
 S POP3=+$G(^TMP("BGPMU0497",$J,TF,"POP",3))
 S ARRAY=POP1_U_POP2_U_POP3
 Q ARRAY
P2D ;Do the Details
 N POP,PT,PTCT
 D HEADERL^BGPMUPH
 W !!,"Elapsed times are stratified as follows: A) All ED patients excluding patients"
 W !,"with mental disorders or placed into observation status, B) ED patients placed"
 W !,"into observation status, and C) ED patients with a mental disorder."
 W !!,"The following are the abbreviations used in the denominator and numerator"
 W !,"columns:"
 W !,"N/A=Not Applicable - No Denominators for this Measure"
 W !,"ED=ED Patient, Excl Mental Disorder & Observation Status"
 W !,"MD=ED Mental Disorder Patient"
 W !,"OS=ED Observation Status Patient"
 I $Y>(BGPIOSL-7) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"A) All ED patients excluding patients with mental disorders or placed into"
 W !,"observation status"
 ;Patients not Mental health or Observation
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?43,"SEX",?47,"AGE",?51,"DENOMINATOR",?64,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S POP=1,PTCT=0,BGPMUTF="C"
 S PT=0 F  S PT=$O(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 W !!,"Total # of ED visits on list: "_PTCT
 S PTCT=0
 ;Observation Pts seen in ER
 I $Y>(BGPIOSL-7) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"B) ED patients placed into observation status"
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?43,"SEX",?47,"AGE",?51,"DENOMINATOR",?64,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S POP=2
 S PT=0 F  S PT=$O(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 W !!,"Total # of ED visits on list: "_PTCT
 S PTCT=0
 ;Mental health patients seen in ER
 I $Y>(BGPIOSL-7) D HEADERL^BGPMUPH Q:BGPQUIT
 W !!,"C) ED patients with a mental disorder"
 W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?43,"SEX",?47,"AGE",?51,"DENOMINATOR",?64,"NUMERATOR"
 S LINE="",$P(LINE,"-",79)="" W !,LINE
 S POP=3
 S PT=0 F  S PT=$O(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT)) Q:'+PT  D
 .S PTCT=PTCT+1
 .S NODE=$G(^TMP("BGPMU0497",$J,"C","POP",POP,"PAT",PT))
 .D DATA(NODE)
 W !!,"Total # of ED visits on list: "_PTCT
 Q
 ;
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,COMM,SEX
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,30)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S DEN="N/A",NUM=$P(NODE,U,2)
 S SEX=$P($G(^DPT(DFN,0)),U,2)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,10)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !!,"PATIENT NAME",?25,"HRN",?33,"COMMUNITY",?43,"SEX",?47,"AGE",?51,"DENOMINATOR",?64,"NUMERATOR"
 .S LINE="",$P(LINE,"-",79)="" W !,LINE
 W !,NAME,?25,HRN,?33,COMM,?44,SEX,?47,AGE,?51,DEN,?64,NUM
 Q
 ;
XML495 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0495_1"_U_""_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",1)),U,2)_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",1)),U,1)
 S BGPXML(2)="NQF_0495_2"_U_""_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",2)),U,2)_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",2)),U,1)
 S BGPXML(3)="NQF_0495_3"_U_""_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",3)),U,2)_U_+$P($G(^TMP("BGPMU0495",$J,"C","POP",3)),U,1)
 K ^TMP("BGPMU0495",$J)
 Q
XML497 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Measure number^""^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="NQF_0497_1"_U_""_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",1)),U,2)_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",1)),U,1)
 S BGPXML(2)="NQF_0497_2"_U_""_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",2)),U,2)_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",2)),U,1)
 S BGPXML(3)="NQF_0497_3"_U_""_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",3)),U,2)_U_+$P($G(^TMP("BGPMU0497",$J,"C","POP",3)),U,1)
 K ^TMP("BGPMU0497",$J)
 Q
