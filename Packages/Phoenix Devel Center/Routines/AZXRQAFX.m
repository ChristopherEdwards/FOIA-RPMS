AZXRQAFX ; [ 09/28/93  11:24 AM ]
 ; Written by Lori Butcher (9/28/93)
 ;
 ; Cleans up problems with the QA (printing Top Ten List)
 ; with having bad "B" Cross-ref.s in the Visit file (^AUPNVSIT).
 S LORIV=0 F  S LORIV=$O(^AUPNVSIT(LORIV)) Q:LORIV'=+LORIV  I $P(^AUPNVSIT(LORIV,0),U)[".12.12" D
 .W !,LORIV,"  ",^AUPNVSIT(LORIV,0)
 .S NEWDATE=$P($P(^AUPNVSIT(LORIV,0),U),".")_".12",DIE="^AUPNVSIT(",DR=".01////"_NEWDATE,DA=LORIV
 .D ^DIE
 .W !,^AUPNVSIT(LORIV,0)
 .Q
 Q
