BGPMUFD1 ;IHS/MSC/MMT - MU Reports Measure NQF0038 ;01-Mar-2011 15:50;MGH
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
CHIMM ;EP
 D P1
 K ^TMP("BGPMU0038")
 Q
P1 ;Print measure details
 N TOTALS,BGPI,TF,CMP,PMP,BMP,CMPWO,PMPWO,BMPWO,BGPDNCNT,BGPSSTR
 S BGPDNCNT=0
 F TF="C","P","B" D NEW
 F TF="C","P","B" D LOAD
 ;Initialize iCare/summary global
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0038^240"
 F N=1:1:12 D
 .S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 .D S^BGPMUDEL(X,2,1)
 .S X="" D S^BGPMUDEL(X,1,1)
 .S X="Numerator "_N_" ("_$P($T(ITEXT+N),";;",2)_")"
 .D S^BGPMUDEL(X,1,1)
 .S X="Pts 2 yrs old"_U_(@("CDEN"_N_"CT")+@("CEXC"_N_"CT"))_U_U_(@("PDEN"_N_"CT")+@("PEXC"_N_"CT"))_U_U_U_(@("BDEN"_N_"CT")+@("BEXC"_N_"CT"))
 .D S^BGPMUDEL(X,1,1)
 .S X="# Excluded (Exc)"_U_@("CEXC"_N_"CT")_U_U_@("PEXC"_N_"CT")_U_U_U_@("BEXC"_N_"CT")
 .D S^BGPMUDEL(X,1,1)
 .S X="Pts 2 yrs old less Exc"_U_@("CDEN"_N_"CT")_U_U_@("PDEN"_N_"CT")_U_U_U_@("BDEN"_N_"CT")
 .D S^BGPMUDEL(X,1,1)
 .D CALCS(N,.CMP,.PMP,.BMP)
 .D CALCSWO(N,.CMPWO,.PMPWO,.BMPWO)
 .S X=$P($T(NTEXT+N),";;",2)_U_@("CNUM"_N_"CT")_U_$J(CMP,5,1)_U_@("PNUM"_N_"CT")_U_$J(PMP,5,1)_U_$J($FN(CMP-PMP,"+,",1),6)_U_@("BNUM"_N_"CT")_U_$J(BMP,5,1)_U_$J($FN(CMP-BMP,"+,",1),6)
 .D S^BGPMUDEL(X,2,1)
 .S X=$P($T(OTEXT+N),";;",2)_U_(@("CDEN"_N_"CT")-@("CNUM"_N_"CT"))_U_$J(CMPWO,5,1)_U_(@("PDEN"_N_"CT")-@("PNUM"_N_"CT"))_U_$J(PMPWO,5,1)_U_$J($FN(CMPWO-PMPWO,"+,",1),6)
 .S X=X_U_(@("BDEN"_N_"CT")-@("BNUM"_N_"CT"))_U_$J(BMPWO,5,1)_U_$J($FN(CMPWO-BMPWO,"+,",1),6)
 .D S^BGPMUDEL(X,1,1)
 .;Setup summary page/iCare ^TMP global
 .S BGPDNCNT=BGPDNCNT+1
 .S BGPSSTR="MU.EP.0038."_N_U_$P($T(ITEXT+N),";;",2)_U_@("CEXC"_N_"CT")_U_@("CDEN"_N_"CT")_U_@("CNUM"_N_"CT")_U_CMP_"^^^^"
 .;                    11                 12                 13                14
 .S BGPSSTR=BGPSSTR_U_@("PEXC"_N_"CT")_U_@("PDEN"_N_"CT")_U_@("PNUM"_N_"CT")_U_PMP
 .;                    15                 16                 17                18
 .S BGPSSTR=BGPSSTR_U_@("BEXC"_N_"CT")_U_@("BDEN"_N_"CT")_U_@("BNUM"_N_"CT")_U_BMP
 .S ^TMP("BGPMU SUMMARY",$J,BGPIC,BGPDNCNT)=BGPSSTR
 I $D(BGPLIST(BGPIC)) D P2
 F TF="C","P","B" D KILL
 Q
 ;
