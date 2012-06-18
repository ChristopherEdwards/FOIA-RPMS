BARADJRB ; IHS/SD/LSL - data values for BARADJRA ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 10/07/2003 - V1.7 Patch 4
 ;      Contains $T values for BARADJRA in regards to DEDUCTIBLE,
 ;      CO-PAY, PENALTY, GENERAL INFORMATION, GROUPER ALLOWANCE,
 ;      WRITE OFF and REFUND.
 ;
 ; *********************************************************************
 ; ;; IEN ;; DESCRIPTION ;; CATEGORY POINTER
 ; *********************************************************************
 ;
WRITEOFF ;
 ;;691;;Dispensing Fee Adj;;3
 ;;15;;Wrkrs comp State Fee Sched Adj;;3
 ;;135;;Duplicate Claim/Service;;3
 ;;END
 ;
DEDUCT ;
 ;;29;;Deductible Amount;;13
 ;;666;;Blood Deductible;;13
 ;;726;;Deductible - Major Medical;;13
 ;;END
 ;
COPAY ;
 ;;602;;Coinsurance Amount;;14
 ;;27;;Co-Payment Amount;;14
 ;;672;;Coinsurance Day;;14
 ;;727;;Coinsurance - Major Medical;;14
 ;;END
 ;
PENALTY ;
 ;;92;;Pymt Den/Reducd No Precrt Auth;;15
 ;;854;;Late Filing Penalty;;15
 ;;END
 ;
GRPALLOW ;
 ;;93;;DRG Weight;;16
 ;;694;;Processed in Excess of Charges;;16
 ;;END
 ;
REFUND ;
 ;;800;;Patient Refund Amount;;19
 ;;END
 ;
GENINFO ;
 ;;664;;Denial Reversed per Med Review;;22
 ;;692;;Claim Paid in Full;;22
 ;;693;;No Claim Level Adjustments;;22
 ;;723;;Payer Refund Due to Overpymt;;22
 ;;724;;Payer Refund Amt - Not Our Pt;;22
 ;;END
