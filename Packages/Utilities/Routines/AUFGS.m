%AUFGS ; Fast Global Save ; V1.0 ; Utilities ; 03-Apr-84 ; LLK,MVB [ 01/08/86  12:29 PM ]
 ; For use only in conjunction with %AUFGR
 S $ZT="ERR^%AUFGS",%QTY=2 K ^UTILITY($J) W !,"IHS Fast Global Save",! D ^%IOS G:'$D(%IOD) EXIT
 U %IOD I $D(%MTBOT),@(%MTBOT_"=0") U 0 R !,"Rewind tape? <N> ",%,! I $L(%),"Yy"[$E(%) U %IOD W *5
 U 0 R !,"Header: ",H,! D ^%GSEL G:'$D(%GO) EXIT W ! D INT^%D,INT^%T S TIM=%DAT1_" "_%TIM,WTH="TIM,!,H,!"
 S %V=0 I $D(%MTM),%MTM["V" S %V=1
 I $D(%P),%P["V" S %V=1
 I %V S WTH="TIM,H"
 U %IOD W @WTH S $P(WTH,",")="""*""",%=$F(WTH,"H"),WTH=$E(WTH,1,%-2)_"""*"""_$E(WTH,%,255),%=""
SAVE S %=$O(^UTILITY($J,%)) I $L(%) D  G SAVE
 .S %1="^"_% U 0 W !,%1 Q:'$D(@%1)  U %IOD
 .I %V W @$ZR,$ZR F B=0:0 W $ZO,$ZR U 0 R *a:0 W:$T !,$ZR U %IOD
 .I '%V W @$ZR,!,$ZR,! F B=0:0 W $ZO,!,$ZR,! U 0 R *a:0 W:$T !,$ZR U %IOD
EXIT I $O(^UTILITY($J,""))'="",$D(%DTY),%DTY'="MT" U %IOD W @WTH
 I $O(^UTILITY($J,""))'="",$D(%DTY),%DTY="MT" W *3
EXIT1 U 0 I $D(%IOD),%IOD'=$I C %IOD
 S $ZT="" Q
ERR I $ZE["<UNDEF" U %IOD W @$S(%DTY="MT":"*3",1:WTH) S $ZT="ERR^%AUFGS" G SAVE
 I $ZE["<MTERR" U %IOD D ^%MTCHK C %IOD S $ZT="" ZQ
 I $ZE["<INRPT" U 0 W !,"** Unexpected Interrupt **",! G EXIT1
 U 0 I $D(%IOD) C:%IOD'=$I %IOD
 ZQ
ENT S %="",$ZT="ERR^%AUFGS" G SAVE
