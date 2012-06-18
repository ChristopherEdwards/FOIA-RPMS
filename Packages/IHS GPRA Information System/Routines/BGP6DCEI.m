BGP6DCEI ; IHS/CMI/LAB - calculate HEDIS measures ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
CALCIND ;EP
 S BGPIC=0 F  S BGPIC=$O(BGPIND(BGPIC)) Q:BGPIC'=+BGPIC  D
 .K BGPSTOP,BGPVAL,BGPVALUE,BGPG,BGPC,BGPALLED,BGPV,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 .I $D(^BGPELIS(BGPIC,1)) X ^BGPELIS(BGPIC,1)
 .K BGPG,BGPC,BGPALLED,BGPVAL,BGPV,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 .I $D(BGPSTOP) Q  ;no need to set since no num/denom
 .;loop each individual to set numerator and denominator
 .S BGPI=0 F  S BGPI=$O(^BGPELIIS("B",BGPIC,BGPI)) Q:BGPI'=+BGPI  D
 ..S (BGPNUM,BGPDEN)=0
 ..X ^BGPELIIS(BGPI,1)
 ..X ^BGPELIIS(BGPI,2) ;denominator 1 or 0
 ..;set field counter
 ..S BGPNF=$P(^BGPELIIS(BGPI,0),U,9)
 ..S BGPN=$P(^DD(90376.03,BGPNF,0),U,4),N=$P(BGPN,";"),P=$P(BGPN,";",2)
 ..D S(BGPRPT,BGPGBL,N,P,BGPNUM)
 ..S BGPDF=$P(^BGPELIIS(BGPI,0),U,8)
 ..S BGPN=$P(^DD(90376.03,BGPDF,0),U,4),N=$P(BGPN,";"),P=$P(BGPN,";",2)
 ..I BGPDEN'="NO" D S(BGPRPT,BGPGBL,N,P,BGPDEN)
 .I $D(BGPLIST(BGPIC)) D STMP^BGP6EUTL
 Q
 ;
S(R,G,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(@(G_R_","_N_")"),U,P)=$P($G(@(G_R_","_N_")")),U,P)+V
 Q
D(D) ;
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
