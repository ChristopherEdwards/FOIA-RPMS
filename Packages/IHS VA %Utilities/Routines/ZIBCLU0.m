%ZIBCLU0 ; IHS/ADC/GTH - GENERAL PURPOSE CLEAN UP UTILITY GLOBALS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
EN ;
 Q:'($ZV?1"MSM".E!($ZV?1"DSM".E))  ; Only works for MSM or DSM.
 S ZIBOS=$ZV ; Set operating system.
 D @$S(ZIBOS?1"DSM".E:"DSM",1:"MSM") ; Active JOB lookup per operating system.
 D XUT ; Cleanup the ^XUTL global.
 F ZIBGR="^ZUT(","^UTILITY(" D GO ; Check the ^ZUT and ^UTILITY globals for nodes to be removed.
 D OUT ; KILL off variables and exit gracefully.
 Q
 ;
MSM ; MSM specific look up of active JOBs.
 S $ZT="MER^%ZIBCLU0"
 V 44:$J:$ZB($V(44,$J,2),1,7):2
 S ZIBST=$V(44),ZIBSTA=$V(ZIBST+8,-3,2)+ZIBST,ZIBMXJ=$V($V(ZIBST+284),-3,4),ZIBPT=$V(3*4+ZIBSTA)
 ; Build active JOB table (ZIBJT).
 F ZIBJ=1:1:ZIBMXJ S:$V(ZIBJ*4+ZIBPT) ZIBJT(ZIBJ)=$ZU(($V(2,ZIBJ,2)#32),($V(2,ZIBJ,2)\32))
 Q
 ;
MER ;EP - MSM error trap.
 V 44:$J:$ZB($V(44,$J,2),#FFFE,1):2
 ZQ
 ;
DSM ; DSM specific look up of active JOBs.
 S ZIBST=$V(44),ZIBSJT=$V(ZIBST+4)
 ; Build active JOB table (ZIBJT).
 F ZIBI=ZIBSJT+2:2:ZIBSJT+126 I $V(ZIBI+1),$V(ZIBI+1)'=244 S ZIBJ=ZIBI-ZIBSJT\2 S:ZIBJ]"" ZIBJT(ZIBJ)=$ZU(($V(149,ZIBJ)#32),($V(149,ZIBJ)\32))
 S ZIBJT($J)=$ZU(0) ; Put this JOB and UCI in the JOB table.
 KILL ZIBSJT
 Q
 ;
XUT ; Clenaup ^XUTL in MGR separate from other UCIs.
 I $ZU(0)?1"MGR".E D
 . S ZIBJ=""
 . F  S ZIBJ=$O(^XUTL("XQ",ZIBJ)) Q:ZIBJ=""  KILL:'$D(ZIBJT(ZIBJ)) ^(ZIBJ)
 E  D
 .S ZIBJ=""
 .S ZIBK=1 ; Set KILL flag ON - Set OFF if other JOBs active in this UCI
 .F  S ZIBJ=$O(ZIBJT(ZIBJ)) Q:ZIBJ=""  S:ZIBJ'=$J&(ZIBJT(ZIBJ)=$ZU(0)) ZIBK=0
 .I ZIBK S ZIBX="" F  S ZIBX=$O(^XUTL(ZIBX)) Q:ZIBX=""  KILL ^(ZIBX)
 Q
 ;
GO ; $O down ^ZUT or ^UTILITY looking for (jobnbr OR (namespace,jobnbr
 S ZIBX1=""
 F  S (ZIBA,ZIBJ,ZIBX1)=$O(@(ZIBGR_""""_ZIBX1_""")")) Q:ZIBX1=""  D @$S(ZIBX1?1N.N:"N1",1:"N2")
GOQ ;
 Q
 ;
N1 ; Check first subscript value and remove if its a dangling node.
 I ZIBOS?1"MSM".E,ZIBX1="%ER" D N2 G N1Q
 D RM
N1Q ;
 Q
 ;
N2 ; Process second node if first is non-numeric or ^UTILITY("%ER" for MSM
 S ZIBX2="",ZIBA1=""""_ZIBA_""""
 F ZIBI=1:1 S ZIBRM=1,ZIBX2=$O(@(ZIBGR_""""_ZIBX1_""","""_ZIBX2_""")")) D  D:ZIBRM RM Q:ZIBX2=""
 .I ZIBOS?1"MSM".E,ZIBX1="%ER",($P($H,",")-ZIBX2)<7 S ZIBRM=0 Q
 .I ZIBX2]"" S ZIBA=ZIBA1_","""_ZIBX2_"""",ZIBJ=ZIBX2
 KILL ZIBRM
 Q
 ;
RM ; Remove dangling ^UTILITY node.
 ;   If not in active JOB table '$D(ZIBJT(ZIBJ))
 ;   Or if an active JOB and not this UCI $D(ZIBJT(ZIBJ) & ZIBJT(ZIBJ)'=$Z(0)
 ;   Or if an active JOB and this UCI, but the same $J as this JOB.
 I $D(ZIBJT(ZIBJ)),ZIBJT(ZIBJ)=$ZU(0),$J'=ZIBJ G RMQ
 KILL @(ZIBGR_ZIBA_")") ; Remove dangling ^ZUT or ^UTILITY node.
RMQ ;
 Q
 ;
OUT ;
 KILL ZIBOS,ZIBA,ZIBA1,ZIBX1,ZIBX2,ZIBST,ZIBJT,ZIBJM,ZIBJI,ZIBJ,ZIBQ,ZIBGR,ZIBSTA,ZIBMXJ,ZIBPT,ZIBK
 I $ZV?1"MSM".E V 44:$J:$ZB($V(44,$J,2),#FFFE,1):2
 Q
 ;
