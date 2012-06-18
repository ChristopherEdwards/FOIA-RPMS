BIAGE ;IHS/CMI/MWR - PROCESS AGE RANGES, PROMPTS ; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY TO PROMPT AND PROCESS AGE RANGES.
 ;
 ;
 ;----------
AGERNG(BIAGRG,BIPOP,BIDFLT,BIDMODE) ;EP
 ;---> Ask age range.
 ;---> Parameters:
 ;     1 - BIAGRG  (ret) Age Range^Mode (Mode is in Months or Years).
 ;                       Mode="" or 0, is Months (default).
 ;                       Mode=1, is Years.
 ;                       Or BIAGRG="ALL"
 ;                       Examples: "6-24"="6 to 24 Months"
 ;                                 "50-64^1"="50 to 64 Years"
 ;                                 "ALL"
 ;     2 - BIPOP   (ret) =1 if quit
 ;     3 - BIDFLT  (opt) Default Age Range
 ;     4 - BIDMODE (opt) Default Mode: 1=Years, 0/""=Months(default)
 ;
 ;
ASKRNG ;EP
 N DIR,DIRUT,Y S BIPOP=0,BIAGRG=""
 D
 .;---> Set default=previous entry.
 .I $D(^BIAGRG(DUZ,0)) D  Q
 ..S DIR("B")=$P(^BIAGRG(DUZ,0),U,2)
 ..S BIMODE=+$P(^BIAGRG(DUZ,0),U,3)
 .;
 .;---> If no previous user default, then use passed default.
 .S:$G(BIDFLT)]"" DIR("B")=BIDFLT
 .S BIMODE=+$G(BIDMODE)
 ;
