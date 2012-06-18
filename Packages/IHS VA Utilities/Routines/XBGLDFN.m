XBGLDFN ; IHS/ADC/GTH - GET LAST DFN ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
START ;
 NEW GBL,LDFN,NDFN,STRT,TGBL
LOOP ;
 R !,"Enter global reference like '^DPT(""B"",' ",GBL:$G(DTIME,999)
 Q:GBL=""
 I $E(GBL)="?"!(GBL'?1"^"1U.U.E) W !,"Enter global reference (e.g. ""^AUPNPAT("")." G LOOP
 S TGBL=$S($E(GBL,$L(GBL))="(":$P(GBL,"(",1),$E(GBL,$L(GBL))=",":$E(GBL,1,$L(GBL)-1)_")",$E(GBL,$L(GBL))'=")":GBL_")",1:GBL)
 I '$D(@(TGBL)) W !!,"Global ",GBL," does not exist!" G XBGLDFN
 R !,"Start after DFN: 0// ",STRT:$G(DTIME,999)
 S:STRT="" STRT=0
 S LDFN="Started after high DFN"
 S NDFN=$D(@(GBL_STRT_")")),NDFN=STRT F L=0:0 S NDFN=$O(^(NDFN)) Q:NDFN=""!(NDFN'?1N.N)  S LDFN=NDFN
 W !!,"Last DFN is ",LDFN
 Q
 ;
