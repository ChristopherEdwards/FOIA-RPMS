PSNRPT3 ;BIR/CCH&WRT-FILEMAN PRINT TEMPLATE USED IN PSNRPT ;10/02/98 14:34
 ;;4.0; NATIONAL DRUG FILE;; 30 Oct 98
 I '$D(^PSDRUG(D0,"ND")) Q
 S HLD=D0,D0=$P(^PSDRUG(HLD,"ND"),"^"),FNM=$P(^PSDRUG(HLD,"ND"),"^",3),Y=$P(^PSNDF(50.68,FNM,0),"^",1) W ?42,"INGREDIENTS:" D INGRED1^PSNOUT
 W !!! S D0=HLD K HLD,FNM,IN Q
