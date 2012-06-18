AUPNCPT ; IHS/CMI/LAB - CALCULATE CPT CODE ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
CPT(V) ;PEP - get all cpts entered on this visit
 ;return 0 or error code
 ;error codes : 1 - no visit passed
 ;              2 - invalid/deleted visit entry passed
 ;return AUPNCPT( array in format:
 ;       AUPNCPT(n)=cpt code^cpt narr^cpt ien^v file # from where the cpt code came^ien of v file entry^
 ;note:  not all will have a v file entry #
 ;    if no cpt codes available, array AUPNCPT will be undefined
 ;i=internal of cpt
 ;c=cpt cpt code
 ;e=ien of v file or visit
 ;n=text of cpt
 ;
 I '$G(V) Q 1
 I '$D(^AUPNVSIT(V)) Q 2
 I $P(^AUPNVSIT(V,0),"^",11) Q 2
 I '$P(^AUPNVSIT(V,0),"^",9) Q 2
 NEW %,AUPNX,AUPNJ,AUPNT,AUPNY,%1,C,E,F,N,I,D,M,O
 S (%,%1)=0
 S D=$P($P(^AUPNVSIT(V,0),"^",1),".")
 K AUPNCPT
 S AUPNT="CPTS" F AUPNJ=1:1 S AUPNX=$T(@AUPNT+AUPNJ),AUPNY=$P(AUPNX,";;",3),F=$P(AUPNX,";;",2) Q:AUPNY="QUIT"!(AUPNY="")  D @AUPNY
 Q %
SET ;
 S %1=%1+1
 S AUPNCPT(%1)=C_"^"_N_"^"_I_"^"_F_"^"_E_"^"_M_"^"_O
 Q
V ;visit cpt - eval&man
 Q:$P(^AUPNVSIT(V,0),"^",17)=""
 ;S C=$$VAL^XBDIQ1(9000010,V,.17),E=V,N=$$VAL^XBDIQ1(81,$P(^AUPNVSIT(V,0),"^",17),2),I=$P(^AUPNVSIT(V,0),"^",17),(M,O)="" D SET
 S C=$$VAL^XBDIQ1(9000010,V,.17),E=V
 S N=$P($$CPT^ICPTCOD($P(^AUPNVSIT(V,0),"^",17),D),U,3)
 S I=$P(^AUPNVSIT(V,0),"^",17),(M,O)="" D SET
 Q
1 ;measurements
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVMSR("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.01,E,.011)]"" S C=$$VAL^XBDIQ1(9000010.01,E,.011),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 Q
8 ;
 ; S E=0,(M,O)="" F  S E=$O(^AUPNVPRC("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.08,E,.16)]"" S C=$$VAL^XBDIQ1(9000010.08,E,.16), ; IHS/ASDST/GTH AUPN*99.1*7 02/15/2002 ; split from following line for length.
 ; I=$P(^AUPNVPRC(E,0),U,16),N=$P(^ICPT($P(^AUPNVPRC(E,0),U,16),0),U,2),(M,O)="" D SET ; IHS/ASDST/GTH AUPN*99.1*7 02/15/2002
 S E=0,(M,O)="" F  S E=$O(^AUPNVPRC("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.08,E,.16)]"" D
 .S I=$P(^AUPNVPRC(E,0),U,16)
 .S C=$$VAL^XBDIQ1(9000010.08,E,.16)
 .S N=$P($$CPT^ICPTCOD(I,D),U,3)
 .S M=$P(^AUPNVPRC(E,0),U,17)
 .S O=$P(^AUPNVPRC(E,0),U,18)
 .D SET ; IHS/ASDST/GTH AUPN*99.1*7 02/15/2002
 Q
11 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVIMM("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.11,E,.011)]"" S C=$$VAL^XBDIQ1(9000010.11,E,.011),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 Q
12 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVSK("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.12,E,.011)]"" S C=$$VAL^XBDIQ1(9000010.12,E,.011),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 Q
13 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVXAM("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.13,E,.011)]"" S C=$$VAL^XBDIQ1(9000010.13,E,.011),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 Q
15 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVTRT("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.15,E,.011)]"" S C=$$VAL^XBDIQ1(9000010.15,E,.011),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 Q
16 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVPED("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.16,E,.011)]"" S C=$$VAL^XBDIQ1(9000010.16,E,.011),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 Q
17 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVPT("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.17,E,.011)]"" S C=$$VAL^XBDIQ1(9000010.17,E,.011),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 ;not yet ready
 Q
18 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVCPT("AD",V,E)) Q:E'=+E  S C=$$VAL^XBDIQ1(9000010.18,E,.01),I=$P(^AUPNVCPT(E,0),U),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),M=$P(^AUPNVCPT(E,0),U,8),O=$P(^AUPNVCPT(E,0),U,9) D SET
 S E=0,(M,O)="" F  S E=$O(^AUPNVCPT("AD",V,E)) Q:E'=+E  S C=$$VAL^XBDIQ1(9000010.18,E,.01),I=$P(^AUPNVCPT(E,0),U),N=$P($$CPT^ICPTCOD(I,D),U,3),M=$P(^AUPNVCPT(E,0),U,8),O=$P(^AUPNVCPT(E,0),U,9) D SET
 Q
22 ;
 ;S E=0,(M,O)="" F  S E=$O(^AUPNVRAD("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.22,E,.019)]"" S C=$$VAL^XBDIQ1(9000010.22,E,.019),I=$O(^ICPT("B",C,0)),N=$S(I:$P(^ICPT(I,0),"^",2),1:""),(M,O)="" D SET
 S E=0,(M,O)="" F  S E=$O(^AUPNVRAD("AD",V,E)) Q:E'=+E  I $$VAL^XBDIQ1(9000010.22,E,.019)]"" S C=$$VAL^XBDIQ1(9000010.22,E,.019),I=$P($$CPT^ICPTCOD(C,D),U,1),N=$P($$CPT^ICPTCOD(I,D),"^",3),(M,O)="" D SET
 Q
EXAMCPT(E) ;EP called from .011 field of V EXAM
 Q:'$G(E)
 Q:'$D(^AUPNVXAM(E))
 NEW A,%,%1,%2,%3,%4
 S %=$P(^AUPNVXAM(E,0),"^"),%1=$P(^AUTTEXAM(%,0),"^",11)
 I %1 Q $P(^ICPT(%1,0),"^")
 I $P(^AUTTEXAM(%,0),"^",2)="01" D
 .S %1=""
 .Q:$P(^AUPNVXAM(E,0),"^",3)=""
 .Q:$P(^AUPNVXAM(E,0),"^",2)=""
 .S %2=$P(^AUPNVXAM(E,0),"^",2),%4=$P($P(^AUPNVSIT($P(^AUPNVXAM(E,0),"^",3),0),"^"),".")
 .S A=$$AGE^AUPNPAT(%2,%4)
 .S %3=$P(^AUPNPAT(%2,0),"^",2)
 .I %4=%3 D  Q
 ..S %1=""
 ..I A<1 S %1=99381 Q
 ..I A>0&(A<5) S %1=99382 Q
 ..I A>4&(A<12) S %1=99383 Q
 ..I A>11&(A<18) S %1=99384 Q
 ..I A>17&(A<40) S %1=99385 Q
 ..I A>39&(A<65) S %1=99386 Q
 ..I A>64 S %1=99387 Q
 ..Q
 .S %1=$S(A<1:99391,A>0&(A<5):99392,A>4&(A<12):99393,A<18&(A>11):99394,A<40&(A>17):99395,A<65&(A>39):99396,A>64:99397,1:"")
 Q %1
IMMCPT(E) ;EP - called from .011 Field of V Immunization
 Q:'$G(E)
 Q:'$D(^AUPNVIMM(E))
 NEW A,%,%1
 S %=$P(^AUPNVIMM(E,0),"^"),%1=$P(^AUTTIMM(%,0),"^",11)
 I %1 Q $P(^ICPT(%1,0),"^")
 I $P(^AUTTIMM(%,0),"^",3)=10 D
 .S %1=""
 .Q:$P(^AUPNVIMM(E,0),"^",3)=""
 .Q:$P(^AUPNVIMM(E,0),"^",2)=""
 .S A=$$AGE^AUPNPAT($P(^AUPNVIMM(E,0),"^",2),$P($P(^AUPNVSIT($P(^AUPNVIMM(E,0),"^",3),0),"."),"^"))
 .I A<12 S %1=90744 Q
 .I A>11&(A<20) S %1=90745 Q
 .I A>19 S %1=90746
 .Q
 Q %1
EDUCCPT(E) ;EP - compute cpt code for education topic given
 ;if cpt code present in v file, use it and quit
 ;if time and ind/grp designation is present, use to calculate
 ;cpt code
 ;otherwise return NULL (should we return 99401)
 Q:'$G(E)
 Q:'$D(^AUPNVPED(E))
 NEW %1
 S %1=99401
 I $P(^AUPNVPED(E,0),"^",9) Q $P(^ICPT($P(^AUPNVPED(E,0),"^",9),0),"^")
 I $P(^AUPNVPED(E,0),"^",7)]"",$P(^(0),"^",8)]"" D  Q %1
 .I $P(^AUPNVPED(E,0),"^",7)="I",$P(^(0),"^",8)<16 S %1=99401 Q
 .I $P(^AUPNVPED(E,0),"^",7)="I",$P(^(0),"^",8)>15&($P(^(0),"^",8)<31) S %1=99402 Q
 .I $P(^AUPNVPED(E,0),"^",7)="I",$P(^(0),"^",8)>30&($P(^(0),"^",8)<46) S %1=99403 Q
 .I $P(^AUPNVPED(E,0),"^",7)="I",$P(^(0),"^",8)>45 S %1=99404 Q
 .I $P(^AUPNVPED(E,0),"^",7)="G",$P(^(0),"^",8)<31 S %1=99411 Q
 .I $P(^AUPNVPED(E,0),"^",7)="G",$P(^(0),"^",8)>30 S %1=99412 Q
 .Q
 Q %1
 ;
CPTS ;
 ;;9000010;;V
 ;;9000010.01;;1
 ;;9000010.08;;8
 ;;9000010.11;;11
 ;;9000010.12;;12
 ;;9000010.13;;13
 ;;9000010.15;;15
 ;;9000010.16;;16
 ;;9000010.17;;17
 ;;9000010.18;;18
 ;;9000010.22;;22
 ;;QUIT
