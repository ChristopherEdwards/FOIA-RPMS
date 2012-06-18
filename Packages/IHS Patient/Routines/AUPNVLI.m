AUPNVLI ; IHS/CMI/LAB - CALLED from v line item ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
DES(AUPNIEN) ;EP called from trigger on #.05 to stuff
 ;description of item in #.06
 NEW %,%1
 S %=""
 I $P($G(^AUPNVLI(AUPNIEN,0)),U)="" Q %
 I $P($G(^AUPNVLI(AUPNIEN,0)),U,5)="" Q %
 S %1=$P(^AUTTLIT($P(^AUPNVLI(AUPNIEN,0),U),0),U,3)
 I %1="" Q %
 S %=$$VAL^XBDIQ1($P(^AUPNVLI(AUPNIEN,0),U),$P(^AUPNVLI(AUPNIEN,0),U,5),%1)
 Q %
 ;
VAL(%,AUPNIEN) ;EP - called from input transform of .04
 ;make sure that value passed in X is legitimate value in file
 ;in .01 field
 NEW %1,%
 S %1=$G(^AUTTLIT($P(^AUPNVLI(AUPNIEN,0),U),11)) I %1="" Q 1
 X %1
 Q $T
