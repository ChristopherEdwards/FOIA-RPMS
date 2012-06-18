BGP9PHEP ; IHS/CMI/LAB - IHS gpra print ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
PRINT ;EP
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 S BGPGPG=0
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP9HEH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP9DHEP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP9HEL ;create ^tmp of delimited report
 Q
 ;
