LRHYU4 ;VA/DALOI/HOAK - GET THE LAB UID ; 13-Aug-2013 09:16 ; MKK
 ;;5.2;LAB SERVICE;**405,1033**;NOV 01, 1997
 ;
 ; Reference to ^DIC supported by DBIA #916.
 ;
 ; Get the accession number or order number or universal ID
 ;
AA ;
 ;
 I $G(LRORDSIZ) S LRORDSIZ=$L(LRORDSIZ)
 S LRACC="" D ^LRWU4
 QUIT
