BARRASMA ; IHS/SD/LSL - Age Summary Report Questions ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6**;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 02/27/02 - Routine created
 ;     Called from BARRASM
 ;     ASK^BARRASMA   - Ask all questions and define header array.
 ;     PRINT^BARRASMA - Print report
 ;
 ; IHS/SD/LSL - 02/20/03 - V1.7 Patch 1
 ;     Added DISCHARGE SERVICE sort and report.  Add time run to report
 ;     headers.
 ;
 ; IHS/SD/LSL - 08/01/03 - V1.7 Patch 2
 ;     Add call to ASM^BAREISS to print of summary data
 ;
 ; IHS/SD/LSL - 11/24/03 - V1.7 Patch 4
 ;     Add Visit Location Sort level to accomodate EISS
 ;     Move print logic to BARRASMB.  Routine too large
 ;
 Q
 ; *********************************************************************
 ;
ASK ; EP
 S BARA("LOC")=0
 S BARA("SORT")=0
 D MSG^BARRSEL                      ; Message about BILL/VIS loc
 D LOC^BARRSL1                      ; Ask loc - return BARY("LOC")
 Q:$D(DTOUT)!($D(DUOUT))            ; Q if time or "^" out
 W:'$D(BARY("LOC")) "ALL"
 F  D SORT Q:BARA("SORT")           ; Ask sort criteria-required
 Q:'+$G(BARY("STCR"))               ; No sort criteria specified - Q
 I BARY("STCR")=1 D  Q
 . W !
 . D ARACCT^BARRSL2                 ; Ask A/R Account-return BARY(
 I BARY("STCR")=2 D  Q
 . W !
 . D CLIN^BARRSEL                   ; Ask clinic-return BARY("CLIN")
 I BARY("STCR")=3 D  Q
 . W !
 . D VTYP^BARRSEL                   ; Ask Vis type-return BARY("VTYP")
 I BARY("STCR")=4 D  Q
 . W !
 . D DSCHSVC^BARRSL2                ; Ask Discharge Svc-return BARY("DSCH")
 I BARY("STCR")=5 D
 . D ALL^BARRSL1                    ; Ask allow cat-return BARY("ALL")
 . Q:$D(DTOUT)!($D(DUOUT))
 . W:'$D(BARY("ALL")) "ALL"         ; If not select category, then ALL
 I BARY("STCR")=6 D
 . D TYP^BARRSL1                    ; Ask billing entity
 . Q:$D(DTOUT)!($D(DUOUT))
 . W:('$D(BARY("TYP"))&'$D(BARY("ACCT"))&'$D(BARY("PAT"))) "ALL"
 I BARY("STCR")=7 D
 . D ITYP^BARRSL1                    ; Ask ins type-return BARY("ITYP")
 . Q:$D(DTOUT)!($D(DUOUT))
 . W:'$D(BARY("ITYP")) "ALL"        ; If not select ins type,ALL
 ; Ask rpt type (only if sort by allow cat/bill ent-return BARY("RTYP")
 Q:$D(DTOUT)!($D(DUOUT))
 D RTYP                             ; Ask report type
 ;I $D(BARY("ALL")) S BARY("ALL")=$S(BARY("ALL")=1:"R",BARY("ALL")=2:"D",BARY("ALL")=3:"P",BARY("ALL")=4:"K",1:"O")
 I $D(BARY("ALL")) S BARY("ALL")=$S(BARY("ALL")=1:"R",BARY("ALL")=2:"D",BARY("ALL")=3:"P",1:"O")  ;BAR*1.8*6 DD 4.1.1 IM21585
 Q
 ; *********************************************************************
 ;
SORT ;
 ; Ask how report should be sorted;  clinic, visit, allowance category,
 ; or billing entity
 K DIR,BARY("STCR")
 S DIR(0)="S^1:A/R ACCOUNT"
 S DIR(0)=DIR(0)_";2:CLINIC TYPE"
 S DIR(0)=DIR(0)_";3:VISIT TYPE"
 S DIR(0)=DIR(0)_";4:DISCHARGE SERVICE"
 S DIR(0)=DIR(0)_";5:ALLOWANCE CATEGORY"
 S DIR(0)=DIR(0)_";6:BILLING ENTITY"
 S DIR(0)=DIR(0)_";7:INSURER TYPE"
 S DIR("A")="Select criteria for sorting"
 S DIR("?")="This is a required response.  Enter ^ to exit"
 D ^DIR
 K DIR
 S:($D(DTOUT)!$D(DUOUT)) BARA("SORT")=1
 Q:Y<1
 S BARA("SORT")=1                   ; The question was answered
 S BARY("STCR")=+Y
 S BARY("STCR","NM")=Y(0)
 ; Following lines needed for BARRCHK to work
 S:BARY("STCR")=2 BARY("SORT")="C"
 S:BARY("STCR")=3 BARY("SORT")="V"
 Q
 ; *********************************************************************
 ;
RTYP ;
 ; Ask report type if user choose to sort by billing entity or
 ; allowance category
 S DIR(0)="S^1:Summarize by ALLOW CAT/BILL ENTITY/INS TYPE"
 S DIR(0)=DIR(0)_";2:Summarize by PAYER w/in ALLOW CAT/BILL ENTITY/INS TYPE"
 S DIR(0)=DIR(0)_";3:Summarize by BILL w/in PAYER w/in ALLOW CAT/BILL ENTITY/INS TYPE"
 S DIR("A")="Select REPORT TYPE"
 S DIR("B")=1
 S DIR("?",1)="Enter the selection that best describes the summary information desired"
 S DIR("?")="Enter ^ to exit"
 D ^DIR
 K DIR
 Q:Y<1
 S BARY("RTYP")=+Y
 S BARY("RTYP","NM")=Y(0)
 Q
