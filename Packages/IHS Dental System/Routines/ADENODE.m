ADENODE ; IHS/HQT/MJL  - RESET PATIENT UPDATE FLAG ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;IHS/HMW 5-5-92 Now checks ADEPOST & returns message if unposted data
 ;exists in the queue.
 ;------->INIT
 S U="^"
 ;------->LOOKUP PT
 S DIC="^AUPNPAT(",DIC(0)="AEMQZ" D ^DIC G:Y<1 END S ADEPAT=+Y
 ;------->CHECK FOR VISITS QUEUED IN ^ADEPOST
 S ADEFLG=0
 I $D(^ADEPOST(0)) D KILLQ
 I ADEFLG W !,"CANNOT UNLOCK PATIENT DENTAL RECORD:  Patient has unposted data in the",!,"background queue.  Contact site manager for assistance." G END
 ;
 ;------->KILL FLAG AND QUIT
 K ^ADEUTL("ADELOCK",ADEPAT)
 W !,"RESET!"
END K ADEFLG,ADEPAT Q
KILLQ S K=0 F J=0:0 S K=$O(^ADEPOST(K)) Q:'+K  I $P(^ADEPOST(K),U,3)=ADEPAT S ADEFLG=1
 Q
