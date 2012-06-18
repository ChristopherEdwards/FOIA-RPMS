BATU ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
NREL(P,BDATE,EDATE) ;EP
 ;number of reliever meds between BDATE and EDATE
 NEW X,BATL,E
 S X=P_"^ALL MEDS [BAT ASTHMA RELIEVER MEDS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BATL(")
 I '$D(BATL(1)) Q 0
 NEW C,X S (X,C)=0 F  S X=$O(BATL(X)) Q:X'=+X  S C=C+1
 Q C
 ;
PLAST(P,F) ;PEP
 ;1 return 1 if yes, null if no
 ;2 return problem number _ provdier narrative
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW I,A,B,G,S
 S G="",A=0 F  S A=$O(^AUPNPROB("AC",P,A)) Q:A'=+A!(G]"")  D
 .S I=$P(^AUPNPROB(A,0),U),I=$P(^ICD9(I,0),U)
 .I $E(I,1,3)'="493" Q
 .S G=A
 .Q
 I G="" Q ""
 I F=1 Q 1
 I F=2 S G=$$PLN(G) Q G
 Q ""
DXAST(P) ;PEP
 I '$G(P) Q ""
 NEW D,I,A,G
 S (D,G)=0 F  S D=$O(^AUPNVPOV("AA",P,D)) Q:D'=+D!(G)  D
 .S I=0 F  S I=$O(^AUPNVPOV("AA",P,D,I)) Q:I'=+I!(G)  D
 ..S A=$P(^AUPNVPOV(I,0),U),A=$P(^ICD9(A,0),U)
 ..Q:$E(A,1,3)'="493"
 ..S G=1
 ..Q
 .Q
 Q G
PLN(E) ;
 NEW S
 S S=$P(^AUPNPROB(E,0),U,6),S=$S($P(^AUTTLOC(S,0),U,7)]"":$P(^AUTTLOC(S,0),U,7),1:"??")
 Q S_$P(^AUPNPROB(E,0),U,7)_"  "_$$VAL^XBDIQ1(9000011,E,.05)_$S($P(^AUPNPROB(E,0),U,12)="I":" (INACTIVE)",1:"")
NEXT(E) ;EP - called from trigger
 I '$G(E) Q ""
 I '$D(^BATREG(E,0)) Q ""
 NEW BATLD
 S BATLD=$$LASTAV(E,2)
 I BATLD="" Q ""
 S BATLS=$$LASTSEV($P(^BATREG(E,0),"^"))
 I BATLS=1 Q ""
 Q $$FMADD^XLFDT(BATLD,(6*30))
 ;
LASTPBF(P,F) ;EP
 ;1 value
 ;2 external date
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW G,D,D1,E,BATL
 S G="",D=0 K BATL F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(G]"")  D
 .K BATL S E=0 F  S E=$O(^AUPNVAST("AA",P,D,E)) Q:E'=+E  I $P(^AUPNVAST(E,0),U,7)]"" S BATL(9999999-E)=$P(^AUPNVAST(E,0),U,7)_"^"_(9999999-D)
 .I $D(BATL) S E=$O(BATL(0)),G=$P(BATL(E),U),D1=$P(BATL(E),U,2)
 I '$D(BATL) Q ""
 I F=1 Q G
 I F=2 Q $$FMTE^XLFDT(D1)
 I F=3 Q D1
 Q ""
LASTFV2(P,F) ;EP - return last fev25-75
 ;1 value
 ;2 external date
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW G,D,D1,E,BATL
 S G="",D=0 K BATL F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(G]"")  D
 .K BATL S E=0 F  S E=$O(^AUPNVAST("AA",P,D,E)) Q:E'=+E  I $P(^AUPNVAST(E,0),U,6)]"" S BATL(9999999-E)=$P(^AUPNVAST(E,0),U,6)_"^"_(9999999-D)
 .I $D(BATL) S E=$O(BATL(0)),G=$P(BATL(E),U),D1=$P(BATL(E),U,2)
 I '$D(BATL) Q ""
 I F=1 Q G
 I F=2 Q $$FMTE^XLFDT(D1)
 I F=3 Q D1
 Q ""
LASTSEVD(P,F,EDATE) ;EP - return last severity before a certain date
 ;1 - internal set of codes
 ;2 - internal date
 ;3 - external date
 ;4 - external name
 ;5 - code and external name
 NEW D,LAST,E,S
 I '$G(P) Q ""
 I '$G(EDATE) S EDATE=DT
 I '$G(F) S F=1
 NEW EDATE1 S EDATE1=9999999-EDATE-1
 S D=$O(^AUPNVAST("AS",P,EDATE1))
 I 'D Q ""
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AS",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST Q ""
 S S=^AUPNVAST("AS",P,D,LAST)
 I F=1 Q S
 I F=2 Q 9999999-D
 I F=3 Q $$FMTE^XLFDT(9999999-D)
 I F=4 Q $$EXTSET^XBFUNC(9000010.41,.04,S)
 I F=5 Q S_"-"_$$EXTSET^XBFUNC(9000010.41,.04,S)
 Q ""
 ;
LASTETS(P,F) ;EP
 ;1 value
 ;2 external date
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW G,D,D1,E,BATL
 S G="",D=0 K BATL F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(G]"")  D
 .K BATL S E=0 F  S E=$O(^AUPNVAST("AA",P,D,E)) Q:E'=+E  I $P(^AUPNVAST(E,0),U,8)]"" S BATL(9999999-E)=$$VAL^XBDIQ1(9000010.41,E,.08)_"^"_(9999999-D)
 .I $D(BATL) S E=$O(BATL(0)),G=$P(BATL(E),U),D1=$P(BATL(E),U,2)
 I '$D(BATL) Q ""
 I F=1 Q G
 I F=2 Q $$FMTE^XLFDT(D1)
 Q ""
