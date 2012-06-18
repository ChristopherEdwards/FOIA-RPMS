BKMSUPP1 ;PRXM/HC/WOM - Continuation of BKMSUPP, HIV SUPPLEMENT; [ 1/19/2005 7:16 PM ] ; 10 Jun 2005  12:31 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
CD4(DFN) ;EP - Retrieve CD4 taxonomies
 W ?1,"Last 6 CD4: "
 ;Retrieve CD4 taxonomies
 K BKMT("CD4"),BKMT("CD4ABS")
 S GLOBAL="BKMT(""CD4"",VSTDT\1,""ALL"",VSTDT,TEST)"
 D LABTAX^BKMIXX(DFN,"BGP CD4 TAX","","",GLOBAL)
 D LOINC^BKMIXX(DFN,"BGP CD4 LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""CD4"",VSTDT\1,""ALL"",VSTDT,TEST)"
 D CPTTAX^BKMIXX(DFN,"BGP CD4 CPTS","","",GLOBAL)
 ;Retrieve CD4 ABS taxonomies
 S GLOBAL="BKMT(""CD4"",VSTDT\1,""ABS"",VSTDT,TEST)"
 D LABTAX^BKMIXX(DFN,"BKMV CD4 ABS TESTS TAX","","",GLOBAL)
 D LOINC^BKMIXX(DFN,"BKMV CD4 ABS LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""CD4"",VSTDT\1,""ABS"",VSTDT,TEST)"
 D CPTTAX^BKMIXX(DFN,"BKMV CD4 ABS CPTS","","",GLOBAL)
 ;
 ;Print 6 most recent results - ABS should be listed in preference to All
 ;When printing ABS list results - none should be listed for All
 ;Only one result per day should be printed (consistent with Flow Sheet)
 ;
 N MAX,LDT,CNT,Y,LDTTM,TYPE,RESULT
 S MAX=6,(LDT,CNT)=""
 F  S LDT=$O(BKMT("CD4",LDT),-1) Q:'LDT  D  Q:CNT=MAX!QUIT
 . S Y=$P($$FMTE^XLFDT(LDT,"5Z"),"@"),CNT=CNT+1
 . W ?24,"Date: ",Y
 . I $D(BKMT("CD4",LDT,"ABS")) D
 .. W ?43,"Result: "
 .. S LDTTM="",RESULT=""
 .. F  S LDTTM=$O(BKMT("CD4",LDT,"ABS",LDTTM),-1) Q:LDTTM=""  D  Q:RESULT]""
 ... S TYPE=""
 ... F  S TYPE=$O(BKMT("CD4",LDT,"ABS",LDTTM,TYPE)) Q:TYPE=""  D  Q:RESULT]""
 .... S RESULT=$P(BKMT("CD4",LDT,"ABS",LDTTM,TYPE),U)
 .... I RESULT]"" W $E(RESULT,1,37) Q
 .. ;Only save one result per day for Flow Sheet
 .. I TYPE="" S TYPE=$O(BKMT("CD4",LDT,"ABS",""),-1) ; set TYPE if no results found
 .. S BKMT("CD4ABS",LDT,TYPE,"ABS")=RESULT
 . K BKMT("CD4",LDT)
 . I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW) Q
 . I CNT<MAX,$O(BKMT("CD4",LDT),-1) W !
 K BKMT("CD4")
 ;Q:QUIT!CNT
 Q:QUIT
 I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER(.PAGE,XNOW)
 W !!
 ;BKMT("CD4ABS") is later used for the Flow Sheet
 Q
