INHVA ;FRW ; 22 Jul 91 11:09; Misc. utilities for SAIC-Care/VA interfacing
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
IDXREF(INSYS,INDA,INKILL,INFUNC,INRECID) ;Update record ID x-ref on file #4090.1
 ;Called from DD of file #4090.1
 ;INPUT:
 ;  INSYS - system ('VA' or 'SC') (req.)
 ;  INDA - entry in file #4090.1 (ien) (req.)
 ;  INKILL - flag to indicate if x-ref is being set or killed (opt.)
 ;              1 => kill x-ref ; 0 => set x-ref (default)
 ;  INFUNC - mapping function (ien)  (opt.)
 ;  INRECID - appropriate record id
 ;
 S INSYS=$G(INSYS),INKILL=$G(INKILL),INFUNC=$G(INFUNC),INRECID=$G(INRECID) Q:'$G(INDA)!(INSYS'="SC"&(INSYS'="VA"))
 S:'$L(INFUNC) INFUNC=$P($G(^INVD(4090.1,INDA,0)),U,2) S:'$L(INRECID) INRECID=$E($S(INSYS="SC":$G(^(1)),1:$G(^(10))),1,100)
 Q:('$L(INFUNC)!'$L(INRECID))
 I 'INKILL S ^INVD(4090.1,INSYS,INFUNC,INRECID,INDA)=""
 E  K ^INVD(4090.1,INSYS,INFUNC,INRECID,INDA)
 Q
 ;
TRANS(INSYS,INFUNC,INRECID,INRECNA) ;Transform from one system to another
 ;INPUT:
 ;  INSYS - sending system to transform from ('VA' or 'SC')  (req.)
 ;            i.e. 'VA' implies transform VA value to SAIC-Care value
 ;  INFUNC - mapping function from file #4090.2 (internmal or external)  (req.)
 ;  INRECID - record ID  (req.)
 ;  INRECNA - record name  (opt.)
 ;
 ;OUTPUT:
 ;  function value - data element value (ien) ^ translated record ID
 ;                    or NULL if look-up failed
 ;
 S INSYS=$G(INSYS),INFUNC=$G(INFUNC),INRECID=$G(INRECID),INRECNA=$G(INRECNA) Q:'$L(INFUNC)!'$L(INRECID)!(INSYS'="SC"&(INSYS'="VA")) ""
 N INNOID,INNONA,INNOTRNA,INNOEX,INDA,INID,POP,DIC
 ;Get ien of Map Function
 I INFUNC'=+INFUNC S DIC="^INVD(4090.2,",DIC(0)="MNX",X=INFUNC D ^DIC Q:Y<0 "" S INFUNC=+Y
 ;Determine appropriate nodes in file
 S INNOID=$S(INSYS="SC":1,1:10),INNONA=INNOID+1,INNOEX=$S(INSYS="SC":12,1:3),INNOTRID=$S(INSYS="SC":10,1:1),INID=$E(INRECID,1,100),INNOTRNA=INNOTRID+1
 ;Loop thru appropriate x-ref
 S INDA="",POP=0 F  S INDA=$O(^INVD(4090.1,INSYS,INFUNC,INID,INDA)) Q:'INDA  S POP=1 D  Q:POP
 .;Verify NOT excluded
 .I $P($G(^INVD(4090.1,INDA,INNOEX)),U,1) S POP=0 Q
 .;Verify full record ID matches
 .I INRECID'=$G(^INVD(4090.1,INDA,INNOID)) S POP=0 Q
 .;Verify record name matches (if present)
 .I $L(INRECNA),INRECNA'=$G(^INVD(4090.1,INDA,INNONA)) S POP=0 Q
 ;Construct exit value
 I INDA S INDA=$G(^INVD(4090.1,INDA,INNOTRID))_U_$G(^INVD(4090.1,INDA,INNOTRNA))
 Q INDA
 ;
