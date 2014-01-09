SDRPA15 ;BP-OIFO/ESW - UTILITY ; 6/9/04 8:28am
 ;;5.3;Scheduling;**376,1015**;Aug 13, 1993;Build 21
EN(ST) ;
 N SR,II,STR,SA,STE,GG,SS,SQS,ER,SB,SM,SQ
 F II=1:1 S STR=$P($T(@ST+II),";;",2) Q:+STR'=ST  D
 .S SA=$P(STR,";",2) Q:SA'="B"
 .S SB=$P(STR,";",3),SM=$P(STR,";",4) D
 ..F GG=1:1 S STE=$P($T(@ST+II+GG),";;",2) Q:+STE'=ST!($P(STE,";",2)="B")  D
 ...S ER=$P(STE,";",3) S SQS=$P(STE,";",4) F SS=1:1 S SQ=$P(SQS,",",SS) Q:SQ=""  D PR^SD376P(SB,SM,ER,SQ)
 ..;update batch acknowledgement
 ..S ER="" S SQ=$O(^SDWL(409.6,"AMSG",SM,"")) Q:SQ=""  D PR^SD376P(SB,SM,ER,SQ)
 Q
619 ;;
 ;;619;B;61934461160;61935566249
 ;;619;ER;350;1495,1996,3185,3411,
 ;;619;B;61934467364;61935570694
 ;;619;ER;350;3713,
 ;;619;B;61934475278;61935575320
 ;;619;ER;350;1233,
 ;;619;B;61934476854;61935576213
 ;;619;ER;400;1715,
 ;;619;B;61934478706;61935577448
 ;;619;ER;350;271,
 ;;619;B;61934479827;61935578142
 ;;619;ER;350;3315,
 ;;619;ER;400;190,
620 ;;
 ;;620;B;62094177662;62065197692
 ;;620;ER;350;1836,
 ;;620;B;62094207805;62065214364
 ;;620;ER;350;611,
621 ;;
 ;;621;B;62184281093;62139478336
 ;;621;ER;350;2847,
 ;;621;B;62184285387;62139480913
 ;;621;ER;350;3329,
623 ;;
 ;;623;B;62313573887;62324520029
 ;;623;ER;350;3210,
 ;;623;B;62313584324;62324534684
 ;;623;ER;350;480,
626 ;;
 ;;626;B;62641068414;626126580504
 ;;626;ER;350;3360,3549,
 ;;626;B;62641276624;626126720487
 ;;626;ER;350;1058,
 ;;626;B;62641662292;626126985971
 ;;626;ER;400;4934,
 ;;626;B;62641691414;626127005866
 ;;626;ER;400;4901,4902,
629 ;;
 ;;629;B;62921109547;62958401319
 ;;629;ER;700;203,
 ;;629;B;62921230076;62958619265
 ;;629;ER;700;203,
630 ;;
 ;;630;B;63050701981;630157174109
 ;;630;ER;350;4936,
 ;;630;B;63050913340;630157820628
 ;;630;ER;450;3028,
631 ;;
 ;;631;B;6319029561;63113225143
 ;;631;ER;350;1127,
635 ;;
 ;;635;B;63520523705;63537174321
 ;;635;ER;400;159,
 ;;635;B;63520523873;63537174702
 ;;635;ER;400;520,521,522,
 ;;635;B;63520524115;63537174943
 ;;635;ER;350;664,
 ;;635;ER;400;1452,
 ;;635;B;63520525121;63537176250
 ;;635;ER;350;1120,
 ;;635;B;63520527107;63537177775
 ;;635;ER;400;679,
 ;;635;B;63520531762;63537184107
 ;;635;ER;400;747,
 ;;635;B;63520538010;63537192878
 ;;635;ER;350;1563,
 ;;635;ER;400;790,
 ;;635;B;63520542593;63537198482
 ;;635;ER;350;2498,
 ;;635;B;63520543699;63537200310
 ;;635;ER;350;975,4219,
 ;;635;ER;400;1093,
 ;;635;B;63520544591;63537201534
 ;;635;ER;400;1213,
 ;;635;B;63520545094;63537202138
 ;;635;ER;350;1184,
 ;;635;B;63520549024;63537207961
 ;;635;ER;400;875,
 ;;635;B;63520589371;63537253180
 ;;635;ER;400;838,
 ;;635;B;63520596578;63537262680
 ;;635;ER;400;635,
 ;;635;B;63520598566;63537265274
 ;;635;ER;400;584,
