AZXARLU ; IHS/PHXAO/TMJ - ROI GEN RETR UTILITIES ; 
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;IHS/PHXAO/TMJ Patch #1 - Fix Best Avail DX & PX
 ;IHS/PHXAO/TMJ Patch #3 - Fix Appt Dt to print Readable Time
 ;
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
 NEW AZXAA
 S AZXAA=0
 S AZXAA=$$MCR^AUPNPAT(P,D) I AZXAA Q AZXAA
 S AZXAA=$$MCD^AUPNPAT(P,D) I AZXAA Q AZXAA
 S AZXAA=$$PI^AUPNPAT(P,D)
 Q AZXAA
AVDX(R,A,T) ;EP - return array of available dx's
 NEW AZXAFLG,AZXAX
 I $G(T)="" S T="N"
 S AZXAFLG=0
 I $G(A)="" S A="AZXAAVDX"
 K @A
 I 'R S AZXAFLG=1 Q AZXAFLG
 I '$D(^AZXAREC(R)) S AZXAFLG=2 Q AZXAFLG ;IHS/PHXAO/TMJ Patch #1 11/20/97
 S (AZXAX,C)=0 F  S AZXAX=$O(^AZXADX("AD",R,AZXAX)) Q:AZXAX'=+AZXAX  I $P(^AZXADX(AZXAX,0),U,4)="F" S C=C+1 D SETDX
 I C=0 S AZXAX=0 F  S AZXAX=$O(^AZXADX("AD",R,AZXAX)) Q:AZXAX'=+AZXAX  I $P(^AZXADX(AZXAX,0),U,4)="P" S C=C+1 D SETDX
 Q AZXAFLG
SETDX ;
 I T="N" S @A@($P(^AZXADX(AZXAX,0),U))="" Q
 I T="E" S @A@($P(^ICD9($P(^AZXADX(AZXAX,0),U),0),U))="" Q
 I T="I" S @A@($P(^ICD9($P(^AZXADX(AZXAX,0),U),0),U,3))="" Q
 ;I T="P",$P(^AZXADX(AZXAX,0),U,6) S @A@(AZXAX)=$P(^AUTNPOV($P(^AZXADX(AZXAX,0),U,6),0),U) Q
 Q
AVOP(R,A,T) ;EP
 NEW AZXAFLG,AZXAX
 I $G(T)="" S T="N"
 S AZXAFLG=0
 I $G(A)="" S A="AZXAAVOP"
 K @A
 I 'R S AZXAFLG=1 Q AZXAFLG
 I '$D(^AZXAREC(R)) S AZXAFLG=2 Q AZXAFLG ;IHS/PHXAO/TMJ Patch #1 11/20/97
 S (AZXAX,C)=0 F  S AZXAX=$O(^AZXAPX("AD",R,AZXAX)) Q:AZXAX'=+AZXAX  I $P(^AZXAPX(AZXAX,0),U,4)="F" S C=C+1 D SETOP
 I C=0 S AZXAX=0 F  S AZXAX=$O(^AZXAPX("AD",R,AZXAX)) Q:AZXAX'=+AZXAX  I $P(^AZXAPX(AZXAX,0),U,4)="P" S C=C+1 D SETOP
 Q AZXAFLG
SETOP ;
 I T="N" S @A@($P(^AZXAPX(AZXAX,0),U))="" Q
 I T="E" S @A@($P(^ICPT($P(^AZXAPX(AZXAX,0),U),0),U))="" Q  ;IHS/PHXAO/TMJ Patch #1 11/20/97
 I T="I" S @A@($P(^ICPT($P(^AZXAPX(AZXAX,0),U),0),U,2))="" Q  ;IHS/PHXAO/TMJ Patch #1 11/20/97
 I T="P",$P(^AZXAPX(AZXAX,0),U,6) S @A@(AZXAX)=$P(^AUTNPOV($P(^AZXAPX(AZXAX,0),U,6),0),U) Q
 Q
AVDOS(R,F) ;EP - return available Date of Disclosure
 NEW AZXADOS
 I $G(F)="" S F="S"
 S AZXADOS=""
 S AZXADOS=$P($G(^AZXAREC(R,0)),U,19)
 I AZXADOS="" Q AZXADOS
 I F="N" Q AZXADOS  ;IHS/PHXAO/TMJ Patch #1
 I F="E" S AZXADOS=$$FMTE^XLFDT(AZXADOS,"2P") ;IHS/PHXAO/TMJ Patch #3
 I F="S" S AZXADOS=$E(AZXADOS,4,5)_"/"_$E(AZXADOS,6,7)_"/"_$E(AZXADOS,2,3)
 I F="C" S AZXADOS=$E(AZXADOS,4,5)_"/"_$E(AZXADOS,6,7)_"/"_$E(AZXADOS,2,3)_" ("_$S($$VAL^XBDIQ1(90001,R,.19)]"":"A)",1:"E)")
 Q AZXADOS