VIRAL(DFN) ;EP - Retrieve Viral taxonomies
 I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER(.PAGE,XNOW)
 W ?1,"Last 6 HIV/RNA Viral Load: ",!
 ;Retrieve Viral Load taxonomies
 K BKMT("VL")
 S GLOBAL="BKMT(""VL"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BGP HIV VIRAL LOAD TAX","","",GLOBAL)
 D LOINC^BKMIXX(DFN,"BGP VIRAL LOAD LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""VL"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BGP HIV VIRAL LOAD CPTS","","",GLOBAL)
 D LTAXPRT("VL",6,1,"","","",1)
 Q:QUIT
 W !
 ;BKMT("VL") is later used for the Flow Sheet
 Q
 ;
RPR(DFN) ;EP - Retrieve RPR taxonomies
 W ?1,"RPR: "
 K BKMT("RPR")
 S GLOBAL="BKMT(""RPR"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM RPR TAX","","",GLOBAL) ;***
 D LOINC^BKMIXX(DFN,"BKM RPR LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""RPR"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKM RPR CPTS","","",GLOBAL)
 ;Print results
 D LTAXPRT("RPR",1,1)
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("RPR")) D
 .S GLOBAL="BKMT(""RPR"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BKM RPR TAX","","",GLOBAL) ;taxonomy not loaded yet
 .D REFUSAL^BKMIXX2(DFN,60,"BKM RPR LOINC CODES","","",GLOBAL)
 .;Print results
 .D LTAXPRT("RPR",1,1,1)
 K BKMT("RPR")
 Q
PAP(DFN) ;EP - Retrieve PAP taxonomies
 ;Q:$P(^DPT(DFN,0),U,2)'="F"  ; - removed and replaced with N/A as per IHS
 W !?1,"PAP: "
 I $P(^DPT(DFN,0),U,2)'="F" W "Not Applicable" Q  ;Females only
 K BKMT("PAP")
 S GLOBAL="BKMT(""PAP"",VSTDT,""LAB"",TEST)"
 D LABTAX^BKMIXX(DFN,"BGP PAP SMEAR TAX","","",GLOBAL)
 D LOINC^BKMIXX(DFN,"BGP PAP LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""PAP"",VSTDT,""CPT"",TEST)"
 D CPTTAX^BKMIXX(DFN,"BGP CPT PAP","","",GLOBAL)
 S GLOBAL="BKMT(""PAP"",VSTDT,""ICD"",TEST)"
 D ICDTAX^BKMIXX1(DFN,"BGP PAP ICDS","","",GLOBAL)
 S GLOBAL="BKMT(""PAP"",VSTDT,""PROC"",TEST)"
 D PRCTAX^BKMIXX1(DFN,"BGP PAP PROCEDURES","","",GLOBAL)
 ;
 N LDT,CNT,Y,TST
 S (LDT,CNT)=""
 F  S LDT=$O(BKMT("PAP",LDT),-1) Q:'LDT  D  Q:CNT!QUIT
 .I $O(BKMT("PAP",LDT,""))="" Q
 .S CNT=1,Y=$P($$FMTE^XLFDT(LDT,"5Z"),"@")
 .W ?24,"Date: ",Y,?43,"Result: "
 .;Only print lab results
 .I $D(BKMT("PAP",LDT,"LAB")) D
 .. S TST=$O(BKMT("PAP",LDT,"LAB",""),-1)
 .. W $E($P(BKMT("PAP",LDT,"LAB",TST),U),1,37) Q
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("PAP")) D
 .S GLOBAL="BKMT(""PAP"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BGP PAP SMEAR TAX","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,60,"BGP PAP LOINC CODES","","",GLOBAL)
 .;Print results
 .D LTAXPRT("PAP",1,1,1)
 K BKMT("PAP")
 Q
CHL(DFN) ;EP - Retrieve Chlamydia taxonomies
 W !?1,"Chlamydia: "
 K BKMT("CHL")
 S GLOBAL="BKMT(""CHL"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BGP CHLAMYDIA TESTS TAX","","",GLOBAL)
 D LOINC^BKMIXX(DFN,"BGP CHLAMYDIA LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""CHL"",VSTDT,TEST,""PROC"")"
 D PRCTAX^BKMIXX1(DFN,"BGP CHLAMYDIA TEST PROCEDURES","","",GLOBAL)
 S GLOBAL="BKMT(""CHL"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BGP CHLAMYDIA CPTS","","",GLOBAL)
 ;Print results
 D LTAXPRT("CHL",1,1)
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("CHL")) D
 .S GLOBAL="BKMT(""CHL"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BGP CHLAMYDIA TESTS TAX","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,60,"BGP CHLAMYDIA LOINC CODES","","",GLOBAL)
 .;Print results
 .D LTAXPRT("CHL",1,1,1)
 K BKMT("CHL")
 Q
