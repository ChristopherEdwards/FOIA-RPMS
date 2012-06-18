ASUUTIL1 ; IHS/ITSC/LMH - VARIOUS UTILITY SUBROUTINES USED BY SAMS REPORTS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK AEF/2970311
 ;This routine contains various utilities used by the SAMS reports
 ;
 ;
EXTDATE(Y)         ;EP
 ;----- CONVERTS INTERNAL FM DATE TO EXTERNAL
 ;
 X ^DD("DD")
 Q Y
 ;
FY(X) ;EP -- RETURNS FY AND BEGINNING AND ENDING DATES OF FISCAL YEAR
 ;
 ;      Returns Fileman beginning and ending dates for fiscal year in
 ;      FY^FY1STDAY^FYLASTDAY format
 ;
 ;      X = date passed by calling routine
 ;      Y = first day of fiscal year
 ;      Z = last day of fiscal year
 ;
 N Y,Z
 S (Y,Z)=$E(X,1,3)
 S:+$E(X,4,5)<10 Y=Y-1
 S Y=Y_1001
 S:+$E(X,4,5)>9 Z=Z+1
 S Z=Z_"0930"
 Q $E(Z,1,3)_"0000"_"^"_Y_"^"_Z
 ;
FPP(X) ;EP -- SETS UP FY, PREV FY, PREV PREV FY DATE ARRAY USED BY DATABOOK
 ;      REPORTS
 ;
 ;      Returns current fiscal year beginning and ending dates,
 ;      previous fiscal year beginning and ending dates,
 ;      previous previous fiscal year beginning and ending dates
 ;      in ASU("DT") array
 ;
 ;      X = date passed by calling routine
 ;
 S ASU("DT","FY")=+$$FY^ASUUTIL1(X)
 S ASU("DT","FY1")=ASU("DT","FY")-10000
 S ASU("DT","FY2")=ASU("DT","FY")-20000
 S ASU("DT","BEG")=$P($$FY^ASUUTIL1(ASU("DT","FY")),U,2)
 S ASU("DT","END")=$P($$FY^ASUUTIL1(ASU("DT","FY")),U,3)
 S ASU("DT","BEG1")=$P($$FY^ASUUTIL1(ASU("DT","FY1")),U,2)
 S ASU("DT","END1")=$P($$FY^ASUUTIL1(ASU("DT","FY1")),U,3)
 S ASU("DT","BEG2")=$P($$FY^ASUUTIL1(ASU("DT","FY2")),U,2)
 S ASU("DT","END2")=$P($$FY^ASUUTIL1(ASU("DT","FY2")),U,3)
 Q
LDOM(X) ;EP -- LAST DAY OF MONTH
 ;
 ;      Returns FileMan date of last day of a particular month
 ;
 ;      X = date passed by calling routine
 ;
 N Y
 S X=$E(X,1,5)_$P("31^28^31^30^31^30^31^31^30^31^30^31","^",+$E(X,4,5))
 I +$E(X,4,5)=2 S Y=X X ^DD("DD") S X=X+$$LEAP^ASUUTIL1($P(Y,",",2))
 Q X
 ;
LEAP(X) ;EP -- EXTRINSIC FUNCTION - LEAP YEAR CALCULATION
 ;
 ;      X = 4 DIGIT YEAR
 ;
 ;      Returns:  0 if year is not a leap year
 ;                1 if year is a leap year
 ;
 ;      Every year that is exactly divisible by 4 is a leap year,
 ;      except for years that are exactly divisible by 100; these
 ;      centurial years are leap years only if they are exactly
 ;      divisible by 400.  As a result the year 2000 is a leap year,
 ;      whereas 1900 and 2100 are not leap years.
 ;
 I '(X#100),'(X#4),'(X#400) Q 1
 I '(X#4),'(X#100) Q 0
 I '(X#4) Q 1
 Q 0
 ;
SOBJ(Y) ;EP; - OUTPUT TRANSFORM FOR SUB OBJECT
 S:Y?4N Y=$E(Y,1,2)_"."_$E(Y,3,4) Q
