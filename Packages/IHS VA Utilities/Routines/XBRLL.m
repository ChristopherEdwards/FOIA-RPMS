XBRLL ; IHS/ADC/GTH - LIST ROUTINE LINES WITH LENGTHS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine lists a single routine line by line noting
 ; the length of the line plus the cumulative character count.
 ;
START ;
 NEW DIF,X,XCNP
 S X=$$DIR^XBDIR("FO^1:8","Enter routine name")
 Q:$D(DIRUT)
 X ^%ZOSF("TEST")
 Q:'$T
 KILL ^TMP("XBRLL",$J)
 S DIF="^TMP(""XBRLL"",$J,",XCNP=0
 X ^%ZOSF("LOAD")
 D ^%ZIS
 Q:POP
 U IO
 W !!,"....[LINE NUMBER/LENGTH OF THIS LINE/CUMULATIVE NUMBER OF CHARACTERS]",!!
 S (%2,%1)=0
 F %I=1:1 S %X=$G(^TMP("XBRLL",$J,%I,0)) Q:%X=""  W ! S %Y=$P(%X," "),%Z=$E(%X,$L(%Y)+2,255),%2=%2+$L(%X)+2,%1=$S(%Y="":%1+1,1:0) S:%1>0 %Y=" +"_%1 S %Y=%Y_$J("",8-$L(%Y)) W %Y,"  ",%Z," [+",%I,"/",$L(%X),"/",%2,"]"
 KILL %1,%2,%N,%X,%Y,%Z,%I
 W !!
 KILL DIRUT,DTOUT,DUOUT,I,Y
 D ^%ZISC
 Q
 ;
