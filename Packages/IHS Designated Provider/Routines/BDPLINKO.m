BDPLINKO ; IHS/CMI/TMJ - LINK ROUTINE ON PARM PASS TO THE DESG PROV PKG ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
START ;Get Record Information
UPDATE(BDPFILE,BDPFIELD,BDPDA,BDPPROV,BDPPAT,BDPLINKI) ;PEP - published entry point
 ;this entry point is called from xrefs on various
 ;files/fields to update the current designated
 ;provider package
 ;called from 9002011.55, 9000001
 I $G(BDPLINKI) Q  ;don't process if coming from bdp
 I $G(BDPFILE)="" Q
 I $G(BDPFIELD)="" Q
 I $G(BDPDA)="" Q
 I $G(BDPPROV)="" Q  ;bdpprov is the pointer to file 200
 I $G(BDPPAT)="" Q
 D EN^XBNEW("UPDATE1^BDPLINKO","BDPFILE;BDPFIELD;BDPDA;BDPPROV;BDPPAT;BDPLINKI")
 Q
 ;
UPDATE1 ;
 ;special code to take care of 9000001 file 6/200 issue
 ;
 ;S BDPLINKO=1 ;Sets Variable to determine to invoke Routine BDPLO
 ;
 I BDPFILE=9000001,$P(^DD(9000001,.14,0),U,2)[6 S BDPPROV=$P(^VA(200,BDPPROV,0),U,16) I BDPPROV="" Q  ;can't process if no file 200 ptr
 S BDPTYIEN=$O(^BDPTCAT("AF",BDPFILE,BDPFIELD,0)) ;Get Type IEN
 Q:BDPTYIEN=""  ;Quit if this type is not linked
 S BDPRIEN=$O(^BDPRECN("AA",BDPPAT,BDPTYIEN,0))
 I BDPRIEN="" D ADD Q:BDPRIEN=""   ;add entry to file, quit if it failed
 ;now update multiple
 ;if the last one in the multiple by date matches the one being passed
 ;then just update the .03 field, otherwise populate the multiple
 S BDPLAST=""
 S X=0 F  S X=$O(^BDPRECN(BDPRIEN,1,X)) Q:X'=+X  S BDPLAST=$P($G(^BDPRECN(BDPRIEN,1,X,0)),U)
 I 'BDPLAST D ADDM Q  ;there are no entries in the multiple so go add one
 I BDPLAST'=BDPPROV D ADDM ;the last one doesn't match this new one so go add to multiple
 ;just update .03 since last entry in mulitple is this provider
 D ^XBFMK S DIE="^BDPRECN(",DA=BDPRIEN,DR=".03///`"_BDPPROV_";.04////"_DUZ_";.05////"_DT D ^DIE,^XBFMK
 Q
ADDM ;
 ;add to multiple of BDPRIEN using FILE^DICN
 S X="`"_BDPPROV,DIC="^BDPRECN("_BDPRIEN_",1,",DA(1)=BDPRIEN,DIC(0)="L",DIC("P")=$P(^DD(90360.1,.06,0),U,2) D ^DIC K DIC,DA,DR,Y,X,DIADD,DLAYGO
 Q
ADD ;
 D ^XBFMK K DIADD,DLAYGO
 S DIC="^BDPRECN(",DIC(0)="L",DLAYGO=90360.1,DIC("DR")=".02////"_BDPPAT,X=BDPTYIEN
 D FILE^DICN
 I Y=-1 Q
 S BDPRIEN=+Y
 D ^XBFMK K DIADD,DLAYGO
 Q
KILL(BDPFILE,BDPFIELD,BDPDA,BDPPROV,BDPPAT,BDPLINKI) ;PEP - called from kill side of xrefs
 I $G(BDPLINKI) Q  ;don't process if bdp
 I $G(BDPFILE)="" Q
 I $G(BDPFIELD)="" Q
 I $G(BDPDA)="" Q
 I $G(BDPPROV)="" Q  ;bdpprov is the pointer to file 200
 I $G(BDPPAT)="" Q
 D EN^XBNEW("KILL1^BDPLINKO","BDPFILE;BDPFIELD;BDPDA;BDPPROV;BDPPAT;BDPLINKI")
 Q
KILL1 ;EP - CALLED FROM XBNEW
 S BDPTYIEN=$O(^BDPTCAT("AF",BDPFILE,BDPFIELD,0)) ;Get Type IEN
 Q:BDPTYIEN=""  ;Quit if this type is not linked
 S BDPRIEN=$O(^BDPRECN("AA",BDPPAT,BDPTYIEN,0))
 Q:BDPRIEN=""  ;NO entry of this type for this patient
 ;now delete last current provider field
 S DIE="^BDPRECN(",DA=BDPRIEN,DR=".03///@" D ^DIE
 D ^XBFMK
 Q
