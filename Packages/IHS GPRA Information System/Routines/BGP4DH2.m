BGP4DH2 ; IHS/CMI/LAB - cover page for gpra 28 Apr 2010 11:30 AM 02 Jul 2010 8:28 AM ;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;
 ;
DASH ;EP
 D W^BGP4DP("",0,1,BGPPTYPE)
 S BGPNODEP=91
 S BGPX=$O(^BGPCTRL("B",2014,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP4DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP(^BGPCTRL(BGPX,BGPNODEP,BGPY,0),0,1,BGPPTYPE)
 .Q
 D W^BGP4DP("",0,1,BGPPTYPE)
 Q
ONMHDRA ;EP
 D W^BGP4DP("",0,1,BGPPTYPE)
 S BGPTEXT="ONH1" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP4DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP(BGPT,0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 I BGPRTC="U" D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP4DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP("3. User defines population: a) Indian/Alaska Natives Only - based on",0,1,BGPPTYPE)
 .D W^BGP4DP("Classification of 01; b) Non AI/AN (not 01); or c) Both.",0,1,BGPPTYPE)
 I BGPRTC="H" D  I BGPPTYPE="P" Q:BGPQHDR
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D  I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP("3. Indian/Alaska Natives Only - based on Classification of 01.",0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 S BGPTEXT="ONH2" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP4DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP(BGPT,0,1,BGPPTYPE)
 I BGPPTYPE="P" Q:BGPQHDR
 S BGPTEXT="UP" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP4DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP(BGPT,0,1,BGPPTYPE)
 D W^BGP4DP("",0,1,BGPPTYPE)
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
 ;; - Non-GPRA Summary and Official GPRA/GPRAMA Summary are located on the
 ;;last pages of this report following the GPRA/GPRAMA section.
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
 ;;
GPRAHDRA ;EP
 D W^BGP4DP("",0,1,BGPPTYPE)
 S BGPX=$O(^BGPCTRL("B",2014,0))
 S BGPNODEP=29 D 2
 S BGPTEXT="UP" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP4DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP(BGPT,0,1,BGPPTYPE)
 Q
2 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,BGPNODEP,BGPY)) Q:BGPY'=+BGPY!(BGPQHDR)  D
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D AHDR^BGP4DH1 Q:BGPQHDR
 .D W^BGP4DP(^BGPCTRL(BGPX,BGPNODEP,BGPY,0),0,1,BGPPTYPE)
 .Q
 Q
DASHHDRA ;EP
 D W^BGP4DP("",0,1,BGPPTYPE)
 S BGPX=$O(^BGPCTRL("B",2014,0))
 S BGPNODEP=94 D 2
 ;D W^BGP4DP("",0,1,BGPPTYPE)
 S BGPTEXT="UP1" F BGPJ1=1:1 S BGPX=$T(@BGPTEXT+BGPJ1) Q:$P(BGPX,";;",2)="QUIT"  D
 .S BGPT=$P(BGPX,";;",2)
 .I BGPPTYPE="P",$Y>(BGPIOSL-2) D HDR^BGP4DH I BGPPTYPE="P" Q:BGPQHDR
 .D W^BGP4DP(BGPT,0,1,BGPPTYPE)
 Q