LASTPARM(P,F) ;EP
 ;1 value
 ;2 external date
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW G,D,D1,E,BATL
 S G="",D=0 K BATL F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(G]"")  D
 .K BATL S E=0 F  S E=$O(^AUPNVAST("AA",P,D,E)) Q:E'=+E  I $P(^AUPNVAST(E,0),U,9)]"" S BATL(9999999-E)=$$VAL^XBDIQ1(9000010.41,E,.09)_"^"_(9999999-D)
 .I $D(BATL) S E=$O(BATL(0)),G=$P(BATL(E),U),D1=$P(BATL(E),U,2)
 I '$D(BATL) Q ""
 I F=1 Q G
 I F=2 Q $$FMTE^XLFDT(D1)
 Q ""
LASTDM(P,F) ;EP
 ;1 value
 ;2 external date
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW G,D,D1,E,BATL
 S G="",D=0 K BATL F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(G]"")  D
 .K BATL S E=0 F  S E=$O(^AUPNVAST("AA",P,D,E)) Q:E'=+E  I $P(^AUPNVAST(E,0),U,11)]"" S BATL(9999999-E)=$$VAL^XBDIQ1(9000010.41,E,.11)_"^"_(9999999-D)
 .I $D(BATL) S E=$O(BATL(0)),G=$P(BATL(E),U),D1=$P(BATL(E),U,2)
 I '$D(BATL) Q ""
 I F=1 Q G
 I F=2 Q $$FMTE^XLFDT(D1)
 Q ""
LASTSEV(P,F) ;PEP;return last severity recorded
 ;1 - internal set of codes
 ;2 - internal date
 ;3 - external date
 ;4 - external name
 ;5 - code and external name
 NEW D,LAST,E,S
 I '$G(P) Q ""
 I '$G(F) S F=1
 S D=$O(^AUPNVAST("AS",P,0))
 I 'D Q ""
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AS",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST Q ""
 S S=^AUPNVAST("AS",P,D,LAST)
 I F=1 Q S
 I F=2 Q 9999999-D
 I F=3 Q $$FMTE^XLFDT(9999999-D)
 I F=4 Q $$EXTSET^XBFUNC(9000010.41,.04,S)
 I F=5 Q S_"-"_$$EXTSET^XBFUNC(9000010.41,.04,S)
 Q ""
 ;
LASTAM(P,F) ;EP - return date of last asthma management plan = yes
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW D S D=$O(^AUPNVAST("AM",P,0))
 I 'D Q ""
 I F=1 Q 9999999-D
 I F=2 Q $$FMTE^XLFDT(9999999-D)
 Q ""
LASTAV(P,F) ;EP;return last visit with an Asthma V file entry
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW D S D=$O(^AUPNVAST("AA",P,0))
 I 'D Q ""
 NEW E S E=$O(^AUPNVAST("AA",P,D,0))
 I 'E Q ""
 I F=1 Q $P($G(^AUPNVAST(E,0)),U,3)
 I F=2 Q $P($P(^AUPNVSIT($P(^AUPNVAST(E,0),U,3),0),U),".")
 I F=3 Q $$FMTE^XLFDT($P(^AUPNVSIT($P(^AUPNVAST(E,0),U,3),0),U),"1D")
 Q ""
LASTDX(P) ;EP - return date of last asthma diagnosis
 I $G(P)="" Q 0
 NEW BATX,BATY,I,S,E
 K BATX
 S BATY="BATX("
 S S=P_"^LAST DX [BAT ASTHMA DIAGNOSES" S E=$$START1^APCLDF(S,BATY)
 I '$D(BATX(1)) Q ""
 Q $P(BATX(1),U)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
XTMP(N,D) ;EP - set xtmp 0 node
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
BANNER ;EP
V ; GET VERSION
 NEW BATV,BATL,BATJ,BATX
 S BATV="1.0"
 I $G(BATTEXT)="" S BATTEXT="TEXT",BATL=3 G PRINT
 S BATTEXT="TEXT"_BATTEXT
 F BATJ=1:1 S BATX=$T(@BATTEXT+BATJ),BATX=$P(BATX,";;",2) Q:BATX="QUIT"!(BATX="")  S BATL=BATJ
PRINT W:$D(IOF) @IOF
 F BATJ=1:1:BATL S BATX=$T(@BATTEXT+BATJ),BATX=$P(BATX,";;",2) W !,$$CTR(BATX,80)
 W !,$$CTR("Version "_BATV)
SITE W !!,$$CTR($$LOC)
 K BATTEXT
 Q
TEXT ;
 ;;**************************
 ;;**   Asthma Register    **
 ;;**************************
 ;;QUIT
 ;
TEXTR ;
 ;;**************************
 ;;**   Asthma Register    **
 ;;**    Reports Menu      **
 ;;**************************
 ;;QUIT
TEXTX ;;
 ;;***************************
 ;;**    Asthma Register    **
 ;;**    QI Reports Menu    **
 ;;***************************
 ;;QUIT
 ;
TEXTP ;;
 ;;******************************
 ;;**     Asthma Register      **
 ;;**    Patient Management    **
 ;;******************************
 ;;QUIT
 ;
TEXTG ;;
 ;;********************************
 ;;**      Asthma Register       **
 ;;**     Register Management    **
 ;;********************************
 ;;QUIT
 ;
TEXTS ;;
 ;;******************************
 ;;**     Asthma Register      **
 ;;**     Register Setup       **
 ;;******************************
 ;;QUIT
 ;
TEXTL ;
 ;;**************************
 ;;**   Asthma Register    **
 ;;**    Letters Menu      **
 ;;**************************
 ;;QUIT
 ;
