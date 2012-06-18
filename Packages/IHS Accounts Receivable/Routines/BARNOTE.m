BARNOTE ; IHS/SD/LSL - ENHANCEMENTS/NOTES FOR V1.1 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; A/R COLLECTION BATCH dictionary received new fields and triggers to
 ; existing fields.  They are:
 ; 
 ; 90051.01,15 BATCH TOTAL - added TRIGGER^90051.01^17
 ;
 ; 90051.01,16 BATCH POSTING TOTAL - added TRIGGER^90051.01^17
 ;
 ; 90051.01,17 BATCH UNDISTRIBUTED - added TRIGGER^90051.01^17
 ;
 ; new field 90051.01,21 BATCH UNALLOCATED
 ;
 ; new field 90051.01,22 BATCH REFUNDED
 ;
 ; 90051.01,18 ITEM POSTING TOTAL - added TRIGGER^90051.1101^19
 ;                                  added TRIGGER^90051.01^16
 ; 
 ; 90051.01,101 CREDIT - added TRIGGER^90051.1101^19
 ;
 ; 90051.01,102 DEBIT - added TRIGGER^90051.1101^19
 ;
 ; 90051.01,103 ITEM UNDISTRIBUTED - added TRIGGER^90051.1101^19
 ;
 ; new field 90051.01,105 ITEM UNALLOCATED
 ;
 ; new field 90051.01,106 ITEM REFUNDED
 ;
 ; 90051.1101601,2 PAID AMOUNT - added TRIGGER^90051.1101601^4
 ;
 ; 90051.1101601,3 SUB EOB POSTING TOTAL - added TRIGGER^90051.1101^18
 ;                                         added TRIGGER^90051.1101601^4
 ;
 ; new field 90051.1101601,5 SUB EOB UNALLOCATED
 ;
 ;
COLLECTI        ;
 ; BARCLU* series of routines execute the processes within the 
 ; collections entry option.