AVEOS(R,F) ;EP return available end date of service
 NEW AZXADOS
 I $G(F)="" S F="E"
 S AZXADOS=""
 S AZXADOS=$S($P($G(^AZXAREC(R,11)),U,8)]"":$P(^AZXAREC(R,11),U,8),1:$P($G(^AZXAREC(R,11)),U,7))
 I F="E",AZXADOS]"" S AZXADOS=$$FMTE^XLFDT(AZXADOS)
 I F="S",AZXADOS]"" S AZXADOS=$$FMTE^XLFDT(AZXADOS,"2D")
 I F="N" Q AZXADOS  ;IHS/PHXAO/TMJ Patch #1
 Q AZXADOS
AVLOS(R,F) ;EP return available LOS
 I $G(F)="" S F="I"
 NEW %
 S %=$S($P($G(^AZXAREC(R,11)),U,10):$P($G(^AZXAREC(R,11)),U,10),1:$P($G(^AZXAREC(R,11)),U,9))
 I %="" Q %
 I F="C" S %=%_$S($P($G(^AZXAREC(R,11)),U,10):" (A)",1:" (E)")
 Q %
AVICOST(R) ; EP
 ;best available IHS cost is 1104 if available, else the larger of
 ;1103 or 1117
 I $G(^AZXAREC(R,11))="" Q ""
 S %=0 F %1=4,3,17 S %=%+$P(^AZXAREC(R,11),U,%1)
 I '% Q ""
 I $P(^AZXAREC(R,11),U,4) Q $P(^(11),U,4)
 I $P(^AZXAREC(R,11),U,3)>$P(^AZXAREC(R,11),U,17) Q $P(^AZXAREC(R,11),U,3)
 E  Q $P(^AZXAREC(R,11),U,17)
 Q ""
 ;
AVTCOST(R) ; EP
 ;Final Total Referral Costs 1102 if available Else Estimated Total 
 ;Costs 1101 Total Referral Cost to Date 1119 whichever is larger
 I $G(^AZXAREC(R,11))="" Q ""
 S %=0 F %1=2,1,19 S %=%+$P(^AZXAREC(R,11),U,%1)
 I '% Q ""
 I $P(^AZXAREC(R,11),U,2) Q $P(^(11),U,2)
 I $P(^AZXAREC(R,11),U)>$P(^AZXAREC(R,11),U,19) Q $P(^AZXAREC(R,11),U)
 E  Q $P(^AZXAREC(R,11),U,19)
 Q ""
FACREF(R) ;EP return facility referred to (piece 7-8-9)
 N AZXAF,%
 S %=^AZXAREC(R,0)
 S AZXAF=$S($P(%,U,6):$P($G(^AZXAREQ($P(%,U,6),0)),U),1:"<UNKNOWN>")
 ;S AZXAF=$S($P(%,U,7):$P($G(^AUTTVNDR($P(%,U,7),0)),U),$P(%,U,8):$P(^DIC(4,$P(%,U,8),0),U),$P(%,U,9):$P($G(^AZXALPRV($P(%,U,9),0)),U),$P(%,U,23):$P(^DIC(40.7,$P(%,U,23),0),U),1:"<UNKNOWN>")
 Q AZXAF
CASEMAN(R) ;EP return case manager
 Q $S($P(^AZXAREC(R,0),U,19)]"":$P(^VA(200,$P(^AZXAREC(R,0),U,19),0),U),1:"??")
REFDTI(R,F) ; EP - Date Referral Initiated
 NEW AZXADOS
 I $G(F)="" S F="E"
 S AZXADOS=""
 S AZXADOS=$S($P($G(^AZXAREC(R,0)),U)]"":$P(^AZXAREC(R,0),U),1:$P($G(^AZXAREC(R,0)),U,6))
 I AZXADOS="" Q AZXADOS
 I F="E" S AZXADOS=$$FMTE^XLFDT(AZXADOS)
 I F="S" S AZXADOS=$E(AZXADOS,4,5)_"/"_$E(AZXADOS,6,7)_"/"_$E(AZXADOS,2,3)
 I F="C" S AZXADOS=$E(AZXADOS,4,5)_"/"_$E(AZXADOS,6,7)_"/"_$E(AZXADOS,2,3)_" ("_$S($$VAL^XBDIQ1(90001,R,.01)]"":"A)",1:"E)")
 Q AZXADOS
