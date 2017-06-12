ABMM2PP1 ;IHS/SD/SDR - MU Patient Volume EP Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**11,12,15**;NOV 12, 2009;Build 251
 ;IHS/SD/SDR - 2.6*15 - Updated 'C' prompt so a complete date (mm/dd/ccyy) must be entered.  Was allowing user
 ;  to enter CCYY only.
 ;IHS/SD/SDR - 2.6*15 - HEAT194499 - If option D is used need to kill the End date variables that were set so it will
 ; calculate end date for each 90-day window.  Was printing same date for all start dates.
 ;
90DAY ;
 W !!,"Patient Volume is calculated based on a 90-day period. There are two different"
 W !,"time frame options that can be utilized to determine patient volume."
 W !!?3,"1. Qualification year - This is the year prior to the participation year."
 W !?6,"Any 90-day period can be selected within the qualification year to"
 W !?6,"determine patient volume."
 W !?3,"2. Look-back period - This can be a 90-day period in the previous 12 months"
 W !?6,"from attestation."
 W !!,"Note: All reports will be run for a 90-day reporting period. The 90-day"
 W !,"period may be automatically calculated or user may select a specific start date."
 W !,"The automated calculation will return the first 90-day period in which required"
 W !,"patient volumes are met or the 90-day period with the highest volume percentage"
 W !,"(first occurrence in the year)."
 W !!,"Select A or B to run Patient Volume based on the Qualification year time frame"
 W !,"Select C to Validate a 90-day or less time frame"
 W !,"Select D or E to run Patient Volume based on the Attestation date time frame"
 ;
 D ^XBFMK
 S DIR(0)="S^A:Automated 90-Day Period (using Qualification Year);B:User Specified Start Date 90-Day Period (using Qualification Year);C:Validation Report - user specified date range (validation)"
 S DIR(0)=DIR(0)_";D:Automated 90-Day Period -12 month look back from Attestation Date;E:User Specific 90-Day Period -12 month look back from Attestation Date"
 S DIR("L",1)="Select one of the following:"
 S DIR("L",2)=""
 S DIR("L",3)="     A   Automated 90-Day Period (using Qualification Year)"
 S DIR("L",4)="     B   User Specified Start Date 90-Day Period (using Qualification Year)"
 S DIR("L",5)=""
 S DIR("L",6)="     C   Validation Report - user specified date range (validation)"
 S DIR("L",7)=""
 S DIR("L",8)="     D   Automated 90-Day Period -12 month look back from Attestation Date"
 S DIR("L")="     E   User Specific 90-Day Period -12 month look back from Attestation Date"
 S DIR("A")="Enter selection"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMY("90")=$P(Y,U)
 I ABMY("90")="D" D  Q:+$G(ABMY("SDT"))=0
 .D ^XBFMK
 .S DIR(0)="D^::EX"
 .S DIR("A")="Enter Attestation Date"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S (ABMY("QYR"),ABMY("AYR"))=$E($$SDT^ABMDUTL(+Y),7,10)
 .S ABMY("ADT")=+Y
 .S (ABMY("EDT"),ABMEDT)=Y
 .S X1=$P(ABMEDT,".")
 .S X2=-365
 .D C^%DTC
 .S (ABMY("SDT"),ABMP("SDT"))=X
 .K ABMY("EDT"),ABMEDT  ;abm*2.6*15 HEAT194499
 I ABMY("90")="A"!(ABMY("90")="D") D
 .D ^XBFMK
 .S DIR(0)="S^F:First 90-day period found;H:Highest 90-day period found"
 .S DIR("A",1)=""
 .S DIR("A")="Enter selection"
 .S DIR("B")="F"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMY("A90")=$P(Y,U)
 I ABMY("90")="B" D
 .D ^XBFMK
 .S DIR(0)="D^"_(ABMY("QYR")-1700)_"0101:"_(ABMY("QYR")-1700)_"1231:%DT"
 .I ABMY("RTYP")'="HOS",ABMY("90")="B" D
 ..S DIR(0)="D^"_(ABMY("QYR")-1700)_"0101:"_(ABMY("QYR")-1700)_"1003:%DT"
 .I ABMY("RTYP")="HOS",ABMY("90")="B" D
 ..S DIR(0)="D^"_(ABMY("QYR")-1701)_"1001:"_(ABMY("QYR")-1700)_"0703:%DT"
 .I ABMY("RTYP")="HOS",ABMY("90")'="B" S DIR(0)="D^"_(ABMY("QYR")-1701)_"1001:"_(ABMY("QYR")-1700)_"0930:%DT"
 .S DIR("A",1)=""
 .S DIR("A",2)="Select a specific start date in the calendar year"
 .I ABMY("90")="B" S DIR("A",2)=DIR("A",2)_" for the 90-Day Report Period."
 .I ABMY("RTYP")="HOS" S DIR("A",2)="Select a specific start date in the fiscal year for the 90-Day Report Period."
 .S DIR("A",3)="Note:  End Date must not be after December 31."
 .I ABMY("RTYP")="HOS" S DIR("A",3)="Note:  End Date must not be after September 30."
 .S DIR("A",4)=""
 .S DIR("A")="Enter first day of reporting period"_$S(ABMY("90")="B"!(ABMY("90")="C"):" for "_ABMY("QYR"),1:"")  ;abm*2.6*12
 .D ^DIR K DIR
 .S (ABMY("SDT"),ABMP("SDT"))=Y
 I ABMY("90")="C" D
 .D ^XBFMK
 .;S DIR(0)="D^::%DT"  ;abm*2.6*15
 .S DIR(0)="D^::EX"  ;forces date to be mm/dd/ccyy  ;abm*2.6*15
 .S DIR("A",1)=""
 .S DIR("A",2)="Select a specific start date in the calendar year"
 .I ABMY("RTYP")="HOS" S DIR("A",2)="Select a specific start date in the fiscal year for the 90-Day Report Period."
 .S DIR("A",4)=""
 .S DIR("A")="Enter first day of reporting period"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S (ABMY("SDT"),ABMP("SDT"))=Y
 .D ^XBFMK
 .S DIR("A",1)=""
 .S X1=ABMY("SDT")
 .S X2=89
 .D C^%DTC
 .S ABMDT=X
 .;I ABMY("RTYP")'="HOS" I ABMDT>((ABMY("QYR")-1700)_"1231") S ABMDT=((ABMY("QYR")-1700)_"1231")
 .;I ABMY("RTYP")="HOS" I ABMDT>((ABMY("QYR")-1700)_"0930") S ABMDT=((ABMY("QYR")-1700)_"0930")
 .S DIR(0)="D^"_ABMY("SDT")_":"_ABMDT_":EX"
 .S DIR("A")="Select a specific END date"
 .D ^DIR K DIR
 .S (ABMY("EDT"),ABMP("EDT"))=Y
 I ABMY("90")="E" D
 .D ^XBFMK
 .S DIR(0)="D^"
 .S DIR("A",1)=""
 .S DIR("A",2)="Select a specific END date"
 .S DIR("A",4)=""
 .S DIR("A")="Enter last day of 90-day period"
 .D ^DIR K DIR
 .S (ABMY("EDT"),ABMEDT)=Y
 .S X1=$P(ABMEDT,".")
 .S X2=-89
 .D C^%DTC
 .S (ABMY("SDT"),ABMP("SDT"))=X
 Q
