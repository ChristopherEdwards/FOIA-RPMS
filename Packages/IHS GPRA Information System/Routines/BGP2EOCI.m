BGP2EOCI ; IHS/CMI/LAB - calculate HEDIS measures ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
CALCIND ;EP
 S BGPIC=0 F  S BGPIC=$O(BGPIND(BGPIC)) Q:BGPIC'=+BGPIC  D
 .K BGPSTOP,BGPVAL,BGPVALUE,BGPG,BGPC,BGPALLED,BGPV,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 .K BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7,BGPN8,BGPN9,BGPN10,BGPN11,BGPN12,BGPN13,BGPN14,BGPN15,BGPN16,BGPN17,BGPN18,BGPN19,BGPN20,BGPN21,BGPN22,BGPN23,BGPN24,BGPN25,BGPN26,BGPN27,BGPN28,BGPN29,BGPN30
 .K BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9,BGPD10,BGPD11,BGPD12,BGPD13
 .K BGPNUMV,BGPMEDS,BGPDAE,BGPMEDS1
 .K ^TMP($J)
 .I $D(^BGPEOMB(BGPIC,1)) X ^BGPEOMB(BGPIC,1)
 .K BGPG,BGPC,BGPALLED,BGPVAL,BGPV,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 .I $D(BGPSTOP) Q  ;no need to set since no num/denom
 .;loop each individual to set numerator and denominator
 .S BGPI=0 F  S BGPI=$O(^BGPEOMIB("B",BGPIC,BGPI)) Q:BGPI'=+BGPI  D
 ..S (BGPNUM,BGPDEN)=0
 ..X ^BGPEOMIB(BGPI,1)
 ..X ^BGPEOMIB(BGPI,2) ;denominator 1 or 0
 ..;set field counter
 ..S BGPNF=$P(^BGPEOMIB(BGPI,0),U,5)
 ..S BGPN=$P(^DD(90549.1,BGPNF,0),U,4),N=$P(BGPN,";"),P=$P(BGPN,";",2)
 ..D S(BGPRPT,BGPGBL,N,P,BGPNUM)
 ..S BGPDF=$P(^BGPEOMIB(BGPI,0),U,4)
 ..S BGPN=$P(^DD(90549.1,BGPDF,0),U,4),N=$P(BGPN,";"),P=$P(BGPN,";",2)
 ..I BGPDEN'="NO" D S(BGPRPT,BGPGBL,N,P,BGPDEN)
 .K BGPNUMV
 .I $D(BGPLIST(BGPIC)) D STMP^BGP2EOUT
 .K BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9,BGPD10,BGPD11,BGPD12,BGPD13,BGPD14,BGPD15,BGPD16,BGPD17,BGPD18,BGPD19,BGPD20,BGPD21,BGPD22,BGPD23,BGPD24,BGPD25,BGPD26
 .K BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7,BGPN8,BGPN9,BGPN10,BGPN11,BGPN12,BGPN13,BGPN14,BGPN15,BGPN16,BGPN17,BGPN18,BGPN19,BGPN20,BGPN21,BGPN22,BGPN23,BGPN24,BGPN25,BGPN26,BGPN27,BGPN28,BGPN29,BGPN30
 Q
 ;
S(R,G,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(@(G_R_","_N_")"),U,P)=$P($G(@(G_R_","_N_")")),U,P)+V
 Q
D(D) ;
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
