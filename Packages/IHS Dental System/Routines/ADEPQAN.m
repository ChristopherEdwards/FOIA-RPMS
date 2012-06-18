ADEPQAN ; IHS/HQT/MJL - QA ENGINE NOTES ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;Main idea- Hard-code the search logic and store
 ;the hits in DIBT for printout by FM.
 ;Search Options will be:
 ;Use Template:
 ;Beginning and Ending Dates
 ;Age range
 ;Include Provider (or "*" for All)
 ;Prompt like this:
 ;ADA Code: (Comma-delimited codes. Ranges separated by dash.)
 ;    Followed by ADA Code:
 ;        Relative (date):
 ;    Preceded by ADA Code:
 ;        Relative (date):
 ;    Should these codes apply to the SAME operative site?
 ;    Should these codes apply to a PARTICULAR Operative site?
 ;ADA CODE:  ...ETC
 ;All these search criteria should be stored in an array
 ;and the engine should be callable with the array already
 ;set up so that the reports can be generated without
 ;prompting for codes, etc.
 ;Confirm selections
 ;OUTPUT:
 ;Prompt for template name
 ;Report options:  Count of Patients, visits, codes or operative sites
 ;List of patient names/chart#s/visit dates
 ;Dental summary for each hit
 ;DEVICE SELECTION
 ;Set up BY string
 ;Call EN1^DIP
