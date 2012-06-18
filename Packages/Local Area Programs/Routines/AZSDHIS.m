AZSDHIS ; DELETE HIS IIDs [ 10/03/85  2:16 PM ]
 S DFN=0 F L=0:0 S DFN=$O(^AUPNPAT(DFN)) Q:$E(DFN)]9  W "." D:$D(^(DFN,41,4584,0))
 . W "*"
 . S HRNO=$P(^(0),"^",2)
 . K ^(0),^AUPNPAT("D",HRNO,DFN,4584)
 . S $P(^AUPNPAT(DFN,41,0),"^",4)=$P(^AUPNPAT(DFN,41,0),"^",4)-1
 W !!,"ALL DONE"
 Q
