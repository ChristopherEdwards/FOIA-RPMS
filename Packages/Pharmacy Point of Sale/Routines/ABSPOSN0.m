ABSPOSN0 ; IHS/FCS/DRS - NCPDP forms ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; Routines ABSPOSN1-ABSPOSN8 are included in the kit.
 ; They are for printing NCPDP forms with the ILC A/R package.
 ; The ABSB NCPDP xxxxx   options are not included in the kit.
 ;  They still point to the ABSBNRX* routines.
 ; Long term goal: replace the ABSBNRX* routines 
 ;  with these ABSPOSN* routines and try to decouple them from
 ;  the A/R structures as much as possible.
 ; 
 ; ABSPOSNC  is not an NCPDP form routine,
 ; though it happens to be in this same namespace.
 ; "NC" stands for "Nightly Checker", the ANMC process which
 ; first inspired the need for an external query of POS status
 ; given a V MEDICATION pointer.
