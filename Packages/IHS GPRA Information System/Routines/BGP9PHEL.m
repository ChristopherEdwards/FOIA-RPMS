BGP9PHEL ; IHS/CMI/LAB - IHS gpra print ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
PRINT ;EP
 S BGPGPG=0
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP9ELH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP9DELP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP9ELL ;create ^tmp of delimited report
 Q
 ;
