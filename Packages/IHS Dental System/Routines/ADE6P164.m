ADE6P164 ; IHS/OIT/MJL - ADE6.0 PATCH 16 ;  [ 08/08/2005  11:00 AM ]
 ;;6.0;ADE;**16**;JUL 28, 2005
 ;
MODCDT4 ;EP
 D UPDATE^ADEUPD(9999999.31,".01,.02,501",1101,"?+1,","MODADA^ADE6P164","SETX^ADE6P164")
 Q
 ;
SETX ;EP
 S $P(ADEX,U)=$P($P(ADEX,U),"D",2),$P(ADEX,U,2)=$TR($P(ADEX,U,2),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
MODADA ;
 ;;D0350^Oral/facial photographic images^0.68
 ;;D2710^Crown - resin-based composite (indirect)^6.78
 ;;D2910^Recement inlay, onlay, or partial coverage restoration^1.02
 ;;D3332^Incomplete endodontic therapy; inoperable, unrestorable or fractured tooth^3.66
 ;;D4211^Gingivectomy or gingivoplasty - one to three contiguous teeth or bounded teeth spaces per quadrant^5.56
 ;;D4241^Gingival flap procedure, including root planing - one to three contiguous teeth or bounded teeth spaces per quadrant^2.1
 ;;D4261^Osseous surgery (including flap entry and closure) - one to three contiguous teeth or bounded teeth spaces per quadrant^5.42
 ;;D4273^Subepithelial connective tissue graft procedures, per tooth^11.19
 ;;D4276^Combined connective tissue and double pedicle graft, per tooth^6.44
 ;;D6056^Prefabricated abutment - includes placement^8.75
 ;;D6057^Custom abutment - includes placement^10.03
 ;;D7111^extraction, coronal remnants - deciduous tooth^1.36
 ;;D7283^Placement of device to facilitate eruption of impacted tooth^1.63
 ;;D7490^Radical resection of maxilla or mandible ^84.07
 ;;D7955^Repair of maxillofacial soft and/or hard tissue defect^30.51
 ;;***END***
