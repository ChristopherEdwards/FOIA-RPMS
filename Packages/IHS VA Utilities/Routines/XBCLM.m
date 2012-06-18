XBCLM ; IHS/ADC/GTH - COLUMN LISTER ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Thanks to Don Enos, OHPRD, for the original routine,
 ; 7 Feb 95.
 ;
 ; This routine displays a column number header followed by
 ; the passed string.
 ;
 ;
EP(STR) ;PEP - Column Lister
 Q:$G(STR)=""
 NEW B,C1,C2,CH,CV,CV1,CV2,H,L,LC,X
 KILL DIR,DIRUT
 S CH=$S($L(STR)>80:3,1:2) ;           set column header height
 S LC=$L(STR)\80
 S:($L(STR)/80)>LC LC=LC+1 ;           set loop count
 W:$D(IOF) @IOF
 F L=1:1:LC D LINE Q:$$QUIT($L(STR))
 Q
 ;
LINE ; WRITE HEADER AND ONE LINE
 KILL H
 F C1=1:1:CH D
 . F C2=1:1:80 D  Q:(C2+((L-1)*80))'<$L(STR)
 .. S CV=(C2+((L-1)*80))
 .. S CV1=CV\100,CV2=(CV#100)\10
 .. S $E(H(C1),C2)=$S(C1=CH:$E(C2,$L(C2)),C1=(CH-1):CV2,1:CV1)
 .. Q
 . Q
 S X="",$P(X,"=",80)="="
 W !,X,!
 F C1=1:1:CH W H(C1),!
 S X="",$P(X,"-",80)="-"
 S B=(1+((L-1)*80))
 W X,!,$E(STR,B,B+79),!
 Q
 ;
QUIT(L) ;
 NEW B,C1,C2,CH,CV,CV1,CV2,H,LC,X
 S X=$$DIR^XBDIR("E","<$L="_L_"> Press any key to continue")
 Q $S($D(DIRUT):1,1:0)
 ;
