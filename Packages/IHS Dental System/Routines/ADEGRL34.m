ADEGRL34 ; IHS/ANMC/HMW - PROCESS 'IH' CODES ;
 ;;6.0;ADE;**10,11**;APRIL 1999
 ;
IH(ADEPAT,ADEVDATE) ;EP
 ;IHS/ANMC/HMW 10-31-2001 Patch 10
 ;IHS/ANMC/HMW 8-14-2002 Patch 11 added prompts for broken and cancelled appt codes
 ;ADA Codes begining with 'IH' are IHS-created codes used to track patient dental treatment and status.
 ;Dental patients must receive at least one IH code per fiscal year.
 ;This routine checks patient dental treatment history in ADEHXC for existence
 ;of any 'IH' code for fiscal year of visit date.
 ;
 ;INPUT:
 ;       ADEPAT Patient DFN
 ;       ADEVDATE Visit Date
 ;
 ;UPDATE:
 ;       ADEV( and ADEDES( arrays
 ;
 ;RETURN:
 ;If an IH code exists for visit's FY, returns +1
 ;If no record of an IH code, prompts user for an IH code and
 ;       Returns -1 if user does not select an IH code
 ;       Returns +1 if a proper IH code selected
 ;
 N ADEIH,ADEIHD,ADEFY,ADEHIT,ADEVFM,%DT,J,DIR,DTOUT,DUOUT,DIRUT,DIROUT,Y
 N ADETXT,ADEAGE
 I ADECON Q 1 ;No IH code necessary on CONTRACT visits
 S X=ADEVDATE,%DT="T" D ^%DT S ADEVFM=Y
 I '+ADEVFM Q 0
 S ADEFY=$P($$FISCAL^XBDT(ADEVFM),U)
 ;
 ;$O Through ADEXHC("IH") looking for at least one code that occurred during this FY
 S ADEIH="IH",ADEHIT=0
 F  S ADEIH=$O(ADEHXC(ADEIH)) Q:ADEIH'["IH"  D  Q:ADEHIT
 . S ADEIHD=0
 . F  S ADEIHD=$O(ADEHXC(ADEIH,ADEIHD)) Q:'+ADEIHD  D  Q:ADEHIT
 . . I ADEFY=$P($$FISCAL^XBDT(ADEIHD),U) S ADEHIT=1
 . . Q
 . Q
 ;
 I ADEHIT Q 1 ;An IH code exists for the visit's FY
 ;
 D LIST^ADEGRL3
 ;
 S ADEAGE=$G(AGE)
 S DIR(0)="SX^"
 S DIR(0)=DIR(0)_"BA:9130 - Broken Appointment;"
 S DIR(0)=DIR(0)_"CA:9140 - Cancelled Appointment;"
 S DIR(0)=DIR(0)_"0:IH70 - PATIENT ASSESSED FOR OBJECTIVES;"
 I ADEAGE>0&(ADEAGE<20) S DIR(0)=DIR(0)_"1:IH71 - CARIES FREE PATIENT;"
 I ADEAGE>0&(ADEAGE<20) S DIR(0)=DIR(0)_"2:IH72 - UNTREATED TOOTH DECAY;"
 I ADEAGE>0&(ADEAGE<20) S DIR(0)=DIR(0)_"3:IH73 - PERMANENT MOLAR SEALANT(S);"
 I ADEAGE>14&(ADEAGE<46) S DIR(0)=DIR(0)_"4:IH74 - ACCEPTABLE PERIO (AGE 15-45);"
 I ADEAGE>14&(ADEAGE<46) S DIR(0)=DIR(0)_"5:IH75 - DEEP POCKETING (AGE 15-45);"
 I ADEAGE>14&(ADEAGE<46) S DIR(0)=DIR(0)_"6:IH76 - MISSING TEETH DUE TO DISEASE;"
 I ADEAGE>14&(ADEAGE<75) S DIR(0)=DIR(0)_"7:IH77 - BECAME EDENTULOUS AT THIS VISIT"
 S DIR("?")="Patient is "_ADEAGE_" years old.  Select the appropriate 'IH' code"
 S DIR("A")="Select Oral Health Code"
 D ^DIR
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) Q 0
 I Y="BA" D  Q 1
 .  K ADEV,ADEDES
 .  S ADEV("9130")="1^"
 .  S ADEDES("9130")="BROKEN APPT"
 I Y="CA" D  Q 1
 .  K ADEV,ADEDES
 .  S ADEV("9140")="1^"
 .  S ADEDES("9140")="CANCELLED APPT"
 I Y?1N,Y>-1,Y<8 S Y="IH7"_Y
 I Y'["IH" Q 0
 S ADEV(Y)="1^"
 S ADETXT="IH70:ASSESSED;"
 S ADETXT=ADETXT_"IH71:CARIES FREE;"
 S ADETXT=ADETXT_"IH72:UNTREATED DECAY;"
 S ADETXT=ADETXT_"IH73:MOLAR SEALANTS;"
 S ADETXT=ADETXT_"IH74:GINGIVITIS;"
 S ADETXT=ADETXT_"IH75:DEEP POCKETS;"
 S ADETXT=ADETXT_"IH76:TOOTH LOSS;"
 S ADETXT=ADETXT_"IH77:PATIENT EDENT"
 S ADEDES(Y)=$P(ADETXT,Y_":",2),ADEDES(Y)=$P(ADEDES(Y),";")
 Q 1
