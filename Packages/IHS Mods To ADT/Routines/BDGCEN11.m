BDGCEN11 ; IHS/ANMC/LJF - CENSUS AID-LIST BY WARD&SRV ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW DGDT,STR,SRV,X
 ; -- loop thru census files by ward & service
 S DGDT=BDGBD-.0001
 F  S DGDT=$O(^BDGCWD(BDGWD,1,DGDT)) Q:'DGDT  Q:(DGDT>BDGED)  D
 . ;
 . ; print totals for ward for date
 . S STR=$G(^BDGCWD(BDGWD,1,DGDT,0))
 . W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)
 . W ?17,$P(STR,U,3),?27,$P(STR,U,5)
 . W ?37,$P(STR,U,6),?48,$P(STR,U,4)
 . W ?58,$P(STR,U,7),?69,$P(STR,U,2)
 . ;
 . ; now loop through services within ward
 . S SRV=0
 . F  S SRV=$O(^BDGCWD(BDGWD,1,DGDT,1,SRV)) Q:'SRV  D
 .. Q:'$D(^BDGCWD(BDGWD,1,DGDT,1,SRV,0))
 .. S X=$P(^BDGCWD(BDGWD,1,DGDT,1,SRV,0),U,2,21)
 .. S X=$$STRIP^XLFSTR(X,U),X=$$STRIP^XLFSTR(X,"0") Q:X=""
 .. ;
 .. ; print numbers of service within ward
 .. S STR=^BDGCWD(BDGWD,1,DGDT,1,SRV,0)
 .. W !?3,$$GET1^DIQ(45.7,SRV,99)                     ;abbreviation
 .. W ?17,$P(STR,U,3)+$P(STR,U,13)                    ;admissions
 .. W ?27,$P(STR,U,5)+$P(STR,U,15)                    ;transfer in
 .. W ?37,$P(STR,U,6)+$P(STR,U,16)                    ;transfer out
 .. W ?48,$P(STR,U,4)+$P(STR,U,14)                    ;discharge
 .. W ?58,$P(STR,U,7)+$P(STR,U,17)                    ;deaths
 .. W ?69,$P(STR,U,2)+$P(STR,U,12)                    ;pts remaining
 . W !
 Q
 ;
