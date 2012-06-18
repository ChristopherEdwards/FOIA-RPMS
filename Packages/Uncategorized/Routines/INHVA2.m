INHVA2 ;FRW ; 6 Mar 92 18:07
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
MAP(INFUNC,INVAL,INLAYGO,INDELIM,INSYS,INDR,INDS) ;Data transform/update
 ;This function will transform a remote value to a local value.
 ;It will also update the local data files (i.e. hosp. loc., etc.), and
 ;the data element value map file (#4090.1)
 ;
 ;INPUT:
 ;  INFUNC   - mapping function (file #4090.2) (req.)
 ;              internal or external value
 ;  INVAL    - value to transform (req.)
 ;               remote record id _ delimeter _ remote record name
 ;  INLAYGO  - is laygo allowed on mapped file and value map file (opt.)
 ;                1 => allowed  ;  0 => NOT allowed (default)
 ;  INDELIM  - delimeter used to piece apart INVAL (opt.)
 ;                default = value of SUBDELIM (from GIS) or '\'
 ;  INSYS    - sending system to transform from ('VA' or 'SC') (opt.)
 ;                default comes from value of INMODE (from GIS)
 ;  INDR     - DR string to apply to newly created entries in the
 ;                target file. (optional)
 ;
 ;  INDS     - Code executed before DIC lookup to make new entry (opt)
 ;
 ;  INMODE   - indicates direction of transaction 
 ;                I => IN   ;  O => OUT
 ;  SUBDELIM - indicates delimete for data value field
 ;
 ;OUTPUT:
 ;  function value - record id ^ record name ^ new entry indicator
 ;                     or NULL if lookup failed
 ;
 ;LOCAL:
 ;  INHPOP - indicates if an error has occured (truth value)
 ;  INLOC  - local record id _ ^ _ local record name
 ;  INEWDAT - indicates if new entry was added to mapped file
 ;  INEWMAP - indicates if new entry was added to value map file (4090.1)
 ;  INDIC - indicates corresponding file # on local system for data map function
 ;
 ;*NOTE* Error handling may need to be evaluated.  If this funciton returns NULL then maybe an error should be flagged
 ;
ST ;Starting point
 Q:'$L($G(INFUNC))!'$L($G(INVAL)) ""
 N INHPOP,DIC,INLOC,INEWDAT,INEWMAP,INDIC
 ;Verify data mapping function is correct
 I INFUNC'=+INFUNC K DIC S DIC="^INVD(4090.2,",DIC(0)="X",X=INFUNC D ^DIC Q:+Y<0 "" S INFUNC=+Y
 Q:'$D(^INVD(4090.2,INFUNC,0)) ""
 ;Initialize variables
 S (INHPOP,INEWMAP,INEWDAT)=0,INLAYGO=+$G(INLAYGO),INDELIM=$S($L($G(INDELIM)):INDELIM,$L($G(SUBDELIM)):SUBDELIM,1:"\")
 ;Determine sending system
 ;*NOTE* This needs to be smarter - will only support SC in some cases
 S INSYS=$S($L($G(INSYS)):INSYS,$G(INMODE)="I":$S($$SYS^INHUTIL1="SC":"VA",1:"SC"),$G(INMODE)="O":$$SYS^INHUTIL1,1:"") Q:(INSYS'="VA")&(INSYS'="SC") ""
 ;
TR ;Transform existing data map
 S INDIC=$P($G(^INVD(4090.2,INFUNC,$S(INSYS="VA":"SC",1:"VA"))),U,1)
 S INLOC=$$TRANS^INHVA(INSYS,INFUNC,$P(INVAL,INDELIM,1),$S(INDIC'=2:$P(INVAL,INDELIM,2),1:""))
 Q:$L(INLOC) INLOC
 Q:'INLAYGO ""
 ;
 ;Only data map functions that correspond to files on the local system
 ;  will continue from here
 ;
UDAT ;Update mapped file
 K DIC S (INDIC,DIC)=$P($G(^INVD(4090.2,INFUNC,$S(INSYS="VA":"SC",1:"VA"))),U,1) Q:'INDIC "" S DIC(0)="XL",X=""""_$P(INVAL,INDELIM,2)_"""" X $G(INDS) D ^DIC Q:Y<0 "" S INLOC=$P(Y,U,1,2),INEWDAT=$P(Y,U,3)
 ;Perform edit on newly created entry
 I $G(INDR)]"" S DIE=DIC,DA=+Y,DR=INDR D ^DIE
 ;
UMAP ;Update value map file (#4090.1)
 K DIC S DIC="^INVD(4090.1,",DIC(0)="XL",X=""""_INDIC_"-"_$S(INSYS="VA":$P(INVAL,INDELIM,1),1:$P(INLOC,U,1))_"""" D ^DIC Q:+Y<0 ""
 ;Edit new entry
 S INEWMAP=$P(Y,U,3),DA=+Y,DIE=DIC,DR="[INH AUTO UPDATE ON "_$S(INSYS="VA":"SC",1:"VA")_"]" D ^DIE
 ;Check for errors during edit
 I $D(Y)#2
 ;
 ;*NOTE* Error needs to be flagged somewhere (bulletin or GIS) if:
 ;             Problems occured during edit
 ;             New entry added to mapped file but not to value map file
 ;
 ;*NOTE* Need to send bulletin to someone (postmaster)
 ;        Should inidcate if mapped file was updated (and values)
 ;        Should indicate if 4090.1 was updated (and values)
 ;        Tell user to verify many to one relationship for map function
 ;
 Q INLOC
 ;
TEST ;Test it
 R !!!,"Map function: ",INFUNC:DTIME
 Q:INFUNC=U
 R !,"Remote value (ien\name): ",INVAL:DTIME
 R !,"Laygo (1 or 0): ",INLAYGO:DTIME
 S X=$$MAP(INFUNC,INVAL,INLAYGO,"","VA")
 W !,"Function Value => ",X
 G TEST
 ;
 ;
