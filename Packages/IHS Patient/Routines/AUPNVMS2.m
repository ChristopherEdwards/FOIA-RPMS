AUPNVMS2 ; IHS/CMI/LAB - HELP FOR V MEASUREMENT 24-MAY-1993 ; 29 Aug 2011  4:39 PM
 ;;2.0;IHS PCC SUITE;**2,5,7**;MAY 14, 2009
 ;
 ;BJPC patch 1
 ;  - peak flow change to 50-1000
HELP ; HELP FOR VARIOUS TYPES
 NEW AUPNMTYP,%
 S AUPNMTYP=$P(^AUPNVMSR(DA,0),U,1)
 S %=0 F  S %=$O(^AUTTMSR(AUPNMTYP,11,%)) Q:%'=+%  D EN^DDIOL(^AUTTMSR(AUPNMTYP,11,%,0))
 D EN^DDIOL("","","!")
 Q
 ;S AUPNMTYP="H"_$P(^AUTTMSR($P(^AUPNVMSR(DA,0),U,1),0),U,1) S:AUPNMTYP="HVU" AUPNMTYP="HVC"
 ;Q:$T(@AUPNMTYP)=""
 ;F %AUI=1:1 S L=$T(@AUPNMTYP+%AUI) Q:L=""!($P(L,";;",1)'=" ")  W $P(L,";;",2),!
 ;K AUPNMTYP
 ;Q
 ;
HELP1 ;PEP; called by other packages with AUPNMTYP already set;IHS/ANMC/LJF 1/30/98
 ; calling routine responsible for killing AUPNMTYP
 Q:$T(@AUPNMTYP)=""
 NEW %
 S AUPNMTYP=$P(^AUPNVMSR(DA,0),U,1)
 S %=0 F  S %=$O(^AUTTMSR(AUPNMTYP,11,%)) Q:%'=+%  D EN^DDIOL(^AUTTMSR(AUPNMTYP,11,%,0))
 D EN^DDIOL("","","!")
 Q
 ;F %AUI=1:1 S L=$T(@AUPNMTYP+%AUI) Q:L=""!($P(L,";;",1)'=" ")  W $P(L,";;",2),!
 Q
 ;IHS/ANMC/LJF 1/30/98 end of new subrtn
 ;
BHHELP ;PEP ; called by BH module dd
 S AUPNMTYP="H"_$P(^AUTTMSR($P(^AMHRMSR(DA,0),U,1),0),U,1) S:AUPNMTYP="HVU" AUPNMTYP="HVC"
 Q:$T(@AUPNMTYP)=""
 F %AUI=1:1 S L=$T(@AUPNMTYP+%AUI) Q:L=""!($P(L,";;",1)'=" ")  W $P(L,";;",2),!
 K AUPNMTYP
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
 ;;  U - UNKNOWN - UNK
HSN ;;
 ;; Enter a value between -6 and 4.
HTMP ;;
 ;; Enter as degrees fahrenheit.  Must be 70-120 degrees.
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
 ;; Weight must be 2-1000 lbs and fractional/decimal part must be a
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
 ;;Enter a number between 50 and 1000.
HCEF ;EP - per Terry Cullen new measurement 3/17/04
 ;;Enter a number between 5 and 99.
 ;;
HASQF ;;
 ;; Enter an ASQ FINE MOTOR development score between 0 and 100.
 ;;
HASQG ;; 
 ;; Enter an ASQ GROSS MOTOR development score between 0 and 100.
 ;;
HASQL ;;
 ;; Enter an ASQ LANGUAGE development score between 0 and 100.
 ;;
HASQS ;;
 ;; Enter an ASQ SOCIAL development score between 0 and 100.
 ;;
HAKBP ;;
 ;; Enter as SYSTOLIC/DIASTOLIC (120/80).  SYSTOLIC must be between
 ;; 20 and 275.  DIASTOLIC must be between 20 and 200.
 ;; 
HPHQ2 ;;
 ;; Enter a total PHQ2 score.  Range 0-6
 ;; A score of 3 or higher is considered a positive screen and
 ;; further evaluation is indicated.
 ;; Enter a value between 0 and 6.
 ;; 
HPHQ9 ;;
 ;; Enter a total PHQ9 score. Range: 0 - 27
 ;; 0 - 4 No depression; 5 - 9 Minimal symptoms; 
 ;; 10 - 14  Mild symptoms; 15 - 19 Moderate symptoms; 20 or more Severe symptoms
 ;;
HAUDT ;;
 ;; Enter a total AUDIT score. Range 0 - 40
 ;; Zone I: Score 0 - 7  Low risk drinking or abstinence
 ;; Zone II: Score 8 - 15  Alcohol use in excess of low-risk guidelines 
 ;; Zone III: Score 16 - 19  Harmful and hazardous drinking 
 ;; Zone IV: Score 20 - 40  Referral to Specialist for Diagnostic Evaluation
 ;;  and Treatment
 ;; 
HCRFT ;;
 ;;
 ;; Enter a total CRAFFT score. Range: 0 - 6
 ;; Positive answers to two or more questions is highly predictive
 ;; of an alcohol or drug-related disorder. Further assessment is indicated. 
 ;; 
HASFD ;;
 ;; Enter number of days without asthma symptoms (chest tightness, cough,
 ;; shortness of breath, or wheezing) in the past two weeks.
 ;;     Value range:  0-14
 ;;
HBPF ;;
 ;; Also called 'personal best' peak flow recorded during periods of
 ;; symptom control. Often recorded from home and self-reported.
 ;;     Value range: 50-1000 L/min.
 ;;
HFEF ;;
 ;; Enter in percent the average flow of air during the middle portion of
 ;; expiration.  Value range: 0-150.  Enter a whole number only.
 ;;
HFEV1 ;;
 ;; Enter in liters the maximum amount of air exhaled in one second.
 ;;     Value range:  0-10 liters,  enter a whole number between 0 and 10.
 ;;
HFV1P ;;
 ;; Enter in percent the maximum amount of air exhaled in one second.
 ;; Measured in percent to compare to population statistics.
 ;;     Value range:  0-150.  Enter a whole number only.
 ;;
HFVC ;;
 ;; Enter in liters the maximum amount of air inhaled and exhaled.
 ;;     Value range:  0-10 liters, enter a whole number between 0 and 10.
 ;;
HFVCP ;;
 ;; Enter in percent the maximum amount of air inhaled and exhaled.
 ;;     Value range:  0-150.
 ;;
HFVFC ;;
 ;; Enter as FEV1/FVC (6/8).  FEV1 and FVC must be between
 ;;   0 and 10 liters; these readings are taken from a spirometer. 
 ;;
HAUDC ;;
 ;; Enter a total AUDIT-C score. Range: 0-12
 ;; The AUDIT-C (the first three AUDIT questions which focus on alcohol 
 ;; consumption) is scored on a scale of 0-12 (scores of 0 reflect no 
 ;; alcohol use). In men, a score of 4 or more is considered positive; in 
 ;; women, a score of 3 or more is considered positive. A positive score
 ;; means the patient is at increased risk for hazardous drinking or active 
 ;; alcohol abuse or dependence. 
 ;; 
HADM ;;
 ;; Enter the number of work or school days missed related to asthma
 ;; in the past two weeks.
 ;;     Value range: 0-14
 ;;
HLKW ;;
 ;;Enter date/time last time patient was known to be without signs/symptoms
 ;;of current stroke.  When onset is witnessed, the last known well is identical
 ;;to time of symptoms onset.
 ;;
