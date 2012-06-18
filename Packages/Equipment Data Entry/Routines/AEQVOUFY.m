AEQVOUFY ; DSD/DFM/CSC - VOUCHER FISCAL YEAR EDIT EQUIPMENT PACKAGE ; MAY 29,1992 [ 09/29/1999  1:50 PM ]
 ;;2.1;AEQ;**1**;JUL 31, 1992
 I '$D(DT) S X1=X,X=("TODAY") D ^%DT S DT=Y K Y S X=X1 K X1
 ;BEGIN Y2K BLOCK
 S CC=(($E(DT,1,3)+1700)+$E(DT,4,4))   ; Y2000
 S FY=$E(CC,3,4)                       ; Y2000
 S MINFY=CC-50                         ; Y2000
 S ZZ=CC+$S(X'>FY:X,1:X-100)           ; Y2000
 I ZZ<MINFY G INVALID                  ; Y2000
 G EXIT                                ; Y2000
 ;END Y2K BLOCK
INVALID ;INVALID
 K X,Y S Y=-1
EXIT ;
 Q
