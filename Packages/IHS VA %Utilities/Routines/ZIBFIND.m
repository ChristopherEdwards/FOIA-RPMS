ZIBFIND ; IHS/ADC/GTH - FIND MSM BLOCKS WITH CONTAIN SPECIFIC GLOBAL ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; Thanks to Ross Leatham, AAO, and Mark Delaney, DSM, for the
 ; original routine.
 ;
 ; MSM-specific utility for finding blocks which contain a
 ; specific GBL.
 ;
 ;  ZIBCC=common count, ZIBUC=unique count
 ;  ZIBCHAR=string of characters
 ;
 ;S X="ERR^ZIBFIND",@^%ZOSF("TRAP") K X
 ;
 I '(^%ZOSF("OS")["MSM") D OSNO^XB Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 S ZIBOSET=-1
GETINFO ;
 KILL ZIBVN,ZIBGREF,ZIBTYPE
 D GETVOL^%VGUTIL
 S:VGVOL=1 ZIBVN=0
 I VGVOL>1 R !,"What Volume Number are you looking in? ",ZIBVN:30
 G END:"^"[ZIBVN
 S ZIBLBLK=$P(VGVOL(ZIBVN),"^",4)
ASK1 ;
 S ZIBN=1
 F  R !,"Enter GLOBAL to search for: ^",ZIBGREF:30 Q:"^"[ZIBGREF  S ZIBGREF(ZIBN)=ZIBGREF,ZIBN=ZIBN+1
 G END:ZIBGREF="^"
 S ZIBTYPE="234"
 O 63::0
 I '$T W !,"VIEW BUFFER IN USE- SORRY" Q
 KILL ^TMP("ZIBFIND",$J)
 V 0:"DB/"_ZIBVN ;get the actual block number at start of volume
 S ZIBBBLK=$V(1016,0,4),ZIBEBLK=ZIBBBLK+ZIBLBLK-1
ASK2 ;
 W !,"Enter beginning actual block to search from <",ZIBBBLK,"> "
 R X:30
 G ASK2:X'?.N,END:X["^"!(X>ZIBLBLK)
 S:X]"" ZIBBBLK=X
 S ZIBOSET=ZIBBBLK-1
ASK3 ;
 W !,"Enter last actual block to search to <",ZIBEBLK,"> "
 R X:30
 G ASK3:X'?.N,END:X["^"!(X<ZIBBBLK)
 S:X]"" ZIBEBLK=X
 W !,"Start Block=",ZIBBBLK,"     End Block=",ZIBEBLK,!
 W !!,"This could take a while, hold on... ",!
 F ZIBI=ZIBBBLK:1:ZIBEBLK V ZIBI S ZIBCC=$V(0,0,1),ZIBUC=$V(1,0,1),ZIBCHAR=$V(2,0,ZIBUC,1),ZIBBTYPE=$V(1020,0,1),ZIBOSET=ZIBOSET+1 I ZIBCHAR]"",ZIBTYPE[ZIBBTYPE D LOOP
 C 63
 W !,"DONE!",*7,$S($D(^TMP("ZIBFIND",$J)):" The blocks are listed in ^TMP(""ZIBFIND"","_$J_"), in this UCI",1:" no blocks were found with this data")
 Q
 ;
LOOP ;
 S ZIBN=0
 F  S ZIBN=$O(ZIBGREF(ZIBN)) Q:ZIBN=""  I ZIBCHAR[ZIBGREF(ZIBN) S ^TMP("ZIBFIND",$J,ZIBGREF(ZIBN),ZIBI)=ZIBVN_":"_ZIBOSET W *13,ZIBI
 Q
 ;
END ;
 C 63
 KILL ZIBBBLK,ZIBBTYPE,ZIBCC,ZIBCHAR,ZIBEBLK,ZIBLBLK,ZIBN,ZIBOSET,ZIBUC,ZIBZR
 Q
 ;
ERR ;
 C 63
 S ZIBZR=$ZR
 D @^%ZOSF("ERRTN")
 Q
 ;
