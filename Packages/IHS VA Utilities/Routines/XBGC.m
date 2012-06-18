XBGC ; IHS/ADC/GTH - COPY GLOBAL (ANY LEVEL) ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
START ;
 NEW (%)
GSGL ;
 R !,"Source global: ",SG:$G(DTIME,999),!
 Q:SG=""
 S:$E(SG)'="^" SG="^"_SG
 S:SG'["(" SG=SG_"("
 S:$E(SG,$L(SG))="," SG=$E(SG,1,$L(SG)-1)
 I SG'?1"^"1U.U1"(".UNP W $C(7) G GSGL
 I $E(SG,$L(SG))=")" W !!,"Global must be partial!,",!,$C(7) G GSGL
 KILL SUB,SCNT,NSUB
 I $E(SG,$L(SG))="(" I $D(@($E(SG,1,$L(SG)-1)))=0 W !!,"Global ",SG," does not exist!",!,$C(7) G GSGL
 I $E(SG,$L(SG))'="(" I $D(@(SG_")"))=0 W !!,"Partial global ",SG," does not exist!",!,$C(7) G GSGL
GDGL ;
 R !,"Destination global: ",DG:$G(DTIME,999),!
 Q:DG=""
 S:$E(DG)'="^" DG="^"_DG
 S:DG'["(" DG=DG_"("
 S:$E(DG,$L(DG))="," DG=$E(DG,1,$L(DG)-1)
 I DG'?1"^"1U.U1"(".UNP W $C(7) G GDGL
 I $E(DG,$L(DG))=")" W !!,"Global must be partial!,",!,$C(7) G GDGL
 KILL SUB,SCNT,NSUB
 I SG=DG W !!,"Output same as input!",$C(7),! G GSGL
 I $L(DG)>$L(SG) I $E(DG,1,$L(SG))=SG W !!,"Output contained in input!",$C(7),! G GSGL
 I $L(DG)<$L(SG) I $E(SG,1,$L(DG))=DG W !!,"Input contained in output!",$C(7),! G GSGL
 I $E(DG,$L(DG))="(" I $D(@($P(DG,"(",1)))'=0 W !!,"Destination global """,$P(DG,"(",1),""" already exists!",! S IS=""
 I $E(DG,$L(DG))'="(" I $D(@(DG_")"))'=0 W !!,"Partial global ",DG," already exists.",! S IS=""
 I $D(IS) W !,"KILL (Y/N) " R ANS:$G(DTIME,999) I $E(ANS)="Y" K:$E(DG,$L(DG))="(" @($E(DG,1,$L(DG)-1))  K:$E(DG,$L(DG))'="(" @(DG_")")
 I $D(IS),ANS'="Y" W !,"Copy anyway? (Y/N) N//" R ANS:$G(DTIME,999) S:ANS="" ANS="N" Q:ANS'="Y"
 I $E(SG,$L(SG))="(" S FROM=$E(SG,1,$L(SG)-1)
 E  S FROM=SG_")"
 I $E(DG,$L(DG))="(" S TO=$E(DG,1,$L(DG)-1)
 E  S TO=DG_")"
 S:$D(@(FROM))#10 @(TO)=@(FROM)
 S (SCMA,DCMA)=""
 S:$E(SG,$L(SG))'="(" SCMA=","
 S:$E(DG,$L(DG))'="(" DCMA=","
 S CTR=0
 D WALK
 W !!,"All done!",!
 G START
 ;
WALK ; TRAVERSE TREE AT CURRENT SUBSCRIPT LEVEL
 NEW (CTR,SCMA,DCMA,SG,DG)
 S NL=""
 F L=0:0  S NL=$O(@(SG_SCMA_""""_NL_""")")) Q:NL=""  D GOTNODE
 Q
 ;
GOTNODE ; PROCESS ONE NODE
 S CTR=CTR+1
 W:'(CTR#100) "."
 S FROM=SG_SCMA_"NL)",TO=DG_DCMA_"NL)"
 I $D(@(FROM))#10 S VAL=@(FROM),@(TO)=VAL
 I $D(@(FROM))\10 S LNL=$L(NL),SG=SG_SCMA_""""_NL_"""",DG=DG_DCMA_""""_NL_"""",SVSCMA=SCMA,SVDCMA=DCMA,(SCMA,DCMA)="," D WALK S SCMA=SVSCMA,DCMA=SVDCMA,SG=$E(SG,1,$L(SG)-(LNL+2+$L(SCMA))),DG=$E(DG,1,$L(DG)-(LNL+2+$L(DCMA)))
 Q
 ;
