AUSAUTH ;SET AUTHORITIES [ 06/06/87  1:53 PM ]
 ;
BEGIN S DUZ(0)="@",U="^" D CURRENT^%ZIS
 W !!,"This program sets FileMan dictionary authorities by a range"
 W !,"of dictionary numbers.",!!
 ;
 D ^%AUDSET
 G:'$D(^UTILITY("AUDSET",$J)) EOJ
ASK W !!,"Do you want to be asked before setting each file? (Y/N) Y// " R AUSAASK S:AUSAASK="" AUSAASK="Y" S AUSAASK=$E(AUSAASK) I "YyNn"'[AUSAASK W *7 G ASK
 S AUSAASK=$S("Yy"[AUSAASK:1,1:0)
 W !
 K AUSA F AUSAX="DD","DEL","LAYGO","RD","WR" D GETAUTH
 W !!,"I am going to set the following authorities:",!
 F AUSAX="DD","DEL","LAYGO","RD","WR" D PRTAUTH
ASK2 W !!,"Do you want to continue? (Y/N) N// " R AUSAX S:AUSAX="" AUSAX="N" S AUSAX=$E(AUSAX) I "YyNn"'[AUSAX W *7 G ASK2
 G:"Yy"'[AUSAX EOJ
 W !
 S AUSAFILE="" F AUSAL=0:0 S AUSAFILE=$O(^UTILITY("AUDSET",$J,AUSAFILE)) Q:AUSAFILE=""  D PROCESS
 G EOJ
 ;
GETAUTH ; GET DICTIONARY AUTHORITIES
 W !,"Enter ",AUSAX," authority: " R @("AUSA("""_AUSAX_""")")
 Q
 ;
PRTAUTH ; PRINT DICTIONARY AUTHORITIES
 W !,AUSAX,?6," to """,@("AUSA("""_AUSAX_""")"),""""
 Q
 ;
PROCESS ;
 S AUSAANS="Y"
 W !,@("$P(^DIC("_AUSAFILE_",0),U,1)"),$S(AUSAASK:"..OK? Y// ",1:"")
P2 I AUSAASK R AUSAANS S:AUSAANS="" AUSAANS="Y" S AUSAANS=$E(AUSAANS) I "YyNn"'[AUSAANS D P2ERR G P2
 I "Yy"[AUSAANS D P2SETS Q
 W "  Skipping"
 Q
P2SETS ;
 S @("^DIC("_AUSAFILE_",0,""DD"")")=AUSA("DD")
 S ^("DEL")=AUSA("DEL")
 S ^("LAYGO")=AUSA("LAYGO")
 S ^("RD")=AUSA("RD")
 S ^("WR")=AUSA("WR")
 W "  Done"
 Q
P2ERR W *7 F AUSAI=1:1:$L(AUSAANS) W @BS," ",@BS
 Q
 ;
EOJ ;
 K ^UTILITY("AUDSET",$J)
 K AUSA
 K AUSAANS,AUSAASK,AUSAFILE,AUSAI,AUSAL,AUSAX
 K BS,FF,RM,SL,SUB,XY
 W !!,"Bye",!!
 Q
