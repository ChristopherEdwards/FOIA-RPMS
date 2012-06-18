ABMDE301 ; IHS/ASDST/DMJ - Page 3 - QUESTIONS - Display (cont) ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ; Split from ABMDE30 due to routine size
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added Hearing and Vision Prescription Date
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added start/end disability dates
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added Assumed/Relinquished Care dates
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added property/casualty date of 1st contact
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added Patient Paid Amount
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added Spinal Manipulation Cond Code Ind
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Added Vision Condition Info
 ;
 ; *********************************************************************
W30 ;EP Hospice Employed Provider
 W "Hospice Employed Prov...: "
 S ABM(30)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,15)
 W ABM(30)
 Q
W31 ;EP Delayed Reason Code
 W "Delayed Reason Code.....: "
 S ABM(31)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,16)
 I ABM(31) D
 .W $P(^ABMDCODE(+ABM(31),0),U)," "
 .W $P(^ABMDCODE(+ABM(31),0),U,3)
 Q
W32 ;Number of Enclosures - Radiographs/Oral Images/Model(s)
 W "Number of Enclosures....: "
 S ABM(32)=+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,17)  ;Radiographs
 S ABM(32)=ABM(32)+($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,18))  ;+Oral Images
 S ABM(32)=ABM(32)+($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,19))  ;+Models
 W ABM(32)
 Q
W33 ; Other Dental Charges
 W "Other Dental Charges....: "
 S ABM(33)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,21)
 W $FN(ABM(33),",",2)
 Q
 ;
W34 ;Reference Lab CLIA#
 W "Reference Lab CLIA#.....: "
 S ABM(34)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23)
 Q:ABM(34)=""
 Q:$G(^ABMRLABS(ABM(34),0))=""
 W:$G(ABM(34))'="" $P($G(^ABMRLABS(ABM(34),0)),U,2),"  ",$P($G(^AUTTVNDR($P($G(^ABMRLABS(ABM(34),0)),U),0)),U)
 Q
W35 ;In-House CLIA#
 W "In-House CLIA#..........: "
 S ABM(35)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22)
 W:$G(ABM(35))'="" ABM(35)
 Q
 ;start new code abm*2.6*6 5010
W36 ;Hearing and Vision Prescription Date
 W "Hearing/Vision Prescription Date: "
 S ABM(36)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,14)
 W:$G(ABM(36))'="" $$SDT^ABMDUTL(ABM(36))
 Q
W37 ;Start/End Disability Dates
 W "Start/End Disability Dates: "
 S ABM(37)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,15)
 W:$G(ABM(37))'="" " ST: "_$$SDT^ABMDUTL(ABM(37))
 S ABM(37)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,16)
 W:$G(ABM(37))'="" " END: "_$$SDT^ABMDUTL(ABM(37))
 Q
W38 ;Assumed/Relinquished Care Dates
 W "Assumed/Relinquished Care Dates: "
 S ABM(38)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,19)
 W:$G(ABM(38))'="" " Assumed: "_$$SDT^ABMDUTL(ABM(38))
 S ABM(38)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,21)
 W:$G(ABM(38))'="" " Relinq'ed: "_$$SDT^ABMDUTL(ABM(38))
 Q
W39 ;Property/Casualty Date of 1st contact
 W "Property/Casualty Date of 1st Contact: "
 S ABM(39)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,22)
 W:$G(ABM(39))'="" $$SDT^ABMDUTL(ABM(39))
 Q
W40 ;Patient Paid Amount
 W "Patient Paid Amount: "
 S ABM(40)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,23)
 W:$G(ABM(40))'="" $J($FN(ABM(40),",",2),10)
 Q
W41 ;Spinal Manipulation Service Info
 W "Spinal Manipulation Cond Code Ind: "
 S ABM(41)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,24)
 W:$G(ABM(41))'="" ABM(41)
 Q
W42 ;Vision Condition Info
 W "Vision Condition Info: "
 S ABM(42)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,21)
 W:$G(ABM(42))'="" ABM(42)
 S ABM(42)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,22)
 W:$G(ABM(42))'="" "   CERT: ",ABM(42)
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8.5,0)) D
 .S ABM("VIEN")=0
 .W "    COND IND: "
 .F  S ABM("VIEN")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),8.5,ABM("VIEN"))) Q:'ABM("VIEN")  D
 ..I ABM("VIEN")'=1 W ","
 ..W $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8.5,ABM("VIEN"),0)),U)
 Q
 ;end new code 5010
