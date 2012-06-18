ADEFPC4 ; IHS/HQT/MJL - F COMPLIANCE PT 4 ;03:06 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
REP() ;EP
 ;Select report options
 ;Returns string containing 1 if AREA, 2 if SU and 3 if WSYS reports
 ;selected, otherwise null if none selected
 N ADEROPT
RALL S ADEROPT=""
 S DIR(0)="Y"
 S DIR("A")="Print All Three (AREA, SERVICE UNIT, WATER SYSTEM) Summary Reports"
 S DIR("B")="YES"
 S DIR("?")="Answer YES to print all three summary reports."
 D ^DIR
 I $$HAT^ADEPQA() Q ADEROPT
 I Y S ADEROPT="123" Q ADEROPT
RAREA S ADEROPT=$TR(ADEROPT,"1","")
 S DIR("A")="Include AREA Summary Report"
 S DIR("B")="YES"
 S DIR("?")="Answer YES to print the Area Summary Report."
 D ^DIR
 I $$HAT^ADEPQA() W ! G RALL
 I Y S ADEROPT=ADEROPT_1
RSU S ADEROPT=$TR(ADEROPT,"2","")
 S DIR("A")="Include SERVICE UNIT Summary Report"
 S DIR("?")="Answer YES to print the Service Unit Summary Report."
 D ^DIR
 I $$HAT^ADEPQA() W ! G RAREA
 I Y S ADEROPT=ADEROPT_2
RSY S ADEROPT=$TR(ADEROPT,"3","")
 S DIR("A")="Include WATER SYSTEM Summary Report"
 S DIR("?")="Answer YES to print the Water System Summary Report."
 D ^DIR
 I $$HAT^ADEPQA() W ! G RSU
 I Y S ADEROPT=ADEROPT_3
 Q ADEROPT
