BMCRLU ; IHS/PHXAO/TMJ - GEN RETR UTILITIES ;     
 ;;4.0;REFERRED CARE INFO SYSTEM;**3**;JAN 09, 2006
 ;IHS/ITSC/FCJ REMOVED THE () FOR PRINTING ACT OR EST; FX DT FORMAT
 ;4.0*3 10.30.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LZERO(V,L) ;left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
 ;
ANYINS(P,D) ;EP - return 1 or 0 if patient has any insurance
 NEW BMCA
 S BMCA=0
 S BMCA=$$MCR^AUPNPAT(P,D) I BMCA Q BMCA
 S BMCA=$$MCD^AUPNPAT(P,D) I BMCA Q BMCA
 S BMCA=$$PI^AUPNPAT(P,D) I BMCA Q BMCA
 S BMCA=$$RAIL(P,D)
 Q BMCA
AVDX(R,A,T) ;EP - return array of available dx's
 NEW BMCFLG,BMCX
 I $G(T)="" S T="N"
 S BMCFLG=0
 I $G(A)="" S A="BMCAVDX"
 K @A
 I 'R S BMCFLG=1 Q BMCFLG
 I '$D(^BMCREF(R)) S BMCFLG=2 Q BMCFLG
 S (BMCX,C)=0 F  S BMCX=$O(^BMCDX("AD",R,BMCX)) Q:BMCX'=+BMCX  I $P(^BMCDX(BMCX,0),U,4)="F" S C=C+1 D SETDX
 I C=0 S BMCX=0 F  S BMCX=$O(^BMCDX("AD",R,BMCX)) Q:BMCX'=+BMCX  I $P(^BMCDX(BMCX,0),U,4)="P" S C=C+1 D SETDX
 Q BMCFLG
SETDX ;
 I T="N" S @A@($P(^BMCDX(BMCX,0),U))="" Q
 ;4.0*3 10.30.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 4 LINES
 ;I T="E" S @A@($P(^ICD9($P(^BMCDX(BMCX,0),U),0),U))="" Q
 I T="E" S @A@($P($$ICDDX^ICDCODE($P(^BMCDX(BMCX,0),U),0),U,2))="" Q
 ;I T="I" S @A@($P(^ICD9($P(^BMCDX(BMCX,0),U),0),U,3))="" Q
 I T="I" S @A@($P($$ICDDX^ICDCODE($P(^BMCDX(BMCX,0),U),0),U,4))="" Q
 Q
AVOP(R,A,T) ;EP
 NEW BMCFLG,BMCX
 I $G(T)="" S T="N"
 S BMCFLG=0
 I $G(A)="" S A="BMCAVOP"
 K @A
 I 'R S BMCFLG=1 Q BMCFLG
 I '$D(^BMCREF(R)) S BMCFLG=2 Q BMCFLG
 S (BMCX,C)=0 F  S BMCX=$O(^BMCPX("AD",R,BMCX)) Q:BMCX'=+BMCX  I $P(^BMCPX(BMCX,0),U,4)="F" S C=C+1 D SETOP
 I C=0 S BMCX=0 F  S BMCX=$O(^BMCPX("AD",R,BMCX)) Q:BMCX'=+BMCX  I $P(^BMCPX(BMCX,0),U,4)="P" S C=C+1 D SETOP
 Q BMCFLG
SETOP ;
 I T="N" S @A@($P(^BMCPX(BMCX,0),U))="" Q
 ;4.0*3 10.30.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 4 LINES
 ;I T="E" S @A@($P(^ICPT($P(^BMCPX(BMCX,0),U),0),U))="" Q
 I T="E" S @A@($P($$CPT^ICPTCOD($P(^BMCPX(BMCX,0),U),0),U,2))="" Q
 ;I T="I" S @A@($P(^ICPT($P(^BMCPX(BMCX,0),U),0),U,2))="" Q
 I T="I" S @A@($P($$CPT^ICPTCOD($P(^BMCPX(BMCX,0),U),0),U,3))="" Q
 I T="P",$P(^BMCPX(BMCX,0),U,6) S @A@(BMCX)=$P(^AUTNPOV($P(^BMCPX(BMCX,0),U,6),0),U) Q
 Q
