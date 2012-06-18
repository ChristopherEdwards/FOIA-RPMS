BDGCEN20 ; IHS/ANMC/LJF - CENSUS AID-LIST BY SERVICE ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW DGDT,DGSTR,ADJ
 ;
 ; adjustment for piece in node (peds items are 10 pieces higher)
 S ADJ=$S(BDGAGE="A":0,1:10)
 ;
 ; -- loop thru census file by service and print data
 S DGDT=BDGBD-.0001
 F  S DGDT=$O(^BDGCTX(BDGTX,1,DGDT)) Q:'DGDT  Q:(DGDT>BDGED)  D
 . ;
 . I '$D(^BDGCTX(BDGTX,1,DGDT,0)) D  Q
 .. W !!,"NO CENSUS DATA FOR THIS SERVICE FOR ",$$FMTE^XLFDT(DGDT),!!
 . ;
 . S DGSTR=^BDGCTX(BDGTX,1,DGDT,0)
 . W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)
 . W ?17,$P(DGSTR,U,3+ADJ),?27,$P(DGSTR,U,5+ADJ)
 . W ?37,$P(DGSTR,U,6+ADJ),?48,$P(DGSTR,U,4+ADJ)
 . W ?58,$P(DGSTR,U,7+ADJ),?69,$P(DGSTR,U,2+ADJ)
 Q
 ;
 ;
HEAD ;***> subrtn to print heading
 ; DGPAGE is set by calling routine
 NEW SITE,TITLE,LINE
 S SITE=$$GET1^DIQ(4,DUZ(2),.01),LINE=$$REPEAT^XLFSTR("=",80)
 S TITLE=$$GET1^DIQ(45.7,BDGTX,.01)_" SERVICE"
 ;
 W:DGPAGE>0 @IOF S DGPAGE=DGPAGE+1
 W !,$$GET1^DIQ(200,DUZ,2),?80-$L(SITE)/2,SITE
 W !,$$TIME^BDGF($$NOW^XLFDT)
 S X="ADT CENSUS DATA FOR" W ?80-$L(X)/2,X
 S Y=DT X ^DD("DD") W !,Y
 W !,$$FMTE^XLFDT(DT),?80-$L(TITLE)/2,TITLE,?70,"Page: ",DGPAGE
 W !,LINE,!,"Date",?15,"Admits",?25,"Trans In",?35,"Trans Out"
 W ?46,"Disch",?55,"Deaths",?65,"Remaining",!,LINE,!
 Q
