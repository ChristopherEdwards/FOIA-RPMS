TIUCP ;SLC/RMO - Clinical Procedures API(s) and RPC(s) ;12/18/00@10:54:20
 ;;1.0;TEXT INTEGRATION UTILITIES;**109**;Jun 20, 1997
 ;
CLASS() ;Get the CLINICAL PROCEDURES TIU Document Definition file (#8925.1) IEN
 ; Input  -- None    
 ; Output -- TIU Document Definition file (#8925.1) IEN
 N Y
 S Y=+$O(^TIU(8925.1,"B","CLINICAL PROCEDURES",0))
 Q Y
 ;
ISCP(TIUY,TITLE) ;RPC that evaluates whether or not a Title is under
 ;the CLINICAL PROCEDURES Class 
 ; Input  -- TITLE    TIU Document Definition file (#8925.1) IEN
 ; Output -- TIUY     1=True and 0=False
 N TIUCLASS
 ;
 ;Exit if a Title is not defined
 I +$G(TITLE)'>0 S TIUY=0 G ISCPQ
 ;
 ;Get CLINICAL PROCEDURES TIU Document Definition file (#8925.1) IEN
 S TIUCLASS=+$$CLASS
 ;
 ;Exit if the CLINICAL PROCEDURES Class is not found
 I +TIUCLASS'>0 S TIUY=0 G ISCPQ
 ;
 ;Check if the Title is under the CLINICAL PROCEDURES Class
 S TIUY=+$$ISA^TIULX(TITLE,TIUCLASS)
ISCPQ Q
 ;
CPCLASS(Y) ;RPC that gets the CLINICAL PROCEDURES TIU Document
 ;Definition file (#8925.1) IEN
 ; Input  -- None
 ; Output -- Y        TIU Document Definition file (#8925.1) IEN
 S Y=$$CLASS
 Q
 ;
LNGCP(Y,FROM,DIR) ;RPC that serves data to a longlist of selectable Titles
 ; Input  -- FROM     Reference Title from which the longlist is
 ;                    scrolling
 ;           DIR      Direction from which the longlist is scrolling
 ;                    from the reference Title  (Optional- default 1)
 ; Output -- Y        An array of the 44 nearest Titles to that indicated
 ;                    by the user in the direction passed by the longlist
 ;                    component
 N TIUCLASS
 ;
 ;Exit if a reference Title is not defined
 I '$D(FROM) G LNGCPQ
 ;
 ;Get CLINICAL PROCEDURES TIU Document Definition file (#8925.1) IEN
 S TIUCLASS=+$$CLASS
 ;
 ;Exit if the CLINICAL PROCEDURES Class is not found
 I +TIUCLASS'>0 G LNGCPQ
 ;
 ;Get the longlist of Titles for the CLINICAL PROCEDURES Class
 D LONGLIST^TIUSRVD(.Y,TIUCLASS,FROM,$G(DIR,1))
LNGCPQ Q
