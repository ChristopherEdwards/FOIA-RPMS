BSDLT1 ; IHS/ANMC/LJF - IHS CALLS FOR LETTERS ;  [ 12/27/2004  3:22 PM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
FUTURE(DFN,BSDCNT) ;EP
 ; called to print list of all future appts for patient
 ; BSDCNT is count of # of appts rescheduled; killed by calling rtn
 NEW BSDX,BSDN,SDX,SDLT,%DT,X,Y
 D PEND^BSDU2(DFN,0,"BSDX(")  ;find pending appts
 I $G(BSDX(2))="" Q           ;none found
 I $G(BSDX(3))="" Q  ;only one appt;IHS/ITSC/LJF 10/25/2004 PATCH 1001
 I '$D(BSDX($G(BSDCNT)+2)) Q  ;only rescheduled for future appts
 ;
 ; screen out future appointments to selected clinics
 S X=0 F  S X=$O(^BSDX(X)) Q:'X  D
 . S Y=$G(^BSDX(X,0)) I Y,$D(VAUTC(Y)) K BSDX(X)
 Q:'$D(BSDX)   ;quit if all future were already printed
 ;
 W !!?5,"In summary, here is a list of all your upcoming appointments:",!
 S BSDN=1 F  S BSDN=$O(BSDX(BSDN)) Q:'BSDN  D
 . S %DT="T",X=$P(BSDX(BSDN),U) D ^%DT Q:Y=-1
 . S SDX=Y,SDCL=$P(BSDX(BSDN),U,2) D FORM^SDLT
 Q
