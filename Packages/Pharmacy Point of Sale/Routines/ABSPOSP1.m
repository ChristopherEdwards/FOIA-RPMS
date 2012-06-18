ABSPOSP1 ; IHS/FCS/DRS - POS Writeoffs batch ;    [ 09/12/2002  10:17 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
INDEX() Q "APBWO" ; which one is the index for these?
ISEMPTY() Q '$O(^ABSBITMS(9002302,$$INDEX,1,0)) ; true if there's none to do
WHAT W !,"This program takes accounts from the AUTOMATIC WRITEOFFS list",!
 W "and creates a PAYMENTS BATCH to ADJUST each of these accounts",!
 W "to a ZERO BALANCE.",!
 W !
 Q
WRITEOFF ;EP - option:  ABSP AUTO-WRITEOFF BAT
 ; based on the automatic writeoff list
 Q:'$$MUSTILC^ABSPOSB  ; ILC A/R only
 N THRUDATE,X,BATCH
 Q:$$ISEMPTY
 D WHAT
A S THRUDATE=$$DATE Q:'THRUDATE
 S X=$$OKAY G:X="^" A Q:'X
 W !,"Creating the automatic writeoffs batch, please wait...",!
 S BATCH=$$BATCH(THRUDATE)
 W !,"Batch ",BATCH," created, but it isn't automatically posted.",!
 W "To post it to Accounts Receivable, use the PAY option",!
 W "from the main menu.",!
 I '$$UPDATE Q
 D CLRFLAGS
 W !,"Don't forget to post batch ",BATCH,!
 W "You may print or edit the batch as needed before posting.",!
 Q
BATCH(THRUDATE)    ; $$ this, it returns batch number
 N BATCH S BATCH=$$NEWBATCH^ABSPOSP I 'BATCH D IMPOSS^ABSPOSUE("FM,DB,P","TI","$$NEWBATCH^ABSPOSP failed",,"BATCH",$T(+0))
 N PCNDFN S PCNDFN=0
 F  S PCNDFN=$O(^ABSBITMS(9002302,$$INDEX,1,PCNDFN)) Q:'PCNDFN  D
 . D BATCH1,DOT
 Q BATCH
BATCH1 ; given BATCH, PCNDFN, THRUDATE
 N VSTDFN S VSTDFN=$P(^ABSBITMS(9002302,PCNDFN,1,1,0),U,3)
 N PCN S PCN=$P(^ABSBITMS(9002302,PCNDFN,0),U)
 I $P(VSTDFN,U)>THRUDATE Q
 I $P(^ABSBITMS(9002302,PCNDFN,6),U,2)'="A" D  Q  ; closed account?
 . W PCN," status is not ACTIVE; we will remove it from writeoff list",!
 . W "     but no adjustment will be made.",!
 . D CLRFLAG(PCNDFN)
 N BAL S BAL=$P(^ABSBITMS(9002302,PCNDFN,3),U)
 I 'BAL D  Q
 . W PCN," has a zero balance",!
 . ; continue and generate a zero writeoff so as to close the account
 N INS,REASON S INS=$P(^ABSBITMS(9002302,PCNDFN,0),U,3)
 S REASON="RX POS - "
 I INS="SELF PAY" S REASON=REASON_"Beneficiary, No Insurance"
 E  S REASON=REASON_INS
 I $L(REASON)>80 S REASON=$E(REASON,1,77)_"..." ; ^DD(9002302.02,2)
 D ADJUST^ABSPOSP(PCNDFN,BATCH,BAL,REASON)
 Q
CLRFLAGS ; remove these accounts from the automatic writeoff list
 W !,"Now that the adjustments are in the batch, we will",!
 W "remove these accounts from the automatic writeoff list...",!
 N PCNDFN S PCNDFN=0
 F  S PCNDFN=$O(^ABSTMP(BATCH,"TOT",PCNDFN)) Q:'PCNDFN  D
 . D CLRFLAG(PCNDFN),DOT
 W "Done",!
 Q
CLRFLAG(PCNDFN)    ;
 N FDA,MSG
 S FDA(9002302,PCNDFN_",",600.01)=0
C5 D FILE^DIE("","FDA","MSG")
 Q:'$D(MSG)  ; success
 D ZWRITE^ABSPOS("FDA","MSG")
 G C5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"CLRFLAG",$T(+0))
 Q
DOT W "." W:$X>70 !?10 Q
DATE() ;Create automatic writeoff adjustments for visits THRU DATE:
 N X S X=$$DTP^ABSPOSU1($P($T(DATE),";",2)_" ","T") W !
 Q X ; X false if no date entered
OKAY() ;
 W "Okay to create a batch of writeoff adjustments for visits",!
 W "on the automatic writeoff list with visit dates through",!
 W "up to and including ",$P(THRUDATE,U,2),"? ",!
 Q $$YNCOMMON
YNCOMMON() N X S X=$$YESNO^ABSPOSU3("Yes or No? ","YES",0)
 W ! Q $S(X=1:1,X=-1:"^",1:0)
UPDATE() ;
 Q 1 ; it's just a lot simpler this way
 W "Now that the batch has been created, is it okay",!
 W "to REMOVE these accounts from the automatic writeoff list?",!
 N X S X=$$YNCOMMON
 Q
