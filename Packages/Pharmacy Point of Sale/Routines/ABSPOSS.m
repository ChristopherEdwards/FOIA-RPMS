ABSPOSS ; IHS/FCS/DRS - POS setup ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
INSUR ;EP - option ABSP INSURANCE EDIT ; Edit insurance info
 D INSURSYS()
 W !!?5,"SELECT an INSURER - the insurer must already be in the"
 W !?8,"RPMS INSURER file, but you may need to answer Yes if it"
 W !?8,"asks about adding the insurer to the FSI INSURER file."
 W !
 N DIC,DLAYGO,DIE,DA,DR,IEN,X,Y,I
LOOP ;
 S DIC="^ABSPEI(",DIC(0)="QEALM",DLAYGO=9002313.4
 S DIC("A")="Edit PHARMACY settings for which INSURER: "
 D ^DIC
 S IEN=+Y Q:IEN<0
 W !!?5,"RX BILLING STATUS:"
 W !?8,"If this insurance does not cover pharmacy, answer with U."
 W !?8,"To remove an UNBILLABLE status, answer with @."
 W !?8,"Don't use the answer O unless you're really sure about it."
 W !
 S DIE="^AUTNINS(",DA=IEN,DR=.23 D ^DIE
 ;
 W !!?5,"GRACE PERIOD: usually left blank in here."
 S DIE="^ABSPEI(",DA=IEN,DR=100.08 D ^DIE
 W !
 W !!?5,"PRINT ON WHICH FORMS? Select NCPDP, UB92, or 1500",!
 S DIE="^ABSPEI(",DA=IEN,DR="105:105.99" D ^DIE
 W !
 W !?5,"NCPDP Forms detail: answer with  ?  for help on any question."
 S DIE="^ABSPEI(",DA=IEN,DR="100.09:100.13" D ^DIE
 W !!!
 G LOOP
 Q
INSURSYS(X) ; display the system-wide defaults for insurance
 I '$D(X) S X=99
 I X>0 D
 . W !,"The system-wide defaults for POS and insurance are currently:",!
 D INSURNCP ; NCPDP form settings
 D INSURPRE ; prebill settings
 D INSURINS ; other settings
 I X>0 D
 . W !
 . W "These settings apply to all insurances, unless you make special",!
 . W "settings for a particular insurer in this program.",!
 Q
INSURNCP D DIQ99("FORMS - NCPDP") Q
INSURPRE D DIQ99("FORMS - PREBILL") Q
INSURINS D DIQ99("INS") Q
DIQ99(DR)          S DIC="^ABSP(9002313.99,",DA=1 D EN^DIQ Q
