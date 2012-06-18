XMZDOM ;(WASH ISC)/CAP - CONVERT MAILMAN HOST #'S TO IDCU ;5/23/90  10:17
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;1.0;
 D ^XMZDOM4
 S U="^" D NOW^%DTC S XMDT=$E(%,4,5)_"/"_$E(%,6,7)_"/"_$E(%,2,3),%=$P(%,".",2) I $L(%) S %=$E(%_"000",1,4),XMDT=XMDT_" @ "_$E(%,1,2)_":"_$E(%,3,4)
R R !,"OPTION: P//",X:900 E  W !!,"<< Time out ! " G END
 I X["^" G OUT
 G XMZDOM:X="?" I X="" S XMF0="PRE-CONVERSION CHECK" G GO
 S %="PRE-CONVERSION CHECK^IDCU^VADATS" F I=1:1:$L(%,U) I $E($P(%,U,I),1,$L(X))=X S XMF0=$P(%,U,I) W $E(XMF0,$L(X)+1,99) G GO
 D 0^XMZDOM4 G R
GO I XMF0="VADATS",'$D(^XMB(4.6,"B","OLDMINI"))!'$D(^("OLDAUSTIN")) W !!,*7,"The OLDMINI and OLDAUSTIN entries are NOT IN the TRANSMISSION SCRIPT file.",!,"You cannot reverse the IDCU conversion because you haven't run it.",!! G END
 I XMF0="IDCU",$D(^XMB(4.6,"B","OLDMINI"))!$D(^XMB("OLDAUSTIN")) W !!,*7,"You have Transmission scripts name OLDMINI or OLDAUSTIN.",!,"You have already run this conversion.  " G END
TEXT I XMF0'="VADATS" W *7,!!,"The following will initialize your TRANSMISSION scripts.",!,"You must enter in the correct UserID and Password in order for it to work.",!,"If you do not, you may edit it in the 4.6 file later."
 I XMF0'="VADATS" R !!,"Enter the IDCU UserID sent to you by mail: ",XMU:600 G OUT:XMU["^"!'$T R !!,"Enter the IDCU Password sent to you by mail: ",XMP:600 G OUT:XMP["^"!'$T I XMP=""!(XMU="") D IDCU^XMZDOM3 I X["^" G OUT
 K %ZIS S %IS="Q" D ^%ZIS I POP K POP W !!," << No device --" G END
 G ZTSK:'$D(IO("Q")),GO:'IO("Q"),END:X=U
 S ZTRTN="ZTSK^XMZDOM",ZTDESC=XMF0_" Conversion (IDCU Conversion Kit)"
 D GETTIME^XMA02 W ! S ZTDTH=Y X ^%ZOSF("UCI")
 S %=$S($D(ION)#2:ION,1:IO) I $D(IOST)#2,IOST]"" S %=%_";"_IOST I $D(IOM)#2,IOM S %=%_";"_IOM I $D(IOSL)#2,IOSL S %=%_";"_IOSL
 S ZTIO=% I $D(IOT),IOT="SPL" K ZTIO
 S ZTUCI=Y,ZTSAVE("XMF0")="",ZTSAVE("XMU")="",ZTSAVE("XMP")="" D ^%ZTLOAD W "Task #"_ZTSK_" queued by request",!
 G KILL
ZTSK U IO K ^UTILITY($J) D DT^DICRW S XMA=0,XMPG=0 D ^XMZDOM1,^XMZDOM2 W !!,"WORKING",!! S XMD(1)=XMA,XMA=0
 G ^XMZDOM0
OUT I X["^" W !!,"<< User requested Abort "
END W "Process aborted >>",!!,*7 G KILL
KILL K %,%0,I,X,Y,XMA,XMB,XMC,XMD,XMDT,XME,XMF,XMF0,XMP,XMPG,XMS,XMU
 K ZTUCI,ZTDTH,ZTSAVE,ZTRTN,ZTDESC,ZTIO,ZTSK
 Q
