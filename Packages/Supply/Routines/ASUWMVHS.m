ASUWMVHS ; IHS/ITSC/LMH - RE-EXTRACT AND DATA ENTRY ONLY ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine will move history transactions to separate files for extract
 N X,Y F X=0:1:10 D
 .S Y=0
 .F  S Y=$O(^ASUH("AT",X,Y)) Q:Y'?1N.N  D
 ..Q:$P($G(^ASUH(Y,0)),U,10)'="U"
 ..S Z=$S(X=8:2,X=9:3,X=0:7,X=10:7,1:X)
 ..M ^TMP("ASUW",$J,Z,Y)=^ASUH(Y)
 Q
