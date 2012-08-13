VENPCCMH ; IHS/OIT/GIS - GLOBAL MANAGEMENT OF DIAGNOSES AND ICD CODES ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ; 
 N TMP,PIEN,X,CODE,TEXT,Y,T,Z,PATH,FILE,POP,STOP,%,%Y
 S TMP="^TMP(""VEN TABLE"","_$J_")" K @TMP
 W !,"Building master table of ICD codes and diagnoses..."
ARR S PIEN=0 F  S PIEN=$O(^VEN(7.1,PIEN)) Q:'PIEN  D  ; BUILD THE DATA ARRAY
 . S X=$G(^VEN(7.1,PIEN,0)) I '$L(X) Q
 . S CODE=$P(X,U,2),TEXT=$P(X,U,3)
 . I CODE=""!(TEXT="") Q
 . I $D(@TMP@(CODE)) D  Q
 .. S Y=0,STOP=0
 .. F  S Y=$O(@TMP@(CODE,Y)) Q:'Y  D  I STOP=1 Q
 ... S T=@TMP@(CODE,Y)
 ... I T=TEXT S STOP=1
 ... Q
 .. I STOP Q
 .. S Z=$O(@TMP@(CODE,99999),-1)
 .. S @TMP@(CODE,Z+1)=TEXT
 .. Q
 . S @TMP@(CODE,1)=TEXT
 . Q
LIST ; MAKE A LIST FROM THE ARRAY
 W !,"Get ready to store the ICD information in a file..."
 S DIR(0)="FO^1:8",DIR("A")="Enter the name of the file",DIR("B")="icd_info" K DA
 D ^DIR K DIR ; GET FILE NAME
 I '$L(Y) Q
 I Y?1."^" Q
 S FILE=Y_".txt"
 S PATH=$G(^VEN(7.5,$$CFG^VENPCCU,3))
 W !,"'",FILE,"' will be stored in '",PATH,"'  OK"
 S %=1 D YN^DICN I %'=1 Q
 S POP=$$OPN^VENPCCP(PATH,FILE,"W","D FMT^VENPCCMH")
 I POP W !,"Unable to create this file.  Sesion terminated..."  Q
 W !,"Done!"
 K @TMP
 Q
 ;
FMT ; FORMAT THE DATA FOR OUTPUT
 N ICD,X,TXT,Y,TAB
 W !!,"ICD",$C(9),"POV",!!
 S ICD="" F  S ICD=$O(@TMP@(ICD)) Q:'ICD  S X=0 F  S X=$O(@TMP@(ICD,X)) Q:'X  D
 . S TXT=@TMP@(ICD,X)
 . S Y=ICD_$C(9)_TXT
 . W Y,!
 . Q
 Q