P2 ;Print the Patient List Details
 N PT,NODE,NAME,VST,BMI,FOL,X,N,BGPARR,PTCT
 S X="Patients who reached 2 years of age and who had at least 1 encounter with the" D S^BGPMUDEL(X,2,1)
 S X="EP, both during the reporting period." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D S^BGPMUDEL(X,2,1)
 S X="by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator column:" D S^BGPMUDEL(X,2,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 F N=1:1:12 D
 .S X=$P($T(LITEXT+N),";;",2) D S^BGPMUDEL(X,2,1)
 .S PTCT=0
 .I BGPLIST="D"!(BGPLIST="A") D
 ..S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR"
 ..D S^BGPMUDEL(X,2,1)
 ..K BGPARR
 ..D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0038"","_$J_",""C"",""PAT"",""NOT"","_N_")")
 ..S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ...S PTCT=PTCT+1
 ...S NODE=$G(BGPARR(PT))
 ...S $P(NODE,U,3)="NM:"_$P(NODE,U,3) ; uglify the display
 ...D DATA(NODE)
 .I BGPLIST="N"!(BGPLIST="A") D
 ..K BGPARR
 ..D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0038"","_$J_",""C"",""PAT"",""INCL"","_N_")")
 ..S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ...S PTCT=PTCT+1
 ...S NODE=$G(BGPARR(PT))
 ...S $P(NODE,U,3)="M:"_$P(NODE,U,3) ; uglify the display
 ...D DATA(NODE)
 .I BGPLIST="A" D
 ..K BGPARR
 ..D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0038"","_$J_",""C"",""PAT"",""EXCL"","_N_")")
 ..S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ...S PTCT=PTCT+1
 ...S NODE=$G(BGPARR(PT))
 ...D DATA(NODE)
 .S X="Total # of patients on list: "_PTCT
 .D S^BGPMUDEL(X,2,1)
 Q
