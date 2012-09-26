PSSGENM ;BIR/WRT-Input transform for .01 field in file 50 ;01-Nov-2011 11:24;PLS
 ;;1.0;PHARMACY DATA MANAGEMENT;**1013**;9/30/97;Build 33
 ;Modified - IHS/MSC/PLS - 11/01/11 - Line EDIT - Changed limit from 40 to 50 characters
EDIT K:$D(^PSDRUG("AQ",+$G(DA)))!(X["""")!($A(X)=45)!('$D(PSSZ))!(X[";") X I $D(X) K:$L(X)>50!($L(X)<1)!'(X'?1P.E)!(X'?.ANP) X
 Q
