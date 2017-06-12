APCM25EA ; IHS/CMI/LAB - IHS MU ;
 ;;1.0;MU PERFORMANCE REPORTS;**7,8**;MAR 26, 2012;Build 22
 ;
ET ;
 W ! S APCMZ=0 F  S APCMZ=$O(^APCM25OB(APCMY,N,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM25OB(APCMY,N,APCMZ,0)
 W !
 Q
SS ;EP
 Q
SSH ;EP
 Q
IMMREG ;EP - ask additional exclusion questions for IMM REG
 S APCMQ=0
 S APCMY=$O(^APCM25OB("B",APCMX,0))
 Q:'$D(APCMIND(APCMY))  ;measure not being run
 ;display exclusion text/narrative
 I $O(^APCM25OB(APCMY,19,0)) S N=19 W !! D ET
 I APCMPLTY="SEL"!(APCMPLTY="TAX") D  G:APCMIND=1 IMMIND Q
 .W !!,"Do all selected providers included in this report meet this"
 .S DIR(0)="Y",DIR("A")="exclusion",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .I 'Y S APCMIND=1 Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  S APCMATTE(APCMX,APCMP)="N/A"
IMMIND ;ask individually
 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 .S APCMZ=0 F  S APCMZ=$O(^APCM25OB(APCMY,24,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM25OB(APCMY,24,APCMZ,0)
 .W ! S DIR(0)="Y",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_" meet this exclusion",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMATTE(APCMX,APCMP)=$S(Y:"N/A",1:"")
IMM2 ;display exclusion text/narrative
 S APCMP=0,E=0,T=0 F  S APCMP=$O(APCMATTE(APCMX,APCMP)) Q:APCMP=""!(APCMQ)  D
 .S T=T+1
 .I APCMATTE(APCMX,APCMP)="N/A" S E=E+1 ;excluded so don't ask
 I E=T Q  ;all excluded
 I $O(^APCM25OB(APCMY,31,0)) S N=31 W !! D ET
 ;
IMMIND2 ;ask individually
 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 .Q:APCMATTE(APCMX,APCMP)="N/A"  ;excluded
 .W ! S DIR(0)="Y",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_" attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMATTE(APCMX,APCMP)=$S(Y:"Yes",1:"No")
 Q
SPECREG ;EP
 Q
IMMREGH ;EP - ask additional exclusion questions for IMM REG
 S APCMQ=0
 S APCMY=$O(^APCM25OB("B",APCMX,0))
 Q:'$D(APCMIND(APCMY))  ;measure not being run
 ;display exclusion text/narrative
 I $O(^APCM25OB(APCMY,19,0)) S N=19 W !! D ET
 ;ask individually
 S APCMP=APCMFAC  D
 .S APCMZ=0 F  S APCMZ=$O(^APCM25OB(APCMY,24,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM25OB(APCMY,24,APCMZ,0)
 .W ! S DIR(0)="Y",DIR("A")="Does "_$E($P(^DIC(4,APCMP,0),U,1),1,25)_" meet this exclusion"
 .S DIR("B")="YES"
 .I $P(^APCM25OB(APCMY,0),U,1)="S2.025.H.1" S DIR("B")="NO"
 .KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMATTE(APCMX,APCMP)=$S(Y:"N/A",1:"")
IMMH2 ;display exclusion text/narrative
 S APCMP=0,E=0,T=0 F  S APCMP=$O(APCMATTE(APCMX,APCMP)) Q:APCMP=""!(APCMQ)  D
 .S T=T+1
 .I APCMATTE(APCMX,APCMP)="N/A" S E=E+1 ;excluded so don't ask
 I E=T Q  ;all excluded
 I $O(^APCM25OB(APCMY,31,0)) S N=31 W !! D ET
 ;
IMMINDH2 ;ask individually
 S APCMP=APCMFAC  D
 .Q:APCMATTE(APCMX,APCMP)="N/A"  ;excluded
 .W ! S DIR(0)="Y",DIR("A")="Does "_$E($P(^DIC(4,APCMP,0),U,1),1,25)_" attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMATTE(APCMX,APCMP)=$S(Y:"Yes",1:"No")
 Q
 ;
C(X,X2,X3) ;
 S X3=""
 I X'?.N Q $$LBLK^APCLUTL(X,7)
 D COMMA^%DTC
 S X=$$STRIP^XLFSTR(X," ")
 Q $$LBLK^APCLUTL(X,7)
SEM ;EP - PRINT OUT SEM
 ;W !!,"measure being worked on...will let you know when it is done." Q
 ;write label
 I APCMPTYP="P" D
 .F X=1,2,3 D
 ..S M=APCMIC
 ..I X=1 D W^APCM2AEH(" 9. Secure Messaging 2015+",0,2,APCMPTYP)
 ..I X=2 D W^APCM2AEH("    Secure Messaging 2016",0,1,APCMPTYP)
 ..I X=3 D W^APCM2AEH("    Secure Messaging 2017",0,1,APCMPTYP)
 ..;TARGET
 ..I X=2 S T=">=1"
 ..I X=1 S T="Yes"
 ..I X=3 S T=">5%"
 ..D W^APCM2AEH(T,0,0,APCMPTYP,,35)
 ..;RATE
 ..I X=1 D SETND^APCM2AER
 ..I X=1 D W^APCM2AEH($S(APCMCYD]"":$$LBLK^APCLUTL(APCMCYD,8),1:$$LBLK^APCLUTL("N/A",8)),0,0,APCMPTYP,,40)
 ..I X=2 D
 ...S (APCMCYN,APCMCYD,APCMCYP)=0
 ...S APCMDF=31.02,APCMNF=31.01 D SETND
 ...D W^APCM2AEH($$C(APCMCYN,0,9),0,0,APCMPTYP,,40)  ;RATE IS NUMERATOR
 ..I X=3 D
 ...S (APCMCYN,APCMCYD,APCMCYP)=0
 ...S APCMDF=31.04,APCMNF=31.03 D SETND
 ...D WRATE
 ..;NUM/DEN
 ..I X=1 W ?55,"    N/A",?65,"    N/A"
 ..I X=2!(X=3) D WNUMDEN
 ..;EXCL
 ..D WEXCL
 .Q:'APCMSEME
 .D W^APCM25EH("Note: PHR Server access failed during report generation "_$P(APCMSEME,U,2)_" which may",0,1,APCMPTYP,,0)
 .D W^APCM25EH("have affected the numerator results for this measure. Contact your IT staff to",0,1,APCMPTYP,,0)
 .D W^APCM25EH("resolve the error and then regenerate the report again to obtain accurate",0,1,APCMPTYP,,0)
 .D W^APCM25EH("results.",0,1,APCMPTYP,,0)
 I APCMPTYP="D" D
 .F X=1,2,3 D
 ..S M=APCMIC
 ..I X=1 S APCMX="Secure Messaging 2015+"
 ..I X=2 S APCMX="Secure Messaging 2016"
 ..I X=3 S APCMX="Secure Messaging 2017"
 ..;TARGET
 ..I X=2 S T=">=1"
 ..I X=1 S T="Yes"
 ..I X=3 S T=">5%"
 ..S $P(APCMX,U,2)=T
 ..;RATE
 ..I X=1 D SETND^APCM2AER S $P(APCMX,U,3)=APCMCYD
 ..I X=2 D
 ...S (APCMCYN,APCMCYD,APCMCYP)=0
 ...S APCMDF=31.02,APCMNF=31.01 D SETND
 ...S $P(APCMX,U,3)=APCMCYN  ;RATE IS NUMERATOR
 ..I X=3 D
 ...S (APCMCYN,APCMCYD,APCMCYP)=0
 ...S APCMDF=31.04,APCMNF=31.03 D SETND
 ...S $P(APCMX,U,3)=$$SB^APCM25ER($J(APCMCYP,8,2))_"%"
 ..;NUM/DEN
 ..I X=1 S $P(APCMX,U,4)="N/A",$P(APCMX,U,5)="N/A"
 ..I X=2!(X=3) D WNUMDEN
 ..D WEXCL
 ..I X=2!(X=3) D W^APCM25EH(APCMX,0,1,APCMPTYP,1)
 ..I X=1 D W^APCM25EH(APCMX,0,2,APCMPTYP,1)
 .Q:'APCMSEME
 .D W^APCM25EH("Note: PHR Server access failed during report generation "_$P(APCMSEME,U,2)_" which may",0,1,APCMPTYP,1)
 .D W^APCM25EH("have affected the numerator results for this measure. Contact your IT staff to",0,1,APCMPTYP,1)
 .D W^APCM25EH("resolve the error and then regenerate the report again to obtain accurate results.",0,1,APCMPTYP,1)
 Q
SETND ;
 ;S APCMDF=$P(^APCM25OB(M,0),U,8)
 S APCMNP=$P(^DD(9001304.0311,APCMDF,0),U,4),N=$P(APCMNP,";"),P=$P(APCMNP,";",2)
 S APCMCYD=$$V^APCM25ER(1,APCMRPT,N,P,APCMPROV,$S($G(APCMTOT):"T",1:"I"),APCMRPTT)
 I $P(^APCM25OB(M,0),U,6)="A" S (APCMPRN,APCMCYN)="" Q
 ;S APCMNF=$P(^APCM25OB(M,0),U,9)  ;numerator field
 S APCMNP=$P(^DD(9001304.0311,APCMNF,0),U,4),N=$P(APCMNP,";"),P=$P(APCMNP,";",2)
 D SETN
 Q
SETN ;EP - set numerator fields
 S APCMCYN=$$V^APCM25ER(1,APCMRPT,N,P,APCMPROV,$S($G(APCMTOT):"T",1:"I"),APCMRPTT) ;SPDX
 Q:$P(^APCM25OB(APCMIC,0),U,6)="A"  ;no % on attestation measures
 S APCMCYP=$S(APCMCYD:((APCMCYN/APCMCYD)*100),1:"")
 Q
WRATE ;
 I APCMPTYP="P" D  Q
 .I $P(^APCM25OB(M,0),U,6)="A" D W^APCM2AEH($S(APCMCYD]"":$$LBLK^APCLUTL(APCMCYD,8),1:$$LBLK^APCLUTL("N/A",8)),0,0,APCMPTYP,,42)
 .I $P(^APCM25OB(M,0),U,6)'="A" D W^APCM2AEH($J(APCMCYP,8,2)_"%",0,0,APCMPTYP,,42)
 I $P(^APCM25OB(M,0),U,6)="A" S $P(APCMX,U,3)=$S(APCMCYD]"":APCMCYD,1:"N/A")
 I $P(^APCM25OB(M,0),U,6)'="A" S $P(APCMX,U,3)=$S($P(^APCM25OB(M,0),U,6)="A":"N/A",1:$J(APCMCYP,8,2)_"%")
 Q
WNUMDEN ;
 I APCMPTYP="P" D  Q
 .D W^APCM2AEH($S($P(^APCM25OB(M,0),U,6)="A":"    N/A",APCMCYN'?.N:"    N/A",1:$$C(APCMCYN,0,9)),0,0,APCMPTYP,,55)
 .D W^APCM2AEH($S($P(^APCM25OB(M,0),U,6)="A":"    N/A",APCMCYD'?.N:"    N/A",1:$$C(APCMCYD,0,9)),0,0,APCMPTYP,,65)
 S $P(APCMX,U,4)=$S($P(^APCM25OB(M,0),U,6)="A":"N/A",1:+APCMCYN)
 S $P(APCMX,U,5)=$S($P(^APCM25OB(M,0),U,6)="A":"N/A",1:+APCMCYD)
 Q
WEXCL ;
 S APCMEF=$P(^APCM25OB(M,0),U,11)
 I APCMEF]"" D
 .S APCMNP=$P(^DD(9001304.0311,APCMEF,0),U,4),N=$P(APCMNP,";"),P=$P(APCMNP,";",2)
 .S APCMEV=$$V^APCM25ER(1,APCMRPT,N,P,APCMPROV,$S($G(APCMTOT):"T",1:"I"),APCMRPTT)
 .I APCMPTYP="P" D W^APCM25EH($S(APCMEV="N/A":"N/A",APCMEV]"":"Yes",1:"No"),0,0,APCMPTYP,,76)
 .I APCMPTYP="D" S $P(APCMX,U,6)=$S(APCMEV="N/A":"N/A",APCMEV]"":"Yes",1:"No")
 I APCMEF="" D
 .I APCMPTYP="P" D W^APCM25EH("N/A",0,0,APCMPTYP,,76)
 .S $P(APCMX,U,6)="N/A"
 Q
