ABMRELG ; IHS/ASDST/DMJ - FIND INS TYPE AND COVERAGE ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 NEW DIC,X,Y,C,DIP           ;CLEAN OUT VARIABLES
 DO ELG^ABMDLCK(D0,.ABML)
 NEW D0
 IF '$D(ABML) D  QUIT
 .I $X>19 W !
 .WRITE ?10,"NO COVERAGE"
 SET P=0,I=0,ABMNUM=0            ; SET PRIORITY, INS TO ZERO
 FOR  SET P=$ORDER(ABML(P)) QUIT:'P  D  QUIT:ABMNUM>3
 .FOR  SET I=$ORDER(ABML(P,I)) QUIT:'I  D  QUIT:ABMNUM>3
 ..SET ABMNUM=ABMNUM+1
 ..Q:ABMNUM>3
 ..SET DIC="^AUTNINS("     ; AUTNINS=INS FLMAN CALL GET VALUE OF   
 ..SET DIC(0)="N"
 ..SET X=I      ; COME BACK WITH IEN & INS COVERAGE=Y                 
 ..D ^DIC       ;   
 ..SET ABMNAME=$P(Y,U,2)     ; NAME=INS CO 
 ..SET C=0,COV=""
 ..FOR  SET C=$ORDER(ABML(P,I,"COV",C)) Q:'C  D
 ...SET COV=COV_(ABML(P,I,"COV",C))
 ..IF $X>19 W !
 ..WRITE ?10,ABMNAME," ",COV
 K ABMNUM,ABMNAME
 Q
 ;
OPT ; ENTRY POINT
 S DIR("A")="Do you want to print visits with Claims Created and Claims Modified?"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR Q:$D(DIRUT)
 I Y S ABMRSTMP="[ABMRELGS]"
 E  S ABMRSTMP="[ABMRELG RPT2]"
 S L=0
 S DIC=9000010
 S FLDS="[ABMRELG RPT]"
 S BY=ABMRSTMP
 S DIPCRIT=1
 D EN1^DIP
 Q