ABMDLBL1 ; IHS/ASDST/DMJ - Print Insurer Labels - PART 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
BADDR ;EP for setting Mailing Address array
 S ABM("IDFN")=$P(ABM("I"),"-",$L(ABM("I"),"-")) Q:'ABM("IDFN")
 I ABM("I")["NON-BENEFICIARY PATIENT"&($G(ABM("INS",ABM("I"),ABM("J")))) G PADDR
 Q:'$D(^AUTNINS(ABM("IDFN"),0))  S ABM("I",0)=^(0),ABM("I",1)=$G(^(1)),ABM("I",4)=$G(^(4))
 I $P(ABM("I",1),U)]"",$P(ABM("I",1),U,2)]"",$P(ABM("I",1),U,3)]"",$P(ABM("I",1),U,4)]"",$P(ABM("I",1),U,5)]""
 E  G MADDR
 S ABMCSZ=$P(ABM("I",1),"^",3,5)
 S ABM("ADD")=$P(ABM("I",1),U,1,3)_", "
 I $D(^DIC(5,$P(ABM("I",1),U,4),0)) S $P(ABM("ADD"),U,3)=$P(ABM("ADD"),U,3)_$P(^(0),U,2)_"  "_$P(ABM("I",1),U,5) Q
 E  K ABM("ADD")
 ;
MADDR ;mailing address
 S ABM("ADD")=$S($P(ABM("I",4),U)]"":ABM("I",4),1:$P(ABM("I",0),U))
 I $P(ABM("I",0),U,2)]"",$P(ABM("I",0),U,3)]"",$P(ABM("I",0),U,4)]"",$P(ABM("I",0),U,5)]"" S $P(ABM("ADD"),U,2)=$P(ABM("I",0),U,2),$P(ABM("ADD"),U,3)=$P(ABM("I",0),U,3)_", "
 E  G NO
 I $P(ABM("I",0),U,4)]"",$D(^DIC(5,$P(ABM("I",0),U,4),0)) S $P(ABM("ADD"),U,3)=$P(ABM("ADD"),U,3)_$P(^(0),U,2)_"  "_$P(ABM("I",0),U,5)
 E  G NO
 S ABMCSZ=$P(ABM("I",0),"^",3,5)
 Q
 ;
PADDR ;PATIENT ADDRESS
 S ABM("PAT")=ABM("INS",ABM("I"),ABM("J")) Q:'$D(^DPT(+ABM("PAT"),0))
 S ABM("ADD")=$P(^DPT(ABM("PAT"),0),U)
 I $D(^DPT(ABM("PAT"),.11)),$P(^(.11),U)]"",$P(^(.11),U,4)]"",$P(^(.11),U,5)]"",$P(^(.11),U,6)]"" S $P(ABM("ADD"),U,2)=$P(^(.11),U),$P(ABM("ADD"),U,3)=$P(^(.11),U,4)_", "
 E  S ABM("ADD")=ABM("ADD")_U_"*** address info incomplete ***" Q
 S ABMCSZ=$P(^DPT(ABM("PAT"),.11),"^",4,6)
 I $D(^DIC(5,$P(^DPT(ABM("PAT"),.11),U,5),0)) S $P(ABM("ADD"),U,3)=$P(ABM("ADD"),U,3)_$P(^(0),U,2)_"  "_$P(^DPT(ABM("PAT"),.11),U,6)
 E  S ABM("ADD")=ABM("ADD")_U_"*** address info incomplete ***"
 Q
 ;
NO S ABM("ADD")=$P(^AUTNINS(ABM("IDFN"),0),U)_U_"*** address info incomplete ***"
 Q
