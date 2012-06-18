AZXADEL ; IHS/PHXAO/TMJ - DISCLOSURE DELETE ; 
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;
 D GETREF
 I Y<1 W !!,"No DISCLOSURE selected!" D EOJ Q
 D DSPLY
 D DELETE
 D EOJ
 Q
 ;
GETREF ; GET DISCLOSURE IEN - Do Not Display Closed Disclosures
 W !
 S AZXAQ=1
 W !
 S DIC="^AZXAREC(",DIC(0)="AEMQ",DIC("S")="I $D(^(0)),$P(^(0),U,8)'[""C""",DIC("A")="Select DISCLOSURE by Patient or by Disclosure Date or #: "
 D DIC^AZXAFMC
 Q:Y<1
 S AZXARIEN=+Y
 S AZXAQ=0
 Q
 ;
 ;
 ;
 ;
DSPLY ;
 S AZXARDSP=AZXARIEN D START2^AZXARDSP
 W !!,"THE ABOVE DISCLOSURE AND RELATED ENTRIES WILL BE REMOVED FOREVER !!!"
 Q
 ;
DELETE ; DELETE VISIT AND RELATED V FILES
 W !,"Sure you want to delete" S %=2 D YN^DICN S %Y=$E(%Y)
 Q:"Nn"[%Y
 S AZXARDLT=AZXARDSP D ^AZXARDLT
 I $D(^AZXAREC(AZXARDSP,0)) D MSG
 Q
 ;
EOJ ; EOJ HOUSE KEEPING
 K %,%DT,%X,%Y,C,DIYS,X,Y
 K AZXARIEN,AZXARDSP,AZXARDLT
 Q
 ;
MSG ;No Delete of Disclosure Message IHS/PHXAO/TMJ Patch #4 New Message
 Q  ; Quit No Delete Message on disclosure Program
 W !!,?10,"The Selected Disclosure was NOT deleted.......",!,?10,"This Disclosure either contains required Required Data!!",!
 W ?10,"OR the Disclosure has been CLOSED!",!!
 H 5 Q
