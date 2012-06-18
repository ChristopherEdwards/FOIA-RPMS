AGGAGE ;VNGT/HS/ALA - Age Function calls ; 21 Apr 2010  9:50 AM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;;
 ;
AGE(D0,PDATE,QUAL) ;EP
 ; Description
 ;   This program is copied from the computed AGE field (2,.033) which
 ;   calculates the AGE of a person based on their DOB (date of birth)
 ;   and either the current date (DT) or their DOD (date of death)
 ;   
 ;   It has been modified to use another date passed into this function
 ;   instead of just the previous two dates, DT and DOD.
 ; 
 ; Input
 ;   D0    - Patient IEN
 ;   PDATE - Other date to compare patient's date of birth with
 ;   QUAL  - Include qualifier (YRS, DYS, MOS)
 ;
 ; Assumes variables U,DT
 ;
 S PDATE=$G(PDATE,""),QUAL=$G(QUAL,"")
 I $P($G(^DPT(D0,0)),U,3)="" Q ""
 Q $$AGE^AUPNPAT(D0,PDATE,QUAL)
