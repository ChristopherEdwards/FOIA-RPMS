BGP8PHEP ; IHS/CMI/LAB - IHS gpra print ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
PRINT ;EP
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 S BGPGPG=0
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP8HEH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP8DHEP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP8HEL ;create ^tmp of delimited report
 Q
 ;
