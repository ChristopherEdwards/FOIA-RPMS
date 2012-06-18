BARADJRA ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 10/06/2003 - V1.7 Patch 4
 ;     For HIPAA compliance.  Modify description of AR Adjustment
 ;     to be more descriptive.
 ;
 ; ********************************************************************
 Q
 ; ********************************************************************
ENTRY ; EP
 ; Edit entries into A/R Table Entry File (Adj Reasons)
 ;L +^BARTBL
 L +^BARTBL:5 S X=$T
 I 'X D  Q
 . W *7,!!,"Cannot update HIPAA Standard Adjustment Reasons at this time."
 . W !,"Contact ITSC Support to obtain instructions for updating"
 . W !,"HIPAA Standard Adjustments after this install is complete."
 . W !!,"....continuing this KIDS installation."
 . D EOP^BARUTL(1)
 S BARD=";;"
 S BARCNT=0
 F  D EN2 Q:BARTYPE="END"
 L -^BARTBL
 D ^BARVKL0
 Q
 ; ********************************************************************
EN2 ;
 S BARCNT=BARCNT+1
 S BARTYPE=$P($T(@1+BARCNT),BARD,2,3)
 Q:BARTYPE="END"
 S BARTAG=$P(BARTYPE,BARD)
 S BARRTN=$P(BARTYPE,BARD,2)
 S BARCNT2=0
 F  D TYPE Q:BARVALUE="END"
 Q
 ; ********************************************************************
TYPE ;
 S BARCNT2=BARCNT2+1
 S BARVALUE=$P($T(@BARTAG+BARCNT2^@BARRTN),BARD,2,5)
 Q:BARVALUE="END"
 K DIC,DA,X,Y,DIE,DR
 S DIE="^BARTBL("
 S DA=$P(BARVALUE,BARD)
 S DR=".01///^S X=$P(BARVALUE,BARD,2)"
 S DR=DR_";2////^S X=$P(BARVALUE,BARD,3)"
 D ^DIE
 Q
 ; *********************************************************************
 ;; LINE TAG ;; ROUTINE
 ; *********************************************************************
1 ;;
 ;;DEDUCT;;BARADJRB
 ;;COPAY;;BARADJRB
 ;;PENDING;;BARADJRC
 ;;NONPYMT;;BARADJRD
 ;;PENALTY;;BARADJRB
 ;;GENINFO;;BARADJRB
 ;;GRPALLOW;;BARADJRB
 ;;WRITEOFF;;BARADJRB
 ;;REFUND;;BARADJRB
 ;;END
