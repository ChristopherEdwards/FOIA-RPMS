AUGLDFN ; GET LAST DFN [ 06/17/85  8:01 AM ]
 R !,"Global: ",GBL
 Q:GBL=""
 I $E(GBL)="?"!(GBL'?1"^"1U.U.E) W !,"Enter global reference (e.g. ""^APAT("")." G AUGLDFN
 S TGBL=$S($E(GBL,$L(GBL))="(":$P(GBL,"(",1),$E(GBL,$L(GBL))=",":$E(GBL,1,$L(GBL)-1)_")",$E(GBL,$L(GBL))'=")":GBL_")",1:GBL)
 I '$D(@(TGBL)) W !!,"Global ",GBL," does not exist!" G AUGLDFN
 R !,"Start after DFN: 0// ",STRT
 S:STRT="" STRT=0
 S LDFN="Started after high DFN"
 S NDFN=$D(@(GBL_STRT_")")),NDFN=STRT F L=0:0 S NDFN=$O(^(NDFN)) Q:NDFN=""!(NDFN'?1N.N)  S LDFN=NDFN
 W !!,"Last DFN is ",LDFN
 Q
