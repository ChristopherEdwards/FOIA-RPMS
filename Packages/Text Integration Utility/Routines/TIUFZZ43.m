TIUFZZ43 ; SLC/MAM - Post Patch TIU*1*43 Cleanup.  Fixes entries in  TIU DOCUMENT DEFINITION FILE whose Menu Text is bad ;8/27/97  14:02
 ;;1.0;TEXT INTEGRATION UTILITIES;**43**;Jun 20, 1997
 ;
WRITE ; Fix Docmt Defs w/ bad Menu Text
 S %ZIS="Q" D ^%ZIS I POP G WRITX
 I '$D(IO("Q")) G WRITE1
 S ZTRTN="WRITE1^TIUFZZ43",ZTDESC="TIU Document Definitions with Bad Menu Text"
 D ^%ZTLOAD G WRITX
 ;
WRITE1 N FILEDA,PFILEDA,IFILEDA,MTXT,DA,NMTXT,ALLOK
 U IO
 W !!!,"    *** TIU Document Definitions with Bad Menu Text or No Menu Text ***",!
 S FILEDA=0,ALLOK=1
 F  S FILEDA=$O(^TIU(8925.1,"AD",FILEDA)) Q:'FILEDA  D
 . S PFILEDA=$O(^TIU(8925.1,"AD",FILEDA,0)) Q:'PFILEDA
 . S IFILEDA=$O(^TIU(8925.1,"AD",FILEDA,PFILEDA,0)) Q:'IFILEDA
 . S DA=IFILEDA,DA(1)=PFILEDA
 . I $$MTXTOK^TIUFT1(.DA,.MTXT) Q
 . S ALLOK=0 I MTXT="NOTEN" D  Q
 . . W !!,"Cross Reference shows entry ",FILEDA," as item ",IFILEDA," under parent ",PFILEDA,": "
 . . W !,"     ^TIU(8925.1,""AD"",",FILEDA,",",PFILEDA,",",IFILEDA,"),"
 . . W !,"  but ",IFILEDA," does not exist under parent ",PFILEDA,":"
 . . W !,"      ^TIU(8925.1,",PFILEDA,",10,",IFILEDA,",0) is missing."
 . . W !,"  Please check this out with IRM.",!
 . W !!,"Entry ",FILEDA," has menu text ",?40,$S(MTXT="":"none",1:MTXT),".",?65,"Parent: ",PFILEDA
 . L +^TIU(8925.1,PFILEDA,10):1 I '$T W !,"Can't lock entry.  Please edit Menu Text manually or rerun this option later.",! Q
 . D MTXTCHEC^TIUFT1(.DA,FILEDA,1,.MTXT,.NMTXT)
 . I NMTXT="NOENTRY" D  Q
 . . W !,"Cross Reference shows entry ",FILEDA," as an item under ",PFILEDA,": "
 . . W !,"     ^TIU(8925.1,""AD"",",FILEDA,",",PFILEDA,"),"
 . . W !,"  but ",FILEDA," does not exist: "
 . . W !,"     ^TIU(8925.1,",FILEDA,",0) is missing."
 . . W !,"  Please check this out with IRM.",!
 . W !,"Changing menu text to ",?40,NMTXT,"."
 . L -^TIU(8925.1,PFILEDA,10)
 I ALLOK W !!,"No entries found with bad Menu Text or no Menu Text.",! G WRITX
 W !!,"To edit Menu Text, select 'Detailed Display' for the PARENT, and then select",!,"action 'Items'.",!
WRITX D ^%ZISC,HOME^%ZIS
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