DATA(NODE) ;GET DATA
 N NAME,HRN,DEN,NUM,AGE,DFN,SEX,COMM
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S SEX=$P(^DPT(DFN,0),U,2)
 S DEN=$P(NODE,U,2),NUM=$P(NODE,U,3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE_U_DEN_U_NUM
 D S^BGPMUDEL(X,1,1)
 Q
CALCS(N,CMP,PMP,BMP) ;
 S CMP=$FN($S(@("CDEN"_N_"CT")>0:$$ROUND^BGPMUA01((@("CNUM"_N_"CT")/@("CDEN"_N_"CT")),3)*100,1:0),",",1)
 S PMP=$FN($S(@("PDEN"_N_"CT")>0:$$ROUND^BGPMUA01((@("PNUM"_N_"CT")/@("PDEN"_N_"CT")),3)*100,1:0),",",1)
 S BMP=$FN($S(@("BDEN"_N_"CT")>0:$$ROUND^BGPMUA01((@("BNUM"_N_"CT")/@("BDEN"_N_"CT")),3)*100,1:0),",",1)
 Q
CALCSWO(N,CMP,PMP,BMP) ;
 S CMP=$FN($S(@("CDEN"_N_"CT")>0:$$ROUND^BGPMUA01(((@("CDEN"_N_"CT")-@("CNUM"_N_"CT"))/@("CDEN"_N_"CT")),3)*100,1:0),",",1)
 S PMP=$FN($S(@("PDEN"_N_"CT")>0:$$ROUND^BGPMUA01(((@("PDEN"_N_"CT")-@("PNUM"_N_"CT"))/@("PDEN"_N_"CT")),3)*100,1:0),",",1)
 S BMP=$FN($S(@("BDEN"_N_"CT")>0:$$ROUND^BGPMUA01(((@("BDEN"_N_"CT")-@("BNUM"_N_"CT"))/@("BDEN"_N_"CT")),3)*100,1:0),",",1)
 Q
NEW ;NEW all variables for timeframe
 F BGPI=1:1:12 N @(TF_"EXC"_BGPI_"CT")
 F BGPI=1:1:12 N @(TF_"DEN"_BGPI_"CT")
 F BGPI=1:1:12 N @(TF_"NUM"_BGPI_"CT")
 Q
LOAD ;Load variables from TMP global
 S @(TF_"TOTALS")=$G(^TMP("BGPMU0038",$J,TF,"TOT"))
 ;exclusion counts
 F BGPI=1:1:12 S @(TF_"EXC"_BGPI_"CT")=+$G(^TMP("BGPMU0038",$J,TF,"EXC",BGPI))
 ;denominator counts
 F BGPI=1:1:12 S @(TF_"DEN"_BGPI_"CT")=+$G(^TMP("BGPMU0038",$J,TF,"DEN",BGPI))
 ;numerator counts
 F BGPI=1:1:12 S @(TF_"NUM"_BGPI_"CT")=+$G(^TMP("BGPMU0038",$J,TF,"NUM",BGPI))
 Q
KILL ;KILL all varables for timeframe
 F BGPI=1:1:12 N @(TF_"EXC"_BGPI_"CT")
 F BGPI=1:1:12 N @(TF_"DEN"_BGPI_"CT")
 F BGPI=1:1:12 N @(TF_"NUM"_BGPI_"CT")
 Q
XML38 ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 ;F BGPI=1:1:12 S BGPXML(BGPI)="1"_U_BGPI_U_+$G(^TMP("BGPMU0038",$J,"C","DEN",BGPI))_U_+$G(^TMP("BGPMU0038",$J,"C","NUM",BGPI))_U_+$G(^TMP("BGPMU0038",$J,"C","EXC",BGPI))
 S BGPXML(1)="240"_U_""_U_+$G(^TMP("BGPMU0038",$J,"C","DEN",12))_U_+$G(^TMP("BGPMU0038",$J,"C","NUM",12))_U_+$G(^TMP("BGPMU0038",$J,"C","EXC",12))
 K ^TMP("BGPMU0038",$J)
 Q
ITEXT ;
 ;;4 DTaP
 ;;3 IPV
 ;;1 MMR
 ;;3 HiB
 ;;3 HepB
 ;;1 VZV
 ;;4 Pneumococcal
 ;;2 HepA
 ;;2 Rotavirus
 ;;2 Influenza
 ;;4:3:1:3:3:1
 ;;4:3:1:3:3:1:4
NTEXT ;
 ;;# w/4 DTaP
 ;;# w/3 IPV
 ;;# w/1 MMR
 ;;# w/3 HiB
 ;;# w/3 Hep B
 ;;# w/1 VZV
 ;;# w/4 Pneumococcal
 ;;# w/2 Hep A
 ;;# w/2 Rotavirus
 ;;# w/2 Influenza
 ;;# w/1-6 (4:3:1:3:3:1)
 ;;# w/1-7 (4:3:1:3:3:1:4)
OTEXT ;
 ;;# w/o 4 DTaP
 ;;# w/o 3 IPV
 ;;# w/o 1 MMR
 ;;# w/o 3 HiB
 ;;# w/o 3 Hep B
 ;;# w/o 1 VZV
 ;;# w/o 4 Pneumococcal
 ;;# w/o 2 Hep A
 ;;# w/o 2 Rotavirus
 ;;# w/o 2 Influenza
 ;;# w/o 1-6 (4:3:1:3:3:1)
 ;;# w/o 1-7 (4:3:1:3:3:1:4)
LITEXT ;
 ;;1: 4 DTaP Patients
 ;;2: 3 IPV Patients
 ;;3: 1 MMR Patients
 ;;4: 3 HiB Patients
 ;;5: 3 Hepatitis B Patients
 ;;6: 1 VZV Patients
 ;;7: 4 Pneumococcal Patients
 ;;8: 2 Hepatitis A Patients
 ;;9: 2 Rotavirus Patients
 ;;10: 2 Influenza Patients
 ;;11: 4:3:1:3:3:1 Patients
 ;;12: 4:3:1:3:3:1:4 Patients
 ;;
 ;;DTAP numerator patients
 ;;IPV numerator patients
 ;;MMR numerator patients
 ;;HiB numerator patients
 ;;HepB numerator patients
 ;;VZV numerator patients
 ;;Pneumo numerator patients
 ;;HepA numerator patients
 ;;Rotavirus numerator patients
 ;;Influenza numerator patients
 ;;Numerator patients for 1 thru 6
 ;;Numerator patients for 1 thru 7
LNTEXT ;
 ;;Denominator patients not in numerator for DTAP
 ;;Denominator patients not in numerator for IPV
 ;;Denominator patients not in numerator for MMR
 ;;Denominator patients not in numerator for HiB
 ;;Denominator patients not in numerator for Hep B
 ;;Denominator patients not in numerator for VZV
 ;;Denominator patients not in numerator for Pneumococcal
 ;;Denominator patients not in numerator for Hep A
 ;;Denominator patients not in numerator for Rotavirus
 ;;Denominator patients not in numerator for Influenza
 ;;Denominator patients not in numerator for 1 thru 6
 ;;Denominator patients not in numerator for 1 thru 7
LETEXT ;
 ;;Exclusion patients for DTAP
 ;;Exclusion patients for IPV
 ;;Exclusion patients for MMR
 ;;Exclusion patients for HiB
 ;;Exclusion patients for Hep B
 ;;Exclusion patients for VZV
 ;;Exclusion patients for Pneumococcal
 ;;Exclusion patients for Hep A
 ;;Exclusion patients for Rotavirus
 ;;Exclusion patients for Influenza
 ;;Exclusion patients for 1 thru 6
 ;;Exclusion patients for 1 thru 7
