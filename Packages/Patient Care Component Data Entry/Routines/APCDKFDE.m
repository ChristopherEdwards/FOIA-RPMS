APCDKFDE ; IHS/CMI/LAB - CHECK DEPENDENT ENTRIES AND DELETE VISIT ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
EN1(V) ;EP
 ;WILL DELETE WITH DEL^AUPNVSIT ANY VISIT WITH 0 DEPENDENT ENTRIES
 ;0 returned if visit not deleted
 ;1 returned if visit deleted
 ;
 I '$G(V) Q 0
 I '$D(^AUPNVSIT(V)) Q 0
 I $P(^AUPNVSIT(V,0),U,11) Q 0  ;quit if already deleted visit
 I $P(^AUPNVSIT(V,0),U,7)="H" Q 0
 I $P($G(^AUPNVSIT(V,"VCN")),U)]"" Q 0
 ;
PROCESS ;calculate dependent entry count
 NEW N,C,E,G,R,F
 S C=$P(^AUPNVSIT(V,0),U,9) D CALDEC
 I N'=C S $P(^AUPNVSIT(V,0),U,9)=N
 I N=0 S $P(^AUPNVSIT(V,22),U)="DELETED BY VISIT RE-LINKER"
 I N=0 S AUPNVSIT=V D DEL^AUPNVSIT K AUPNVSIT Q 1
 Q 0
CALDEC ;
 S N=0
 S F=9000010 F  S F=$O(^DIC(F)) Q:F>9000010.99!(F'=+F)  D CALDEC2
 Q
CALDEC2 ;
 S G=^DIC(F,0,"GL"),R=G_"""AD"",V,E)"
 S E="" F  S E=$O(@R) Q:E'=+E  S N=N+1
 Q
