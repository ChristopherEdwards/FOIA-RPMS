BCHMSRH ; IHS/TUCSON/LAB - HELP FOR MEASUREMENT VALUES ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;help prompts for each of the measurement types
 ;
HELP ; HELP FOR VARIOUS TYPES
 Q:$T(@BCHMTYP)=""
 F I=1:1 S L=$T(@BCHMTYP+I) Q:L=""!($P(L,";;")'=" ")  W $P(L,";;",2),!
 K BCHMTYP
 Q
 ;
HAUD ;;
 ;; Enter 8 readings for right ear followed by 8 readings for left ear,
 ;; all followed by slashes (/).  Values must be between 0 and 110.
 ;; EXAMPLE:  100/100/100/95/90/90/85/80/105/105/105/105/100/100/95/90/
HBP ;;
 ;; Enter as SYSTOLIC/DIASTOLIC (120/80).  SYSTOLIC must be between
 ;; 20 and 275.  DIASTOLIC must be between 20 and 200.
HHC ;;
 ;; To enter head circumference in INCHES, enter the inches (21)
 ;; and decimal (21.5), or inches and fraction (21 1/2).
 ;; Must be 10-30 inches and fractional/decimal part must be a 
 ;; multiple of 1/8 (.125).
 ;;
 ;; To enter head circumference in CENTIMETERS, enter
 ;; the centimeters and decimal, followed by the letter 'C' (30.2C).
 ;; Centimeter range:  26 to 76 centimeters.
HHE ;;
 ;; Enter N for normal, or A for abnormal.
HHT ;;
 ;; To enter height in INCHES, enter the inches (64), inches and
 ;; fractions (64 3/4), or inches and decimal (64.75).
 ;; Height inches must be between 10 and 80.
 ;;
 ;; To enter height in CENTIMETERS, enter value, followed
 ;; by the letter 'C' (100C).  Centimeter range:   26 and 203.
HPU ;;
 ;; Enter whole number between 30 and 250.
HTMP ;;
 ;; Enter as degrees fahrenheit.  Must be 94-109.9 degrees.
HTON ;;
 ;; Enter READING for RIGHT eye, followed by a SLASH, followed
 ;; by the READING for the LEFT eye.
 ;; SLASH is REQUIRED!
 ;; Examples:  18/18, /20, 18/, 10/13
 ;; Readings can be between 0 and 80.
HVC ;;
 ;; Enter denominators only.  The 20/ is assumed.  Enter right eye
 ;; / left eye in form n/n (20/20).  If right eye only enter n (20).
 ;; If left eye only enter /n (/20).  Must be between 10 and 999.
HVU ;;
 ;; SAME AS HVC. HVU CHANGED TO HVC BY HELP LOGIC.
HWT ;;
 ;; To enter weight in LBS and OZs, enter lbs oz (132 12), lbs fraction (132 3/4),
 ;; or lbs.decimal (132.75).  Weight must be 2-750 lbs and fractional/decimal part
 ;; must be a multiple of 1/16 (.0625).
 ;;
 ;; Metric ranges:
 ;;   - To enter weight in KILOGRAMS, enter value between 1 and 340
 ;;     (fractions and decimals allowed), followed by the letter 'K' (100K).
 ;;   - To enter weight in GRAMS, enter value between 1000 and 340000
 ;;     (fractions and decimals allowed), followed by the letter 'G' (100G).
 ;;     Fractions must be entered as in 4000 1/2 or 4 2/3
HAG ;;
 ;; Enter Abdominal Girth.  Must be in the range 0-150.
HFH ;;
 ;; Enter a Fundal Height.  Must be in the range 10-50.
HFT ;;
 ;; Enter Fetal Heart Tone.  Must be in the range 50-250.
HRS ;;Help for Respiration rate
 ;;Enter the respiration rate of the patient.  Must be in range 8-90.
