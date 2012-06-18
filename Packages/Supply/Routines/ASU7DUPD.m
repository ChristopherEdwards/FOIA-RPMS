ASU7DUPD ; IHS/ITSC/LMH -POST DIRECT ISSUE TRANS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine provides logic to post (process) DIRECT ISSUE
 S:$G(DDSREFT)']"" DDSREFT=$G(ASUV("DDSREFT"))
 S ASUMK("E#","IDX")=99999999
 D ^ASUMKBPS ;Update Issue Book master
 D ^ASUMYDPS ;Update Year to Date Issue data  master
 D ^ASUJHIST ;Move transaction to History file
 K ASUMS
 Q
