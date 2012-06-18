BDPPASS ; IHS/CMI/TMJ - Routine to Pass data to Designated Provider Package ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;This Routine creates a new entry or edits an existing entry
 ;of the Desginated Specialty Provider Management System
 ;BDPDFN = Patient DFN Number
 ;BDPTYPE = Internal IEN # of Provider Type File #90360.3
 ;BDPRPRVP = Internal IEN of Provider Name
 ;
 ;
 ;
CREATE(BDPDFN,BDPTYPE,BDPRPRVP) ;EP - Entry Point to Create
 ;
 N BDPRR,BDPLINKI,BDPLPROV,BDPRIEN,BDPLINKI
 ;
 S BDPQ=1
 S BDPLINKI=1  ;tell xrefs we are in bdp
 S BDPRPROV=$P($G(^VA(200,BDPRPRVP,0)),U) ;Provider Text Name
 S BDPRR=$O(^BDPRECN("AA",BDPDFN,BDPTYPE,""))  ;Check to see if this Patient already has Type
 I BDPRR="" D ADDNEW Q BDPQ  ;NONE OF THIS TYPE
 S BDPLPROV=$P($G(^BDPRECN(BDPRR,0)),U,3) ;Current Provider
 Q:BDPLPROV=BDPRPRVP 0  ;Quit if Same Provider Selected as Current
 S BDPRIEN=BDPRR D MOD Q 0
 Q 0
 ;
ADDNEW ;Add a new Record
 S DIC="^BDPRECN(",DIC(0)="L",DLAYGO=90360.1,DIC("DR")=".02////"_BDPDFN,X=BDPTYPE
 D FILE^BDPFMC
 I Y<0 W !,"Error creating DESIGNATED PROVIDER.",!,"Notify programmer.",! D EOP^BDP Q
 ;
 S BDPRIEN=+Y
 S X="`"_BDPRPRVP,DIC="^BDPRECN("_BDPRIEN_",1,",DA(1)=BDPRIEN,DIC(0)="L",DIC("P")=$P(^DD(90360.1,.06,0),U,2) D ^DIC K DIC,DA,DR,Y,X,DIADD,DLAYGO D ^XBFMK
 S BDPQ=0
 K BDPLINKI
 Q
 ;
MOD ;Modify an Existing Provider Type for this Patient
 S BDPLINKI=1
 S X="`"_BDPRPRVP,DIC="^BDPRECN("_BDPRIEN_",1,",DA(1)=BDPRIEN,DIC(0)="L",DIC("P")=$P(^DD(90360.1,.06,0),U,2) D ^DIC K DIC,DA,DR,Y,X,DIADD,DLAYGO D ^XBFMK
 S DIE="^BDPRECN(",DA=BDPRIEN,DR=".03///`"_BDPRPRVP_";.04////"_DUZ_";.05////"_DT D ^DIE,^XBFMK
 S BDPQ=0
 K BDPLINKI
 Q
 ;
 ;
DELETE ;EP Delete a Designated Provider
 ;user must set BDPPAT,BDPTYPE
 NEW BDPIEN,BDPLINKI
 S BDPLINKI=1
 ;
 ;
 S BDPIEN=$O(^BDPRECN("AA",BDPPAT,BDPTYPE,"")) ;Get Existing
 I BDPIEN="" Q  ;Quit if no Existing Record 
 ;
 S DIE="^BDPRECN(",DA=BDPIEN,DR=".03///"_"@" D ^DIE K DIE,DR,DA,DINUM
 K BDPLINKI
 Q
EOJ ; END OF JOB
 K BDPLINKI
 Q
 ;
