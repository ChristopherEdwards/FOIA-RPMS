BSTSXREF ;GDHS/HS/ALA-Concept ID Cross-references ; 16 Dec 2015  1:35 PM
 ;;1.0;IHS STANDARD TERMINOLOGY;**6**;Sep 10, 2014;Build 20
 ;
 Q
 ;
 NEW CDN,CDS,CID,X,DA
 ;
VSX ;EP - Variable set xref
 I $G(DA(2)) D
 . D VR
 S ^BSTS(9002318.4,"J",CDS,CID,X,DA(2),DA(1),DA)=""
 Q
 ;
VKX ;EP - Variable kill xref
 I $G(DA(2)) D
 . D VR
 K ^BSTS(9002318.4,"J",CDS,CID,X,DA(2),DA(1),DA)
 Q
 ;
VR ;EP - Set up variables
 S CDN=$P($G(^BSTS(9002318.4,DA(2),0)),U,7),CDS=$P($G(^BSTS(9002318.1,CDN,0)),"^",1)
 S CID=$P($G(^BSTS(9002318.4,DA(2),0)),U,2)
 Q
