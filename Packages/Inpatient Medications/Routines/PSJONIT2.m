PSJONIT2 ; ; 06-OCT-1994
 ;;4.5; Inpatient Medications ;;7 Oct 94
 ;
 ;
 K ^UTILITY("ORVROM",$J),DIC
 Q
DT W !
 I '$D(DTIME) S DTIME=999
 K %DT D NOW^%DTC S DT=X
 K DIK,DIC,%I,DICS Q
 ;