GON(DFN) ;EP - Retrieve Gonorrhea taxonomies
 W !?1,"Gonorrhea: "
 K BKMT("GON")
 S GLOBAL="BKMT(""GON"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM GONORRHEA TEST TAX","","",GLOBAL) ;***
 D LOINC^BKMIXX(DFN,"BKM GONORRHEA LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""GON"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKM GONORRHEA TESTS CPTS","","",GLOBAL)
 ;Print results
 D LTAXPRT("GON",1,1)
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("GON")) D
 .S GLOBAL="BKMT(""GON"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BKM GONORRHEA LOINC CODES","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM GONORRHEA TEST TAX","","",GLOBAL)
 .;Print results
 .D LTAXPRT("GON",1,1,1)
 K BKMT("GON")
 Q
CMV(DFN) ;EP - Retrieve CMV taxonomies
 W !?1,"CMV: "
 K BKMT("CMV")
 S GLOBAL="BKMT(""CMV"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM CMV TEST TAX","","",GLOBAL) ;***
 D LOINC^BKMIXX(DFN,"BKM CMV LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""CMV"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKM CMV TEST CPTS","","",GLOBAL)
 ;Print results
 D LTAXPRT("CMV",1,1)
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("CMV")) D
 .S GLOBAL="BKMT(""CMV"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BKM CMV LOINC CODES","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM CMV TEST TAX","","",GLOBAL)
 .;Print results
 .D LTAXPRT("CMV",1,1,1)
 K BKMT("CMV")
 Q
TOX(DFN) ;EP - Retrieve Toxoplasmosis taxonomies
 W !?1,"Toxoplasmosis: "
 K BKMT("TOX")
 S GLOBAL="BKMT(""TOX"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM TOXOPLASMOSIS TESTS TAX","","",GLOBAL) ;***
 D LOINC^BKMIXX(DFN,"BKM TOXOPLASMOSIS LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""TOX"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKM TOXOPLASMOSIS CPTS","","",GLOBAL)
 ;Print results
 D LTAXPRT("TOX",1,1)
 Q:QUIT
 ;If no results found check refusal file
 I '$D(BKMT("TOX")) D
 .S GLOBAL="BKMT(""TOX"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BKM TOXOPLASMOSIS LOINC CODES","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM TOXOPLASMOSIS TESTS TAX","","",GLOBAL)
 .;Print results
 .D LTAXPRT("TOX",1,1,1)
 K BKMT("TOX")
 Q
COC(DFN) ;EP - Retrieve Cocci taxonomies
 W !?1,"Cocci: "
 K BKMT("COC")
 S GLOBAL="BKMT(""COC"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM COCCI ANTIBODY TAX","","",GLOBAL) ;***
 D LOINC^BKMIXX(DFN,"BKM COCCI ANTIBODY LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""COC"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKM COCCI ANTIBODY CPTS","","",GLOBAL)
 ;Print results
 I $D(BKMT("COC")) D LTAXPRT("COC",1,1) Q
 ;Check refusals
 S GLOBAL="BKMT(""COC"",VSTDT,TEST,""LAB"")"
 D REFUSAL^BKMIXX2(DFN,60,"BKM COCCI ANTIBODY LOINC CODES","","",GLOBAL)
 D REFUSAL^BKMIXX2(DFN,60,"BKM COCCI ANTIBODY TAX","","",GLOBAL)
 ;Print results
 D LTAXPRT("COC",1,1,1)
 K BKMT("COC")
 Q
PPD(DFN) ;EP - Retrieve PPD taxonomies (T.21)
 W !?1,"PPD: "
 K BKMT("PPD")
 S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKM PPD TAX","","",GLOBAL) ;***
 D LOINC^BKMIXX(DFN,"BKM PPD LOINC CODES","","",GLOBAL)
 S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKM PPD CPTS","","",GLOBAL)
 S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""CVX"")"
 D CVXTAX^BKMIXX1(DFN,"BKM PPD CVX CODES","","",GLOBAL)
 I $D(BKMT("PPD")) D LTAXPRT("PPD",1,1)
 Q:QUIT
 I '$D(BKMT("PPD")) D  Q:QUIT
 .;If patient had no PPD T.21 in Labs, also check Skin Tests.
 .S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""SKIN"")"
 .D SKNTAX^BKMIXX1(DFN,"21","","",GLOBAL)
 .;Following code was modified to display Result and Reading in that order
 .I $D(BKMT("PPD")) D  Q
 ..N BKMTL
 ..S BKMTL="BKMT(""PPD"")"
 ..F  S BKMTL=$Q(@BKMTL) Q:$P(BKMTL,",")'="BKMT(""PPD"""  D
 ... I $P(@BKMTL,U,2)]"" S @BKMTL=$P(@BKMTL,U,2)_" "_$P(@BKMTL,U)
 ..D LTAXPRT("PPD",1,1)
 .;If nothing found check diagnosis taxonomy BKM PPD ICDS and include the text "(by Diagnosis)"
 .S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""ICD"")"
 .D ICDTAX^BKMIXX1(DFN,"BKM PPD ICDS","","",GLOBAL)
 .I $D(BKMT("PPD")) D LTAXPRT("PPD",1,1,"",""," (by Diagnosis)") Q
 .;Check refusals
 .S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""LAB"")"
 .D REFUSAL^BKMIXX2(DFN,60,"BKM PPD LOINC CODES","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,60,"BKM PPD TAX","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,9999999.14,"BKM PPD CVX CODES","","",GLOBAL)
 .D REFUSAL^BKMIXX2(DFN,9999999.28,"21","","",GLOBAL)
 .;Print results
 .D LTAXPRT("PPD",1,1,1)
 K BKMT("PPD") Q:QUIT
 Q
