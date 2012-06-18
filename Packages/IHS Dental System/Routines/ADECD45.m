ADECD45 ; IHS/SET/HMW - DENTAL EDIT TABLE UPDATE (CDT4) ;
 ;;6.0;ADE;**12,14**;MAR 25, 1999
 ;
 ;IHS/SET/HMW 4-14-2003 **14** Removed entry for 9220 code
 ;
 ;Remove and replace all DENTAL EDIT entries.
 ;
 ;Remove existing entries
 N DA,DIK
 S DIK="^ADEDIT("
 S DA=0 F  S DA=$O(^ADEDIT(DA)) Q:'+DA  D ^DIK
 ;
 ;Manually kill Mumps X-REF nodes
 K ^ADEDIT("AC"),^ADEDIT("AD")
 ;
 ;Add current entries
 ;
 N ADEGRP,ADECNT
 S ADECNT=0
 F  S ADECNT=ADECNT+1,ADEGRP=$P($T(EDITS+ADECNT),";",3,99) Q:ADEGRP=""  D
 . D ADDGRP($P(ADEGRP,U),$P(ADEGRP,U,2),$P(ADEGRP,U,3),$P(ADEGRP,U,4),$P(ADEGRP,U,5),$P(ADEGRP,U,6),$P(ADEGRP,U,7),$P(ADEGRP,U,8),$P(ADEGRP,U,9),$P(ADEGRP,U,10))
 Q
 ;
ADDGRP(ADECOD,ADETYPE,ADEOPSP,ADECONF,ADETIME,ADERTYPE,ADERCODE,ADEAGE,ADERMSG,ADEOPSPR) ;
 ;
 N ADEIEN,ADEFDA
 S ADEIEN="+1,"
 S ADEFDA(9002007.9,"+1,",.01)=ADECOD
 S ADEFDA(9002007.9,"+1,",1)=ADETYPE ;EDIT TYPE
 S ADEFDA(9002007.9,"+1,",1.3)=ADEOPSP ;OPSITE SPECIFIC
 S ADEFDA(9002007.9,"+1,",2)=ADECONF ;CONFLICT CODE
 S ADEFDA(9002007.9,"+1,",3)=ADETIME ;EDIT TIME
 S ADEFDA(9002007.9,"+1,",4)=ADERTYPE ;RESOLUTION TYPE
 S ADEFDA(9002007.9,"+1,",5)=ADERCODE
 S ADEFDA(9002007.9,"+1,",2.4)=ADEAGE
 S ADEFDA(9002007.9,"+1,",6)=ADERMSG
 S ADEFDA(9002007.9,"+1,",4.1)=ADEOPSPR ;OPSITES PERMITTED
 D UPDATE^DIE("","ADEFDA","ADEIEN")
 Q
 ;
EDITS ;CODE^TYPE^OPSITE SPECIFIC^CONFLICT CODE^EDIT TIME^RES TYPE^RES CODE^AGE^RESMSG^ADEOPSPR
 ;;1350^4^y^^^2^1351^^W *7,"This code cannot be used for permanent molars"^
 ;;1355^2^y^1355^1800;2^3^^^W *7,"UNREPORTABLE: This tooth has already had 2 reseals in pst 5 years."
 ;;1355^4^y^^^1^^^W *7,"This code is only used for PERMANENT MOLARS"^[PERMANENT MOLARS
 ;;[QUADRANT PROCEDURES^4^y^^^1^^^W *7,"Only QUADRANTS may be reported for this code"^[QUADRANTS
 ;;9221^4^y^^^1^^^W *7,"A 15 minute increment of general anesthesia, intravenous sedation, or behavior management."^[INCREMENTS
 ;;9242^4^y^^^1^^^W *7,"A 15 minute increment of general anesthesia, intravenous sedation, or behavior management."^[INCREMENTS
 ;;IH70^2^^IH70^FY|1^1^^^W *7,"This patient has already been assessed during this fiscal year"
 ;;IH71^2^^IH71^FY|1^1^^^W *7,"This patient already has a IH71 code during this fiscal year"
 ;;IH72^2^^IH72^FY|1^1^^^W *7,"This patient already has a IH72 code during this fiscal year"
 ;;IH73^2^^IH73^FY|1^1^^^W *7,"This patient already has a IH73 code during this fiscal year"
 ;;IH74^2^^IH74^FY|1^1^^^W *7,"This patient already has a IH74 code during this fiscal year"
 ;;IH75^2^^IH75^FY|1^1^^^W *7,"This patient already has a IH75 code during this fiscal year"
 ;;IH76^2^^IH76^FY|1^1^^^W *7,"This patient already has a IH76 code during this fiscal year"
 ;;IH77^2^^IH77^99999|1^1^^W *7,"This patient already has a IH77 code at this facilitY"
 ;;IH71^3^^IH71^^1^^X<20^W *7,"Patient must be 19 years old or younger"
 ;;IH72^3^^IH72^^1^^X<20^W *7,"Patient must be 19 years old or younger"
 ;;IH75^3^^IH75^^1^^((X>14)&(X<46))^W *7,"Patient must be between 15 and 45 years old"
 ;;IH77^3^^IH77^^1^^X>14^W *7,"Patient must be age 15 years or older"
 ;;[EXAMS^1^^[EXAMS^^1^^^W *7,"Only one exam may be reported per visit"
 ;;[EXTRACTIONS^2^y^[EXTRACTIONS^99999^1^^^W *7,"An extraction has already been reported for this tooth"
 ;;[EXTRACTIONS^1^y^[RESTORATIONS^^1^^^W *7,"Cannot extract and fill same tooth on same visit"
 ;;[PERMANENT TOOTH PROCEDURES^2^y^[EXTRACTIONS^99999^1^^^W *7,"An extraction has previously been reported for this tooth"
 ;;[PERMANENT TOOTH PROCEDURES^1^y^[EXTRACTIONS^^1^^^W *7,"An extraction is also being reported for this tooth"
 ;;[PERMANENT TOOTH PROCEDURES^4^y^^^1^^^W *7,"This code may only be used for permanent teeth"^[PERMANENT TEETH
 ;;[PERMANENT TOOTH PROCEDURES 2^4^y^^^1^^^W *7,"This code may only be used for permanent teeth"^[PERMANENT TEETH
 ;;[PRIMARY TOOTH PROCEDURES^2^y^[EXTRACTIONS^99999^1^^^W *7,"An extraction has previously been reported for this tooth"
 ;;[PRIMARY TOOTH PROCEDURES^1^y^[EXTRACTIONS^^1^^^W *7,"An extraction is also being reported for this tooth"
 ;;[PRIMARY TOOTH PROCEDURES^4^y^^^1^^^W *7,"This code may only be used for primary teeth"^[PRIMARY TEETH
