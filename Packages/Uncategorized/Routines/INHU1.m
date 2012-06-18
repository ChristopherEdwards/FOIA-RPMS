INHU1 ;JSH; 6 May 98 09:15;GIS utilities - cont'd
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
CUR() ;Currency report
 ;Returns a 1 if current, 0 if not current, -1 if unknown
 N CT,I,J,T
 S CT=$P(^INRHSITE(1,0),U,13) Q:'CT -1
 S T=-1
 F I="E","P","K","S","N" S J=$O(^INTHU("ASP",I,0,0)) D:J
 . Q:'$D(^INTHU(J,0))  S:+^(0)>T T=+^(0)
 Q:T=-1 1
 S T=$$CDATF2H^UTDT(T),T2=$P(T,",",2),T=+T
 S H=$H,H2=$P(H,",",2),H=+H
 S D=$S(H2>T2:H-T*86640+H2-T2,1:H-T-1*86640+T2-H2)\60
 Q D'>CT
 ;
MESS(IND0) ;Display message text with entry #IND0
 N INJ,INMS,INMSA
 Q:$G(DUOUT)!'$G(IND0)  Q:'$D(^INTHU(IND0))  Q:'$O(^INTHU(IND0,3,0))
 D T^DIWW Q:$G(DUOUT)
 W "MESSAGE TEXT:"
 S INMS="INMSA"
 D ONE^INHUT9("^INTHU("_IND0_",3,0)",.INMS,IOM,3,"|CR|")
 S INJ=0 F   D T^DIWW Q:$G(DUOUT)  S INJ=$O(@INMS@(INJ)) Q:'INJ  W @INMS@(INJ)
 K @INMS
 Q
 ;
CR() ;Press return to continue
 W ! D ^UTSRD("Press <RETURN> to continue: ")
 Q ""
 ;
ERRMSG() ;Returns latest error message
 N X,Y S X=1 S Y=$$GETERR^%ZTOS S:Y="" Y="No error message."
 Q Y
 ;
TXTPTR(DIC,X,Y) ;Input transform for free-text pointers
 ;INPUT:
 ;   DIC      - file reference
 ;   X        - user input (dot pass)
 ;   Y        - dot pass
 ;
 ;OUTPUT:
 ;   X        - .01 field from the file
 ;   Y        -  standard Y array from DIC
 ;
 N D,DIX,DS,DZ K Y Q:'$D(X)  S DIC(0)="EQZM" D ^DIC I Y<0 K X Q
 S X=$P(Y(0),U,1),DWVOY=X
 Q
 ;
TXTHLP(DIC) ;Executable help for free-text pointers
 ;INPUT:
 ;  DIC     - file reference
 ;
 N D,DIX,DS,DZ,Y,X S DIC(0)="E",X="??" D ^DIC
 Q
 ;
