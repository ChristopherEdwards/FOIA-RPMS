ADGSVP1 ; IHS/ADC/PDW/ENM - HSA-202 PRINT ; [ 12/08/1999  4:17 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**2,3**;MAR 25, 1999
 ;
 N ND,LN,X,Y,X1,X2
 S X1=$E(DGEMON,1,5)_$$ND,X2=$E(DGSMON,1,5)_"01" D ^%DTC S ND=X+1
 S LN="",$P(LN,"-",40)=""
P3 W !,DGLINE,!?16,"Part III",!?13,"Beds Available"
 W ?50,"Comments",!,LN,!,"STAFF UNITS",?21,"# of Beds",?32,"% Occup."
 ;W ?45,"ALOS: ",?60,"ADULT: ",$J(DGA(1,9)/DGLOS(1),1,2)    ;adu alos
 W ?45,"ALOS: ",?60,"ADULT: ",$J($$LOS1(),1,2)
 ;W !,LN,?56,"PEDIATRIC: ",$J(DGA(2,9)/DGLOS(2),1,2)        ;ped alos
 W !,LN,?56,"PEDIATRIC: ",$J($$LOS2(),1,2)
 ;W !?58,"NEWBORN: ",$J(DGA(4,9)/DGLOS(4),1,2)             ;nb  alos
 W !?58,"NEWBORN: ",$J($$LOS4(),1,2)
 W !,"MEDICAL (Adult)",?28,DGBED("AM")                     ;# med beds
 W !,"SURGICAL (Adult)",?28,DGBED("AS"),?27,"_____"        ;# sur beds
 W ?45,"ADPL:",?60,"ADULT: ",$J(DGA(1,6)+DGA(3,6)/ND,1,2)  ;adu adpl
 W !?15,"Subtotal",?28,DGBED("AM")+DGBED("AS"),?35,$$OA   ;adu # & %
 W ?56,"PEDIATRIC: ",$J(DGA(2,6)/ND,1,2)                   ;ped adpl
 W !?58,"NEWBORN: ",$J(DGA(4,6)/ND,1,2)                   ;nb  adpl
 W !,"MEDICAL (Pediatric)",?28,DGBED("PM")                 ;# m ped beds
 W !,"SURGICAL (Pediatric)",?28,DGBED("PS"),?27,"_____"    ;# s ped beds
 W ?45,"1 DAY PATIENTS ADULT: ",DGA(1,10)                  ;1day
 W !?15,"Subtotal",?28,DGBED("PM")+DGBED("PS"),?35,$$OP   ;ped # & %
 W ?56,"PEDIATRIC: ",DGA(2,10),!?58,"NEWBORN: ",DGA(4,10) ;1day
 W !,"OBSTETRIC",?28,DGBED("O"),?35,$$OO                   ;ob  # & %
 W !,"TUBERCULOSIS",?28,DGBED("T"),?35,$$OT                ;tb  # & %
 W ?49,"ICU PATIENT DAYS: ",$$ICU
 W !,"ALCOHOL/SUBSTANCE ABUSE",?28,DGBED("AL"),?35,$$OL    ;al  # & %
 W ?49,"PCU PATIENT DAYS: ",$$PCU
 W !,"MENTAL HEALTH",?28,DGBED("MH"),?35,$$OM              ;mh  # & %
 W !,"ICU/SCU",?28,DGBED("I"),?35,$$OI                     ;icu # & %
 W !,"PCU",?28,DGBED("P"),?35,$$OU                         ;pcu # & %
 W ?48,"NON-BENEFICIARIES: ",!?27,"_____",?53,"# Discharged: ",DGCNT
 W !?18,"Total",?28,$$TOT,?48,"With total LOS of ",DGLOS," days"
 W !!,"NEWBORN",?28,DGBED("N"),?35,$$ON                    ;nb  # & %
 W ?51,"% OF OCCUPANCY: ",$$OC,!,DGLINE
 W !,"Name of SUD",?35,"Signature Of SUD",?65,"Date" Q
 ;
DAY ;;31 28 31 30 31 30 31 31 30 31 30 31
 ;
ND() ; -- # days in month
 N X S X=$P($P($T(DAY),";;",2)," ",$E(DGEMON,4,5))
 Q $S(X'=28:X,$E(DGEMON,1,3)#4=0:29,1:X)
 ;
OA() ; -- occup, adult
 Q:'(DGBED("AM")+DGBED("AS")) ""
 Q $E($P(DGA(1,6)/ND/(DGBED("AM")+DGBED("AS")),".",2),1,2)_"%"
 ;
OP() ; -- occup, ped     
 Q:'(DGBED("PM")+DGBED("PS")) ""
 Q $E($P(DGA(2,6)/ND/(DGBED("PM")+DGBED("PS")),".",2),1,2)_"%"
 ;
OO() ; -- occup, ob
 Q:'DGBED("O") "" Q $E($P(DGA(3,6)/ND/DGBED("O"),".",2),1,2)_"%"
 ;
OT() ; -- occup, tb
 Q:'DGBED("T") "" Q $E($P(DGA(5,6)/ND/DGBED("T"),".",2),1,2)_"%"
 ;
OL() ; -- occup, al
 Q:'DGBED("AL") "" Q $E($P(DGA(6,6)/ND/DGBED("AL"),".",2),1,2)_"%"
 ;
OM() ; -- occup, mh
 Q:'DGBED("MH") "" Q $E($P(DGA(7,6)/ND/DGBED("MH"),".",2),1,2)_"%"
 ;
OI() ; -- occup, icu
 Q:'DGBED("I") ""  Q $E($P($$ICU/ND/DGBED("I"),".",2),1,2)_"%"
 ;
OU() ; -- occup, pcu
 Q:'DGBED("P") ""  Q $E($P($$PCU/ND/DGBED("P"),".",2),1,2)_"%"
 ;
ON() ; -- occup, nb
 Q:'DGBED("N") ""  Q $E($P(DGA(4,6)/ND/DGBED("N"),".",2),1,2)_"%"
 ;
OC() ; -- % of occupancy
 N X S X=DGX(6)/ND/$$TOT Q:'X "0.00%" Q $E($P(X,".",2),1,2)_"%"
 ;
ICU() ; -- icu patient days
 N X,D,T,E
 S (X,T)=0 F  S X=$O(^DIC(42,X)) Q:'X  D
 . Q:$P($G(^DIC(42,X,"IHS")),U)'="Y"
 . S D=DGSMON,E=$E(DGEMON,1,5)_"31"
 . F  S D=$O(^ADGWD(X,1,D)) Q:'D!(D>E)  D
 .. S T=T+$P($G(^ADGWD(+X,1,D,0)),U,2)+$P($G(^(0)),U,8)
 Q T
 ;
PCU() ; -- pcu patient days
 N X,D,T,E
 S (X,T)=0 F  S X=$O(^DIC(42,X)) Q:'X  D
 . Q:$P($G(^DIC(42,X,"IHS")),U,5)'=1
 . S D=DGSMON,E=$E(DGEMON,1,5)_"31"
 . F  S D=$O(^ADGWD(X,1,D)) Q:'D!(D>E)  D
 .. S T=T+$P($G(^ADGWD(+X,1,D,0)),U,2)+$P($G(^(0)),U,8)
 Q T
 ;
LOS1() ; -- alos, adult
 ;IHS/DSD/ENM 12/08/99 DIV ERROR FIX
 ;Q (DGA(3,6)+DGA(1,6))/(DGA(1,3)+DGA(1,4)+DGA(3,3)+DGA(3,4))
 Q (DGA(3,6)+DGA(1,6))/$S(DGA(1,3)+DGA(1,4)+DGA(3,3)+DGA(3,4)>0:DGA(1,3)+DGA(1,4)+DGA(3,3)+DGA(3,4),1:1)
 ;
LOS2() ; -- alos, ped
 ;IHS/DSD/ENM 05/17/99 DIV ERROR FIX
 ;Q DGA(2,6)/(DGA(2,3)+DGA(2,4))
 Q DGA(2,6)/$S(DGA(2,3)+DGA(2,4)>0:DGA(2,3)+DGA(2,4),1:1)
 ;
LOS4() ; -- alos, ped
 ;IHS/DSD/ENM 05/17/99 DIV ERROR FIX
 ;Q DGA(4,6)/(DGA(4,3)+DGA(4,4))
 Q DGA(4,6)/$S(DGA(4,3)+DGA(4,4)>0:DGA(4,3)+DGA(4,4),1:1)
 ;
TOT() ; -- total # of beds ('nb)
 Q DGBED("AM")+DGBED("AS")+DGBED("PM")+DGBED("PS")+DGBED("O")+DGBED("I")+DGBED("T")+DGBED("AL")+DGBED("MH")+DGBED("P")
