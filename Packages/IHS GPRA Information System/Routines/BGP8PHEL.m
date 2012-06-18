BGP8PHEL ; IHS/CMI/LAB - IHS gpra print ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
PRINT ;EP
 S BGPGPG=0
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP8ELH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP8DELP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP8ELL ;create ^tmp of delimited report
 Q
 ;
