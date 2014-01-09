APCM1UTL ; IHS/CMI/LAB - IHS MU ;
 ;;1.0;IHS MU PERFORMANCE REPORTS;**1**;MAR 26, 2012
 ;
D(D) ;EP
 I D="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)_$S($P(D,".",2)]"":$P(D,".",2),1:"")
JRNL ;EP
 ;N (DT,U,ZTQUEUED) S %=$$NOJOURN^ZIBGCHAR("APCMMUDC"),%=$$NOJOURN^ZIBGCHAR("APCMMUDP")
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
EDT(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
 ;
 ;
LZERO(V,L) ;EP
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
RZERO(V,L) ;EP
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
XTMP(N,D) ;EP
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
