BLRSPRSE ; IHS/DIR/FJE - SPECIAL PARSING FOR VARIOUS MODULES ; [ 04/13/98  1:11 PM ]
 ;;5.2;BLR;**1001**;FEB 1, 1998
 ;
 ; subroutine is called by BLRLINK1
 ;
 ; parsing of data elements from disk into local arrays and variables
 ; BLRVAL = array containing elements of ^BLRTXLOG (file # 9009022)
 ;
 S:BLRSS="MI" BLRVAL(13)=$G(^BLRTXLOG(BLRLOGDA,13))
 S:BLRSS="BB" BLRVAL(14)=$G(^BLRTXLOG(BLRLOGDA,14))
 F T=1:1 S TEXTSTR=$T(@BLRSS+T) S BLRSTR=$P(TEXTSTR,";",3) Q:BLRSTR=""  S NAME=$P(BLRSTR,"|"),INDX=$P(BLRSTR,"|",2),FLD=$P(BLRSTR,"|",3),@NAME=$P(BLRVAL(INDX),U,FLD)
 Q
 ;
PARSE ;;variable reference|subscript of BLRVAL array|field or piece in BLRVAL string
MI ; MICRO
 ;;BLRORG|13|1;; organism ien
 ;;BLRORGN|13|2;; organism name
 ;;BLRANT|13|3;; antibiotic ien
 ;;BLRANTN|13|4;; antibiotic name
 ;;BLRSTAGE|13|5;; stage counter...number of stages in a parasite
 ;;BLRCOLSP|13|7;; collection sample ien  ;IHS/DIR TUC/AAB 04/08/98
 ;;BLRCOMPD|13|9;; complete date  ;IHS/DIR TUC/AAB 04/08/98
 ;
BB ; BLOOD BANK
 ;;BLRBTN|14|2;; blood bank test name
 ;;BLRANT|14|3;; antibody ien
 ;;BLRANTN|14|4;; antibody name
 ;
 Q
