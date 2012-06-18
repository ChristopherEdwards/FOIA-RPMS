AMERBSET ; IHS/ANMC/GIS - MAKES AGE BIN STRING ; 
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
SETBIN S ^TMP("AMERAGE",$J)="0:1;2:4;5:12;13:19;20:39;40:59;60:79;80:199"
 I $D(^AMER("AGE")) S ^TMP("AMERAGE",$J)=^AMER("AGE")
 D LIST
 S DIR(0)="YO",DIR("A")="Is this OK",DIR("B")="YES",DIR("?")="" D ^DIR K DIR
 D OUT^AMEROUT I $D(AMERQUIT) Q
 I "yY"[$E(X) Q
RUN S %="",A=-1 W !!! F L=0:0 D AGE Q:X=""  I $D(AMERQUIT) G EXIT
 D CLOSE I $D(AMERQUIT) G EXIT
 D LIST
EXIT K X,Y,Z,%,I,L,A
 Q
 ;
AGE ;
 S DIR(0)="N",DIR("A")="Enter the starting age of the "_$S(%="":"first",1:"next")_" age group: "
 D ^DIR S X=Y I '$T S X=U K DIR
 I X=U S AMERQUIT="" Q
 I X="" Q
 I X?1."?" D HELP G AGE
 I X?1.3N,X>A D SET Q
 W "  ??",*7 G AGE
 ;
SET S A=X
 I %="" S %=X Q
 S %=%_":"_(X-1)_";"_X
 Q
 ;
CLOSE I %="" Q
GC ;
 S DIR(0)="N",DIR("A")="Enter the highest age for the last group: "
 D ^DIR S X=Y I '$T S X=U K DIR
 I X=U S AMERQUIT="" Q
 I X?1."?" D HELP G GC
 I X="" S X=199
 I X?1.3N,X'<A S %=%_":"_X,^TMP("AMERAGE",$J)=% Q
 W "  ??",*7 G GC
 ;
HELP Q
 ;
LIST W !!,"CURRENT AGE GROUPS =>",!
 S %=^TMP("AMERAGE",$J)
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,":")," - ",$P(X,":",2)
 W !!
 Q
