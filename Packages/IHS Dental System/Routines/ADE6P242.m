ADE6P242 ;IHS/OIT/GAB - ADE6.0 PATCH 24 [ 11/17/2012  2:35 PM ]
 ;;6.0;ADE;**24**;NOV 17, 2012
 ;;ADA Code Update
 ;;Modification of Code
MODCDT5 ;EP
 D UPDATE^ADEUPD24(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P242","SETX^ADE6P242")
 Q
 ;
SETX ;EP
 I $G(ADERPEAT) D  Q:ADERPEAT
 .S:ADERPEAT=1 ADECURX=ADEX,ADERPEAT=2
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEX=ADECURX,ADEN="" Q
 .S ADEX=ADESVX,$P(ADEX,U)=ADEN,ADERPEAT=2
 Q:ADEDONE
 I $P(ADEX,U)["-" D  Q:'ADERPEAT
 .S ADERPEAT=1,ADESVX=ADEX,ADESTART=$P($P($P(ADEX,U),"-"),"D",2),ADEEND=$P($P($P(ADEX,U),"-",2),"D",2),ADEN=$O(^AUTTADA("B",ADESTART),-1)
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEN="" Q
 .S $P(ADEX,U)=ADEN
 I 'ADERPEAT S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN
 S $P(ADEX,U,3)=$TR($P(ADEX,U,3),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S:ADERPEAT ADESVX=ADEX
 Q
 ;
MODADA ;
 ;;D0210^^intraoral - complete series of radiographic images
 ;;A radiographic survey of the whole mouth, usually consisting of 14-22 periapical and
 ;;posterior bitewing images intended to display the crowns and roots of all teeth,
 ;;periapical areas and alveolar bone.
 ;;D0220^^intraoral - periapical first radiographic image
 ;;D0230^^intraoral - periapical each additional radiographic image
 ;;D0240^^intraoral - occlusal radiographic image
 ;;D0250^^extraoral - first radiographic image
 ;;D0260^^extraoral - each additional radiographic image
 ;;D0270^^bitewing - single radiographic image
 ;;D0272^^bitewings - two radiographic images
 ;;D0273^^bitewings - three radiographic images
 ;;D0274^^bitewings - four radiographic images
 ;;D0277^^vertical bitewings - 7 to 8 radiographic images
 ;;This does not constitute a full mouth intraoral radiographic series
 ;;D0290^^posterior - anterior or lateral skull and facial bone survey radiographic image
 ;;D0321^^other temporomandibular joint radiographic images, by report
 ;;D0330^^panoramic radiographic image
 ;;D0340^^cephalometric radiographic image
 ;;D1206^^topical application of fluoride varnish
 ;;D2710^^crown - resin-based composite (indirect)
 ;;D2799^^provisional crown - further treatment or completion of diagnosis necessary prior to final impression
 ;;Not to be used as a temporary crown for a routine prosthetic restoration.
 ;;D2940^^protective restoration
 ;;Direct placement of a restorative material to protect tooth and/or tissue form.  This procedure may be used to
 ;;relieve pain, promote healing, or prevent further deterioration.  Not to be used for endodontic access
 ;;closure, or as a base or liner under a restoration.
 ;;D2955^^Post removal
 ;;D2980^^crown repair necessitated by restorative material failure
 ;;D3352^^apexification/recalcification/pulpal regeneration-interim medication replacement (apial closure/calcific repair of perforations, root resorption, pulp space disinfection, etc.)
 ;;For visits in which the intra-canal medication is replaced with new medication.  Includes any necessary radiographs.
 ;;D4210^^gingivectomy or gingivoplasty - four or more contiguous teeth or tooth bound spaces per quandrant
 ;;It is performed to eliminate suprabony pockets or to restore normal
 ;;architecture when gingival enlargements or asymmetrical or unaesthetic
 ;;topography is evident with normal bony configuration.
 ;;D4211^^gingivectomy or gingivoplasty - one to three contiguous teeth or tooth bounded spaces per quandrant
 ;;It is performed to eliminate suprabony pockets or to restore normal architecture
 ;;when gingival enlargements or asymmetrical or unaesthetic topography is evident
 ;;with normal bony configuration.
 ;;D4260^^osseous surgery (including flap entry and closure) - four or more contiguous teeth or tooth bounded spaces per quandrant
 ;;This procedure modifies the bony support of the teeth by reshaping the
 ;;alveolar process to achieve a more physiologic form.  This must include
 ;;the removal of supporting bone (ostectomy) and/or non-supporting bone
 ;;(osteoplasty).  Other procedures may be required concurrent to D4260
 ;;and should be reported using their own unique codes
 ;;D4261^^osseous surgery (including flap entry and closure) - one to three contiguous teeth or tooth bounded spaces per quadrant
 ;;This procedure modifies the bony support of the teeth by reshaping the
 ;;alveolar process to achieve a more physiologic form.  This must include
 ;;the removal of supporting bone (ostectomy) and/or non-supporting bone
 ;;(osteoplasty).  Other procedures may be required concurrent to D4261
 ;;and should be reported using their own unique codes.
 ;;D4266^^guided tissue regeneration - resorbable barrier, per site
 ;;This procedure does not include flap entry and closure, or, when
 ;;indicated, wound debridement, osseous contouring, bone replacement
 ;;grafts, and placement of biologic materials to aid in osseous
 ;;regeneration.  This procedure can be used for periodontal and
 ;;peri-implant defects.
 ;;D4267^^guided tissue regeneration - nonresorbable barrier, per site (includes membrane removal)
 ;;This procedure does not include flap entry and closure, or, when
 ;;indicated, wound debridement, osseous contouring, bone replacement
 ;;grafts, and placement of biologic materials to aid in osseous
 ;;regeneration.  This procedure can be used for periodontal and
 ;;peri-implant defects.
 ;;D4381^^localized delivery of antimicrobial agents via controlled release vehicle into diseased crevicular tissue, per tooth
 ;;FDA approved subgingival delivery devices containing antimicrobial
 ;;medication(s) are inserted into periodontal pockets to suppress
 ;;the pathogenic microbiota.  These devices slowly release the
 ;;pharmacological agents so they can remain at the intended site
 ;;of action in a therapeutic concentration for a sufficient length
 ;;of time.
 ;;D6056^^prefabricated abutment - includes modification and placement
 ;;Modification of a prefabricated abutment may be necessary.
 ;;D6057^^custom fabricated abutment - includes placement
 ;;Created by a laboratory process, specific for an individual application.
 ;;D6253^^provisional pontic - further treatment or completion of diagnosis necessary prior to final impression
 ;;Not to be used as a temporary pontic for routine prosthetic fixed partial dentures
 ;;D6793^^provisional retainer crown - further treatment or completion of diagnosis necessary prior to final impression
 ;;Not to be used as a temporary retainer crown for routine prosthetic fixed partial dentures.
 ;;D6975^^coping
 ;;To be used as a definitive restoration when coping is an integral part of a fixed prosthesis.
 ;;D6980^^fixed partial denture repair necessitated by restorative material failure
 ;;D7951^^sinus augmentation with bone or bone substitutes via a lateral open approach
 ;;The augmentation of the sinus cavity to increase alveolar height for
 ;;reconstruction of edentulous portions of the maxilla.  This procedure
 ;;is performed via a lateral open approach.  This includes obtaining the
 ;;bone or bone substitutes.  Placement of a barrier membrane if used
 ;;should be reported separately.
 ;;D9972^^external bleaching - per arch - performed in office
 ;;***END***
