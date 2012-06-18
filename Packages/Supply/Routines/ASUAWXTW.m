ASUAWXTW ;DSD/DFM - EXTRACT TRANS - RE-EXTRACT AND DATA ENTRY ONLY OPTIONS;  [ 04/15/98  3:01 PM ]
 ;;3.0;SAMS;**1**;AUG 20, 1993
REXT ;PEP;RE-EXTRACT
 S DIR(0)="Y",DIR("A")="DO YOU WISH TO RE-EXTRACT TRANSACTIONS"
 S DIR("?",1)="Enter 'Y' to re-extract previously extracted, or"
 S DIR("?")=" 'N' to be prompted for a regular extract of updated transactions."
 D ^DIR K DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 G:Y CONTURXT
 S DIR(0)="Y",DIR("A")="DO YOU WISH TO EXTRACT UPDATED TRANSACTIONS"
 S DIR("?",1)="Enter 'Y' to extract updated transactions, or"
 S DIR("?")=" 'N' to end this option selection."
 D ^DIR K DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 G:Y BEGIN^ASUAWXT
 Q
CONTURXT ;
 S ASUW("TYPE LAST RUN")=^ASUTLRUN(1,0)
 S $P(ASUW("TYPE LAST RUN"),U,2)=8
 D:'$D(U) ^XBKVAR
 I '$D(IO(0)) S IOP=$I D ^%ZIS
 S ASUW("RUN TYPE")=$G(ASUW("RUN TYPE")) S:ASUW("RUN TYPE")']"" ASUW("RUN TYPE")=0
REXT2 ;EP ; RE-EXTRACT DATA
 S DIR(0)="D",DIR("A")="ENTER RE-EXTRACT DATE",DIR("?")="^D DATEHELP^ASUAWXTW" D ^DIR Q:$D(DTOUT)  Q:$D(DUOUT)!($D(DIROUT))
 S ASUX("EXTRACT DATE")=Y X ^DD("DD") W " ",Y
 K DIR,Y G OPNHFS^ASUAWXT
DATEHELP ;
 W !,"Enter the Extracted Date on records to be re-extracted.  Dates in Issues are:"
 S X=0 F  S X=$O(^ASU3("AX",X)) Q:X'?1N.N  W !,$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 Q
DAOL ;PEP; DATA ENTRY ONLY
 S ASUW("TYPE LAST RUN")=^ASUTLRUN(1,0)
 S $P(ASUW("TYPE LAST RUN"),U,2)=9,ASUX("EXTRACT DATE")=DT
 D:'$D(U) ^XBKVAR
 I '$D(IO(0)) S IOP=$I D ^%ZIS
 S ASUW("RUN TYPE")=$G(ASUW("RUN TYPE"))
 S:ASUW("RUN TYPE")']"" ASUW("RUN TYPE")=0
 D:'$D(ASUK("DATE","RUNMO")) GETRUN^ASUAUTL1
 G OPNHFS^ASUAWXT
END ;
 Q
