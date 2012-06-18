ZIBVL ;IHS/SET/GTH - LIST LOCAL VARIABLES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Both MSM and Cache'.
 ;
 ; This routine lists variables that begin with the string
 ; entered by the user.  Selection of variables is case
 ; sensitive.
 ;
 ; This routine is specific to MSM and Cache.  It will work
 ; with any M implementation that has all Type A extensions
 ; to the 1990 M ANSI standard implemented.  The front end
 ; routine, XBVL, stops if any other than an MSM or Cache
 ; implementation is encountered.
 ;
 ; TASSC/MFD formally ZIBVLMSM, patched this along with XBVL for Cache
 ;
START ;
 NEW ZIBVLC,ZIBVLDQT,ZIBVLI,ZIBVLLC,ZIBVLNS,ZIBVLQ,ZIBVLX,ZIBVLX2,ZIBVLY,ZIBVLZ
 S $P(ZIBVLZ,"=",40)=""
 F  D LOOP Q:ZIBVLQ
 Q
 ;
LOOP ; WRITE NAME SPACED VARIABLES UNTIL USER IS THROUGH
 D READ ;                           get name space
 Q:ZIBVLQ
 Q:ZIBVLNS=""
 I $D(IOF) W @IOF I 1
 E  W !!
 W ZIBVLZ,! ;                       write leading === line
 I ZIBVLNS="*" D ALL I 1 ;          list variables
 E  D NMSPACE
 D:ZIBVLLC>20 PAUSE ;               pause if bottom of screen
 I 'ZIBVLQ W ZIBVLZ,! I 1 ;         write trailing === line
 E  W !
 S ZIBVLQ=0
 Q
 ;
NMSPACE ; LIST VARIABLES IN NAME SPACE
 S ZIBVLX=""
 I $$VERSION^%ZOSV(1)["MSM" S ZIBVLX=$O(@ZIBVLNS,-1) ;         backup to variable before name space
 S:ZIBVLX="" ZIBVLX="%" ;           if none start with %
 I ZIBVLNS="%",$D(%) D WRITE,QUERY ;if % name space list % variable
 ; now list variables in name space and subnodes if arrays
 ; skip ZIBVL* variables
 F  S ZIBVLX=$O(@ZIBVLX) Q:ZIBVLX=""  Q:$E(ZIBVLX,1,$L(ZIBVLNS))]ZIBVLNS  I $E(ZIBVLX,1,$L(ZIBVLNS))=ZIBVLNS,$E(ZIBVLX,1,5)'="ZIBVL" D WRITE Q:ZIBVLQ  D QUERY Q:ZIBVLQ
 Q
 ;
ALL ; LIST ALL VARIABLES
 S ZIBVLX="%"
 I $D(%) D WRITE,QUERY ;            if % exists list it
 ; now list all variables and subnodes if arrays
 ; skip ZIBVL* variables
 F  S ZIBVLX=$O(@ZIBVLX) Q:ZIBVLX=""  I $E(ZIBVLX,1,5)'="ZIBVL" D WRITE Q:ZIBVLQ  D QUERY Q:ZIBVLQ
 Q
 ;
QUERY ; $Q THROUGH ARRAYS
 S ZIBVLX2=ZIBVLX
 NEW ZIBVLX
 S ZIBVLX=ZIBVLX2
 F  S ZIBVLX=$Q(@ZIBVLX) Q:ZIBVLX=""  D WRITE Q:ZIBVLQ
 Q
 ;
WRITE ; WRITE ONE VARIABLE NAME AND VALUE
 Q:'($D(@ZIBVLX)#2)
 ; quote non-numeric values (numeric = canonic < 16 digits)
 S ZIBVLDQT=""""
 I $L(@ZIBVLX)<16,@ZIBVLX=+@ZIBVLX S ZIBVLDQT=""
 ; figure out # of lines that will be used
 S ZIBVLC=$L(ZIBVLX)+1+($L(ZIBVLDQT)*2)+$L(@ZIBVLX) F ZIBVLI=1:1 S ZIBVLC=ZIBVLC-80 Q:ZIBVLC<1
 S ZIBVLLC=ZIBVLLC+ZIBVLI
 I ZIBVLLC>22 S ZIBVLLC=0 D PAUSE ;         pause if not enough room
 Q:ZIBVLQ
 W ZIBVLX,"=",ZIBVLDQT,@ZIBVLX,ZIBVLDQT,! ; write name=value
 Q
 ;
READ ; READ USER INPUT
 S ZIBVLQ=1,ZIBVLLC=0
 R !,"Enter Name Space: ",ZIBVLNS:300
 S:'$T ZIBVLNS="^"
 Q:ZIBVLNS=""
 Q:ZIBVLNS["^"
 S ZIBVLQ=0
 I ZIBVLNS["?" D HELP Q
 I $E(ZIBVLNS,1,5)="ZIBVL" W !!,"ZIBVL is not allowed!",*7 D HELP Q
 I ZIBVLNS=" " W !!,"BLANK is not allowed!",*7 D HELP Q
 I $L(ZIBVLNS)>1,$E(ZIBVLNS,$L(ZIBVLNS))="*" S ZIBVLNS=$E(ZIBVLNS,1,($L(ZIBVLNS)-1))
 D  I ZIBVLQ S ZIBVLQ=0 D HELP W *7 Q
 . Q:ZIBVLNS?1"%".AN
 . Q:ZIBVLNS?1A.AN
 . Q:ZIBVLNS="*"
 . S ZIBVLQ=1
 . Q
 Q
 ;
HELP ; DISPLAY HELP MESSAGE
 W !!,"Enter valid variable name string (e.g IO), or * for all, or RETURN or ^ to exit.",!
 S ZIBVLNS=""
 Q
 ;
PAUSE ; PAUSE FOR USER
 R "Press any key to continue",ZIBVLY:300 S:'$T ZIBVLY="^"
 W !
 I ZIBVLY["^" S ZIBVLQ=1 Q
 W:$D(IOF) @IOF
 Q
 ;
