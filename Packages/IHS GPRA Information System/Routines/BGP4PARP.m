BGP4PARP ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
PRINT ;EP
 S BGPGPG=0
 S BGPQUIT=""
 D SETEXCEL^BGP4DP
 I BGPROT="D" G DEL
 D AREACP^BGP4DH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP4DP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP4PDL ;create ^tmp of delimited report
 Q
 ;
