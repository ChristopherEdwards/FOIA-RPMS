APCLDF0 ; IHS/CMI/LAB -IHS -INTERACTIVE ROUTINE FOR DATA FETCHER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 D ^XBKVAR
START S DIC="^DPT(",DIC(0)="EAQM" D ^DIC K DIC Q:Y=-1  S APCLPDFN=+Y W !
ASK ;
 R !,"ENTER SCRIPT: ",APCLX:DTIME
 I '$T!(U[$G(APCLX))!(APCLX=" ") K APCLPDFN,APCLX,APCLY,APCLINT,APCLTYPE,APCLER G START
 I $P(APCLX," ")="DATE"!($P(APCLX," ")="VALUE") W !!,*7,"Do not enter the words 'DATE' or 'VALUE' before your script.  This is done",!,"only for use with the report template utility.",! G ASK
 NEW % F %=1:1:$L(APCLX) S:$E(APCLX,%)?1L APCLX=$E(APCLX,0,%-1)_$C($A(APCLX,%)-32)_$E(APCLX,%+1,999)
 K APCLDFVR S APCLY="APCLDFVR(",APCLX=APCLPDFN_U_APCLX,APCLINT=1 S APCLER=$$START1^APCLDF(APCLX,APCLY,APCLINT,.APCLTYPE) S APCLX=$P(APCLX,U,2) I $D(APCLDFVR) W ! D  K APCLDFVR
 . NEW I,Z,VALUE
 . F I=1:1 Q:'$D(APCLDFVR(I))  S Y=$P(APCLDFVR(I),U),Z=$P(APCLDFVR(I),U,2),T=$P(APCLDFVR(I),U,3) D
 .. W !,$S($E("PATIENT",1,$L($P(APCLX," ")))=$P(APCLX," ")!($P(APCLX," ")="PT"):"",1:$S(APCLTYPE="NV":"DATE NOTED OR LAST MODIFIED: ",1:"VISIT DATE: ")_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_(1700+$E(Y,1,3))) W:Z]""&(Z'=T) "    VALUE: ",Z D
 ... I Z]""&(Z'=T) W ?45
 ... E  W "   "
 ... W $S(T]"":$S(Z]""&(Z'=T):"TYPE: ",1:"VALUE: ")_T,1:"") K Y,Z,T
 E  I 'APCLER W !,"No ",$S($E("PATIENT",1,$L($P(APCLX," ")))=$P(APCLX," ")!($P(APCLX," ")="PT"):"demographic value",1:"clinical occurrence")," for this patient"
 I APCLER W *7,!,"      =>  ",$P($T(@APCLER^APCLDF2),";",3) K APCLER
 W ! G ASK