PHENO(DFN) ;EP - Retrieve HIV Phenotype Taxonomies (T.16)
 W !?1,"HIV Phenotype: "
 K BKMT("PHENO")
 S GLOBAL="BKMT(""PHENO"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKMV HIV PHENOTYPE TESTS TAX","","",GLOBAL)
 S GLOBAL="BKMT(""PHENO"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKMV HIV PHENOTYPE CPTS","","",GLOBAL)
 ;Print results
 I $D(BKMT("PHENO")) D LTAXPRT("PHENO",1,1) Q
 K BKMT("PHENO")
 Q
GENO(DFN) ;EP - Retrieve HIV Genotype Taxonomies
 W !?1,"HIV Genotype: "
 K BKMT("GENO")
 S GLOBAL="BKMT(""GENO"",VSTDT,TEST,""LAB"")"
 D LABTAX^BKMIXX(DFN,"BKMV HIV GENOTYPE TESTS TAX","","",GLOBAL)
 S GLOBAL="BKMT(""GENO"",VSTDT,TEST,""CPT"")"
 D CPTTAX^BKMIXX(DFN,"BKMV HIV GENOTYPE CPTS","","",GLOBAL)
 ;Print results
 I $D(BKMT("GENO")) D LTAXPRT("GENO",1,1) Q
 K BKMT("GENO")
 Q
HEADER(PAGE,XNOW) ;EP - Print the header
 I PAGE=1 S $X=0
 E  W @IOF
 W !?1,$$CONF(""),!?(IOM-41\2),"****** HMS PATIENT CARE SUPPLEMENT ******"
 W !!?1,"Report Date: ",XNOW,?69,"Page: ",PAGE,!!
 S PAGE=PAGE+1
 Q
CONF(END) ;EP - Print confidential message
 ;END is set if final page and ending message is being printed.
 N X,Y,TIM,AP,HDR
 S Y=$$FMTE^XLFDT($$NOW^XLFDT()) S TIM=$P(Y,"@",2)
 S AP="AM" S:+TIM>12 TIM=TIM-12_":"_$P(TIM,":",2),AP="PM" S TIM=TIM_" "_AP
 ;***** CONFIDENTIAL PATIENT INFORMATION --  DATE/TIME **************
 S HDR="CONFIDENTIAL PATIENT INFORMATION -- "_$$FMTE^XLFDT(DT,"5Z")_" "_$J(TIM,9)_"  ["_$P(^VA(200,DUZ,0),U,2)_"]"
 S X="",$P(X,"*",((IOM-6-$L(HDR))\2)+1)="*"
 S HDR=$S($G(END):$E("**** END *",$L(X)-4,12),1:X)_" "_HDR_" "_X
 Q HDR