ASKRNG1 ;GO EP
 ;
 D FULL^VALM1,TITLE^BIUTL5("SELECT AGE RANGE")
 D
 .I BIMODE D TEXT2 Q
 .D TEXT1
 ;
 S DIR(0)="FOA"
 S DIR("?")="     Enter a number"
 S DIR("A")="     Enter Age Range in "
 S DIR("A")=DIR("A")_$S(BIMODE:"Years: ",1:"Months: ")
 D ^DIR
 I $D(DIRUT)!(Y="") S BIPOP=1 Q
 ;
 I "ALLAllall"[Y S BIAGRG="ALL" Q
 ;
 I "YyMm"[Y D  G ASKRNG1
 .S BIMODE=$S("Yy"[Y:1,1:0) K DIR
 ;
 ;---> If not a valid range, begin again.
 I $$CHECK(.Y) D ERRCD^BIUTL2(660,,1) G ASKRNG
 ;
 ;---> If Age Range was given in Years, concat 1.
 S:BIMODE Y=Y_U_1
 S BIAGRG=Y
 ;
 ;---> Now store user's Age Range for future default.
 Q:Y=""
 Q:DUZ=0
 ;---> Clear any previous Date-Loc Line for this user.
 K ^BIAGRG(DUZ),^BIAGRG("B",DUZ)
 ;---> Store this Age Range for this user.
 S ^BIAGRG(DUZ,0)=DUZ_U_Y,^BIAGRG("B",DUZ,DUZ)=""
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;Enter the patient Age Range IN MONTHS in the form of: 6-24
 ;;Use a dash "-" to separate the limits of the range.  You may also
 ;;enter a single age, such as 12, to select for only 12-month-old
 ;;patients.
 ;;
 ;;Enter "ALL" if you wish to simply include patients of ALL ages.
 ;;
 ;;Or, if you wish to select a range in YEARS, enter "Y" (no quotes).
 ;;
 ;;NOTE: The Age Range will include patients whose ages span from the
 ;;minimum age all the way up to ONE DAY LESS THAN a month after the
 ;;maximum age.  For example, 6-24 will include patients 6 months of
 ;;age and older, up to 24 months and approximately 30 days.
 ;;
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;Enter the patient Age Range IN YEARS in the form of: 65-99
 ;;Use a dash "-" to separate the limits of the range.  You may also
 ;;enter a single age, such as 65, to select for only 65-year-old
 ;;patients.
 ;;
 ;;Enter "ALL" if you wish to simply include patients of ALL ages.
 ;;
 ;;Or, if you wish to select a range in MONTHS, enter "M" (no quotes).
 ;;
 ;;NOTE: The Age Range will include patients whose ages span from the
 ;;minimum age all the way up to ONE DAY LESS THAN a year after the
 ;;maximum age.  For example, 65-99 will include patients 65 years of
 ;;age and older, up to 99 years and 364 days.
 ;;
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
CHECK(X) ;EP
 ;---> Check syntax of age range string.
 ;---> Also, convert to years if appropriate.
 ;---> Parameters:
 ;     1 - X      (req) Age Range.
 ;
 ;---> If only one age selected, quit.
 Q:X?1N.N 0
 N V,Y,Z S V="-"
 S Y=$P(X,V),Z=$P(X,V,2)
 ;---> Each end of the range should be a number.
 I (Y'?1N.N)!(Z'?1N.N) K X Q 1
 ;---> The lower number should be first.
 I Z<Y K X Q 1
 Q 0
 ;
 ;
 ;----------
AGEDATE(BIAGRG,BISVDT,BIBEGDT,BIENDDT,BIERR) ;EP
 ;---> Given an Age Range in months or years and a Survey Date,
 ;---> return the beginning and ending dates in Fileman format.
 ;---> Use to search patients by DOB.
 ;---> Parameters:
 ;     1 - BIAGRG  (req) Age Range^Mth/Yr (e.g.,50-64^1)
 ;                    (See description at linelable AGERNG above.)
 ;     2 - BISVDT  (req) Survey/Forecast Date (date from which to
 ;                       calculate age).
 ;     3 - BIBEGDT (ret) Beginning Date.
 ;     4 - BIENDDT (ret) Ending Date.
 ;     5 - BIERR   (ret) Error.
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 I "ALL"[$G(BIAGRG) S BIBEGDT=0,BIENDDT=9999999 Q
 I '$G(BISVDT) S BISVDT=$G(DT)
 ;I '$G(BISVDT) S BIBEGDT=0,BIENDDT=9999999 Q
 ;S:BISVDT>DT BISVDT=DT
 ;
 ;---> If X=one age only, set it in the form X-X and quit.
 ;---> If Age Range is passed in years, convert to months.
 D
 .N Y S Y=$P(BIAGRG,U)
 .;---> If Y=one age only, set it in the form Y-Y.
 .I Y?1N.N S Y=Y_"-"_Y
 .I '$P(BIAGRG,U,2) S BIAGRG=Y Q
 .S BIAGRG=(12*$P(Y,"-"))_"-"_(12*$P(Y,"-",2)+11)
 ;
 N BIAGRG1,BIAGRG2
 S BIAGRG1=+$P(BIAGRG,"-",1),BIAGRG2=+$P(BIAGRG,"-",2)
 I (BIAGRG1'?1N.N)!(BIAGRG2'?1N.N) D ERRCD^BIUTL2(676,.BIERR) Q
 ;
 ;D PASTMTH(BISVDT,($P(BIAGRG,"-",2)+1),.BIBEGDT)
 D PASTMTH(BISVDT,(BIAGRG2+1),.BIBEGDT)
 ;
 ;---> Now, set Beginning Day to be one day AFTER the patient would
 ;---> be too old and out of the selected Age Range.
 ;---> In other words, come forward one day to include only patients
 ;---> whose age is ONE DAY LESS THAN a month (or year) after the
 ;---> maximum limit of the selected Age Range.
 ;---> For example, Age Range=24-36 includes patients whose age
 ;---> is between [24months] and [37months-1day].
 N X,X1,X2 S X1=BIBEGDT,X2=1 D C^%DTC S BIBEGDT=X
 ;
 ;D PASTMTH(BISVDT,$P(BIAGRG,"-",1),.BIENDDT)
 D PASTMTH(BISVDT,BIAGRG1,.BIENDDT)
 Q
 ;
 ;
 ;----------
PASTMTH(BIDTI,BIMTHS,BIDTO,BIYR) ;EP
 ;---> Return the date BIMTHS months/years prior the input date.
 ;---> Parameters:
 ;     1 - BIDTI  (req) Date in.
 ;     2 - BIMTHS (req) Number of months in the past to calculate.
 ;     3 - BIDTO  (ret) Date out (BIMTHS prior to BIDTI).
 ;     4 - BIYR   (opt) If BIYR=1, input is in years; multiply BIMTHSx12.
 ;
 Q:'$G(BIDTI)
 I '$G(BIMTHS) S BIDTO=BIDTI Q
 I $G(BIYR)=1 S BIMTHS=(BIMTHS*12)
 N YYY,MM,DD
 S YYY=$E(BIDTI,1,3),MM=+$E(BIDTI,4,5),DD=+$E(BIDTI,6,7)
 D
 .I MM>BIMTHS S MM=MM-BIMTHS Q
 .N I,Q S Q=0
 .F I=12:12 D  Q:Q
 ..I BIMTHS-MM<I S MM=I-(BIMTHS-MM),YYY=YYY-(I/12),Q=1
 ;
 S:MM<10 MM="0"_MM
 S:DD<10 DD="0"_DD
 S BIDTO=YYY_MM_DD
 Q
 ;
 ;
 ;----------
MTHYR(BIAG,BIS) ;EP
 ;---> Return Age Range for display in either months or years
 ;---> as appropriate, formatted: "24-36 Months" or "65-99 Years".
 ;---> Parameters:
 ;     1 - BIAG (req) Age Range^Mth/Yr
 ;                    (See description at linelable AGERNG above.)
 ;     2 - BIS  (opt) If BIS=1 return "Mths" instead of "Months" or
 ;                    "Yrs" instead of "Years".
 ;
 Q:$G(BIAG)="" "NO RANGE"
 N V,W,X,Y,Z S V="-"
 ;
 ;---> Z=""/0: Range is in Months; Z=1: Range is in Years.
 S W=$P(BIAG,U),X=$P(W,V),Y=$P(W,V,2),Z=$P(BIAG,U,2)
 S:'X X=0
 S:W=0 W="<1"
 Q:$G(Z) W_$S($G(BIS):" Yr",1:" Year")_$S((Y!(X>1)):"s",1:"")
 Q W_$S($G(BIS):" Mth",1:" Month")_$S((Y!(X>1)):"s",1:"")
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
