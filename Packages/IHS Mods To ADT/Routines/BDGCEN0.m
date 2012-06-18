BDGCEN0 ; IHS/ANMC/LJF - CENSUS AID-BY WARD CONT ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW DGTOT,DGCNT,DGDT,DGSTR
 S (DGTOT,DGCNT)=0
 ;
 ; -- loop thru adt census-ward file by date
 S DGDT=BDGBD-.0001
 F  S DGDT=$O(^BDGCWD(BDGWD,1,DGDT)) Q:'DGDT  Q:(DGDT>BDGED)  D
 . ;
 . I '$D(^BDGCWD(BDGWD,1,DGDT,0)) D  Q
 .. W !!,"NO CENSUS DATA FOR THIS WARD FOR ",$$FMTE^XLFDT(DGDT,2),!!
 . ;
 . S DGSTR=^BDGCWD(BDGWD,1,DGDT,0)
 . W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)  ;date
 . W ?12,$P(DGSTR,U,3)  ;admits
 . W ?22,$P(DGSTR,U,5)  ;trans in
 . W ?32,$P(DGSTR,U,6)  ;trans out
 . W ?42,$P(DGSTR,U,4)  ;disch
 . W ?51,$P(DGSTR,U,7)  ;deaths
 . W ?61,$P(DGSTR,U,2)  ;# remaining
 . W ?71,$J($$BENCHMRK,3,0)
 . S DGCNT=DGCNT+1,DGTOT=DGTOT+$$BENCHMRK
 ;
 W !?60,"Average:",?71,$J($S(DGTOT=0:0,1:DGTOT/DGCNT),3,0)
 Q
 ;
HEAD ;EP; -- subrtn to print heading
 ; DGPAGE set by calling routine
 NEW DGSITE,DGDUZ,DGTL,DGLIN
 S DGSITE=$$GET1^DIQ(4,DUZ(2),.01),DGDUZ=$$GET1^DIQ(200,DUZ,2)
 S DGTL=$$GET1^DIQ(42,BDGWD,.01)_" WARD",DGLIN=$$REPEAT^XLFSTR("=",80)
 ;
 W:DGPAGE>0 @IOF S DGPAGE=DGPAGE+1
 W !,DGDUZ,?80-$L(DGSITE)/2,DGSITE             ;user initials & site
 W !,$$TIME^BDGF($$NOW^XLFDT) W ?28,"ADT WARD CENSUS DATA FOR"
 W !,$$FMTE^XLFDT(DT),?80-$L(DGTL)/2,DGTL,?70,"Page: ",DGPAGE
 W !,DGLIN
 W !,"Date",?10,"Admits",?19,"Trans In",?29,"Trans Out"
 W ?40,"Disch",?49,"Deaths",?57,"Remaining",?69,"Unit Score"
 W !,DGLIN,!
 Q
 ;
 ;
BENCHMRK() ;bed control movements divided by # remaining
 NEW X,I,Y
 F I=3,4,5,6,7 S X=$G(X)+$P(DGSTR,U,I)
 S Y=$P(DGSTR,U,2) I +Y=0 S Y=1
 Q $G(X)/Y*100
