BARPMUP4 ; IHS/SD/LSL - OVERFLOW FROM BARPMUP2 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 12/16/02 - V1.7 - NHA-0601-180049
 ;      Modified to carry through changes made to BARPMUP2
 ;
 ; *********************************************************************
 ;;
STAT ;EP - Status review of previous run
 S BARLDUZ=$G(^BARTMP("BARUP","DUZ(2)"))
 S BAREND=$G(^BARTMP("BARUP","PREVIOUS END DATE"))
 S BARSTART=$G(^BARTMP("BARUP","PREVIOUS START DATE"))
 S BARDA=$G(^BARTMP("BARUP","LAST BILL IEN",BARLDUZ))
 S BARBLNM=$G(^BARTMP("BARUP","LAST BILL NAME",BARLDUZ))
 S BARUSTAT=$G(^BARTMP("BARUP","STATUS"))
 S BARGO=$G(^BARTMP("BARUP","LAST AP DATE",BARLDUZ))
 S BARCNT=$G(^BARTMP("BARUP","COUNT"))
 S BARDTS=$G(^BARTMP("BARUP","LAST DATE"))
 W !,"PREVIOUS START DATE",?30,BARSTART
 W !,"PREVIOUS END DATE",?30,BAREND
 W !,"LAST 3P BILL LOCATION",?30,$$GET1^DIQ(4,BARLDUZ,.01)
 W !,"LAST BILL NAME",?30,BARBLNM
 W !,"LAST BILL IEN",?30,BARDA
 W !,"STATUS OF LAST RUN",?30,BARUSTAT
 W !,"LAST TRANSACTION TIME",?30,BARDTS
 W !,"UPLOAD COUNT",?30,+BARCNT,!!
 I $D(^BARTMP("BARUP","ERRORS")) D
 . W "PAST BAD BILLS ARE:",!
 . S BARDTS=""
 . F  S BARDTS=$O(^BARTMP("BARUP","ERRORS",BARDTS)) Q:'$L(BARDTS)  W !,?10,^(BARDTS)
 . W !!,"You must note the above as the >BAD< Bill(s) above"
 . W !,"did not cross over to A/R and will have to be manually"
 . W !,"uploaded after being reseached as to why they broke."
 . W !!
STATE Q
 ;;overflow from BARPMUP2
