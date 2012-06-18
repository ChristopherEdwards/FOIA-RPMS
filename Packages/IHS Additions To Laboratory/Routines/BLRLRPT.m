BLRLRPT ; IHS/OIT/MPW - LOINC Mapping to File 60 Tests ; [ JUN 29, 2010  ]
 ;;5.2;IHS LABORATORY;**1028**;NOV 01, 1997;Build 46
 ;;This routine prints reports for tests in File 60 that are mapped or not mapped to LOINC.
 ;
 ; Temporary Globals
 ; -----------------
 ; ^XTMP("BLRLRPT","LOINC")      - Holds mapped tests
 ; ^XTMP("BLRLRPT","NO LOINC")   - Holds non-mapped tests
 ;
 ; Local Variables
 ; ---------------
 ; ACNT  - Counter of all ACTIVE tests in File 60
 ; CCNT  - Counter of tests mapped to C80 LOINC codes
 ; CNT   - Counter of all tests (active and inactive) in File 60
 ; D0    - Test IEN from File 60
 ; D1    - Specimen IEN from File 60
 ; GCNT  - Counter of C80 LOINC codes mapped to File 60
 ; ICNT  - Counter of IHS(non-specimen) LOINC codes
 ; LCNT  - Counter of specimen-specific LOINC codes
 ; LOINC - LOINC code
 ; NAME  - Test name from File 60
 ; NCNT  - Counter of tests w/o LOINC codes
 ; NSPEC - Counter of tests w/o specimens (includes cosmic)
 ; PCNT  - Counter of cosmic tests w/o LOINC codes
 ; SCNT  - Counter of all specimens in File 60
 ; SPNM  - Specimen name from File 61, defaults to SPECXXX
 ; UNITS - Units from File 60, defaults to UNITXXX
 ; ZCNT  - Counter of inactive tests in File 60, not mapped
 ;
 ;Must enter via proper tag/menu option
 Q
 ;
PRNT ; Print File 60 tests mapped/not mapped to LOINC code
 ;
 ; Reset temporary globals
 K ^XTMP("BLRLRPT")
 ;
 ; Initialize variables
 N ACNT,CNT,CCNT,GCNT,ICNT,LCNT,NCNT,NSPEC,PCNT,SCNT,SPN,ZCNT
 N HDR,HDR1,HDR2,HDR3,LOINC,NAME,NOW,Q,Q1,R,R1,SPNM,UDL,UNITS
 D INIT
 ;
 S HDR="Print Lab Tests Mapped/Not Mapped to LOINC Codes" D HDR
 W !!,"1. Print Tests Mapped to LOINC"
 W !,"2. Print Tests NOT Mapped to LOINC"
 W !!,"Enter selection # or '^' to quit: " R R:30 Q:R="^"!(R="")
 I "1 2"'[R W !!,"Invalid Entry" H 2 G PRNT
 S OPT="OPT"_R D @OPT
 ;
 K ACNT,CNT,CCNT,GCNT,HDR,HDR1,HDR2,HDR3,ICNT,LCNT,LOINC,NAME,NCNT,NSPEC,NOW,PCNT,Q,Q1,R,R1,SCNT,SPN,SPNM,UDL,UNITS,ZCNT
 Q
 ;
