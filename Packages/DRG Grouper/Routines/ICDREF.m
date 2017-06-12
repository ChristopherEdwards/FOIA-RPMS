ICDREF ;ALB/EG - GROUPER UTILITY FUNCTIONS ;04/21/2014
 ;;18.0;DRG Grouper;**14,17,57**;Oct 20, 2000;Build 7
 ;               
 ; KER  Remove direct global reads, update for ICD-10
 ;
 ; Global Variables
 ;    None
 ;               
 ; External References
 ;    $$REF^ICDEX         ICR  N/A
 ;    $$VMDCDX^ICDEX      ICR  N/A
 ;    $$VMDCOP^ICDEX      ICR  N/A
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     DADRGFY,DAMDC,DRGFY,ICDMDC,X
 ;     
RTABLE(ICDRG,ICDDATE) ; Return Reference Table
 ;  Input:      ICDRG - DRG entry
 ;              ICDDATE - Date to use for resolving correct entry
 ;
 ;  Output:     Table reference associted with entry from DRG
 ;              file
 Q $$REF^ICDEX($G(ICDRG),$G(ICDDATE))
VMDC(CODE) ; Get versioned MDC for Diagnosis Code
 Q $$VMDCDX^ICDEX($G(CODE),$G(ICDDATE))
GETPVMDC(CODE,ICDMDC,DRGFY) ; Get versioned MDC for Op/Pro ICD code from previous years
 Q $$VMDCOP^ICDEX(+($G(CODE)),$G(ICDMDC),$G(DRGFY))
