BLRUCUM ; IHS/OIT/MPW - Link units field in File 60 to UCUM codes ; [ 12/10/2010  4:00 PM ]
 ;;5.2;IHS LABORATORY;**1028**;NOV 01, 1997;Build 46
 ;
 ; This routine goes through the LABORATORY TESTS file (#60) and verifies that the contents of the units field under the 
 ; site/specimen sub-field can be linked to a valid UCUM entry found in a new IHS UCUM file (#90475.3).
 ;
 ; When completed, a summary report displays the outcome of the verification process and the user is prompted to request 
 ; a detailed report of units verified based on either tests or units.
 ; 
 ; Temporary globals for exceptions report:  
 ; ^XTMP("BLRUCUM","ERR","PANEL")  -- Panels without specimens and units
 ; ^XTMP("BLRUCUM","ERR","NSPEC")  -- No specimen found, skipped
 ; ^XTMP("BLRUCUM","ERR","NUNIT")  -- No units found, skipped
 ; ^XTMP("BLRUCUM","ERR","NUCUM")  -- No UCUM equivalent found
 ; 
 ; Temporary globals for results reports:
 ; ^XTMP("BLRUCUM","LOG")=CNT^SPEC, Total numbers of tests and specimens in File 60
 ; ^XTMP("BLRUCUM","LOG","TEST")=TCNT, # of tests that had units verified
 ; ^XTMP("BLRUCUM","LOG","TEST",test,specimen)=units
 ; ^XTMP("BLRUCUM","LOG","UNITS")=OKCNT, total # of units verified
 ; ^XTMP("BLRUCUM","LOG","UNITS",units,UCUM)= # of instances verified for this unit
 ;
 ; Local Variables
 ; ---------------
 ; CNT   - # of tests in File 60
 ; DONE  - Flag = $H completed or 0 if not completed
 ; ETYP  - Exceptions type, branch of ERR global: NSPEC, NUNIT or NUCUM
 ; NAME  - Test name
 ; NCNT  - # of specimens without units (ETYP=NUNIT)
 ; OKCNT - # of units verified and tied to UCUM
 ; RES   - Prompt response
 ; SIEN  - Specimen IEN in File 60
 ; SCNT  - # of tests without specimens (ETYP=NSPEC)
 ; SPEC  - # of specimens in File 60
 ; SPNM  - Specimen description from File 61
 ; SWU   - Specimens with units
 ; TCNT  - Total number of tests with units verified
 ; TIEN  - Test IEN in File 60
 ; UCNT  - # of units with no UCUM equivalent (ETYP=NUCUM)
 ; UNITS - Units stored in each site/specimen node
 ; UCUM  - UCUM formatted units tied to UID in File 90475.3
 ; UID   - IEN of UCUM code in File 90475.3
 ; ZCNT  - # of inactive tests skipped
 ; ===============================================================================================
 ;
 ; Initialize variables
 D INIT
 ;
 ; Print header
 D HDR
 ;
 ; Display message if conversion has already been run
 D:DONE CMP
 ;
 ; Prompt for detailed results, if present
 I $D(^XTMP("BLRUCUM","LOG")) D
 .I DONE W !!,"RESULTS OF UNIT VERIFICATION ARE AVAILABLE"
 .W !!,"Display Detailed Results by Test, Units or Both? (T/U/B): " R RES:30
 .D:RES="T" TRPT D:RES="U" URPT D:RES="B" TRPT,URPT
 .Q
 ;
 S DIR(0)="Y",DIR("A")="Verify Units Linked to UCUM",DIR("B")="N" K DA D ^DIR K DIR
 I 'Y Q
 ;
 ; Reset global and reinitialize variables for verification
 K ^XTMP("BLRUCUM")
 D INIT
 ;
 S TIEN=0 F  S TIEN=$O(^LAB(60,TIEN)) Q:TIEN'=+TIEN  S CNT=CNT+1 W "." D
 .S NAME=$P(^LAB(60,TIEN,0),U,1) I $E(NAME,1,2)="ZZ"!($E(NAME,1,2)="zz") S ZCNT=ZCNT+1 Q
 .I $O(^LAB(60,TIEN,2,0)) S ETYP="PANEL" D ERR Q
 .I $O(^LAB(60,TIEN,1,0))="" S ETYP="NSPEC" D ERR Q
 .S SIEN=0 F  S SIEN=$O(^LAB(60,TIEN,1,SIEN)) Q:SIEN'=+SIEN  D
 ..S SPEC=SPEC+1
 ..S UNITS=$P(^LAB(60,TIEN,1,SIEN,0),U,7),UNITS=$TR(UNITS,QT,""),UNITS=$$TRIMALL(UNITS)
 ..I UNITS="" S ETYP="NUNIT" D ERR Q
 ..I '$D(^BLRUCUM("B",UNITS))&('$D(^BLRUCUM("D",UNITS))) S ETYP="NUCUM" D ERR Q
 ..S UID=$S($D(^BLRUCUM("B",UNITS)):$O(^BLRUCUM("B",UNITS,"")),$D(^BLRUCUM("D",UNITS)):$O(^BLRUCUM("D",UNITS,"")),1:"")
 ..Q:UID=""
 ..S UCUM=$P(^BLRUCUM(UID,0),U,1) D LOG
 ..Q
 .Q
 ; Print completion message
 W !!,"Verification of Units Linked to UCUM Completed"
 S ^XTMP("BLRUCUM","LOG")=CNT_U_SPEC
 S ^XTMP("BLRUCUM","LOG","INACT")=ZCNT
 S ^XTMP("BLRUCUM","LOG","TEST")=TCNT
 S ^XTMP("BLRUCUM","LOG","UNITS")=OKCNT
 S ^XTMP("BLRUCUM","DONE")=$H
 ;
 ; Print summary report
 D SRPT
 ;
 ; Prompt for detailed results report
 I $D(^XTMP("BLRUCUM","LOG")) D
 .W !!,"Display Detailed Results for File 60 by Test, Units or Both? (T/U/B): " R RES:30
 .D:RES="T" TRPT D:RES="U" URPT D:RES="B" TRPT,URPT
 .Q
 ;
 I $D(^XTMP("BLRUCUM","ERR")) D
 .W !!,"Print Exceptions Report? (Y/<N>): " R RES:30 S RES=$S(RES="Y":1,1:0)
 .I RES D ERPT
 .Q
 Q
 ;
INIT ; Clear the screen and initialize variables
 D ^XBCLS
 S U1=":",U2=";",CM=",",QT=""""
 S (CNT,DRPT,OKCNT,PCNT,RES,TCNT,TIEN,SIEN,SPEC,Q,Q1,ZCNT)=0
 S (ETYP,HDR,NAME,SPNM,UCUM,UID,UNITS,UNL)=""
 S TODAY=$$HTFM^XLFDT($H,1)
 S PURGE=$$HTFM^XLFDT($P($H,CM,1)+90,1)
 I '$D(^XTMP("BLRUCUM")) S ^XTMP("BLRUCUM",0)=PURGE_U_TODAY_U_"UCUM VERIFICATION"
 S DONE=+$G(^XTMP("BLRUCUM","DONE"))
 Q
 ;
HDR ; Print header
 S HDR="VERIFY FILE 60 UNITS LINKED TO UCUM"
 S UNL="==================================="
 W !!,$$CJ^XLFSTR(HDR,IOM)
 W !,$$CJ^XLFSTR(UNL,IOM)
 Q
 ;
CMP ; Verification completed display
 S CHDR="Verification of Units Linked to UCUM completed on "_$$HTE^XLFDT(DONE)
 D ^XBON
 W !!,$$CJ^XLFSTR(CHDR,IOM)
 D ^XBOFF
 Q
 ;
CR ;
 S Q1=0
 W !,"Enter RETURN to continue or '^' to exit:" R RES:30
 I RES="^" S Q1=1 Q
 I RES="" S $Y=0 Q
 D CR
 Q
 ;
ERR ; Log exceptions for File 60 verification
 I ETYP="NSPEC"!(ETYP="PANEL") S ^XTMP("BLRUCUM","ERR",ETYP,TIEN)=""
 I ETYP="NUNIT"!(ETYP="NUCUM") S ^XTMP("BLRUCUM","ERR",ETYP,TIEN,SIEN)=$G(UNITS)
 S ^XTMP("BLRUCUM","ERR",ETYP)=+$G(^XTMP("BLRUCUM","ERR",ETYP))+1
 Q
 ;
LOG ; Log tests with units verified, by test,specimen and by units,UCUM
 I '$D(^XTMP("BLRUCUM","LOG","TEST",TIEN)) S TCNT=TCNT+1,^XTMP("BLRUCUM","LOG","TEST")=TCNT
 I '$D(^XTMP("BLRUCUM","LOG","TEST",TIEN,SIEN)) S OKCNT=OKCNT+1
 S ^XTMP("BLRUCUM","LOG","TEST",TIEN,SIEN)=$G(UNITS)_U_$G(UCUM)
 S ^XTMP("BLRUCUM","LOG","UNITS")=+$G(^XTMP("BLRUCUM","LOG","UNITS"))+1
 S ^XTMP("BLRUCUM","LOG","UNITS",UNITS,UCUM)=+$G(^XTMP("BLRUCUM","LOG","UNITS",UNITS,UCUM))+1
 Q
 ;
SRPT ; Summary Report
 D ^XBCLS
 S PCNT=+$G(^XTMP("BLRUCUM","ERR","PANEL"))
 S SCNT=+$G(^XTMP("BLRUCUM","ERR","NSPEC"))
 S NCNT=+$G(^XTMP("BLRUCUM","ERR","NUNIT"))
 S UCNT=+$G(^XTMP("BLRUCUM","ERR","NUCUM"))
 S ZCNT=+$G(^XTMP("BLRUCUM","LOG","INACT"))
 I $G(^XTMP("BLRUCUM","LOG"))'="" S CNT=+$P(^XTMP("BLRUCUM","LOG"),U,1),SPEC=+$P(^XTMP("BLRUCUM","LOG"),U,2)
 S OKCNT=+$G(^XTMP("BLRUCUM","LOG","UNITS"))
 S SWU=+$G(SPEC)-(+$G(NCNT))
 W !,$$CJ^XLFSTR("UNITS LINKED TO UCUM - RESULTS SUMMARY",IOM)
 W !,$$CJ^XLFSTR("======================================",IOM)
 ;
 W !!,$J(CNT,5),?7,"TESTS and ",SPEC," SPECIMENS examined in File 60"
 W !,$J(OKCNT,5),?7 W:SWU>0 "(",$E((OKCNT/SWU*100),1,5),"%)" W " UNITS linked to UCUM"
 ;
 ; Print error summary
 W !!,$$CJ^XLFSTR("Summary of Exceptions",IOM)
 W !,$$CJ^XLFSTR("---------------------",IOM)
 W !,$J(ZCNT,5),?7 W:CNT>0 "(",$E((ZCNT/CNT*100),1,5),"%)" W " INACTIVE TESTS skipped"
 W !,$J(PCNT,5),?7 W:CNT>0 "(",$E((PCNT/CNT*100),1,5),"%)" W " PANELS skipped"
 W !,$J(SCNT,5),?7 W:CNT>0 "(",$E((SCNT/CNT*100),1,5),"%)" W " TESTS w/o specimens skipped"
 W !,$J(NCNT,5),?7 W:SPEC>0 "(",$E((NCNT/SPEC*100),1,5),"%)" W " SPECIMENS w/o units skipped"
 W !,$J(UCNT,5),?7 W:OKCNT>0 "(",$E((UCNT/(UCNT+OKCNT)*100),1,5),"%)" W " UNITS not linked to UCUM"
 Q
TRPT ; Display detailed results by test
 S DONE=+$G(^XTMP("BLRUCUM","DONE"))
 S TCNT=+$G(^XTMP("BLRUCUM","LOG","TEST"))
 D ^XBCLS
 D THDR
 S TIEN="",Q1=0
 F  S TIEN=$O(^XTMP("BLRUCUM","LOG","TEST",TIEN)) Q:Q1!(TIEN="")  D
 .S SIEN="" F  S SIEN=$O(^XTMP("BLRUCUM","LOG","TEST",TIEN,SIEN)) Q:Q1!(SIEN="")  D
 ..S TST=$P(^LAB(60,TIEN,0),U,1)
 ..S SPNM=$P(^LAB(61,SIEN,0),U,1)
 ..S UNITS=$P($G(^XTMP("BLRUCUM","LOG","TEST",TIEN,SIEN)),U,1)
 ..S UCUM=$P($G(^XTMP("BLRUCUM","LOG","TEST",TIEN,SIEN)),U,2)
 ..W !,?3,TIEN,?10,$E(TST,1,23),?35,$E(SPNM,1,13),?50,UNITS,?65,UCUM
 ..I $Y>22 D CR Q:Q1  D THDR
 ..Q
 .Q
 W !!,?3,TCNT," Tests with Units Linked to UCUM"
 D CR Q:Q1
 Q
 ;
URPT ; Print detailed results by units
 S UCNT=+$G(^XTMP("BLRUCUM","LOG","UNITS"))
 D ^XBCLS
 D UHDR
 S UNITS="",Q1=0
 F  S UNITS=$O(^XTMP("BLRUCUM","LOG","UNITS",UNITS)) Q:UNITS=""!(Q1)  D
 .S UCUM=$O(^XTMP("BLRUCUM","LOG","UNITS",UNITS,"")) Q:UCUM=""
 .S UID=$O(^BLRUCUM("B",UCUM,""))
 .S CNT=+$G(^XTMP("BLRUCUM","LOG","UNITS",UNITS,UCUM))
 .W !,?25,CNT,?32,"'"_UNITS_"'",?50,UCUM
 .I $Y>22 D CR Q:Q1  D UHDR
 .Q
 W !!,?3,UCNT," Units Linked to UCUM"
 D CR Q:Q1
 Q
 ;
THDR ; Print Header for File 60 Test Report
 W !,$$CJ^XLFSTR("FILE 60 UNITS LINKED TO UCUM -- RESULTS BY TEST",IOM)
 W !,$$CJ^XLFSTR("===============================================",IOM)
 W !!,?3,"IEN",?10,"TEST",?35,"SPECIMEN",?50,"UNITS",?65,"UCUM"
 W !,"--------------------------------------------------------------------------------"
 Q
 ;
UHDR ; Print Header for File 60 Units Report
 W !,$$CJ^XLFSTR("FILE 60 UNITS LINKED TO UCUM -- RESULTS BY UNITS",IOM)
 W !,$$CJ^XLFSTR("================================================",IOM)
 W !!,?24,"Instances of Units Linked to UCUM"
 W !,?24,"----------------------------------"
 Q
 ; 
ERPT ; Print Detailed Exceptions Report
 I '$D(^XTMP("BLRUCUM","ERR")) W !!,$$CJ^XLFSTR("NO EXCEPTIONS TO REPORT",IOM) H 2 Q
 ;
 ; Print exceptions from File 60
 S ETYP="A",Q1=0
 F  S ETYP=$O(^XTMP("BLRUCUM","ERR",ETYP)) Q:Q1!(ETYP="")  D
 .D ^XBCLS
 .D EHDR
 .S TIEN="",Q1=0
 .F  S TIEN=$O(^XTMP("BLRUCUM","ERR",ETYP,TIEN)) Q:Q1!(TIEN="")  D
 ..S TST=$P(^LAB(60,TIEN,0),U,1),SS=$P(^LAB(60,TIEN,0),U,4)
 ..I $O(^LAB(60,TIEN,2,0)) S TST=TST_" (PANEL)"
 ..W !,?3,TIEN,?15,$E(TST,1,23)_$S(SS'="":" ("_SS_")",1:"")
 ..I ETYP="NUNIT"!(ETYP="NUCUM") S SIEN="",LN=1 D
 ...F  S SIEN=$O(^XTMP("BLRUCUM","ERR",ETYP,TIEN,SIEN)) Q:Q1!(SIEN="")  D
 ....S SPNM=$P(^LAB(61,SIEN,0),U,1),UNITS=$G(^XTMP("BLRUCUM","ERR",ETYP,TIEN,SIEN))
 ....W:LN>1 ! W ?45,$E(SPNM,1,12) W:ETYP="NUCUM" ?60,$G(UNITS) S LN=LN+1
 ....I $Y>22 D CR Q:Q1  D EHDR
 ....Q
 ...Q
 ..I 'Q1,$Y>22 D CR Q:Q1  D EHDR
 ..Q
 .S TOT=+$G(^XTMP("BLRUCUM","ERR",ETYP))
 .W !!,?3,TOT," ",HDR
 .I $O(^XTMP("BLRUCUM","ERR",ETYP))="" W !!,$$CJ^XLFSTR("*** END OF REPORT ***",IOM) Q
 .D CR Q:Q1
 .Q
 ;
 Q
 ;
EHDR ; Print Header for Error Report
 S (HDR,UNL)=""
 W !,$$CJ^XLFSTR("FILE 60 UNITS LINKED TO UCUM -- EXCEPTIONS REPORT",IOM)
 I ETYP="NSPEC" S HDR="TESTS WITHOUT SPECIMENS - SKIPPED"
 I ETYP="NUNIT" S HDR="SPECIMENS WITHOUT UNITS - SKIPPED"
 I ETYP="NUCUM" S HDR="UNITS NOT LINKED TO UCUM"
 I ETYP="PANEL" S HDR="PANELS - SKIPPED"
 W !,$$CJ^XLFSTR(HDR,IOM)
 W !,$$CJ^XLFSTR("================================================",IOM)
 W !!,?3,"IEN",?15,"TEST (CATEGORY)" W:ETYP="NUNIT"!(ETYP="NUCUM") ?45,"SPECIMEN" W:ETYP="NUCUM" ?60,"UNITS"
 W !,"--------------------------------------------------------------------------------"
 Q
 ;
 ;Trim Leading Spaces
TRIMLSPC(X) ;
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 Q X
 ;--------------------------------------------------------------------
 ;Trim Trailing Spaces
TRIMTSPC(X) ;
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,$L(X)-1)
 Q X
 ;--------------------------------------------------------------------
 ;
 ;Trim All Leading and Trailing Spaces
TRIMALL(X) ;
 Q $$TRIMLSPC($$TRIMTSPC(X))
 ;
 ;============================================================================================
