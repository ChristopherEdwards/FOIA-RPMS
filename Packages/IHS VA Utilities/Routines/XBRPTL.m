XBRPTL ; IHS/ADC/GTH - PRINT ROUTINE TO FIRST LABEL ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; This routine prints selected routines down to the first
 ; label.
 ;
START ;
 KILL ^UTILITY($J)
 X ^%ZOSF("RSEL")
 D ^%ZIS
PRINT ;
 KILL ^TMP("XBRPTL",$J)
 NEW %,I,L,R,X,Y
 U IO
 W @IOF
 ;S XBRPTLQ=0,R="";IHS/SET/GTH XB*3*9 10/29/2002
 S XBRPTLQ=0,R=0 ;IHS/SET/GTH XB*3*9 10/29/2002
 F L=0:0 KILL XBRPTL Q:XBRPTLQ  S R=$O(^UTILITY($J,R)) Q:R=""  D
 . S DIF="^TMP(""XBRPTL"",$J,",XCNP=0,X=R
 . X ^%ZOSF("LOAD")
 . S XBRPTL(1)=^TMP("XBRPTL",$J,1,0)
 . F I=2:1 S Y=$G(^TMP("XBRPTL",$J,I,0)) Q:(Y="")!($E(Y,1,2)'=" ;")  S XBRPTL(I)=Y
 . S I=I-1
 . D TOP
 . W !!!
 . I $D(XBRPTL) F %=1:1:I W XBRPTL(%),! I IO=IO(0)&($E(IOST,1,2)="C-")&($Y>(IOSL-4)) D PAGE S:$D(DUOUT) %=I,XBRPTLQ=1
 .Q
 ;
 KILL DTOUT,DUOUT,XBRPTLQ
 KILL ^UTILITY($J)
 I IO'=IO(0)!($E(IOST,1,2)="P-") W @IOF D:'$D(XBRPTLE) ^%ZISC
 KILL DIF,XBRPTLE,XCNP
 KILL ^TMP("XBRPTL",$J)
 Q
 ;
TOP ;
 I IO'=IO(0)!($E(IOST,1,2)="P-") W:$Y+I+3>IOSL @IOF
 Q
 ;
PAGE ;
 NEW %,I,X
 S Y=$$DIR^XBDIR("E")
 W:'$D(DUOUT) @IOF
 Q
 ;
EN ;PEP - Print routines down to first label.
 S XBRPTLE=1
 D PRINT
 KILL XBRPTLE
 Q
 ;
