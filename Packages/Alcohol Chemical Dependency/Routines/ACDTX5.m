ACDTX5 ;IHS/ADC/EDE/KML - SAVE ACDGTMP TO UNIX/DOS FILE; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 K ACDTIME
 D ^XBKVAR,NOW^%DTC
 ;S XBDT=%I(1)_"/"_%I(2)_"/"_$E(%I(3),2,3)
 S XBDT=DT
V ;
 I '$D(ACDTIME) S ACDTIME=DTIME,DTIME=9000000000
 K XBMED
 ;
 ;Check for extract data found
 I '$D(^ACDGTMP) W !!,"No new data found to extract....." Q
 ;
 ;Set up 0 node of extract now that we know there was data found
 S $P(^ACDGTMP(0),U)=ACDFR,$P(^(0),U,2)=ACDTO
 ;
 W !!,"Saving Data now....."
 S XBMED="F"
 S XBGL="ACDGTMP"
 D ^XBGSAVE
 ;I XBFLG W !!,*7,"Up Arrow not allowed." G V
 S DTIME=ACDTIME
 K XBMED,ACDTIME
 K ^ACDGTMP ;         kill of scratch global  SAC EXEMPTION (2.3.2.3  killing of unsubscripted globals is prohibited)
 Q
 ;
PGM ;EP - PGM data (1 time a year send)
 ;I '$D(ACDTIME) S ACDTIME=DTIME,DTIME=9000000000
 ;K XBMED
 ;I '$D(^ACDPDATA) W !,"*** No new data to extract from file *** " Q
 ;I ^%ZOSF("OS")["UNIX"!(^%ZOSF("OS")["PC") S XBMED="F"
 ;D ^XBKVAR,NOW^%DTC
 ;S XBDT=%I(1)_"/"_%I(2)_"/"_$E(%I(3),2,3)
 ;S XBGL="ACDPDATA"
 ;D ^XBGSAVE
 ;I XBFLG W !!,*7,"Up Arrow Not Allowed." G PGM
 ;S DTIME=ACDTIME
 ;K XBMED,^ACDPDATA,ACDTIME
