ASUARDTX ;DSD/DFM - RECEIPT ENTER DATE OF EXPIRATION;  [ 04/15/98  2:44 PM ]
 ;;3.0;SAMS;**2**;AUG 20, 1993
RDDT4 ;
 S DIR("A")="13. ENTER EXPIRATION DATE"
 S DIR("?")="Enter a Date in 'MMYY' format not before current month - may be blank"
 S DIR(0)="FO^1:4^D DTCK^ASUARDTX"
 D ^DIR I $D(DUOUT)!($D(DIROUT))!($D(DTOUT)) G EXIT
 S ASUTRNS(ASUTRNS,"EXPIRATION DATE")=Y
EXIT ;RETURN TO CALLING ROUTINE
 K DIR,X,Y
 Q
DTCK ;
 I X="T"!(X="N") S Y=$E(ASUK("DATE","FM"),4,5)_$E(ASUK("DATE","FM"),2,3) W " ",Y Q
 I X["/" S %DT="F" D ^%DT I Y>0 S Y=$E(Y,4,5)_$E(Y,2,3) W " ",Y Q
 I $L(X)<4 W !,"Answer must be in MMYY format" K X Q
 I ($E(X,3,4)<$E(ASUK("DATE","FM"),2,3))&($E(X,3,4)>"85") W !,"Answer may not be for a previous year" K X Q   ;DFM 3/27/98 FIX UNTIL 2085
 I ($E(X,3,4)=$E(ASUK("DATE","FM"),2,3))&($E(X,1,2)<$E(ASUK("DATE","FM"),4,5)) W !,"Month must be current month or greater" K X Q
 I $E(X,1,2)>12!(+$E(X,1,2)<1) W !,"Month must be 01 - 12" K X Q
 S Y=X
 Q
