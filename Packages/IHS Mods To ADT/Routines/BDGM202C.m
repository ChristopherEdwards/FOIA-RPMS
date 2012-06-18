BDGM202C ; IHS/ANMC/LJF - M202 PRINT CONT. ; 
 ;;5.3;PIMS;**1003,1005,1006**;MAY 28, 2004
 ;IHS/ITSC/LJF 06/02/2005 PATCH 1003 make captions clearer
 ;IHS/OIT/LJF  05/04/2006 PATCH 1005 made changes based on new logic
 ;             08/24/2006 PATCH 1006 removed observation count - no longer needed
 ;
PART3 ; part III - Beds Available & Comments
 NEW NDAYS,LINE
 ;
 ; # of days in one month selected
 I BDGBM=BDGEM S NDAYS=$$ND
 ; OR # of days in range of months selected
 E  S X1=$E(BDGEM,1,5)_$$ND,X2=$E(BDGBM,1,5)_"01" D ^%DTC S NDAYS=X+1
 ;
 S LINE=$$REPEAT^XLFSTR("-",40)
 W !,DGLINE,!?16,"Part III",!?13,"Beds Available"
 W ?50,"Comments",!,LINE,!,"STAFF UNITS",?21,"# of Beds",?32,"% Occup."
 ;
 ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 enhance caption
 ;W ?45,"ALOS: ",?60,"ADULT: ",$J($$LOSA(),1,2)            ;adult alos
 ;W !,LINE,?56,"PEDIATRIC: ",$J($$LOSP(),1,2)              ;ped alos
 W ?45,"ALOS: ",?52,"ADULT MED/SUR: ",$J($$LOSA(),1,2)     ;adult alos
 W !,LINE,?53,"PEDS MED/SUR: ",$J($$LOSP(),1,2)            ;ped alos
 ;
 W !?58,"NEWBORN: ",$J($$LOSN(),1,2)                       ;nb  alos
 ;
 W !,"MEDICAL (Adult)",?28,DGBED("AM")                     ;# med beds
 W !,"SURGICAL (Adult)",?28,DGBED("AS"),?27,"_____"        ;# sur beds
 ;
 ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 enhance caption
 ;W ?45,"ADPL:",?60,"ADULT: ",$J(DGA(1,6)+DGA(3,6)/NDAYS,1,2)         ;adu adpl
 W ?45,"ADPL:",?52,"ADULT MED/SUR: ",$J(DGA(1,6)+DGA(3,6)/NDAYS,1,2)  ;adu adpl
 ;
 W !?15,"Subtotal",?28,DGBED("AM")+DGBED("AS"),?35,$$OA     ;adu beds & %
 ;
 ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 enhance caption
 ;W ?56,"PEDIATRIC: ",$J(DGA(2,6)/NDAYS,1,2)                ;ped adpl
 W ?53,"PEDS MED/SUR: ",$J(DGA(2,6)/NDAYS,1,2)              ;ped adpl
 ;
 W !?58,"NEWBORN: ",$J(DGA(4,6)/NDAYS,1,2)                  ;nb  adpl
 ;
 W !,"MEDICAL (Pediatric)",?28,DGBED("PM")                  ;# m ped beds
 W !,"SURGICAL (Pediatric)",?28,DGBED("PS"),?27,"_____"     ;# s ped beds
 ;
 ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 enhance caption
 ;W ?45,"1 DAY PATIENTS ADULT: ",DGA(1,10)                  ;1day-adults
 W ?45,"1 DAY PAT  ADULT M/S: ",DGA(1,10)                   ;1day-adults
 ;
 W !?15,"Subtotal",?28,DGBED("PM")+DGBED("PS"),?35,$$OP     ;ped beds & %
 ;
 ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 enhance caption
 ;W ?56,"PEDIATRIC: ",DGA(2,10),!?58,"NEWBORN: ",DGA(4,10)  ;1day-ped/nb
 W ?57,"PEDS M/S: ",DGA(2,10),!?58,"NEWBORN: ",DGA(4,10)    ;1day-ped/nb
 ;
 ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;W !,"OBSTETRIC",?28,DGBED("O"),?35,$$OO                   ;ob beds & %
 W !,"OBSTETRIC",?28,DGBED("OB"),?35,$$OO                   ;ob beds & %
 ;W !,"TUBERCULOSIS",?28,DGBED("T"),?35,$$OT                ;tb beds & %
 W !,"TUBERCULOSIS",?28,DGBED("TB"),?35,$$OT                ;tb beds & %
 ;
 W ?45,"ICU/SCU PATIENT DAYS: ",$$ICU                       ;icu pt days
 W !,"ALCOHOL/SUBSTANCE ABUSE",?28,DGBED("AL"),?35,$$OL     ;al beds & %
 ;
 W ?49,"PCU PATIENT DAYS: ",$$PCU
 ;
 W !,"MENTAL HEALTH",?28,DGBED("MH"),?35,$$OM               ;mh beds & %
 ;W ?51,"# OBSERVATIONS: ",$G(BDGOB)                         ;# observ pat;IHS/OIT/LJF 08/24/2006 PATCH 1006
 ;
 ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;W !,"ICU/SCU",?28,DGBED("I"),?35,$$OI                     ;icu beds & %
 W !,"ICU/SCU",?28,DGBED("IC"),?35,$$OI                     ;icu beds & %
 ;W !,"PCU",?28,DGBED("P"),?35,$$OU                         ;pcu beds & %
 W !,"PCU",?28,DGBED("PC"),?35,$$OU                         ;pcu beds & %
 ;
 W ?48,"NON-BENEFICIARIES: ",!?27,"_____",?53,"# Discharged: ",DGCNT
 ;
 W !?18,"Total",?28,$$TOT,?48,"With total LOS of ",DGLOS," days"
 ;
 ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;IHS/OIT/LJF 08/24/2006 PATHC 1006 removed extra line feed
 ;W !!,"NEWBORN",?28,DGBED("N"),?35,$$ON                    ;nb beds & %
 ;W !!,"NEWBORN",?28,DGBED("NB"),?35,$$ON                    ;nb beds & %
 W !,"NEWBORN",?28,DGBED("NB"),?35,$$ON                    ;nb beds & %
 ;
 W ?51,"% OF OCCUPANCY: ",$$OC,!,DGLINE
 W !,"Name of SUD",?35,"Signature Of SUD",?65,"Date"
 Q
 ;
