ABSPOSS5 ; IHS/FCS/DRS - 9002313.55 DIAL OUT ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
ABSPOSS1 ;EP - ABSPOSS1
 ; We want to just print the ones that are used, perhaps?
 ; And make mention of the ones that aren't used?
 D TEMPLATE^ABSPOSS2("ABSP DIAL OUT",9002313.55,"CAPTIONED")
 Q
DEFAULT()          ; return pointer to the DEFAULT dial out
 N X S X=$O(^ABSP(9002313.55,"B","DEFAULT",0))
 I 'X D IMPOSS^ABSPOSUE("DB","TI","Missing the dial out named DEFAULT",,"DEFAULT",$T(+0))
 Q X
BASIC ;EP - option ABSP DIAL OUT BASIC
 ; Basic edit - just a few fields in the default dial out
 ; and the 9002313.99 pointer to the default dial out
 N DIE,DA,DR,DIDEL,DTOUT
 W !,"Set up information about the modem being used to send claims:",!
 S DIE=9002313.55,DA=$$DEFAULT,DR="[ABSP SETUP DIAL OUT BASIC]"
 D ^DIE
 D DEF
 Q
DEF ;EP - option ABSP DIAL OUT DEF. ; also done as part of BASIC
 W !!,"Choose the destination to which claims will be sent.",!!
 W "Usually, answer ENVOY and select any one of the choices.",!!
 N DIE,DA,DR,DIDEL,DTOUT
 S DIE=9002313.99,DA=1,DR=440.01 D ^DIE
 Q
 ; ABSP SETUP DIAL OUT ADV ; advanced setup
 ; is done as an "edit" option
