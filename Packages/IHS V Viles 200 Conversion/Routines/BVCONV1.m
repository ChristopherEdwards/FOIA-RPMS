BVCONV1 ; IHS/ITSC/JDH - PCC CONVERSION PROCESS; [ 12/06/2002  10:05 AM ]
 ;;2.0;IHS V FILES 200 CONVERSION;;MAR 29, 2002
 W !!,"Use PRECMP^BVCONV to call this routine." Q
 ;
EN ; EP PCC conversion routine
 N X,BVCERR,POP,BVCEXP,BVCPRNM
 S BVCQ=$D(^BVCONV(1,"VARS"))
 S X=$ST($ST-1,"PLACE")
 I 'BVCQ,X'["O+3^BVCONV" W !,"This routine must be called from the interface",!,"aborting" Q  ;caller must be from the interface
 S X=$ST($ST-1,"MCODE")
 I 'BVCQ,X'["D EN^BVCONV1 ; run the conversion" W !,"This routine must be called from the interface",!,"aborting" Q  ; caller must be this
 D INIT
 D CONV ; convert
 ; set PCC Conversion flag in ^AUTTSITE
 D:'BVCERR!BVCPRCP POST
 Q
 Q
 ;
CONV ; convert PCC files to use file 200 vs 6 pointer.    
 N X
 S X=$ST($ST-1,"PLACE")
 I 'BVCQ,'BVCERR,X'["EN+8^BVCONV1" W !,"this is not a valid entry point",!,"aborting" Q  ;caller must be from tag EN
 S X=$ST($ST-1,"MCODE")
 I 'BVCQ,'BVCERR,X'["D CONV ;" W !,"this is not a valid entry point",!,"aborting" Q  ;convert" ; caller must be this   ;TASSC/MFD changed X'= to X'[ to allow functioning with Cache
 ;
 N BVCLPCT,BVCNUMB,BVCDA,BVCFLD,BVCP6,BVCPRNM,BVCP200,BVCNPNM,DA,DR,BVC
 S BVC=1 ; required for the input transform of field .01 of file 9000010.06
 S BVCNUMB=90000,X="ERR^BVCONV1",@^%ZOSF("TRAP")
 ;S BVCNUMB=9000010.08 ; TEST
 F  S BVCNUMB=$O(BVCONV(BVCNUMB)) Q:'BVCNUMB  S BVCREC=BVCONV(BVCNUMB) D
 .W !!,$S(BVCPRCP:"Checking",1:"Converting")_" file: "_BVCNUMB,!!
 .S X=$P($G(^BVCONV1(BVCPRCP,BVCNUMB)),U,4,6)
 .S BVCNUCT=+$P(X,U,2),BVCCVCT=+X,BVCGNCT=+$P(X,U,3) ;zero field counts
 .S X=$G(^BVCONV1(BVCPRCP,BVCNUMB)) Q:X  ;file is already converted
 .S $P(^BVCONV1(BVCPRCP,BVCNUMB),U,3)=$H
 .S BVCDA=+$P(X,U,2) ; starting record number
 .S BVCROOT="^"_$P(BVCREC,U),BVCELMS=$P(BVCREC,U,2,99)
 .I '$D(@$P(BVCROOT,"(")) Q
 .; loop through target file
 .F BVCLPCT=1:1 S BVCDA=$O(@(BVCROOT_BVCDA_")")) Q:'BVCDA  D
 ..;
 ..W:'(BVCLPCT#500) "."
 .. I 'BVCPRCP,'BVCLPCT#1000,$D(^%ZTSCH("RUN")) D
 ...S BVCP6=0 D ERROR("TASKMAN RE-SUTDOWN") D SMAN^ZTMKU,SSUB^ZTMKU ; keep Takman down
 ..S DA=BVCDA,DR=""
 ..I '$D(@(BVCROOT_BVCDA_",0)")) Q
 ..; get file elements to convert
 ..F BVCI=1:1 S BVCELM=$P(BVCELMS,U,BVCI) Q:'$L(BVCELM)  D
 ...; create parse string. This may eliminate processing steps
 ...S BVCNODE=BVCROOT_BVCDA_","_$P(BVCELM,";",3)_")",BVCPCE=$P(BVCELM,";",4)
 ...S BVCDATA=$G(@BVCNODE),BVCP6=$P(BVCDATA,U,BVCPCE) ; file 6 pointer
 ...I 'BVCP6 D  Q  ; no entry. no conversion needed
 ....S BVCNUCT=BVCNUCT+1
 ...;get name for comparison. 
 ...S BVCFLD=$P(BVCELM,";",2)
 ...S BVCCVCT=BVCCVCT+1,BVCP200=$$RESOLVE(BVCP6) ;get current field value and 200 ptr
 ...Q:'BVCP200  ; no file 200 pointer, no conversion - THIS SHOULD NEVER BE
 ...Q:BVCPRCP  ; cheking compile only - do not change databAse.
 ...;I BVCELM S $P(@BVCNODE,U,BVCPCE)=BVCP200 ; set directly
 ...;E  D  ; set through fileman
 ...S DR=DR_$E(";",DR>0)_BVCFLD_$S(BVCFLD'=.01:"////",1:"///`")_BVCP200
 ..; record last ien used
 ..I DR S DIE=BVCNUMB D ^DIE I $D(Y) S BVCP200=BVCP6,(BVCPRNM,BVCNPNM)=$P($G(^DIC(16,+BVCP6,0)),U) D ERROR("NO CHANGE INPUT XFRM ERROR")
 ..;
 ..; record status
 ..S $P(^BVCONV1(BVCPRCP,BVCNUMB),U,2)=BVCDA
 ..S $P(^BVCONV1(BVCPRCP,BVCNUMB),U,4,6)=BVCCVCT_U_BVCNUCT_U_BVCGNCT
 .; record completion of file
 .S $P(^BVCONV1(BVCPRCP,BVCNUMB),U,1)=$H
 Q
 ;
RESOLVE(BVCP6) ; convert from a file 6 to 200 pointer
 ; the navigations from file 2 to 200 must exit
 ; this tag verifies a file 200 entry is used
 K BVCPRNM
 S BVCFLG=0 ;use default flag 0 = NO 1 = YES
 S BVCFLG1=1 ; do the checks
 ; defaults
 S BVCP200=BVCDFDC
 S BVCNPNM=BVCDFNM
 ;
 ; do not reprocess
 S X=$G(^BVCONV(1,"CONV",BVCP6)) D:X
 .S BVCP200=+X
 .S BVCNPNM=$P(X,U,2)
 .S BVCEXP=$P(X,U,3)
 .S BVCFLG1=0
 .I $L(BVCEXP) D ERROR(BVCEXP) S BVCFLG=1
 ;
 I BVCFLG1 D
 .S BVCPTR=$G(^DIC(16,+BVCP6,"A3"))
 .I 'BVCPTR D
 ..D ERROR("No A16 XREF & A3 node") S BVCFLG=1
 .E  D
 ..S BVCPRNM=$P($G(^DIC(16,+BVCP6,0)),U)
 ..S BVCNP=$P($G(^VA(200,+BVCPTR,0)),U)
 ..I '$L(BVCNP) D ERROR("No file 200 entry") S BVCFLG=1 Q
 ..I '$D(^VA(200,"AK.PROVIDER",BVCNP,BVCPTR)) D ERROR("No AK.PROVIDER xref") S BVCFLG=1 ; no provider key or xref
 ..I BVCPRCP,BVCPRNM'=BVCNP D ERROR("Not same provider names") S BVCFLG=1
 ..S:'BVCFLG BVCP200=BVCPTR,BVCNPNM=BVCNP ; ok to use provider (not default)
 S:BVCFLG BVCGNCT=BVCGNCT+1 ;default use count
 S:BVCFLG1 $P(^BVCONV(1,"CONV",BVCP6),U,1,2)=BVCP200_U_$G(BVCPRNM)
 Q BVCP200 ; use resolved pointer or user defined default
 ;
ERROR(BVCERTP) ; record an error
 N DIC,DLAYGO,X,DD,DO,BVCORIG
 S:BVCFLG1 $P(^BVCONV(1,"CONV",BVCP6),U,3)=BVCERTP
 S BVCORIG=+$G(^DIC(16,+BVCP6,"A3"))
 S DIC="^BVC(90098,",DIC(0)="L",DLAYGO=9003102,X=BVCERTP
 S DIC("DR")=".02////"_+$G(BVCNUMB)_";.03////"_+$G(BVCDA)_";.04////"_+$G(BVCFLD)_";.05////"_+$G(BVCP6)_";.06////"_$S($L($G(BVCPRNM)):BVCPRNM,1:"NOT AVAILABLE")
 S DIC("DR")=DIC("DR")_";.07////"_$G(BVCP200)_";.08////"_$S($L($G(BVCNPNM)):BVCNPNM,1:"NOT AVAILABLE")_";.09////"_$$HTE^XLFDT($H)_";1////"_BVCORIG D FILE^DICN
 Q
 ;
ERR ; record an error
 N X S BVCERR=BVCERR+1
 S X=$$EC^%ZOSV
 W !!,"An error has occured",!,X,!,"Aborting the conversion",!!
 D ERROR(X) ;error
 I BVCPRCP,BVCERR<11 G CONV
 D ^%ZTER
 D XMD^BVCONV(0) ; email abort message
 Q
 ;
INIT ; initialize VARIABLES
 N BVCSTRT
 S BVCERR=0
 ; get variables from ^BVCONV
 S I="" F  S I=$O(^BVCONV(1,"VARS",I)) Q:I=""  S @I=^(I) ; get variables from BVCONV routine
 I BVCQ D  ; reset device variables in jobbed process. IOP defined in ^BVCONV(1,"VARS",
 .S ZTQUEUED=1
 .D ^XBKVAR
 .N %ZIS S:IOT="HFS" %ZIS("IOPAR")=IOPAR
 .S %ZIS=0 D ^%ZIS
 U IO W:$E(IOST,1,2)'="C-"!(ION="HFS") !!,"The conversion "_$S(BVCPRCP:"check ",1:"")_"started "_$$HTE^XLFDT($H)
 S ^BVCONV1(BVCPRCP,0)="PCC file conversion "_$S(BVCPRCP:"check ",1:"")_"to use file 200 vs. 6 pointers"
 S BVCERR=0
 D ELEMLST^BVCONV(1) ; setup conversion table
 S BVCSTRT=$P($G(^BVCONV1(BVCPRCP,"RUN TIMES")),U)
 I 'BVCSTRT D
 .N DIK,DA,BVCERCT
 .W !,"Deleting FILE 200 ERROR FILE entries."
 .S BVCERCT=$O(^BVC(90098,"A"),-1) F DA=1:1:BVCERCT W:'(DA#100) "." S DIK="^BVC(90098," D ^DIK
 .S ^BVCONV1(BVCPRCP,"RUN TIMES")=$H
 ;default name
 S BVCDFNM=$P($G(^VA(200,BVCDFDC,0)),U)
 Q
 ;
POST ; execute after conversion
 N BVCCVTM
 S $P(^BVCONV1(BVCPRCP,"RUN TIMES"),U,2)=$H
 S X=^BVCONV1(BVCPRCP,"RUN TIMES") S BVCCVTM=$$HDIFF^XLFDT($P(X,U,2),$P(X,U),2)
 I BVCPRCP D
 .S BVCCVTM=$J(BVCCVTM*5.5/3600,3,2)
 .W !!,"The PCC conversion will take approximately "_BVCCVTM_" hours."
 .D XMD^BVCONV(2,BVCCVTM) ; email of check completion
 .K ^BVCONV(1)
 E  D
 .S $P(^AUTTSITE(1,0),U,22)=1 ; FM is not used here because the uneditable field may be valued
 .; send message of completion
 .S BVCCVTM=$J(BVCCVTM/3600,3,2)
 .D XMD^BVCONV(1,BVCCVTM) ; email completion message
 .W !,"Converting Q-MAN to use file 200 vs 6"
 .W !,"Q-MAN is "_$S($$AMQQ200:"",1:"NOT ")_"converted"
 .W !!,"The conversion completed "_$$HTE^XLFDT($H)
 .W !!,"The conversion ran for "_BVCCVTM_" hours."
 .W !!,"Deleteing conversion routines.",!! D DELETE^BVCONV ; delete conversion routines
 .;  kill pcc run 
 .K ^BVCONV(1),^BVCHK(1)
 D ^%ZISC
 Q
 ;
AMQQ200() ; convert Q-man
 N BVCFLG S BVCFLG=0
 I ^AMQQ(1,203,4,1,1)["^DIC(16," D  ; ok to convert
 .D META^AMQQ200,DIE^AMQQ200 S BVCFLG=1
 Q BVCFLG
 ;