AVDOS(R,F) ;EP - return available date of service (actual or estimated) in either internal or external format
 NEW BMCDOS
 I $G(F)="" S F="E"
 S BMCDOS=""
 S BMCDOS=$S($P($G(^BMCREF(R,11)),U,6)]"":$P(^BMCREF(R,11),U,6),1:$P($G(^BMCREF(R,11)),U,5))
 I BMCDOS="" Q BMCDOS
 I F="N" Q BMCDOS
 I F="E" S BMCDOS=$$FMTE^XLFDT(BMCDOS,"2P")
 I F="S" S BMCDOS=$E(BMCDOS,4,5)_"/"_$E(BMCDOS,6,7)_"/"_$E(BMCDOS,2,3)
 I F="C" S BMCDOS=$E(BMCDOS,4,5)_"/"_$E(BMCDOS,6,7)_"/"_$E(BMCDOS,2,3)_" "_$S($$VAL^XBDIQ1(90001,R,1106)]"":"A",1:"E")
 Q BMCDOS
AVEOS(R,F) ;EP return available end date of service
 NEW BMCDOS
 I $G(F)="" S F="E"
 S BMCDOS=""
 S BMCDOS=$S($P($G(^BMCREF(R,11)),U,8)]"":$P(^BMCREF(R,11),U,8),1:$P($G(^BMCREF(R,11)),U,7))
 I F="E",BMCDOS]"" S BMCDOS=$$FMTE^XLFDT(BMCDOS)
 I F="S",BMCDOS]"" S Y=BMCDOS D DT1^BMCOSUT S BMCDOS=Y_" "_$S($$VAL^XBDIQ1(90001,R,1106)]"":"A",1:"E")
 I F="N" Q BMCDOS
 Q BMCDOS
AVLOS(R,F) ;EP return available LOS
 I $G(F)="" S F="I"
 NEW %
 S %=$S($P($G(^BMCREF(R,11)),U,10):$P($G(^BMCREF(R,11)),U,10),1:$P($G(^BMCREF(R,11)),U,9))
 I %="" Q %
 I F="C" S %=%_$S($P($G(^BMCREF(R,11)),U,10):" A",1:" E")
 Q %
AVICOST(R) ; EP
 ;best available IHS cost is 1104 if available, else the larger of
 ;1103 or 1117
 I $G(^BMCREF(R,11))="" Q ""
 S %=0 F %1=4,3,17 S %=%+$P(^BMCREF(R,11),U,%1)
 I '% Q ""
 I $P(^BMCREF(R,11),U,4) Q $P(^(11),U,4)
 I $P(^BMCREF(R,11),U,3)>$P(^BMCREF(R,11),U,17) Q $P(^BMCREF(R,11),U,3)
 E  Q $P(^BMCREF(R,11),U,17)
 Q ""
 ;
AVTCOST(R) ; EP
 ;Final Total Referral Costs 1102 if available Else Estimated Total 
 ;Costs 1101 Total Referral Cost to Date 1119 whichever is larger
 I $G(^BMCREF(R,11))="" Q ""
 S %=0 F %1=2,1,19 S %=%+$P(^BMCREF(R,11),U,%1)
 I '% Q ""
 I $P(^BMCREF(R,11),U,2) Q $P(^(11),U,2)
 I $P(^BMCREF(R,11),U)>$P(^BMCREF(R,11),U,19) Q $P(^BMCREF(R,11),U)
 E  Q $P(^BMCREF(R,11),U,19)
 Q ""
FACREF(R) ;EP return facility referred to (piece 7-8-9)
 N BMCF,%
 S %=^BMCREF(R,0)
 S BMCF=$S($P(%,U,7):$P($G(^AUTTVNDR($P(%,U,7),0)),U),$P(%,U,8):$P(^DIC(4,$P(%,U,8),0),U),$P(%,U,9):$P($G(^BMCLPRV($P(%,U,9),0)),U),$P(%,U,23):$P(^DIC(40.7,$P(%,U,23),0),U),1:"<UNKNOWN>")
 Q BMCF
CASEMAN(R) ;EP return case manager
 Q $S($P(^BMCREF(R,0),U,19)]"":$P(^VA(200,$P(^BMCREF(R,0),U,19),0),U),1:"??")
