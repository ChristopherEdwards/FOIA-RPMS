INSY185 ;slt;19 Aug 1994@090351;compiled gis system data
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
EN F I=1:2 S %ODD=$E($T(EN+I),4,999) Q:%ODD=""  S %EVEN=$E($T(EN+(I+1)),4,999) S X="^UTILITY(""INHSYS"","_$J_","_$P(%ODD,",",2,99),@X=%EVEN
 ;;^UTILITY(562037788,"SGF",253,1,1,0)
 ;;Date/time results reported or status changed.
 ;;^UTILITY(562037788,"SGF",253,1,2,0)
 ;;Cancel/modified orders - Status change date/time
 ;;^UTILITY(562037788,"SGF",253,1,3,0)
 ;;Results reports - reporting date/time
 ;;^UTILITY(562037788,"SGF",253,"C")
 ;;@EFFDATE
 ;;^UTILITY(562037788,"SGF",256,0)
 ;;HL RESULT STATUS^CODED ID^1
 ;;^UTILITY(562037788,"SGF",256,1,0)
 ;;12^^12^12^2940216
 ;;^UTILITY(562037788,"SGF",256,1,1,0)
 ;;Status of results for the order.  Completed by filler of the order.
 ;;^UTILITY(562037788,"SGF",256,1,2,0)
 ;;  
 ;;^UTILITY(562037788,"SGF",256,1,3,0)
 ;;   O - Order received, specimen not yet received (Unacknowledged)
 ;;^UTILITY(562037788,"SGF",256,1,4,0)
 ;;   I - No results, specimen received, procedure incomplete (Pending)
 ;;^UTILITY(562037788,"SGF",256,1,5,0)
 ;;   S - No results, procedure scheduled but not done (Scheduled - RAD)
 ;;^UTILITY(562037788,"SGF",256,1,6,0)
 ;;   P - Preliminary, final results not available (Intermediate)
 ;;^UTILITY(562037788,"SGF",256,1,7,0)
 ;;   C - Correction to results (Amended)
 ;;^UTILITY(562037788,"SGF",256,1,8,0)
 ;;   R - Results stored, not yet verified (Uncertified)
 ;;^UTILITY(562037788,"SGF",256,1,9,0)
 ;;   F - Final results, order is complete and verified (Complete, Certified)
 ;;^UTILITY(562037788,"SGF",256,1,10,0)
 ;;   X - No results available, Order Canceled (Lab Cancelled)
 ;;^UTILITY(562037788,"SGF",256,1,11,0)
 ;;   
 ;;^UTILITY(562037788,"SGF",256,1,12,0)
 ;;   
 ;;^UTILITY(562037788,"SGF",256,"C")
 ;;@RESULT
 ;;^UTILITY(562037788,"SGF",260,0)
 ;;HL TRANSPORTATION MODE^STRING^20
 ;;^UTILITY(562037788,"SGF",260,1,0)
 ;;6^^6^6^2940216
 ;;^UTILITY(562037788,"SGF",260,1,1,0)
 ;;Mobility Status - Rad Orders Only
 ;;^UTILITY(562037788,"SGF",260,1,2,0)
 ;;  
 ;;^UTILITY(562037788,"SGF",260,1,3,0)
 ;;  WALK - Ambulatory
 ;;^UTILITY(562037788,"SGF",260,1,4,0)
 ;;  WHLC - Wheelchair
 ;;^UTILITY(562037788,"SGF",260,1,5,0)
 ;;  CART - Stretcher/Crib/Bassinette
 ;;^UTILITY(562037788,"SGF",260,1,6,0)
 ;;  PORT - Portable  (101;130.02)
 ;;^UTILITY(562037788,"SGF",260,"C")
 ;;@ORTM
 ;;^UTILITY(562037788,"SGF",262,0)
 ;;HL PRINC RESULT INTERP.^COMPOSITE PERSON NAME SPECIAL^60
 ;;^UTILITY(562037788,"SGF",262,1,0)
 ;;4^^4^4^2940329
 ;;^UTILITY(562037788,"SGF",262,1,1,0)
 ;;Identifies the user/person who interpreted the results.
 ;;^UTILITY(562037788,"SGF",262,1,2,0)
 ;;  
 ;;^UTILITY(562037788,"SGF",262,1,3,0)
 ;;Lab Orders : Lab tech. or Pathologist
 ;;^UTILITY(562037788,"SGF",262,1,4,0)
 ;;Rad Orders : Supervising Radiologist
 ;;^UTILITY(562037788,"SGF",262,50)
 ;;
 ;;^UTILITY(562037788,"SGF",262,"C")
 ;;@SUPV
 ;;^UTILITY(562037788,"SGF",263,0)
 ;;HL ASST RES INTERP.^COMPOSITE PERSON NAME SPECIAL^60
 ;;^UTILITY(562037788,"SGF",263,1,0)
 ;;1^^1^1^2940329
 ;;^UTILITY(562037788,"SGF",263,1,1,0)
 ;;Result reports only.  Interpreting radiologist or Pathologist
 ;;^UTILITY(562037788,"SGF",263,50)
 ;;
 ;;^UTILITY(562037788,"SGF",263,"C")
 ;;@INTERP
 ;;^UTILITY(562037788,"SGF",264,0)
 ;;HL TECHNICIAN^COMPOSITE PERSON NAME SPECIAL^60
 ;;^UTILITY(562037788,"SGF",264,1,0)
 ;;1^^1^1^2940311
 ;;^UTILITY(562037788,"SGF",264,1,1,0)
 ;;Radiology performing technician or lab technician
 ;;^UTILITY(562037788,"SGF",264,50)
 ;;
 ;;^UTILITY(562037788,"SGF",264,"C")
 ;;@TECH
 ;;^UTILITY(562037788,"SGF",265,0)
 ;;HL TRANSCRIPTIONIST^COMPOSITE PERSON NAME SPECIAL^60
 ;;^UTILITY(562037788,"SGF",265,1,0)
 ;;1^^1^1^2940216
 ;;^UTILITY(562037788,"SGF",265,1,1,0)
 ;;Transcriptionist for radiology and pathology reports.
 ;;^UTILITY(562037788,"SGF",265,50)
 ;;
 ;;^UTILITY(562037788,"SGF",265,"C")
 ;;@TRANSC
 ;;^UTILITY(562037788,"SGF",267,0)
 ;;HL SET ID - OBSERVATION^SET ID^4
 ;;^UTILITY(562037788,"SGF",267,1,0)
 ;;1^^1^1^2940216
 ;;^UTILITY(562037788,"SGF",267,1,1,0)
 ;;Sequential number for OBX segments
 ;;^UTILITY(562037788,"SGF",267,"C")
 ;;"OBX"
 ;;^UTILITY(562037788,"SGF",278,0)
 ;;HL RAD PROCEDURE^CODED ELEMENT^75
 ;;^UTILITY(562037788,"SGF",278,1,0)
 ;;^^2^2^2940310
 ;;^UTILITY(562037788,"SGF",278,1,1,0)
 ;;Radiology procedure internal entry number and name from the Radiology Exam
 ;;^UTILITY(562037788,"SGF",278,1,2,0)
 ;;file (#70.5)
 ;;^UTILITY(562037788,"SGF",278,50)
 ;;RADIOLOGY PROCEDURE
 ;;^UTILITY(562037788,"SGF",278,"C")
 ;;INTERNAL(#.03)_";71"
 ;;^UTILITY(562037788,"SGF",280,0)
 ;;HL RAD RELEVANT CLIN. INFO.^STRING^300
 ;;^UTILITY(562037788,"SGF",280,1,0)
 ;;2^^2^2^2940310
 ;;^UTILITY(562037788,"SGF",280,1,1,0)
 ;;Order Comment.  Navigation occurs through the Radiology Exam file Order IEN
 ;;^UTILITY(562037788,"SGF",280,1,2,0)
 ;;field.
 ;;^UTILITY(562037788,"SGF",280,"C")
 ;;#8609.12:#.1
 ;;^UTILITY(562037788,"SGF",283,0)
 ;;HL RAD DIAGNOSTIC SERV SECT^COMPOSITE ID NUMBER AND NAME^75
 ;;^UTILITY(562037788,"SGF",283,1,0)
 ;;1^^1^1^2940310
 ;;^UTILITY(562037788,"SGF",283,1,1,0)
 ;;Radiology Exam file radiology location.
 ;;^UTILITY(562037788,"SGF",283,50)
 ;;HOSPITAL LOCATION
 ;;^UTILITY(562037788,"SGF",283,"C")
 ;;#.15:#.01
 ;;^UTILITY(562037788,"SGF",285,0)
 ;;HL RAD ORDERING PROVIDER^COMPOSITE PERSON NAME^60
 ;;^UTILITY(562037788,"SGF",285,1,0)
 ;;1^^1^1^2940311
 ;;^UTILITY(562037788,"SGF",285,1,1,0)
 ;;Requesting HCP from the Radiology Exam file.
 ;;^UTILITY(562037788,"SGF",285,50)
 ;;PROVIDER
 ;;^UTILITY(562037788,"SGF",285,"C")
 ;;#.08
 ;;^UTILITY(562037788,"SGF",288,0)
 ;;HL RAD ORDER NUMBER^COMPOSITE^60
 ;;^UTILITY(562037788,"SGF",288,1,0)
 ;;1^^1^1^2940314
 ;;^UTILITY(562037788,"SGF",288,1,1,0)
 ;;Order number associated with the radiology exam
 ;;^UTILITY(562037788,"SGF",288,"C")
 ;;#8609.11
 ;;^UTILITY(562037788,"SGF",289,0)
 ;;HL RAD EXAM NUMBER^COMPOSITE^60
 ;;^UTILITY(562037788,"SGF",289,1,0)
 ;;1^^1^1^2940314
 ;;^UTILITY(562037788,"SGF",289,1,1,0)
 ;;Radiology exam number
 ;;^UTILITY(562037788,"SGF",289,"C")
 ;;#.01
 Q