OPT1 ; Print Lab Tests Mapped to LOINC Codes
 ;
 ;Gather data from File 60
 F  S D0=$O(^LAB(60,D0)) Q:Q1!(D0'=+D0)  D
 .S CNT=CNT+1,NAME=$P(^LAB(60,D0,0),U,1),TYP=$P(^LAB(60,D0,0),U,3)
 .;Don't report inactive tests
 .I $E(NAME,1,2)="ZZ"!($E(NAME,1,2)="zz") S ZCNT=ZCNT+1 Q
 .S ACNT=ACNT+1
 .I $O(^LAB(60,D0,1,0))="" S NSPEC=NSPEC+1 I $D(^LAB(60,D0,9999999)),$P(^LAB(60,D0,9999999),U,2)'="" D
 ..S NAME=$S($O(^LAB(60,D0,2,0))'="":NAME_" (PANEL)",1:NAME_" ("_$P(^LAB(60,D0,0),U,4)_")")
 ..S ICNT=ICNT+1,LOINC=$P(^LAB(60,D0,9999999),U,2)
 ..S ^XTMP("BLRLRPT","LOINC","IHS",NAME)=LOINC_"-"_$P(^LAB(95.3,LOINC,0),U,15)
 ..Q
 .I $O(^LAB(60,D0,1,0))'="" S D1=0 D
 ..F  S D1=$O(^LAB(60,D0,1,D1)) Q:D1=""!(D1'=+D1)  D
 ...S SCNT=SCNT+1,SPNM=$S($D(^LAB(61,D1,0)):$P(^LAB(61,D1,0),U,1),1:"SPECXXX")
 ...S UNITS=$P(^LAB(60,D0,1,D1,0),U,7) I UNITS="" S UNITS="UNITXXX"
 ...I $G(^LAB(60,D0,1,D1,95.3))'="" S LCNT=LCNT+1,LOINC=$G(^LAB(60,D0,1,D1,95.3)),^XTMP("BLRLRPT","LOINC",NAME,SPNM,UNITS)=LOINC_"-"_$P(^LAB(95.3,LOINC,0),U,15)
 ...Q
 ..Q
 .Q
 ;
 ;Print results
 S DIR(0)="Y",DIR("A")="Ready to capture output to a file",DIR("B")="Y"
 D ^DIR K DIR
 S R1=+Y
 D ^XBCLS
 S HDR="FILE 60 TESTS WITH LOINC CODES"
 S HDR1=$G(NOW)
 S HDR2="TEST NAME                       SPECIMEN      UNITS                   LOINC"
 S HDR3="================================================================================"
 W !!,$$CJ^XLFSTR(HDR,IOM)
 S PG=PG+1 W !,?5,HDR1,?70,"PAGE: ",PG
 W !!,HDR2,!,HDR3
 S NAME=""
 F  S NAME=$O(^XTMP("BLRLRPT","LOINC",NAME)) Q:NAME=""!Q1  D
 .I 'R1,$Y>20 D CR Q:Q1  W !,$$CJ^XLFSTR(HDR,IOM) S PG=PG+1 W !,?5,HDR1,?70,"PAGE: ",PG,!!,HDR2,!,HDR3
 .I R1,$Y>56 S $Y=0,PG=PG+1 W !,$$CJ^XLFSTR(HDR,IOM),!,?5,HDR1,?70,"PAGE: ",PG,!!,HDR2,!,HDR3
 .I $D(^XTMP("BLRLRPT","LOINC",NAME))=1 S LOINC=$G(^XTMP("BLRLRPT","LOINC",NAME)) W !,NAME,?70,LOINC,!,?2,$G(^LAB(95.3,LOINC,80)),! Q
 .S SPNM="" F  S SPNM=$O(^XTMP("BLRLRPT","LOINC",NAME,SPNM)) Q:SPNM=""  D
 ..S UNITS=""  F  S UNITS=$O(^XTMP("BLRLRPT","LOINC",NAME,SPNM,UNITS)) Q:UNITS=""  D
 ...S LOINC=$G(^XTMP("BLRLRPT","LOINC",NAME,SPNM,UNITS)),LNC=$P(LOINC,"-",1) W !,NAME,?32,$E(SPNM,1,12),?46,UNITS,?70,LOINC
 ...S REC=$O(^BLSLMAST("C",LNC,"")) Q:REC=""  S SRC=$G(^BLSLMAST(REC,11)) Q:SRC=""  I SRC="C80" W "*" S CCNT=CCNT+1 S:'$D(^XTMP("BLRLRPT","C80",LOINC)) GCNT=GCNT+1,^XTMP("BLRLRPT","C80",LOINC)=""
 ...W !,?2,$G(^LAB(95.3,LNC,80)),!
 ...Q
 ..Q
 .Q
 ;Print any non-specimen LOINCed tests
 I $D(^XTMP("BLRLRPT","LOINC","IHS"))&('Q1) D
 .D ^XBCLS
 .S HDR2="TEST NAME (CATAGORY)            LOINC"
 .S HDR3="================================================================================"
 .W !!,$$CJ^XLFSTR(HDR,IOM)
 .S PG=PG+1 W !,?5,HDR1,?70,"PAGE: ",PG
 .W !!,HDR2,!,HDR3
 .S NAME="" F  S NAME=$O(^XTMP("BLRLRPT","LOINC","IHS",NAME)) Q:NAME=""!(Q1)  D
 ..S LOINC=$G(^XTMP("BLRLRPT","LOINC","IHS",NAME)),LNC=$P(LOINC,"-",1)
 ..I 'R1,$Y>20 D CR Q:Q1  W !,$$CJ^XLFSTR(HDR,IOM) S PG=PG+1 W !,?5,HDR1,?70,"PAGE: ",PG,!!,HDR2,!,HDR3
 ..I R1,$Y>56 S $Y=0,PG=PG+1 W !,$$CJ^XLFSTR(HDR,IOM),!,?5,HDR1,?70,"PAGE: ",PG,!!,HDR2,!,HDR3
 ..W !,NAME,?32,LOINC,!,?2,$G(^LAB(95.3,LNC,80)),!
 ..Q
 .Q
 ;Print summary
 W !!,$J(CNT,6)," Total Active/Inactive Tests in File 60"
 W !,$J(ZCNT,6)," INACTIVE Tests (",$E(ZCNT/CNT*100,1,5),"%) Will NOT be Mapped"
 ;
 W !!,$J(ACNT-NSPEC,6)," Active Tests with ",SCNT," Specimens in File 60"
 W !,$J(NSPEC,6)," Active Tests w/o Specimens in File 60"
 W !,$J(SCNT+NSPEC,6)," Total Entries to Map in File 60"
 ;
 W !!,$J(LCNT,6)," Tests w/ Specimens (",$E(LCNT/SCNT*100,1,5),"%) Mapped"
 W !,$J(ICNT,6)," Tests w/o Specimens (",$E(ICNT/NSPEC*100,1,5),"%) Mapped"
 W !,$J(LCNT+ICNT,6)," Total Entries (",$E((LCNT+ICNT)/(SCNT+NSPEC)*100,1,5),"%) Mapped"
 ;
 W !!,$J(CCNT,6)," Entries (",$E(CCNT/ACNT*100,1,5),"%) Mapped to C80 LOINC Codes"
 W !,$J(GCNT,6)," C80 LOINC Codes (",$E(GCNT/290*100,1,5),"%) Mapped to File 60"
 Q
 ;
OPT2 ; Print Lab Tests NOT Mapped to LOINC Codes
 ;
 ;Gather data from File 60
 F  S D0=$O(^LAB(60,D0)) Q:Q1!(D0'=+D0)  D
 .S CNT=CNT+1,NAME=$P(^LAB(60,D0,0),U,1),TYP=$P(^LAB(60,D0,0),U,3)
 .;Don't report inactive tests
 .I $E(NAME,1,2)="ZZ"!($E(NAME,1,2)="zz") S ZCNT=ZCNT+1 Q
 .S ACNT=ACNT+1
 .I $O(^LAB(60,D0,1,0))="" S NSPEC=NSPEC+1 D
 ..I '$D(^LAB(60,D0,9999999)) D
 ...S NAME=$S($O(^LAB(60,D0,2,0))'="":NAME_" (PANEL)",1:NAME_" ("_$P(^LAB(60,D0,0),U,4)_")")
 ...S PCNT=PCNT+1,^XTMP("BLRLRPT","NO LOINC",NAME)=""
 ...Q
 ..I $D(^LAB(60,D0,9999999)),$P(^LAB(60,D0,9999999),U,2)="" D
 ...S NAME=$S($O(^LAB(60,D0,2,0))'="":NAME_" (PANEL)",1:NAME_" ("_$P(^LAB(60,D0,0),U,4)_")")
 ...S PCNT=PCNT+1,^XTMP("BLRLRPT","NO LOINC",NAME)=""
 ...Q
 ..Q
 .I $O(^LAB(60,D0,1,0))'="" S D1=0 D
 ..F  S D1=$O(^LAB(60,D0,1,D1)) Q:D1=""!(D1'=+D1)  D
 ...S SCNT=SCNT+1,SPNM=$S($D(^LAB(61,D1,0)):$P(^LAB(61,D1,0),U,1),1:"SPECXXX")
 ...S UNITS=$P(^LAB(60,D0,1,D1,0),U,7) I UNITS="" S UNITS="UNITXXX"
 ...I $G(^LAB(60,D0,1,D1,95.3))="" S NCNT=NCNT+1,^XTMP("BLRLRPT","NO LOINC",NAME,SPNM,UNITS)=""
 ...Q
 ..Q
 .Q
 ;
 ;Print results
 S DIR(0)="Y",DIR("A")="Ready to capture output to a file",DIR("B")="Y"
 D ^DIR K DIR
 S R1=+Y
 D ^XBCLS
 S HDR="FILE 60 TESTS WITHOUT LOINC CODES"
 S HDR1=$G(NOW)
 S HDR2="TEST NAME (CATAGORY)                          SPECIMEN      UNITS"
 S HDR3="================================================================================"
 W !!,$$CJ^XLFSTR(HDR,IOM)
 S PG=PG+1 W !,?5,HDR1,?70,"PAGE: ",PG
 W !!,HDR2,!,HDR3
 S NAME=""
 F  S NAME=$O(^XTMP("BLRLRPT","NO LOINC",NAME)) Q:NAME=""!Q1  D
 .I 'R1,$Y>22 D CR Q:Q1  W !,$$CJ^XLFSTR(HDR,IOM) S PG=PG+1 W !,?5,HDR1,?70,"PAGE:",PG,!!,HDR2,!,HDR3
 .I R1,$Y>57 S $Y=0,PG=PG+1 W !,$$CJ^XLFSTR(HDR,IOM),!,?5,HDR1,?70,"PAGE: ",PG,!!,HDR2,!,HDR3
 .I $D(^XTMP("BLRLRPT","NO LOINC",NAME))=1 W !,NAME Q
 .S SPNM="" F  S SPNM=$O(^XTMP("BLRLRPT","NO LOINC",NAME,SPNM)) Q:SPNM=""  D
 ..S UNITS=$O(^XTMP("BLRLRPT","NO LOINC",NAME,SPNM,"")) W !,NAME,?46,$E(SPNM,1,12),?60,UNITS
 ..Q
 .Q
 ;Print summary
 W !!,$J(CNT,6)," Total Active/Inactive Tests in File 60"
 W !,$J(ZCNT,6)," INACTIVE Tests (",$E(ZCNT/CNT*100,1,5),"%) Will NOT be Mapped"
 ;
 W !!,$J(ACNT-NSPEC,6)," Active Tests with ",SCNT," Specimens in File 60"
 W !,$J(NSPEC,6)," Active Tests w/o Specimens in File 60"
 W !,$J(SCNT+NSPEC,6)," Total Entries to Map in File 60"
 ;
 W !!,$J(NCNT,6)," Tests/Specimens (",$E(NCNT/SCNT*100,1,5),"%) NOT Mapped"
 W !,$J(PCNT,6)," Tests w/o Specimens (",$E(PCNT/NSPEC*100,1,5),"%) NOT Mapped"
 Q
 ;
 ;======================================================================================
 ;
INIT ; Initialize variables
 D ^XBCLS
 S CM=",",(D0,D1,D2,PG,Q,Q1,R1)=0
 S (ACNT,CNT,CCNT,GCNT,ICNT,LCNT,NCNT,NSPEC,PCNT,SCNT,SPN,ZCNT)=0
 S (HDR,HDR1,HDR2,HDR3,LOINC,NAME,R,SPNM,UDL,UNITS)=""
 S NOW=$$HTE^XLFDT($H)
 Q
 ;
HDR ; Print appropriate header
 W !!,$$CJ^XLFSTR(HDR,IOM)
 F I=1:1:$L(HDR) S UDL=UDL_"="
 W !,$$CJ^XLFSTR(UDL,IOM)
 Q
 ;
CR ; Prompt to continue or exit
 ;S DIR(0)="^",DIR("A")="Enter RETURN to continue or '^' to exit"
 ;D ^DIR K DIR
 ;I +Y S Q1=1 Q
 ;S $Y=0 Q
 W !,"Enter RETURN to continue or '^' to exit: " R ANS:30
 I ANS="^" S Q1=1 Q
 I ANS="" S $Y=0 Q
 D CR
 Q
