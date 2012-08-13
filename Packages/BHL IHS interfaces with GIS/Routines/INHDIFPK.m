INHDIFPK ;MTM; 12 Apr 94 15:03; difrom/package file utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
HELP(D000,SUB,PTR) ;  Help logic for PACKAGE file.
 N D,DIC,DIX,DS,DZ,Y I $D(DWD)>9 S DIC("IOSL")=6
 S DIC="^DIC(9.4,D000,"""_SUB_""",",DIC(0)="EQZ",X="?" D ^DIC
 Q:$G(PTR)=""
 S Y=$$YN^UTSRD("Want more help? ;1;") Q:'Y
 S X="??",DIC=PTR D ^DIC
 Q
LOOKUP(DIC,X,Y,XQY) ;  Lookup logic for PACKAGE file.
 N DIX,DS S DIC(0)="EQZ" I $D(DWD)>9 S DIC("IOSL")=6
 K XQY,Y D ^DIC I Y<0 K X Q
 S X=$P(Y(0),U),XQY(0)=Y(0)
 Q
YN ;  Yes/No reader for installing inits.
 W $G(%A),"? "
Y ;
 W $P("YES// ^NO// ",U,%) S %1=%
RX R %Y:$S($G(DTIME):DTIME,1:300) E  S DTOUT=1,%Y=U W *7
 S:%Y]""!'% %=$A(%Y),%=$S(%=89:1,%=121:1,%=78:2,%=110:2,%=94:-1,1:0)
 I '%,%Y'?."?" W *7,"??",!?4,"Answer 'YES' or 'NO': " G RX
 I '% D YNHELP S %=%1 W ! G YN
 W:$X>73 ! W $P("  (YES)^  (NO)",U,%) K %1,%A,%H Q
YNHELP I $G(%H)="" W !?4,"Sorry, no help available." Q
 I $E(%H)=U X $P(%H,U,2,999) Q
 W !?4,%H
