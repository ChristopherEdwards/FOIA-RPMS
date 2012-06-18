XBSAUTH ; IHS/ADC/GTH - SET AUTHORITIES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine sets FileMan dictionary authorities:
 ;     "AUDIT" "DD" "DEL" "LAYGO" "RD" "WR"
 ;
START ;
 I $G(DUZ(0))'="@" W !,*7,"  Insufficient FileMan access.  DUZ(0) is not ""@""." Q
 S U="^",IOP=$I
 D ^%ZIS
 W !!,"^XBSAUTH - This program sets FileMan dictionary authorities."
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
ASK ;
 W !!,"Do you want to be asked before setting each file? (Y/N) Y// "
 R XBSAASK:$G(DTIME,999)
 S:XBSAASK="" XBSAASK="Y"
 S XBSAASK=$E(XBSAASK)
 I "YyNn"'[XBSAASK W *7 G ASK
 S XBSAASK=$S("Yy"[XBSAASK:1,1:0)
 W !!,"To delete a particular authority enter '@@'",!
 S XBSAF=0
 KILL XBSA
 F XBSAX="AUDIT","DD","DEL","LAYGO","RD","WR" D GETAUTH
 I 'XBSAF W !!,"Bye" Q
 W !!,"I am going to set the following authorities:",!
 F XBSAX="AUDIT","DD","DEL","LAYGO","RD","WR" D:@("XBSA("""_XBSAX_""")")'="" PRTAUTH
ASK2 ;
 W !!,"Do you want to continue? (Y/N) N// "
 R XBSAX:$G(DTIME,999)
 S:XBSAX="" XBSAX="N"
 S XBSAX=$E(XBSAX)
 I "YyNn"'[XBSAX W *7 G ASK2
 G:"Yy"'[XBSAX EOJ
 W !
 S XBSAFILE=""
 F XBSAL=0:0 S XBSAFILE=$O(^UTILITY("XBDSET",$J,XBSAFILE)) Q:XBSAFILE=""  D PROCESS
 G EOJ
 ;
GETAUTH ; GET DICTIONARY AUTHORITIES
 W !,"Enter ",XBSAX," authority: "
 R @("XBSA("""_XBSAX_""")")
 S:@("XBSA("""_XBSAX_""")")'="" XBSAF=1
 Q
 ;
PRTAUTH ; PRINT DICTIONARY AUTHORITIES
 W !,XBSAX,?6," to """,@("XBSA("""_XBSAX_""")"),""""
 Q
 ;
PROCESS ;
 S XBSAANS="Y"
 W !,@("$P(^DIC("_XBSAFILE_",0),U,1)")
 I XBSAASK W !?4,"Current authorities are:  " D  W "..OK? Y// "
 . F XBSAX="AUDIT","DD","DEL","LAYGO","RD","WR" I $D(@("^DIC("_XBSAFILE_",0,"""_XBSAX_""")")),@("^("""_XBSAX_""")")'="" W ?31,XBSAX,?38,@("^("""_XBSAX_""")"),!
 . Q
P2 ;
 I XBSAASK R XBSAANS:$G(DTIME,999) S:XBSAANS="" XBSAANS="Y" S XBSAANS=$E(XBSAANS) I "YyNn"'[XBSAANS D P2ERR G P2
 I "Yy"[XBSAANS D P2SETS Q
 W "  Skipping"
 Q
 ;
P2SETS ;
 NEW X
 F X="AUDIT","DD","DEL","LAYGO","RD","WR" S:XBSA(X)]"" @("^DIC("_XBSAFILE_",0,"""_X_""")")=XBSA(X) KILL:XBSA(X)="@@" @("^DIC("_XBSAFILE_",0,"""_X_""")")
 Q
 ;
P2ERR ;
 W *7
 F %=1:1:$L(XBSAANS) W @IOBS," ",@IOBS
 Q
 ;
EOJ ;
 KILL ^UTILITY("XBDSET",$J),XBSA,XBSAANS,XBSAASK,XBSAF,XBSAFILE,XBSAI,XBSAL,XBSAX
 Q
 ;
