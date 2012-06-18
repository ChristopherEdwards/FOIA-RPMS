ZIBVCHV ; IHS/ADC/GTH - READ VARS AND RTNS FROM A %INDEX ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;;
 ;
 ; Thanks to Paul Wesley, DSD, for the original routine.
 ;
 I '(^%ZOSF("OS")["MSM") D OSNO^XB Q  ; IHS/SET/GTH XB*3*9 10/29/2002
OPEN ;
 D DT^DICRW,^XBCLS
 W !!,"Select a %INDEX Summary that was put to disk",!
 KILL DIR
 S DIR(0)="F^1:30",DIR("A")="Directory ",DIR("B")="/usr/mumps/"
 D ^DIR
 Q:Y["^"
 S XBDIR=Y
FNAME ;
 KILL DIR
FNAME1 ;
 S DIR(0)="F^1:15",DIR("A")="File Name "
 D ^DIR
 G:Y["^" OPEN
 I Y?.N,$D(XBFL(Y)) S DIR("B")=XBFL(Y) G FNAME1
 I Y["*" KILL XBFL S X=$$LIST^%ZISH(XBDIR,Y,.XBFL) D  G FNAME
 .F XBI=1:1 Q:'$D(XBFL(XBI))  W !?5,XBI,?10,XBFL(XBI)
 .Q
 S XBFN=Y,X=$$OPEN^%ZISH(XBDIR,XBFN,"R")
ES ;
 I X W !,"error on open of file ",XBDIR,XBFN,! KILL DIR S DIR(0)="E" D ^DIRQ:Y=1  G FNAME
 S XBJ=$J,XBVRLC=0
 KILL ^XBVROU(XBJ,"V")
 W !,"Looking for 'Indexed Routines:' ",!
READ ;
 F XBI=1:1:20 U IO R X:DTIME U IO(0) W "." I X["Indexed Routines:" S XBOK=1 W !,"Found ! ... continuing" Q
 I '$G(XBOK) KILL DIR
 F XBI=1:1 U IO R X:DTIME Q:X["Local V"
 F XBI=1:1 U IO R X:DTIME Q:X["Global "  D
 .Q:$L(X)<17
 .Q:$E(X,17)=" "
 .I X[$C(13) S X=$P(X,$C(13))
 .S XBVARL=$G(XBVAR)
 .I $E(X,4)'=" " S XBVAR="" F XBI=4:1 S XBX=$E(X,XBI) Q:" ("[XBX  S XBVAR=XBVAR_XBX
 .I XBVAR'=XBVARL S XBVRLC=0
 .S XBR=$E(X,17,999),XBR=$TR(XBR,"*!","")
 .S XBVRLC=XBVRLC+1,^XBVROU(XBJ,"V",XBVAR,XBVRLC)=XBR
 .Q
 D ^%ZISC
 S XBFILE=1
 Q
 ;
