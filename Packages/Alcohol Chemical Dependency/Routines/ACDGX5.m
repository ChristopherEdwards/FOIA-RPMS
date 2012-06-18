ACDGX5 ;IHS/ADC/EDE/KML - SAVE ACDVTMP TO UNIX/DOS FILE;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
EN ;EP
 K ACDTIME
 D ^XBKVAR,NOW^%DTC
 ;S XBDT=%I(1)_"/"_%I(2)_"/"_$E(%I(3),2,3)
 S XBDT=DT
 S XBTLE=$$FMTE^XLFDT(ACDDTF)_" thru "_$$FMTE^XLFDT(ACDDTT)_" @"
V ;
 I '$D(ACDTIME) S ACDTIME=DTIME,DTIME=9000000000
 K XBMED
 ;
 ;Check for extract data found
 ;S 1=1
 I '$D(^ACDVTMP),'$D(^ACDPTMP) W !!,"No new data found to extract....." Q
 ;
 ;
 W !!,"Saving Data now....."
 S XBMED="F"
 D ^XBGSAVE
 ;I XBFLG W !!,*7,"Up Arrow not allowed." G V
 ;S DTIME=ACDTIME
 S DTIME=$$DTIME^XUP(DUZ)
 K XBMED,ACDTIME
 Q
