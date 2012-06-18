ACPT29AD ;IHS/SD/SDR - ACPT*2.09 activate/deactivate codes ; 12/21/2008 00:29
 ;;2.09;CPT FILES;;JAN 2, 2009
 ;
EN ;activate 2009 CPT codes, deactivate deleted ones
 ; input: ACPTYR = 3090000, to use as the flag value for the Date Deleted
 ; field.
 ; loop: traverse the entries for CPT codes in the CPT file (81)).
 ; For each, activate if new, inactivate if deleted.
 ;
 N ACPTDA S ACPTDA=0  ; CPT file entry #
 N ACPTDOTS  ; count, so that a dot is printed every 100 codes
 F ACPTDOTS=1:1 S ACPTDA=$O(^ICPT(ACPTDA)) Q:'ACPTDA!(ACPTDA>99999)  D
 .D ACTIV8(ACPTDA,ACPTYR)  ; activate 2009 CPTs
 .D DEACTIV8(ACPTDA,ACPTYR)  ; deact codes not in 2009 CPT delete file
 .Q:$D(ZTQUEUED)  ; if this has been queued, skip the dots
 .W:'(ACPTDOTS#100) "."  ; otherwise, write a dot for every 100 codes
 ;
 Q
 ;
 ;
ACTIV8(ACPTDA,ACPTYR) ; activate 2009 CPT codes
 ; called only by the main procedure above; only ACPTDA passed in (by
 ; value), though the major input is the corresponding CPT record;
 ; likewise the output is to the record: the Inactive Flag field (5) of
 ; the CPT record, the creation if missing of a new Effective Date
 ; subfile (60/81.02) record, and the Status field (.02) of that
 ; subrecord. The Status Field is a set of codes: 0 = INACTIVE,
 ; 1 = ACTIVE.
 ;
 N ACPTNODE S ACPTNODE=$G(^ICPT(ACPTDA,0)) ; get CPT's header node
 Q:ACPTNODE=""  ; skip bad records with no header
 ;
 N ACPTADD S ACPTADD=$P(ACPTNODE,U,6)  ; CPT's Date Added (7)
 Q:ACPTADD'=ACPTYR  ; if new, Date Added = 3090000
 ;
 N ACPTINAC S ACPTINAC=$P(ACPTNODE,U,4)  ; CPT's Inactive Flag (5)
 Q:'ACPTINAC  ; new codes also have this flag set to INACTIVE (1)
 ;
 S $P(ACPTNODE,U,4)=""  ; clear the Inactive Flag
 S $P(ACPTNODE,U,6)=3090101  ; set Date Added to a real date
 ;
 S ^ICPT(ACPTDA,0)=ACPTNODE  ; copy results back to CPT's header node
 ;
 Q
 ;
 ;
DEACTIV8(ACPTDA,ACPTYR) ; deactivate codes not in 2009 CPT
 ; called only by the main procedure above; only ACPTDA passed in (by
 ; value), though the major input is the corresponding CPT record;
 ; likewise the output is to the record: the Inactive Flag (5) and Date
 ; Deleted (8) fields of the CPT record, the creation if missing of a new 
 ; Effective Date subfile (60/81.02) record, and the Status field (.02)
 ; of that subrecord. The Status Field is a set of codes: 0 = INACTIVE,
 ; 1 = ACTIVE.
 ;
 N ACPTDEL S ACPTDEL=$P($G(^ICPT(ACPTDA,0)),U,7)  ; CPT's Date Deleted (8)
 Q:ACPTDEL'=ACPTYR  ; skip codes not deleted by this post-init
 ;
 ; otherwise, let's inactivate it:
 S $P(^ICPT(ACPTDA,0),U,4)=1  ; first, set the Inactive Flag
 S $P(^ICPT(ACPTDA,0),U,7)=3090101  ; 2nd, set Date Deleted to a real date
 ;
 ; third, let's find or add the current Effective Date (1/1/2008)
 N DA S DA(1)=ACPTDA  ; parent record, i.e., the CPT code
 N DIC S DIC="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 S DIC(0)="L"  ; allow LAYGO (Learn As You Go, i.e., add if not found)
 S DIC("P")=$P(^DD(81,60,0),"^",2)  ; subfile # & specifier codes
 N X S X="01/01/2009"  ; value to lookup in the subfile
 N DLAYGO,Y,DTOUT,DUOUT  ; other parameters for DIC
 D ^DIC  ; Fileman Lookup call
 S DA=+Y  ; save IEN of found/added record for next call below
 ;
 ; third, let's inactivate it
 N DIE S DIE="^ICPT("_DA(1)_",60,"  ; Effective Date subfile (60/81.02)
 N DR S DR=".02////0"  ; set Status field to INACTIVE
 N DIDEL,DTOUT  ; other parameters for DIE
 D ^DIE  ; Fileman Data Edit call
 ;
 Q
