BARPBEN2 ; IHS/SD/LSL - PRINT FROM AUTO POSTING ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/29/03 - V1.8
 ;     Tweaked code for AR national release.  Thanks to California Area
 ;     for original code (AZLKAP02 - 07/10/2000)
 ;
 Q
 ; ********************************************************************
 ;
PRINT ; EP
 ; PRINT
 K DUOUT,DROUT,DTOUT,DIROUT
 D SETHDR
 I BARSBY="P" D PAT
 I BARSBY="B" D BILL
 D EXIT
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Set header Array
 S BAR("HD",0)=""
 S BAR("TXT")="Auto Post Beneficiary"
 S BAR("LVL")=0
 S BAR("CONJ")=""
 D CHK^BARRHD                         ; Line 1 of Report header
 S BAR("LVL")=BAR("LVL")+1
 S BAR("HD",BAR("LVL"))=""
 S BAR("TXT")="AR Account: "_BARACNM
 S BAR("CONJ")="For "
 D CHK^BARRHD                       ; Line 2 of Report header
 S BAR("LVL")=BAR("LVL")+1
 S BAR("HD",BAR("LVL"))=""
 S BAR("TXT")=$S(BARSBY="B":"Bill",1:"Patient")
 S BAR("CONJ")="By "
 D CHK^BARRHD                       ; Line 2 of Report header
 S BAR("PG")=0
 S BAREQUAL="W !?64,""=============="""
 Q
 ; ********************************************************************
 ;
PAT ; EP
 ; sort/print by Patient
 S BAR("COL")="W !?3,""PATIENT"",?29,""BILL"",?51,""DOS"",?72,""AMOUNT"""
 D HDB^BARRPSRB
 I '+BARCNT D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARPATNM=0
 F  S BARPATNM=$O(^XTMP("BAR-BEN",$J,BARPATNM)) Q:BARPATNM=""  D PATBIL Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
 ;
PATBIL ;
 S BARBILL=""
 F  S BARBILL=$O(^XTMP("BAR-BEN",$J,BARPATNM,BARBILL)) Q:BARBILL=""  D PATPRT  Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
 ;
PATPRT ; EP
 ; Print one line Patient Summary
 S BARHOLD=$G(^XTMP("BAR-BEN",$J,BARPATNM,BARBILL))
 I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 W !,$E(BARPATNM,1,25)                         ; Patient Name
 W ?29,$E(BARBILL,1,18)                        ; Bill Number
 W ?51,$P(BARHOLD,U,2)                         ; DOS
 W ?69,$J($P(BARHOLD,U),9,2)                   ; Write off Amount
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
BILL ;EP
 ; sort/print by Bill    
 S BAR("COL")="W !?3,""BILL"",?22,""PATIENT"",?51,""DOS"",?72,""AMOUNT"""
 D HDB^BARRPSRB
 I '+BARCNT D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
 S BARBILL=0
 F  S BARBILL=$O(^XTMP("BAR-BEN",$J,BARBILL)) Q:BARBILL=""  D BILLPRT  Q:$G(BAR("F1"))
 D TOTAL
 Q
 ; ********************************************************************
 ;
BILLPRT ; EP
 ; Print one line Bill summary
 S BARHOLD=$G(^XTMP("BAR-BEN",$J,BARBILL))
 I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 W !,$E(BARBILL,1,18)                          ; Bill Name
 W ?22,$E($P(BARHOLD,U,3),1,25)                ; Patient Name
 W ?51,$P(BARHOLD,U,2)                         ; DOS
 W ?69,$J($P(BARHOLD,U),9,2)                   ; Write off amount
 Q
 ; ********************************************************************
 ;
TOTAL ;
 ; Write report totals
 X BAREQUAL
 W !,?10,"TOTAL BILLS: ",BARCNT
 W ?40,"TOTAL AMOUNT",?64,$J(BARTOT,14,2)
 Q
 ; ********************************************************************
 ;
EXIT ; EP
 ; clear variables
 K ^XTMP("BAR-BEN",$J)
 Q
