AQAQ228I ;;IHS/HQW/JDH;PATCH 8 INIT ROUTINE FOR KIDS INSTALL;;;[ 07/26/1999  11:20 AM ]
 ;;2.2;STAFF CREDENTIALS;**8**;01 OCT 1992
 ; delete field data, P8 will install new definition
 ; This routine only kills the DD global at node level if Kernal is
 ; running for AQAQ Kids Install.
 K:$P($G(XPDNM),"*")="AQAQ" ^DD(9002161.21,.03)
 Q
