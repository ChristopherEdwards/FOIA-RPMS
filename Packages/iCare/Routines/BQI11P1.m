BQI11P1 ;VNGT/HS/ALA-iCare Version 1.1 Patch 1 Post-Install ; 20 Jun 2008  10:14 AM
 ;;1.1;ICARE MANAGEMENT SYSTEM;**1**;Jul 08, 2008
 ;
EN ;
 ; Check for CRS Patch install
 I $$PATCH^XPDUTL("BGP*8.0*2") D GCHK^BQIGPUPD()
 ;
 Q