LTAXPRT(TYP,MAX,RES,REF,TBEF,TAFT,ONE) ;EP - Print lab related taxonomies for a patient
 ;TYP = Type of test (subscript in BKMT array)
 ;MAX = Maximum number of results to print
 ;$G(RES)=1 - Print results
 ;TBEF = text before
 ;REF = Refusal flag
 ;TAFT = text after
 ;ONE = Only display one result per day
 N LDT,CNT,Y,TST,TYPE,END
 S MAX=$G(MAX,1),REF=$G(REF),ONE=$G(ONE),RES=$G(RES)
 S (LDT,CNT)=""
 F  S LDT=$O(BKMT(TYP,LDT),-1) Q:'LDT  D  Q:CNT>MAX!QUIT
 .S Y=$P($$FMTE^XLFDT(LDT,"5Z"),"@")
 .I RES,'ONE,'REF D GETRES(TYP,LDT)
 .I ONE D ONERES(TYP,LDT)
 .S TST=""
 .F  S TST=$O(BKMT(TYP,LDT,TST)) Q:TST=""  D  Q:CNT>MAX!QUIT
 .. S TYPE=""
 .. F  S TYPE=$O(BKMT(TYP,LDT,TST,TYPE)) Q:TYPE=""  S CNT=CNT+1 Q:CNT>MAX  D  Q:QUIT
 ...W ?24,"Date: ",Y
 ...I RES D
 ....W ?41
 ....I $G(TBEF)]"" W TBEF
 ....I REF W "[Refusal type: ",$E($P(BKMT(TYP,LDT,TST,TYPE),U),1,37),"]"
 ....E  W "Result: ",$E($P(BKMT(TYP,LDT,TST,TYPE),U),1,37)
 ....I $G(TAFT)]"" W TAFT
 ....I CNT<MAX W !
 ....I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER^BKMSUPP1(.PAGE,XNOW)
 ...I 'RES,CNT<MAX D
 .... I $O(BKMT(TYP,LDT),-1)!($O(BKMT(TYP,LDT,TST,TYPE))]"")!($O(BKMT(TYP,LDT,TST))]"") W !
 Q:QUIT!CNT
 I $Y>MAXCT S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT  D HEADER(.PAGE,XNOW)
 Q
 ;
ONERES(TYP,LDT) ;Pare down array to the one entry to be displayed
 N STOP,TST,TYPE,RES,LDTTM
O1 S (STOP,TST)=""
 F  S TST=$O(BKMT(TYP,LDT,TST)) Q:TST=""  D  Q:STOP
 . S TYPE=""
 . F  S TYPE=$O(BKMT(TYP,LDT,TST,TYPE)) Q:TYPE=""  D  Q:STOP
 .. S RES=BKMT(TYP,LDT,TST,TYPE)
 .. I $P(RES,U)'="" D  S STOP=1 Q
 ... K BKMT(TYP,LDT) S BKMT(TYP,LDT,TST,TYPE)=RES
 ... ;Remove other entries for this date
 ... S LDTTM=LDT
 ... F  S LDTTM=$O(BKMT(TYP,LDTTM),-1) Q:LDTTM\1'=(LDT\1)  K BKMT(TYP,LDTTM)
 Q:STOP
 ;Check remaining entries on this date for results
 S LDTTM=$O(BKMT(TYP,LDT),-1)
 I LDTTM\1=(LDT\1) K BKMT(TYP,LDT) S LDT=LDTTM G O1
 ;No results found - save one entry
 S TST=$O(BKMT(TYP,LDT,"")) Q:TST=""
 S TYPE=$O(BKMT(TYP,LDT,TST,"")) Q:TYPE=""
 S RES=$G(BKMT(TYP,LDT,TST,TYPE))
 K BKMT(TYP,LDT) S BKMT(TYP,LDT,TST,TYPE)=RES
 Q
 ;
GETRES(TYP,LDT) ;If more than one entry/day get entry with result
 N TEST,LPEND
 S LPEND="BKMT("""_TYP_""","_LDT,TEST=LPEND_")"
 ;Loop through entries for the date and remove any tests w/o results until you either
 ;find a test with a result or get to the last test for the date
 F  S TEST=$Q(@TEST) Q:$P(TEST,",",1,2)'=LPEND  Q:@TEST]""  D
 . ;If this isn't the last test for the date and there is no result remove it
 . I $P($Q(@TEST),",",1,2)=LPEND K @TEST
 Q
 ;
XIT ;QUIT POINT
 Q
