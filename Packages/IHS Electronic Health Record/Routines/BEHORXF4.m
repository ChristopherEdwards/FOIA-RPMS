BEHORXF4 ;MSC/IND/PLS - Support for EHR continued;07-Jul-2015 20:01;DU
 ;;1.1;BEH COMPONENTS;**009013**;Sep 18, 2007;Build 1
 ;=================================================================
 ; RPC: BEHORXF4 ERXCANCP
 ; Returns boolean value (0/1) of the following condition
 ;    A true value will cause the RPMS EHR order cancel process to
 ;    confirm that the user wishes to cancel an eRX order.
 ;      Prescription has been transmitted and last activity is not
 ; Input: OIEN - Order IEN
ERXCANCP(DATA,OIEN) ;EP-
 N RXIEN
 S RXIEN=+$$GETPSIFN^BEHORXFN(OIEN)
 S DATA=$$CKRXACT^APSPFNC6(RXIEN,"X","T")&($$LASTACT^APSPFNC6(RXIEN,"X")'="F")
 Q
