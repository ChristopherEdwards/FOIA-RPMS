AZAXFCD ;IHS/PHXAO/AEF - FIX COVERED DAYS FIELD IN 3P BILL BATCHES
 ;;1.0;ANNE'S SPECIAL ROUTINES;;JULY 14, 2004
 ;;
 ;;DISCLAIMER:  This routine is written for local use by Phoenix Area
 ;;facilities.  Phoenix Area offers no support for the installation
 ;;or use of this routine nor claims responsibility for any adverse
 ;;effects resulting from its use.  
 ;;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine is written specifically to correct the COVERED DAYS
 ;;field for Medicare batches.
 ;;
 ;;This routine prompts for a specific batch entry in the 3P TX
 ;;STATUS file.  It will then loop through each bill contained in
 ;;that batch and set the COVERED DAYS field contained in the 
 ;;3P BILL file to null for each of those bills.  The batch can
 ;;then be recreated and submitted.
 ;;$$END
 ;;
 ;;NOTE:  Audit trails of the bills that were changed are placed
 ;;in the ^AZAX3PBF global for retrieval in case a batch is
 ;;accidentally processed.  See the ARCH subroutine for more details.
 Q
EN ;EP -- MAIN ENTRY POINT
 ;
 N EXPDT,OUT,QUIT
 ;
 D ^XBKVAR
 D HOME^%ZIS
 ;
 D TXT
 ;
 F  D  Q:QUIT
 . D EXP(.EXPDT,.OUT,.QUIT)
 . Q:QUIT
 . Q:OUT
 . ;
 . D PROC(EXPDT)
 ;
 Q
PROC(EXPDT) ;
 ;----- PROCESS ENTRIES
 ;
 ;      INPUT:
 ;      EXPDT  =  IEN OF ENTRY IN 3P TX STATUS FILE TO BE PROCESSED
 ;      
 N BILL,CD,CNT,D1,NOW
 ;
 Q:'EXPDT
 ;
 S CNT=0
 S NOW=$$NOW
 ;
 W !!,"PROCESSING BATCH #",EXPDT,"  ",$$EXTDT($P($G(^ABMDTXST(DUZ(2),EXPDT,0)),U)),"..."
 ;
 S D1=0
 F  S D1=$O(^ABMDTXST(DUZ(2),EXPDT,2,D1)) Q:'D1  D
 . S CNT=$G(CNT)+1
 . I '(CNT#10) W "."
 . S BILL=$P($G(^ABMDTXST(DUZ(2),EXPDT,2,D1,0)),U)
 . Q:'BILL
 . S CD=$P($G(^ABMDBILL(DUZ(2),BILL,7)),U,3)
 . D ARCH(NOW,EXPDT,BILL,CD)
 . D ONE(BILL)
 ;
 W !,CNT," BILLS PROCESSED"
 Q
ONE(DA) ;
 ;----- EDIT ONE BILL
 ;
 ;      INPUT:
 ;      DA  =  IEN OF BILL IN 3P BILL FILE
 ;      
 N DIE,DR,X,Y
 ;
 S DIE="^ABMDBILL("_DUZ(2)_","
 S DR=".73///^S X=""@"""
 D ^DIE
 Q
EXP(EXPDT,OUT,QUIT) ;
 ;----- SELECT EXPORT DATE FROM 3P TX STATUS FILE
 ;
 ;      INPUT:
 ;      NONE
 ;      
 ;      OUTPUT:
 ;      EXPDT  =  IEN OF ENTRY IN 3P TX STATUS FILE TO BE PROCESSED
 ;      OUT    =  QUIT FLAG
 ;      QUIT   =  QUIT FLAG
 ;      
 N DA,D0,DIC,DIQ,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,Y
 ;
 S OUT=0
 S QUIT=0
 ;
 W !
 S DIC="^ABMDTXST("_DUZ(2)_","
 S DIC(0)="AEQM"
 S DIC("S")="I $P(^(0),U,3)=""R"""
 D ^DIC
 I $D(DTOUT)!($D(DUOUT))!(+Y'>0) S QUIT=1
 Q:QUIT
 ;
 W !
 S DA=+Y
 S DR="0:1"
 S DIQ(0)="R"
 D EN^DIQ
 ;
 W !
 S DIR("A",1)="WARNING!  This option will delete the COVERED DAYS from all bills"
 S DIR("A",2)="contained in this batch."
 S DIR("A",3)=""
 S DIR("A")="Do you REALLY want to delete the COVERED DAYS from this batch"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT))!(+Y'>0) S OUT=1
 Q:OUT
 ;
 S EXPDT=DA
 Q
ARCH(NOW,EXPDT,BILL,CD) ;
 ;----- PUT AN ENTRY INTO THE ^AZAX3PBF GLOBAL FOR EACH 'COVERED DAYS'
 ;      FIELD THAT IS CHANGED BY THIS ROUTINE.  USED AS AN AUDIT TRAIL.
 ;      THIS GLOBAL CAN BE DELETED AFTER A WHILE.
 ;      
 ;      GLOBAL STRUCTURE IS:
 ;      ^AZAX3PBF(DUZ(2),NOW,EXPORT_IEN,BILL_IEN)=COVERED_DAYS_OLD_VALUE^DUZ
 ;      
 ;      INPUT:
 ;      NOW    =  DATE/TIME THE CHANGE WAS MADE
 ;      EXPDT  =  EXPORT DATE IEN FROM 3P TX STATUS FILE
 ;      BILL   =  BILL IEN FROM 3P TX STATUS FILE
 ;      CD     =  COVERED DAYS FROM 3P BILL FILE
 ;      
 I '$D(^AZAX3PBF(0)) D
 . S ^AZAX3PBF(0)="RECORD OF 3P BILL FILE ENTRIES WHOSE COVERED DAYS FIELD HAS BEEN CHANGED BY AZAX3PBF ROUTINE. "
 . S ^AZAX3PBF(0)=^AZAX3PBF(0)_" THIS GLOBAL CAN BE DELETED AFTER A WHILE."
 ;
 S ^AZAX3PBF(DUZ(2),NOW,EXPDT,BILL)=CD_U_DUZ
 Q
TXT ;----- PRINT ROUTINE DESCRIPTION TEXT
 ;
 N I,X
 F I=1:1 S X=$T(DESC+I) Q:X["$$END"  D
 . W !,$P(X,";;",2)
 Q
EXTDT(Y) ;
 ;----- RETURNS EXTERNAL DATE
 ;
 ;      INPUT:
 ;      Y  =  DATE IN FM FORMAT
 ;      
 X ^DD("DD")
 Q Y
NOW() ;
 ;----- RETURNS CURRENT DATE/TIME IN INTERNAL FM FORMAT CYYMMDD.HHMMSS
 ;
 N %,%I,X
 D NOW^%DTC
 Q %
 
 
