BGP4PHEP ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
PRINT ;EP
 S BGPGPG=0
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP4HEH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP4DHEP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP4HEL ;create ^tmp of delimited report
 Q
 ;
