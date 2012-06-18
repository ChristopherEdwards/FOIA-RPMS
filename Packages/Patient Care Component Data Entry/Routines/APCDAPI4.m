APCDAPI4 ; IHS/CMI/LAB - & HMW - PCC API FOR RPMS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ; REQUIRES PIMS VERSION 5.3 PATCH 1002
 ;
GETVISIT(APCDIN,APCDOUT) ;PEP - API for PCC visit Creation by RPMS applications
 ;
 ; >> See details in PIMS Technical Manual (released as appendix with patch 1003)
 ;    or in SAC Developers' Handbook
 ;    
 ; >> All date/time variables must be in FileMan internal format
 ;
 ; Special Incoming Variables:
 ;  APCDIN("FORCE ADD")   = 1    ; no matter what, create new visit (Optional)
 ;  APCDIN ("NEVER ADD")  = 1    ; never add visit, just try to find one or more (Optional)
 ;  APCDIN("ANCILLARY")   = 1    ; for ancillary packages to create noon visit if no match found (Optional)
 ;
 ; Incoming Variables used in Matching: REQUIRED
 ;  APCDIN("PAT")         = patient IEN (file 2 or 9000001)
 ;  APCDIN("VISIT DATE")  = visit date & time (same as check-in date & time)
 ;  APCDIN ("SITE")       = location of encounter IEN (file 4 or 9999999.06)
 ;  APCDIN("VISIT TYPE")  = internal value for field .03 in Visit file
 ;  APCDIN("SRV CAT")     = internal value for service category
 ;  APCDIN("TIME RANGE")  = #   ; range in minutes for matching on visit time; REQUIRED unless FORCE ADD set
 ;                              ;   zero=exact matches only; -1=don't match on time
 ;
 ;   These are used to match if sent (Optional)
 ;  APCDIN("PROVIDER")    = IEN for provider to match from file 200
 ;  APCDIN("CLINIC CODE") = IEN of clinic stop code (file 40.7)
 ;  APCDIN("HOS LOC")     = IEN of hospital location (file 44)
 ;
 ; Incoming Variables used in creating appt and visit
 ;  APCDIN("APPT DATE")   = appt date & time (Required for scheduled appts and walk-ins; check-in will be performed) 
 ;  APCDIN("USR")         = user IEN in file 200; REQUIRED
 ;  APCDIN("OPT")         = name for Option Used To Create field (Optional)
 ;  APCDIN("OI")          = reason for appointment; for walk-ins (Optional)
 ;
 ; Incoming PCC variables for adding additional info to visit (Optional)
 ;  APCDIN("APCDTPB")  = Third Party Billed (#.04)
 ;  APCDIN("APCDPVL")  = Parent Visit Link (#.12)
 ;  APCDIN("APCDAPPT"  = WalkIn/Appt (#.16)
 ;  APCDIN("APCDEVM")  = Evaluation and Management Code (#.17)
 ;  APCDIN("APCDCODT") = Check Out Date & Time (#.18)
 ;  APCDIN("APCDLS")   = Level of Service -PCC Form  (#.19).
 ;  APCDIN("APCDVELG") = Eligibility (#.21)
 ;  APCDIN("APCDPROT") = Protocol (#.25).
 ;  APCDIN("APCDOPT")  = Option Used To Create (#.24)  ;IHS/OIT/LJF 09/15/2005 PATCH 1004
 ;  APCDIN("APCDOLOC") = Outside Location (#2101)      ;IHS/OIT/LJF 12/21/2005 PATCH 1005
 ; Outgoing Array:
 ;  APCDOUT(0) always set; if = 0 none found and may have error message in 2nd piece
 ;                         if = 1 and APCDOUT(visit ien)="ADD" new visit just created
 ;                         if = 1 and APCDOUT(visit ien)=#; # is time difference in minutes
 ;                         if >1, multiple APCDOUT(visit ien) entries exist
 ;
 I '$L($T(VISIT^BSDV)) S APCDOUT(0)="0^PIMS version 5.3 must be installed" Q
 I '$L($T(GETVISIT^BSDAPI4)) S APCDOUT(0)="0^PIMS patch 1004 must be installed" Q
 D GETVISIT^BSDAPI4(.APCDIN,.APCDOUT)
 Q
