FHWOR8 ; HISC/NCA - Dietetics Order Parameter ;2/24/95  07:56 ;
 ;;5.0;Dietetics;**6,34,37**;Oct 11, 1995;
EN(DFN,FHPAR) ; Get the Order Parameter by passing the DFN and Variable
 ; array FHPAR(1)-FHPAR(3) is returned.
 N WARD,ADM,DP,FHWRD
 S FHPAR="",WARD=$G(^DPT(DFN,.1)) G:WARD="" EXIT
 S ADM=$G(^DPT("CN",WARD,DFN)) G:ADM<1 EXIT
 S FHWRD=$P($G(^FHPT(DFN,"A",ADM,0)),"^",8),DP=$P($G(^FH(119.6,+FHWRD,0)),"^",8)
 S FHPAR(1)=$G(^FH(119.73,+DP,1)),FHPAR(2)=$G(^FH(119.73,+DP,2))
 S FHPAR(3)=$P($G(^FH(119.6,+FHWRD,0)),"^",10)
EXIT Q
 ;
EN1(WARD,FHPAR) ; Get the Order Parameters by passing the WARD
 ; array FHPAR(1)-FHPAR(3) is returned.
 K FHPAR N DP,FHWRD
 S FHWRD=$O(^FH(119.6,"AW",WARD,"")) I FHWRD="" Q
 S DP=$P($G(^FH(119.6,+FHWRD,0)),"^",8) I DP="" Q
 S FHPAR(1)=$G(^FH(119.73,+DP,1)),FHPAR(2)=$G(^FH(119.73,+DP,2))
 S FHPAR(3)=$P($G(^FH(119.6,+FHWRD,0)),"^",10)
 Q
