BHLPV13M ;cmi/sitka/maw - BHL PV1 Segment Supplement for 3M 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will supplement the 3M PV1 segment
 ;
PTCLASS ;-- returns patient class
 S BHLC=$O(INDA(9000010,0))
 K INA("PTCLASS",BHLC),INA("DSP",BHLC),INA("DDT",BHLC)
 S INA("PTCLASS",BHLC)=$S($$VALI^XBDIQ1(9000010,BHL("VIEN"),.07)="H":"I",1:"O")
 I $O(^AUPNVINP("AD",BHL("VIEN"),0)) D
 . S BHLVHIEN=$O(^AUPNVINP("AD",BHL("VIEN"),0))
 . S INA("DSP",BHLC)=$$DSP($$VALI^XBDIQ1(9000010.02,BHLVHIEN,.06))
 . S BHLDSP=$$VAL^XBDIQ1(9000010.02,BHLVHIEN,.06)
 . S BHLHOSP=1
 S INA("DDT",BHLC)=$S($G(BHLVHIEN):$$VALI^XBDIQ1(9000010.02,BHLVHIEN,.01),1:$$VALI^XBDIQ1(9000010,BHL("VIEN"),.01))
 Q
 ;
DSP(V) ;return disposition on inpatient visits
 S R=BHLVHIEN
 I $P(^AUPNVINP(R,0),"^",6)="" Q ""
 S X=$P(^AUPNVINP(R,0),"^",6),X=$P($G(^DG(405.1,X,9999999)),U)
 Q $S(X=1:1,X=2:2,X=3:7,X=4:20,X=5:20,X=6:20,X=7:20,1:X)
 ;convert to UB92 code
 ;
