BMCPOST ; IHS/PHXAO/TMJ - NEW INSTALLS POST ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;5.28.04 IHS/ITSC/FCJ UPDATED BY REMOVING INVALID COMMENTS
 ;        AND XREF REINDEX
 ;
START ; ENTRY POINT
 W !!,"Installing Taxonomies..." D ^BMCTX
 K ^TMP($J)
 W !!,"Installing 4 Mail Groups..." D ^BMCPOST1
 W !!,"Adding Mail Group Entries to Bulletins..." D ^BMCPOST2
 D PROV
 D VENDOR
 ;Site Parm Message
 W !!,"This is a first time install, be sure to populate the Site Paramters",!
 Q
 ;
PROV ;Message to Site Manager - Locum Tenum Physician Entry
 ;
 S DA=$O(^VA(200,"B","LOCUM,TENUM CONTRACT",""))
 I DA W !,"LOCUM,TENUM CONTRACT Entry Exists",!
 I 'DA D
 .W !,"Message to Site Manager--",!!,"Add the following new Provider",!
 .W !,"Name = LOCUM,TENUM CONTRACT"
 .W !,"Provider Class = PHYSICIAN"
 .W !,"Code = 998"
 .W !,"Affiliation = CONTRACT"
 .W !,"Initials = LTC"
 .W !!,"The Referred Care Package requires this Provider entry.",!!
 Q
 ;
VENDOR ;Message to Site Manager - UNSPECIFIED Vendor Entry
 ;
 S DA=$O(^AUTTVNDR("B","UNSPECIFIED",""))
 I DA W !,"UNSPECIFIED Vendor Entry Exists",!
 I 'DA D
 .W !,"Message to Site Manager--",!!,"Add the following new Vendor",!
 .W !,"Name = UNSPECIFIED"
 .W !,"Vendor Type = 16"
 .W !,"Mnemonic = UN"
 .W !,"EIN No. = 2999999999"
 .W !!,"The Referred Care Package requires this Vendor entry.",!!
 Q
