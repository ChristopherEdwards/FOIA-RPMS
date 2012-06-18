ANSDATE ;IHS/OIRM/DSD/CSC - UTILITY TO SET BEGINNING AND ENDING DATES; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;UTILITY TO SET BEGINNING AND ENDING DATES
 ;
DATES ;EP;TO SET DATES
 S DIR(0)="DO",DIR("A")="Beginning Date",DIR("?",1)="Enter the earliest date you wish to include.",DIR("?")="Do not enter any date if you want to include all dates."
 D DIR^ANSDIC
 I $E(X)[U S ANSQUIT="" Q
 K ANSQUIT
 S ANSBEGIN=+Y,ANSEND=""
 I ANSBEGIN D  Q:$D(ANSQUIT)
 .S DIR(0)="DO",DIR("A")="Ending Date...",DIR("?",1)="Enter the latest date you wish to include.",DIR("?")="Do not enter any date if you want to include all dates."
 .D DIR^ANSDIC
 .I $E(X)[U S ANSQUIT="" Q
 .K ANSQUIT
 .S ANSEND=$S(Y="":DT,1:Y)
 Q
