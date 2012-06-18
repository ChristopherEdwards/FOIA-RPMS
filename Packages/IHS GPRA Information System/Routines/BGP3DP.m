BGP3DP ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
PRINT ;
 I BGPROT="D" G DEL
 D ^BGP3DH
 S BGPGPG=0
 S BGPQUIT=""
 D PRINT1
 Q:BGPROT="P"
 ;
DEL ;create delimited output file
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP3PDL ;create ^tmp of delimited report
 K ^XTMP("BGP3D",BGPJ,BGPH)
 ;call xbgsave to write out tmp
 Q
 ;
PRINT1 ;EP
 S BGPIC=0 F  S BGPIC=$O(BGPIND(BGPIC)) Q:BGPIC=""!(BGPQUIT)  D
 .D HEADER^BGP3DPH ;header for all indicators
 .;now print individual indicator
 .;print page 1 header
 .S BGPNODE=$S(BGPRTYPE=4:52,BGPRTYPE=1:54,BGPRTYPE=2:55,1:""),BGPX=0 F  S BGPX=$O(^BGPIND(BGPIC,BGPNODE,BGPX)) Q:BGPX'=+BGPX  D
 ..I $Y>(IOSL-3) D HEADER^BGP3DPH Q:BGPQUIT
 ..W !,^BGPIND(BGPIC,BGPNODE,BGPX,0)
 .X ^BGPIND(BGPIC,3)
 D ^BGP3DS
 D EXIT
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
