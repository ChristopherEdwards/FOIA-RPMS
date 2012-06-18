XBVCH1 ; IHS/ADC/GTH - CONTINUE VARIABLE CHANGER ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; Thanks to Paul Wesley, DSD/OIRM, for the original routine.
 ;
PROCESS ;
 S XBL=$L(XBV0),XBOUT=0
 S X=0
 X ^%ZOSF("RM")
 S (XBROU,XBRM)=""
 F  S XBROU=$O(^XBVROU(XBJ,"R",XBROU)) Q:XBROU=""  S XBRM=XBRM_XBROU_","
 S XBROU=""
 F  S XBROU=$O(^XBVROU(XBJ,"R",XBROU)) Q:XBROU=""  D  Q:$G(XBOUT)
 . S X=XBROU
 . X ^%ZOSF("TEST")
 . E  D ^XBCLS W !!,X,"  NOT FOUND",! KILL DIR S DIR(0)="E" D ^DIR S:(Y=0) XBOUT=1 Q
 . S X=XBROU,DIF="^XBVROU(XBJ,""R"","""_XBROU_""",",(XCNP,%N)=0
 . X ^%ZOSF("LOAD")
 . I ^XBVROU(XBJ,"R",XBROU,1,0)["GENERATED FROM" W !,^(0),! KILL DIR S DIR(0)="E" D ^DIR D ^XBCLS Q
 . S XBLN=0,XBEDIT=0
 . F  S XBLN=$O(^XBVROU(XBJ,"R",XBROU,XBLN)) Q:XBLN=""  S XBLIN=^(XBLN,0) D LIN Q:$G(XBOUT)
 . I XBEDIT D SAVE
 . KILL ^XBVROU(XBJ,"R",XBROU)
 .Q
 Q
 ;
DISPROU ;display routine list
 S DX=1,DY=22
 X XBXY
 S XBRD=""
 F XBRI=1:1 S XBRD=$P(XBRM,",",XBRI) Q:XBRD=""  W:'(XBRI-1#8) ! S XBRC=(10*(XBRI-1#8)) W ?XBRC W:XBRD=XBROU "|" W XBRD W:XBRD=XBROU "|"
 Q
 ;
 ;--------------------------------------
 ;
LIN ;PROCESS LINE FROM TOP    
 S XBLIN0=XBLIN,XBVX=XBV0
 Q:XBLIN0'[XBV0
 D SCAN0,CHKMK
 I '$G(XBMK),$L(XBV0)=1 Q  ;skip when single character variable
 I '$G(XBMK) KILL XBEDLIN D EDIT,CHKMK Q:'$G(XBMK)  Q:$G(XBOUT)
 D ACCEPT
 Q
 ;
SCAN0 ;
 S XBLINX=XBLIN0,XBVX=XBV0
 D SCAN,UPT
 Q
 ;
SCAN1 ;
 S XBLINX=XBLIN1,XBVX=XBV1
 D SCAN
 Q
 ;
DISP0 ;
 S XBVX=XBV0,XBLINX=XBLIN0
 D ^XBCLS,DISPLAY
 Q
 ;
DISP1 ;
 S XBVX=XBV1,XBLINX=XBLIN1
 D DISPLAY
 Q
 ;
SCAN ;
 KILL XB,XBT,XBMK
 S XBL=$L(XBVX)
 F XBI=1:1 S XB(XBI)=$F(XBLINX,XBVX,$G(XB(XBI-1))+1)-XBL Q:XB(XBI)'>0  D
 . S XB(XBI,"M")=0,XB(XBI,0)=XB(XBI)
 . I XBP[$E(XBLINX,XB(XBI)-1),XBS[$E(XBLINX,XB(XBI)+XBL) S XB(XBI,"M")=1
 . S XB("B",XB(XBI))=XBI,XB("E",XB(XBI)+XBL-1)=XBI
 . S XB(XBI,"E")=XB(XBI)+XBL-1
 .Q
 KILL XB(XBI)
CHKMK ;
 I XBVX=XBV0 KILL XBMK S XBJM="" F  S XBJM=$O(XB(XBJM)) Q:XBJM=""  I $G(XB(XBJM,"M")) W *7 S XBMK=1
 KILL XBJM
 Q
 ;
EDIT ;
 D DISP0
 S DX=1,DY=13
 X XBXY
 R "TAB/T/SPC/CR/R/N/%/^/? :",*X:DTIME
 S X=$C(X)
 I X="T" D UPT G EDIT
 I $A(X)=9 D UPT G EDIT
 I X=" " S XB(XBT,"M")=XB(XBT,"M")+1#2 D UPT G EDIT
 I X="R" S XBLN=0 KILL XBMK Q
 I X="N" S XBLN=999 KILL XBMK Q
 ; I X="%" D ^XBNEW("%EDIT^XBVCH1:XBJ;XBROU") S XBLN=0 KILL XBMK Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 I X="%" D EN^XBNEW("%EDIT^XBVCH1","XBJ;XBROU") S XBLN=0 KILL XBMK Q  ; IHS/SET/GTH XB*3*9 10/29/2002
 I X="^" S XBOUT=1 KILL XBMK Q
 KILL XBMK
 S XBJM=""
 F  S XBJM=$O(XB(XBJM)) Q:XBJM=""  I $G(XB(XBJM,"M")) W *7 S XBMK=1
 KILL XBJM
 I $A(X)=13 Q
 D ^XBCLS
 W !!!
 W !?5,"'X'             Set changes"
 W !?5,"'Tab' or 'T'    Move to next marker"
 W !?5,"'Space bar'     Toggel marker and move to next"
 W !?5,"'CR'            Skip to next line"
 W !?5,"'R'             Restart the current Routine"
 W !?5,"'%'             %E Edit Routine"
 W !?5,"'N'             Next Routine"
 W !?5,"'^'             Exit"
 KILL DIR
 S DIR(0)="E"
 D ^DIR
 G EDIT
 ;
DISPLAY ; display line
 ; XB(XBI,0)=POS XB("B",POS)=XBI XB("E",POS)=XBI XB(XBI,"M")=MARK (0 OR 1)
 ; XBD(0) =underline-on,XBD(1)=Bold on,XBD(2)=Underline Off,XBD(3)=Bold Off,XBD("RVON")=RVON,XBD("RVOFF")=RVOFF
 D:(XBVX=XBV0) ^XBCLS ;displaying current line
 D:XBVX=XBV0 DISPROU
 S DX=0,DY=0
 X XBXY
 W ?5,"routine ",XBROU,?35,"line ",XBLN,!!
 I XBVX=XBV1 W ! ;displaying new line
 W XBD(6)
 F XBI=1:1:$L(XBLINX) D
 . I '(XBI#80) W !!!
 . I $D(XB("B",XBI)) W XBD(XB(XB("B",XBI),"M")*2)
 . W $E(XBLINX,XBI)
 . I $D(XB("E",XBI)) W XBD(XB(XB("E",XBI),"M")*2+1)
 .Q
 W XBD(7)
 Q:(XBVX=XBV1)  ;no tab marker when displaying new line
TAB ;
 S DY=+3,DX=XB(XBT,0)#80-1,DY=DY+(XB(XBT,0)\80*3)
 S:DY>8 DX=DX+1
TAB1 ;
 X XBXY
 W XBD(2),"|",XBD(3)
 Q
 ;
UPT ; SET TAB     
 S XBT=$G(XBT),XBT=$O(XB(XBT))
 I XBT'>0 S XBT=0 G UPT
 KILL XB("T")
 S XB("T",XB(XBT,0))=""
 Q
 ;
BLDLIN1 ;
 S XBLIN0=XBLIN,XBSUB=XBV0_":"_XBV1,XBLIN1=""
 F XBI=1:1 Q:'$D(XB(XBI))  S XBLIN1=XBLIN1_$E(XBLIN,$G(XB(XBI-1,"E"))+1,XB(XBI,0)-1)_$S(XB(XBI,"M"):XBV1,1:XBV0)
 S XBI=XBI-1
 S XBLIN1=XBLIN1_$E(XBLIN,XB(XBI,"E")+1,999)
 Q
 ;
ACCEPT ;
 D DISP0,BLDLIN1,SCAN1,DISP1
 KILL DIR
 S DIR(0)="S^Y:ACCEPT;E:EDIT;S:SKIP;N:NEXT ROUTINE;Q:QUIT",DIR("B")="Y"
 S X=$P(XBLINX," ",2,999)
 F  Q:$E(X)'=" "  S X=$E(X,2,999)
 F  Q:$E(X)'="."  S X=$E(X,2,999)
 D ^DIM
 I '$D(X) W *7,!,XBD(2),"FM DIM checker does not like this line !",XBD(3),!,XBD(2),XBLINX,XBD(3),! S DIR("B")="E"
 D ^DIR
 KILL DIR
 I Y="N" S XBLN=999 Q
 I Y="S" Q
 I Y="E" D SCAN0,EDIT,CHKMK G:$G(XBMK) ACCEPT Q
 I Y="Q" S XBOUT=1 Q
 I Y'="Y" G ACCEPT
 S XBEDIT=1 ; set edit markers
 S XBLIN=XBLIN1,^XBVROU(XBJ,"R",XBROU,XBLN,0)=XBLIN ;set new line
 Q
 ;
%EDIT ; USE %E EDITOR
 X "ZL @XBROU X ^%E"
 KILL ^XBVROU(XBJ,"R",XBROU)
 S X=XBROU,DIF="^XBVROU(XBJ,""R"","""_XBROU_""",",(XCNP,%N)=0
 X ^%ZOSF("LOAD")
 S XBLIN=0
 Q
 ;
SAVE ; SAVE NEW ROUTINE TO DISK
 D ^XBCLS
 X ^%ZOSF("UCI")
 I Y["DEV," W !,"you are in DEV .. NO CHANGES" H 2 Q
 I Y["PRD," W !,"you are in PRD .. NO CHANGES" H 2 Q
 KILL DIR
 S DIR(0)="Y",DIR("A")=XBROU_" has been changed. Save with Changes ?",DIR("B")="Y"
 D ^DIR
 KILL DIR
 I 'Y W !?5,XBROU," NOT CHANGED" H 3 D ^XBCLS Q
 W !?5,XBROU,"is being saved with changes",!
 S XBSAV1="ZR",XBSAV2="F XBI=1:1 S XBX=$G(^XBVROU(XBJ,""R"",XBROU,XBI,0)) Q:'$L(XBX)  ZI XBX",XBSAV3="ZS @XBROU"
 X "X XBSAV1,XBSAV2,XBSAV3"
 S ^XBVROU("PRT",$J,"VCHG",XBSUB,XBROU)=""
 S ^XBVROU("PRT",$J,"RCHG",XBROU,XBSUB)=""
 S ^XBVROU(XBJ,"NV",XBV1)=""
 W !?5,XBROU,"SAVED WITH CHANGES" H 2
 Q
 ;
