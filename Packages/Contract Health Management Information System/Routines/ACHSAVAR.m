ACHSAVAR ; IHS/ITSC/PMF - SET AREA OFFICE CHS OPTIONS ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Remove non-standard error recording.
 I '$D(^ACHSAOP(DUZ(2),0)) D NOTSET("This facility does not have an entry in the 'CHS AREA OFFICE PARAMETERS' file '$D(^ACHSAOP("_DUZ(2)_",0))")
 ;
 I '$D(^ACHSAOP(DUZ(2),2)) D NOTSET("The 'CHS AREA OFFICE PARAMETERS' file node 2 has not been set. Several parameters missing '$D(^ACHSAOP("_DUZ(2)_",2))")
 I $P(^ACHSAOP(DUZ(2),2),U)="" D NOTSET("The 'EOBR IMPORT/SPLITOUT EXPORT' field of the 'CHS AREA OFFICE PARAMETERS' file must contain a directory pathname $P(^ACHSAOP("_DUZ(2)_",2),U)=NULL")
 ;
 I $P(^ACHSAOP(DUZ(2),2),U,7)="" D NOTSET("The 'EOBR ARCHIVE DIRECTORY' field of the 'CHS AREA OFFICE PARAMETERS' file must contain a directory pathname $P(^ACHSAOP("_DUZ(2)_",2),U,7)=NULL")
 ;
 I $P(^ACHSAOP(DUZ(2),2),U,13)="" D NOTSET("The 'FACILITY ARCHIVE DIR' field of the 'CHS AREA OFFICE PARAMETERS' file must contain a directory pathname $P(^ACHSAOP("_DUZ(2)_",2),U,13)=NULL")
 ;
 ;
 N ACHS,ACHSY
 S ACHSY="",ACHS=""
 F  S ACHS=$O(^DD(9002079,"GL",2,ACHS)) Q:+ACHS=0  S ACHSY=ACHSY_$P($G(^ACHSAOP(DUZ(2),2)),U,ACHS)
 Q:ACHSY]""
 ;
 ;
NOTSET(ACHSMSG) ;
 D VIDEO^ACHS
 W !!,*7,"The " W $G(IORVON) W "DENIAL" W $G(IORVOFF) W " parameters forthis site have "
 W $G(IORVON) W "not been properly set." W $G(IORVOFF)
 W !!,$$C^ACHS(ACHSMSG)
 W !!,"Print this screen to a printer."
 W *7,!!,$G(IOBON),$G(IORVON),"Contact your site manager immediately!",$G(IOBOFF),$G(IORVOFF)
 ;S ^ACHSERR($H)=ACHSMSG;SET THE MESSAGE INTO THE ERROR MESSAGE GLOBAL;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ;D CLEAN^ACHS("");CLEANUP THE ^ACHSERR ERROR MESSAGE GLOBAL;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 W !!,"Press RETURN..."
 D READ^ACHSFU
 S ACHS("NOTSET")="",ACHSXQT=1
 Q
 ;
EDIT ;EP - Edit the Area Office Parameters.
 W !,"For ",$$LOC^ACHS,":"
 N DIE,DA,DR
 S DIE="^ACHSAOP(",DA=DUZ(2),DR="[ACHS AREA PARAMETERS]"
 D ^DIE,RTRN^ACHS
 Q
 ;
