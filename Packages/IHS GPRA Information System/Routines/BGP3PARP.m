BGP3PARP ; IHS/CMI/LAB - IHS gpra print ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
PRINT ;EP
 S BGPGPG=0
 S BGPQUIT=""
 I BGPROT="D" G DEL
 D AREACP^BGP3DH
 S BGPQUIT="",BGPGPG=0,BGPRPT=0
 D PRINT1^BGP3DP
 Q:BGPQUIT
 Q:BGPROT="P"
DEL ;create delimited output file
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP3PDL ;create ^tmp of delimited report
 Q
 ;
