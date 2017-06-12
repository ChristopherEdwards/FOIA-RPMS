BEHOAMH ;IHS/MSC/PLS - RPCS FOR BEHAVIORAL HEALTH;28-Oct-2015 04:43;du
 ;;1.1;BEH COMPONENTS;**013004**;Sept 18, 2007;Build 1
 ;==========================================================
FORMIENS(DATA,IEN) ;EP- Returns IENS for fields .03;.07;.25
 N FN,FLDS,DARY,IENS,FLD
 S DATA="",IENS=IEN_","
 S FN=9002011.65,FLDS=".03;.07;.25"
 D GETS^DIQ(FN,IEN_",",FLDS,"I","DARY")
 F I=1:1:$L(FLDS,";") D
 .S FLD=$P(FLDS,";",I)
 .S DATA=DATA_$S($L(DATA):U,1:"")_FLD_":"_$G(DARY(FN,IENS,FLD,"I"))
 Q
POST ;Post-init for EHR patch 17 to clean up data in the MHSS SUICIDE FORMS file
 ;has text data stored in pointer fields
 N AIEN,DATA,PRV,COM,DISP,PIEN,FDA,IENS,ERR,PIEN,DIEN
 S (PIEN,CIEN,DIEN)=""
 S AIEN=0 F  S AIEN=$O(^AMHPSUIC(AIEN)) Q:'+AIEN  D
 .S DATA=$G(^AMHPSUIC(AIEN,0))
 .S PRV=$P(DATA,U,3)
 .Q:PRV=""
 .I '+PRV D
 ..S PIEN=$O(^VA(200,"B",PRV,"")) Q:'+PIEN  D
 ...S FDA(9002011.65,AIEN_",",.03)=PIEN
 .S COM=$P(DATA,U,7)
 .Q:COM=""
 .I '+COM D
 ..S CIEN=$O(^AUTTCOM("B",COM,"")) Q:'+CIEN  D
 ...S FDA(9002011.65,AIEN_",",.07)=CIEN
 .S DISP=$P(DATA,U,25)
 .Q:DISP=""
 .I '+DISP D
 ..S DIEN=$O(^AMHTSDT("B",DISP,"")) Q:'+DIEN  D
 ...S FDA(9002011.65,AIEN_",",.25)=DIEN
 .I $D(FDA) D
 ..D UPDATE^DIE("","FDA","IENS","ERR")
 ..K FDA,IENS,ERR
 Q
