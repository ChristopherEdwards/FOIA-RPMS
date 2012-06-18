ADE6P221 ;IHS/OIT/ENM - ADE6.0 PATCH 22 [ 12/01/2010  8:37 AM ]
 ;;6.0;ADE;**22**;SEP 17, 2008
 ;
ADDCDT5 ;EP
 D UPDATE^ADEUPD22(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P221","SETX^ADE6P221")
 Q
AC ;EP
 ;SET Dental Edit File "AC" xref for new ADA Codes
 D S1 ;call to S2 removed
 Q
S1 ;Code 1352,3354,6254,6795,7251 is the same as 2950
 ;
 S ADENO=2950,ADEAC=0
 F  S ADEAC=$O(^ADEDIT("AC",ADENO,1,ADEAC)) Q:'ADEAC  D ZSE
 K ADENO,ADEAC
 Q
ZSE ;
 S ^ADEDIT("AC",1352,1,ADEAC)="",^ADEDIT("AC",3354,1,ADEAC)="",^ADEDIT("AC",6254,1,ADEAC)="",^ADEDIT("AC",6795,1,ADEAC)="",^ADEDIT("AC",7251,1,ADEAC)=""
 Q
 ;
S2 ;Remove Codes 1352,3354,6254,6795,7251 that are the same as 2930
 Q
 ;K ^ADEDIT("AC",1352,1,26),^ADEDIT("AC",1352,1,27),^ADEDIT("AC",1352,1,28)
 ;K ^ADEDIT("AC",3354,1,26),^ADEDIT("AC",3354,1,27),^ADEDIT("AC",3354,1,28)
 ;K ^ADEDIT("AC",6254,1,26),^ADEDIT("AC",6254,1,27),^ADEDIT("AC",6254,1,28)
 ;K ^ADEDIT("AC",6795,1,26),^ADEDIT("AC",6795,1,27),^ADEDIT("AC",6795,1,28)
 ;K ^ADEDIT("AC",7251,1,26),^ADEDIT("AC",7251,1,27),^ADEDIT("AC",7251,1,28)
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;
 ;;D1352^2^1.5^PRR^88^preventive resin restoration in a moderate to high caries risk patient – permanent tooth^PRR^
 ;;Conservative restoration of an active cavitated lesion in a pit or fissure that
 ;;does not extend into dentin; includes placement of a sealant in any radiating
 ;;non-carious fissures or pits.
 ;;D3354^3^12.0^PU REGEN^^pulpal regeneration – (completion of regenerative treatment in an immature permanent tooth with a necrotic pulp); does not include final restoration^PUREGEN^
 ;;Includes removal of intra-canal medication and procedures necessary to 
 ;;regenerate continued root development and necessary radiographs.  This 
 ;;procedure includes placement of a seal at the coronal portion of the root 
 ;;canal system.  Conventional root canal treatment is not performed.
 ;;D5992^1^1.5^ADJ PROS^41^adjust maxillofacial prosthetic appliance^ADJPROS^n
 ;;D5993^2^0.75^MAINT PROS^118^maintenance and cleaning of a maxillofacial prosthesis (extra or intraoral) other than required adjustments, by report^MAINTPROS^n
 ;;Maintenance and cleaning of a maxillofacial prosthesis.
 ;;D6254^5^2.79^INT PON^14^interim pontic^INTPON^
 ;;Pontic used as an interim restoration for a duration of less than six 
 ;;months when a final impression is not made to allow adequate time for 
 ;;healing or completion of definitive treatment planning.  This is not 
 ;;a temporary pontic for routine prosthetic fixed partial denture 
 ;;restoration.
 ;;D6795^5^2.79^INT RET^^interim retainer crown^INTRET^
 ;;Retainer crown used as an interim restoration for a duration of less 
 ;;than six months when a final impression is not made to allow adequate
 ;;time for healing or completion of definitive treatment planning.  This
 ;;is not a temporary retainer crown for routine prosthetic fixed partial
 ;;denture restoration.
 ;;D7251^5^11.17^CRNECTOMY^^coronectomy - intentional partial tooth removal^CRNECTOMY^
 ;;Intentional partial tooth removal is performed when a neurovascular
 ;;complication is likely if the entire impacted tooth is removed.
 ;;D7295^5^12.0^HAR BONE GRAFT^56^harvest of bone for use in autogenous grafting procedure^HBGRAFT^n
 ;;Reported in addition to those autogenous graft placement procedures
 ;;that do not include harvesting of bone.
 ;;***END***
