XBFIXL1 ; IHS/ADC/GTH - STANDARDIZE LINE 1 OF SELECTED ROUTINES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; This routine asks user to select a set of routines, asks
 ; the user for the programmer information and standardizes
 ; the format of the first line of each routine.
 ;
 ; The form of the first line will be as follows:
 ;
 ; label ; agency/site/developer - comment ; edit date    E.G.
 ; XBFIXL1 ; IHS/ADC/GTH - FIX LINE 1 ; [ 11/08/90  10:41 AM ]
 ;
START ;
 NEW ASK,QUIT,RTN
 S QUIT=0
 D ^XBKTMP,^XBKVAR
 X ^%ZOSF("RSEL")
 I $D(^UTILITY($J,"XBFIXL1")) W !,"^XBFIXL1 cannot modify itself.  Ignored." KILL ^UTILITY($J,"XBFIXL1")
 G:$O(^UTILITY($J,""))="" EOJ
 S XBPI=$$DIR^XBDIR("F^9:20","Enter agency/site/programmer","","","E.G IHS/OHPRD/ACC")
 G:$D(DIRUT) EOJ
 ;S XBRTN="";IHS/SET/GTH XB*3*9 10/29/2002
 S XBRTN=0 ;IHS/SET/GTH XB*3*9 10/29/2002
 F  S XBRTN=$O(^UTILITY($J,XBRTN)) Q:XBRTN=""  D CHECK Q:QUIT
 G EOJ
 ;
CHECK ;
 KILL ^TMP("XBFIXL1",$J)
 S DIF="^TMP(""XBFIXL1"",$J,",XCNP=0,X=XBRTN
 X ^%ZOSF("LOAD")
 S XBL1=^TMP("XBFIXL1",$J,1,0)
 I $E($P(XBL1," ",2))'=";" W !!,XBRTN," - line 1 contains code and must be changed manually.  Skipping" Q
 S XBSAVE=XBL1
 D MODIFY
REVER ;
 D VERIFY
 Q:QUIT
 D:Y="R" FIX
 I QUIT S XBL1=XBSAVE G REVER
 I XBL1]"" S ^TMP("XBFIXL1",$J,1,0)=XBL1,DIE=DIF,XCN=0,X=XBRTN X ^%ZOSF("SAVE")
 Q
 ;
MODIFY ; Modify Line 1.
 S XBTAG=$P(XBL1," "),X=$P(XBL1,";",2,99)
 D EXTDATE
 F  Q:$E(X)'=" "  S X=$E(X,2,$L(X))
 S:$P(X,";")?." " $P(X,";")=XBPI_" - NO DESCRIPTION PROVIDED"
 S %=$P(X,";")
 I %'["-",$P(%," ")?1A.AN1"/"1A.AN.E S $P(%," ")=$P(%," ")_" - ",$P(X,";")=%
 F  S %=$F(X,";") Q:'%  S X=$E(X,1,%-2)_" "_$E(X,%,$L(X))
 F  S %=$F(X,"  ") Q:'%  S X=$E(X,1,%-3)_" "_$E(X,%,$L(X))
 S:$E(X)=" " X=$E(X,2,$L(X)) S:$E(X,$L(X))=" " X=$E(X,1,$L(X)-1)
 I X["-" S %=$P($P(X,"-")," ") S %=(%["/")*(1+($P($P(X,"-"),%,2)?." ")) S:%=1 $P(X," ")=XBPI_" -" S:%=2 $P(X,"-")=XBPI_" " S:'% X=XBPI_" - "_X
 I X'["-" S X=XBPI_" - "_X
 S XBL1=XBTAG_" ; "_X_" ;"_$S(XBDATE]"":" [ "_XBDATE_" ]",1:"")
 Q
 ;
EXTDATE ; Extract date and remove from Line.
 S XBNP=$L(X,";"),XBLP=$P(X,";",XBNP)
 F XBPAT=("1.2N1""/""1.2N1""/""2.4N"),("1.2N1"" ""3A1"" ""2.4N"),("1.2N1""-""3A1""-""2.4N") S XBLDT=$$GETPATRN^XBFUNC(XBLP,XBPAT) Q:XBLDT]""
 I XBLDT="" S XBDATE="" Q
 S XBLTM=$$GETPATRN^XBFUNC($P(XBLP,XBLDT,2),"1.2N1"":""1.2N1"" ""2A")
 S:XBLTM]"" XBLDT=XBLDT_" "_XBLTM
 S XBLP=$P(XBLP,XBLDT)_$P(XBLP,XBLDT,2)
 S XBLDJ=$$FNDPATRN^XBFUNC(XBLP,"."" ""1""["".E1""]"".E")
 S:XBLDJ XBLP=$E(XBLP,1,XBLDJ-1)
 S $P(X,";",XBNP)=XBLP
 S XBDATE=XBLDT
 Q
 ;
VERIFY ; Ask user to verify mod.
 W !!,XBRTN,!," from: ",XBSAVE,!,"   to: ",XBL1
 S Y=$$DIR^XBDIR("S^A:Accept;R:Replace;S:Skip","","A","","Accept the proposed modification; Replace the proposal with your own line; Skip the routine")
 S:$D(DIRUT) QUIT=1
 S:Y="S" XBL1=""
 Q
 ;
FIX ; Get comment from user.
 S X=$$DIR^XBDIR("F^5:40","Enter comment to follow agency/site/programmer ")
 S:$D(DIRUT) QUIT=1
 S $P(XBL1,";",2)=XBPI_" - "_X
 Q
 ;
EOJ ;
 D ^XBKTMP
 KILL DIF,XCNP,DIE,XCN
 KILL %,X,Y,^UTILITY($J)
 KILL DTOUT,DUOUT,DIRUT,DIROUT
 KILL XBDATE,XBL1,XBLDJ,XBLDT,XBLP,XBLTM,XBNP,XBPAT,XBPI,XBRTN,XBSAVE,XBTAG
 Q
 ;
