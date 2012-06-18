ACMMS2 ; IHS/TUCSON/TMJ - HELP FOR V MEASUREMENT ; [ 05/11/06  2:18 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**6**;JAN 10, 1996
 ;
 ;PATCH #6 ADDS HELP TEXT TO LINE TAGS HCXD - HED - HEF - HHT - HPR - HSN & CHANGES TEXT ON HTON
 ;
 ;EP;ENTRY POINT: ACMMSR
HELP ; HELP FOR VARIOUS TYPES
 S ACMMTYP="H"_$P(^AUTTMSR($P(^ACM(57,DA,0),U,1),0),U,1) S:ACMMTYP="HVU" ACMMTYP="HVC"
 Q:$T(@ACMMTYP)=""
 F ACMUI=1:1 S ACML=$T(@ACMMTYP+ACMUI) Q:ACML=""!($P(ACML,";;",1)'=" ")  W $P(ACML,";;",2),!
 K ACMMTYP,ACML,ACMUI
 Q
 ;
HAUD ;;
 ;; Enter 8 readings for right ear followed by 8 readings for left ear,
 ;; all followed by slashes (/).  Values must be between 0 and 110.
 ;; EXAMPLE:  100/100/100/95/90/90/85/80/105/105/105/105/100/100/95/90/
HBP ;;
 ;; Enter as SYSTOLIC/DIASTOLIC (120/80).  SYSTOLIC must be between
 ;; 20 and 275.  DIASTOLIC must be between 20 and 200.
HCXD ;;
 ;;Enter a value between 0 and 10.
HED ;;
 ;; Enter EDEMA as one of the following 0, 1+, 2+, 3+ or 4+
HEF ;;
 ;; Enter a value 0-100.
HHC ;;
 ;; To enter head circumference in inches, enter the inches (21)
 ;; inches and decimal (21.5), or inches and fraction (21 1/2).
 ;; Must be 10-30 inches and fractional/decimal part must be a 
 ;; multiple of 1/8 (.125).
 ;;
 ;; To enter head circumference in Centimeters (CHC) enter
 ;; the centimeters and decimal (30.2).
 ;; Centimeter range:  26 to 76 centimeters.
HHE ;;
 ;; Enter N for normal, or A for abnormal.
HPA ;;
 ;; Enter a value between 0 and 10.
HWC ;;
 ;; Enter a waist measurement value between 20 and 99 inches.
 ;; Up to 2 decimal digits.  E.g.  50.25 or 40
HHT ;;
 ;; Enter height in inches and fractions (64 3/4), or inches and
 ;; decimal (64.75).  Height must be between 10 and 90 inches.
 ;; Centimeter range:   26 and 203.
HPU ;;
 ;; Enter whole number between 30 and 250.
HPR ;;
 ;; Enter PRESENTATION as one of the following:
 ;;  (You may enter the number or the text or the abbreviation)
 ;;   1 - VERTEX - VT
 ;;   2 - COMPLETE BREACH - CB
 ;;   3 - DOUBLE FOOTLING - DF
 ;;   4 - SINGLE FOOTLING - SF
 ;;   5 - FRANK BREACH - FB
 ;;   6 - FACE - FA
 ;;   7 - UNSPECIFIED BREACH - UB
 ;;   8 - TRANSVERSE - TR
 ;;   9 - OTHER - OT
 ;;  10 - UNKNOWN - UNK
HSN ;;
 ;; Enter a value between -6 and 4.
HTMP ;;
 ;; Enter as degrees fahrenheit.  Must be 92-109.9 degrees.
HTON ;;
 ;; Enter READING for RIGHT eye, followed by a SLASH, followed
 ;; by the READING for the LEFT eye.
 ;; SLASH is REQUIRED!
 ;; Examples:  18/18, /20, 18/, 10/13
 ;; Readings can be between 0 and 80.
HVC ;;
 ;; Enter denominators only.  The 20/ is assumed.  Enter right eye
 ;; / left eye in form n/n (20/20).  If right eye only enter n (20).
 ;; If left eye only enter /n (/20).  Must be between 10 and 999 or
 ;; must be HM, LP or NLP.
 ;; 
 ;; Numerator may be different than 20.  You will be prompted to
 ;; enter numerator seperately.
HVU ;;
 ;; SAME AS HVC. HVU CHANGED TO HVC BY HELP LOGIC.
HWT ;EP
 ;; If entering weight in LBS and OZs:   enter lbs oz (132 12),
 ;; lbs fraction (132 3/4), or ;; lbs.decimal (132.75).  
 ;; Weight must be 2-750 lbs and fractional/decimal part must be a
 ;; multiple of 1/16 (.0625).
 ;;
 ;; Metric ranges:
 ;; Kilograms: enter between 1 and 340 (fractions and decimals allowed)
 ;; Grams: enter between 1000 and 340000 grams (fractions and decimals allowed)
 ;; Fractions must be entered as in 4000 1/2 or 4 2/3
HAG ;;
 ;; Enter Abdominal Girth.  Must be in the range 0-150. Up to 2 decimal digits.
 ;; e.g.  38.5 or 40 or 39.25
HFH ;;
 ;; Enter a Fundal Height.  Must be in the range 0-100.
HFT ;;
 ;; Enter Fetal Heart Tone.  Must be in the range 0-400.
HRS ;;Help for Respiration rate
 ;;Enter the respiration rate of the patient.  Must be in range 8-100.
HO2 ;;
 ;;Enter a % between 50 and 100.
HPF ;;
 ;;Enter a number between 50 and 900.
HCEF ;EP - per Terry Cullen new measurement 3/17/04
 ;;Enter a number between 5 and 99.
