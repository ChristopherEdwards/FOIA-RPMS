BGP2PHEP ; IHS/CMI/LAB - IHS gpra print ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
PRINT ;EP
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 S ^TMP($J,"BGPDEL",0)=0
 S BGPPTYPE="P"
 S BGPGPG=0
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP2HEH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP2DHEP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D ^%ZISC ;close printer device
 S BGPPTYPE="D"
 K ^TMP($J)
 D ^BGP2HEL ;create ^tmp of delimited report
 Q
 ;