REFDTI(R,F) ; EP - Date Referral Initiated
 NEW BMCDOS
 I $G(F)="" S F="E"
 S BMCDOS=""
 S BMCDOS=$S($P($G(^BMCREF(R,0)),U)]"":$P(^BMCREF(R,0),U),1:$P($G(^BMCREF(R,0)),U,6))
 I BMCDOS="" Q BMCDOS
 I F="E" S BMCDOS=$$FMTE^XLFDT(BMCDOS)
 I F="S" S BMCDOS=$E(BMCDOS,4,5)_"/"_$E(BMCDOS,6,7)_"/"_$E(BMCDOS,2,3)
 I F="C" S BMCDOS=$E(BMCDOS,4,5)_"/"_$E(BMCDOS,6,7)_"/"_$E(BMCDOS,2,3)_" "_$S($$VAL^XBDIQ1(90001,R,.01)]"":"A",1:"E")
 Q BMCDOS
 ;
 ;
EXPBGDT(R,F) ;Expected Begin Date of Service
 NEW BMCDOS
 I $G(F)="" S F="E"
 S BMCDOS=""
 S BMCDOS=$P($G(^BMCREF(R,11)),U,5)
 I F="E",BMCDOS]"" S BMCDOS=$$FMTE^XLFDT(BMCDOS)
 I F="S",BMCDOS]"" S Y=BMCDOS D DT1^BMCOSUT S BMCDOS=Y
 I F="N" Q BMCDOS
 Q BMCDOS
 ;
 ;
EXPENDT(R,F) ;Expected End DOS
 NEW BMCDOS
 I $G(F)="" S F="E"
 S BMCDOS=""
 S BMCDOS=$P($G(^BMCREF(R,11)),U,7)
 I F="E",BMCDOS]"" S BMCDOS=$$FMTE^XLFDT(BMCDOS)
 I F="S",BMCDOS]"" S Y=BMCDOS D DT1^BMCOSUT S BMCDOS=Y
 I F="N" Q BMCDOS
 Q BMCDOS
 ;
ACTBDT(R,F) ;Actual Beginning DOS
 NEW BMCDOS
 I $G(F)="" S F="E"
 S BMCDOS=""
 S BMCDOS=$P($G(^BMCREF(R,11)),U,6)
 I F="E",BMCDOS]"" S BMCDOS=$$FMTE^XLFDT(BMCDOS)
 I F="S",BMCDOS]"" S Y=BMCDOS D DT1^BMCOSUT S BMCDOS=Y
 I F="N" Q BMCDOS
 Q BMCDOS
ACTDT(R,F) ;Actual End DOS
 NEW BMCDOS
 I $G(F)="" S F="E"
 S BMCDOS=""
 S BMCDOS=$P($G(^BMCREF(R,11)),U,8)
 I F="E",BMCDOS]"" S BMCDOS=$$FMTE^XLFDT(BMCDOS)
 I F="S",BMCDOS]"" S Y=BMCDOS D DT1^BMCOSUT S BMCDOS=Y
 I F="N" Q BMCDOS
 Q BMCDOS
 ;
RAIL(P,D) ;EP - Check for Railroad Retirement Data
 Q $$RRR^BMCRLU1(P,D)
CSECOM(R,D) ;EP -TEST FOR SORT BY, IF BY CSE COM DATES NEED TO TEST FOR DATES
 ;4.0 IHS/OIT/FCJ ADDED FOR CASE COMMENTS
 S X=1,Y=0  F  S Y=$O(^BMCRTMP(BMCRPT,11,Y)) Q:Y'?1N.N  D
 .S (X1,X2)=1
 .I $P(^BMCTSORT(Y,0),U)="Case Rev Comment Dt" D
 ..S X1=0,X3=$P(^BMCCOM(D,0),U)
 ..Q:X3<$P(^BMCRTMP(BMCRPT,11,Y,11,1,0),U)
 ..Q:X3>$P(^BMCRTMP(BMCRPT,11,Y,11,1,0),U,2)
 ..S X1=1
 .I $P(^BMCTSORT(Y,0),U)="Case Reviewer" D
 ..S X2=0
 ..S Y1=0 F  S Y1=$O(^BMCRTMP(BMCRPT,11,Y,11,Y1)) Q:Y1'?1N.N  D  Q:X2=1
 ...Q:$P(^BMCCOM(D,0),U,4)'=$P(^BMCRTMP(BMCRPT,11,Y,11,Y1,0),U)
 ...S X2=1
 .I 'X1!'X2 S X=0
 Q X