636 ;;
 ;;636;B;63635193423;63662847520
 ;;636;ER;350;3571,
 ;;636;B;63635202403;63662859075
 ;;636;ER;700;581,
 ;;636;B;63635462920;63663227039
 ;;636;ER;350;3569,
 ;;636;B;63635467872;63663232717
 ;;636;ER;700;527,
 ;;636;B;63635805870;63663722429
 ;;636;ER;350;1479,
 ;;636;B;63635807214;63663724105
 ;;636;ER;450;895,
 ;;636;B;63636979130;63665361302
 ;;636;ER;350;3571,
 ;;636;B;63636983651;63665367674
 ;;636;ER;700;331,
 ;;636;B;63636986728;63665371597
 ;;636;ER;350;1668,
 ;;636;B;63636987649;63665372545
 ;;636;ER;350;1267,1317,
 ;;636;B;63637000797;63665391307
 ;;636;ER;350;1245,
 ;;636;B;63637044170;63665453294
 ;;636;ER;350;1432,
 ;;636;B;63637045723;63665455406
 ;;636;ER;350;1953,
637 ;;
 ;;637;B;63712358412;63720591588
 ;;637;ER;350;644,
640 ;;
 ;;640;B;64028032219;64071284831
 ;;640;ER;400;1947,
 ;;640;B;64028034427;64071292241
 ;;640;ER;350;3954,
 ;;640;B;64028035904;64071295525
 ;;640;ER;350;3137,
 ;;640;B;64028037495;64071297942
 ;;640;ER;350;3880,
 ;;640;B;64028040018;64071309972
 ;;640;ER;350;1058,
 ;;640;B;64028040706;64071312241
 ;;640;ER;350;4996,
 ;;640;B;64028041583;64071316787
 ;;640;ER;350;4816,
642 ;;
 ;;642;B;64219040764;64247692763
 ;;642;ER;350;3918,
 ;;642;B;64219044000;64247697805
 ;;642;ER;350;4345,
 ;;642;B;64219055644;64247719067
 ;;642;ER;350;1856,
 ;;642;B;64219064867;64247734420
 ;;642;ER;350;2019,
 ;;642;B;64219066381;64247736808
 ;;642;ER;350;1633,
 ;;642;B;64219070163;64247743950
 ;;642;ER;350;1946,
 ;;642;B;64219070384;64247744318
 ;;642;ER;350;2242,
 ;;642;B;64219071069;64247745564
 ;;642;ER;350;3850,
 ;;642;B;64219071155;64247745706
 ;;642;ER;350;1505,2788,4683,
 ;;642;B;64219071235;64247745877
 ;;642;ER;350;3030,
 ;;642;B;64219071531;64247746887
 ;;642;ER;350;1791,
 ;;642;B;64219071792;64247747601
 ;;642;ER;350;300,3686,
 ;;642;B;64219073896;64247756907
 ;;642;ER;700;1011,
644 ;;
 ;;644;B;64431818656;64446027218
 ;;644;ER;350;2278,
 ;;644;B;64431874728;64446084905
 ;;644;ER;350;2167,
 ;;644;B;64431889209;64446101223
 ;;644;ER;350;4004,
 ;;644;B;64431896874;64446108951
 ;;644;ER;350;3130,
 ;;644;B;64431904135;64446116323
 ;;644;ER;350;2433,
 ;;644;B;64431978829;64446192826
 ;;644;ER;200;31,163,412,
 ;;644;B;64431980821;64446195496
 ;;644;ER;200;643,727,734,1250,1386,1760,1905,2107,2244,2598,2676,3513,3538,3552,3823,3945,4733,
 ;;644;B;64431989436;64446203597
 ;;644;ER;200;33,
 ;;644;B;64431992122;64446205828
 ;;644;ER;200;386,453,557,689,755,798,803,982,1030,1440,1605,1788,1885,2290,2393,3004,3787,3790,4628,
 ;;644;B;64431993591;64446207840
 ;;644;ER;200;65,353,354,388,499,656,1151,1198,1365,1835,1840,2382,2620,
 ;;644;B;64431994207;64446208461
 ;;644;ER;200;2279,2589,2894,2991,3450,3894,4064,
 ;;644;B;64432000557;64446214187
 ;;644;ER;200;235,939,972,1005,1056,1125,1162,1589,1624,1942,1954,2071,2351,2439,2482,
 ;;644;B;64432001163;64446214612
 ;;644;ER;200;589,804,1007,1355,1424,
646 ;;
 ;;646;B;64622152067;64636125592
 ;;646;ER;350;3641,
 ;;646;B;64622172061;64636149373
 ;;646;ER;350;2807,
 ;;646;B;64622177731;64636158072
 ;;646;ER;350;2913,
 ;;646;B;64622182360;64636165439
 ;;646;ER;350;2350,
 ;;646;B;64622182634;64636165816
 ;;646;ER;350;1713,
