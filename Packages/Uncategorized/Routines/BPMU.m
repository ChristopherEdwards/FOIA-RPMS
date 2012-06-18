BPMU ; IHS/OIT/LJF - IHS CODE CALLED BY MERGE FUNCTION
 ;;1.0;IHS PATIENT MERGE;;MAR 01, 2010
 ;
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,Y,DIRUT
 S DIR(0)=TYPE
 I $E(TYPE,1)="P",$P(TYPE,":",2)["L" S DLAYGO=+$P(TYPE,U,2)
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
PAUSE ;EP; -- ask user to press return - no form feed
 NEW DIR Q:IOST'["C-"
 S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR
 Q
 ;
ZIS(X,BPMRTN,BPMDESC,BPMVAR,BPMDEV) ;EP; -- called to select device and send print
 K %ZIS,IOP,ZTIO
 I X="F" D     ;forced queuing; no user interaction
 . S ZTIO=BPMDEV,ZTDTH=$H
 E  D   Q:POP  I '$D(IO("Q")) D @BPMRTN Q
 . S %ZIS=X I $G(BPMDEV)]"" S %ZIS("B")=BPMDEV
 . D ^%ZIS
 ;
 K IO("Q") S ZTRTN=BPMRTN,ZTDESC=BPMDESC
 F I=1:1 S J=$P(BPMVAR,";",I) Q:J=""  S ZTSAVE(J)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 Q
 ;
HRCN(PAT,SITE) ;EP; return chart number for patient at this site
 ;called by XDRMERGA
 I ('$G(PAT))!('$G(SITE)) Q "??"
 Q $P($G(^AUPNPAT(PAT,41,SITE,0)),U,2)
