BGP2CU6 ; IHS/CMI/LAB - calc CMS measures 26 Sep 2004 11:28 AM 04 May 2010 2:38 PM 30 Oct 2009 11:26 AM ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
ANGIOED(P,BDATE,EDATE,BGPY,BGPC) ;EP
 NEW X,Y,I,T,V,BGPG
 K BGPG
 I $G(BGPC)="" S BGPC=0
 S X=P_"^ALL DX [BGP CMS ANGIOEDEMA DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP2UTL($P(BGPG(X),U,1))_" ["_$P(BGPG(X),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(X),U,4),.04)
 .Q
 Q
HYPERKAL(P,BDATE,EDATE,BGPY,BGPC) ;EP
 NEW X,Y,I,T,V,BGPG
 K BGPG
 I $G(BGPC)="" S BGPC=0
 S X=P_"^ALL DX [BGP CMS HYPERKALEMIA DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP2UTL($P(BGPG(X),U,1))_" ["_$P(BGPG(X),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(X),U,4),.04)
 .Q
 Q
HYPOTEN(P,BDATE,EDATE,BGPY,BGPC) ;EP
 NEW X,Y,I,T,V,BGPG
 K BGPG
 I $G(BGPC)="" S BGPC=0
 S X=P_"^ALL DX [BGP CMS HYPOTENSION DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP2UTL($P(BGPG(X),U,1))_" ["_$P(BGPG(X),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(X),U,4),.04)
 .Q
 Q
RENART(P,BDATE,EDATE,BGPY,BGPC) ;EP
 NEW X,Y,I,T,V,BGPG
 K BGPG
 I $G(BGPC)="" S BGPC=0
 S X=P_"^ALL DX [BGP CMS RENAL ART STEN DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP2UTL($P(BGPG(X),U,1))_" ["_$P(BGPG(X),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(X),U,4),.04)
 .Q
 Q
RENAL(P,BDATE,EDATE,BGPY,BGPC) ;EP
 NEW X,Y,I,T,V,BGPG
 K BGPG
 I $G(BGPC)="" S BGPC=0
 S X=P_"^ALL DX [BGP CMS RENAL DISEASE DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S BGPC=BGPC+1,BGPY(BGPC)="POV:  "_$$DATE^BGP2UTL($P(BGPG(X),U,1))_" ["_$P(BGPG(X),U,2)_"]  "_$$VAL^XBDIQ1(9000010.07,+$P(BGPG(X),U,4),.04)
 .Q
 Q
