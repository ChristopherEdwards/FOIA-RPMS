ASUUY2K ; IHS/ITSC/LMH -Y2K COMPLIENT RTN ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
START(A,B,C,D)     ;EP
 ;;4.2T1;SUPPLY ACCOUNTING MGMT SYSTEM;;JAN 28, 2000
 ;11/16/98 WAR - This routine is designed to create a Fileman date
 ;              from either a 4 digit date (YYMM or MMYY) or a 6
 ;              digit date (MMDDYY or YYMMDD).
 ;5/14/99 WAR - Due to Y2K compliance issues, "00" was imbedded in
 ;              between the MMYY format to avoid FM problems with dates
 ;              between 2000 and 2031
 ;
 ;      A - Contains a numeric string or an array
 ;      B - Number of piece, within array, if applicable
 ;      C - Delimeter, if applicable
 ;      D - Contains either 'Y' or 'N' (order to be set)
 ;
 ;      NOTE: Incoming formats that need to be changed:
 ;            YYMM or YYMMDD
 ;
 ; 
 N X,Z            ;X newed because of VA FM
 ; 
 I +B>0 D         ;if null, value is zero and no piece needed
 .S Z=$P(A,C,B)
 E  D
 .S Z=A
 ;U IO(0) W !,"Z IS ->",Z
 I $L(Z)#2=0 D    ;watching for even number char's 
 .I D="Y" D       ;fld needs to be put in correct order for VA FM
 ..I $L(Z)=6 D
 ...S Z=$E(Z,3,4)_$E(Z,5,6)_$E(Z,1,2)  ;set to MMDDYY
 ..E  I $L(4) D      ;IHS/DSD/JLG 5/27/99
 ...S Z=$E(Z,3,4)_"00"_$E(Z,1,2)       ;set to MM00YY
 .E  D
 ..I $L(Z)=4 D
 ...S Z=$E(Z,1,2)_"00"_$E(Z,3,4)       ;include 00
 S X=Z
 D ^%DT
 I Y=-1 S Y=X      ;IHS/DSD/JLG 5/27/99  If X is null leave it
 I +B>0 D
 .S $P(A,C,B)=Y
 E  D
 .S A=Y
 Q
