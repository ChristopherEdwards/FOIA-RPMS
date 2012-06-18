ABSPOSS3 ; IHS/FCS/DRS - file 9002313.53 - Pricing tables ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
ABSPOSS1 ;EP - ABSPOSS1
 D TEMPLATE^ABSPOSS2("ABSP PRICING TABLES",9002313.53)
 Q
INDEX ; which pricing tables are in use by which insurers?
 W "Index - Pricing tables used by which insurers",!
 ; incomplete
 ; ^ABSPEI("APricing",pricing table,insurer)
 Q
ASK ;EP - ABSPOSQP
 I $$YESNO^ABSPOSS8("Do you want to see a report of the pricing formulas you have set up now") D ABSPOSS1
 Q