DAY ;;31 28 31 30 31 30 31 31 30 31 30 31
 ;
ND() ; -- # days in month
 N X S X=$P($P($T(DAY),";;",2)," ",$E(BDGEM,4,5))
 Q $S(X'=28:X,$E(BDGEM,1,3)#4=0:29,1:X)
 ;
OA() ; -- occup, adult
 Q:'(DGBED("AM")+DGBED("AS")) ""
 Q $J(DGA(1,6)/NDAYS/(DGBED("AM")+DGBED("AS"))*100,3,0)_"%"
 ;
OP() ; -- occup, ped     
 Q:'(DGBED("PM")+DGBED("PS")) ""
 Q $J(DGA(2,6)/NDAYS/(DGBED("PM")+DGBED("PS"))*100,3,0)_"%"
 ;
OO() ; -- occup, ob
 ;Q:'DGBED("O") "" Q $J(DGA(3,6)/NDAYS/DGBED("O")*100,3,0)_"%"
 Q:'DGBED("OB") "" Q $J(DGA(3,6)/NDAYS/DGBED("OB")*100,3,0)_"%"  ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;
OT() ; -- occup, tb
 ;Q:'DGBED("T") "" Q $J(DGA(5,6)/NDAYS/DGBED("T")*100,3,0)_"%"
 Q:'DGBED("TB") "" Q $J(DGA(5,6)/NDAYS/DGBED("TB")*100,3,0)_"%"  ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;
OL() ; -- occup, al
 Q:'DGBED("AL") "" Q $J(DGA(6,6)/NDAYS/DGBED("AL")*100,3,0)_"%"
 ;
OM() ; -- occup, mh
 Q:'DGBED("MH") "" Q $J(DGA(7,6)/NDAYS/DGBED("MH")*100,3,0)_"%"
 ;
OI() ; -- occup, icu
 ;Q:'DGBED("I") ""  Q $J($$ICU/NDAYS/DGBED("I")*100,3,0)_"%"
 Q:'DGBED("IC") ""  Q $J($$ICU/NDAYS/DGBED("IC")*100,3,0)_"%"  ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;
OU() ; -- occup, pcu
 ;Q:'DGBED("P") ""  Q $J($$PCU/NDAYS/DGBED("P")*100,3,0)_"%"
 Q:'DGBED("PC") ""  Q $J($$PCU/NDAYS/DGBED("PC")*100,3,0)_"%"  ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;
ON() ; -- occup, nb
 ;Q:'DGBED("N") ""  Q $J(DGA(4,6)/NDAYS/DGBED("N")*100,3,0)_"%"
 Q:'DGBED("NB") ""  Q $J(DGA(4,6)/NDAYS/DGBED("NB")*100,3,0)_"%"  ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;
OC() ; -- % of occupancy
 NEW X,Y
 S Y=$$TOT S:'Y Y=1
 S X=DGX(6)/NDAYS/Y*100
 Q:'X "0.00%" Q $J(X,3,0)_"%"
 ;
ICU() ; -- icu patient days
 NEW X,D,T,E
 S (X,T)=0 F  S X=$O(^DIC(42,X)) Q:'X  D
 . Q:$$GET1^DIQ(9009016.5,X,101)'="YES"     ;not ICU ward
 . S D=BDGBM,E=$E(BDGEM,1,5)_"31"
 . F  S D=$O(^BDGCWD(X,1,D)) Q:'D!(D>E)  D
 .. S T=T+$P($G(^BDGCWD(+X,1,D,0)),U,2)+$P($G(^(0)),U,8)
 Q T
 ;
PCU() ; -- pcu patient days
 N X,D,T,E
 S (X,T)=0 F  S X=$O(^DIC(42,X)) Q:'X  D
 . Q:$$GET1^DIQ(9009016.5,X,103)'="YES"    ;not PCU ward
 . S D=BDGBM,E=$E(BDGEM,1,5)_"31"
 . F  S D=$O(^BDGCWD(X,1,D)) Q:'D!(D>E)  D
 .. S T=T+$P($G(^BDGCWD(+X,1,D,0)),U,2)+$P($G(^(0)),U,8)
 Q T
 ;
LOSA() ; -- alos, adult
 NEW X
 S X=(DGA(1,3)+DGA(1,4)+DGA(3,3)+DGA(3,4)) S:'X X=1
 Q (DGA(3,6)+DGA(1,6))/X
 ;
LOSP() ; -- alos, ped
 Q DGA(2,6)/$S(DGA(2,3)+DGA(2,4)>0:DGA(2,3)+DGA(2,4),1:1)
 ;
LOSN() ; -- alos, ped
 Q DGA(4,6)/$S(DGA(4,3)+DGA(4,4)>0:DGA(4,3)+DGA(4,4),1:1)
 ;
TOT() ; -- total # of beds ('nb)
 ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ;Q DGBED("AM")+DGBED("AS")+DGBED("PM")+DGBED("PS")+DGBED("O")+DGBED("I")+DGBED("T")+DGBED("AL")+DGBED("MH")+DGBED("P")
 Q DGBED("AM")+DGBED("AS")+DGBED("PM")+DGBED("PS")+DGBED("OB")+DGBED("IC")+DGBED("TB")+DGBED("AL")+DGBED("MH")+DGBED("PC")
