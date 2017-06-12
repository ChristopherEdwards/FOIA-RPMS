APCM24EA ; IHS/CMI/LAB - IHS MU ;
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;
ET ;
 W ! S APCMZ=0 F  S APCMZ=$O(^APCM24OB(APCMY,N,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM24OB(APCMY,N,APCMZ,0)
 W !
 Q
SS ;EP
 Q
SSH ;EP
 Q
IMMREG ;EP - ask additional exclusion questions for IMM REG
 S APCMQ=0
 S APCMY=$O(^APCM24OB("B",APCMX,0))
 Q:'$D(APCMIND(APCMY))  ;measure not being run
 ;display exclusion text/narrative
 I $O(^APCM24OB(APCMY,19,0)) S N=19 W !! D ET
 I APCMPLTY="SEL"!(APCMPLTY="TAX") D  G:APCMIND=1 IMMIND Q
 .W !!,"Do all selected providers included in this report meet this"
 .S DIR(0)="Y",DIR("A")="exclusion",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .I 'Y S APCMIND=1 Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  S APCMATTE(APCMX,APCMP)="N/A"
IMMIND ;ask individually
 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 .S APCMZ=0 F  S APCMZ=$O(^APCM24OB(APCMY,24,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM24OB(APCMY,24,APCMZ,0)
 .W ! S DIR(0)="Y",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_" meet this exclusion",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMATTE(APCMX,APCMP)=$S(Y:"N/A",1:"")
IMM2 ;display exclusion text/narrative
 S APCMP=0,E=0,T=0 F  S APCMP=$O(APCMATTE(APCMX,APCMP)) Q:APCMP=""!(APCMQ)  D
 .S T=T+1
 .I APCMATTE(APCMX,APCMP)="N/A" S E=E+1 ;excluded so don't ask
 I E=T Q  ;all excluded
 I $O(^APCM24OB(APCMY,31,0)) S N=31 W !! D ET
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
 S APCMY=$O(^APCM24OB("B",APCMX,0))
 Q:'$D(APCMIND(APCMY))  ;measure not being run
 ;display exclusion text/narrative
 I $O(^APCM24OB(APCMY,19,0)) S N=19 W !! D ET
 ;ask individually
 S APCMP=APCMFAC  D
 .S APCMZ=0 F  S APCMZ=$O(^APCM24OB(APCMY,24,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM24OB(APCMY,24,APCMZ,0)
 .W ! S DIR(0)="Y",DIR("A")="Does "_$E($P(^DIC(4,APCMP,0),U,1),1,25)_" meet this exclusion"
 .S DIR("B")="YES"
 .I $P(^APCM24OB(APCMY,0),U,1)="S2.025.H.1" S DIR("B")="NO"
 .KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMATTE(APCMX,APCMP)=$S(Y:"N/A",1:"")
IMMH2 ;display exclusion text/narrative
 S APCMP=0,E=0,T=0 F  S APCMP=$O(APCMATTE(APCMX,APCMP)) Q:APCMP=""!(APCMQ)  D
 .S T=T+1
 .I APCMATTE(APCMX,APCMP)="N/A" S E=E+1 ;excluded so don't ask
 I E=T Q  ;all excluded
 I $O(^APCM24OB(APCMY,31,0)) S N=31 W !! D ET
 ;
IMMINDH2 ;ask individually
 S APCMP=APCMFAC  D
 .Q:APCMATTE(APCMX,APCMP)="N/A"  ;excluded
 .W ! S DIR(0)="Y",DIR("A")="Does "_$E($P(^DIC(4,APCMP,0),U,1),1,25)_" attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMATTE(APCMX,APCMP)=$S(Y:"Yes",1:"No")
 Q
