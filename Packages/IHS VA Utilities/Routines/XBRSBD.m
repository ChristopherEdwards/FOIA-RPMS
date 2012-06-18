XBRSBD ;IHS-OIRM-DSD/THL;ADAPTATION OF %RS TO SELECT ROUTINES EDITED AFTER SPECIFIED DATE; 
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;
 ; This routine saves selected routines edited after a given date
 ;
START ;
 S $ZT="ERR^%RS",%SEQ=1 K %SBP
 W !?10,$P($P($ZV,","),"-")," - Routine Save Utility"
 O 63::0 E  U 0 W !,"Waiting for device 63" O 63
SDEV D OUT^%SDEV I $D(QUIT) C 63 K %SEQ Q
 S QUIT=0,%SBP=%DEV>58&(%DEV<63),%TAP=%DEV>46&(%DEV<51)
 S %TAPV=$S('%TAP:0,1:$ZB(%DEVMODE,"_",1)["V") G:'%TAP SIZE
 ;U %DEV I @(%MTON_"=0") U 0 W *7,!,"Tape is not ready" C %DEV G SDEV
 ;I @%MTWLK U 0 W *7,!,"Tape is write protected" C %DEV G SDEV
 U 0 G RCMT
SIZE I %SBP S %SIZE=1024*10000 G RCMT
 R !,"Enter size of save medium (if applicable): ",%SIZE:$S($D(DTIME):DTIME,1:999) S:%SIZE="" %SIZE=1024*10000 G SDEV:"^"=%SIZE,EXIT:%SIZE="^Q"!(%SIZE="^q")
 I %SIZE?1N.N1A S %SIZE=$P(%SIZE,"K"),%SIZE=$P(%SIZE,"k")
 I %SIZE?1N.N,%SIZE>0 S %SIZE=%SIZE*1024 G RCMT
 I %SIZE'?1"?".E W "  ??" G SIZE
 W !!,"If using removeable disks or tape for save, enter the number of 1k blocks which",!,"each disk will hold.  As each disk becomes full, you will be asked to",!,"replace it with an empty one."
 W !!,"If not using removeable media, press <RETURN>",! G SIZE
 ;
RCMT R !,"Enter comment for dump header : ",%CMT:$S($D(DTIME):DTIME,1:999) G SDEV:%CMT="^",CNT1:%CMT'="?"
 W !,"The comment will be displayed with the date and time before the routines",!,"are restored." G RCMT
CNT1 K QUIT D INT^%RSEL I $D(QUIT) W !,"No routines selected" G EXIT
 S XBTYPE="SAVE" D ^XBDATE ;ADDED TO SPECIFY A DATE AND SCREEN OUT ROUTINES EDITED SINCE SPECIFIED DATE
 I $D(QUIT) W !,"No routines will be saved." H 2 G EXIT
 D:%TAP %SET^%MTCHK
 S QUIT=0,%NEXT="D NEXTVOL^%RS Q:QUIT  ZL @%RN"
 I '%TAP S %ZPRINT="ZR  S %S=$S ZL @%RN X:%S-$S>(%SIZE-$ZB-10) %NEXT Q:QUIT  U %DEV W %RN,! S:'%SBP&$ZC!($ZA<0&%SBP) QUIT=2 Q:QUIT  F %X=1:1 S %J=$T(+%X) W %J,! Q:%J="""""
 E  I '%TAPV S %ZPRINT="ZL @%RN U %DEV W %RN,! S:$ZC QUIT=2 Q:QUIT  P"
 E  S %ZPRINT="ZL @%RN U %DEV W %RN S:$ZC QUIT=2 Q:QUIT  F %X=1:1 S %J=$T(+%X) W %J Q:%J="""""
 D INT^%T,INT^%D
 W !!,"Saving ...",!
 U %DEV W:'%DEV ! W %TIM1_"  "_%DAT1 W:'%TAPV ! W %CMT W:'%TAPV !
 S %RN=""
 F %I=1:1 S %RN=$O(^UTILITY($J,%RN)) Q:%RN=""!QUIT  U 0 W ?%I-1#8*10,%RN W:(%I#8)=0 ! U %DEV D PCODE Q:QUIT  I PCODE X %ZPRINT Q:QUIT  I %TAP,@%MTEOT D NEXTTAPE Q:QUIT
 I QUIT=2 U 0 W !!,"End of file reached, last portion of save may be corrupted!  Terminating save."
 E  U %DEV W:'%TAPV !! W:%TAPV "",""
 U 0 W !!,"Done. "
QUIT I '$D(%SBP) K %SEQ Q
 I %SBP,QUIT<2 U %DEV S %BN=$ZA U 0 W "Last block used was ",%BN,"."
EXIT C 63 U 0 I $D(%DEV),%DEV'=$I,+%DEV C %DEV I $G(%DEVTYPE)="HFS",$ZA=-1 W !!,"Cannot write end of file.  Last part of save may be corrupted."
 I $D(%TAP) D:%TAP %KILL^%MTCHK
 K %DEV,%RN,%BN,%I,%J,%CMT,%TIM,%TIM1,%DAT,%DAT1,%NEXT,%SEQ,%FN,%S,%SIZE,%SBP,%TAP,%X,%ZA,%ZPRINT,QUIT,%TAPV
 K XBDAT,RTN
 Q
PCODE ; Test for pcode only routine
 I %DEV<47!(%DEV>62) S PCODE=1 Q
 S PCODE=$ZBN(^ (%RN)) I PCODE=0 U 0 W !,%RN," does not exist" Q
 V PCODE I $V(17,0,1)=0 S PCODE=1 Q  ; not a pcode routine
 G:%TAP PC10
 S %S=1056 F %K=0:0 S %K=$V(1012,0,4) Q:%K=0  V %K S %S=%S+1024 ;1056=1024+32, 32 byte cushion left for rtn name, etc.
 I %S>(%SIZE-$ZB) X %NEXT Q:QUIT
PC10 V PCODE U %DEV W %RN_":"_$V(17,0,1) W:'%TAPV ! I $ZC S QUIT=2 Q
 U:%DEV>58&(%DEV<63) %DEV:(::::"V")
 F PCODE=PCODE:0 W $V(0,0,1024,1) S PCODE=$V(1012,0,4) Q:PCODE=0  V PCODE ;I %TAP,@%MTEOT D NEXTTAPE U %DEV Q:QUIT
 I $ZC S QUIT=2
 U:%DEV>58&(%DEV<63) %DEV:(::::"S") Q
ERR I $F($ZE,"<INRPT>") U 0 W !!,"...Aborted." D EXIT V 0:$J:$ZB($V(0,$J,2),0400,7):2
 ZQ
NEXTVOL ;
 S %SEQ=%SEQ+1 U %DEV W "*EOF*",! C %DEV
 U 0 W !,"Sequence #",%SEQ-1," is full, if using removeable media, please put in the next one"
NEXTVOL1 ;
 R !,"Enter 'GO' to proceed: ",%X:$S($D(DTIME):DTIME,1:999) W !
 I %X="?" W !!,"Remove sequence #",%SEQ-1,", and put the next disk or tape into the drive.  If you are",!,"not using removeable media, you should abort this save by typing 'control C';",!,"your save will still be good up to this point." G NEXTVOL1
 I %X'="GO" W "  ??" G NEXTVOL1
 O %DEV:(%FN:"W") U %DEV I $ZA U 0 W !,"Cannot access ",%FN," please correct" G NEXTVOL1
 W "DISK#",%SEQ,! S %X=$ZC
 U 0 I %X W !,"Cannot write to ",%FN," please correct" G NEXTVOL1
 S QUIT=0 Q
NEXTTAPE ;
 U 0 W !,"Tape sequence number ",%SEQ," is full. Last routine was ",%RN,"."
 W !,"After this tape rewinds, mount the next tape.",!
 S %SEQ=%SEQ+1 U %DEV W "*EOF*" W:'%TAPV ! W *9
NT0 U %DEV W *16 U 0
NT1 W !,"Enter 'GO' when tape sequence number ",%SEQ R " is ready: ",%X:$S($D(DTIME):DTIME,1:999)
 I %X="?" W !,"Mount the next tape (sequence number ",%SEQ,") and enter 'GO' when it is ready.",!,"Or enter '^' to abort the save.",! G NT1
 I %X["^" S QUIT=1 Q
 I %X'="GO",%X'="go" W *7,"  ??" G NT1
 U %DEV W *10 I @(%MTON_"=0") U 0 W *7,!,"Tape is not ready" G NT1
 I @%MTWLK U 0 W *7,!,"Tape is write protected" G NT0
 W %TIM1_"  "_%DAT1_"  (sequence "_%SEQ_")" W:'%TAPV ! W %CMT W:'%TAPV !
 U 0 W !!,"Saving ...",! S QUIT=0 Q
