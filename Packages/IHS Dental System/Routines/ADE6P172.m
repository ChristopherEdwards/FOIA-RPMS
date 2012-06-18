ADE6P172 ;IHS/OIT/ENM - ADE6.0 PATCH 17 [ 03/26/2007  9:28 AM ]
 ;;6.0;ADE;**17**;JAN 29, 2007
 ;
MODCDT5 ;EP
 D UPDATE^ADEUPD7(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P172","SETX^ADE6P172")
 ;D UPDATE^ADEUPD7(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P173","SETX^ADE6P172")
 ;D MODEDT ;IHS/ENM NO NEED TO RUN THIS LINE IN P17
 Q
 ;
MODEDT ;EP Modify DENTAL CODE EDIT GROUP and Reindex DENTAL EDIT file
 ;D UPDATE^ADEUPD7(9002007.91,".01,1",,"?+1,","EDITX^ADE6P172","SETEDX^ADE6P172")
 ;D REINDX
 ;
 Q
SETEDX ;
 S ADEN=$P(ADEX,U)
 Q
 ;
EDITX ;Data for DENTAL CODE EDIT GROUP modifications
 Q
 ;;PRIMARY TOOTH PROCEDURES^2121|2930|3230
 ;;
 ;;***END***
 Q
 ;
REINDX ;EP Kill and Re-index AC, AD AND B Cross References on DENTAL EDIT file
 ;
 N DIK
 K ^ADEDIT("AC"),^ADEDIT("AD"),^ADEDIT("B")
 S DIK="^ADEDIT("
 D IXALL^DIK
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
 ;;D0120^46^periodic oral evaluation - established patient^
 ;;An evaluation performed on a patient of record to determine any changes in the
 ;;patients dental and medical health status since a previous comprehensive or
 ;;periodic evaluation.  This includes an oral cancer evaluation and periodontal
 ;;screening where indicated, and may require interpretation of information
 ;;acquired through additional diagnostic procedures.  Report additional 
 ;;diagnostic procedures separately.
 ;;D0150^58^comprehensive oral evaluation - new or established patient^
 ;;Used by a general dentist and/or a specialist when evaluating a patient
 ;;comprehensively.  This applies to new patients; established patients who
 ;;have a significant change in health conditions or other unusual 
 ;;circumstances, by report, or established patients who have been absent 
 ;;from active treatment for three or more years.  It is a thorough evaluation
 ;;and recording of the extraoral and intraoral hard and soft tissues.  It may 
 ;;require interpretation of information acquired through additional diagnostic
 ;;procedures.  Additional diagnostic procedures should be reported separately.
 ;;This includes an evaluation for oral cancer where indicated, the evaluation 
 ;;and recording of the patient's dental and medical history and a general health
 ;;assessment. It may include the evaluation and recording of dental caries, 
 ;;missing or unerupted teeth, restorations, existing prostheses, occlusal 
 ;;relationships, periodontal conditions (including periodontal screening 
 ;;and/or charting), hard and soft tissue anomalies, etc.
 ;;D0180^65^comprehensive periodontal evaluation - new or established patient^
 ;;This procedure is indicated for patients showing signs or symptoms
 ;;of periodontal disease and for patients with risk factors such as 
 ;;smoking or diabetes.  It includes evaluation of periodontal conditions, 
 ;;probing and charting, evaluation and recording of the patient's dental 
 ;;and medical history and general health assessment.  It may include 
 ;;the evaluation and recording of dental caries, missing or unerupted 
 ;;teeth, restorations, occlusal relationships and oral cancer evaluation
 ;;D0472^86^accession of tissue, gross examination, preparation and transmission of written report^
 ;;To be used in reporting architecturally intact tissue obtained by invasive means.
 ;;D0473^102^accession of tissue, gross and microscopic examination, preparation and transmission of written report^
 ;;To be used in reporting architecturally intact tissue obtained by invasive means.
 ;;D0474^168^accession of tissue, gross and microscopic examination, including assessment of surgical margins for presence of disease, preparation and transmission of written report^
 ;;To be used in reporting architecturally intact tissue obtained by invasive means.
 ;;D0480^114^accession of exfoliative cytologic smears, microscopic examination, preparation and transmission of written report^
 ;;To be used in reporting disaggregated, non-transepithelial cell cytology sample via mild scraping of the oral mucosa.
 ;;D2952^57^post and core in addition to crown, indirectly fabricated^
 ;;Post and core are custom fabricated as a single unit.
 ;;D2953^55^each additional indirectly fabricated post - same tooth^
 ;;To be used with D2952.
 ;;D3120^49^pulp cap - indirect (excluding final restoration)^
 ;;Procedure in which the nearly exposed pulp is covered with a protective 
 ;;dressing to protect the pulp from additional injury and to promote healing and
 ;; repair via formation of secondary dentin.  This code is not to be used for 
 ;;bases and liners when all caries has been removed.
 ;;D3331^56^treatment of root canal obstruction; non-surgical access^
 ;;In lieu of surgery, the formation of a pathway to achieve an apical seal 
 ;;without surgical intervention because of a non-negotiable root canal blocked
 ;; by foreign bodies, included but not limited to separated instruments, broken 
 ;;posts or calcification of 50% or more of the roots.
 ;;D4210^98^gingivectomy or gingivoplasty - four or more contiguous teeth or bounded teeth spaces per quadrant^
 ;;Involves the excision of the soft tissue wall of the periodontal pocket by 
 ;;either an external or an internal bevel.  It is performed to eliminate 
 ;;suprabony pockets after adequate initial preparation, to allow access for
 ;; restorative dentistry in the presence of suprabony pockets, or to restore 
 ;;normal architecture when gingival enlargements or asymmetrical or 
 ;;unaesthetic topography is evident with normal bony configuration.
 ;;D4211^98^gingivectomy or gingivoplasty - one to three contiguous teeth or bounded teeth spaces per quadrant^
 ;;Involves the excision of the soft tissue wall of the periodontal pocket by 
 ;;either an external or an internal bevel.  It is performed to eliminate 
 ;;suprabony pockets after adequate initial preparation, to allow access for
 ;; restorative dentistry in the presence of suprabony pockets, or to restore
 ;; normal architecture when gingival enlargements or asymmetrical or
 ;; unaesthetic topography is evident with normal bony configuration
 ;;D4240^116^gingival flap procedure, including root planing - four or more contiguous teeth or bounded teeth spaces per quadrant^
 ;;A soft tissue flap is reflected or resected to allow debridement of the root 
 ;;surface and the removal of granulation tissue.  Osseous recontouring is not
 ;; accomplished in conjunction with this procedure.  May include open flap 
 ;;curettage, reverse bevel flap surgery, modified Kirkland flap procedure, and
 ;; modified Widman surgery.  This procedure is performed in the presence of 
 ;;moderate to deep probing depths, loss of attachment, need to maintain 
 ;;esthetics, need for increased access to the root surface and alveolar bone, 
 ;;or to determine the presence of a cracked tooth, fractured root, or external 
 ;;root resorption.  Other procedures may be required concurrent to D4240 and 
 ;;should be reported separately using their own unique codes
 ;;D4241^116^gingival flap procedure, including root planing - one to three contiguous teeth or bounded teeth spaces per quadrant^
 ;;A soft tissue flap is reflected or resected to allow debridement of the root 
 ;;surface and the removal of granulation tissue.  Osseous recontouring is 
 ;;not accomplished in conjunction with this procedure.  May include open 
 ;;flap curettage, reverse bevel flap surgery, modified Kirkland flap procedure, 
 ;;and modified Widman surgery.  This procedure is performed in the 
 ;;presence of moderate to deep probing depths, loss of attachment, need to 
 ;;maintain esthetics, need for increased access to the root surface and alveolar
 ;; bone, or to determine the presence of a cracked tooth, fractured root, or 
 ;;external root resorption.  Other procedures may be required concurrent  
 ;;to D4241 and should be reported separately using their own unique codes.
 ;;D4260^119^osseous surgery (including flap entry and closure) - four or more contiguous teeth or bounded teeth spaces per quadrant^
 ;;This procedure modifies the bony support of the teeth by reshaping the alveolar
 ;; process to achieve a more physiologic form.  This may include the removal of 
 ;;supporting bone (ostectomy) and/or non-supporting bone (osteoplasty).  Other 
 ;;procedures may be required concurrent to D4260 and should be reported using 
 ;;their own unique codes
 ;;D4261^119^osseous surgery (including flap entry and closure) - one to three contiguous teeth or bounded teeth spaces per quadrant^
 ;;This procedure modifies the bony support of the teeth by reshaping the alveolar
 ;; process to achieve a more physiologic form.  This may include the removal of 
 ;;supporting bone (ostectomy) and/or non-supporting bone (osteoplasty).  Other 
 ;;procedures may be required concurrent to D4261 and should be reported using
 ;; their own unique codes.
 ;;D4263^47^bone replacement graft - first site in quadrant^
 ;;This procedure involves the use of osseous autografts, osseous allografts, 
 ;;or non-osseous grafts to stimulate periodontal regeneration when the disease 
 ;;process has led to a deformity of the bone.  This procedure does not include 
 ;;flap entry and closure, wound debridement, osseous contouring, or the 
 ;;placement of biologic materials to aid in osseous tissue regeneration or 
 ;;barrier membranes.  Other separate procedures may be required concurrent 
 ;;to D4263 and should be reported using their own unique codes.  Definition for 
 ;;the term "site" precedes code D4210.
 ;;D4264^57^bone replacement graft - each additional site in quadrant^
 ;;This procedure involves the use of osseous autografts, osseous allografts, or 
 ;;non-osseous grafts to stimulate periodontal regeneration when the disease 
 ;;process has led to a deformity of the bone.  This procedure does not include 
 ;;flap entry and closure, wound debridement, osseous contouring, or the 
 ;;placement of biologic materials to aid in osseous tissue regeneration or 
 ;;barrier membranes.  This code is used if performed concurrently with D4263 and
 ;; allows reporting of the exact number of sites involved.  Definition for the term 
 ;;"site" precedes code D4210.
 ;;
 ;;***END***
