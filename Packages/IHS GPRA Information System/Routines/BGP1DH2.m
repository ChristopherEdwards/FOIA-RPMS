BGP1DH2 ; IHS/CMI/LAB - cover page for gpra 28 Apr 2010 11:30 AM 02 Jul 2010 8:28 AM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
DASH ;EP
 D W^BGP1DP("",0,1,BGPPTYPE)
 S BGPNODEP=$S($G(BGPCHSO):92,1:91)
 S BGPNODEP=$S($G(BGPURBAN):93,1:BGPNODEP)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(^BGPCTRL(BGPX,BGPNODEP,BGPY,0),0,1,BGPPTYPE)
 .Q
 D W^BGP1DP("",0,1,BGPPTYPE)
 Q
ONMHDRA ;EP
 D W^BGP1DP("",0,1,BGPPTYPE)
 S BGPTEXT="ONH1" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 I BGPRTC="U" D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP("3. User defines population: a) Indian/Alaska Natives Only - based on",0,1,BGPPTYPE)
 .D W^BGP1DP("Classification of 01; b) Non AI/AN (not 01); or c) Both.",0,1,BGPPTYPE)
 I BGPRTC="H" D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D  I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP("3. Indian/Alaska Natives Only - based on Classification of 01.",0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 S BGPTEXT="ONH2" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 I BGPCHSO D ONMHDRC
 I BGPPTYPE="P" Q:BGPQHDR
 I BGPURBO D ONMHDRU
 I BGPPTYPE="P" Q:BGPQHDR
 S BGPTEXT="UP" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 D W^BGP1DP("",0,1,BGPPTYPE)
 Q
ONMHDRC ;
 S BGPTEXT="ONHC1" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2),BGPPTYPE="P" D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 I BGPPTYPE="P" I BGPPTYPE="P" Q:BGPQHDR
 I BGPRTC="U" D  I BGPPTYPE="P" I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P" I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP("3. User defines population: a) Indian/Alaska Natives Only - based on",0,1,BGPPTYPE)
 .D W^BGP1DP("Classification of 01; b) Non AI/AN (not 01); or c) Both.",0,1,BGPPTYPE)
 I BGPRTC="H" D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D  I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP("3. Indian/Alaska Natives Only - based on Classification of 01.",0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 S BGPTEXT="ONH2C" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 ;D W^BGP1DP("",0,1,BGPPTYPE)
 Q
ONMHDRU ;
 S BGPTEXT="ONHU1" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2),BGPPTYPE="P" D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 I BGPPTYPE="P" I BGPPTYPE="P" Q:BGPQHDR
 I BGPRTC="U" D  I BGPPTYPE="P" I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P" I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP("3. User defines population: a) Indian/Alaska Natives Only - based on",0,1,BGPPTYPE)
 .D W^BGP1DP("Classification of 01; b) Non AI/AN (not 01); or c) Both.",0,1,BGPPTYPE)
 I BGPRTC="H" D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D  I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP("3. Indian/Alaska Natives Only - based on Classification of 01.",0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 S BGPTEXT="ONH2U" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 ;D W^BGP1DP("",0,1,BGPPTYPE)
 Q
ONH1 ;;
 ;;Denominator Definitions used in this Report:
 ;;
 ;;ACTIVE CLINICAL POPULATION:
 ;;1. Must reside in a community specified in the community taxonomy used for
 ;;this report.
 ;;2. Must be alive on the last day of the Report period.
 ;;QUIT
 ;
ONH2 ;;
 ;;4. Must have 2 visits to medical clinics in the 3 years prior to the end
 ;;of the Report period. At least one visit must include: 01 General,
 ;;06 Diabetic, 10 GYN, 12 Immunization, 13 Internal Med, 20 Pediatrics, 24
 ;;Well Child, 28 Family Practice, 57 EPSDT, 70 Women's Health, 80 Urgent, 89
 ;;Evening.  See User Manual for complete description of medical clinics.
 ;;QUIT
 ;;
UP ;;
 ;;
 ;;USER POPULATION:
 ;;1. Definitions 1-3 above.
 ;;2. Must have been seen at least once in the 3 years prior to the end of
 ;;the Report period, regardless of the clinic type.
 ;;
 ;;The report Performance Summaries are split into two sections.
 ;; - GPRA Developmental Summary located at the end of the GPRA Developmental
 ;;section
 ;; - Non-GPRA Summary and Official GPRA & PART Summary are located on the
 ;;last pages of this report following the GPRA & PART section.
 ;;QUIT
 ;;
UP1 ;;
 ;;
 ;;USER POPULATION:
 ;;1. Definitions 1-3 above.
 ;;2. Must have been seen at least once in the 3 years prior to the end of
 ;;the Report period, regardless of the clinic type.
 ;;
 ;;QUIT
 ;;
ONH2C ;;
 ;;4. Must have 2 CHS visits in the 3 years prior to the end of the Report period.
 ;;QUIT
ONHC1 ;;
 ;;
 ;;ACTIVE CLINICAL CHS POPULATION:
 ;;1. Must reside in a community specified in the community taxonomy used for
 ;;this report.
 ;;2. Must be alive on the last day of the Report period.
 ;;QUIT
 ;
ONH2U ;;
 ;;4. Must have 2 visits to behavioral health or case management clinics in
 ;;the 3 years prior to the end of the Report period.
 ;;QUIT
ONHU1 ;;
 ;;
 ;;ACTIVE BEHAVIORAL HEALTH URBAN OUTREACH & REFERRAL POPULATION:
 ;;1. Must reside in a community specified in the community taxonomy used for
 ;;this report.
 ;;2. Must be alive on the last day of the Report period.
 ;;QUIT
 ;
 ;
CHS ;;
 ;;
 ;;ACTIVE CLINICAL CHS POPULATION:
 ;;1. Must reside in a community specified in the community taxonomy used for
 ;;this report.
 ;;2. Must be alive on the last day of the Report period.
 ;;3. Indian/Alaska Natives Only - based on Classification of 01.
 ;;4. Must have 2 CHS visits in the 3 years prior to the end of the Report period.
 ;;QUIT
 ;;
URB ;;
 ;;
 ;;ACTIVE BEHAVIORAL HEALTH URBAN OUTREACH & REFERRAL POPULATION:
 ;;1. Must reside in a community specified in the community taxonomy used for
 ;;this report.
 ;;2. Must be alive on the last day of the Report period.
 ;;3. Indian/Alaska Natives Only - based on Classification of 01.
 ;;4. Must have 2 visits to behavioral health or case management clinics in the
 ;;3 years prior to the end of the Report period.
 ;;QUIT
 ;;
GPRAHDRA ;EP
 D W^BGP1DP("",0,1,BGPPTYPE)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 ;I '(BGPCHSO+BGPURBO) S BGPNODEP=14 D 2 Q  ;no urban or chs
 S BGPNODEP=29 D 2
 ;D W^BGP1DP("",0,1,BGPPTYPE)
 I BGPCHSO S BGPTEXT="CHS" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 I BGPURBO S BGPTEXT="URB" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 S BGPTEXT="UP" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 Q
2 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D AHDR^BGP1DH1 Q:BGPQHDR
 .D W^BGP1DP(^BGPCTRL(BGPX,BGPNODEP,BGPY,0),0,1,BGPPTYPE)
 .Q
 Q
DASHHDRA ;EP
 D W^BGP1DP("",0,1,BGPPTYPE)
 S BGPX=$O(^BGPCTRL("B",2011,0))
 ;I '(BGPCHSO+BGPURBO) S BGPNODEP=14 D 2 Q  ;no urban or chs
 S BGPNODEP=94 D 2
 ;D W^BGP1DP("",0,1,BGPPTYPE)
 I BGPCHSO S BGPTEXT="CHS" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 I BGPURBO S BGPTEXT="URB" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 S BGPTEXT="UP1" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP1DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP1DP(BGPT,0,1,BGPPTYPE)
 Q
