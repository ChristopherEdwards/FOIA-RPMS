APCDDCG ; IHS/CMI/LAB - display coding guidelines ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
EP ;EP - called from data entry input template
 D EN^XBNEW("EP1^APCDDCG","")
 Q
EP1 ;EP called from xbnew
 ;display word processing field of coding guidelines
 D DIQ^XBLM("^APCDSUPP(",1)
 Q
