FHINIT5	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	K ^UTILITY("DIF",$J) S DIFRDIFI=1 F I=1:1:88 S ^UTILITY("DIF",$J,DIFRDIFI)=$T(IXF+I),DIFRDIFI=DIFRDIFI+1
	Q
IXF	;;DIETETICS^FH
	;;111sI;DIETS;^FH(111,;0;y;y;;n;;;y;m;y
	;;
	;;111.1;DIET PATTERNS;^FH(111.1,;0;y;y;;n;;;n
	;;
	;;112;FOOD NUTRIENTS;^FHNU(;0;y;y;;n;;;y;o;n
	;;
	;;112.2;RDA VALUES;^FH(112.2,;0;y;y;;n;;;y;o;n
	;;
	;;112.6I;USER MENU;^FHUM(;0;y;y;;n;;;n
	;;
	;;113;INGREDIENT;^FHING(;0;y;y;;n;;;y;m;y
	;;
	;;113.1;STORAGE LOCATION;^FH(113.1,;0;y;y;;n;;;n
	;;
	;;113.2;VENDOR;^FH(113.2,;0;y;y;;n;;;y;m;y
	;;
	;;114;RECIPE;^FH(114,;0;y;y;;n;;;y;m;y
	;;
	;;114.1I;RECIPE CATEGORY;^FH(114.1,;0;y;y;;n;;;y;m;y
	;;
	;;114.2;PREPARATION AREA;^FH(114.2,;0;y;y;;n;;;y;m;y
	;;
	;;114.3;SERVING UTENSIL;^FH(114.3,;0;y;y;;n;;;y;m;y
	;;
	;;114.4;EQUIPMENT;^FH(114.4,;0;y;y;;n;;;y;m;y
	;;
	;;115;DIETETICS PATIENT;^FHPT(;0;y;y;;n;;;n
	;;
	;;115.2sI;FOOD PREFERENCES;^FH(115.2,;0;y;y;;n;;;n
	;;
	;;115.3sI;NUTRITION CLASSIFICATION;^FH(115.3,;0;y;y;;n;;;n
	;;
	;;115.4I;NUTRITION STATUS;^FH(115.4,;0;y;y;;n;;;y;o;n
	;;
	;;115.5;DIETETIC NUTRITION PLAN;^FH(115.5,;0;y;y;;n;;;n
	;;
	;;115.6sI;ENCOUNTER TYPES;^FH(115.6,;0;y;y;;n;;;y;m;y
	;;
	;;115.7;DIETETIC ENCOUNTERS;^FHEN(;0;y;y;;n;;;n
	;;
	;;116;MENU CYCLE;^FH(116,;0;y;y;;n;;;n
	;;
	;;116.1;MEAL;^FH(116.1,;0;y;y;;n;;;n
	;;
	;;116.2sI;PRODUCTION DIET;^FH(116.2,;0;y;y;;n;;;y;m;y
	;;
	;;116.3;HOLIDAY MEALS;^FH(116.3,;0;y;y;;n;;;n
	;;
	;;117D;MEALS SERVED;^FH(117,;0;y;y;;n;;;n
	;;
	;;117.1D;STAFFING DATA;^FH(117.1,;0;y;y;;n;;;n
	;;
	;;117.2D;DIETETIC COST OF MEALS;^FH(117.2,;0;y;y;;n;;;n
	;;
	;;117.3D;ANNUAL REPORT;^FH(117.3,;0;y;y;;n;;;n
	;;
	;;117.4;DIETETIC REPORT CATEGORIES;^FH(117.4,;0;y;y;;n;;;y;o;n
	;;
	;;118sI;SUPPLEMENTAL FEEDINGS;^FH(118,;0;y;y;;n;;;y;m;y
	;;
	;;118.1sI;SUPPLEMENTAL FEEDING MENU;^FH(118.1,;0;y;y;;n;;;y;m;y
	;;
	;;118.2sI;TUBEFEEDING;^FH(118.2,;0;y;y;;n;;;y;m;y
	;;
	;;118.3sI;STANDING ORDERS;^FH(118.3,;0;y;y;;n;;;n
	;;
	;;119P;DIETITIAN TICKLER FILE;^FH(119,;0;y;y;;n;;;n
	;;
	;;119.1;UNITS;^FH(119.1,;0;y;y;;n;;;y;m;y
	;;
	;;119.4sI;ISOLATION/PRECAUTION TYPE;^FH(119.4,;0;y;y;;n;;;y;m;y
	;;
	;;119.5sI;DIETETIC CONSULTS;^FH(119.5,;0;y;y;;n;;;y;m;y
	;;
	;;119.6;DIETETICS WARD;^FH(119.6,;0;y;y;;n;;;n
	;;
	;;119.71;PRODUCTION FACILITY;^FH(119.71,;0;y;y;;n;;;n;;
	;;
	;;119.72;SERVICE POINT;^FH(119.72,;0;y;y;;n;;;n;;
	;;
	;;119.73;COMMUNICATION OFFICE;^FH(119.73,;0;y;y;;n;;;n;;
	;;
	;;119.74;SUPPLEMENTAL FEEDING SITE;^FH(119.74,;0;y;y;;n;;;n;;
	;;
	;;119.8;DIETETIC EVENTS;^FH(119.8,;0;y;y;;n;;;n
	;;
	;;119.9;FH SITE PARAMETERS;^FH(119.9,;0;y;y;;n;;;y;m;y
	;;
