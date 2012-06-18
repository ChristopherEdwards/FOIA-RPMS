ACHSSTL ; IHS/ITSC/PMF - CHS FACILITY PARAMETER SET UP;    [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Fix index to prevent overwrite of print Q for other facilities.
 D VIDEO^ACHS
 S ACHSDUZ2=""
 W @IOF,$G(IORVON),!,$$REPEAT^XLFSTR("*",78)
 W !,"*",?77,"*",!
 W "*",?30,"CONTRACT HEALTH SYSTEM",?77,"*",!
 W "*",?31,"FACILITY PARAMETER SET UP",?77,"*",!
 W "*",?77,"*",!,$$REPEAT^XLFSTR("*",78),$G(IORVOFF),!!
 S Y=$$DIR^XBDIR("PO^4:AEMQ","What Facility's Parameters Will You Be Entering")
 G:(Y<1)!$D(DTOUT)!$D(DUOUT) END
 S ACHSDUZ2=+Y
 ;
 S Y=$$DIR^XBDIR("YO","Is This Facility a 638 Facility","","","","",2)
 G:Y=""!$D(DTOUT)!$D(DUOUT) END
 I Y=1 S ACHS638=""
 I Y=0 K ACHS638
 ;
 D LIST I STOP D END Q
 ;
 D STDPAR
 D ^ACHSSTL1,^ACHSSTL2
 D SIG,DATA,FI
 D INDEX,END
 ;
 ;
 W !!!!!,"Install Complete!!",!!
 Q
LIST ;
 W @IOF
 W !,$$REPEAT^XLFSTR("*",78)
 W !!,"You should know the following items before installing CHS",!
 W !,"Check With The CHS Department For The Information If You Don't Have It ",!
 W !,"1.  CHS Mailing Address (Street,City,State,Zip)"
 W !,"2.  The Start Date Of Your Fiscal Year If Not Oct 1 (638 Facilities Only)"
 W !,"3.  CHS Common Accounting Numbers And The Cost Center(s) For Each"
 W !,"4.  Values For Allowable Overpayment For Each Document Type"
 W !,"5.  Normal Amount That Each Document Can Be Issued For"
 W !,"6.  Absolute Maximum That Document Can Be Issued For"
 W !,"7.  Name(s) and Title(s) Of Person(s) Who Will Sign Documents"
 W !,"8.  Name and Address Of Fiscal Intermediary",!,"    (If Other Than Blue Cross/Blue Shield of New Mexico)"
 W !,"9.  Current Advice Of Allowance"
 W !,"10. List of High Volume Providers That Will Be Participating In That Program",!
 W $$REPEAT^XLFSTR("*",78),!
 S STOP='$$DIR^XBDIR("E")
 Q
 ;
STDPAR ;
 I $D(^ACHSF(ACHSDUZ2,2)) Q
 W !,$$C^XBFUNC("Installing standard parameters...")
 ;
 S ^ACHSF(ACHSDUZ2,2)="^N^N^Y^Y^N^Y^Y^Y^N^Y^Y^N^N^N^N^N^N^P^N^1^N^N^N^N^N"
 S ^ACHSF(ACHSDUZ2,0)=ACHSDUZ2_"^^^^^1001^1^N^N^^^"
 I $D(ACHS638) D
 . S $P(^ACHSF(ACHSDUZ2,0),U,8)="Y"
 . S Y=$$DIR^XBDIR("Y","Do You Wish To Edit The Fiscal Year Start Date (DEFAULT=OCT 1)","","","","",1)
 . Q:'Y
 . S DIE="^ACHSF(",DA=ACHSDUZ2,DR="11.01;11.02"
 . D ^DIE
 . Q
 ;
 S ACHSFY=$E(DT,1,3)
 I $P(^ACHSF(ACHSDUZ2,0),U,6)<$E(DT,4,7) S ACHSFY=ACHSFY+1
 S ACHSFY=ACHSFY+1700
 Q
 ;
SIG ;
 I $D(^ACHSF(ACHSDUZ2,"P")) Q
 W !!,"Enter Name and Title Of Person Signing Documents...",!!
 S DIE="^ACHSF(",DA=+ACHSDUZ2,DR="50;51;52"
 D ^DIE
 Q
 ;
DATA ;
 I $D(^ACHS(9,ACHSDUZ2)) Q
 W !,$$C^XBFUNC("Installing 'CHS DATA CONTROL FILE'...")
 S:'$D(^ACHS(9,0)) ^(0)="CHS DATA CONTROL^9002069P"
 S:'$D(^ACHS(9,ACHSDUZ2,0)) ^(0)=ACHSDUZ2_"^^1^1"
 S:'$D(^ACHS(9,ACHSDUZ2,"FY",0)) ^(0)="^9002069.01^"_ACHSFY_"^1"
 S:'$D(^ACHS(9,ACHSDUZ2,"FY",ACHSFY,0)) ^(0)=ACHSFY_"^0^0"
 S:'$D(^ACHS(9,ACHSDUZ2,"FY",ACHSFY,1)) ^(1)="0^0^0^0^0^0^0"
 S:'$D(^ACHS(9,ACHSDUZ2,"FY",ACHSFY,"C")) ^("C")=0
 S:'$D(^ACHS(9,ACHSDUZ2,"FY",ACHSFY,"W",0)) ^(0)="^9002069.02A^1^1"
 S:'$D(^ACHS(9,ACHSDUZ2,"FY",ACHSFY,"W",1,0)) ^ACHS(9,ACHSDUZ2,"FY",ACHSFY,"W",1,0)=1
 S:'$D(^ACHS(9,ACHSDUZ2,"FY",ACHSFY,"W",1,1)) ^ACHS(9,ACHSDUZ2,"FY",ACHSFY,"W",1,1)="0^0^0^0^0^0^0"
 S:'$D(^ACHS(9,ACHSDUZ2,"RN")) ^("RN")="HOSPITAL CARE^E.R. ROOM^PHYS INPATIENT^PHYS OUTPATIENT^DENTAL CARE^P&E TRAVEL^OTHER"
 Q
 ;
FI ; Set FI address.
 I $D(^ACHS(4,1,0)) Q
 W !,$$C^XBFUNC("Installing 'FISCAL AGENT' address...")
 S ^ACHS(4,1,0)="BLUE CROSS & BLUE SHIELD OF NM^P. O. BOX 13509^ALBUQUERQUE^35^87192-3509"
 ;
 Q
 ;
INDEX ; Index files just installed.
 W !,$$C^XBFUNC("Re-indexing all files just installed...")
 K DIK
 F ACHS=2,4,7,9 S DIK="^ACHS("_ACHS_"," W !,$$C^XBFUNC(DIK) D IXALL^DIK
 ;K DIK;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ;S DIK="^ACHSF(";IHS/SET/GTH ACHS*3.1*5 12/06/2002
 K DIK,DA ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 S DIK="^ACHSF(",DA=ACHSDUZ2 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 W !,$$C^XBFUNC(DIK)
 ;D IXALL^DIK;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 D IX1^DIK ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 Q
END ;
 K ACHS638,ACHSC,ACHSFY,ACHSI,ACHSK,ACHSO,ACHSSITE,ACHSZ,DA,DIC,DIE,DIK,DIR,DR
 Q
 ;
