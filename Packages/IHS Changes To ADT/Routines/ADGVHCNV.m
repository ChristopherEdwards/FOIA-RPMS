ADGVHCNV ; IHS/ADC/PDW/ENM - V HOSP DISCHARGE TYPE CONVERSION ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;searhc/maw this file needs to set piece 6 and 7 of the
 ;v hospitalization file.  compare 42.2 and 405.1 to get the 
 ;correct corresponding numbers.  this cannot be done unless
 ;every init has already been run
 ;this routine has been replaced by ^ADGGFL
 ;
 ;
 W !!,"This routine is not ready yet..."
 Q
 I $P($G(^DG5(1,"IHS")),U)="C" D  Q
 . W !,"... movement type conversion already run!",!
 N A,I,N,C D INIT
A ; -- v hosp
 S I=+$G(^DG5(1,"IHS")) D:I RS
 F  S I=$O(^AUPNVINP(I)) Q:'I  D
 . S N=$G(^AUPNVINP(+I,0)) Q:'N
 . S C=$P(N,U,6),^DG5(1,"IHS")=I_U_C
 . S C=$O(A(+C,0)),$P(^AUPNVINP(I,0),U,6)=C
 S ^DG5(1,"IHS")="C"
 Q
 ;
INIT ; -- (42.2 ien, 405.1 ien)
 ;searhc/maw this needs to be dynamic not hard set
 S A(1,12)="",A(2,13)="",A(3,14)="",A(4,15)="",A(5,16)="",A(6,17)=""
 S A(7,18)="",A(8,19)=""
 Q
 ;
RS ; -- restart conversion
 W !!,"... restarting movement type conversion with IEN #,",I,!!
 S N=$G(^DG5(1,"IHS")),I=+N,C=$P(N,U,2),C=$O(A(+C,0))
 S $P(^AUPNVINP(I,0),U,6)=C
 Q
