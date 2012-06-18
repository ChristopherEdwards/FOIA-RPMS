AGGPTDEL ;VNGT/HS/ALA-Delete Patient Record ; 02 Sep 2010  1:19 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
 ;Description
 ;  This deletes a new patient who has been partially added to the system from Mini
 ;  Registration or New Patient if the user selects to cancel the addition of the
 ;  patient
 ;
EN(DATA,DFN) ;EP -- AGG PATIENT DELETE
 NEW UID,II,DA,DIK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGPTDEL",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGWDISP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT^T00080MESSAGE"_$C(30)
 S DA=DFN,DIK="^AUPNPAT(" D ^DIK
 S DA=DFN,DIK="^DPT(" D ^DIK
 S RESULT=1
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 ; Remove the export entry
 D DEL^AGGEXPRT(DFN)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
