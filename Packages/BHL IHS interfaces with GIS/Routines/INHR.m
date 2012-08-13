INHR ;JSH; 22 Dec 93 16:42;Interface - Misc. Reports
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
STATUS ;Message Statistics by status
 N:'$D(ZTSK) %DT,INSD,INED,ZTSK
 D DATES Q:(INSD<0)!(INED<0)
 S ZTRTN="STATZTSK^INHR" D QUEUE Q:$D(ZTSK)  D WAIT^DICD
STATZTSK ;TaskMan entry point to print message stats by status
 N:'$D(ZTSK) INCNT,S,I,INHD,INI,DUOUT,PAGE
 S I=INSD-.0000001,TYPE="STATUS"
 F  S I=$O(^INTHU("B",I)) Q:'I  Q:I>INED  S X=0 F  S X=$O(^INTHU("B",I,X)) Q:'X  S S=$P(^INTHU(X,0),U,3) S:S]"" INCNT(S)=$G(INCNT(S))+1
 S INHD(1)="  Status                          Count"
 W:'$D(ZTSK) @IOF D HEAD
 S C=$P(^DD(4001,.03,0),U,2)
 S INI="" F  S INI=$O(INCNT(INI)) Q:INI=""  S Y=INI D Y^DIQ W !?3,Y,?35,INCNT(INI)
 K:$D(ZTSK) ^%ZTSK(ZTSK)
 Q
 ;
DEST ;Message statistics by destination
 N %DT,INSD,INED,ZTSK
 D DATES Q:(INSD<0)!(INED<0)
 S ZTRTN="DESTZTSK^INHR" D QUEUE Q:$D(ZTSK)  D WAIT^DICD
DESTZTSK ;TaskMan entry point to print message stats by destination
 N:'$D(ZTSK) INCNT,S,I,INHD,INI,DUOUT,PAGE
 S I=INSD-.0000001,TYPE="DESTINATION"
 F  S I=$O(^INTHU("B",I)) Q:'I  Q:I>INED  S X=0 F  S X=$O(^INTHU("B",I,X)) Q:'X  S S=$P(^INTHU(X,0),U,2) S:S]"" INCNT(S)=$G(INCNT(S))+1
 S INHD(1)="  Destination                                  Count"
 W:'$D(ZTSK) @IOF D HEAD
 S INI="" F  S INI=$O(INCNT(INI)) Q:'INI  D  Q:$G(DUOUT)
 . I $Y+3>IOSL D HEAD Q:$G(DUOUT)
 . W !?3,$E($P($G(^INRHD(INI,0)),U),1,40),?48,INCNT(INI)
 K:$D(ZTSK) ^%ZTSK(ZTSK)
 Q
 ;
DSTAT ;Message statistics by destination/status
 N:'$D(ZTSK) %DT,INSD,INED,ZTSK
 D DATES Q:(INSD<0)!(INED<0)
 S ZTRTN="DSZTSK^INHR" D QUEUE Q:$D(ZTSK)  D WAIT^DICD
DSZTSK ;TaskMan entry point to print message stats by destination/status
 N:'$D(ZTSK) INCNT,S1,S2,I,INHD,IND,INS,TOTAL,DEST,DUOUT,PAGE
 S I=INSD-.0000001,TYPE="DESTINATION/STATUS"
 F  S I=$O(^INTHU("B",I)) Q:'I  Q:I>INED  S X=0 F  S X=$O(^INTHU("B",I,X)) Q:'X  S S=$P(^INTHU(X,0),U,2,3) S:S?1.N1"^"1.E INCNT(+S,$P(S,U,2))=$G(INCNT(+S,$P(S,U,2)))+1
 S INHD(1)="  Destination                     Status                              Count"
 W:'$D(ZTSK) @IOF D HEAD
 S IND="" F  S IND=$O(INCNT(IND)) Q:'IND  D  Q:$G(DUOUT)
 . I $Y+3>IOSL D HEAD Q:$G(DUOUT)
 . S (D,TOTAL)=0,DEST=$E($P($G(^INRHD(IND,0)),U),1,30) W !?3,DEST
 . S INS="" F  S INS=$O(INCNT(IND,INS)) Q:INS=""  D  Q:$G(DUOUT)
 .. I $Y+3>IOSL D HEAD Q:$G(DUOUT)  W !?3,DEST S D=0
 .. S C=$P(^DD(4001,.03,0),U,2),Y=INS D Y^DIQ W:D ! W ?35,$E(Y,1,30),?71,INCNT(IND,INS) S TOTAL=TOTAL+INCNT(IND,INS),D=1
 . I $Y+4>IOSL D HEAD Q:$G(DUOUT)  W !?3,DEST
 . W !?70,"-----",!?63,"Total:",?71,TOTAL
 K:$D(ZTSK) ^%ZTSK(ZTSK)
 Q
 ;
HEAD ;Header
 N L,I,X,Y
 K DUOUT S PAGE=+$G(PAGE)
 I IO=IO(0),'$D(ZTSK),$E(IOST,1,2)="C-",PAGE W !,*7 R X:DTIME S:$E(X)=U DUOUT=1
 Q:$G(DUOUT)
 W:PAGE @IOF S PAGE=PAGE+1
 S L="Interface Message Statics by "_TYPE S Y=INSD D DD^%DT S INSD(1)=Y,Y=INED D DD^%DT S INED(1)=Y
 W !?(40-($L(L)\2)),L
 S L="Period: "_INSD(1)_" - "_INED(1) W !?(40-($L(L)\2)),L,?(IOM-10),"Page: ",PAGE
 I $D(INHD)>9 W ! F I=1:1 Q:'$D(INHD(I))  W !,INHD(I)
 W ! K Z S $P(Z,"-",IOM+1)="" W Z
 Q
 ;
QUEUE ;Select device for output and queue if necessary
 K IOP D ^%ZIS Q:POP  S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 Q:IO=IO(0)
 S ZTIO=IOP
 F I="INSD","INED" S ZTSAVE(I)=""
 D ^%ZTLOAD W !?5,"Request "_$S($D(ZTSK):"",1:"NOT ")_"QUEUED!" Q
 ;
DATES ;Get start/end dates (with time)
 S %DT("A")="START of Period: ",%DT="ATE" D ^%DT S INSD=+Y I INSD<0 S INED=-1 Q
 S %DT("A")="END of Period: ",%DT="ATE",%DT("B")="NOW" D ^%DT S INED=+Y
 S:INED\1=INED INED=INED+.999999
 Q
