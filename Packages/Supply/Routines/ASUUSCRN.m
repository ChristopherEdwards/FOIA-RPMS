ASUUSCRN ; IHS/ITSC/LMH -GENERIC SCREEN FOR AREA ROUTINE ;  [ 07/18/2000  7:23 AM ]
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine provides screening logic for internal record numbers
 ;(E#) for all SAMS files which has them defined as requiring an
 ;Area's Accounting Point as the first two digits.
 ;IHS/ITSC/MRS 7/17/2000-Modified to return DUZ(2) unchanged from DUZ(2)
 ;      sub-routine. No exit flag needs to be set at this point.
EN1 ;EP ;PRIMARY ENTRY POINT
 ;W !,"Now in Screening routine - X = ",$G(X)," Y = ",$G(Y)
 D:'$D(DUZ(2)) AREA Q:'$D(ASUL(1))
 I '$D(ASUL(1,"AR","AP")) D
 .S:$D(X) X("OLD")=X
 .D SETAREA^ASULARST
 .S:$D(X("OLD")) X=X("OLD")
 .K X("OLD")
 I ASUL(1,"AR","WHSE")=3 S X("INDR")="I 1" G TEST  ;Regional Warehouse may look at all areas
 I $D(Y) D  G TEST
 .I $E(Y,1,2)=ASUL(1,"AR","AP") D
 ..S X("INDR")="I 1"
 .E  D
 ..S X("INDR")="I 0"
 S DIC("S")=$G(DO("SCR")) K:DIC("S")']"" DIC("S")
 D
 .I $D(X) D
 ..I $E(X,1,2)=ASUL(1,"AR","AP") S X("INDR")="I 1"
 .E  D
 ..S X("INDR")="I 0"
AREA ;ALSO LOCAL ENTRY FROM EN1 IF '$D(DUZ(2))
 N Z
 S Z=$P($G(^ASUSITE(1,0)),U) I Z]"" D  Q:'$D(DUZ(2))
 .D DUZ(Z)
 E  D
 .W !,"No Site file entry"
 D ARE^ASULARST(Z) W:'$D(ASUL(1)) !,"Not able to find Area"
 Q
DUZ(X) ;
 ;Modified to return DUZ(2) unchanged
 ;No exit flag apparently needs to be set at this point MRS:7/17/2000
 Q
 ;N Y
 ;S Y(1)=$O(^AUTTLOC("C",X_"0000")) I Y(1)]"" D
 ;.S Y=$O(^AUTTLOC("C",Y(1),"")) S DUZ(2)=Y
 ;Q
SST(Y) ;EP ;PASSING X
 D EN1
 K:'$T Y
 Q
IDX ;EP ;FOR INDEX NUMBER
 I $D(X) I X["999999" S X("INDR")="I 0" G TEST
 G EN1
TEST ;
 X X("INDR") K X("INDR")
 Q
ARE ;EP ;REGIONAL CHECK
 Q:ASUL(1,"AR","WHSE")=3  ;Regional Warehouse may look at all areas
 S DO("SCR")="I $P(^(0),U,2)'=$G(ASUL(1,""AR"",""AP"")"
 Q
CHK() ;EP;CALLED BY; ^DD(9002039.18
 ;KERNEL ONLY
 N Y
 S Y=''$D(DUZ(2))
 I 'Y W !,*7,"Use SAMS package menu options, not VA Fileman"
 Q Y
 ;
SCR(X) ;EP;CALLED BY; ^DD(9002039.18 ;ASUTBL SUB STATION ;SCREEN FOR AREA
 N Y,Z
 Q:'$D(ASUL(1)) 0
 Q:$G(ASUL(1,"AR","WHSE"))=3 1
 I X?1N.N Q:$G(ASUL(1,"AR","AP"))'=$E(X,1,2) 0
 Q 1
 ;
FSCR() ;EP;CALLED BY; ^DD(9002031; ASUMST STATION
 ;^DD(9002036; ASUHST HISTORY TRANSACTIONS
 ;^DD(9002036.1; ASUTRN DUE IN; ASUTRN DUE IS
 ;^DD(9002036.2; ASUTRN RECEIPTS
 ;^DD(9002036.3; ASUTRN ISSUES
 ;^DD(9002036.4; ASUTRN INDEX
 ;^DD(9002036.5; ASUTRN STATION
 ;^DD(9002036.6; ASUTRN ADJUSTMENT
 ;^DD(9002036.7; ASUTRN DIRECT ISSUE
 ;^DD(9002036.8; ASUJIB ISSUE BOOK
 ;^DD(9002039.01; ASUTBL AREA
 ;^DD(9002039.02; ASUTBL STATION
 ;^DD(9002039.18; ASUTBL SUB STATION
 ;^DD(9002039.19; ASUTBL USER
 ;^DD(9002039.21; ASUTBL BUDGET
 ; LOOKUP SCREEN MOST FILES
 ;      SCREENS ENTRIES FROM LOOKUP, PRINT, INQUIRY, SEARCH AND OTHER
 ;      ACTIONS
 ;
 D:'$D(ASUL(1)) AREA Q:'$D(ASUL(1)) 0
 Q:$G(ASUL(1,"AR","AP"))=65 1
 Q:$G(ASUL(1,"AR","WHSE"))=3 1
 Q:$P(^(0),U,2)'=$G(ASUL(1,"AR","AP")) 0
 Q 1
FSCX() ;EP;^DD(9002032;ASUMST INDEX; LOOKUP SCREEN FOR INDEX MASTER
 ;
 ;      SCREENS ENTRIES FROM LOOKUP, PRINT, INQUIRY, SEARCH AND OTHER
 ;      ACTIONS
 ;
 D:'$D(ASUL(1)) AREA Q:'$D(ASUL(1)) 0
 Q:$G(ASUL(1,"AR","WHSE"))=3 1
 S:$P(^(0),U,11)']"" $P(^(0),U,11)=$E($G(Y),1,2)
 Q:$P(^(0),U,11)'=$G(ASUL(1,"AR","AP")) 0
 Q:$E($G(Y),3,8)=999999 0
 Q 1
FSCU() ;EP;CALLED BY; ^DD(9002039.2; ASUTBL REQUSITIONER
 ;-- LOOKUP SCREEN FOR REQUSITIONER FILE
 ;
 ;      SCREENS ENTRIES FROM LOOKUP, PRINT, INQUIRY, SEARCH AND OTHER
 ;      ACTIONS
 ;
 D:'$D(ASUL(1)) AREA Q:'$D(ASUL(1)) 0
 Q:$G(ASUL(1,"AR","WHSE"))=3 1
 Q:$P(^(0),U,4)'=$G(ASUL(1,"AR","AP")) 0
 Q 1