648 ;;
 ;;648;B;64830169503;64859420738
 ;;648;ER;350;3226,
 ;;648;B;64830173491;64859426791
 ;;648;ER;350;559,
 ;;648;B;64830176032;64859430610
 ;;648;ER;350;3576,
 ;;648;B;64830176493;64859431425
 ;;648;ER;350;4437,
 ;;648;B;64830181488;64859439943
 ;;648;ER;200;201,2116,4485,
650 ;;
 ;;650;B;65013317751;65024393176
 ;;650;ER;350;1964,
652 ;;
 ;;652;B;65211886530;65213575232
 ;;652;ER;350;618,
 ;;652;B;65211887675;65213578292
 ;;652;ER;350;3143,
 ;;652;B;65211888822;65213581189
 ;;652;ER;350;1029,
 ;;652;B;65211914787;65213619795
 ;;652;ER;350;525,
654 ;;
 ;;654;B;65413112674;65419363257
 ;;654;ER;350;3301,4157,
 ;;654;B;65413223658;65419507467
 ;;654;ER;350;2008,2759,3776,
655 ;;
 ;;655;B;65516549087;65520295193
 ;;655;ER;350;3324,
657 ;;
 ;;657;B;65729884244;65764668755
 ;;657;ER;700;4874,
 ;;657;B;65729887352;65764672552
 ;;657;ER;350;4759,
 ;;657;B;65729928496;65764736980
 ;;657;ER;700;725,
 ;;657;B;65729931738;65764743255
 ;;657;ER;700;4571,4782,
658 ;;
 ;;658;B;65814078326;65822477724
 ;;658;ER;350;639,
 ;;658;B;65814085475;65822487961
 ;;658;ER;350;3798,
 ;;658;B;65814091130;65822495944
 ;;658;ER;350;3614,
 ;;658;B;65814093437;65822499879
 ;;658;ER;350;4423,
 ;;658;B;65814093863;65822500443
 ;;658;ER;350;3272,
 ;;658;B;65814093973;65822500660
 ;;658;ER;350;4009,
 ;;658;B;65814094754;65822504108
 ;;658;ER;350;3727,
 ;;658;B;65814094883;65822504172
 ;;658;ER;350;4794,
659 ;;
 ;;659;B;65921670759;65928910087
 ;;659;ER;350;2755,
 ;;659;B;65921671754;65928911209
 ;;659;ER;350;3033,
 ;;659;B;65921672431;65928911663
 ;;659;ER;350;1453,
 ;;659;B;65921687821;65928931958
 ;;659;ER;350;3395,
 ;;659;B;65921746315;65929005443
 ;;659;ER;350;4798,
 ;;659;B;65921748734;65929009131
 ;;659;ER;400;4948,
660 ;;
 ;;660;B;6608026700;66033848678
 ;;660;ER;350;4353,
 ;;660;ER;700;34,
662 ;;
 ;;662;B;66220042896;66219570876
 ;;662;ER;400;556,642,643,644,
 ;;662;B;66220043286;66219571232
 ;;662;ER;400;653,654,655,
 ;;662;B;66220043544;66219571400
 ;;662;ER;400;699,813,814,815,816,817,
 ;;662;B;66220043608;66219571476
 ;;662;ER;400;779,780,
 ;;662;B;66220043997;66219571735
 ;;662;ER;400;743,
 ;;662;B;66220044158;66219571900
 ;;662;ER;400;744,745,
 ;;662;B;66220044918;66219572474
 ;;662;ER;350;3643,
 ;;662;B;66220045352;66219572827
 ;;662;ER;400;923,
 ;;662;B;66220045649;66219573166
 ;;662;ER;400;975,
 ;;662;B;66220049393;66219576633
 ;;662;ER;350;4777,4778,
 ;;662;B;66220049792;66219577884
 ;;662;ER;350;4175,
 ;;662;ER;400;651,652,
 ;;662;B;66220050273;66219579204
 ;;662;ER;350;3735,
 ;;662;B;66220076364;66219608607
 ;;662;ER;350;4527,
 ;;662;B;66220084134;66219618992
 ;;662;ER;350;3875,
 ;;662;B;66220096015;66219631665
 ;;662;ER;350;4527,4584,
 ;;662;ER;400;740,
663 ;;
 ;;663;B;66335145156;66354303336
 ;;663;ER;350;553,
 ;;663;B;66335183905;66354349535
 ;;663;ER;350;553,
 ;;663;B;66335202779;66354372618
 ;;663;ER;350;225,
 ;;663;B;66335218249;66354391533
 ;;663;ER;350;1802,